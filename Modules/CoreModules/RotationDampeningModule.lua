--@class RotationDampeningModule

--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require ReadingsModule

RotationDampeningModule = (function()
    local this = HorizonModule("Rotation Dampening", "Slows rotation over time, preventing unintended spin", "PostFlush", true)
    this.Tags = "stability,rotation"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    function this.Update(eventType, deltaTime)
        local staticWorld = Horizon.Memory.Static.World
        local dynamicShip = Horizon.Memory.Dynamic.Ship

        dynamicShip.Rotation = dynamicShip.Rotation - ((staticWorld.AngularVelocity * 2) - (staticWorld.AngularAirFriction * 2))
    end

    return this
end)()
