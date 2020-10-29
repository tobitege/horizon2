--@class SerializationModule
--@require ConfigSerializer

SerializationModule = (function() 
    local this = HorizonModule("Serialization Module", "Save and load module configs to/from a databank", "Start", true, 5)
    this.Tags = "system,state"
    

    function this.Update(eventType)
        if eventType == "start" then

        else

        end
    end

    Horizon.Event.Stop.Add(this)

    return this
end)()