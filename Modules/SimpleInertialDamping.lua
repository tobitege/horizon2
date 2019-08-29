SimpleInertialDampening = (function() 
    local this = HorizonModule("Simple Inertial Dampening", "PostFlush", true)
    this.Tags = "stability,thrust"
    
    function this.Update(eventType, deltaTime)
        local slocal = Horizon.Memory.Static.Local
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship
        local norm = (slocal.Velocity + slocal.Acceleration):normalize()
        local speed = slocal.Velocity:len() + slocal.Acceleration:len()
        local delta = vec3(0,0,0)

        if ship.MoveDirection.x == 0 then delta.x = norm.x * speed end
        if ship.MoveDirection.y == 0 then delta.y = norm.y * speed end
        if ship.MoveDirection.z == 0 then delta.z = norm.z * speed end
        delta = (world.Right * delta.x) + (world.Forward * delta.y) + (world.Up * delta.z)
        ship.Thrust = ship.Thrust - delta
    end

    return this
end)()
Horizon.RegisterModule(SimpleInertialDampening)