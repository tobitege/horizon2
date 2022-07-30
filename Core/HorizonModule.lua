--@class HorizonModule
--@require HorizonCore

---@class HorizonModule Creates a new Horizon Module instance.
---@param name string The human readable name of the module.
---@param description string The description of the module.
---@param defaultEventName string The name of default event which this module will update on.
---@param defaultEnable boolean Whether the module should be enabled by default.
---@param priority? number The priority of the module in the system queue.
HorizonModule = function (name, description, defaultEventName, defaultEnable, priority)
    ---@class HorizonModule Creates a new Horizon Module instance.
    local this = {}
    setmetatable(this, { __call = function(ref, ...) ref.Update(...) end, _name = "HorizonModule" })

    ---The name of the module.
    ---@type string
    this.Name = name or ""

    ---The system tags of the module.
    ---@type string
    this.Tags = ""

    ---Array of the module's dependencies.
    ---@type table
    this.Dependencies = {}

    ---Enabled status of the module.
    ---@type boolean
    this.Enabled = false

    if priority == nil then
        this.Priority = 1
    else
        this.Priority = priority
    end

    ---The confuguration of the module.
    ---@type table
    this.Config = {}

    ---Method which is called when the event it is registered to is raised.
    ---@param eventType string The name of the event which initiated the method call.
    ---@param deltaTime number The time elapsed since last call.
    function this.Update(eventType, deltaTime) end

    ---Perform initialization of the module. Note that this method may be called more than once.
    ---@return boolean Success Whether the module initiated successfully.
    function this.Init()
        return true
    end

    ---Enables the module.
    function this.Enable() this.Enabled = true end

    ---Disables the module.
    function this.Disable() this.Enabled = false end

    ---Toggles the enabled state of the module.
    function this.ToggleEnabled() if this.Enabled then this.Disable() else this.Enable() end end

    ---Registers this module to be managed by HorizonCore
    function this.Register()
        if defaultEnable ~= nil then this.Enabled = defaultEnable end
        if defaultEventName then
            Horizon.Event[defaultEventName].Add(this)
        end
    end

    ---Unregisters this module from HorizonCore
    function this.Unregister()
        if defaultEventName then
            if defaultEnable then this.Enabled = false end
            Horizon.Event[defaultEventName].Remove(this)
        end
    end

    Horizon.RegisterModule(this)
    return this
end