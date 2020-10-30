--@class LandingModule
--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require KeybindsModule
--@require ReadingsModule

LandingModule = (function() 
    local this = HorizonModule("Landing Gear", "Allows manual or automatic landing gear activation. Also includes a soft landing function", "PostFlush", true)
    this.Config = {
        SpeedLimit = 20, -- in m/s
        DistanceLimit = 10,
        SoftLandSpeed = 0.5,
        SoftLandTimeout = 10,
        Version = "%GIT_FILE_LAST_COMMIT%"
    }

    this.SoftLandEnabled = false

    function this.Update(eventType, deltaTime)
        local slots = Horizon.Memory.Slots
        local world = Horizon.Memory.Static.World
        local dShip = Horizon.Memory.Dynamic.Ship


        if Horizon.Controller.isAnyLandingGearExtended() == 1 then
            --Landing gear is extended
            
            if world.Velocity:len() >= this.Config.SpeedLimit then
                --Overspeed, retract
                Horizon.Controller.retractLandingGears()
                return
            end

            --Check if we are close enough to the ground
            if (#slots.Telemeters > 0) then

                for i,v in ipairs(slots.Telemeters) do
                    if v.getDistance() > this.Config.DistanceLimit then
                        Horizon.Controller.retractLandingGears()
                        return
                    end
                end

            end

        else
            --Landing gear is retracted

            if world.Velocity:len() < this.Config.SpeedLimit then
                if (#slots.Telemeters > 0) then
                    for i,v in ipairs(slots.Telemeters) do
                        if v.getDistance() <= this.Config.DistanceLimit then
                            Horizon.Controller.extendLandingGears()
                            return
                        end
                    end
                end
            end

        end

        if this.SoftLandEnabled then
            local deltaV = world.Gravity:normalize()*this.Config.SoftLandSpeed
            dShip.Thrust = dShip.Thrust + deltaV
        end

    end

    function this.ToggleGear()
        if Horizon.Controller.isAnyLandingGearExtended() then
            Horizon.Controller.retractLandingGears()
        else
            Horizon.Controller.extendLandingGears()
        end
    end


    function this.ToggleSoftland()
        if this.SoftLandEnabled then this.DisableSoftland() else this.EnableSoftland() end
    end
    function this.EnableSoftland()
        system.print("Soft Land Enabled")
        this.SoftLandEnabled = true
    end
    function this.DisableSoftland()
        system.print("Soft Land Disabled")
        this.SoftLandEnabled = false
    end

    return this
end)()