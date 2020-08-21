ReadingsModule = (function() 
    local this = HorizonModule("Ship Readings", "PreFlush", true)
    this.Tags = "system,readings"
    
    local memory = getmetatable(Horizon.Memory.Static).__index
    local core = Horizon.Core
    local controller = Horizon.Controller

    function this.Update()
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
        --Gravity is a vector3
        World.Gravity = vec3(core.getWorldGravity())
        World.AirFriction = vec3(core.getWorldAirFrictionAcceleration())
        World.AtmosphericDensity = controller.getAtmosphereDensity()

        -- World Angular
        World.AngularVelocity = vec3(core.getWorldAngularVelocity())
        World.AngularAcceleration = vec3(core.getWorldAngularAcceleration())
        World.AngularAirFriction = vec3(core.getWorldAirFrictionAngularAcceleration())

        -- Ship
        Ship.Altitude = vec3(core.getAltitude())
        Ship.Id = core.getConstructId()
        Ship.Mass = core.getConstructMass()
        Ship.CrossSection = core.getConstructCrossSection()
        Ship.MaxKinematics = {
            Forward = core.getMaxKinematicsParametersAlongAxis("All", vec3(0,1,0)),
            Up = core.getMaxKinematicsParametersAlongAxis(vec3(0,0,1)),
            Right = core.getMaxKinematicsParametersAlongAxis(vec3(1,0,0))
        }
        Ship.MaxKinematics = {
            Forward = {10000,-10000,0,0},
            Up = {20000,-10000,0,0},
            Right = {10000,-10000,0,0}
        }

        -- Local
        Local.Velocity = vec3(core.getVelocity())
        Local.Acceleration = vec3(core.getAcceleration())

        rawset(memory, "World", World)
        rawset(memory, "Ship", Ship)
        rawset(memory, "Local", Local)
    end

    return this
end)()
Horizon.RegisterModule(ReadingsModule)