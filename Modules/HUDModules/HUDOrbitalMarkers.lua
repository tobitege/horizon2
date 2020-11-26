--@require HUDMarkers

--@class HUDOrbitalMarkers

HUDOrbitalMarkers = (function()
    local this = HorizonModule("HUD Orbital Markers", "AR HUD Markers","Start", true, 5)
    this.Tags = "hud,navigation"

    local markers = Horizon.GetModule("HUD Markers")
    local world = Horizon.Memory.Static.World

    -- All of these need proper centering due to export bs. center with viewbox
    local progradeSVG = [[<svg viewBox="0 0 198 198"><path fill="none" stroke="#f90" stroke-miterlimit="10" d="m109,99l-20,0m10,-10l0,20"/><circle cx="99" cy="99" r="75.13" fill="none" stroke="#f90" stroke-miterlimit="10"/><path fill="#f90" d="m99,26a75.1,75.1 0 0 1 75.1,74.1l0,-1a75.1,75.1 0 0 0 -150.2,0l0,1a75.1,75.1 0 0 1 75.1,-74.1z"/><path fill="#f90" d="m99,172.3a75.1,75.1 0 0 1 -75,-74.2l0,1a75.1,75.1 0 0 0 150.2,0l0,-1a75.1,75.1 0 0 1 -75.2,74.2zm-0.2,-170.7l2.5,34.8l-2.5,10l-2.5,-10l2.5,-34.8z"/><path fill="#f90" d="m196.4,99l-34.8,2.5l-10,-2.5l10,-2.5l34.9,2.5l-0.1,0zm-195,0.4l34.8,-2.5l10,2.5l-10,2.5l-34.8,-2.5z"/></svg>]]
    local retrogradeSVG = [[<svg viewBox="0 0 198 198"><path fill="none" stroke="#f90" stroke-miterlimit="10" d="m109,99l-20,0m10,-10l0,20"/><circle cx="99" cy="99" r="75.13" fill="none" stroke="#f90" stroke-miterlimit="10"/><path fill="#f90" d="m99,26a75.1,75.1 0 0 1 75.1,74.1l0,-1a75.1,75.1 0 0 0 -150.2,0l0,1a75.1,75.1 0 0 1 75.1,-74.1z"/><path fill="#f90" d="m99,172.2a75.1,75.1 0 0 1 -75.1,-74.2l0,1a75.1,75.1 0 0 0 150.3,0l0,-1a75.1,75.1 0 0 1 -75.2,74.2zm-0.3,-170.7l2.6,34.8l-2.5,10l-2.5,-10l2.4,-34.8z"/><path fill="#f90" d="m187.4,140.1l-32.8,-12.6l-8,-6.5l10.2,2l30.5,17l0.1,0.1zm-176.8,0.4l30.5,-17l10,-2l-7.9,6.5l-32.6,12.4l0,0.1z"/><path fill="none" stroke="#f90" stroke-miterlimit="10" d="m152,152.2l-106.2,-106.3m106.2,0l-106.2,106.3"/></svg>]]
    local normalSVG = [[<svg viewBox="0 0 198 198"><path fill="none" stroke="#cc218b" stroke-miterlimit="10" d="m109,99l-20,0m10,-10l0,20"/><path fill="#cc218b" d="m99,5.72l-36.5,73.1l36.4,-65.5l36.6,65.4l-36.5,-73zm-38.5,77.1l-36.6,73.2l73.1,0l-67.3,-3.3l30.8,-70l0,0.1zm77,0l30.8,70l-67.3,3.2l73.1,0l-36.6,-73.3l0,0.1z"/></svg>]]
    local antinormalSVG = [[<svg viewBox="0 0 198 198"><path fill="none" stroke="#cc218b" stroke-miterlimit="10" d="m109,99l-20,0m10,-10l0,20"/><path fill="#cc218b" d="m99,192l36.5,-73.1l-36.5,65.4l-36.5,-65.4l36.5,73l0,0.1zm38.5,-77.2l36.6,-73.1l-73.1,0l67.3,3.1l-30.8,70zm-77,0l-30.8,-70l67.3,-3.1l-73.1,0l36.6,73.2l0,-0.1zm38.3,-95.5l2.5,34.8l-2.5,10l-2.5,-10l2.5,-34.8z"/><path fill="#cc218b" d="m171,132.5l-32.6,-12.5l-8,-6.5l10,2l30.6,17zm-144.2,0.3l30.5,-17l10.1,-1.9l-8,6.5l-32.6,12.4z"/></svg>]]
    local radialinSVG = [[<svg viewBox="0 0 198 198"><path fill="none" stroke="#0faea9" stroke-miterlimit="10" d="m109,99l-20,0m10,-10l0,20"/><path fill="#0faea9" d="m71,70l-26.4,-22.8l-5.3,-8.8l8.8,5.2l22.9,26.4zm-0.1,56.2l-23,26.4l-8.8,5.3l5.3,-8.8l26.4,-23l0.1,0.1zm56.2,0.1l26.4,22.8l5.3,8.9l-8.9,-5.3l-22.8,-26.4zm0.1,-56.2l22.7,-26.4l8.8,-5.3l-5.3,8.9l-26.3,22.8l0.1,0z"/><path fill="#0faea9" d="m99,25a75.1,75.1 0 0 1 75.1,74.1l0,-1a75.1,75.1 0 0 0 -150.2,0l0,1a75.1,75.1 0 0 1 75,-74.1l0.1,0z"/><path fill="#0faea9" d="m99,171a75.1,75.1 0 0 1 -75,-74.3l0,1a75.1,75.1 0 0 0 150.2,0l0,-1a75.1,75.1 0 0 1 -75.3,74.3l0.1,0z"/></svg>]]
    local radialoutSVG = [[<svg viewBox="0 0 198 198"><path fill="none" stroke="#0faea9" stroke-miterlimit="10" d="m109,99l-20,0m10,-10l0,20"/><path fill="#0faea9" d="m21.5,21.5l26.5,22.8l5.3,8.8l-8.9,-5.2l-22.9,-26.4zm0,154.9l22.8,-26.4l8.8,-5.3l-5.2,8.8l-26.4,23l0,-0.1zm154.9,0.1l-26.4,-23l-5.3,-8.8l8.8,5.3l22.9,26.3l0,0.2zm0.1,-155l-23,26.5l-8.8,5.3l5.3,-8.9l26.4,-22.9l0.1,0z"/><path fill="#0faea9" d="m99,25a75.1,75.1 0 0 1 75,74.1l0,-1a75.1,75.1 0 0 0 -150.2,0l0,1a75.1,75.1 0 0 1 75.2,-74l0,-0.1z"/><path fill="#0faea9" d="m99,171.3a75.1,75.1 0 0 1 -75.1,-74.3l0,1a75.1,75.1 0 0 0 150.2,0l0,-1a75.1,75.1 0 0 1 -75.1,74.2l0,0.1z"/></svg>]]


    if not markers then this.Disable() error("HUD Orbital Markers requires HUD Markers to work.") end

    local function createMarker(icon, initialVector, calc)
        local markerBase = ARMarker(initialVector)
        markerBase.MaxDistance = nil
        markerBase.ShowDistance = false
        markerBase.Icon = icon or nil
        local mark = markers.Add(markerBase)
        mark.AlwaysDirty = true
        local update = mark.OnUpdate
        mark.OnUpdate = function(ref)
            ref.Marker.Position = calc() 
            update(ref)
        end
    end
    
    local prograde = createMarker(progradeSVG, world.Forward, function()
        local world = Horizon.Memory.Static.World
        return world.Position + (world.Velocity:normalize() * 10000)
    end)

    local retrograde = createMarker(retrogradeSVG, -world.Forward, function()
        local world = Horizon.Memory.Static.World
        return world.Position - (world.Velocity:normalize() * 10000)
    end)

    local normal = createMarker(normalSVG, -world.Right, function()
        local world = Horizon.Memory.Static.World
        local dir = world.Velocity:normalize():cross(world.Up)
        return world.Position - (dir * 10000)
    end)

    local antinormal = createMarker(antinormalSVG, world.Right, function()
        local world = Horizon.Memory.Static.World
        local dir = world.Velocity:normalize():cross(-world.Up)
        return world.Position - (dir * 10000)
    end)

    local radialin = createMarker(radialinSVG, world.Vertical, function()
        local world = Horizon.Memory.Static.World
        return world.Position + (world.Vertical * 10000)
    end)

    local radialout = createMarker(radialoutSVG, -world.Vertical, function()
        local world = Horizon.Memory.Static.World
        return world.Position - (world.Vertical * 10000)
    end)

    return this
end)()