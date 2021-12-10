--@class DockingRequest

--@require EncryptedCommsModule

DockingRequest = (function()
    local this = HorizonModule("Docking Request", "Allows sending and receiving docking requests.", "Update", true)
    this.Tags = "comms,navigation,radio"

    local radar

    --TODO: Passive scanning
    --TODO: Process requests

    if #Horizon.Slots.Radars.Atmo == 0 and #Horizon.Slots.Radars.Space == 0 then
        error("No radars detected. Unable to use Docking Request module.")
    end

    local function selectRadar()
        local retn
        if Horizon.Memory.Static.World.AtmosphericDensity > 0 then
            retn = Horizon.Slots.Radars.Atmo[1]
        else
            retn = Horizon.Slots.Radars.Space[1]
        end
        return retn
    end

    local function init()
    end

    local Client = EncryptedCommsModule.Client
    Client.OnConnection = function (comm)
        system.print("Incoming connection")
        comm.Debug = true
        comm.OnHandshake = function()
            ---listen
        end
    end

    init()

    local connection = nil

    ---@param comm Communication
    local function handleMessage(comm, type, payload)
        if type == "DOCKR" then
            if payload then
                --notify captain prolly, wait for accept
                local constructID = payload
                local distance = radar.getConstructDistance(constructID)
                if not distance or distance > 1000 then
                    error("Bullshit.")
                    return
                end
                if constructID ~= comm.TargetId then
                    error("Lying about CID.")
                    return
                end
                system.print("past DOCKR, sending DOCKTRS")
                ---TODO: Change to some random hash
                comm.Send("DOCKTRS", "CHANGEME!!!")
            end
        elseif type == "DOCKTRS" then
            if payload then
                local transponder = Horizon.Slots.Transponders[1]
                if transponder then
                    system.print("Sending DOCKOK")
                    local tags = transponder.getTags()
                    transponder.setTags(tags..","..payload)
                    comm.Send("DOCKOK")
                    ---@diagnostic disable-next-line: undefined-field
                    system.print("Negotiated transponder tags with ["..comm.Name.."]")
                else
                    ---gonna have to wonk it somehow
                    comm.Send("DOCKNOK")
                end
            end
        elseif type == "DOCKOK" then
            ---send the waypoints
            ---set autodock
        end
    end

    this.Update = function ()
        radar = selectRadar()
        local id = radar.getTargetId()
        if id ~= 0 and not connection then
            local name = radar.getConstructName(id)
            connection = Client.Connect(tostring(id), "STEM")
            connection.Debug = true
            connection.Name = name
            connection.OnMessage = function(type, payload) handleMessage(connection, type, payload) end
            connection.OnHandshake = function()
                system.print("Connected to "..name..".")
                connection.Send("DOCKR", Horizon.Memory.Static.Ship.Id)
            end
            connection.OnClose = function(reason)
                system.print("Disconnected from "..name..": "..reason)
                connection = nil
            end
            -- start handshake
            -- negotiate transponder id
            -- negotiate waypoints
            -- remove tmp transponder id
            -- go
        end
        -- local contacts = radar.getConstructIds()
        -- system.print("---")
        -- for i=1,#contacts do
        --     local id = contacts[i]
        --     local isIdentified = radar.hasMatchingTransponder(id)
        --     if isIdentified then
        --         local distance = radar.getConstructDistance(id)
        --         if distance < 1000 then
        --             system.print(radar.getConstructName(id).." is in range")
        --         end
        --     end
        -- end
    end

    return this
end)()