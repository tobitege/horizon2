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

        local localGravityVector = vec3(library.systemResolution3(
                {World.Right:unpack()},
                {World.Forward:unpack()},
                {World.Up:unpack()},
                {(World.Gravity*Ship.Mass):unpack()}
            ))

        local localAirFrictionVector = vec3(library.systemResolution3(
                {World.Right:unpack()},
                {World.Forward:unpack()},
                {World.Up:unpack()},
                {World.AirFriction:unpack()}
            ))

        local tkForward = core.getMaxKinematicsParametersAlongAxis("all", {vec3(0,1,0):unpack()})
        local tkUp = core.getMaxKinematicsParametersAlongAxis("all", {vec3(0,0,1):unpack()})
        local tkRight = core.getMaxKinematicsParametersAlongAxis("all", {vec3(1,0,0):unpack()})

        local tkOffset = 0
        if World.AtmosphericDensity < 0.1 then tkOffset = 2 end

        Ship.MaxKinematics = {
            Forward = math.abs(tkForward[1+tkOffset] + localGravityVector.y),-- + localAirFrictionVector.y,
            Backward = math.abs(tkForward[2+tkOffset] - localGravityVector.y),-- - localAirFrictionVector.y,

            Up = math.abs(tkUp[1+tkOffset] + localGravityVector.z),-- + localAirFrictionVector.z,
            Down = math.abs(tkUp[2+tkOffset] - localGravityVector.z),-- - localAirFrictionVector.z,

            Right = math.abs(tkRight[1+tkOffset] + localGravityVector.x),-- + localAirFrictionVector.x,
            Left = math.abs(tkRight[2+tkOffset] - localGravityVector.x),-- - localAirFrictionVector.x
        }

        -- Local
        Local.Velocity = vec3(core.getVelocity())
        Local.Acceleration = vec3(core.getAcceleration())

        rawset(memory, "World", World)
        rawset(memory, "Ship", Ship)
        rawset(memory, "Local", Local)
    end

    this.Update()

    return this
end)()
Horizon.RegisterModule(ReadingsModule)