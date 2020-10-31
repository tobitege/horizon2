--@require HUDMarkers

--@class HUDOrbitalMarkers

HUDOrbitalMarkers = (function()
    local this = HorizonModule("HUD Orbital Markers", "AR HUD Markers","Start", true, 5)
    this.Tags = "hud,navigation"

    local markers = Horizon.GetModule("HUD Markers")
    local world = Horizon.Memory.Static.World

    if not markers then this.Disable() error("HUD Orbital Markers requires HUD Markers to work.") end

    local function createMarker(icon, initialVector, calc)
        local markerBase = ARMarker(initialVector)
        markerBase.MaxDistance = nil
        markerBase.ShowDistance = false
        local mark = markers.Add(markerBase)
        mark.AlwaysDirty = true
        local update = mark.OnUpdate
        mark.OnUpdate = function(ref)
            ref.Marker.Position = calc() 
            update(ref)
        end
    end

    local prograde = createMarker(nil, world.Forward, function()
        local world = Horizon.Memory.Static.World
        return world.Position + (world.Velocity:normalize() * 20)
    end)

    local retrograde = createMarker(nil, -world.Forward, function()
        local world = Horizon.Memory.Static.World
        return world.Position - (world.Velocity:normalize() * 20)
    end)

    local radialin = createMarker(nil, world.Vertical, function()
        local world = Horizon.Memory.Static.World
        return world.Position + (world.Vertical * 20)
    end)

    local radialout = createMarker(nil, -world.Vertical, function()
        local world = Horizon.Memory.Static.World
        return world.Position - (world.Vertical * 20)
    end)

    return this
end)()