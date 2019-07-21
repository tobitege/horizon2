ReadingsModule = (function() 
    local this = HorizonModule("Ship Readings")

    function this.Update()
        local memory = getmetatable(Horizon.Memory).__index

        -- World Linear
        memory.Static.World.Position = vec3(Horizon.Core.getConstructWorldPos())
        memory.Static.World.Velocity = vec3(Horizon.Core.getWorldVelocity())
        memory.Static.World.Acceleration = vec3(Horizon.Core.getWorldAcceleration())
        memory.Static.World.Up = vec3(Horizon.Core.getConstructWorldOrientationUp())
        memory.Static.World.Right = vec3(Horizon.Core.getConstructWorldOrientationRight())
        memory.Static.World.Forward = vec3(Horizon.Core.getConstructWorldOrientationForward())
        memory.Static.World.Gravity = vec3(Horizon.Core.getWorldGravity())
        memory.Static.World.AirFriction = vec3(Horizon.Core.getWorldAirFrictionAcceleration())

        -- World Angular
        memory.Static.World.AngularVelocity = vec3(Horizon.Core.getWorldAngularVelocity())
        memory.Static.World.AngularAcceleration = vec3(Horizon.Core.getWorldAngularAcceleration())
        memory.Static.World.AngularAirFriction = vec3(Horizon.Core.getWorldAirFrictionAngularAcceleration())

        -- Ship
        memory.Static.Ship.Altitude = vec3(Horizon.Core.getAltitude())
        memory.Static.Ship.Id = Horizon.Core.getConstructId()
        memory.Static.Ship.Mass = Horizon.Core.getConstructMass()
        memory.Static.Ship.CrossSection = Horizon.Core.getConstructCrossSection()
        memory.Static.Ship.MaxKinematics = Horizon.Core.getMaxKinematicsParameters() -- Possibly read off of databank/magic var later?

        -- Local
        memory.Static.Ship.Local.Velocity = vec3(Horizon.Core.getVelocity())
    end

    return this
end)()