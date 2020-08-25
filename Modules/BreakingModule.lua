BreakingModule = (function() 
    local this = HorizonModule("Velocity Braking", "PreFlush", false, 4)
    this.Tags = "thrust,braking"

    local time = system.getTime()

    function this.Update(eventType, key)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship
        local deltaTime = system.getTime() - time
        
        dship.Thrust = -world.Velocity * ship.Mass * deltaTime
        time = system.getTime()
    end

    return this
end)()
Horizon.RegisterModule(BreakingModule)