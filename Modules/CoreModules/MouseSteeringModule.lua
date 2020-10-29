--@class MouseSteeringModule
--@require HorizonCore
--@require HorizonModule

MouseSteeringModule = (function() 
    local this = HorizonModule("Mouse Steering", "Locks the mouse and redirects input to ship rotation", "Flush", true)
    this.Tags = "steering,control"

    -- Config
    this.Config = {
        FlipX = false,
        FlipY = false,
        Sensitivity = 1,
        Deadzone = 0.5,
        Clamp = 50
    }

    local function InThreshold(n)
        return (n > this.Config.Deadzone and n > 0) or (n < -this.Config.Deadzone and n < 0)
    end

    local function Clamp(n)
        return math.min(this.Config.Clamp, math.max(n, -this.Config.Clamp))
    end

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship

        local delta = vec3(system.getMouseDeltaX(), system.getMouseDeltaY(), 0) * (this.Config.Sensitivity * 0.1)
        -- Transform local->world
        local x = world.Forward:cross(world.Up) * Clamp(delta.y)
        local z = world.Forward:cross(world.Right) * -Clamp(delta.x)

        if not InThreshold(delta.y) then x = vec3(0,0,0) end
        if not InThreshold(delta.x) then z = vec3(0,0,0) end

        if this.Config.FlipX then z = z * -1 end
        if this.Config.FlipY then x = x * -1 end

        ship.Rotation = ship.Rotation - x - z
    end

    function this.Enable()
        this.Enabled = true
        system.lockView(1)
    end
    function this.Disable()
        this.Enabled = false
        system.lockView(0)
    end

    Horizon.Emit.Subscribe("MouseSteering", function() this.ToggleEnabled() end)

    system.lockView(1)
    return this
end)()