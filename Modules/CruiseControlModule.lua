CruiseControlModule = (function() 
    local this = HorizonModule("Cruise Control Module", "PostFlush", true)
    this.Tags = "thrust,breaking"

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    local cruiseControlEnabled = false

    function this.Update(eventType, key)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship
        
        if key == "option1" then
            if eventType == "keydown" then
                cruiseControlEnabled = not cruiseControlEnabled
            end
            return
        end

        if cruiseControlEnabled == true then
            local maxForwardThrust = 0
            if world.AtmosphericDensity > 0.1 then maxForwardThrust = ship.MaxKinematics.Forward[1] else maxForwardThrust = ship.MaxKinematics.Forward[3] end
            dship.Thrust = dship.Thrust + world.Forward*maxForwardThrust
        end
    end

    return this
end)()
Horizon.RegisterModule(CruiseControlModule)