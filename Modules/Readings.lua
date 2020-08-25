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
                {World.Gravity:unpack()}
            ))

        local gravityForwardKinematics = {localGravityVector.y, -localGravityVector.y, localGravityVector.y, -localGravityVector.y}
        local gravityUpKinematics = {localGravityVector.z, -localGravityVector.z, localGravityVector.z, -localGravityVector.z}
        local gravityRightKinematics = {localGravityVector.x, -localGravityVector.x, localGravityVector.x, -localGravityVector.x}

        local localAirFrictionVector = vec3(library.systemResolution3(
                {World.Right:unpack()},
                {World.Forward:unpack()},
                {World.Up:unpack()},
                {World.AirFriction:unpack()}
            ))

        local airFrictionForwardKinematics = {localAirFrictionVector.y, -localAirFrictionVector.y, localAirFrictionVector.y, -localAirFrictionVector.y}
        local airFrictionUpKinematics = {localAirFrictionVector.z, -localAirFrictionVector.z, localAirFrictionVector.z, -localAirFrictionVector.z}
        local airFrictionRightKinematics = {localAirFrictionVector.x, -localAirFrictionVector.x, localAirFrictionVector.x, -localAirFrictionVector.x}

        Ship.MaxKinematics = {
            Forward = core.getMaxKinematicsParametersAlongAxis("fueled", {vec3(0,1,0):unpack()}),
            Up = core.getMaxKinematicsParametersAlongAxis("fueled", {vec3(0,0,1):unpack()}),
            Right = core.getMaxKinematicsParametersAlongAxis("fueled", {vec3(1,0,0):unpack()})
        }
        Ship.MaxBreakingKinematics = {
            Forward = core.getMaxKinematicsParametersAlongAxis("all", {vec3(0,1,0):unpack()}),
            Up = core.getMaxKinematicsParametersAlongAxis("all", {vec3(0,0,1):unpack()}),
            Right = core.getMaxKinematicsParametersAlongAxis("all", {vec3(1,0,0):unpack()})
        }

        for i=1,#Ship.MaxKinematics.Forward,1 do

            Ship.MaxKinematics.Forward[i] = Ship.MaxKinematics.Forward[i]+gravityForwardKinematics[i]
            Ship.MaxKinematics.Up[i] = Ship.MaxKinematics.Up[i]+gravityUpKinematics[i]
            Ship.MaxKinematics.Right[i] = Ship.MaxKinematics.Right[i]+gravityRightKinematics[i]

            Ship.MaxBreakingKinematics.Forward[i] = Ship.MaxBreakingKinematics.Forward[i]+gravityForwardKinematics[i]+airFrictionForwardKinematics[i]
            Ship.MaxBreakingKinematics.Up[i] = Ship.MaxBreakingKinematics.Up[i]+gravityUpKinematics[i]+airFrictionUpKinematics[i]
            Ship.MaxBreakingKinematics.Right[i] = Ship.MaxBreakingKinematics.Right[i]+gravityRightKinematics[i]+airFrictionRightKinematics[i]

        end

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