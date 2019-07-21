GravityCounter = (function() 
    local this = HorizonModule("Gravity Suppression", "Flush", true)

    local world = Horizon.Memory.Static.World
    local ship = Horizon.Memory.Dynamic.Ship

    function this.Update(eventType, deltaTime)
        ship.Thrust = ship.Thrust - world.Gravity
    end

    return this
end)()
Horizon.RegisterModule(GravityCounter)