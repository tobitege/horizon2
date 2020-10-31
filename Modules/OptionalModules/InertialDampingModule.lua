--@class InertialDampeningModule
--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require KeybindsModule
--@require ReadingsModule
--@require Utils3D

InertialDampeningModule = (function() 
    local this = HorizonModule("Inertial Dampening", "Slows velocity in any direction that the user is not applying thrust to 0, ie soft braking", "PostFlush", true)
    this.Tags = "stability,thrust"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    function this.Update(eventType, deltaTime)
        local staticWorld = Horizon.Memory.Static.World
        local dynamicShip = Horizon.Memory.Dynamic.Ship
        local localShip = Horizon.Memory.Static.Local

        local currentShipMomentum = localShip.Velocity

        local delta = vec3(0,0,0)

        local moveDirection = dynamicShip.MoveDirection or vec3(0,0,0)

        if moveDirection.x == 0 then delta.x = currentShipMomentum.x end
        if moveDirection.y == 0 then delta.y = currentShipMomentum.y end
        if moveDirection.z == 0 then delta.z = currentShipMomentum.z end

        delta = Utils3d.localToRelative(delta, staticWorld.Up, staticWorld.Right, staticWorld.Forward)

        dynamicShip.Thrust = dynamicShip.Thrust - delta
    end

    Horizon.Emit.Subscribe("InertialDamping", function() this.ToggleEnabled() end)

    return this
end)()