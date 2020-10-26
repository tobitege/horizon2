--@class HorizonCore
--@require SlotDetector

function HorizonDelegate(eventType)
    local typeof = types.type
    local this = {}
    this.Delegates = {}
    local lastTime = system.getTime()

    function this.Add(f)
        if typeof(f) ~= "HorizonModule" and type(f) ~= "function" then
            error("[HorizonDelegate] Unable to add callback - not a HorizonModule or function")
            return
        end
        for i = 1, #this.Delegates do
            if this.Delegates[i] == f then
                return false
            end
        end
        table.insert(this.Delegates, f)
        return true
    end

    function this.Remove(f)
        if typeof(f) ~= "HorizonModule" and type(f) ~= "function" then
            error("[HorizonDelegate] Unable to remove callback - not a HorizonModule or function")
            return
        end
        for i = 1, #this.Delegates do
            if this.Delegates[i] == f then
                table.remove(this.Delegates, i)
                return true
            end
        end
        return false
    end

    function this.Call(...)
        local anonymous = {}
        local deltaTime = system.getTime() - lastTime
        for currentPriority = 0, 5 do
            for i = 1, #this.Delegates do
                if
                    type(this.Delegates[i]) == "function" or
                        this.Delegates[i].Enabled and this.Delegates[i].Priority == currentPriority
                 then
                    local block = false
                    for k, v in pairs(anonymous) do
                        if v == this.Delegates[i] then
                            block = true
                        end
                    end
                    if not block then
                        local _, err = pcall(this.Delegates[i], eventType, deltaTime, ...)
                        if type(this.Delegates[i]) == "function" then
                            table.insert(anonymous, this.Delegates[i])
                        end
                        if err then
                            Horizon.Event.Error.Call(err)
                        end
                    end
                end
            end
        end
        lastTime = system.getTime()
    end

    function this.Count()
        return #this.Delegates
    end

    setmetatable(
        this,
        {
            __call = function(ref, ...)
                this.Call(...)
            end,
            __add = function(left, right)
                if left == this then
                    this.Add(right)
                    return this
                end
                if right == this then
                    this.Add(left)
                    return this
                end
                return this
            end,
            __sub = function(left, right)
                if left == this then
                    this.Remove(right)
                    return this
                end
                if right == this then
                    this.Remove(left)
                    return this
                end
                return this
            end,
            __tostring = function()
                return "EventDelegate(" .. eventType .. ", #" .. #this.Delegates .. ")"
            end
        }
    )

    return this
end

function EventEmitter()
    local this = {}
    this.Subscribed = {}

    this.Subscribe = function(filter, callback)
        if type(callback) ~= "function" then error("Attempting to add a non-function callback to EventEmitter") end
        if not this.Subscribed[filter] then
            this.Subscribed[filter] = {}
        end
        table.insert(this.Subscribed[filter], callback)
    end
    this.Add = this.Subscribe

    this.Unsubscribe = function(callback)
        for evtName,evt in pairs(this.Subscribed) do
            for key,cb in ipairs(evt) do
                if cb == callback then
                    table.remove(evt,key)
                end
            end
        end
    end
    this.Remove = this.Unsubscribe

    this.Call = function(event, ...)
        event = string.lower(event)
        for evtName,evt in pairs(this.Subscribed) do
            local ename = string.lower(evtName)
            local match = string.match(event, ename)
            if match then
                for _,cb in ipairs(evt) do cb(event, ...) end
            end
        end
    end

    setmetatable(this, { __call = function(ref, ...) this.Call(...) end })

    return this
end

--@require SlotDetector
local slots = SlotDetector.DetectSlotsInNamespace(_G)
Horizon = (function (slotContainer)
    local this = {}

    if not slotContainer.Core then error("The core has not been linked") end
    if not slotContainer.Unit then error("The code is running on an unknown program unit, slot detected needs updating") end
    this.Core = slotContainer.Core
    this.Controller = slotContainer.Unit
    this.Slots = slots
    this.Modules = {}
    this.HUD = nil
    this.Memory = {
        Static = {},
        Dynamic = {
            Ship = {
                Thrust = vec3(0,0,0),
                Rotation = vec3(0,0,0),
                --All except rocket engines
                Tags = "atmospheric_engine,space_engine,airfoil,brake,torque,vertical",
                Priority1Tags = "brake,airfoil,torque",
                Priority2Tags = "atmospheric_engine,space_engine,vertical",
                Priority3Tags = ""
            },
            Settings = {}
        },
        Slots = slotContainer
    }
    this.Event = {
        Start = HorizonDelegate("start"),
        PreFlush = HorizonDelegate("preflush"),
        Flush = HorizonDelegate("flush"),
        PostFlush = HorizonDelegate("postflush"),
        PreUpdate = HorizonDelegate("preupdate"),
        Update = HorizonDelegate("update"),
        PostUpdate = HorizonDelegate("postupdate"),
        KeyDown = HorizonDelegate("keydown"),
        KeyUp = HorizonDelegate("keyup"),
        KeyLoop = HorizonDelegate("keyloop"),
        MouseMove = HorizonDelegate("mousemove"),
        Stop = HorizonDelegate("stop"),
        Error = HorizonDelegate("error"),
        MouseWheel = HorizonDelegate("mousewheel"),
        Click = HorizonDelegate("click")
    }
    this.Version = "2.0.1a RC1 CI_COMMIT_BRANCH CI_COMMIT_SHORT_SHA"


    this.Emit = EventEmitter()

    setmetatable(this.Slots, {__index={}, __newindex=function() end})
    setmetatable(this.Memory.Static, {__index={}, __newindex=function() end})

    function this.RegisterSharedDatabank(databank)
        this.Memory.Shared = databank
    end

    function this.RegisterModule(module)
        if types.type(module) ~= "HorizonModule" then return end
        this.Modules[module.Name] = module
        --table.insert(this.Modules, module)
        module.Register()
    end

    function this.UnregisterModule(module)
        if types.type(module) ~= "HorizonModule" then return end
        if this.Modules[module.Name] == nil then return end
        this.Modules[module.Name] = nil
        module.Unregister()
    end

    function this.GetModule(name)
        return this.Modules[name]
    end

    setmetatable(this, {
        __add = function (module) this.RegisterModule(module) end,
        __sub = function (module) this.UnregisterModule(module) end,
        __newindex = function(table, key, value) end
    })
    return this
end)(slots)