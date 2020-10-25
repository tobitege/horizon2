HUDErrorLog =
    (function()
    local this = HorizonModule("HUD Error Log", "Error logging for the HUD", "Error", true, 5)
    local vec2 = require("cpml/vec2")
    this.Tags = "system,hud,log"
    this.Config = {
        Position = vec2(50, 1.8),
        Width = 30
    }

    local hud = Horizon.GetModule("UI Controller").Displays[1]
    local rollXform = hud.TransformSize(1)

    local base = UIExpandable(this.Config.Position.x - (this.Config.Width * 0.5), this.Config.Position.y)
    base.Class = "filled"
    base.Padding = 0.5
    base.Zindex = -1
    base.OnUpdate = function(ref)
        if #ref.Children > 0 then
            ref.Class = "filled"
        else
            ref.Class = ""
        end
    end
    hud.AddWidget(base)

    local function createWidget(err)
        local w = UIPanel(0, #base.Children * rollXform.y + #base.Children, this.Config.Width - rollXform.x, rollXform.y)
        w.Content = "<uilabel style='height:100%'>" .. err .. "</uilabel>"
        w.Style = "font-size: 0.85vh"
        local closeBtn = UIPanel(this.Config.Width - rollXform.x, 0, rollXform.x, rollXform.y)
        closeBtn.Style = "text-align: center;border: 1px solid var(--primary);background: var(--bg);font-size:1vh;"
        closeBtn.Content = "&times;"
        closeBtn.OnClick = function(ref)
            w.RemoveChild(ref)
            base.RemoveChild(w)
            local i = 0
            local count = #base.Children
            for _, v in ipairs(base.Children) do
                v.Position.y = i * rollXform.y + i
                v.IsDirty = true
                v.Children[1].IsDirty = true
                i = i + 1
            end
            base.IsDirty = true
        end
        w.AddChild(closeBtn)

        base.AddChild(w)
    end

    this.Update = function(event, dt, error)
        system.print(error)
        createWidget(error)
        base.IsDirty = true
    end

    return this
end)()
Horizon.RegisterModule(HUDErrorLog)