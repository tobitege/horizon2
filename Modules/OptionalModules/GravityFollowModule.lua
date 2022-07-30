--@class GravityFollowModule

GravityFollowModule = (function() 
    local this = HorizonModule("Gravity Follow", "Forces ship to follow gravity down, effectively locking ship pitch to the horizon", "Flush", false)
    this.Tags = "thrust,stability"
    this.Keybind = "GravityFollow"
    this.Config = {
        AdjustSpeed = 6
    }
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    this.QuickConfig = {
        Enabled = true,
        WidgetFactory = function(parent, hud, module)
            local template = HUDQuickConfig.Templates.Toggle(parent, hud, module)
            return template
        end,
        Order = 4,
        Category = "Stability Assists"
    }

    local function transformPitch(pitch)
        pitch = pitch % 180
        if pitch > 90 then pitch = pitch - 180 end
        local mult = 10
        pitch = math.floor(pitch * mult + 0.5) / mult
        return pitch
    end

    local function Clamp(n, min, max)
        return math.min(max, math.max(n, min))
    end

    function this.Update(eventType)
        local world = Horizon.Memory.Static.World
        local staticShip = Horizon.Memory.Static.Ship
        local ship = Horizon.Memory.Dynamic.Ship

        -- Maximum correction allowed is 1.25/2=0.625 degrees per tick
        local mod = Clamp(world.VerticalVelocity * this.Config.AdjustSpeed, 0, 1.25)
        local pitch = transformPitch(staticShip.Pitch) - mod

        local offsetVec = -world.Right * (pitch * constants.deg2rad)
        ship.Rotation = ship.Rotation + (world.Up:cross(-world.Vertical) - offsetVec)
    end

    Horizon.Emit.Subscribe(this.Keybind, this.ToggleEnabled)

    return this
end)()