GravityCounter = (function() 
    local this = HorizonModule("Gravity Suppression")

    function this.Update(eventType, deltaTime)
        local memory = Horizon.Memory.Static.World
        local write = Horizon.Memory.Dynamic.Ship

        write.Thrust = write.Thrust - memory.Gravity
    end

    function this.Register()
        this.Enabled = true
        Horizon.Event.Flush.Add(this)
    end

    function this.Unregister()
        this.Enabled = false
        Horizon.Event.Flush.Remove(this)
    end

    return this
end)()
Horizon.RegisterModule(GravityCounter)