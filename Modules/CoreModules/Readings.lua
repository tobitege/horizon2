ReadingsModule =
    (function()
    local this =
        HorizonModule(
        "Ship Readings",
        "Gathers ship and environment data and makes it available to other modules",
        "PreFlush",
        true
    )
    this.Tags = "system,readings"
    this.Config.Version = "CI_FILE_LAST_COMMIT"

    local constants = require("cpml/constants")
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
        World.Gravity = vec3(core.getWorldGravity())
        World.Vertical = vec3(core.getWorldVertical())
        World.AirFriction = vec3(core.getWorldAirFrictionAcceleration())
        World.AtmosphericDensity = controller.getAtmosphereDensity()

        World.VerticalVelocity = World.Velocity:dot(-World.Gravity:normalize())

        -- World Angular
        World.AngularVelocity = vec3(core.getWorldAngularVelocity())
        World.AngularAcceleration = vec3(core.getWorldAngularAcceleration())
        World.AngularAirFriction = vec3(core.getWorldAirFrictionAngularAcceleration())

        -- Ship
        Ship.Altitude = core.getAltitude()
        Ship.Id = core.getConstructId()
        Ship.Mass = core.getConstructMass()
        Ship.CrossSection = core.getConstructCrossSection()

        
        local tkForward = core.getMaxKinematicsParametersAlongAxis("all", {vec3(0, 1, 0):unpack()})
        local tkUp = core.getMaxKinematicsParametersAlongAxis("all", {vec3(0, 0, 1):unpack()})
        local tkRight = core.getMaxKinematicsParametersAlongAxis("all", {vec3(1, 0, 0):unpack()})
        
        local tkOffset = 0
        if World.AtmosphericDensity < 0.1 then
            tkOffset = 2
        end
        
        local virtualGravityEngine =
            vec3(
            library.systemResolution3(
                {World.Right:unpack()},
                {World.Forward:unpack()},
                {World.Up:unpack()},
                {(World.Gravity * Ship.Mass):unpack()}
            )
        )

        Ship.MaxKinematics = {
            Forward = math.abs(tkForward[1 + tkOffset] + virtualGravityEngine.y),
            Backward = math.abs(tkForward[2 + tkOffset] - virtualGravityEngine.y),
            Up = math.abs(tkUp[1 + tkOffset] + virtualGravityEngine.z),
            Down = math.abs(tkUp[2 + tkOffset] - virtualGravityEngine.z),
            Right = math.abs(tkRight[1 + tkOffset] + virtualGravityEngine.x),
            Left = math.abs(tkRight[2 + tkOffset] - virtualGravityEngine.x)
        }

        Ship.Pitch = math.asin(World.Vertical:dot(World.Forward)) * -constants.rad2deg
        Ship.Roll = math.asin(World.Vertical:dot(World.Right)) * constants.rad2deg

        local forward = vec3(World.Forward:project_on_plane(World.Vertical)):normalize()
        local right = vec3(World.Right:project_on_plane(World.Vertical)):normalize()
        local north = vec3(vec3(0, 0, 1):project_on_plane(World.Vertical)):normalize()
        local angleUp = World.Up:dot(World.Vertical)
        if angleUp > 0 then right = -right end
        local angleForward = math.acos(forward:dot(north)) * constants.rad2deg
        local angleRight = math.acos(right:dot(north)) * constants.rad2deg

        Ship.Yaw = angleForward
        if angleRight < 90 then
            Ship.Yaw = (180 - angleForward) + 180
        end

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
