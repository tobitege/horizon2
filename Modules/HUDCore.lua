CSS =
    [[
    #horizon {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      font-family: 'Play';
      font-weight: 1;
      font-size: 1vh;
    }
    :root {
      /* 0faea9 */
      --primary: #ae0f12;
      --secondary: #fff;
      --bg: #55555577;
      --bg2: #44444444;
      --border: 0.05em solid var(--secondary);
      --border-primary: 0.05em solid var(--primary);
      --glow: 0 0 0.25vw 0.05vw var(--primary);
      --text-glow: 0 0 0.25vw var(--primary);
      --spacing: 0.25em;
      --warning: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='-10 -10 120 120' preserveAspectRatio='xMidYMid meet'%3E%3Cpath d='M0 100 L50 0 L100 100 L0 100 L50 0' stroke='%23ae0f12' stroke-width='10' fill='none' /%3E%3Crect x='45' y='32' width='10' height='40' fill='%23ae0f12' /%3E%3Ccircle cx='50' cy='85' r='6' fill='%23ae0f12' /%3E%3C/svg%3E");
    }
    * {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    uicursor {
        display: block;
        position: absolute;
        width: 2vh;
        height: 2vh;
        z-index: 999;
    }
    readout {
        display: inline;
        text-shadow: 0 0 0.5vh #000000ff;
        text-align: center;
        color:#fff;
        letter-spacing:0.25px;
        -webkit-text-stroke-width: 2px;
        -webkit-text-stroke-color: #000000bb;
        font-weight: 100;
    }
    panel {
      display: flex;
      flex-direction: column;
      position: absolute;
      letter-spacing: 0.05vw;
      text-transform: uppercase;
    }
    panel.row {
      flex-direction: row;
    }
    panel:not(.row) > *:not(:last-child) {
      margin-bottom: var(--spacing);
    }
    panel.row > *:not(:last-child) {
      margin-right: var(--spacing);
    }
    panel.filled {
        box-sizing: border-box;
        background: var(--bg);
        border: 1px solid #ae0f1233;
        box-sizing: border-box;
    }
    panel.filled::after {
        position: absolute;
        border: 1px solid #ffffff77;
        border-width: 1px 0 0 1px;
        border-radius: 0;
        content: "";
        width: 0.5vmax;
        height: 0.5vmax;
        top: 0px;
        left: 0px;
    }
    panel.filled::before{
        position: absolute; 
        border: 1px solid #ffffff77;
        border-width: 0 1px 1px 0;
        border-radius: 0;
        content: "";
        width: 0.5vmax;
        height: 0.5vmax;
        bottom: 0px;
        right: 0px;
    }
    .left {
      text-align: left;
    }
    .rel {
      position: relative;
    }
    uiprogress {
        height: 0.5vw;
        border-left: var(--border);
        border-right: var(--border);
        background-color: var(--bg);
    }
    uivprogress {
        position: relative;
        border-top: var(--border);
        border-bottom: var(--border);
        background-color: var(--bg);
        width: 0.75em;
        z-index: 10;
    }
    uivprogress > inner {
        position: absolute;
        display: block;
        background-color: var(--primary);
        width: 33%;
        left: 33%;
        bottom: 0.05em;
        box-shadow: var(--glow);
        max-height: calc(100% - 0.05em);
    }
    uiprogress > inner {
        position: relative;
        display: block;
        background-color: var(--primary);
        height: 33%;
        top: 50%;
        left: 0.05em;
        transform: translateY(-33%);
        box-shadow: var(--glow);
        max-width: calc(100% - 0.05em);
        overflow: hidden;
    }
    uiprogress[data-label] {
        margin-left: 1.8em;
    }
    panel.filled > uiprogress[data-label] {
        margin-left: 2.3em;
    }
    panel.filled > uiprogress[data-label]::before {
        left: 1.5em;
    }
    uiprogress[data-label]::before {
        display: block;
        position: absolute;
        left: 0;
        content: attr(data-label);
        color: var(--secondary);
        font-size: 0.74em;
        font-weight: 500;
        padding-top: 0.05em;
        text-shadow: var(--text-glow);
    }
    uispacer {
        display: block;
        height: 1vh;
    }
    uilabel {
        color: var(--secondary);
        font-size: 1.25em;
        letter-spacing: 0;
        border-left: var(--border-primary);
        padding-left: 0.33vw;
        text-transform: uppercase;
        text-shadow: var(--text-glow);
        background: var(--bg2);
        padding-top: 0.25em;
        padding-right: 0.15em;
    }
    uiheading {
        color: var(--secondary);
        position: absolute;
        display: block;
        text-transform: uppercase;
        text-align: center;
        font-size: 1.25em;
        padding: 0.2vmax;
        background: var(--bg);
    }
    uiheading::before {
        content: "";
        left: 0;
        bottom: 0;
        display: block;
        position: absolute;
        background: var(--primary);
        width: 15%;
        height: 0.1em;
        box-shadow: var(--glow);
    }
    uiheading::after {
        content: "";
        right: 0;
        bottom: 0;
        display: block;
        position: absolute;
        background: var(--primary);
        width: calc(85% - 0.2em);
        height: 0.1em;
        box-shadow: var(--glow);
    }
    uiinstrument {
        background: var(--bg);
        border-left: var(--border);
        border-right: var(--border);
    }
    warning {
        display: inline-block;
        background: var(--warning) no-repeat center center;
        margin-bottom: 0.1em;
        height: 0.9em;
        width: 1em;
        vertical-align: bottom;
    }
    warning::after {
        content: "";
        display: inline-block;
        position: absolute;
        height: 0.9em;
        width: 1em;
        background: var(--warning) no-repeat center center;
        filter: blur(0.1em);
    }
]]

