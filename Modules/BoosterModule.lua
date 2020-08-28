BoosterModule = (function() 
    local this = HorizonModule("Booster Module", "PostFlush", true)
    this.Tags = "system,thrust"

    local tags = Horizon.Memory.Dynamic.Ship.Tags

    function this.Update(eventType, deltaTime)
       
    end

    function this.Enable()
        tags = tags .. ",rocket_engine"
    end
    function this.Disable()
        tags = tags:gsub(",rocket_engine", "")
    end

    return this
end)()
Horizon.RegisterModule(BoosterModule)