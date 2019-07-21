HorizonModule = function (name)
    local this = {}
    setmetatable(this, { __call = function(ref, ...) ref.Update(...) end, _name = "HorizonModule" })

    this.Name = name or ""
    this.Dependencies = {}
    this.Enabled = false

    function this.Update(eventType) end
    function this.Register() end
    function this.Unregister() end
    return this
end