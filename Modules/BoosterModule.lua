BoosterModule = (function() 
    local this = HorizonModule("Booster", "PostFlush", false)
    this.Tags = "system,thrust"

    local link = rocket

    function this.Update(eventType, deltaTime)
       
    end

    function this.Enable()
        link.setThrust(1)
        this.Enabled = true
    end
    function this.Disable()
        link.setThrust(0)
        this.Enabled = false
    end

    return this
end)()
Horizon.RegisterModule(BoosterModule)