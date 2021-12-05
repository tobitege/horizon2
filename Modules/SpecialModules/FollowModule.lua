--@class OwnerFollowModule
--@require HorizonCore
--@require HorizonModule
--@require ThrustControlModule
--@require BrakingModule
--@require ReadingsModule
--@require GravityFollowModule
--@require GravityCounterModule
--@require AltitudeHoldModule
--@require RotationDampeningModule

OwnerFollowModule = (function() 
    local this = HorizonModule("Owner Follow", "When enabled the construct will follow the player", "PostFlush", true)
    this.Tags = "autopilot"
    this.Config.FollowDistance = 10
    this.Config.RotateSpeed = 2
    this.Config.MaxSpeed = 50
    this.Config.IdleShutdown = true
    this.Config.IdleThreshold = 5
    this.Config.HoverHeight = 4
    this.Config.MaxYawDeviation = 0.09 --In Radians
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    
    local rad2deg = 57.295779513

    local altHold = nil
    local braking = nil
    local lastMasterMove = nil
    local lastMasterLocation = nil
    local brakingForce = nil
    --

    local function brakingDistance(velocity, maxBrakingForce, mass)
        local maxDeccel = maxBrakingForce / mass
        local brakingTime = velocity / maxDeccel
        return (0.5 * velocity) * brakingTime
    end

    function this.Update(eventType, deltaTime)
        local world = Horizon.Memory.Static.World
        local ship = Horizon.Memory.Static.Ship
        local dship = Horizon.Memory.Dynamic.Ship

        ---@diagnostic disable-next-line: undefined-field
        brakingForce = brakingForce or require('dkjson').decode(Horizon.Controller.getData()).maxBrake * 0.5
        braking = braking or Horizon.GetModule("Velocity Braking")
        altHold = altHold or Horizon.GetModule("Altitude Hold")

        --If the altitude hold module isnt available, fallback to altitude stabilization (aka le bounce)
        if not altHold then
            Horizon.Controller.activateGroundEngineAltitudeStabilization(1)
        else
            Horizon.Controller.deactivateGroundEngineAltitudeStabilization()
        end

        local playerRelativePosition = vec3(Horizon.Controller.getMasterPlayerRelativePosition())
        local playerLocalPosition = Utils3d.worldToLocal(playerRelativePosition, world.Up, world.Right, world.Forward)
        local playerLocalPositionNorm = playerLocalPosition:normalize()
        local playerDistance = playerRelativePosition:len()

        if lastMasterMove == nil or (lastMasterLocation - playerRelativePosition):len() > this.Config.IdleThreshold then
            lastMasterMove = system.getTime()
            lastMasterLocation = playerRelativePosition
        end

        if lastMasterMove < system.getTime()-30 and this.Config.IdleShutdown then
            braking.Enable()
            altHold.Config.HoldAltitude = 0
            return
        end

        local currentVelocity = world.Velocity:len()
        local yawToTarget = math.atan(playerLocalPositionNorm.x, playerLocalPositionNorm.y)

        local altitudeDifference = playerLocalPosition.z + this.Config.HoverHeight
        local targetAltitude = ship.Altitude + altitudeDifference

        if altHold then
            if not altHold.Enabled then altHold.Enable() end
            altHold.Config.HoldAltitude = targetAltitude
        end

        local rotationToApply = world.Up * (-yawToTarget * this.Config.RotateSpeed)
        dship.Rotation = dship.Rotation + rotationToApply

        local brakingDistance = brakingDistance(currentVelocity, brakingForce, ship.Mass)

        if (playerDistance > this.Config.FollowDistance) and (brakingDistance < playerDistance) and math.abs(yawToTarget)<this.Config.MaxYawDeviation and currentVelocity < this.Config.MaxSpeed then
            --Thrust towards player
            dship.Thrust = dship.Thrust + (world.Forward*this.Config.MaxSpeed)
            if braking then braking.Disable() end
        else
            if braking then braking.Enable() end
        end

    end

    return this
end)()