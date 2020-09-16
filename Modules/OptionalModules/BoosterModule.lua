BoosterModule = (function() 
    local this = HorizonModule("Booster", "When enabled, rocket boosters are activated (BROKEN)", "PostFlush", false)
    this.Tags = "system,thrust"

    function this.Enable()
        rocket.setThrust(1)
        this.Enabled = true
    end

    function this.Disable()
        rocket.setThrust(0)
        this.Enabled = false
    end

    return this
end)()
Horizon.RegisterModule(BoosterModule)