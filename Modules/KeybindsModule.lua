KeybindsModule = (function() 
    local this = HorizonModule("Keybinds Module", "PostFlush", true)
    this.Tags = "system,thrust"

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    function this.Update(eventType, arg)
        
        if eventType == "keydown" then
            if arg == "brake" then local vb = Horizon.GetModule("Velocity Braking").Enable() end
        end

        if eventType == "keyup" then
            if arg == "option1" then local ccm = Horizon.GetModule("Cruise Control").ToggleEnabled() end
            if arg == "option2" then local sid = Horizon.GetModule("Simple Inertial Dampening").ToggleEnabled() end
            if arg == "option3" then local gs = Horizon.GetModule("Gravity Suppression").ToggleEnabled() end
            if arg == "lalt" then local ms = Horizon.GetModule("Mouse Steering").ToggleEnabled() end
            if arg == "brake" then local vb = Horizon.GetModule("Velocity Braking").Disable() end
        end
        
    end

    return this
end)()
Horizon.RegisterModule(KeybindsModule)