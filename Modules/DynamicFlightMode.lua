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
        yawleft = vec3(-1,0,0),
        yawright = vec3(1,0,0),
        up = vec3(0,0,1),
        down = vec3(0,0,-1)
    }

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    function this.Update(eventType, key)
        local world = Horizon.Memory.Static.World
        local stats = Horizon.Memory.Static.Ship

        if eventType == "flush" then
            local kinematicsOffset = 0
            if world.AtmosphericDensity < 0.1 then kinematicsOffset = 2 end
            local currentKinematics = {
                Forward = math.abs(stats.MaxKinematics.Forward[1+kinematicsOffset]),
                Backward = math.abs(stats.MaxKinematics.Forward[2+kinematicsOffset]),
                Right = math.abs(stats.MaxKinematics.Right[1+kinematicsOffset]),
                Left = math.abs(stats.MaxKinematics.Right[2+kinematicsOffset]),
                Up = math.abs(stats.MaxKinematics.Up[1+kinematicsOffset]),
                Down = math.abs(stats.MaxKinematics.Up[2+kinematicsOffset])
            }

            local xFormUp = world.Up
            if (this.Direction.z > 0) then
                xFormUp = xFormUp * currentKinematics.Up
            elseif this.Direction.z < 0 then
                xFormUp = xFormUp * currentKinematics.Down
            end
            xFormUp = xFormUp*this.Direction.z

            local xFormForward = world.Forward
            if this.Direction.y > 0 then
                xFormForward = xFormForward * currentKinematics.Forward
            elseif this.Direction.y < 0 then
                xFormForward = xFormForward * currentKinematics.Backward
            end
            xFormForward = xFormForward*this.Direction.y

            local xFormRight = world.Right
            if this.Direction.x > 0 then
                xFormRight = xFormRight * currentKinematics.Right
            elseif this.Direction.x < 0 then
                xFormRight = xFormRight * currentKinematics.Left
            end
            xFormRight = xFormRight*this.Direction.x


            local xform = xFormUp + xFormForward + xFormRight

            ship.Thrust = ship.Thrust + (xform * this.Throttle)
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
        if key == "left" then
            if eventType == "keyup" then
                this.Rotation.y = 0
            else
                this.Rotation.y = -1
            end
        elseif key == "right" then
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