---@diagnostic disable: undefined-global
--@require StateMachine
Floors = {697.5, 811.25, 1066.7, 9000, 29966.3, 30000}
SelectedAltitude = Floors[1]

StateMachine = (function()
    local this = {}
    this.Current = nil
    this.Update = function()
        local state = this.Current
        if state then
            if state.Condition() then
                state.End()
                if state.Next ~= nil then
                    system.print("State change: " .. state.Next.Name)
                    this.Current = state.Next
                    state.Next.Start()
                end
            else
                state.Action()
            end
        end
    end
    return this
end)

State = (function(name, condition, action, nextState)
    local this = {}
    setmetatable(this, {__call = function(ref, ...) ref.Update(...) end, _name = "State" })
    this.Name = name or "State"
    this.Next = nextState
    this.Condition = condition or function() return true end
    this.Start = function() end
    this.End = function() end
    this.Action = action or function() end
    return this
end)

ElevatorState = StateMachine()

SafeDeviation = 0.175
OvershootDistance = 0.25
FinalDistance = 0.05

local function computeDistanceAndTime(initial, final, restMass, thrust, t50, brakeThrust)
    local C       = 30000000/3600
    local C2      = C*C
    local ITERATIONS = 100 -- iterations over engine "warm-up" period
    local function lorentz(v) return 1/math.sqrt(1 - v*v/C2) end
    t50            = t50 or 0
    brakeThrust    = brakeThrust or 0 -- usually zero when accelerating
    local tau0     = lorentz(initial)
    local speedUp  = initial <= final
    local a0       = thrust * (speedUp and 1 or -1)/restMass
    local b0       = -brakeThrust/restMass
    local totA     = a0+b0
    if speedUp and totA <= 0 or not speedUp and totA >= 0 then
        return -1, -1 -- no solution
    end
    local distanceToMax, timeToMax = 0, 0

    if a0 ~= 0 and t50 > 0 then

        local k1  = math.asin(initial/C)
        local c1  = math.pi*(a0/2+b0)
        local c2  = a0*t50
        local c3  = C*math.pi
        local v = function(t)
            local w  = (c1*t - c2*math.sin(math.pi*t/2/t50) + c3*k1)/c3
            local tan = math.tan(w)
            return C*tan/math.sqrt(tan*tan+1)
        end
        local speedchk = speedUp and function(s) return s >= final end or
                                        function(s) return s <= final end
        timeToMax  = 2*t50
        if speedchk(v(timeToMax)) then
            local lasttime = 0
            while math.abs(timeToMax - lasttime) > 0.5 do
                local t = (timeToMax + lasttime)/2
                if speedchk(v(t)) then
                    timeToMax = t 
                else
                    lasttime = t
                end
            end
        end
        -- There is no closed form solution for distance in this case.
        -- Numerically integrate for time t=0 to t=2*T50 (or less)
        local lastv = initial
        local tinc  = timeToMax/ITERATIONS
        for step = 1, ITERATIONS do
            local speed = v(step*tinc)
            distanceToMax = distanceToMax + (speed+lastv)*tinc/2
            lastv = speed
        end
        if timeToMax < 2*t50 then
            return distanceToMax, timeToMax
        end
        initial     = lastv
    end

    local k1       = C*math.asin(initial/C)
    local time     = (C * math.asin(final/C) - k1)/totA
    local k2       = C2 *math.cos(k1/C)/totA
    local distance = k2 - C2 * math.cos((totA*time + k1)/C)/totA
    return distance+distanceToMax, time+timeToMax
end

local function inThreshold(val, min, max)
    max = max or min
    return val >= min and val <= max
end

local function getDeviation()
    local world = Horizon.Memory.Static.World
    local shaftPosition = vec3(17442780.353266, 22652121.214105, 1966.7768210021)
    local shaftDirection = vec3(-0.50779713085979 , -0.29884835341439 , 0.80798041515116)
    local localPos = (world.Position + world.Velocity) - shaftPosition
    local intersectionPos = shaftDirection * shaftDirection:dot(localPos)
    local intersectionVec = intersectionPos - localPos
    return intersectionVec:len()
