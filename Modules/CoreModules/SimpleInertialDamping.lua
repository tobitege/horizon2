SimpleInertialDampening = (function() 
    local this = HorizonModule("Simple Inertial Dampening", "PostFlush", true)
    this.Tags = "stability,thrust"

    function this.Update(eventType, deltaTime)
        local staticWorld = Horizon.Memory.Static.World
        local dynamicShip = Horizon.Memory.Dynamic.Ship
        local localShip = Horizon.Memory.Static.Local

        local currentShipMomentum = localShip.Velocity

        local delta = vec3(0,0,0)

        if dynamicShip.MoveDirection.x == 0 then delta.x = currentShipMomentum.x end
        if dynamicShip.MoveDirection.y == 0 then delta.y = currentShipMomentum.y end
        if dynamicShip.MoveDirection.z == 0 then delta.z = currentShipMomentum.z end

        delta = Utils3d.localToRelative(delta, staticWorld.Up, staticWorld.Right, staticWorld.Forward)

        dynamicShip.Thrust = dynamicShip.Thrust - delta
    end


    return this
end)()
Horizon.RegisterModule(SimpleInertialDampening)