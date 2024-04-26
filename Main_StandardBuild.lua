--@require LoggingModule
--@require ThrustControlModule
--@require ManeuverFlightMode
--@require RotationDampeningModule
--@require BrakingModule
--@require CruiseControlModule
--@require GravityCounterModule
--@require InertialDampeningModule
--@require MouseSteeringModule
--@require GravityFollow
--@require HUDArtificialHorizon
--@require HUDSimpleStats
--@require HUDVersion

--@class Main
--@outFilename Standard.json

_G.BuildUnit = {}
local Unit = _G.BuildUnit
_G.BuildSystem = {}
local System = _G.BuildSystem

function Unit.onStart()
    Horizon.Event.Start()
end

function Unit.onStop()
    Horizon.Event.Stop()
end

function Unit.onTimer(timer)
end

function System.onActionStart(action)
    Horizon.Event.KeyDown(action)
end

function System.onActionStop(action)
    Horizon.Event.KeyUp(action)
end

function System.onActionLoop(action)
end

function System.onUpdate()
    Horizon.Event.PreUpdate() Horizon.Event.Update() Horizon.Event.PostUpdate()
end

function System.onFlush()
    Horizon.Event.PreFlush() Horizon.Event.Flush() Horizon.Event.PostFlush()
end