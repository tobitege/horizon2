-- { event, isToggle }
Config = {
    antigravity = nil, --Default bind Alt-G

    forward = { {"Move.Direction.Forward"} },
    backward = { {"Move.Direction.Backward"} },
    yawleft = { {"Move.Direction.Left"} },
    yawright = { {"Move.Direction.Right"} },
    up = { {"Move.Direction.Up"} },
    down = { {"Move.Direction.Down"} },
    left = { {"Move.Rotation.RollLeft"} },
    right = { {"Move.Rotation.RollRight"}  },
    brake = { {"Brake"} },

    booster = { {"Booster"} }, --Default bind B
    gear = { {"LandingGear", true} },
    groundaltitudeup = nil, -- Alt-Space
    groupaltitudedown = nil, -- Alt-C
    lalt = { { "MouseSteering" } },
    light = nil,
    lshift = { {"HUD.Cursor.Toggle"}, {"MouseSteering.ToggleAndLock"} },
    option1 = { {"CruiseControl", true} },
    option2 = { {"InertialDamping", true} },
    option3 = { {"GravityCounter", true} },
    option4 = { {"GravityFollow", true} },
    option5 = nil,
    option6 = nil,
    option7 = nil,
    option8 = nil,
    option9 = nil,
    speeddown = { {"Throttle.Up", true} },
    speedup = { {"Throttle.Down", true} },
    stopengines = { {"HUD.Click", true} },
    strafeleft = nil,
    straferight = nil,
    warp = nil,
    mousewheelup = { {"Throttle.Up"} },
    mousewheeldown = { {"Throttle.Down"} },
    external1 = nil,
}

--@class KeybindsModule

--@require HorizonCore
--@require HorizonModule

KeybindsModule = (function() 
    local this = HorizonModule("Keybinds Module", "Takes keyboard input and forwards it to the configured modules", "Start", true, 1)
    this.Tags = "system,control"

    Horizon.Event.KeyUp.Add(this)
    Horizon.Event.KeyDown.Add(this)

    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    this.Keybinds = {}

    function this.LoadConfig(config)
        this.Keybinds = config
    end

    local function callBind(name, isKeyDown)
        local event = this.Keybinds[name]

        if event ~= nil then
            if type(event) == "table" then
                --For each keybind defined
                for _,command in ipairs(event) do
                    local eventName = command[1]
                    local keyDownOnly = command[2]
                    if (not keyDownOnly) or (isKeyDown and keyDownOnly) then
                        Horizon.Emit.Call(eventName, isKeyDown)
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
KeybindsModule.LoadConfig(Config)