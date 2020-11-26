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
        Position = vec2(50, 99),
    }
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    
    local hud = Horizon.GetModule("UI Controller").Displays[1]
    
    local base = UIPanel(this.Config.Position.x, this.Config.Position.y, 33, 3.8)
    base.Memory = Horizon.Memory
    base.Anchor = UIAnchor.BottomCenter
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
        
    local sA = UIPanel(12,0,5.5,rollXform.y)
    sA.AlwaysDirty = true
    sA.OnUpdate = function()
        sA.Number = splitNumber(Horizon.Memory.Static.Ship.Altitude)
    end
    sA.Content = [[<uilabel style="width: 100%;height:100%">↨ $(Number.Major)<sup>$(Number.Minor)</sup> m</uilabel>]]
    base.AddChild(sA)
    
    local vV = UIPanel(18,0,5.5,rollXform.y)
    vV.AlwaysDirty = true
    vV.OnUpdate = function()
        vV.Number = splitNumber(Horizon.Memory.Static.World.VerticalVelocity*3.6)
    end
    vV.Content = [[<uilabel style="width: 100%;height:100%"><div style="display: inline-block;transform:rotate(90deg);">⇌ </div> $(Number.Major)<sup>$(Number.Minor)</sup> km/h</uilabel>]]
    base.AddChild(vV)
    
    local aD = UIPanel(24,0,4,rollXform.y)
    aD.AlwaysDirty = true
    aD.OnUpdate = function()
        aD.Number = utils.round(Horizon.Memory.Static.World.AtmosphericDensity*100,0.1)
    end
    aD.Content = [[<uilabel style="width: 100%;height:100%">☁ $(Number) %</uilabel>]]
    base.AddChild(aD)
    
    local gF = UIPanel(28.5,0,3.5,rollXform.y)
    gF.AlwaysDirty = true
    gF.OnUpdate = function()
        gF.Number = utils.round(Horizon.Memory.Static.World.G / 9.80665,0.01)
    end
    gF.Content = [[<uilabel style="width: 100%;height:100%">⇩ $(Number) g</uilabel>]]
    base.AddChild(gF)
    
    
    hud.AddWidget(base)
    
    return this
end)()