end

local function moveToTarget(dampen,modifier)
    ---@diagnostic disable-next-line: undefined-field
    local maxBrake = require('dkjson').decode(unit.getData()).maxBrake
    local ship = Horizon.Memory.Dynamic.Ship
    local world = Horizon.Memory.Static.World
    local stats = Horizon.Memory.Static.Ship
    local distance = SelectedAltitude - stats.Altitude

    local sign = 1
	local maxF = stats.MaxKinematics.Up
    if distance < 0 then sign = -1 maxF = stats.MaxKinematics.Down end
    --local dist, time = computeDistanceAndTime(math.abs(world.VerticalVelocity), 0, stats.Mass, math.abs(maxF - (world.AirFriction:len() * stats.Mass)), 4, maxBrake)
	local dist, time = computeDistanceAndTime(math.abs(world.VerticalVelocity), 0, stats.Mass, math.abs(ship.Thrust:len() + distance), 0, maxBrake)
	if (math.abs(world.VerticalVelocity) < 333 and world.AtmosphericDensity > 0.001) or world.AtmosphericDensity < 0.001 then
        ship.Thrust = ship.Thrust + (world.Up * (distance - (world.VerticalVelocity * dampen) + (-sign * dist)) * modifier)
	end
end

local function engageSafety()
    lasers.deactivate()
    doors.activate()
end

CheckClamps = State("Check if Docking Clamps", function()
    local dist = telemeter.getDistance()
    if dist == -1 or dist > 5 then return true end
end)

Equalize = State("Equalize Deviation", function()
    if getDeviation() < SafeDeviation then return true end
    return false
end, function() end)
Equalize.Start = engageSafety

MoveToFloor = State("Move to Altitude",
function()
    local margin = OvershootDistance * 0.1 --0.025
    if inThreshold(core.getAltitude(), SelectedAltitude - margin, SelectedAltitude + margin) then 
        return true
    end
end,
function()
    if getDeviation() > SafeDeviation then
        return
    end
    moveToTarget(1,1)
end)
MoveToFloor.Start = engageSafety

FinalizeAltitude = State("Finalize Altitude",
function()
    local distance = math.abs(SelectedAltitude - core.getAltitude())
    local world = Horizon.Memory.Static.World
    local vertical = world.VerticalVelocity
    if distance <= FinalDistance and math.abs(vertical) < 0.1 then 
        return true 
    end
end,
function()
    lasers.deactivate()
    if getDeviation() > SafeDeviation * 0.5 then
        return
    end
    moveToTarget(5,1)
end)
FinalizeAltitude.Start = engageSafety

DockToFloor = State("Dock to Floor",
function()
    local distance = math.abs(SelectedAltitude - core.getAltitude())
    if distance >= FinalDistance * 1000 then
        DockToFloor.Next = FinalizeAltitude
        return true
    elseif system.getTime() - DockToFloor.StartTime > 6 then
        local dist = telemeter.getDistance()
        if dist > 0 and dist <= 5 then
            DockToFloor.Next = Disengage
            return true
        end
    end
    return false 
end,
function()
    lasers.activate()
    if not inThreshold(getDeviation(), 0, SafeDeviation * 0.25) then return end
    moveToTarget(10,1)
end)
DockToFloor.Start = function() 
    DockToFloor.StartTime = system.getTime()
end

Disengage = State("Disengage Controls")
Disengage.Start = function()
    lasers.deactivate()
    doors.deactivate()
    unit.exit()
end

CheckClamps.Next = Equalize
Equalize.Next = MoveToFloor
MoveToFloor.Next = FinalizeAltitude
FinalizeAltitude.Next = DockToFloor

-- Begin SM
ElevatorState.Current = CheckClamps
Equalize.Start()