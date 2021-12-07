--@class CruiseFlightMode
--@require ThrustControlModule
--@require KeybindsModule
--@require ReadingsModule

CruiseFlightMode = (function()
    local this = HorizonModule("Cruise Flight Mode", "Cruise flight mode for constant speed", "Flush", false)
    this.Tags = "control,thrust,steering,input,flightmode"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    this.Config.Speed = 0
    this.Config.SpeedStep = 100 / 3.6
    this.Config.TurnSpeed = 2

    ---Maximum theoretical speed
    local maxSpeed = 556
    local additionalMovement = vec3(0,0,0)
    local verticalForce = vec3(0,0,0)
    local rotation = vec3(0,0,0)

    local world = Horizon.Memory.Static.World
    local staticShip = Horizon.Memory.Static.Ship
    local ship = Horizon.Memory.Dynamic.Ship

    local rotationAxis = {
    }

    ---Initialise the control scheme.
    local function Init()
        local loc = Horizon.Memory.Static.Local
        ---Set velocity to the current velocity to nearest 100
        this.Config.Speed = math.abs(math.floor(loc.Velocity.y/1000)*1000)
    end

    ---notes:
    --cap max speed to 2000km/h in atmos
    --cap to c in space


    function this.Update(eventType, deltaTime)
        world = Horizon.Memory.Static.World
        staticShip = Horizon.Memory.Static.Ship
        ship = Horizon.Memory.Dynamic.Ship

        -- cannot rotate 2 directions at same time
        -- add strafing
        -- check zoom out

        rotationAxis = {
            rollleft = -world.Forward,
            rollright = world.Forward,
            left = world.Up,
            right = -world.Up,
            forward = -world.Right,
            backward = world.Right
        }

        local dot = world.Forward:dot(world.AirFriction)
        local modifiedVelocity = (this.Config.Speed - dot)
        local desired = world.Forward * modifiedVelocity
        local delta = (desired - (world.Velocity - world.Acceleration))
        ship.Thrust = ship.Thrust + delta + (verticalForce/staticShip.Mass)
        ship.MoveDirection = vec3(0,1,0) + additionalMovement
        ship.Rotation = ship.Rotation + (rotation * this.Config.TurnSpeed)
    end

    local function handleThrottle(event)
        if not this.Enabled then return end
        event = string.lower(event)
        local direction = string.match(event, '%.([^%.]*)$')
        if direction == "up" then
            this.Config.Speed = this.Config.Speed+this.Config.SpeedStep
        elseif direction == "down" then
            this.Config.Speed = math.max(0,this.Config.Speed-this.Config.SpeedStep)
        end
        system.print("Curr target speed: "..(this.Config.Speed*3.6).." km/h")
    end

    local function handleVertical(event, keyDown)
        if not this.Enabled then return end
        event = string.lower(event)
        local direction = string.match(event, '%.([^%.]*)$')
        if keyDown then
            if direction == "up" then
                additionalMovement.z = 1
                verticalForce = staticShip.MaxKinematics.Up * world.Up
            elseif direction == "down" then
                additionalMovement.z = -1
                verticalForce = staticShip.MaxKinematics.Down * -world.Up
            else
                if rotationAxis[direction] ~= nil then
                    rotation = rotationAxis[direction]
                end
            end
        else
            if direction == "up" or direction == "down" then
                additionalMovement.z = 0
                verticalForce = vec3(0,0,0)
            else
                rotation = vec3(0,0,0)
            end
        end
    end

    local function proxyMousewheel(evt, dT, amount)
        local direction = "up"
        if amount < 0 then direction = "down" end
        local n = math.abs(amount)
        for i=1,n do
            handleThrottle("Throttle."..direction)
        end
    end

    Horizon.Emit.Subscribe("Move.*", handleVertical)
    Horizon.Emit.Subscribe("Throttle.*", handleThrottle)
    Horizon.Event.MouseWheel.Add(proxyMousewheel)
    Horizon.Emit.Subscribe("FlightMode.Switch", this.Disable)
    Horizon.Emit.Subscribe("CruiseFlightMode", function()
        Init()
        Horizon.Emit.Call("FlightMode.Switch", this.Name)
        this.Enable()
    end)

    return this
end)()