HUDObject = function(x, y, width, height, content)
    local this = {}
    local vec2 = require("cpml/vec2")
    local typeof = require("pl/types").type
    setmetatable(this, {_name = "HUDObject"})
    this.Enabled = false
    this.Name = nil
    this.AlwaysDirty = false

    this.Position = vec2(x or 0, y or 0)
    this.Offset = vec2(0, 0)

    this.Width = width or 0
    this.Height = height or 0
    this.Zindex = 0
    this.Padding = 0
    this.Class = ""
    this.Style = ""

    this.Parent = nil
    this.Children = {}
    this.Content = content or ""
    this.IsDirty = true
    this.IsHovered = false
    this.IsPressed = false
    this.Anchoring = {
        TopLeft = false,
        TopRight = false,
        BottomLeft = false,
        BottomRight = false
    }
    this.IsClickable = true

    this.HUD = Horizon.GetModule("HUD Core")
    this.Horizon = Horizon

    this.GUID =
        (function()
        math.randomseed(system.getTime() * 1000000)
        local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
        return string.gsub(
            template,
            "[xy]",
            function(c)
                local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
                return string.format("%x", v)
            end
        )
    end)()

    this._wrapStart = ""
    this._wrapEnd = ""

    local buffer = ""

    function this.Contains(pos)
        local selfPos = this.GetAbsolutePos()
        selfPos.x = selfPos.x + this.Padding
        selfPos.y = selfPos.y + this.Padding

        if
            pos.x >= selfPos.x and pos.x <= selfPos.x + this.Width and pos.y >= selfPos.y and
                pos.y <= selfPos.y + this.Height
         then
            return true
        end
        return false
    end

    function this.GetAbsolutePos()
        local pos = this.Position + this.Offset
        if this.Parent then
            pos = pos + this.Parent.GetAbsolutePos()
            local pad = this.HUD.TransformSize(this.Parent.Padding)
            pos = pos + pad
        end
        return pos
    end

    function this._update()
        if this.Parent ~= nil then
        -- Recalc pos,size based on anchoring, set IsDirty if changed
        end
        if this.Contains(this.HUD.MousePos) then
            if not this.IsHovered then
                this.IsHovered = true
                this.IsDirty = true
                this.OnEnter(this)
            end
            this.IsDirty = true
        else
            if this.IsHovered then
                this.IsHovered = false
                this.IsDirty = true
                this.OnLeave(this)
            end
        end
        this.OnUpdate(this)

        for _, v in ipairs(this.Children) do
            v._update()
        end
    end

    function this.AddChild(child)
        if typeof(child) ~= "HUDObject" then
            error("Trying to add a non-HUDObject")
            return
        end
        for k, v in ipairs(this.Children) do
            if v.GUID == child.GUID then
                error(v.GUID .. " is already a child of" .. this.GUID)
                return
            end
        end
        child.Parent = this
        this.Children[#this.Children + 1] = child
    end

    function this.RemoveChild(child)
        if typeof(child) ~= "HUDObject" then
            error("Trying to remove a non-HUDObject")
            return
        end
        for k, v in ipairs(this.Children) do
            if v.GUID == child.GUID then
                v.Parent = nil
                table.remove(this.Children, k)
                v.Offset = {
                    X = v.Offset.x,
                    Y = v.Offset.y
                }
                return
            end
        end
        error(v.GUID .. " is not a child of" .. this.GUID)
    end

    function this.OnUpdate(scope)
    end
    function this.OnEnter(scope)
    end
    function this.OnLeave(scope)
    end
    function this.OnPress(scope)
    end
    function this.OnRelease(scope)
    end
    function this.OnClick(scope)
    end
    function this.OnScroll(scope, delta)
    end
    function this.Render(scope)
        local anyDirty = scope.IsDirty
        for k, v in ipairs(scope.Children) do
            if v.AlwaysDirty or v.IsDirty then
                anyDirty = true
                break
            end
        end
        if scope.AlwaysDirty or anyDirty then
            buffer = template.substitute(scope._wrapStart .. scope.Content .. scope._wrapEnd, scope)
            for k, v in ipairs(scope.Children) do
                buffer = buffer .. v.Render(v)
            end
            scope.IsDirty = false
        end
        return buffer
    end

    return this
end

HUDPanel = function(x, y, width, height, content)
    local this = HUDObject(x, y, width, height, content)
    this._wrapStart =
        [[<panel style="position:absolute;left:$(GetAbsolutePos().x)vw;top:$(GetAbsolutePos().y)vh;width:$(Width)vw;height:$(Height)vh;z-index:$(Zindex);$(Style)" class="$(Class)">]]
    this._wrapEnd = [[</panel>]]
    return this
end

HUDExpandable = function(x, y, content)
    local this = HUDPanel(x, y, width, height, content)
    this.Width = 0
    this.Height = 0

    local baseUpdate = this._update

    function this._update()
        local maxHeight = 0
        local maxWidth = 0
        for k, v in ipairs(this.Children) do
            local w = v.Position.x + v.Width
            local h = v.Position.y + v.Height
            if w > maxWidth then
                maxWidth = w
                this.IsDirty = true
            end
            if h > maxHeight then
                maxHeight = h
                this.IsDirty = true
            end
        end
        if this.IsDirty then
            local pad = this.HUD.TransformSize(this.Padding) * 2
            this.Width = maxWidth + pad.x
            this.Height = maxHeight + pad.y
        end
        baseUpdate()
    end

    return this
end

HUDFillHorizontal = function(x, y, width, height, content)
    local this = HUDPanel(x, y, width, height, content)

    local baseUpdate = this._update
    function this._update()
        if this.Parent then
            local desired = this.Parent.Width - (this.Parent.Padding * 2)
            if this.Width ~= desired then
                this.Width = this.Parent.Width - (this.Parent.Padding * 2)
                this.IsDirty = true
            end
        end
        baseUpdate()
    end

    return this
end

HUDCore =
    (function(CSS)
    local template = require("pl/template")
    local this = HorizonModule("HUD Core", "Heads Up Display core driver","PostUpdate", true, 5)
    local vec2 = require("cpml/vec2")
    local typeof = require("pl/types").type
    this.Tags = "hud,core"
    this.Config = {
        EnableMouse = true,
        MouseSensitivity = 1.2,
        ScreenSize = vec2(2560, 1440)
    }
    this.Widgets = {}
    this.CSS = CSS

    local header = ""
    if this.CSS then
        header = "<style>" .. this.CSS .. "</style>"
    end

    local MousePos = vec2(this.Config.ScreenSize.x * 0.5, this.Config.ScreenSize.y * 0.5)
    this.MousePos = vec2(this.Config.ScreenSize.x * 0.5, this.Config.ScreenSize.y * 0.5)

    system.showScreen(1)
    system.freeze(1)
    Horizon.Controller.hide()

    function contains(obj, pos)
        if pos.x > obj.x and pos.x < obj.x + obj.Width and pos.y > obj.y and pos.y < obj.y + obj.Height then
            return true
        end
        return false
    end

    local function xform(pos)
        return vec2((pos.x / this.Config.ScreenSize.x) * 100, (pos.y / this.Config.ScreenSize.y) * 100)
    end

    function processMouse(x, y)
        MousePos.x = MousePos.x + (x * this.Config.MouseSensitivity)
        MousePos.y = MousePos.y + (y * this.Config.MouseSensitivity)
        if MousePos.x < 0 then
            MousePos.x = 0
        end
        if MousePos.x > this.Config.ScreenSize.x then
            MousePos.x = this.Config.ScreenSize.x
        end
        if MousePos.y < 0 then
            MousePos.y = 0
        end
        if MousePos.y > this.Config.ScreenSize.y then
            MousePos.y = this.Config.ScreenSize.y
        end
        this.MousePos = xform(MousePos)
    end

    function this.TransformSize(size)
        return vec2(size, size + ((size / HUDCore.Config.ScreenSize.y) * 1000))
    end

    function this.Update(eventType, deltaTime)
        processMouse(system.getMouseDeltaX(), system.getMouseDeltaY())
        local buffer = header .. [[<div id="horizon">]]
        for k, v in ipairs(this.Widgets) do
            v._update()
            buffer = buffer .. v.Render(v)
        end
        system.setScreen(buffer .. "</div>")
    end

    local function getContained(objArray, targetArr)
        if not targetArr then
            targetArr = {}
        end
        for _, v in ipairs(objArray) do
            if v.Contains(this.MousePos) and v.IsClickable then
                table.insert(targetArr, v)
            end
            if #v.Children > 0 then
                getContained(v.Children, targetArr)
            end
        end
        return targetArr
    end

    function this.Click()
        local contained = getContained(this.Widgets)
        local top = nil
        for _, v in ipairs(contained) do
            if not top or top.Zindex < v.Zindex then
                top = v
            end
        end
        if top then
            top.OnClick(top)
        end
    end

    function this.AddWidget(widget)
        if typeof(widget) ~= "HUDObject" then
            return
        end
        for k, v in ipairs(this.Widgets) do
            if v.GUID == widget.GUID then
                return
            end
        end
        table.insert(this.Widgets, widget)
    end

    function this.RemoveWidget(widget)
        if typeof(widget) ~= "HUDObject" then
            return
        end
        for k, v in ipairs(this.Widgets) do
            if v.GUID == widget.GUID then
                table.remove(this.Widgets, k)
                return
            end
        end
    end

    -- fixes for template builtin
    debug = {traceback = traceback}
    plutils.load = function(code, name, mode, env)
        local err, fn = pcall(load(code, nil, "t", env))
        return function()
            return fn
        end, err
    end

    return this
end)(CSS)
Horizon.RegisterModule(HUDCore)

local cursor = HUDObject(50, 50)
cursor.OnUpdate = function(this)
    this.Position.x = HUDCore.MousePos.x
    this.Position.y = HUDCore.MousePos.y
    this.IsDirty = true
end
cursor.Content =
    [[
<uicursor style="left: $(Position.x)vw;top: $(Position.y)vh">
	<svg xmlns="http://www.w3.org/2000/svg" stroke="black" stroke-width="1" preserveAspectRatio="xMidYMid" viewBox="0 0 100 100"><path fill="#ae0f12" fill-rule="evenodd" d="M30 73L0 100V0l100 100-70-27zM9 80l19-17 37 14L9 21v59z"/></svg>
</uicursor>
]]
cursor.IsClickable = false
HUDCore.AddWidget(cursor)

-- Actual HUD WIP
local Version = HUDPanel(90, 98, 10, 2)
Version.Content = "<uilabel>Horizon " .. Horizon.Version .. "</uilabel>"
Version.Style = "font-size: 0.85vh"
HUDCore.AddWidget(Version)

HUDErrorLog =
    (function()
    local this = HorizonModule("HUD Error Log", "Error logging for the HUD","Error", true, 5)
    local vec2 = require("cpml/vec2")
    this.Tags = "system,hud,log"
    this.Config = {
        Position = vec2(50, 1.8),
        Width = 30
    }

    local hud = Horizon.GetModule("HUD Core")
    local rollXform = hud.TransformSize(1)

    local base = HUDExpandable(this.Config.Position.x - (this.Config.Width * 0.5), this.Config.Position.y)
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
        local w = HUDPanel(0, #base.Children * rollXform.y + #base.Children, this.Config.Width - rollXform.x, rollXform.y)
        w.Content = "<uilabel style='height:100%'>" .. err .. "</uilabel>"
        w.Style = "font-size: 0.85vh"
        local closeBtn = HUDPanel(this.Config.Width - rollXform.x, 0, rollXform.x, rollXform.y)
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

HUDSimpleStats = (function()
    local this = HorizonModule("HUD Simple Stats", "Simple flight stats","PreUpdate", true, 0)
    local vec2 = require("cpml/vec2")
    this.Tags = "system,hud,data"
    this.Config = {
        Position = vec2(40.75, 94),
    }
    local hud = Horizon.GetModule("HUD Core")

    local base = HUDPanel(this.Config.Position.x, this.Config.Position.y, 18.5, 3.8)
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
    local velocity = HUDPanel(0,0,5.5,rollXform.y)
    velocity.AlwaysDirty = true
    velocity.OnUpdate = function()
        velocity.Number = splitNumber(Horizon.Memory.Static.World.Velocity:len()*3.6)
    end
    velocity.Content = [[<uilabel style="width: 100%;height:100%">V $(Number.Major)<sup>$(Number.Minor)</sup> km/h</uilabel>]]
    base.AddChild(velocity)

    local dV = HUDPanel(6,0,5.5,rollXform.y)
    dV.AlwaysDirty = true
    dV.OnUpdate = function()
        dV.Number = splitNumber(Horizon.Memory.Static.World.Acceleration:len()*3.6)
    end
    dV.Content = [[<uilabel style="width: 100%;height:100%">ΔV $(Number.Major)<sup>$(Number.Minor)</sup> km/h</uilabel>]]
    base.AddChild(dV)

    local vV = HUDPanel(12,0,5.5,rollXform.y)
    vV.AlwaysDirty = true
    vV.OnUpdate = function()
        vV.Number = splitNumber(Horizon.Memory.Static.World.VerticalVelocity)
    end
    vV.Content = [[<uilabel style="width: 100%;height:100%">↕ $(Number.Major)<sup>$(Number.Minor)</sup> km/h</uilabel>]]
    base.AddChild(vV)


    hud.AddWidget(base)

    return this
end)()
Horizon.RegisterModule(HUDSimpleStats)

HUDArtificialHorizon = (function()
    local this = HorizonModule("HUD Artificial Horizon", "Artificial Horizon", "PreUpdate", true, 0)
    local vec2 = require("cpml/vec2")
    this.Tags = "system,hud,data"
    
    local rollSVG = [[<svg viewBox="0 0 598 598" style="transform: rotate($(-Memory.Ship.Roll)deg)"><defs><clipPath id="a" transform="translate(-1 -1)"><path d="M0 300h600v300H0z" class="a"/></clipPath><clipPath id="b" transform="translate(-1 -1)"><path d="M0 0h600v300H0z" class="a"/></clipPath><style>.a{fill:none}.c{fill:#fff}.g{fill:#ae0f12}</style></defs><g clip-path="url(#a)"><path d="M300 30l2.29-8.12L300 0v30zM298 30l-2.28-8.12L298 0v30zM30 298l-8.12-2.28L0 298h30zM30 300l-8.12 2.29L0 300h30zM298 568l-2.28 8.12L298 598v-30zM300 568l2.29 8.12L300 598v-30zM568 300l8.12 2.29L598 300h-30zM568 298l8.12-2.28L598 298h-30zM91.11 91.11l13.55 11.74 2.72 4.53-4.53-2.72-11.74-13.55zM91.11 506.89l11.74-13.55 4.53-2.71-2.72 4.52-13.55 11.74zM506.89 506.89l-13.55-11.74-2.71-4.52 4.52 2.71 11.74 13.55zM506.89 91.11l-11.74 13.55-4.52 2.72 2.71-4.53 13.55-11.74zM188.19 31.49l3.08 10.15 1.92-.8-5-9.35zM31.49 409.81l10.15-3.08-.8-1.92-9.35 5zM409.81 566.51l-3.08-10.14-1.92.79 5 9.35zM566.51 188.19l-10.14 3.08.79 1.92 9.35-5zM31.49 188.19l9.35 5 .8-1.92-10.15-3.08zM188.19 566.51l5-9.35-1.92-.79-3.08 10.14zM566.51 409.81l-9.35-5-.79 1.92 10.14 3.08zM409.81 31.49l-5 9.35 1.92.8 3.08-10.15zM242.83114619 21.80721805l1.96157056-.39018065.75109774 3.77602333-1.96157056.39018065zM22.29773466 355.67013528l-.39018064-1.96157056 3.77602333-.75109774.39018064 1.96157056zM356.16766776 576.19117602l-1.96157056.39018064-.75109774-3.77602332 1.96157056-.39018065zM576.70150049 242.3316628l.39018064 1.96157057-3.77602333.75109774-.39018064-1.96157057zM141.06616025 64.5945224l1.66293922-1.11114047 2.1389454 3.201158-1.66293922 1.11114047zM65.08622624 457.4426866l-1.11114046-1.66293922 3.201158-2.1389454 1.11114047 1.66293923zM457.93266807 533.4104826l-1.66293923 1.11114047-2.1389454-3.201158 1.66293923-1.11114048zM533.92050114 140.57062309l1.11114047 1.66293922-3.201158 2.1389454-1.11114047-1.66293922zM63.42062458 143.0587569l1.11114047-1.66293922 3.201158 2.1389454-1.11114046 1.66293922zM143.56247801 535.08548144l-1.66293922-1.11114046 2.1389454-3.20115801 1.66293922 1.11114047zM535.58176033 454.94141596l-1.11114047 1.66293922-3.201158-2.1389454 1.11114046-1.66293922zM455.44513707 62.9243457l1.66293923 1.11114047-2.1389454 3.201158-1.66293923-1.11114046zM21.7197539 245.27862541l.39018065-1.96157056 3.77602333.75109774-.39018064 1.96157056zM245.77784687 576.78453541l-1.96157056-.39018064.75109774-3.77602333 1.96157056.39018064zM577.28531396 352.7278638l-.39018064 1.96157057-3.77602333-.75109774.39018064-1.96157056zM352.8374 22.9384l1.96.4-.77 3.773-1.96-.4z" class="c"/><circle cx="299.5" cy="299" r="282.73" fill="none" stroke="#fff" stroke-miterlimit="10" stroke-opacity=".3"/><circle cx="299.5" cy="299" r="278.93" fill="none" stroke="#fff" stroke-miterlimit="10" stroke-width=".5"/></g><g clip-path="url(#b)"><path d="M300 30l2.29-8.12L300 0v30zM298 30l-2.28-8.12L298 0v30zM30 298l-8.12-2.28L0 298h30zM30 300l-8.12 2.29L0 300h30zM298 568l-2.28 8.12L298 598v-30zM300 568l2.29 8.12L300 598v-30zM568 300l8.12 2.29L598 300h-30zM568 298l8.12-2.28L598 298h-30zM91.11 91.11l13.55 11.74 2.72 4.53-4.53-2.72-11.74-13.55zM91.11 506.89l11.74-13.55 4.53-2.71-2.72 4.52-13.55 11.74zM506.89 506.89l-13.55-11.74-2.71-4.52 4.52 2.71 11.74 13.55zM506.89 91.11l-11.74 13.55-4.52 2.72 2.71-4.53 13.55-11.74zM188.19 31.49l3.08 10.15 1.92-.8-5-9.35zM31.49 409.81l10.15-3.08-.8-1.92-9.35 5zM409.81 566.51l-3.08-10.14-1.92.79 5 9.35zM566.51 188.19l-10.14 3.08.79 1.92 9.35-5zM31.49 188.19l9.35 5 .8-1.92-10.15-3.08zM188.19 566.51l5-9.35-1.92-.79-3.08 10.14zM566.51 409.81l-9.35-5-.79 1.92 10.14 3.08zM409.81 31.49l-5 9.35 1.92.8 3.08-10.15zM242.83114619 21.80721805l1.96157056-.39018065.75109774 3.77602333-1.96157056.39018065zM22.29773466 355.67013528l-.39018064-1.96157056 3.77602333-.75109774.39018064 1.96157056zM356.16766776 576.19117602l-1.96157056.39018064-.75109774-3.77602332 1.96157056-.39018065zM576.70150049 242.3316628l.39018064 1.96157057-3.77602333.75109774-.39018064-1.96157057zM141.06616025 64.5945224l1.66293922-1.11114047 2.1389454 3.201158-1.66293922 1.11114047zM65.08622624 457.4426866l-1.11114046-1.66293922 3.201158-2.1389454 1.11114047 1.66293923zM457.93266807 533.4104826l-1.66293923 1.11114047-2.1389454-3.201158 1.66293923-1.11114048zM533.92050114 140.57062309l1.11114047 1.66293922-3.201158 2.1389454-1.11114047-1.66293922zM63.42062458 143.0587569l1.11114047-1.66293922 3.201158 2.1389454-1.11114046 1.66293922zM143.56247801 535.08548144l-1.66293922-1.11114046 2.1389454-3.20115801 1.66293922 1.11114047zM535.58176033 454.94141596l-1.11114047 1.66293922-3.201158-2.1389454 1.11114046-1.66293922zM455.44513707 62.9243457l1.66293923 1.11114047-2.1389454 3.201158-1.66293923-1.11114046zM21.7197539 245.27862541l.39018065-1.96157056 3.77602333.75109774-.39018064 1.96157056zM245.77784687 576.78453541l-1.96157056-.39018064.75109774-3.77602333 1.96157056.39018064zM577.28531396 352.7278638l-.39018064 1.96157057-3.77602333-.75109774.39018064-1.96157056zM352.8374 22.9384l1.96.4-.77 3.773-1.96-.4z" class="g"/><circle cx="299.5" cy="299" r="282.73" fill="none" stroke="#ae0f12" stroke-miterlimit="10" stroke-opacity=".3"/><circle cx="299.5" cy="299" r="278.93" fill="none" stroke="#ae0f12" stroke-miterlimit="10" stroke-width=".5"/></g></svg>]]
    local pitchSVG = [[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 1.5 20.18 721.5"><path fill="#fff" d="M10.09 720l-10 1h20l-10-1zM10.09 724l10-1h-20l10 1zM9.734 721.996l.354-.354.354.354-.354.353zM10.09 540l-10 1h20l-10-1zM10.09 544l10-1h-20l10 1zM9.735 541.997l.354-.354.353.354-.353.353zM10.09 360l-10 1h20l-10-1zM10.09 364l10-1h-20l10 1zM9.736 361.997l.354-.353.353.353-.353.354zM10.09 180l-10 1h20l-10-1zM10.09 184l10-1h-20l10 1zM9.737 181.998l.353-.353.354.353-.354.354zM10.09 0l-10 1h20l-10-1zM10.09 4l10-1h-20l10 1zM9.738 1.999l.353-.354.354.354-.354.353z"/><path fill="none" stroke="#fff" stroke-miterlimit="10" stroke-width=".25" d="M.09 634.5l2.5-2.5h15l2.5 2.5M.09 629.5l2.5 2.5h15l2.5-2.5M.09 454.5l2.5-2.5h15l2.5 2.5M.09 449.5l2.5 2.5h15l2.5-2.5M.09 274.5l2.5-2.5h15l2.5 2.5M.09 269.5l2.5 2.5h15l2.5-2.5M.09 94.5l2.5-2.5h15l2.5 2.5M.09 89.5l2.5 2.5h15l2.5-2.5M.09 319.5l2.5-2.5h15l2.5 2.5M.09 224.5l2.5 2.5h15l2.5-2.5M.09 404.5l2.5 2.5h15l2.5-2.5M.09 584.5l2.5 2.5h15l2.5-2.5M.09 44.5l2.5 2.5h15l2.5-2.5M.09 499.5l2.5-2.5h15l2.5 2.5M.09 679.5l2.5-2.5h15l2.5 2.5M.09 139.5l2.5-2.5h15l2.5 2.5M6.09 24.5h8M6.09 69.5h8M6.09 114.5h8M6.09 159.5h8M6.09 204.5h8M6.09 249.5h8M6.09 294.5h8M6.09 339.5h8M6.09 384.5h8M6.09 429.5h8M6.09 474.5h8M6.09 519.5h8M6.09 564.5h8M6.09 609.5h8M6.09 654.5h8M6.09 699.5h8"/><path fill="none" stroke="#fff" stroke-dasharray=".23 11.02" stroke-miterlimit="10" d="M10.09 1.87v720"/></svg>]]
    --style="transform: translateY(-50%) translateY($(Height*0.5)vh) rotate($(-Memory.Ship.Roll)deg) scale(1.5)"
    local horizonSVG = [[<svg xmlns="http://www.w3.org/2000/svg" style="transform: translateY(-50%) translateY($(Height*0.5)vh) rotate($(-Memory.Ship.Roll)deg) scale(1.5)" viewBox="0 0 600 24.25"><path fill="none" stroke="#fff" stroke-miterlimit="10" stroke-width=".25" d="M600 12.13H340l-20-12h-40l-20 12-260 .5"/><path fill="none" stroke="#fff" stroke-miterlimit="10" stroke-width=".25" d="M0 12.13h260l20 12h40l20-12h260"/><path fill="#fff" d="M280 3.2l-15.13 8.93L280 20.54l-14.47-8.41L280 3.2zM320 3.2l15.13 8.93L320 20.54l14.47-8.41L320 3.2z"/><path fill="#fff" stroke="#fff" stroke-miterlimit="10" stroke-opacity=".4" stroke-width=".25" d="M265.53 12.13h68.94"/></svg>]]

    local hud = Horizon.GetModule("HUD Core")
    local rollXform = hud.TransformSize(22)
    local roll = HUDPanel(50 - (rollXform.x * 0.5), 50 - (rollXform.y * 0.5), rollXform.x, rollXform.y)
    roll.Round = function(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end
    roll.Memory = Horizon.Memory.Static
    roll.AlwaysDirty = true
    roll.Content =  [[<panel style="position:fixed;width:$(Width)vw;height:$(Height)vh;-webkit-mask-image:-webkit-radial-gradient(rgba(0,0,0,1) 50%, rgba(0,0,0,0) 65%)">]]..
                    horizonSVG..
                    [[</panel>
                        <panel style="position:fixed;width:$(Width)vw;height:$(Height)vh;-webkit-mask-image:-webkit-linear-gradient(bottom, rgba(0,0,0,1) 40%, rgba(0,0,0,0) 60%)">]]..
                    rollSVG..
                    [[</panel>]]
    local rollText = HUDPanel((rollXform.x * 0.5) - 1.99, rollXform.y, 4,4)
    rollText.Memory = Horizon.Memory.Static
    rollText.Transform = function(roll)
        if roll > 180 then roll = roll - 360 end
        local mult = 10
        local roll = math.floor(roll * mult + 0.5) / mult
        return math.abs(roll)
    end
    rollText.Content = [[<readout>$(Transform(Memory.Ship.Roll))</readout>
    <div style="position:absolute;width:4vw;height:4vh;top:1vh;">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2.57 23" style="display: block;height:2vh;margin: 0 auto;"><path fill="#fff" d="M1.28 0l1.29 17.88L1.28 23 0 17.88 1.28 0z"/></svg>
    </div>]]
    rollText.AlwaysDirty = true
    roll.AddChild(rollText)

    local pitchXform = hud.TransformSize(30)
    local pitch = HUDPanel(50 - (pitchXform.x * 0.5),50 - (pitchXform.y * 0.5),pitchXform.x,pitchXform.y)
    pitch.Memory = Horizon.Memory.Static
    pitch.AlwaysDirty = true
    pitch.Style = [[-webkit-mask-image: -webkit-radial-gradient(rgba(0,0,0,1) 25%, rgba(0,0,0,0) 40%)]]
    pitch.Transform = function(pitch)
        pitch = (pitch % 360) / 360
        return -25 + (math.abs(pitch) * 50)
    end
    pitch.Content = [[
        <panel style="position:fixed;width:$(Width)vw;height:$(Height)vh;transform: scale(2.5) rotate($(-Memory.Ship.Roll)deg) translateY($(Transform(-Memory.Ship.Pitch))%)">
        ]].. pitchSVG ..[[
        </panel>
    ]]

    local pitchText = HUDPanel((pitchXform.x * 0.5) - 2,(pitchXform.y * 0.5) + 1.5, 4,3)
    pitchText.AlwaysDirty = true
    pitchText.Memory = Horizon.Memory.Static
    pitchText.Transform = function(pitch)
        pitch = pitch % 180
        if pitch > 90 then pitch = pitch - 180 end
        local mult = 10
        local pitch = math.floor(pitch * mult + 0.5) / mult
        return math.abs(pitch)
    end
    pitchText.Content = [[<readout>$(Transform(Memory.Ship.Pitch))</readout>]]
    pitch.AddChild(pitchText)

    hud.AddWidget(pitch)
    hud.AddWidget(roll)

    return this
end)()
Horizon.RegisterModule(HUDArtificialHorizon)

GameHUDRemover = (function()
    local this = HorizonModule("Stock HUD remover", "Removes the stock game HUD", "Start", true, 0)

    this.Stop = function()
        system.print("Showing UI")
        system.print([[
            <style>
            #reticle_crosshair_wrapper,
            #action_bar,
            #BuildHelperButtonZone,
            #main_chat_notification_icon,
            #persistent_notification,
            #playerStatus_wrapper,
            #custom_screen_click_layer,
            #minimap_bezel,
            #minimap_face,
            #clip_mask,
            #minimap_blips
            { display: block !important; }
            #minimap {
                width: 23.14814815vh;
                height: 23.14814815vh;
                top: 2.77777778vh;
                right: 2.77777778vh;
                z-index: 1;
            }
            #main-chat, #main-chat > * {
                user-select: none !important;
                pointer-events: all !important;
            }
            #main-chat > .message_queue {
                background: rgba(0, 10, 26, 0.6) !important;
            }
            </style>
        ]])
    end
    this.Update = function()
        system.print("Hiding UI")
        system.print([[
            <style>
                #reticle_crosshair_wrapper,
                #action_bar,
                #BuildHelperButtonZone,
                #main_chat_notification_icon,
                #persistent_notification,
                #playerStatus_wrapper,
                #custom_screen_click_layer,
                #minimap_bezel,
                #minimap_face,
                #clip_mask,
                #minimap_blips
                { display: none !important; }
                #minimap {
                    width: 20vh;
                    height: 20vh;
                    top: -1vh;
                    right: calc(50vw - (20vh / 2));
                    z-index: -100;
                }
                #main-chat, #main-chat > * {
                    user-select: all !important;
                    -webkit-user-select: all !important;
                    pointer-events: all !important;
                    cursor: text !important;
                }
                #main-chat > .message_queue {
                    background: transparent !important;
                }
            </style>
        ]])
    end

    Horizon.Event.Stop.Add(this.Stop)

    return this
end)()
Horizon.RegisterModule(GameHUDRemover)