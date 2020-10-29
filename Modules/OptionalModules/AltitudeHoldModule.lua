--@class AltitudeHoldModule
--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require ReadingsModule

AltitudeHoldModule = (function() 
    local this = HorizonModule("Altitude Hold", "When enabled a consistent altitude is maintained", "PostFlush", false, 4)
    this.Tags = "thrust,altitude"
    this.Config.HoldAltitude = 5000
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship

        local currVertical = world.Vertical:dot(world.Velocity + world.Acceleration)
        local altitudeDelta = (ship.Altitude - currVertical) - this.Config.HoldAltitude
        local verticalThrust = world.Vertical:dot(dship.Thrust)
        local target = (world.Vertical * (altitudeDelta * 100))
        dship.Thrust = dship.Thrust + target
        system.print(tostring(verticalThrust))
    end

    function this.Enable()
        local ship = Horizon.Memory.Static.Ship
        -- this.Config.HoldAltitude = ship.Altitude
        this.Config.HoldAltitude = 1000
        this.Enabled = true
    end

    Horizon.Emit.Subscribe("AltitudeHold", this.ToggleEnabled)

    return this
end)()
