ReadingsModule = (function() 
    local this = HorizonModule("Ship Readings")

    function this.Update()
        local memory = getmetatable(Horizon.Memory.Static).__index
        local World = {}
        local Ship = {}
        local Local = {}

        -- World Linear
        World.Position = vec3(Horizon.Core.getConstructWorldPos())
        World.Velocity = vec3(Horizon.Core.getWorldVelocity())
        World.Acceleration = vec3(Horizon.Core.getWorldAcceleration())
        World.Up = vec3(Horizon.Core.getConstructWorldOrientationUp())
        World.Right = vec3(Horizon.Core.getConstructWorldOrientationRight())
        World.Forward = vec3(Horizon.Core.getConstructWorldOrientationForward())
        World.Gravity = vec3(Horizon.Core.getWorldGravity())
        World.AirFriction = vec3(Horizon.Core.getWorldAirFrictionAcceleration())

        -- World Angular
        World.AngularVelocity = vec3(Horizon.Core.getWorldAngularVelocity())
        World.AngularAcceleration = vec3(Horizon.Core.getWorldAngularAcceleration())
        World.AngularAirFriction = vec3(Horizon.Core.getWorldAirFrictionAngularAcceleration())

        -- Ship
        Ship.Altitude = vec3(Horizon.Core.getAltitude())
        Ship.Id = Horizon.Core.getConstructId()
        Ship.Mass = Horizon.Core.getConstructMass()
        Ship.CrossSection = Horizon.Core.getConstructCrossSection()
        Ship.MaxKinematics = Horizon.Core.getMaxKinematicsParameters() -- Possibly read off of databank/magic var later?

        -- Local
        Local.Velocity = vec3(Horizon.Core.getVelocity())

        rawset(memory, "World", World)
        rawset(memory, "Ship", Ship)
        rawset(memory, "Local", Local)
    end

    function this.Register()
        Horizon.Event.PreFlush.Add(this)
    end

    function this.Unregister()
        Horizon.Event.PreFlush.Remove(this)
    end

    return this
end)()