ThrustController = (function() 
    local this = HorizonModule("Thrust Controller", "PostFlush", true)

    local core = Horizon.Core
    local memory = Horizon.Memory.Dynamic.Ship
    local controller = Horizon.Controller

    function this.Update(eventType, deltaTime)
        local thrust = memory.Thrust
        local rotation = memory.Rotation

        controller.setEngineCommand(memory.Tags, {memory.Thrust:unpack()}, {memory.Rotation:unpack()})

        -- Cleanup
        thrust = vec3(0,0,0)
        rotation = vec3(0,0,0)
    end

    return this
end)()
Horizon.RegisterModule(ThrustController)