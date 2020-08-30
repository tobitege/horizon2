CSS = [[
    #horizon {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      font-family: 'Adam';
    }
    :root {
      /* 0faea9 */
      --primary: #ae0f12;
      --secondary: #fff;
      --bg: #ffffff22;
      --bg2: #ffffff11;
      --border: 0.05em solid var(--secondary);
      --border-primary: 0.05em solid var(--primary);
      --glow: 0 0 0.25vw 0.05vw var(--primary);
      --text-glow: 0 0 0.25vw var(--primary);
      --spacing: 0.25em;
      --corner-bg: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100%25' height='10'%3E%3Csvg xmlns='http://www.w3.org/2000/svg' stroke-width='20' viewBox='0 0 100 100' preserveAspectRatio='xMinYMin meet'%3E%3Cpath d='M0 100 L0 0 100 0' fill='none' stroke='%23fff' /%3E%3C/svg%3E%3Csvg xmlns='http://www.w3.org/2000/svg' stroke-width='20' viewBox='0 0 100 100' preserveAspectRatio='xMaxYMin meet'%3E%3Cpath d='M0 0 L0 0 L100 0 L100 100' fill='none' stroke='%23fff' /%3E%3C/svg%3E%3C/svg%3E") no-repeat top center;
      --corner-bg-bottom: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100%25' height='10'%3E%3Csvg stroke-width='20' viewBox='0 0 100 100' preserveAspectRatio='xMinYMax meet'%3E%3Cpath d='M0 0 L0 100 L100 100' fill='none' stroke='%23fff' /%3E%3C/svg%3E%3Csvg stroke-width='20' viewBox='0 0 100 100' preserveAspectRatio='xMaxYMax meet'%3E%3Cpath d='M100 0 L100 100 L0 100' fill='none' stroke='%23fff' /%3E%3C/svg%3E%3C/svg%3E") no-repeat bottom center;
      --warning: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='-10 -10 120 120' preserveAspectRatio='xMidYMid meet'%3E%3Cpath d='M0 100 L50 0 L100 100 L0 100 L50 0' stroke='%23ae0f12' stroke-width='10' fill='none' /%3E%3Crect x='45' y='32' width='10' height='40' fill='%23ae0f12' /%3E%3Ccircle cx='50' cy='85' r='6' fill='%23ae0f12' /%3E%3C/svg%3E");
    }
    uicursor {
        display: block;
        position: absolute;
        width: 2vh;
        height: 2vh;
        z-index: 999;
    }
    panel {
      font-family: "adam";
      display: flex;
      flex-direction: column;
      position: absolute;
      font-size: 1.4vh;
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
      padding: 1em;
      background: var(--bg) var(--corner-bg);
    }
    panel.filled::after {
      position: absolute;
      content: "";
      background: var(--corner-bg-bottom);
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
    }
    .left {
      text-align: left;
    }
    .w5 {
      width: 5vw;
    }
    .w10 {
      width: 10vw;
    }
    .w15 {
      width: 15vw;
    }
    .w20 {
      width: 20vw;
    }
    .w25 {
      width: 25vw;
    }
    .h5 {
      height: 5vh;
    }
    .h10 {
      height: 10vh;
    }
    .h15 {
      height: 15vh;
    }
    .h20 {
      height: 20vh;
    }
    .h25 {
      height: 25vh;
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
      position: relative;
      text-transform: uppercase;
      text-align: center;
      font-size: 1.25em;
      padding: 0.15em;
      background: var(--bg) var(--corner-bg);
      text-overflow: ellipsis;
      overflow: hidden;
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

HUDObject = function (x, y, width, height, content)
    local this = {}
    setmetatable(this, { _name = "HUDObject" })
    this.GUID = system.getTime()
    
    this.Enabled = false
    this.Position = {
        X = x or 0,
        Y = y or 0,
    }
    this.Width = width or 50
    this.Height = height or 50
    this.Parent = nil
    this.Children = {}
    this.Content = content or ""
    this.IsDirty = true
    this.IsHovered = false
    this.IsPressed = false
    this.Anchoring = {
        
    }

    this.HUD = Horizon.GetModule("HUDCore")
    this.Horizon = Horizon

    this._wrapStart = ""
    this._wrapEnd = ""

    local wasHovered = false
    local wasClicked = false
    local buffer = ""

    function this.Contains(pos)
        if  pos.X >= this.Position.X and pos.X <= this.Position.X + this.Width and 
            pos.Y >= this.Position.Y and pos.Y <= this.Position.Y + this.Height then
            return true
        end
        return false
    end
    
    function this._update()
        if this.Contains(this.HUD.MousePos) then
            this.IsHovered = true
        else
            this.IsHovered = false
        end
        if this.IsHovered then 
            this.IsDirty = true
            this.OnEnter(this)
            wasHovered = true
        else
            if wasHovered then
                this.IsDirty = true
                wasHovered = false
                this.OnLeave(this)
            end
        end
        this.OnUpdate(this)
    end

    function this.AddChild(child)
        if typeof(child) ~= "HUDObject" then 
            error("Trying to add a non-HUDObject")
            return
        end
        for k,v in ipairs(this.Children) do
            if v.GUID == child.GUID then 
                error(v.GUID.." is already a child of"..this.GUID)
                return
            end
        end
        child.Parent = this
        table.insert(this.Children, child)
    end

    function this.RemoveChild(child)
        if typeof(child) ~= "HUDObject" then
            error("Trying to remove a non-HUDObject")
            return
        end
        for k,v in ipairs(this.Children) do
            if v.GUID == child.GUID then
                v.Parent = nil
                table.remove(this.Children, k)
                return
            end
        end
        error(v.GUID.." is not a child of"..this.GUID)
    end

    function this.SetParent()
        error("NotImplemented")
    end

    function this.OnUpdate(scope) end
    function this.OnEnter(scope) end
    function this.OnLeave(scope) end
    function this.OnPress(scope) end
    function this.OnRelease(scope) end
    function this.OnClick(scope) end
    function this.OnScroll(scope, delta) end
    function this.Render(scope)
        local anyDirty = scope.IsDirty
        for k,v in ipairs(scope.Children) do
            if v.IsDirty then
                anyDirty = true
                break
            end
        end
        if anyDirty then
            buffer = template.substitute(scope._wrapStart..scope.Content, scope)
            for k,v in ipairs(scope.Children) do
                buffer = buffer .. v.Render(v)
            end
            buffer = buffer .. scope._wrapEnd
            scope.IsDirty = false
        end
        return buffer
    end
    
    return this
end

HUDButton = function (x, y, width, height, content)
    local this = HUDObject(x, y, width, height, content)
    this._wrapStart = [[<div style="position:absolute;left:$(Position.X)vw;top:$(Position.Y)vh;width:$(Width)vw;height:$(Height)vh;background-color: #ae0f12;">]]
    this._wrapEnd = [[</div>]]

    return this
end

HUDPanel = function (x, y, width, height, content)
    local this = HUDObject(x, y, width, height, content)
    this._wrapStart = [[<panel style="position:absolute;left:$(Position.X)vw;top:$(Position.Y)vh;width:$(Width)vw;height:$(Height)vh;z-index:$(Zindex)" class="$(Class)">]]
    this._wrapEnd = [[</panel>]]
    this.Class = ""
    this.Zindex = 0
    this.Spacing = ((0.3 * this.HUD.Config.ScreenSize.Y) / this.HUD.Config.ScreenSize.Y) * 100
    return this
end

HUDCore = (function(CSS) 
    local template = require('pl/template')
    local this = HorizonModule("HUDCore", "PostUpdate", true, 5)
    this.Tags = "hud,core"
    this.Config = {
        EnableMouse = true,
        MouseSensitivity = 1.2,
        ScreenSize = {
            X = 2560,
            Y = 1440
        }
    }
    this.Widgets = {}
    this.CSS = CSS

    local header = ""
    if this.CSS then header = "<style>"..this.CSS.."</style>" end

    local MousePos = {
        X = this.Config.ScreenSize.X * 0.5,
        Y = this.Config.ScreenSize.Y * 0.5
    }

    this.MousePos = {
        X = this.Config.ScreenSize.X * 0.5,
        Y = this.Config.ScreenSize.Y * 0.5
    }

    system.showScreen(1)
    system.freeze(1)
    Horizon.Controller.hide()

    function contains(obj, pos)
        if  pos.X > obj.X and pos.X < obj.X + obj.Width and
            pos.Y > obj.Y and pos.Y < obj.Y + obj.Height then
            return true
        end
        return false
    end

    function xform(pos)
        return {X = (pos.X / this.Config.ScreenSize.X) * 100, Y = (pos.Y / this.Config.ScreenSize.Y) * 100}
    end

    function processMouse(x, y)
        MousePos.X = MousePos.X + (x * this.Config.MouseSensitivity)
        MousePos.Y = MousePos.Y + (y * this.Config.MouseSensitivity)
        if MousePos.X < 0 then MousePos.X = 0 end
        if MousePos.X > this.Config.ScreenSize.X then MousePos.X = this.Config.ScreenSize.X end
        if MousePos.Y < 0 then MousePos.Y = 0 end
        if MousePos.Y > this.Config.ScreenSize.Y then MousePos.Y = this.Config.ScreenSize.Y end
        this.MousePos = xform(MousePos)
    end
    
    function this.Update(eventType, deltaTime)
        processMouse(system.getMouseDeltaX(), system.getMouseDeltaY())
        local buffer = header .. [[<div id="horizon">]]
        for k,v in ipairs(this.Widgets) do
            v._update()
            buffer = buffer .. v.Render(v)
        end
        system.setScreen(buffer .. "</div>")
    end

    function this.AddWidget(widget)
        if typeof(widget) ~= "HUDObject" then return end
        for k,v in ipairs(this.Widgets) do
            if v.GUID == widget.GUID then 
                return
            end
        end
        table.insert(this.Widgets, widget)
    end

    function this.RemoveWidget(widget)
        if typeof(widget) ~= "HUDObject" then return end
        for k,v in ipairs(this.Widgets) do
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
        return function() return fn end, err
    end

    return this
end)(CSS)
Horizon.RegisterModule(HUDCore)

local cursor = HUDObject(50,50)
cursor.OnUpdate = function(this)
    this.Position.X = HUDCore.MousePos.X
    this.Position.Y = HUDCore.MousePos.Y
    this.IsDirty = true
end
cursor.Content = [[
<uicursor style="left: $(Position.X)vw;top: $(Position.Y)vh">
	<svg xmlns="http://www.w3.org/2000/svg" stroke="black" stroke-width="1" preserveAspectRatio="xMidYMid" viewBox="0 0 100 100"><path fill="#ae0f12" fill-rule="evenodd" d="M30 73L0 100V0l100 100-70-27zM9 80l19-17 37 14L9 21v59z"/></svg>
</uicursor>
]]
HUDCore.AddWidget(cursor)

local mainPanel = HUDPanel(86.4, 30, 10.6, 26)
mainPanel.Class = "filled"
HUDCore.AddWidget(mainPanel)

local subpanel = HUDPanel(0.3, 0.6, 10, 25.7)
subpanel.Content = [[<uiheading>Test Panel</uiheading>]]
mainPanel.AddChild(subpanel)