HorizonModule = function ()
    local self = {}

    local mt = {}
    mt._name = "HorizonModule"
    setmetatable(self, mt)

    self.Name = ""
    self.Dependencies = {}
    self.Enabled = false

    function self.Register()
    end
    function self.Deregister()
    end

    return self
end