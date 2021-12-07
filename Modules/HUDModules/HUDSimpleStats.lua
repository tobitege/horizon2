--@class HUDSimpleStats
--@require HorizonCore
--@require HorizonModule
--@require UIController
--@require ReadingsModule
--@require UICSS
--@require Linq

HUDSimpleStats = (function()
    local this = HorizonModule("HUD Simple Stats", "Simple flight stats","PreUpdate", true, 0)
    local vec2 = require("cpml/vec2")
    this.Tags = "system,hud,data"
    this.Config = {
        Position = vec2(50, 99),
        ---@type string[]
        EnabledReadings = {"Velocity", "Acceleration", "Altitude", "Vertical Velocity", "Atmospheric Density", "G-Force"}
    }
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    ---@type UICore
    ---@diagnostic disable-next-line: undefined-field
    local hud = Horizon.GetModule("UI Controller").Displays[1]
    local xformSize = hud.TransformSize(1.3)

    local base = UIExpandable(this.Config.Position.x, this.Config.Position.y)
    base.Anchor = UIAnchor.BottomCenter
    base.Round = function(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end
    base.Class = "filled"
    base.Padding = 0.5
    local paddingXf = hud.TransformSize(base.Padding)
    hud.AddWidget(base)

    local function splitNumber(num)
        local major = math.floor(num)
        local minor = tonumber(math.floor((num % 1) * 100))
        return {
            Major = major,
            Minor = string.format("%02d", minor)
        }
    end

    ---@param el UIObject
    local function getOffset(el)
        return el.Position.x + el.Width
    end

    local function createDisplay(content, onUpdate)
        local lastPos = Linq(base.Children).Max(getOffset) or 0
        if lastPos ~= 0 then lastPos = lastPos + base.Padding end
        local widget = UIPanel(lastPos,0,5.5,xformSize.y)
        widget.AlwaysDirty = true
        widget.Content = [[<uilabel style="width: 100%;height:100%">]]..content..[[</uilabel>]]
        widget.OnUpdate = onUpdate
        base.AddChild(widget)
    end

    local readingsList = {
        ["Velocity"] = {
            [[V $(Number.Major)<sup>$(Number.Minor)</sup> km/h]],
            function (ref)
                ref.Number = splitNumber(Horizon.Memory.Static.World.Velocity:len()*3.6)
            end
        },
        ["Acceleration"] = {
            [[ΔV $(Number.Major)<sup>$(Number.Minor)</sup> km/h]],
            function (ref)
                ref.Number = splitNumber(Horizon.Memory.Static.World.Acceleration:len()*3.6)
            end
        },
        ["Altitude"] = {
            [[↨ $(Number.Major)<sup>$(Number.Minor)</sup> m]],
            function (ref)
                ref.Number = splitNumber(Horizon.Memory.Static.Ship.Altitude)
            end
        },
        ["Vertical Velocity"] = {
            [[<div style="display: inline-block;transform:rotate(90deg);">⇌ </div> $(Number.Major)<sup>$(Number.Minor)</sup> km/h]],
            function (ref)
                ref.Number = splitNumber(Horizon.Memory.Static.World.VerticalVelocity*3.6)
            end
        },
        ["Atmospheric Density"] = {
            [[☁ $(Number) %]],
            function (ref)
                ref.Number = utils.round(Horizon.Memory.Static.World.AtmosphericDensity*100,0.1)
            end
        },
        ["G-Force"] = {
            [[⇩ $(Number) g]],
            function (ref)
                ref.Number = utils.round(Horizon.Memory.Static.World.G / 9.80666,0.01)
            end
        }
    }

    local settingsBtn = nil
    local settingsPanel = nil

    local fn = {}

    fn.buildSettingsPanel = function ()
        if settingsPanel then hud.RemoveWidget(settingsPanel) end
        local btnPos = settingsBtn.GetAbsolutePos()
        settingsPanel = UIExpandable(btnPos.x+settingsBtn.Width,btnPos.y-paddingXf.y)
        settingsPanel.Zindex = 100
        settingsPanel.Class = "filled"
        settingsPanel.Anchor = UIAnchor.BottomRight
        settingsPanel.Padding = 0.25
        hud.AddWidget(settingsPanel)
        for k,v in pairs(readingsList) do
            local lastPos = Linq(settingsPanel.Children).Max(function(el) return el.Position.y + el.Height + settingsPanel.Padding end) or 0
            local rowXf = hud.TransformSize(1.5)
            local row = UIPanel(0,lastPos,12,rowXf.y)
            row.Style = "background-color: #00000033;padding:0.75em;z-index:100;vertical-align:middle"
            row.Zindex = settingsPanel.Zindex + 1
            row.Content = k
            row.OnEnter = function()
                row.Style = "background-color: #00000055;padding:0.75em;z-index:100;vertical-align:middle"
            end
            row.OnLeave = function()
                row.Style = "background-color: #00000033;padding:0.75em;z-index:100;vertical-align:middle"
            end
            row.OnClick = function ()
                if Linq(this.Config.EnabledReadings).Any(function(val) return val == k end) then
                    this.Config.EnabledReadings = Linq(this.Config.EnabledReadings).Where(function(r) return r ~= k end).ToArray()
                else
                    table.insert(this.Config.EnabledReadings, k)
                end
                row.IsDirty = true
                fn.buildWidgets()
            end

            local checkboxXf = rowXf * 0.6
            local checkbox = UIButton(row.Width-settingsPanel.Padding, rowXf.y * 0.5, checkboxXf.x, checkboxXf.y)
            checkbox.Anchor = UIAnchor.MiddleRight
            checkbox.Zindex = row.Zindex + 1
            checkbox.Class = "filled"
            checkbox.AlwaysDirty = true
            checkbox.OnUpdate = function ()
                if Linq(this.Config.EnabledReadings).Any(function(val) return val == k end) then
                    checkbox.Content = [[<div style="background-color:var(--primary);width:60%;height:60%;margin:0 auto;margin-top:20%;opacity:.5"></div>]]
                else
                    checkbox.Content = ""
                end
            end
            checkbox.OnClick = row.OnClick

            row.AddChild(checkbox)
            settingsPanel.AddChild(row)
        end
    end

    fn.buildSettingsButton = function ()
        if settingsBtn then hud.RemoveWidget(settingsBtn) end
        --force base recalculate
        base._update()
        local basePos = base.GetAbsolutePos()
        local sizeXf = hud.TransformSize(1.3)
        settingsBtn = UIButton(basePos.x+base.Width+base.Padding, basePos.y, sizeXf.x, sizeXf.y)
        settingsBtn.Content = [[<svg viewBox="0 0 24 24" style="height:100%;fill:#fff"><g><path d="M20 12c0-.568-.06-1.122-.174-1.656l1.834-1.612-2-3.464-2.322.786c-.82-.736-1.787-1.308-2.86-1.657L14 2h-4l-.48 2.396c-1.07.35-2.04.92-2.858 1.657L4.34 5.268l-2 3.464 1.834 1.612C4.06 10.878 4 11.432 4 12s.06 1.122.174 1.656L2.34 15.268l2 3.464 2.322-.786c.82.736 1.787 1.308 2.86 1.657L10 22h4l.48-2.396c1.07-.35 2.038-.92 2.858-1.657l2.322.786 2-3.464-1.834-1.613c.113-.535.174-1.09.174-1.657zm-8 4c-2.21 0-4-1.79-4-4s1.79-4 4-4 4 1.79 4 4-1.79 4-4 4z"/></g></svg>]]
        settingsBtn.Class = "filled"
        settingsBtn.OnClick = function ()
            if settingsPanel then
                hud.RemoveWidget(settingsPanel)
                settingsPanel = nil
            else
                fn.buildSettingsPanel()
            end
        end
        hud.AddWidget(settingsBtn)
    end

    fn.buildWidgets = function ()
        base.Children = {}
        for i=1,#this.Config.EnabledReadings do
            local key = this.Config.EnabledReadings[i]
            if readingsList[key] then
                local data = readingsList[key]
                createDisplay(data[1], data[2])
            end
        end
        base.IsDirty = true
        fn.buildSettingsButton()
    end

    fn.buildWidgets()

    return this
end)()