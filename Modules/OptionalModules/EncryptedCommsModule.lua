--@class EncryptedCommsModule
--@require Crypto
--@require Communication
--@require STEMTransport

CommsId = 1 --export: Communications ID

EncryptedCommsModule =
    (function()
    local this =
        HorizonModule("Encrypted Communication Module", "Allows encrypted commuinication over emitter/receiver.", "Start", true)
    this.Tags = "system,comms"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    local comms = Horizon.GetModule("Communication Module")
    
    CommsModule = this

    if not Horizon.Slots.Emitters or not Horizon.Slots.Receivers then error("Communication Module cannot init - No emitter or receiver detected.") end
    local emitter = Horizon.Slots.Emitters[1]
    local receiver = Horizon.Slots.Receivers[1]

    this.Client = ConnectionManager(CommsId, emitter, receiver)
    this.Client.Transports.STEM = STEMTransport

    this.Connect = function(target)
        return this.Client.Connect(tostring(target))
    end

    Horizon.Emit.Subscribe(
        "Comms.Message.*",
        function(evt, channel, message)
            this.Client.Receive(channel, message)
        end
    )

    Horizon.Event.Update.Add(this.Client.Process)

    if CommsId == 1 then
        local conn = this.Connect(2, "STEM")
        conn.OnHandshake = function()
            system.print("Successfuly established connection")
            conn.Send("MSG", "Hello, World!")
            conn.Send("MSG", "Testing")
        end
    end

    return this
end)()