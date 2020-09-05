EmergencyStop = (function() 
    local this = HorizonModule("Emergency Stop", "Flush", true)

    local inertialDampenerModule = Horizon.GetModule("Simple Inertial Dampening")
    if not internalDampenerModule then this.Disable() end
    if not emergencyStop then this.Disable() end

    function this.Update(eventType, deltaTime)
        if emergencyStop.getState() == 1 then
            inertialDampenerModule.Enable()
        end
    end

    return this
end)()
Horizon.RegisterModule(EmergencyStop)