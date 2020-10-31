--@require LoggingModule
--@require ThrustControlModule
--@require ManeuverFlightMode
--@require RotationDampeningModule
--@require BrakingModule
--@require GravityCounterModule
--@require MouseSteeringModule
--@require HUDArtificialHorizon
--@require HUDSimpleStats
--@require HUDVersion

--@class Main
--@outFilename Standard.json

_G.BuildUnit = {}
local Unit = _G.BuildUnit
_G.BuildSystem = {}
local System = _G.BuildSystem

function Unit.Start()
    Horizon.Event.Start()
end

function Unit.Stop()
    Horizon.Event.Stop()
end

function Unit.Tick(timer)
end

function System.ActionStart(action)
    Horizon.Event.KeyDown(action)
end

function System.ActionStop(action)
    Horizon.Event.KeyUp(action)
end

function System.ActionLoop(action)
end

function System.Update()
    Horizon.Event.PreUpdate() Horizon.Event.Update() Horizon.Event.PostUpdate()
end

function System.Flush()
    Horizon.Event.PreFlush() Horizon.Event.Flush() Horizon.Event.PostFlush()
end