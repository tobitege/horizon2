-- package.cpath = package.cpath .. ";C:\\Users\\Otixa\\Desktop\\DUDev\\Horizon2\\socket.dll"
print(os.time())
local socket = require("socket.core")
print(require("socket.http").request{ url = "http://www.google.com" });
print("kk")
--types = require("pl/types")


function HorizonDelegate(eventType)
    local typeof = types.type
    local this = {}
    this.Delegates = {}

    function this.Add(f)
        if typeof(f) ~= "HorizonModule" then error("[HorizonDelegate] Unable to add callback - not a HorizonModule") return end
        for i=1,#this.Delegates do
            if this.Delegates[i] == f then return false end
        end
        table.insert(this.Delegates, f)
        return true
    end

    function this.Remove(f)
        if typeof(f) ~= "HorizonModule" then error("[HorizonDelegate] Unable to remove callback - not a HorizonModule") return end
        for i=1,#this.Delegates do
            if this.Delegates[i] == f then
                table.remove(this.Delegates, i)
                return true
            end
        end
        return false
    end

    function this.Call(...)
        for i=1,#this.Delegates do
            if this.Delegates[i].Enabled then this.Delegates[i](eventType, ...) end
        end
    end

    function this.Count() return #this.Delegates end

    setmetatable(this, {
        __call = function(ref, ...) this.Call(...) end,
        __add = function(left, right)
            if left == this then this.Add(right) return this end
            if right == this then this.Add(left) return this end
            return this
            end,
        __sub = function(left, right)
            if left == this then this.Remove(right) return this end
            if right == this then this.Remove(left) return this end
            return this
            end,
        __tostring = function() return "EventDelegate(" .. eventType .. ", #".. #this.Delegates ..")" end
        })

    return this
end

Horizon = (function (core, controller)
    local this = {}
    this.Core = core
    this.Controller = controller
    this.Modules = {}
    this.Memory = {
        Static = {},
        Dynamic = {
            Ship = {
                Thrust = vec3(0,0,0),
                Rotation = vec3(0,0,0),
                Tags = "all,brake"
            },
            Settings = {}
        }
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
        Error = HorizonDelegate("error")
    }

    setmetatable(this.Memory.Static, {__index={}, __newindex=function() end})

    function this.RegisterModule(module)
        if types.type(module) ~= "HorizonModule" then return end
        table.insert(this.Modules, module)
        module.Register()
    end

    function this.UnregisterModule(module)
        if types.type(module) ~= "HorizonModule" then return end
        for k,v in ipairs(this.Modules) do
            if v.Name == module.Name then 
                table.remove(this.Modules, k)
                v.Unregister()
            end
        end
    end

    function this.GetModule(name)
        for k,v in ipairs(this.Modules) do
            if v.Name == module.Name then 
                return v
            end
        end
        return nil
    end

    setmetatable(this, {
        __add = function (module) this.RegisterModule(module) end,
        __sub = function (module) this.UnregisterModule(module) end,
        __newindex = function(table, key, value) end
    })
    return this
end)(core, unit)