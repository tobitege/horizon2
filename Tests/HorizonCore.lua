return (function()
    local this = {}

    function this.OneTimeSetup()
    end

    function this.Setup()
    end

    function this.Cleanup()
    end

    function this.OneTimeCleanup()
    end

    function this.HorizonModuleInGlobal()
        fluant(_G.HorizonModule).ShouldNotBeNil()
    end

    function this.HorizonInGlobal()
        fluant(_G.Horizon).ShouldNotBeNil()
    end

    function this.HorizonDelegateInGlobal()
        fluant(_G.HorizonDelegate).ShouldNotBeNil()
    end

    function this.ModulesShouldBeTables()
        for k,v in pairs(Horizon.Modules) do
            local t = type(v)
            system.print(k .. " : " .. t)
            assert(t == "HorizonModule", k.." should return a HorizonModule. Is "..type(v))
        end
    end

    return this
end)()