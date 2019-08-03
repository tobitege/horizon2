AtmosphericStability = (function() 
    local this = HorizonModule("Atmospheric Stabilizer", "Flush", true)

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship

        ship.Rotation = ship.Rotation - ((world.AngularVelocity * 2) - (world.AngularAirFriction * 2))
    end

    return this
end)()
Horizon.RegisterModule(AtmosphericStability)