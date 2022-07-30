--@class HUDQuickConfig
--@require HorizonCore
--@require HorizonModule
--@require UIController
--@require UICSS
--@require Linq

HUDQuickConfig = (function()
    local this = HorizonModule("HUD Quick Config", "Provides an interface for configuring modules during runtime", "Start", true, 5)
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    this.Templates = {}
    this.Templates.Toggle = function(parent, hud, module)
        local s = hud.TransformSize(parent.Height * 0.4)
        local widget = UICheckbox(parent.Width - (parent.Height-s.y) * 0.5, parent.Height*0.5, s.x, s.y)
        widget.Anchor = UIAnchor.MiddleRight
        widget.OnUpdate = function()
            widget.Value = module.Enabled
        end
        widget.OnClick = function ()
            module.ToggleEnabled()
        end
        return widget
    end
    this.Templates.Scrollable = function(parent, hud, module, configProperty, onUpdate)
        local s = hud.TransformSize(parent.Height * 0.5)
        local widget = UIPanel(parent.Width - (parent.Height-s.y) * 0.5, parent.Height*0.5, s.x, s.y)
        widget.Anchor = UIAnchor.MiddleRight
        widget.Style = "color:#fff;font-size: "..(s.y*0.8).."vh;text-align:center"
        widget.Content = '⇅'
        widget.OnClick = function()
            module.QuickConfig.Locked = not module.QuickConfig.Locked
        end
        widget.AlwaysDirty = true
        local statDisplay = nil
        local function handleScroll(evt, dT, amount)
            widget.OnScroll(amount)
        end

        widget.OnUpdate = function()
            if parent.Class == "selected" and module.QuickConfig.Locked then
                if not statDisplay then
                    statDisplay = UIPanel(parent.Parent.Position.x + (parent.Parent.Padding * 3), parent.Position.y - parent.Parent.Padding, 3, parent.Height)
                    statDisplay.Padding = parent.Parent.Padding
                    statDisplay.Class = "filled"
                    statDisplay.Style = "color:#fff;font-size:"..(parent.Height*0.75).."vh;"
                    statDisplay.OnUpdate = onUpdate or function ()
                        statDisplay.Content = module.Config[configProperty]
                    end
                    statDisplay.AlwaysDirty = true
                    widget.AddChild(statDisplay)
                    widget.IsDirty = true
                    Horizon.Event.MouseWheel.Add(handleScroll)
                end
            else
                if statDisplay then
                    widget.RemoveChild(statDisplay)
                    statDisplay = nil
                    widget.IsDirty = true
                    Horizon.Event.MouseWheel.Remove(handleScroll)
                end
            end
        end
        widget.OnScroll = function (amount)
        end
        return widget
    end
    this.Templates.Text = function(parent, hud, text)
        local s = hud.TransformSize(parent.Height * 0.5)
        local widget = UIPanel(parent.Width - (parent.Height-s.y) * 0.5, parent.Height*0.5, s.x, s.y)
        widget.Anchor = UIAnchor.MiddleRight
        widget.Style = "color:#fff;font-size: "..(s.y*0.8).."vh;text-align:center"
        widget.Content = text
        return widget
    end

    this.TrackedModules = {}
    ---@diagnostic disable-next-line: undefined-field
    local hud = Horizon.GetModule("UI Controller").Displays[1]

    local mainPanel = nil
    local closedInfo = nil
    local panelWidth = 13
    local selectedIndex = 1
    local spacing = 0.2
    local activeFlightMode = nil

    local function findKeybind(keybindName)
        if not keybindName then return end
        for k,v in pairs(Keybinds) do
            if Linq(v).Any(function(el) return el[1] == keybindName end) then
                return system.getActionKeyName(k)
            end
        end
    end

    local function handleBack()
        mainPanel = mainPanel.Back(hud)
        system.print("Curr: "..tostring(mainPanel.Name))
    end

    local function refreshSelections()
        local trueIndex = math.floor(selectedIndex)
        local old = Linq(mainPanel.Children).Where(function(el) return el.Class == "selected" end).ToArray()
        for i=1,#old do
            old[i].Class = ""
            old[i].IsDirty = true
        end
        mainPanel.Children[trueIndex].Class = "selected"
        mainPanel.Children[trueIndex].IsDirty = true
    end

    local function createControl(label, parent)
        local idx = #parent.Children
        local modControl = UILabel(0,idx*(2+spacing),panelWidth,2)
        modControl.Name = label .. " QuickConfig"
        modControl.Content = label
        return modControl
    end

    local function createEntry(module, parent, label)
        if not module.Module.QuickConfig.FullConfig then
            local modControl = createControl(label, parent)
            modControl.Name = label
            modControl.Module = module.Module
            parent.AddChild(modControl)

            local modWidget = module.QuickConfig.WidgetFactory(modControl, hud, module.Module)
            modControl.OnClick = function()
                modWidget.OnClick(modWidget)
            end
            modWidget.Anchor = UIAnchor.MiddleRight
            modControl.AddChild(modWidget)

            local kbd = findKeybind(module.Module.Keybind)
            if module.QuickConfig.ShowKeybind ~= false and kbd then
                local keybindInfo = UIPanel(modWidget.Position.x - 0.2 - modWidget.Width, modControl.Height*0.5, 3, modControl.Height*0.5, kbd)
                keybindInfo.Anchor = UIAnchor.MiddleRight
                keybindInfo.Style = "text-align: right;font-size:0.8em;color:#eee"
                keybindInfo.OnClick = modWidget.OnClick
                modControl.AddChild(keybindInfo)
            end
            return modControl
        end
    end

    local function createPanel(moduleList)
        local panel = UIExpandable(1, 50)
        panel.Anchor = UIAnchor.MiddleLeft
        panel.Class = "filled"
        panel.Padding = spacing

        if moduleList then
            for i=1,#moduleList do
                local mod = moduleList[i]
                createEntry(mod, panel, mod.QuickConfig.Label or mod.Module.Name)
            end
        end
        function panel.OnUpdate(ref)
            local trueIndex = math.floor(selectedIndex)
            local old = Linq(ref.Children).Where(function(el) return el.Class == "selected" end).ToArray()
            for i=1,#old do
                old[i].Class = ""
                old[i].IsDirty = true
            end
            local selected = ref.Children[trueIndex]
            if selected then
                selected.Class = "selected"
                selected.IsDirty = true
                ref.IsDirty = true
            end
        end
        return panel
    end

    local function createBackButton(panel)
        local back = createControl("« Back", panel)
        back.OnClick = handleBack
        for i=1,#panel.Children do
            local child = panel.Children[i]
            child.Position.y = child.Position.y + child.Height + spacing
        end
        back.Position.x = 0
        back.Position.y = 0
        panel.AddChild(back, 1)
        selectedIndex = 2
        refreshSelections()
    end

    function this.Init()
        if mainPanel then hud.RemoveWidget(mainPanel) end
        selectedIndex = 1
        -- First entry should always be the flight mode config
        local flightModes = {}
        if not activeFlightMode then
            flightModes = Linq(Horizon.GetModulesByTag("flightmode")).OrderBy('Name').ToArray()
            activeFlightMode = Linq(flightModes).First(function(el) return el.Enabled end)
            if activeFlightMode then
                this.TrackedModules[1] = { Module = activeFlightMode, QuickConfig = activeFlightMode.QuickConfig, Order = -1, Category = "Default" }
            end
        else
            this.TrackedModules[1] = { Module = activeFlightMode, QuickConfig = activeFlightMode.QuickConfig, Order = -1, Category = "Default" }
        end
        for k,v in pairs(Horizon.Modules) do
            if v.QuickConfig.Enabled and not v.HasTag("flightmode") then
                this.TrackedModules[#this.TrackedModules+1] = { Module = v, QuickConfig = v.QuickConfig, Order = v.QuickConfig.Order or 1, Category = v.QuickConfig.Category }
            end
        end
        this.TrackedModules = Linq(this.TrackedModules).OrderBy('Order').GroupBy('Category').Value

        mainPanel = UIExpandable(1, 50)
        mainPanel.Anchor = UIAnchor.MiddleLeft
        mainPanel.Class = "filled"
        mainPanel.Padding = spacing
        mainPanel.Name = "QuickConfig Info"
        local infoText = UIHeading(0,0,panelWidth,2)
        infoText.Content = string.format("Press <strong class=\"red\">[%s]</strong> to open", findKeybind("QuickConfig"))
        mainPanel.AddChild(infoText)
        mainPanel = UIWizard(mainPanel)
        hud.AddWidget(mainPanel)

        local baseLevel = UIWizard(createPanel(this.TrackedModules.Default), mainPanel)
        baseLevel.Enabled = false
        baseLevel.Name = "QuickConfig Base Level"
        for k,v in pairs(this.TrackedModules) do
            if k ~= "Default" then
                local ctr = createControl(k, baseLevel)
                ctr.OnClick = function ()
                    local subPanel = UIWizard(createPanel(v), mainPanel)
                    subPanel.Name = k
                    createBackButton(subPanel)
                    mainPanel = subPanel.Open(hud)
                    system.print("Curr: "..tostring(mainPanel.Name))
                end
                baseLevel.AddChild(ctr)
                local widget = this.Templates.Text(ctr, hud, '»')
                widget.OnClick = ctr.OnClick
                ctr.AddChild(widget)
            end
        end

        mainPanel.Previous = baseLevel
        baseLevel.Previous = mainPanel
        refreshSelections()
    end

    function this.Update(eventType, deltaTime)
        this.Init()
    end

    local function handleScroll(evt, dt, val)
        local curr = mainPanel.Children[math.floor(selectedIndex)]
        if mainPanel and mainPanel.Enabled and (not curr.Module or not curr.Module.QuickConfig.Locked) then
            val = val * -1
            if val > 1 then val = 1 end
            if val < -1 then val = -1 end
            selectedIndex = selectedIndex + (val*0.5)
            if selectedIndex > #mainPanel.Children then selectedIndex = 1 end
            if selectedIndex < 1 then selectedIndex = #mainPanel.Children end
        end
    end

    local function handleClick(evt, pos)
        system.print("CLICK "..mainPanel.Name)
        if mainPanel and mainPanel.Enabled then
            mainPanel._update()
            if not mainPanel.Contains(pos) then
                system.print("Wonk "..mainPanel.Name)
                system.print(evt)
                local trueIndex = math.floor(selectedIndex)
                mainPanel.Children[trueIndex].OnClick()
            end
        end
    end

    local function handleFlightSwitch(flightmode)
        if mainPanel.Name == "MainQuickConfig" then
            activeFlightMode = Horizon.GetModule(flightmode)
            this.Init()
            handleBack()
        end
    end

    Horizon.Emit.Subscribe("FlightMode.Switch", handleFlightSwitch)
    Horizon.Emit.Subscribe("HUD.Click.Position", handleClick)
    Horizon.Emit.Subscribe("QuickConfig", handleBack)
    Horizon.Event.MouseWheel.Add(handleScroll)

    return this
end)()