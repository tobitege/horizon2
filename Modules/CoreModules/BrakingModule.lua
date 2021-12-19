--@class BrakingModule

--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require KeybindsModule
--@require ReadingsModule

BrakingModule = (function()
    local this = HorizonModule("Velocity Braking", "When enabled, negates all ship velocity", "PostFlush", false, 5)
    this.Tags = "thrust,braking"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship

        dship.Thrust = -world.Velocity * ship.Mass * deltaTime
    end

    Horizon.Emit.Subscribe("Brake", function() this.ToggleEnabled() end)

    return this
end)()