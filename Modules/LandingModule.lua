LandingModule = (function() 
    local this = HorizonModule("Landing", "PostFlush", true)

    local speedLimitInMs = 20 
    local distanceLimit = 10

    function this.Update(eventType, deltaTime)
        local slots = Horizon.Memory.Slots
        local world = Horizon.Memory.Static.World
        
        if world.Velocity:len() < speedLimitInMs then
            for i,v in ipairs(slots.Telemeters) do
                if v.getDistance() < distanceLimit and Horizon.Controller.isAnyLandingGearExtended() ==0 then
                    Horizon.Controller.extendLandingGears()
                    return
                end
                if v.getDistance() > distanceLimit and Horizon.Controller.isAnyLandingGearExtended() ==1 then
                    Horizon.Controller.retractLandingGears()
                    return
                end    
            end
        end
    end

    function this.ToggleGear()
        if Horizon.Controller.isAnyLandingGearExtended() then
            Horizon.Controller.retractLandingGears()
        else
            Horizon.Controller.extendLandingGears()
        end
    end

    return this
end)()
Horizon.RegisterModule(LandingModule)