BoosterModule = (function() 
    local this = HorizonModule("Booster", "PostFlush", false)
    this.Tags = "system,thrust"

    local tags = Horizon.Memory.Dynamic.Ship.Tags
    Navigation.setBoosterCommand('rocket_engine')

    function this.Update(eventType, deltaTime)
       
    end

    function this.Enable()
        Navigation.toggleBoosters()
        this.Enabled = true
    end
    function this.Disable()
        Navigation.toggleBoosters()
        this.Enabled = false
    end

    return this
end)()
Horizon.RegisterModule(BoosterModule)