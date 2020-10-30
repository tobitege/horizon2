--@class AltitudeHoldModule
--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require ReadingsModule

AltitudeHoldModule = (function() 
    local this = HorizonModule("Altitude Hold", "When enabled a consistent altitude is maintained", "PostFlush", false)
    this.Tags = "thrust,altitude"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    
    this.Config.HoldAltitude = 100
    this.Config.MaxDelta = 0.5
    this.Config.MaxVelocity = 1

    local function sign(value)
        if value >= 0 then return 1 else return -1 end
    end

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship

        local altitudeDelta = ship.Altitude:len() - this.Config.HoldAltitude

        if math.abs(altitudeDelta) > this.Config.MaxDelta then
            local deltaThrust = sign(altitudeDelta) * world.Gravity
            dship.Thrust = dship.Thrust + deltaThrust
        end

    end

    function this.Enable()
        local ship = Horizon.Memory.Static.Ship
        this.Config.HoldAltitude = ship.Altitude
        this.Enabled = true
    end

    return this
end)()