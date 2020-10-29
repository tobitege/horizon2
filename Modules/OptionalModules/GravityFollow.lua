GravityFollow = (function() 
    local this = HorizonModule("Gravity Follow", "Forces ship to follow gravity down, effectively locking ship pitch to the horizon", "Flush", false)
    this.Tags = "thrust,stability"
    this.Config = {
        AdjustSpeed = 5
    }
    
    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Dynamic.Ship
        local relAccel = Horizon.Memory.Static.Local.Acceleration
        local relVel = Horizon.Memory.Static.Local.Velocity
        local dot = relVel:normalize():dot(relAccel:normalize())
        local offset = 0
        if dot <= 0 then offset = 1 end

        local maxKinematics = Horizon.Core.getMaxKinematicsParametersAlongAxis("all", {relAccel:normalize():unpack()})
        if world.AtmosphericDensity > 0 then
            maxKinematics = math.abs(maxKinematics[1 + offset])
        else
            maxKinematics = math.abs(maxKinematics[3 + offset])
        end
        local current = relAccel:len() * Horizon.Memory.Static.Ship.Mass
        local scale = this.Config.AdjustSpeed * math.min(math.max(current / maxKinematics, 0.1), 1) * 10

        ship.Rotation = ship.Rotation + (world.Up:cross(-world.Vertical) * scale)
    end
    
    Horizon.Emit.Subscribe("GravityFollow", function() this.ToggleEnabled() end)

    return this
end)()
Horizon.RegisterModule(GravityFollow)
