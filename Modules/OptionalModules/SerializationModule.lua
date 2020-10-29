--@class SerializationModule
--@require ConfigSerializer

SerializationModule = (function() 
    local this = HorizonModule("Serialization Module", "Save and load module configs to/from a databank", "Start", true, 1)
    this.Config = {
        SaveKey = "_HorizonConfig"
    }
    this.Tags = "system,state"

    -- See if there is a databank present.
    local dbs = Horizon.Slots.Databanks
    local dataBank = nil
    if dbs and #dbs > 0 then
        for _,v in pairs(dbs) do
            if v.hasKey(this.Config.SaveKey) == 1 then
                dataBank = v
            end
        end
        if dataBank == nil then
            -- pick the first
            dataBank = dbs[1]
        end
    end

    if not dataBank then
        this.Disable()
        error("SerializationModule can not operate without a linked databank")
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
                    end
                end
                system.print("Loaded config")
            end
        else
            local conf = {}
            for k,v in pairs(Horizon.Modules) do
                if v.Config then
                    conf[k] = v.Config
                end
            end
            conf = ConfigSerializer.Serialize(conf)
            dataBank.setStringValue(this.Config.SaveKey,conf)
            system.print("Saved config")
        end
    end

    Horizon.Event.Stop.Add(this)

    return this
end)()