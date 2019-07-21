HorizonModule = function (name, defaultEventName, defaultEnable)
    local this = {}
    setmetatable(this, { __call = function(ref, ...) ref.Update(...) end, _name = "HorizonModule" })

    this.Name = name or ""
    this.Dependencies = {}
    this.Enabled = false

    function this.Update(eventType) end

    function this.Register()
        if defaultEnable ~= nil then this.Enabled = defaultEnable end
        if defaultEventName then
            Horizon.Event[defaultEventName].Add(this)
        end
    end

    function this.Unregister()
        if defaultEventName then
            if defaultEnable then this.Enabled = false end
            Horizon.Event[defaultEventName].Remove(this)
        end
    end
    return this
end