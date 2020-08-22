BreakingModule = (function() 
    local this = HorizonModule("Velocity Breaking Module", "PostFlush", true, 4)
    this.Tags = "thrust,breaking"

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    local isBreaking = false

    function this.Update(eventType, key)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship
        
        if key == "brake" then
            if eventType == "keyup" then
                isBreaking = false
            else
                isBreaking = true
            end
            return
        end

        if isBreaking == true then 
            dship.Thrust = (-world.Velocity) * ship.Mass 
            system.print("BREAKING")
        end
    end

    return this
end)()
Horizon.RegisterModule(BreakingModule)