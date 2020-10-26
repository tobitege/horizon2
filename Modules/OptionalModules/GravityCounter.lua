GravityCounter = (function() 
    local this = HorizonModule("Gravity Suppression", "Negates the effect of gravity, allowing hovering and linear velocity approaches to planets", "Flush", true)
    this.Tags = "thrust,stability"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship

        ship.Thrust = ship.Thrust - world.Gravity
    end

    Horizon.Emit.Subscribe("GravityCounter", function() this.ToggleEnabled() end)

    return this
end)()
Horizon.RegisterModule(GravityCounter)