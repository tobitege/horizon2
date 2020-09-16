SpeedLimiter = (function() 
    local this = HorizonModule("Speed Limiter", "Prevents total velocity from exceeding the defined speed limit (UNTESTED)", "Flush", false)

    local speedLimitInMs = 277 --Limit us to 1000KM/h, a safe re-entry speed

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship

        local currentVelocity = ship.Velocity:len()
        if currentVelocity > speedLimitInMs then
            local movementVector = ship.Velocity:normalize()
            local maxVelocityVector = movementVector*speedLimitInMs
            local deltaVelocityVector = ship.Velocity - maxVelocityVector

            ship.Thrust = ship.Thrust - deltaVelocityVector
        end
    end

    return this
end)()
Horizon.RegisterModule(AtmosphericStability)