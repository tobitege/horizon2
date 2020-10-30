--@class HUDArtificialHorizon
--@require HorizonCore
--@require HorizonModule
--@require UIController
--@require ReadingsModule
--@require UICSS

HUDArtificialHorizon = (function()
    local this = HorizonModule("HUD Artificial Horizon", "Artificial Horizon", "PreUpdate", true, 0)
    local vec2 = require("cpml/vec2")
    this.Tags = "system,hud,data"
    this.Config = {
        RollSize = 22,
        PitchSize = 30
    }
    
    Horizon.Controller.hide()
    local hud = Horizon.GetModule("UI Controller").Displays[1]

    local rollSVG = [[<svg viewBox="0 0 598 598" style="transform: rotate($(-Memory.Ship.Roll)deg)"><defs><clipPath id="a" transform="translate(-1 -1)"><path d="M0 300h600v300H0z" class="a"/></clipPath><clipPath id="b" transform="translate(-1 -1)"><path d="M0 0h600v300H0z" class="a"/></clipPath><style>.a{fill:none}.c{fill:#fff}.g{fill:#ae0f12}</style></defs><g clip-path="url(#a)"><path d="M300 30l2.29-8.12L300 0v30zM298 30l-2.28-8.12L298 0v30zM30 298l-8.12-2.28L0 298h30zM30 300l-8.12 2.29L0 300h30zM298 568l-2.28 8.12L298 598v-30zM300 568l2.29 8.12L300 598v-30zM568 300l8.12 2.29L598 300h-30zM568 298l8.12-2.28L598 298h-30zM91.11 91.11l13.55 11.74 2.72 4.53-4.53-2.72-11.74-13.55zM91.11 506.89l11.74-13.55 4.53-2.71-2.72 4.52-13.55 11.74zM506.89 506.89l-13.55-11.74-2.71-4.52 4.52 2.71 11.74 13.55zM506.89 91.11l-11.74 13.55-4.52 2.72 2.71-4.53 13.55-11.74zM188.19 31.49l3.08 10.15 1.92-.8-5-9.35zM31.49 409.81l10.15-3.08-.8-1.92-9.35 5zM409.81 566.51l-3.08-10.14-1.92.79 5 9.35zM566.51 188.19l-10.14 3.08.79 1.92 9.35-5zM31.49 188.19l9.35 5 .8-1.92-10.15-3.08zM188.19 566.51l5-9.35-1.92-.79-3.08 10.14zM566.51 409.81l-9.35-5-.79 1.92 10.14 3.08zM409.81 31.49l-5 9.35 1.92.8 3.08-10.15zM242.83114619 21.80721805l1.96157056-.39018065.75109774 3.77602333-1.96157056.39018065zM22.29773466 355.67013528l-.39018064-1.96157056 3.77602333-.75109774.39018064 1.96157056zM356.16766776 576.19117602l-1.96157056.39018064-.75109774-3.77602332 1.96157056-.39018065zM576.70150049 242.3316628l.39018064 1.96157057-3.77602333.75109774-.39018064-1.96157057zM141.06616025 64.5945224l1.66293922-1.11114047 2.1389454 3.201158-1.66293922 1.11114047zM65.08622624 457.4426866l-1.11114046-1.66293922 3.201158-2.1389454 1.11114047 1.66293923zM457.93266807 533.4104826l-1.66293923 1.11114047-2.1389454-3.201158 1.66293923-1.11114048zM533.92050114 140.57062309l1.11114047 1.66293922-3.201158 2.1389454-1.11114047-1.66293922zM63.42062458 143.0587569l1.11114047-1.66293922 3.201158 2.1389454-1.11114046 1.66293922zM143.56247801 535.08548144l-1.66293922-1.11114046 2.1389454-3.20115801 1.66293922 1.11114047zM535.58176033 454.94141596l-1.11114047 1.66293922-3.201158-2.1389454 1.11114046-1.66293922zM455.44513707 62.9243457l1.66293923 1.11114047-2.1389454 3.201158-1.66293923-1.11114046zM21.7197539 245.27862541l.39018065-1.96157056 3.77602333.75109774-.39018064 1.96157056zM245.77784687 576.78453541l-1.96157056-.39018064.75109774-3.77602333 1.96157056.39018064zM577.28531396 352.7278638l-.39018064 1.96157057-3.77602333-.75109774.39018064-1.96157056zM352.8374 22.9384l1.96.4-.77 3.773-1.96-.4z" class="c"/><circle cx="299.5" cy="299" r="282.73" fill="none" stroke="#fff" stroke-miterlimit="10" stroke-opacity=".3"/><circle cx="299.5" cy="299" r="278.93" fill="none" stroke="#fff" stroke-miterlimit="10" stroke-width=".5"/></g><g clip-path="url(#b)"><path d="M300 30l2.29-8.12L300 0v30zM298 30l-2.28-8.12L298 0v30zM30 298l-8.12-2.28L0 298h30zM30 300l-8.12 2.29L0 300h30zM298 568l-2.28 8.12L298 598v-30zM300 568l2.29 8.12L300 598v-30zM568 300l8.12 2.29L598 300h-30zM568 298l8.12-2.28L598 298h-30zM91.11 91.11l13.55 11.74 2.72 4.53-4.53-2.72-11.74-13.55zM91.11 506.89l11.74-13.55 4.53-2.71-2.72 4.52-13.55 11.74zM506.89 506.89l-13.55-11.74-2.71-4.52 4.52 2.71 11.74 13.55zM506.89 91.11l-11.74 13.55-4.52 2.72 2.71-4.53 13.55-11.74zM188.19 31.49l3.08 10.15 1.92-.8-5-9.35zM31.49 409.81l10.15-3.08-.8-1.92-9.35 5zM409.81 566.51l-3.08-10.14-1.92.79 5 9.35zM566.51 188.19l-10.14 3.08.79 1.92 9.35-5zM31.49 188.19l9.35 5 .8-1.92-10.15-3.08zM188.19 566.51l5-9.35-1.92-.79-3.08 10.14zM566.51 409.81l-9.35-5-.79 1.92 10.14 3.08zM409.81 31.49l-5 9.35 1.92.8 3.08-10.15zM242.83114619 21.80721805l1.96157056-.39018065.75109774 3.77602333-1.96157056.39018065zM22.29773466 355.67013528l-.39018064-1.96157056 3.77602333-.75109774.39018064 1.96157056zM356.16766776 576.19117602l-1.96157056.39018064-.75109774-3.77602332 1.96157056-.39018065zM576.70150049 242.3316628l.39018064 1.96157057-3.77602333.75109774-.39018064-1.96157057zM141.06616025 64.5945224l1.66293922-1.11114047 2.1389454 3.201158-1.66293922 1.11114047zM65.08622624 457.4426866l-1.11114046-1.66293922 3.201158-2.1389454 1.11114047 1.66293923zM457.93266807 533.4104826l-1.66293923 1.11114047-2.1389454-3.201158 1.66293923-1.11114048zM533.92050114 140.57062309l1.11114047 1.66293922-3.201158 2.1389454-1.11114047-1.66293922zM63.42062458 143.0587569l1.11114047-1.66293922 3.201158 2.1389454-1.11114046 1.66293922zM143.56247801 535.08548144l-1.66293922-1.11114046 2.1389454-3.20115801 1.66293922 1.11114047zM535.58176033 454.94141596l-1.11114047 1.66293922-3.201158-2.1389454 1.11114046-1.66293922zM455.44513707 62.9243457l1.66293923 1.11114047-2.1389454 3.201158-1.66293923-1.11114046zM21.7197539 245.27862541l.39018065-1.96157056 3.77602333.75109774-.39018064 1.96157056zM245.77784687 576.78453541l-1.96157056-.39018064.75109774-3.77602333 1.96157056.39018064zM577.28531396 352.7278638l-.39018064 1.96157057-3.77602333-.75109774.39018064-1.96157056zM352.8374 22.9384l1.96.4-.77 3.773-1.96-.4z" class="g"/><circle cx="299.5" cy="299" r="282.73" fill="none" stroke="#ae0f12" stroke-miterlimit="10" stroke-opacity=".3"/><circle cx="299.5" cy="299" r="278.93" fill="none" stroke="#ae0f12" stroke-miterlimit="10" stroke-width=".5"/></g></svg>]]
    local pitchSVG = [[<svg viewBox="0 1.5 20.18 721.5"><path fill="#fff" d="M10.09 720l-10 1h20l-10-1zM10.09 724l10-1h-20l10 1zM9.734 721.996l.354-.354.354.354-.354.353zM10.09 540l-10 1h20l-10-1zM10.09 544l10-1h-20l10 1zM9.735 541.997l.354-.354.353.354-.353.353zM10.09 360l-10 1h20l-10-1zM10.09 364l10-1h-20l10 1zM9.736 361.997l.354-.353.353.353-.353.354zM10.09 180l-10 1h20l-10-1zM10.09 184l10-1h-20l10 1zM9.737 181.998l.353-.353.354.353-.354.354zM10.09 0l-10 1h20l-10-1zM10.09 4l10-1h-20l10 1zM9.738 1.999l.353-.354.354.354-.354.353z"/><path fill="none" stroke="#fff" stroke-miterlimit="10" stroke-width=".25" d="M.09 634.5l2.5-2.5h15l2.5 2.5M.09 629.5l2.5 2.5h15l2.5-2.5M.09 454.5l2.5-2.5h15l2.5 2.5M.09 449.5l2.5 2.5h15l2.5-2.5M.09 274.5l2.5-2.5h15l2.5 2.5M.09 269.5l2.5 2.5h15l2.5-2.5M.09 94.5l2.5-2.5h15l2.5 2.5M.09 89.5l2.5 2.5h15l2.5-2.5M.09 319.5l2.5-2.5h15l2.5 2.5M.09 224.5l2.5 2.5h15l2.5-2.5M.09 404.5l2.5 2.5h15l2.5-2.5M.09 584.5l2.5 2.5h15l2.5-2.5M.09 44.5l2.5 2.5h15l2.5-2.5M.09 499.5l2.5-2.5h15l2.5 2.5M.09 679.5l2.5-2.5h15l2.5 2.5M.09 139.5l2.5-2.5h15l2.5 2.5M6.09 24.5h8M6.09 69.5h8M6.09 114.5h8M6.09 159.5h8M6.09 204.5h8M6.09 249.5h8M6.09 294.5h8M6.09 339.5h8M6.09 384.5h8M6.09 429.5h8M6.09 474.5h8M6.09 519.5h8M6.09 564.5h8M6.09 609.5h8M6.09 654.5h8M6.09 699.5h8"/><path fill="none" stroke="#fff" stroke-dasharray=".23 11.02" stroke-miterlimit="10" d="M10.09 1.87v720"/></svg>]]
    local horizonSVG = [[<svg style="transform: translateY(-50%) translateY($(Height*0.5)vh) rotate($(-Memory.Ship.Roll)deg) scale(1.5)" viewBox="0 0 600 24.25"><path fill="none" stroke="#fff" stroke-miterlimit="10" stroke-width=".25" d="M600 12.13H340l-20-12h-40l-20 12-260 .5"/><path fill="none" stroke="#fff" stroke-miterlimit="10" stroke-width=".25" d="M0 12.13h260l20 12h40l20-12h260"/><path fill="#fff" d="M280 3.2l-15.13 8.93L280 20.54l-14.47-8.41L280 3.2zM320 3.2l15.13 8.93L320 20.54l14.47-8.41L320 3.2z"/><path fill="#fff" stroke="#fff" stroke-miterlimit="10" stroke-opacity=".4" stroke-width=".25" d="M265.53 12.13h68.94"/></svg>]]

    local function createHUD(size)
        local xform = hud.TransformSize(size)
        local panel = UIPanel(50, 50, xform.x, xform.y)
        panel.Anchor = UIAnchor.Middle
        panel.AlwaysDirty = true
        panel.Memory = Horizon.Memory.Static
        panel.Zindex = -100
        return panel, xform
    end

    local roll, rollXform = createHUD(this.Config.RollSize)

    roll.Style = roll.Style .. "-webkit-mask-image:-webkit-linear-gradient(bottom, rgba(0,0,0,1) 40%, rgba(0,0,0,0) 60%)"
    roll.Content = rollSVG

    local rollText = UIPanel(rollXform.x * 0.5, rollXform.y, 4,4)
    rollText.Anchor = UIAnchor.TopCenter
    rollText.Memory = Horizon.Memory.Static
    rollText.Transform = function(roll)
        if roll > 180 then roll = roll - 360 end
        local roll = math.floor(roll * 10 + 0.5) / 10
        return math.abs(roll)
    end
    rollText.Content = [[<readout>$(Transform(Memory.Ship.Roll))</readout>
    <div style="position:absolute;width:4vw;height:4vh;top:1vh;">
        <svg viewBox="0 0 2.57 23" style="display: block;height:2vh;margin: 0 auto;"><path fill="#fff" d="M1.28 0l1.29 17.88L1.28 23 0 17.88 1.28 0z"/></svg>
    </div>]]
    rollText.AlwaysDirty = true
    roll.AddChild(rollText)

    local horizon = createHUD(this.Config.RollSize)
    horizon.Style = horizon.Style .. [[-webkit-mask-image:-webkit-radial-gradient(rgba(0,0,0,1) 50%, rgba(0,0,0,0) 65%)]]
    horizon.Content = horizonSVG

    local pitch, pitchXform = createHUD(this.Config.PitchSize)
    pitch.Transform = function(pitch)
        pitch = (pitch % 360) / 360
        return -25 + (math.abs(pitch) * 50)
    end
    pitch.Style = pitch.Style..[[-webkit-mask-image: -webkit-radial-gradient(rgba(0,0,0,1) 25%, rgba(0,0,0,0) 40%)]]
    pitch.Content = [[
        <panel style="position:fixed;width:$(Width)vw;height:$(Height)vh;transform: scale(2.5) rotate($(-Memory.Ship.Roll)deg) translateY($(Transform(-Memory.Ship.Pitch))%)">
        ]].. pitchSVG ..[[
        </panel>
    ]]

    local pitchText = UIPanel(pitchXform.x * 0.5,(pitchXform.y * 0.5) + 1, 4,3)
    pitchText.Anchor = UIAnchor.TopCenter
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
    hud.AddWidget(horizon)
    hud.AddWidget(roll)

    return this
end)()