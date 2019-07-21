HorizonModule = function (name)
    local this = {}

    local mt = {
        __call = function(ref, ...) this.Update(...) end,
        _name = "HorizonModule"
    }
    setmetatable(this, mt)

    this.Name = name or ""
    this.Dependencies = {}
    this.Enabled = false

    function this.Update() end
    function this.Register() end
    function this.Unregister() end

    return this
end