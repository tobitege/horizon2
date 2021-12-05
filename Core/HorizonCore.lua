--@class HorizonCore
--@require SlotDetector

---@alias vec3 table

---@class HorizonDelegate Horizon event delegate.
---@param eventType string Dual Universe event type.
function HorizonDelegate(eventType)
    local typeof = types.type
    ---@class HorizonDelegate
    local this = {}

    --- Array of callbacks attached to the current instance.
    ---@type table
    this.Callbacks = {}

    local lastTime = system.getTime()

    ---Adds a callback to be executed when the delegate is invoked.
    ---@param f HorizonModule|function The callback to add.
    ---@return boolean Success Whether the add operation was sucessful.
    function this.Add(f)
        if typeof(f) ~= "HorizonModule" and type(f) ~= "function" then
            error("[HorizonDelegate] Unable to add callback - not a HorizonModule or function")
            return
        end
        for i = 1, #this.Callbacks do
            if this.Callbacks[i] == f then
                return false
            end
        end
        table.insert(this.Callbacks, f)
        return true
    end

    ---Removes a callback from this delegate.
    ---@param f HorizonModule|function The callback to remove.
    ---@return boolean Success Whether the removal was sucessful.
    function this.Remove(f)
        if typeof(f) ~= "HorizonModule" and type(f) ~= "function" then
            error("[HorizonDelegate] Unable to remove callback - not a HorizonModule or function")
            return
        end
        for i = 1, #this.Callbacks do
            if this.Callbacks[i] == f then
                table.remove(this.Callbacks, i)
                return true
            end
        end
        return false
    end

    ---Invokes this delegate with the specified parameters.
    ---@param ... any The parameters to pass onto the callbacks.
    function this.Call(...)
        local anonymous = {}
        local deltaTime = system.getTime() - lastTime
        for currentPriority = 0, 5 do
            for i = 1, #this.Callbacks do
                if
                    type(this.Callbacks[i]) == "function" or
                        this.Callbacks[i].Enabled and this.Callbacks[i].Priority == currentPriority
                 then
                    local block = false
                    for k, v in pairs(anonymous) do
                        if v == this.Callbacks[i] then
                            block = true
                        end
                    end
                    if not block then
                        local success, err = pcall(this.Callbacks[i], eventType, deltaTime, ...)
                        if type(this.Callbacks[i]) == "function" then
                            table.insert(anonymous, this.Callbacks[i])
                        end
                        if not success then
                            local errorMessage = (this.Callbacks[i].Name or "Unknown").."@"..eventType..": "..err
                            Horizon.Event.Error.Call(errorMessage)
                        end
                    end
                end
            end
        end
        lastTime = system.getTime()
    end

    ---The number of callbacks attached to this delegate.
    ---@return number
    function this.Count()
        return #this.Callbacks
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
                return "EventDelegate(" .. eventType .. ", #" .. #this.Callbacks .. ")"
            end
        }
    )

    return this
end

---@class EventEmitter Arbitrary event emitter bus.
function EventEmitter()
    ---@class EventEmitter Arbitrary event emitter bus.
    local this = {}

    ---Currently subscribed callbacks.
    ---@type table
    this.Subscribed = {}

    ---Subscribe to the event bus.
    ---@param filter string The filter for the event name to listen for. Wildcards are supported with asterisk(*).
    ---@param callback function The callback to invoke when a matching event is raised.
    this.Subscribe = function(filter, callback)
        if type(callback) ~= "function" then error("Attempting to add a non-function callback to EventEmitter") end
        if not this.Subscribed[filter] then
            this.Subscribed[filter] = {}
        end
        table.insert(this.Subscribed[filter], callback)
    end
    this.Add = this.Subscribe

    ---Unsubscribe a function from the callback bus.
    ---@param callback function The callback to unsubscribe.
    this.Unsubscribe = function(callback)
        for _,evt in pairs(this.Subscribed) do
            for key,cb in ipairs(evt) do
                if cb == callback then
                    table.remove(evt, key)
                end
            end
        end
    end
    this.Remove = this.Unsubscribe

    ---Invoke an event on the bus with the specified name.
    ---@param event string The event name.
    ---@param ... any Parameters to pass to registered callbacks.
    this.Call = function(event, ...)
        event = string.lower(event)
        for filter,evt in pairs(this.Subscribed) do
            filter = string.lower(filter)
            local match = string.match(event, "^"..filter.."$")
            if match then
                for _,cb in ipairs(evt) do cb(event, ...) end
            end
        end
    end

    setmetatable(this, { __call = function(ref, ...) this.Call(...) end })

    return this
end

--@require SlotDetector
---@diagnostic disable-next-line: undefined-global
local slots = SlotDetector.DetectSlotsInNamespace(_G)

