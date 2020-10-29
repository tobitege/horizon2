--@class UIController
--@require HorizonCore
--@require HorizonModule
--@require UI

UIController = (function()
    local this = HorizonModule("UI Controller", "UI Display Driver", "PostUpdate", true, 5)
    this.Displays = {}
    Horizon.HUD = Horizon.HUD or this
    this.Update = function(deltaTime)
        for _,v in ipairs(this.Displays) do
            v.Update()
        end
    end

    this.Add = function(ui)
        table.insert(this.Displays, ui)
    end

    this.Get = function (name)
        for _,v in ipairs(this.Displays) do
            if v.Name == name then return v end
        end
    end

    local handleClick = function (event, dt, ref)
        for _,v in ipairs(this.Displays) do
            if v.Adapter.Slot == ref then
                v.Click()
            end
        end
    end

    Horizon.Event.Click.Add(handleClick)
    return this
end)()
Horizon.RegisterModule(UIController)
