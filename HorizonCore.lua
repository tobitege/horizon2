Horzon = (function (core)
    local this = {}
    this.Core = core
    this.Modules = {}
    this.Memory = {
        Current = {},
        Desired = {}
    }
    setmetatable(this.Memory.Current, {__index={}, __newindex=function (t,k,v) end})

    local mt = {
        __add = function (module)
            if types.type(module) ~= "HorizonModule" then return end
            table.insert(this.Modules, module)
            module.Register()
        end,

        __sub = function (module)
            if types.type(module) ~= "HorizonModule" then return end
            for k,v in ipairs(this.Modules) do
                if v.Name == module.Name then 
                    table.remove(this.Modules, k)
                    v.Deregister()
                end
            end
        end,

        __newindex = function(table, key, value) end
    }
    

    function this.GetModule(name)
        for k,v in ipairs(this.Modules) do
            if v.Name == module.Name then 
                return v
            end
        end
        return nil
    end

    -- Lock table!
    setmetatable(this, mt)
    return this
end)(core)