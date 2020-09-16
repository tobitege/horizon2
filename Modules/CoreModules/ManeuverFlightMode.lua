ManeuverFlightMode = (function() 
    local this = HorizonModule("Maneuver Flight Mode", "Flight mode that allows 6DOF movement", "Flush", true)
    this.Tags = "control,thrust,steering,input"

    this.Config.Version = "CI_FILE_LAST_COMMIT"
    this.Config.Throttle = 0.2
    this.Config.TurnSpeed = 2
    this.Direction = vec3(0,0,0)
    this.Rotation = vec3(0,0,0)

    local ship = Horizon.Memory.Dynamic.Ship

    --This is used to inform other modules of the users current movement intent
    if not ship.MoveDirection then ship.MoveDirection = vec3(0,0,0) end

    local directionVectors = {
        forward = vec3(0,1,0),
        backward = vec3(0,-1,0),
        left = vec3(-1,0,0),
        right = vec3(1,0,0),
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

    function this.Left(keyDown)
        if keyDown then
            this.Direction = this.Direction + directionVectors.left
        else
            this.Direction = this.Direction - directionVectors.left
        end
    end

    function this.Right(keyDown)
        if keyDown then
            this.Direction = this.Direction + directionVectors.right
        else
            this.Direction = this.Direction - directionVectors.right
        end
    end

    function this.RollLeft(keyDown)
        if keyDown then
            this.Rotation.y = -1
        else
            this.Rotation.y = 0
        end
    end

    function this.RollRight(keyDown)
        if keyDown then
            this.Rotation.y = 1
        else
            this.Rotation.y = 0
        end
    end

    function this.YawLeft(keyDown)
        if keyDown then
            this.Rotation.x = -1
        else
            this.Rotation.x = 0
        end
    end

    function this.YawRight(keyDown)
        if keyDown then
            this.Rotation.x = 1
        else
            this.Rotation.x = 0
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

    function this.SpeedUp(keyDown)
        this.Config.Throttle = math.min(1,this.Config.Throttle+0.1)
    end
    
    function this.SpeedDown(keyDown)
        this.Config.Throttle = math.max(0,this.Config.Throttle-0.1)
    end

    function this.Update(eventType)
        local world = Horizon.Memory.Static.World
        local stats = Horizon.Memory.Static.Ship

        local thrustToApply = vec3(0,0,0)

        if (this.Direction.z > 0) then
            thrustToApply = thrustToApply + (world.Up * stats.MaxKinematics.Up)
        elseif this.Direction.z < 0 then
            thrustToApply = thrustToApply + (-world.Up * stats.MaxKinematics.Down)
        end

        if this.Direction.y > 0 then
            thrustToApply = thrustToApply + (world.Forward * stats.MaxKinematics.Forward)
        elseif this.Direction.y < 0 then
            thrustToApply = thrustToApply + (-world.Forward * stats.MaxKinematics.Backward)
        end

        if this.Direction.x > 0 then
            thrustToApply = thrustToApply + (world.Right * stats.MaxKinematics.Right)
        elseif this.Direction.x < 0 then
            thrustToApply = thrustToApply + (-world.Right * stats.MaxKinematics.Left)
        end

        ship.Thrust = ship.Thrust + (thrustToApply * this.Config.Throttle)
        ship.Rotation = ship.Rotation + ((world.Forward * this.Rotation.y) * this.Config.TurnSpeed)

        ship.MoveDirection = this.Direction
    end

    return this
end)()
Horizon.RegisterModule(ManeuverFlightMode)