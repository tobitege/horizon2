--[[ Example config :]]

    -- { {ModuleName, ModuleMethod, Keydown only?}}
    Config = {
        antigravity = nil, --Default bind Alt-G
        backward = { {"Cruise Control", "Disable"}, {"Maneuver Flight Mode", "Backward"} },
        booster = { {"Booster Module", "ToggleEnabled"} }, --Default bind B
        brake = { {"Cruise Control", "Disable"}, {"Velocity Braking", "ToggleEnabled"} },
        down = { {"Cruise Control", "Disable"}, {"Maneuver Flight Mode", "Down"} },
        forward = { {"Cruise Control", "Disable"}, {"Maneuver Flight Mode", "Forward"}  },
        gear = { {"Landing Gear", "ToggleGear"}  },
        groundaltitudeup = nil, -- Alt-Space
        groupaltitudedown = nil, -- Alt-C
        lalt = { {"Mouse Steering", "ToggleEnabled"} },
        left = { {"Maneuver Flight Mode", "RollLeft"}  },
        light = nil,
        lshift = nil,
        option1 = { {"Cruise Control", "ToggleEnabled", true} },
        option2 = { {"Inertial Dampening", "ToggleEnabled", true} },
        option3 = { {"Gravity Counter", "ToggleEnabled", true} },
        option4 = { {"Landing Gear", "ToggleSoftland", true}  },
        option5 = nil,
        option6 = nil,
        option7 = nil,
        option8 = nil,
        option9 = nil,
        right = { {"Maneuver Flight Mode", "RollRight"}  },
        speeddown = { {"Maneuver Flight Mode", "SpeedDown", true}  },
        speedup = { {"Maneuver Flight Mode", "SpeedUp", true}  },
        stopengines = nil,
        strafeleft = nil,
        straferight = nil,
        up = { {"Cruise Control", "Disable"}, {"Maneuver Flight Mode", "Up"}  },
        warp = nil,
        yawleft = { {"Cruise Control", "Disable"}, {"Maneuver Flight Mode", "Left"} },
        yawright = { {"Cruise Control", "Disable"}, {"Maneuver Flight Mode", "Right"} },
        mousewheelup = { {"Maneuver Flight Mode", "SpeedUp", true}  },
        mousewheeldown = { {"Maneuver Flight Mode", "SpeedDown", true}  },
        external1 = { {"Cruise Control", "Disable", true}, {"Velocity Braking", "Enable", true} },
    }

--@class KeybindsModule
--@require HorizonCore
--@require HorizonModule

KeybindsModule = (function() 
    local this = HorizonModule("Keybinds Module", "Takes keyboard input and forwards it to the configured modules", "PreFlush", true, 1)
    this.Tags = "system,control"

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    this.Config.Version = "CI_FILE_LAST_COMMIT"
    this.Keybinds = {}

    function this.LoadConfig(config)
        this.Keybinds = config
    end

    local function callBind(name, isKeyDown)
        local event = this.Keybinds[name]

        if event ~= nil then
            if type(event) == "table" then

                --For each keybind
                for i,command in ipairs(event) do
                    --Get the module
                    local m = Horizon.GetModule(command[1])
                    if m ~= nil then
                        --Only if the module is enabled
                        if m.Enabled then
                            local keyDownOnly = command[3]
                    
                            if (not keyDownOnly) or (isKeyDown and keyDownOnly) then
                                if m ~= nil then m[command[2]](isKeyDown) end
                            end

                        end
                    end
                end

            elseif type(event) == "function" then
                event(isKeyDown)
            end
        end

    end

    function this.Update(eventType, deltaTime, arg)
        
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
KeybindsModule.LoadConfig(Config)