LandingModule = (function() 
    local this = HorizonModule("Landing", "PostFlush", true)
    this.Config = {
        SpeedLimit = 20, -- in m/s
        DistanceLimit = 10
    }

    function this.Update(eventType, deltaTime)
        local slots = Horizon.Memory.Slots
        local world = Horizon.Memory.Static.World
        
        if world.Velocity:len() < this.Config.SpeedLimit then
            for i,v in ipairs(slots.Telemeters) do
                if v.getDistance() <= this.Config.DistanceLimit and Horizon.Controller.isAnyLandingGearExtended() == 0 then
                    Horizon.Controller.extendLandingGears()
                    return
                end
                if v.getDistance() > this.Config.DistanceLimit and Horizon.Controller.isAnyLandingGearExtended() == 1 then
                    Horizon.Controller.retractLandingGears()
                    return
                end    
            end
        else
            if Horizon.Controller.isAnyLandingGearExtended() == 1 then Horizon.Controller.retractLandingGears() end
        end
    end

    function this.ToggleGear()
        if Horizon.Controller.isAnyLandingGearExtended() then
            Horizon.Controller.retractLandingGears()
        else
            Horizon.Controller.extendLandingGears()
        end
    end

    return this
end)()
Horizon.RegisterModule(LandingModule)