--@class CruiseFlightMode
--@require ThrustControlModule
--@require KeybindsModule
--@require ReadingsModule

CruiseFlightMode = (function() 
    local this = HorizonModule("Cruise Mode", "Cruise flight mode for constant speed", "Flush", false)
    this.tags = "control,thrust,steering,input,flightmode"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    this.Config.Speed = 1000 / 3.6
    this.Config.SpeedStep = 100 / 3.6
    
    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship

        local dot = world.Forward:dot(world.AirFriction)
        local modifiedVelocity = (this.Config.Speed - dot)
        local desired = world.Forward * modifiedVelocity
        local delta = (desired - (world.Velocity - world.Acceleration))
        ship.Thrust = ship.Thrust + delta
        ship.MoveDirection = vec3(0,1,0)
    end

    local function handleThrottle(event, keyDown)
        if not this.Enabled then return end
        event = string.lower(event)
        local direction = string.match(event, '%.([^%.]*)$')
        if direction == "up" then
            this.Config.Speed = this.Config.Speed+this.Config.SpeedStep
        else
            this.Config.Speed = math.max(0,this.Config.Speed-this.Config.SpeedStep)
        end
    end

    Horizon.Emit.Subscribe("Throttle.*", handleThrottle)
    Horizon.Emit.Subscribe("FlightMode.Switch", this.Disable)
    Horizon.Emit.Subscribe("CruiseFlightMode", function()
        ---@diagnostic disable-next-line: redundant-parameter
        Horizon.Emit("FlightMode.Switch")
        this.Enable()
    end)
    return this
end)()