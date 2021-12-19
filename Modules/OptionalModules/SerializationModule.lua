--@class SerializationModule
--@require ConfigSerializer

SerializationModule = (function()
    local this = HorizonModule("Serialization Module", "Save and load module configs to/from a databank", "Start", true, 1)
    this.Config = {
        SaveKey = "_HorizonConfig"
    }
    this.Tags = "system,state"

    local dataBank = nil
    local playerId = 0

    function this.Init()
        --playerId = Horizon.Controller.getMasterPlayerId()
        -- Check if there is a databank present.
        local dbs = Horizon.Slots.Databanks
        if dbs and #dbs > 0 then
            for _,v in pairs(dbs) do
                if v.hasKey(this.Config.SaveKey) == 1 then
                    dataBank = v
                end
            end
            if dataBank == nil then
                dataBank = dbs[1]
            end
        end

        if not dataBank then
            this.Disable()
            system.print("No databank present. Disabling SerializationModule.")
            return false
        end
        return true
    end

    function this.Update(eventType)
        if eventType == "start" then
            local data = dataBank.getStringValue(this.Config.SaveKey)
            if data then
                data = ConfigSerializer.Deserialize(data)
                for k,v in pairs(data) do
                    local module = Horizon.GetModule(k)
                    if module then
                        module.Config = v
                        module.Init()
                    end
                end
            end
        elseif eventType == "stop" then
            local conf = {}
            for k,v in pairs(Horizon.Modules) do
                if v.Config then
                    conf[k] = v.Config
                end
            end
            conf = ConfigSerializer.Serialize(conf)
            dataBank.setStringValue(this.Config.SaveKey,conf)
        end
    end

    Horizon.Event.Stop.Add(this)

    this.Init()
    return this
end)()