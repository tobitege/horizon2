--@class HUDCursor
--@require UI

HUDCursor = (function() 
    local this = HorizonModule("HUD Cursor", "Allows HUD interaction", "Start", true)
    this.Tags = "hud"

    ---@diagnostic disable-next-line: undefined-field
    local hud = Horizon.GetModule("UI Controller").Displays[1]
    local vec2 = require("cpml/vec2")

    local cursorSVG = [[<svg viewBox="0 0 90 100"><g data-name="Layer 2"><path fill="#fff" d="M0 0v100l29.49-22.67L90 90 0 0z" opacity=".8"/><path d="M.25.6l89 89-59.71-12.52h-.05a.25.25 0 00-.15 0L.25 99.49V.6M0 0v100l29.49-22.67L90 90 0 0z" opacity=".3"/></g></svg>]]

    local size = hud.TransformSize(1)

    local cursor = UIPanel(50,50,size.x,size.y)
    cursor.Zindex = 9999
    cursor.Content = cursorSVG
    cursor.AlwaysDirty = true
    cursor.OnUpdate = function(ref)
        ref.Position = hud.MousePos
    end
    cursor.IsClickable = false
    cursor.Enabled = false

    hud.AddWidget(cursor)

    Horizon.Emit.Subscribe("HUD.Click", function()
        local pos = nil
        if not cursor.Enabled then
            pos = vec2(50, 50)
        end
        hud.Click(pos)
    end)

    Horizon.Emit.Subscribe("HUD.Cursor.Toggle", function()
        cursor.Enabled = not cursor.Enabled
    end)

    return this
end
)()