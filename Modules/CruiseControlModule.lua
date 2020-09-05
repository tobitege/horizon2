CruiseControlModule = (function() 
    local this = HorizonModule("Cruise Control", "PostFlush", false)
    this.Tags = "thrust,breaking"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship
        
        dship.Thrust = dship.Thrust + world.Forward*ship.MaxKinematics.Forward

        if dship.MoveDirection.x ~= 0 or dship.MoveDirection.y ~= 0 or dship.MoveDirection.z ~= 0 then
            -- AHHHRGH, your ... shitty cruise control doesnt turn off when i hit the keyboard! --Mike
            this.Disable()
        end

    end

    return this
end)()
Horizon.RegisterModule(CruiseControlModule)