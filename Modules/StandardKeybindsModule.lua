KeybindsModule = (function() 

    local function MultiKeybind(keybinds)
        local kb = {Keybinds = keybinds}
        local mt = {__call=function(w,a) for k,v in pairs(w.Keybinds) do v() end end}
        setmetatable(kb, mt)
        return kb
    end


    local this = HorizonModule("Keybinds Module", "PreFlush", true, 1)
    this.Tags = "system"

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    --Setup your keybinds here
    --Reference a function, or a MultiKeybind object
    --brake = Horizon.GetModule("Velocity Braking").Enable,
    --brake = MultiKeybind({ Horizon.GetModule("Velocity Braking").Enable, Horizon.GetModule("Mouse Steering").Disable })
    local this.KeyDown = {
        antigravity = nil, --Default bind Alt-G
        backward = Horizon.GetModule("Dynamic Flight Mode").Backward,
        booster = Horizon.GetModule("Mouse Steering").ToggleEnabled, --Default bind B
        brake = Horizon.GetModule("Velocity Braking").Enable,
        down = Horizon.GetModule("Dynamic Flight Mode").Down,
        forward = Horizon.GetModule("Dynamic Flight Mode").Forward,
        Gear = nil,
        groundaltitudeup = nil, -- Alt-Space
        groupaltitudedown = nil, -- Alt-C
        lalt = Horizon.GetModule("Mouse Steering").Disable,
        left = Horizon.GetModule("Dynamic Flight Mode").Left,
        light = nil,
        lshift = nil,
        option1 = Horizon.GetModule("Cruise Control").ToggleEnabled,
        option2 = Horizon.GetModule("Simple Inertial Dampening").ToggleEnabled,
        option3 = Horizon.GetModule("Gravity Suppression").ToggleEnabled,
        option4 = nil,
        option5 = nil,
        option6 = nil,
        option7 = nil,
        option8 = nil,
        option9 = nil,
        right = Horizon.GetModule("Dynamic Flight Mode").Right,
        speeddown = nil,
        speedup = nil,
        stopengines = nil,
        strafeleft = nil,
        straferight = nil,
        up = Horizon.GetModule("Dynamic Flight Mode").Up,
        warp = nil,
        yawleft = Horizon.GetModule("Dynamic Flight Mode").YawLeft,
        yawright = Horizon.GetModule("Dynamic Flight Mode").YawRight,
    }

    local this.KeyUp = {
        antigravity = nil,
        backward = Horizon.GetModule("Dynamic Flight Mode").Backward,
        booster = nil,
        brake = Horizon.GetModule("Velocity Braking").Disable,
        down = Horizon.GetModule("Dynamic Flight Mode").Down,
        forward = Horizon.GetModule("Dynamic Flight Mode").Forward,
        Gear = nil,
        groundaltitudeup = nil,
        groupaltitudedown = nil,
        lalt = Horizon.GetModule("Mouse Steering").Enable,
        left = Horizon.GetModule("Dynamic Flight Mode").Left,
        light = nil,
        lshift = nil,
        option1 = nil,
        option2 = nil,
        option3 = nil,
        option4 = nil,
        option5 = nil,
        option6 = nil,
        option7 = nil,
        option8 = nil,
        option9 = nil,
        right = Horizon.GetModule("Dynamic Flight Mode").Right,
        speeddown = nil,
        speedup = nil,
        stopengines = nil,
        strafeleft = nil,
        straferight = nil,
        up = Horizon.GetModule("Dynamic Flight Mode").Up,
        warp = nil,
        yawleft = Horizon.GetModule("Dynamic Flight Mode").YawLeft,
        yawright = Horizon.GetModule("Dynamic Flight Mode").YawRight,
    }
    --Do not edit below this

    --Will call the bound function with the following arguments
    -- #1 true for keydown, false for keyup
    function this.Update(eventType, arg)
        
        if eventType == "keydown" then
            local event = this.KeyDown[arg]
            if event ~= nil then event(true) end
        end

        if eventType == "keyup" then
            local event = this.KeyUp[arg]
            if event ~= nil then event(false) end
        end
        
    end

    return this
end)()
Horizon.RegisterModule(KeybindsModule)