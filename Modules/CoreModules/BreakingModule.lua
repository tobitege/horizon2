BreakingModule = (function() 
    local this = HorizonModule("Velocity Braking", "When enabled, negates all ship velocity", "PreFlush", false, 5)
    this.Tags = "thrust,braking"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship
        
        dship.Thrust = -world.Velocity * ship.Mass * deltaTime
        time = system.getTime()
    end

    return this
end)()
Horizon.RegisterModule(BreakingModule)