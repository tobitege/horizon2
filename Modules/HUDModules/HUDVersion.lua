--@class HUDVersion
--@require HorizonCore
--@require HorizonModule
--@require UIController
--@require UICSS

HUDVersion = (function()
    local this = HorizonModule("HUD Horizon Version", "Error logging for the HUD", "Start", true, 5)
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    ---@diagnostic disable-next-line: undefined-field
    local hud = Horizon.GetModule("UI Controller").Displays[1]
    local Version = UIPanel(90, 98, 10, 2)
    Version.Content = "<uilabel>Horizon " .. Horizon.Version .. "</uilabel>"
    Version.Style = "font-size: 0.85vh"
    hud.AddWidget(Version)
    return true
end)()