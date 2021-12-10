--@class EncryptedCommsModule
--@require Crypto
--@require STEMTransport
--@require Communication

CommsId = nil --export: Communications ID

EncryptedCommsModule =
    (function()
    local this =
        HorizonModule("Encrypted Communication Module", "Allows encrypted commuinication over emitter/receiver.", "Start", true)
    this.Tags = "system,comms"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    CommsModule = this

    if not Horizon.Slots.Emitters or not Horizon.Slots.Receivers then error("Communication Module cannot init - No emitter or receiver detected.") end
    local emitter = Horizon.Slots.Emitters[1]
    local receiver = Horizon.Slots.Receivers[1]

    CommsId = CommsId or Horizon.Memory.Static.Ship.Id
    system.print("Initiating Comms as "..CommsId)

    this.Client = ConnectionManager(CommsId, emitter, receiver)
    this.Client.Transports.STEM = STEMTransport

    this.Connect = function(target, proto)
        return this.Client.Connect(tostring(target), proto or "STEM")
    end

    Horizon.Emit.Subscribe(
        "Comms.Message.*",
        function(evt, channel, message)
            this.Client.Receive(channel, message)
        end
    )

    Horizon.Event.Update.Add(this.Client.Process)

    return this
end)()