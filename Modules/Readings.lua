ReadingsModule = (function() 
    local this = HorizonModule("Ship Readings")

    function this.Update()
        local memory = getmetatable(Horizon.Memory.Static).__index
        local core = core
        local World = {}
        local Ship = {}
        local Local = {}

        -- World Linear
        World.Position = vec3(core.getConstructWorldPos())
        World.Velocity = vec3(core.getWorldVelocity())
        World.Acceleration = vec3(core.getWorldAcceleration())
        World.Up = vec3(core.getConstructWorldOrientationUp())
        World.Right = vec3(core.getConstructWorldOrientationRight())
        World.Forward = vec3(core.getConstructWorldOrientationForward())
        World.Gravity = vec3(core.getWorldGravity())
        World.AirFriction = vec3(core.getWorldAirFrictionAcceleration())

        -- World Angular
        World.AngularVelocity = vec3(core.getWorldAngularVelocity())
        World.AngularAcceleration = vec3(core.getWorldAngularAcceleration())
        World.AngularAirFriction = vec3(core.getWorldAirFrictionAngularAcceleration())

        -- Ship
        Ship.Altitude = vec3(core.getAltitude())
        Ship.Id = core.getConstructId()
        Ship.Mass = core.getConstructMass()
        Ship.CrossSection = core.getConstructCrossSection()
        Ship.MaxKinematics = core.getMaxKinematicsParameters() -- Possibly read off of databank/magic var later?

        -- Local
        Local.Velocity = vec3(core.getVelocity())

        rawset(memory, "World", World)
        rawset(memory, "Ship", Ship)
        rawset(memory, "Local", Local)
    end

    function this.Register()
        this.Enabled = true
        Horizon.Event.PreFlush.Add(this)
    end

    function this.Unregister()
        this.Enabled = false
        Horizon.Event.PreFlush.Remove(this)
    end

    return this
end)()
Horizon.RegisterModule(ReadingsModule)