--@class ReadingsModule
--@require HorizonCore
--@require HorizonModule

ReadingsModule = (function()
    local this = HorizonModule("Ship Readings", "Gathers ship and environment data and makes it available to other modules", "PreFlush", true)
    this.Tags = "system,readings"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    local constants = require("cpml/constants")
    local memory = getmetatable(Horizon.Memory.Static).__index
    local core = Horizon.Core
    local controller = Horizon.Controller

    function this.Update()
        local World = {}
        local Ship = {}
        local Local = {}

        -- World Linear
        World.Position = vec3(construct.getWorldPosition())
        World.Velocity = vec3(construct.getWorldVelocity())
        World.Acceleration = vec3(construct.getWorldAcceleration())
        World.Up = vec3(construct.getWorldOrientationUp())
        World.Right = vec3(construct.getWorldOrientationRight())
        World.Forward = vec3(construct.getWorldOrientationForward())
        World.Gravity = vec3(core.getWorldGravity())
        World.Vertical = vec3(core.getWorldVertical())
        World.AirFriction = vec3(construct.getWorldAirFrictionAcceleration())
        World.AtmosphericDensity = controller.getAtmosphereDensity()

        World.VerticalVelocity = World.Velocity:dot(-World.Gravity:normalize())

        -- World Angular
        World.AngularVelocity = vec3(construct.getWorldAngularVelocity())
        World.AngularAcceleration = vec3(construct.getWorldAngularAcceleration())
        World.AngularAirFriction = vec3(construct.getWorldAirFrictionAngularAcceleration())

        -- Ship
        Ship.Altitude = core.getAltitude()
        Ship.Id = construct.getId()
        Ship.Mass = construct.getTotalMass()
        Ship.CrossSection = construct.getCrossSection()


        local tkForward = construct.getMaxThrustAlongAxis("all", {vec3(0, 1, 0):unpack()})
        local tkUp = construct.getMaxThrustAlongAxis("all", {vec3(0, 0, 1):unpack()})
        local tkRight = construct.getMaxThrustAlongAxis("all", {vec3(1, 0, 0):unpack()})

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

        local localGrav = vec3(library.systemResolution3({World.Right:unpack()}, {World.Forward:unpack()}, {World.Up:unpack()}, {World.Vertical:unpack()}))
        local localVert = vec3(library.systemResolution3({(World.Vertical:cross(World.Forward)):unpack()}, {World.Forward:unpack()}, {World.Vertical:unpack()}, {vec3(0,0,1):unpack()}))
        Ship.Yaw = (math.atan(-localVert.x, localVert.y) * constants.rad2deg) % 360
        Ship.Pitch = 180 - (math.atan(localGrav.y, localGrav.z) * constants.rad2deg)
        Ship.Roll = 180 - (math.atan(localGrav.x, localGrav.z) * constants.rad2deg)

        -- Local
        Local.Velocity = vec3(construct.getVelocity())
        Local.Acceleration = vec3(construct.getAcceleration())

        rawset(memory, "World", World)
        rawset(memory, "Ship", Ship)
        rawset(memory, "Local", Local)
    end

    this.Update()

    return this
end)()