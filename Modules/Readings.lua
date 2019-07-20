ReadingsModule = (function() 
    local this = HorizonModule("Ship Readings")

    function this.Update()
        local memory = getmetatable(Horizon.Memory).__index

        -- World Linear
        memory.World.Position = vec3(Horizon.Core.getConstructWorldPos())
        memory.World.Velocity = vec3(Horizon.Core.getWorldVelocity())
        memory.World.Acceleration = vec3(Horizon.Core.getWorldAcceleration())
        memory.World.Up = vec3(Horizon.Core.getConstructWorldOrientationUp())
        memory.World.Right = vec3(Horizon.Core.getConstructWorldOrientationRight())
        memory.World.Forward = vec3(Horizon.Core.getConstructWorldOrientationForward())
        memory.World.Gravity = vec3(Horizon.Core.getWorldGravity())
        memory.World.AirFriction = vec3(Horizon.Core.getWorldAirFrictionAcceleration())

        -- World Angular
        memory.World.AngularVelocity = vec3(Horizon.Core.getWorldAngularVelocity())
        memory.World.AngularAcceleration = vec3(Horizon.Core.getWorldAngularAcceleration())
        memory.World.AngularAirFriction = vec3(Horizon.Core.getWorldAirFrictionAngularAcceleration())

        -- Ship
        memory.Ship.Altitude = vec3(Horizon.Core.getAltitude())
        memory.Ship.Id = Horizon.Core.getConstructId()
        memory.Ship.Mass = Horizon.Core.getConstructMass()
        memory.Ship.CrossSection = Horizon.Core.getConstructCrossSection()
        memory.Ship.MaxKinematics = Horizon.Core.getMaxKinematicsParameters() -- Possibly read off of databank/magic var later?

        -- Local
        memory.Ship.Local.Velocity = vec3(Horizon.Core.getVelocity())
    end

    return this
end)()