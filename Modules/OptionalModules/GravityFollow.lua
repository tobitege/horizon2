GravityFollow = (function() 
    local this = HorizonModule("Gravity Follow", "Forces ship down to follow gravity down, effectively locking ship pitch to the horizon", "Flush", true)
    this.Tags = "thrust,stability"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship

        ship.Rotation = ship.Rotation + (world.Up:cross(-world.Gravity:normalize()) * deltaTime)
    end

    return this
end)()
Horizon.RegisterModule(GravityFollow)