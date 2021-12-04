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
--@require ARInteract
--@require HUDOrbitalMarkers

--@class ARMain
--@outFilename AR-Standard.json

_G.BuildUnit = {}
local Unit = _G.BuildUnit
_G.BuildSystem = {}
local System = _G.BuildSystem
_G.BuildReceiver = {}
local Receiver = _G.BuildReceiver
_G.BuildScreen = {}
local Screen = _G.BuildScreen

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

function Unit.Tick(timer)
end

function Receiver.Received(channel, message, slot)
    Horizon.Emit("Comms.Message."..channel, channel, message)
end

function Screen.MouseDown(x, y, slot)
end

function Screen.MouseUp(x, y, slot)
end