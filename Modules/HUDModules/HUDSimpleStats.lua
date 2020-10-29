--@class HUDSimpleStats
--@require HorizonCore
--@require HorizonModule
--@require UIController
--@require ReadingsModule
--@require UICSS

HUDSimpleStats = (function()
    local this = HorizonModule("HUD Simple Stats", "Simple flight stats","PreUpdate", true, 0)
    local vec2 = require("cpml/vec2")
    this.Tags = "system,hud,data"
    this.Config = {
        Position = vec2(40.75, 94),
    }
    local hud = Horizon.GetModule("UI Controller").Displays[1]

    local base = UIPanel(this.Config.Position.x, this.Config.Position.y, 18.5, 3.8)
    base.Memory = Horizon.Memory
    base.Round = function(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end
    base.Class = "filled"
    base.Padding = 0.5

    local function splitNumber(num)
        local major = math.floor(num)
        local minor = tonumber(math.floor((num % 1) * 100))
        return {
            Major = major,
            Minor = string.format("%02d", minor)
        }
    end

    local rollXform = hud.TransformSize(1.3)
    local velocity = UIPanel(0,0,5.5,rollXform.y)
    velocity.AlwaysDirty = true
    velocity.OnUpdate = function()
        velocity.Number = splitNumber(Horizon.Memory.Static.World.Velocity:len()*3.6)
    end
    velocity.Content = [[<uilabel style="width: 100%;height:100%">V $(Number.Major)<sup>$(Number.Minor)</sup> km/h</uilabel>]]
    base.AddChild(velocity)

    local dV = UIPanel(6,0,5.5,rollXform.y)
    dV.AlwaysDirty = true
    dV.OnUpdate = function()
        dV.Number = splitNumber(Horizon.Memory.Static.World.Acceleration:len()*3.6)
    end
    dV.Content = [[<uilabel style="width: 100%;height:100%">ΔV $(Number.Major)<sup>$(Number.Minor)</sup> km/h</uilabel>]]
    base.AddChild(dV)

    local vV = UIPanel(12,0,5.5,rollXform.y)
    vV.AlwaysDirty = true
    vV.OnUpdate = function()
        vV.Number = splitNumber(Horizon.Memory.Static.World.VerticalVelocity)
    end
    vV.Content = [[<uilabel style="width: 100%;height:100%">↕ $(Number.Major)<sup>$(Number.Minor)</sup> km/h</uilabel>]]
    base.AddChild(vV)


    hud.AddWidget(base)

    return this
end)()