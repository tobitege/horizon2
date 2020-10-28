--@require HUDMarkers
ARInteract = (function() 
    local this = HorizonModule("AR Interact", "Allows interaction between elements using emitters and receivers", "PostUpdate", true)
    this.Tags = "hud,comms"
    this.Config = {
        Interval = 5
    }
    if not Horizon.Slots.Emitters or not Horizon.Slots.Receivers then error("AR Interact cannot init - No emitter or receiver detected.") end

    local json = require("dkjson")
    local emitter = Horizon.Slots.Emitters[1]
    local starts = function (String,Start)
        return string.sub(String,1,string.len(Start)) == Start
    end

    local markers = Horizon.GetModule("HUD Markers")

    local startTime = system.getTime() + this.Config.Interval
    
    this.Update = function(event, deltaTime)
        if startTime - system.getTime() <= 0 then
            emitter.send("ST_Wideband", "ping")
            startTime = system.getTime() + this.Config.Interval
        end
    end
    
    local handlePong = function(evt, channel, message)
        if message == "ping" then return end -- ignore pongs for now
        if starts(message, "pong") then
            local data = string.sub(message, 8)
            if data then
                data = json.decode(data)
                local marker = ARMarker(data.Position, data.Channel)
                marker.Icon = Icon

                local inst = markers.Add(marker)
                inst.OnClick = function(ref)
                    emitter.send(data.Channel, "toggle")
                end
                local origStyle = inst.Style
                local onUpdate = inst.OnUpdate
                inst.OnUpdate = function(ref)
                    local distance = (Horizon.Memory.Static.World.Position - data.Position):len()
                    if distance <= 100 then
                        ref.Style = origStyle .. ";fill:#0f0 !important;stroke:#0f0 !important;"
                    else
                        ref.Style = origStyle .. ";fill:#f00 !important;stroke:#f00 !important;"
                    end
                    onUpdate(ref)
                end
            end
        end
    end
    
    Horizon.Emit.Subscribe("Comms.Message.ST_Wideband", handlePong)
    
    return this
end)()
Horizon.RegisterModule(ARInteract)