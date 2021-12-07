--@class UIController
--@require HorizonCore
--@require HorizonModule
--@require UI

UIController = (function()
    local this = HorizonModule("UI Controller", "UI Display Driver", "PreUpdate", true, 5)
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    this.Displays = {}
    Horizon.HUD = Horizon.HUD or this

    Horizon.Controller.setTimer("UI", 1/30)
    system.showHelper(0)

    this.Update = function(evt, dT, timer)
        if evt == "tick" and timer ~= "UI" then return end
        for i=1,#this.Displays do
            this.Displays[i].Update()
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

    Horizon.Event.Tick.Add(this.Update)
    Horizon.Event.Click.Add(handleClick)
    return this
end)()