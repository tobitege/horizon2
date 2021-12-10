--@class CommsModule
--@require Communication

CommsId = nil --export: Communications ID

CommsModule = (function()
    local this = HorizonModule("Communication Module", "Allows commuinication over emitter/receiver.", "Start", true)
    this.Tags = "system,comms"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    if not Horizon.Slots.Emitters or not Horizon.Slots.Receivers then error("Communication Module cannot init - No emitter or receiver detected.") end
    local emitter = Horizon.Slots.Emitters[1]
    local receiver = Horizon.Slots.Receivers[1]

    CommsId = CommsId or Horizon.Memory.Static.Ship.Id
    system.print("Initiating Comms as "..CommsId)

    this.Client = ConnectionManager(CommsId or Horizon.Memory.Static.Ship.Id, emitter, receiver)

    this.Connect = function(target)
        return this.Client.Connect(target)
    end

    Horizon.Emit.Subscribe(
        "Comms.Message.*",
        function(channel, message)
            this.Client.Receive(channel, message)
        end
    )

    return this
end)()