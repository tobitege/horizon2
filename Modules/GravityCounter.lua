GravityCounter = (function() 
    local this = HorizonModule("Gravity Suppression", "Flush", true)

    function this.Update(eventType, deltaTime)
        local memory = Horizon.Memory.Static.World
        local write = Horizon.Memory.Dynamic.Ship

        write.Thrust = write.Thrust - memory.Gravity
    end
    
    return this
end)()
Horizon.RegisterModule(GravityCounter)