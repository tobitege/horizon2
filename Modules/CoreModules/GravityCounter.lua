GravityCounter = (function() 
    local this = HorizonModule("Gravity Suppression", "Flush", true)
    this.Tags = "thrust,stability"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship

        ship.Thrust = ship.Thrust - world.Gravity
    end

    return this
end)()
Horizon.RegisterModule(GravityCounter)