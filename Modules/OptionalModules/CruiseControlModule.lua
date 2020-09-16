CruiseControlModule = (function() 
    local this = HorizonModule("Cruise Control", "When enabled forward thrust is constantly applied", "PostFlush", false)
    this.Tags = "thrust,breaking"

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship
        
        dship.Thrust = dship.Thrust + world.Forward * ship.MaxKinematics.Forward

        --[[if dship.MoveDirection.x ~= 0 or dship.MoveDirection.y ~= 0 or dship.MoveDirection.z ~= 0 then
            this.Disable()
        end]]

    end

    return this
end)()
Horizon.RegisterModule(CruiseControlModule)