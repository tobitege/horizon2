--@class SpeedLimiter

SpeedLimiter = (function() 
    local this = HorizonModule("Speed Limiter", "Prevents total velocity from exceeding the defined speed limit", "Flush", false)
    this.tags = "throttle,stability,thrust,braking"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    this.Config.speedLimitInMs = 277 --Limit us to 1000KM/h, a safe re-entry speed

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship

        local currentVelocity = world.Velocity:len()
        if currentVelocity > this.Config.speedLimitInMs then
            local movementVector = world.Velocity:normalize()
            local maxVelocityVector = movementVector * this.Config.speedLimitInMs
            local deltaVelocityVector = world.Velocity - maxVelocityVector

            ship.Thrust = ship.Thrust - (deltaVelocityVector / deltaTime)
        end
    end

    Horizon.Emit.Subscribe("SpeedLimiter", function() this.ToggleEnabled() end)
    return this
end)()