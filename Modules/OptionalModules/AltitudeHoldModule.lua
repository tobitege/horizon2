--@class AltitudeHoldModule
--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require ReadingsModule

AltitudeHoldModule = (function() 
    local this = HorizonModule("Altitude Hold", "When enabled a consistent altitude is maintained", "PostFlush", false, 4)
    this.Tags = "thrust,altitude"
    this.Config = {
        TargetAltitude = 5000,
        StepSize = 100
    }
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship

        local currThrust = (dship.Thrust:dot(world.Vertical) + world.G) + (world.Acceleration:dot(world.Vertical) + world.G)
        local altitudeDelta = (ship.Altitude + world.VerticalVelocity) - this.Config.TargetAltitude
        dship.Thrust = dship.Thrust + (world.Vertical * ((altitudeDelta * 10) - currThrust))
    end

    function this.Enable()
        local ship = Horizon.Memory.Static.Ship
        this.Config.TargetAltitude = ship.Altitude
        this.Enabled = true
    end

    function this.AltitudeUp()
        this.Config.TargetAltitude = this.Config.TargetAltitude + 100
    end

    function this.AltitudeDown()
        this.Config.TargetAltitude = this.Config.TargetAltitude - 100
    end

    Horizon.Emit.Subscribe("AltitudeHold", this.ToggleEnabled)

    Horizon.Emit.Subscribe("AltitudeUp", this.AltitudeUp)
    Horizon.Emit.Subscribe("AltitudeDown", this.AltitudeDown)

    return this
end)()
