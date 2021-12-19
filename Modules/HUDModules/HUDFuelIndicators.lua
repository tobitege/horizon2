--@class HUDFuelIndicators

--@require HorizonCore
--@require HorizonModule
--@require UIController
--@require UICSS
--@require FuelTanks

HUDFuelIndicators =
    (function()
    local this = HorizonModule("HUD Fuel Indicators", "Adds fuel level indicators to the HUD", "Update", true)
    local vec2 = require("cpml/vec2")
    this.Tags = "system,hud"
    this.Config = {
        Position = {
            X = 99,
            Y = 27
        },
        BarWidth = 0.45
    }
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    ---@diagnostic disable-next-line: undefined-field
    local hud = Horizon.GetModule("UI Controller").Displays[1]

    local tankIds = {
        Atmospheric = {},
        Space = {},
        Rocket = {}
    }

    local elementIds = Horizon.Core.getElementIdList()
    for i=1,#elementIds do
        local idType = Horizon.Core.getElementTypeById(elementIds[i])
        idType = idType:lower():gsub(" fuel tank","")
        idType = idType:gsub("^%l", string.upper)
        if tankIds[idType] then
            local eid = elementIds[i]
            local name = Horizon.Core.getElementNameById(eid)
            local tankType = idType
            if tankType == "Atmospheric" then tankType = "Atmosphere" end
            for k,v in pairs(FuelTanks[tankType]) do
                for size in string.gmatch(name, "[^%s]+") do
                    if v.Class == size:upper() then
                        local tbl = tankIds[idType]
                        tbl[#tbl+1] = {
                            Id = eid,
                            Type = v
                        }
                    end
                end
            end
        end
    end

    local minContainerWidth = 2.5

    local bar = UIExpandable(this.Config.Position.X, this.Config.Position.Y)
    bar.Anchor = UIAnchor.TopRight
    bar.Padding = 0.5
    bar.Class = "filled"
    hud.AddWidget(bar)

    local function createTypeContainer(type, tanks, barColor, parent)
        local barSpacing = 0.05
        local headingWidth = math.max(minContainerWidth, #tanks * (this.Config.BarWidth+barSpacing))
        local container = UIPanel(0,0,headingWidth,7.5)
        parent.AddChild(container)
        local heading = UIHeading(0,0,headingWidth,2)
        heading.Content = type
        for i=1,#tanks do
            local cTank = tanks[i]
            local spc = barSpacing
            if i == 1 then spc = 0 end
            local xPos = (i-1)*(this.Config.BarWidth+spc)
            local fBar = UIProgressVertical(xPos, 2.5, (this.Config.BarWidth+0.0075), 5)
            fBar.AlwaysDirty = true
            fBar.BarColor = barColor
            fBar.OnUpdate = function (ref)
                local current = Horizon.Core.getElementMassById(cTank.Id) - cTank.Type.Mass
                --assume max talents
                local max = (cTank.Type.Capacity*2)*cTank.Type.FuelType.Mass
                local pct = (current/max)*100
                fBar.Value = pct
                if pct < 10 then
                    fBar.Style = "background-color: #ff000022"
                else
                    fBar.Style = "background-color: var(--bg)"
                end
            end
            container.AddChild(fBar)
        end
        container.AddChild(heading)

        return container
    end

    local currOffset = 0

    if #tankIds.Atmospheric > 0 then
        local atmo = createTypeContainer("Atmo", tankIds.Atmospheric, "#3283a8", bar)
        currOffset = currOffset + atmo.Width + bar.Padding
    end

    if #tankIds.Space > 0 then
        local space = createTypeContainer("SPCE", tankIds.Space, "#fcba03", bar)
        space.Position.x = currOffset
        currOffset = currOffset + space.Width + bar.Padding
    end

    if #tankIds.Rocket > 0 then
        local rocket = createTypeContainer("RCKT", tankIds.Rocket, "#bf42f5", bar)
        rocket.Position.x = currOffset
    end

    this.Update = function(event, dt, error)
    end

    return this
end)()