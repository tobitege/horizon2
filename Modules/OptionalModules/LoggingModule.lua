LoggingModule = (function() 
    local this = HorizonModule("Logging Module", "Debug error handling", "Error", true, 5)
    this.Tags = "system,logging"
    local isBreaking = false

    function this.Update(eventType, deltaTime, error)
        system.print(error)
    end

    return this
end)()