--@class CruiseControlModule
--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require KeybindsModule

CruiseControlModule = (function() 
    local this = HorizonModule("Cruise Control", "When enabled forward thrust is constantly applied", "PostFlush", false)
    this.Tags = "thrust,breaking"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    
    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship
        
        dship.Thrust = dship.Thrust + (world.Forward * ship.MaxKinematics.Forward) / ship.Mass
    end
    
    Horizon.Emit.Subscribe("CruiseControl", function() this.ToggleEnabled() end)
    Horizon.Emit.Subscribe("Move.Direction.*", function() this.Disable() end)
    Horizon.Emit.Subscribe("Brake", function() this.Disable() end)

    function this.Enable()
        this.Enabled = true
        local dship = Horizon.Memory.Dynamic.Ship
        dship.MoveDirection = dship.MoveDirection or vec(0,0,0)
        dship.MoveDirection.y = 1
    end
    function this.Disable()
        this.Enabled = false
        local dship = Horizon.Memory.Dynamic.Ship
        dship.MoveDirection = dship.MoveDirection or vec(0,0,0)
        dship.MoveDirection.y = 0
    end
    
    return this
end)()