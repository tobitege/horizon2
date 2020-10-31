--@class MouseModule

MouseModule = (function()
    local this = HorizonModule("Mouse Module", "Converts mouse scroll wheel actions into horizon events", "PreFlush", true, 0)
    this.Tags = "system,mouse"

    
    function this.Update(eventType, deltaTime)
        local mouseWheel = system.getMouseWheel()
        
        if mouseWheel ~= 0 then
            Horizon.Event.MouseWheel(mouseWheel)
        end

    end

    return this
end)()