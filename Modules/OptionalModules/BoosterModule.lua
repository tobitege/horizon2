---@diagnostic disable: undefined-global
--@class BoosterModule

BoosterModule = (function() 
    local this = HorizonModule("Booster", "When enabled, rocket boosters are activated (BROKEN)", "PostFlush", false)
    this.Tags = "system,thrust"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    
    function this.Enable()
        rocket.setThrust(1)
        this.Enabled = true
    end

    function this.Disable()
        rocket.setThrust(0)
        this.Enabled = false
    end

    Horizon.Emit.Subscribe("Boost", function() this.ToggleEnabled() end)

    return this
end)()