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
    local Version = UILabel(100, 0, 12, 1.1)
    Version.Anchor = UIAnchor.TopRight
    Version.Content = "Horizon " .. Horizon.Version
    Version.Style = "font-size: 0.75vh"
    hud.AddWidget(Version)
    return true
end)()