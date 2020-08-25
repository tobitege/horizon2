BoosterModule = (function() 
    local this = HorizonModule("Booster Module", "PostFlush", true)
    this.Tags = "system,thrust"

    local tags = Horizon.Memory.Dynamic.Ship.Tags
    local boostEnabled = false

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    function this.Update(eventType, deltaTime)
        
        if key == "boost" then
            if eventType == "keyup" then
                boostEnabled = not boostEnabled

                if boostEnabled then
                    tags = tags .. ",rocket_engine"
                else
                    tags = tags:gsub(",rocket_engine", "")
                end
            end
        end
        
    end

    return this
end)()
Horizon.RegisterModule(BoosterModule)