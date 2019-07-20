HorizonModule = function (name)
    local this = {}

    local mt = {}
    mt._name = "HorizonModule"
    setmetatable(this, mt)

    this.Name = name or ""
    this.Dependencies = {}
    this.Enabled = false

    function this.Update() end

    function this.Register() end
    function this.Unregister() end

    return this
end