LoggingModule = (function() 
    local this = HorizonModule("Logging Module", "PostUpdate", true, 5)
    this.Tags = "logging"

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    local isBreaking = false

    function this.Update(eventType, key)
        --[[local static = Horizon.Memory.Static
        local dynamic = Horizon.Memory.Dynamic

        system.print("Velocity : "..tostring(static.Ship.Velocity))
        system.print("Gravity : "..tostring(static.World.Gravity))
        system.print("Thrust : "..tostring(dynamic.Ship.Thrust))]]


        if eventType == "keyup" then
            system.print("UP "..key)
        elseif eventType == "keydown" then
            system.print("down "..key)
        end

    end

    return this
end)()
Horizon.RegisterModule(LoggingModule)