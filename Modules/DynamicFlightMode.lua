DynamicFlightMode = (function() 
    local this = HorizonModule("Dynamic Flight Mode", "Flush", true)
    this.Tags = "control,thrust,steering,input"
    this.Throttle = 0.2
    this.TurnSpeed = 2
    this.Direction = vec3(0,0,0)
    this.Rotation = vec3(0,0,0)

    local ship = Horizon.Memory.Dynamic.Ship

    if not ship.MoveDirection then ship.MoveDirection = vec3(0,0,0) end

    local events = {
        forward = vec3(0,1,0),
        backward = vec3(0,-1,0),
        left = vec3(-1,0,0),
        right = vec3(1,0,0),
        up = vec3(0,0,1),
        down = vec3(0,0,-1)
    }

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    function this.Update(eventType, key)
        local world = Horizon.Memory.Static.World
        local stats = Horizon.Memory.Static.Ship
        

        if eventType == "flush" then
            local fMax = stats.MaxKinematics[1] / stats.Mass
            local xform = (world.Up * this.Direction.z) + (world.Forward * this.Direction.y) + (world.Right * this.Direction.x)
            ship.Thrust = ship.Thrust + (xform * this.Throttle * fMax)
            ship.Rotation = ship.Rotation + ((world.Forward * this.Rotation.y) * this.TurnSpeed)
            return
        end

        if events[key] then
            if eventType == "keyup" then
                this.Direction = this.Direction - events[key]
            else
                this.Direction = this.Direction + events[key]
            end
            ship.MoveDirection = this.Direction
            return
        end

        -- TODO: Unfuck
        if key == "yawleft" then
            if eventType == "keyup" then
                this.Rotation.y = 0
            else
                this.Rotation.y = -1
            end
        elseif key == "yawright" then
            if eventType == "keyup" then
                this.Rotation.y = 0
            else
                this.Rotation.y = 1
            end
        end
    end

    return this
end)()
Horizon.RegisterModule(DynamicFlightMode)