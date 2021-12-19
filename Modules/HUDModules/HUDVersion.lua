--@class HUDVersion
--@require HorizonCore
--@require HorizonModule
--@require UIController
--@require UICSS

HUDVersion = (function()
    local this = HorizonModule("HUD Horizon Version", "Display current version of Horizon", "Start", true, 5)
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    ---@diagnostic disable-next-line: undefined-field
    local hud = Horizon.GetModule("UI Controller").Displays[1]
    local Version = UIPanel(100, 100, 12.5, 1.6)
    Version.Anchor = UIAnchor.BottomRight
    Version.Content = "<uilabel style=\"height:100%\">Horizon " .. Horizon.Version .. "</uilabel>"
    Version.Style = "font-size: 0.8vh"
    hud.AddWidget(Version)
    return true
end)()