--@class HUDCruiseFlight
--@require UI
--@require UIController
--@require CruiseFlightMode

HUDCruiseFlight = (function()
    local this = HorizonModule("HUD Cruise Flight Mode", "Displays flight information for Cruise flight mode", "Start", false)
    this.Tags = "hud"

    ---@diagnostic disable-next-line: undefined-field
    local hud = Horizon.GetModule("UI Controller").Displays[1]
    local cruiseModule = Horizon.GetModule("Cruise Flight Mode")
    local isInit = false
    local cruiseHud = nil

    local function init()
        cruiseHud = UIPanel(10,10,10,10)
        cruiseHud.AlwaysDirty = true
        cruiseHud.TargetSpeed = 0
        cruiseHud.Content = [[Target speed: $(TargetSpeed)]]
        cruiseHud.OnUpdate = function()
            cruiseHud.TargetSpeed = (cruiseModule.Config.TargetSpeed * 3.6)
        end
        hud.AddWidget(cruiseHud)
    end

    local function handleSwitch(evt, mode)
        if mode == "Cruise Flight Mode" then
            this.Enable()
        else
            this.Disable()
        end
    end

    local baseDisable = this.Disable
    local baseEnable = this.Enable

    this.Disable = function()
        baseDisable()
        if isInit then
            hud.RemoveWidget(cruiseHud)
            cruiseHud = nil
            isInit = false
        end
    end

    this.Enable = function()
        baseEnable()
        if not isInit then
            init()
            isInit = true
        end
    end

    Horizon.Emit.Subscribe("FlightMode.Switch", handleSwitch)

    return this
end)()