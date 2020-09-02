DynamicFlightMode = (function() 
    local this = HorizonModule("Dynamic Flight Mode", "Flush", true)
    this.Tags = "control,thrust,steering,input"
    this.Throttle = 0.2
    this.TurnSpeed = 2
    this.Direction = vec3(0,0,0)
    this.Rotation = vec3(0,0,0)

    local ship = Horizon.Memory.Dynamic.Ship

    --This is used to inform other modules of the users current movement intent
    if not ship.MoveDirection then ship.MoveDirection = vec3(0,0,0) end

    local directionVectors = {
        forward = vec3(0,1,0),
        backward = vec3(0,-1,0),
        yawleft = vec3(-1,0,0),
        yawright = vec3(1,0,0),
        up = vec3(0,0,1),
        down = vec3(0,0,-1)
    }

    function this.Forward(keyDown)
        if keyDown then
            this.Direction = this.Direction + directionVectors.forward
        else
            this.Direction = this.Direction - directionVectors.forward
        end
    end
    function this.Backward(keyDown)
        if keyDown then
            this.Direction = this.Direction + directionVectors.backward
        else
            this.Direction = this.Direction - directionVectors.backward
        end
    end
    function this.YawLeft(keyDown)
        if keyDown then
            this.Direction = this.Direction + directionVectors.yawleft
        else
            this.Direction = this.Direction - directionVectors.yawleft
        end
    end
    function this.YawRight(keyDown)
        if keyDown then
            this.Direction = this.Direction + directionVectors.yawright
        else
            this.Direction = this.Direction - directionVectors.yawright
        end
    end
    function this.Up(keyDown)
        if keyDown then
            this.Direction = this.Direction + directionVectors.up
        else
            this.Direction = this.Direction - directionVectors.up
        end
    end
    function this.Down(keyDown)
        if keyDown then
            this.Direction = this.Direction + directionVectors.down
        else
            this.Direction = this.Direction - directionVectors.down
        end
    end
    function this.Left(keyDown)
        if keyDown then
            this.Rotation.y = -1
        else
            this.Rotation.y = 0
        end
    end
    function this.Right(keyDown)
        if keyDown then
            this.Rotation.y = 1
        else
            this.Rotation.y = 0
        end
    end
    function this.SpeedUp(keyDown)

    end
    function this.SpeedDown(keyDown)

    end

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

            local thrustToApply = vec3(0,0,0)

            if (this.Direction.z > 0) then
                thrustToApply = thrustToApply + (world.Up * currentKinematics.Up)
            elseif this.Direction.z < 0 then
                thrustToApply = thrustToApply + (-world.Up * currentKinematics.Down)
            end

            if this.Direction.y > 0 then
                thrustToApply = thrustToApply + (world.Forward * currentKinematics.Forward)
            elseif this.Direction.y < 0 then
                thrustToApply = thrustToApply + (-world.Forward * currentKinematics.Backward)
            end

            if this.Direction.x > 0 then
                thrustToApply = thrustToApply + (world.Right * currentKinematics.Right)
            elseif this.Direction.x < 0 then
                thrustToApply = thrustToApply + -(world.Right * currentKinematics.Left)
            end

            ship.Thrust = ship.Thrust + (thrustToApply * this.Throttle)
            ship.Rotation = ship.Rotation + ((world.Forward * this.Rotation.y) * this.TurnSpeed)
        end

        ship.MoveDirection = this.Direction
    end

    return this
end)()
Horizon.RegisterModule(DynamicFlightMode)