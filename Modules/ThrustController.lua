ThrustController = (function() 
    local this = HorizonModule("Thrust Controller")

    function this.Update(eventType, deltaTime)
        local core = Horizon.Core
        local memory = Horizon.Memory.Dynamic.Ship
        local controller = Horizon.Controller
        local thrust = memory.Thrust
        local rotation = memory.Rotation

        controller.setEngineCommand(memory.Tags, {memory.Thrust:unpack()}, {memory.Rotation:unpack()})
    end

    function this.Register()
        this.Enabled = true
        Horizon.Event.PostFlush.Add(this)
    end

    function this.Unregister()
        this.Enabled = false
        Horizon.Event.PostFlush.Remove(this)
    end

    return this
end)()
Horizon.RegisterModule(ThrustController)