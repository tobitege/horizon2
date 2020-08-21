EngineeringModule = (function() 
    system.print("A1")
    local this = HorizonModule("Engineering Module", "PostFlush", true)
    this.Tags = "system,engineering"

    local core = Horizon.Core
    local memory = Horizon.Memory.Static
    local controller = Horizon.Controller

    function this.Update(eventType, deltaTime)
        local constructMass = memory.Ship.Mass

        local maxUsableThrust = 0
        if memory.World.AtmosphericDensity > 0.1 then
            --Use Atmospheric thrust
            maxUsableThrust = math.max(
                math.abs(memory.Ship.MaxKinematics.Forward[1]),
                math.abs(memory.Ship.MaxKinematics.Forward[2]),
                math.abs(memory.Ship.MaxKinematics.Up[1]),
                math.abs(memory.Ship.MaxKinematics.Up[2]),
                math.abs(memory.Ship.MaxKinematics.Right[1]),
                math.abs(memory.Ship.MaxKinematics.Right[2])
            )
        else
            --Use Space thrust
            maxUsableThrust = math.max(
                math.abs(memory.Ship.MaxKinematics.Forward[3]),
                math.abs(memory.Ship.MaxKinematics.Forward[4]),
                math.abs(memory.Ship.MaxKinematics.Up[3]),
                math.abs(memory.Ship.MaxKinematics.Up[4]),
                math.abs(memory.Ship.MaxKinematics.Right[3]),
                math.abs(memory.Ship.MaxKinematics.Right[4])
            )
        end
        --Check Gravity Tolerance
        local maxAccel = maxUsableThrust/constructMass
        local gravityLimit = memory.World.Gravity:len()*0.8
        system.print("Grav "..gravityLimit)
        if maxAccel > gravityLimit then system.print("WARNING : Gravity exceeds 80% of available thrust") end

    end

    return this
end)()
Horizon.RegisterModule(EngineeringModule)