---@class Horizon The Horizon Core
Horizon = (function (slotContainer)
    ---@class Horizon The Horizon Core
    local this = {}

    if not slotContainer.Core then error("The core has not been linked") end
    if not slotContainer.Unit then error("The code is running on an unknown program unit, slot detected needs updating") end

    ---The construct's core element.
    ---@type table
    this.Core = slotContainer.Core

    ---The construct's controller element. e.g. programming board, remote control, seat, etc.
    ---@type table  
    this.Controller = slotContainer.Unit

    ---The linked slots of the controller.
    this.Slots = slots

    ---The currently loaded Horizon modules.
    ---@see HorizonModule
    this.Modules = {}
    this.HUD = nil

    ---The system memory of Horizon
    ---@type table
    this.Memory = {
        ---The static memory of Horizon. Only modifiable by system modules.
        ---This table can only be modified using rawset.
        ---DO NOT modify this table unless you have a VERY good reason to.
        ---@type StaticMemory
        Static = {
        },
        ---The dynamic operational memory of Horizon.
        ---@type table
        Dynamic = {
            ---The dynamic memory associated with ship functions.
            ---@type table
            Ship = {
                ---The ship's current thrust output vector in m/s.
                ---@type vec3
                Thrust = vec3(0,0,0),
                ---The ship's current rotation output vector in rad/s.
                ---@type vec3
                Rotation = vec3(0,0,0),
                ---The active tags to apply engine commands to, exclusing rocket engines.
                ---@type string
                Tags = "atmospheric_engine,space_engine,airfoil,brake,torque,vertical",
                ---Tags of priority1 engines.
                ---@type string
                Priority1Tags = "brake,airfoil,torque",
                ---Tags of priority2 engines.
                ---@type string
                Priority2Tags = "atmospheric_engine,space_engine,vertical",
                ---Tags of priority3 engines.
                ---@type string
                Priority3Tags = ""
            },
            Settings = {}
        },
        Slots = slotContainer
    }
    ---Horizon Core events.
    ---@type table
    this.Event = {
        ---Delegate for the Dual Universe "start" event.
        Start = HorizonDelegate("start"),
        ---Delegate to invoke before the Dual Universe "flush" event.
        PreFlush = HorizonDelegate("preflush"),
        ---Delegate for the Dual Universe "flush" event.
        Flush = HorizonDelegate("flush"),
        ---Delegate to invoke after the Dual Universe "flush" event.
        PostFlush = HorizonDelegate("postflush"),
        ---Delegate to invoke before the Dual Universe "update" event.
        PreUpdate = HorizonDelegate("preupdate"),
        ---Delegate for the Dual Universe "update" event.
        Update = HorizonDelegate("update"),
        ---Delegate to invoke after the Dual Universe "update" event.
        PostUpdate = HorizonDelegate("postupdate"),
        ---Delegate for the Dual Universe "keydown" event.
        KeyDown = HorizonDelegate("keydown"),
        ---Delegate for the Dual Universe "keyup" event.
        KeyUp = HorizonDelegate("keyup"),
        ---Delegate for the Dual Universe "keyloop" event.
        KeyLoop = HorizonDelegate("keyloop"),
        ---Delegate for the Dual Universe "mousemove" event.
        MouseMove = HorizonDelegate("mousemove"),
        ---Delegate for the Dual Universe "stop" event.
        Stop = HorizonDelegate("stop"),
        Error = HorizonDelegate("error"),
        MouseWheel = HorizonDelegate("mousewheel"),
        Click = HorizonDelegate("click")
    }
    ---Git version of the current Horizon build.
    ---@type string
    this.Version = "%CI_COMMIT_TAG% %CI_COMMIT_BRANCH% %CI_COMMIT_SHORT_SHA% %GIT_FILE_LAST_COMMIT%"

    ---Arbitrary event emitter for communication between modules.
    ---@type EventEmitter
    this.Emit = EventEmitter()

    setmetatable(this.Slots, {__index={}, __newindex=function() end})
    setmetatable(this.Memory.Static, {__index={}, __newindex=function() end})

    function this.RegisterSharedDatabank(databank)
        this.Memory.Shared = databank
    end

    ---Registers a HorizonModule into the system.
    ---@param module HorizonModule
    function this.RegisterModule(module)
        if types.type(module) ~= "HorizonModule" then return end
        this.Modules[module.Name] = module
        --table.insert(this.Modules, module)
        module.Register()
    end

    ---Removes a HorizonModule from the system.
    ---@param module HorizonModule
    function this.UnregisterModule(module)
        if types.type(module) ~= "HorizonModule" then return end
        if this.Modules[module.Name] == nil then return end
        this.Modules[module.Name] = nil
        module.Unregister()
    end

    ---Returns a HorizonModule with the given name.
    ---@param name string The name of the module to return.
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

---@class StaticMemory
local staticMock = {
    ---@class WorldMemory World space readings.
    ---@field Position vec3 The current construct position in world coordinates.
    ---@field Velocity vec3 The current construct velocity in world coordinates.
    ---@field Acceleration vec3 The current construct acceleration in world coordinates.
    ---@field Up vec3 The current construct up vector in world coordinates
    ---@field Forward vec3 The current construct forward vector in world coordinates.
    ---@field Right vec3 The current construct right vector in world coordinates.
    ---@field Gravity vec3 The current gravity vector in world coordinates and length as the acceleration in m/s.
    ---@field G number The current acceleration due to gravity in m/s.
    ---@field Vertical vec3 The current gravity vector as a unit vector.
    ---@field AirFriction vec3 The acceleration generated by air resistance.
    ---@field AtmosphericDensity number The local atmosphere density, between 0 and 1.
    ---@field VerticalVelocity number The acceleration along the gravity vector in m/s.
    ---@field AngularVelocity vec3 The constructs angular velocity, in world coordinates.
    ---@field AngularAcceleration vec3 The construct's angular acceleration, in world coordinates.
    ---@field AngularAirFriction vec3 The acceleration torque generated by air resistance.
    World = {},
    ---@class ShipMemory Construct readings.
    ---@field Altitude number Altitude above sea level, with respect to the closest planet (0 in space).
    ---@field Id integer Returns the construct unique ID.
    ---@field Mass number The mass of the construct.
    ---@field CrossSection number The construct's cross sectional surface in the current direction of movement in m^2. Note: Only defined for dynamic cores.
    ---@field MaxKinematics table The maximum force which can be output for each direction.
    ---@field Yaw number The current yaw.
    ---@field Pitch number The current pitch.
    ---@field Roll number The current roll.
    Ship = {},
    ---@class LocalMemory Local space readings.
    ---@field Velocity vec3 Current velocity in local space.
    ---@field Acceleration vec3 Current acceleration in local space.
    Local = {}
}