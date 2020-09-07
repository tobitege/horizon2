ThrustController = (function() 
    local this = HorizonModule("Thrust Controller", "PostFlush", true, 5)
    this.Tags = "system,thrust"

    local core = Horizon.Core
    local memory = Horizon.Memory.Dynamic.Ship
    local controller = Horizon.Controller

    function this.Update(eventType, deltaTime)
        local thrust = memory.Thrust
        local rotation = memory.Rotation

        controller.setEngineCommand(memory.Tags, {thrust:unpack()}, {rotation:unpack()}, false, false, memory.Priority1Tags, memory.Priority2Tags, memory.Priority3Tags)

        -- Cleanup
        memory.Thrust = vec3(0,0,0)
        memory.Rotation = vec3(0,0,0)
    end

    return this
end)()
Horizon.RegisterModule(ThrustController)