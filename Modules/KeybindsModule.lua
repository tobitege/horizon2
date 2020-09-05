--[[ Example config :]]


    -- { {ModuleName, ModuleMethod, Keydown only?}}
    Config = {
        antigravity = nil, --Default bind Alt-G
        backward = { {"Dynamic Flight Mode", "Backward"} },
        booster = { {"Booster Module", "ToggleEnabled"} }, --Default bind B
        brake = { {"Velocity Braking", "ToggleEnabled"} },
        down = { {"Dynamic Flight Mode", "Down"} },
        forward = { {"Dynamic Flight Mode", "Forward"}  },
        Gear = { {"Landing", "ToggleGear"}  },
        groundaltitudeup = nil, -- Alt-Space
        groupaltitudedown = nil, -- Alt-C
        lalt = { {"Mouse Steering", "ToggleEnabled"} },
        left = { {"Dynamic Flight Mode", "Left"}  },
        light = nil,
        lshift = nil,
        option1 = { {"Cruise Control", "ToggleEnabled", true} },
        option2 = { {"Simple Inertial Dampening", "ToggleEnabled", true} },
        option3 = { {"Gravity Suppression", "ToggleEnabled", true} },
        option4 = nil,
        option5 = nil,
        option6 = nil,
        option7 = nil,
        option8 = nil,
        option9 = nil,
        right = { {"Dynamic Flight Mode", "Right"}  },
        speeddown = { {"Dynamic Flight Mode", "SpeedDown", true}  },
        speedup = { {"Dynamic Flight Mode", "SpeedUp", true}  },
        stopengines = nil,
        strafeleft = nil,
        straferight = nil,
        up = { {"Dynamic Flight Mode", "Up"}  },
        warp = nil,
        yawleft = { {"Dynamic Flight Mode", "YawLeft"} },
        yawright = { {"Dynamic Flight Mode", "YawRight"} },
        mousewheelup = { {"Dynamic Flight Mode", "SpeedUp", true}  },
        mousewheeldown = { {"Dynamic Flight Mode", "SpeedDown", true}  },
        external1 = { {"Cruise Control", "Disable", true}, {"Velocity Braking", "Enable", true} },
    }


KeybindsModule = (function() 
    local this = HorizonModule("Keybinds Module", "PreFlush", true, 1)
    this.Tags = "system"

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    this.Config = {}

    function this.LoadConfig(config)
        this.Config = config
    end

    local function callBind(name, triggerOnKeyDownOnly)
        local event = this.Config[name]

        if event ~= nil then
            if type(event) == "table" then

                for i,command in ipairs(event) do
                    local m = Horizon.GetModule(command[1])
                    local keyDownOnly = command[3]
                    
                    if keyDownOnly == nil or triggerOnKeyDownOnly==keyDownOnly then
                        if m ~= nil then m[command[2]](keyDown) end
                    end
                end

            elseif type(event) == "function" then
                event(keyDown)
            end
        end

    end

    function this.Update(eventType, arg)
        
        if eventType == "keydown" or eventType == "keyup" then
            local isKeyDown = eventType == "keydown"
            callBind(arg, isKeyDown)
        end

        if eventType == "mousewheel" then
            if arg > 0 then
                callBind("mousewheelup", true)
            else
                callBind("mousewheeldown", true)
            end
        end

    end

    return this
end)()
Horizon.RegisterModule(KeybindsModule)