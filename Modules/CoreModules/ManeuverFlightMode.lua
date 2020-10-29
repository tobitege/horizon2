--@class ManeuverFlightMode
--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require KeybindsModule
--@require ReadingsModule

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

    local movement = { 
        direction = {
            forward = vec3(0 , 1 , 0),
            backward = vec3(0, -1, 0),
            left = vec3(-1, 0, 0),
            right = vec3(1, 0, 0),
            up = vec3(0, 0, 1),
            down = vec3(0, 0, -1)
        },
        rotation = {
            rollleft = vec3(0, -1, 0),
            rollright = vec3(0, 1, 0),
            yawleft = vec3(-1, 0, 0),
            yawright = vec3(1, 0, 0),
            pitchup = vec3(0, 0, 1),
            pitchdown = vec3(0, 0, -1)
        }
    }

    local function handleInput(event, keyDown)
        event = string.lower(event)
        local property = string.match(event, '%.([^%.]*)%.')
        local direction = string.match(event, '%.([^%.]*)$')
        if movement[property] and movement[property][direction] then
            local sign = 1
            if not keyDown then sign = -1 end
            if property == "direction" then
                this.Direction = this.Direction + (movement[property][direction] * sign)
            else
                this.Rotation = this.Rotation + (movement[property][direction] * sign)
            end
        else
            this.Direction = vec3(0,0,0)
            this.Rotation = vec3(0,0,0)
        end
    end

    local function handleThrottle(event, keyDown)
        event = string.lower(event)
        local direction = string.match(event, '%.([^%.]*)$')
        if direction == "up" then
            this.Config.Throttle = math.min(1,this.Config.Throttle+0.1)
        else
            this.Config.Throttle = math.max(0,this.Config.Throttle-0.1)
        end
    end

    Horizon.Emit.Subscribe("Move.*", handleInput)
    Horizon.Emit.Subscribe("Throttle.*", handleThrottle)

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