MouseModule = (function() 
    local this = HorizonModule("Mouse Module", "PreFlush", true, 0)
    this.Tags = "system,mouse"

    
    function this.Update(eventType, deltaTime)
        local mouseWheel = getThrottleInputFromMouseWheel()

        if mouseWheel ~= 0 then
            Horizon.Event.MouseWheel(mouseWheel)
        end

    end

    return this
end)()
Horizon.RegisterModule(MouseModule)