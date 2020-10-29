--require FuelTanks.lua

SlotContainer = (function()
    local self = {}
    function self.new()
        return {
            FoundIDs={}, 
            Engines={Atmo={}, Rocket={}, Space={}, VerticalBooster={}}, 
            FuelTanks={Atmo={}, Rocket={}, Space={}}, 
            Core=nil,
            Unit=nil,
            Screens={}, 
            Telemeters={}, 
            Radars={}, 
            AntiGrav={}, 
            Databanks={}, 
            Doors={}
        }
    end
    return self
end)()

SlotUtilities = (function()
    local self = {}

    function self.GetFuelCapacity(fuelTanks)
        local capacity = 0
        for i,tank in ipairs(fuelTanks) do
            capacity = capacity+tank.ContainerType.Capacity
        end
        return capacity
    end
    function self.GetAvailableFuel(fuelTanks)
        local fuel = 0
        for i,tank in ipairs(fuelTanks) do
            local tankMass = tank.getItemsMass()
            fuel = fuel + (tankMass/tank.ContainerType.FuelType.Mass)
        end
        return fuel
    end

    function self.GetBaseMaxThrust(engines)
        local thrust = 0
        for i,engine in ipairs(engines) do
            thrust = thrust+engine.getMaxThrustBase()
        end
        return thrust
    end
    function self.GetCurrentMaxThrust(engines)
        local totalThrust = 0
        local thrust = 0
        for i,engine in ipairs(engines) do
            --Currently bugged? returns 0
            --thrust = thrust+engine.getCurrentMaxThrust()
            thrust = thrust + engine.getMaxThrustEfficiency()
            totalThrust = totalThrust + engine.getMaxThrustBase()
        end
        thrust = (totalThrust/#engines) * (thrust/#engines)
        return thrust
    end
    function self.GetCurrentThrust(engines)
        local thrust = 0
        for i,engine in ipairs(engines) do
            thrust = thrust+engine.getThrust()
        end
        return thrust
    end

    function self.GetAverageTelemeterDistance(telemeters)
        local distance = 0
        local telemeterCount = 0
        for i,telemter in ipairs(telemeters) do
            local tDistance = telemter.getDistance()
            if tDistance > -1 then
                distance = distance+tDistance
                telemeterCount = telemeterCount+1
            end
        end
        return distance/telemeterCount
    end

    return self
end)()

SlotDetector = (function()
    local self = {}

    function self.VirtualSlot(unitID)
        --Override this method if needed
        --Acts as a proxy
        return unitID
    end

    local function round(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end

    local function identifyUnit(var, slots)
        if type(var) ~= "table" then return slots end
        if var["getElementClass"] then
            local id = var["getId"]()
            
            if id == nil then 
                return slots
            end


            if slots.FoundIDs[id] ~= nil then return slots end
            slots.FoundIDs[id] = true

            local class = var["getElementClass"]()

            if class == "SpaceFuelContainer" then
                local mass = round(var.getSelfMass(),2)

                for k,fuelTank in pairs(FuelTanks.Space) do
                    if mass==fuelTank.Mass then var.ContainerType = fuelTank break end
                end

                table.insert(slots.FuelTanks.Space, var)
                return slots
            end

            if class == "AtmoFuelContainer" then
                local mass = round(var.getSelfMass(),2)

                for k,fuelTank in pairs(FuelTanks.Atmosphere) do
                    if mass==fuelTank.Mass then var.ContainerType = fuelTank break end
                end

                table.insert(slots.FuelTanks.Atmo, var)
                return slots
            end

            if class == "RocketFuelContainer" then
                local mass = round(var.getSelfMass(),2)

                for k,fuelTank in pairs(FuelTanks.Rocket) do
                    if mass==fuelTank.Mass then var.ContainerType = fuelTank break end
                end

                table.insert(slots.FuelTanks.Rocket, var)
                return slots
            end

            if class == "ScreenUnit" then
                table.insert(slots.Screens, var)
                return slots
            end

            if class == "DoorUnit" then
                table.insert(slots.Doors, var)
                return slots
            end

            if class == "DataBankUnit" then
                table.insert(slots.Databanks, var) 
                return slots
            end

            if class == "TelemeterUnit" then
                table.insert(slots.Telemeters, var)
                return slots
            end

            --Core unit
            if class == "CoreUnitDynamic" or class == "CoreUnitStatic" or class == "CoreUnitSpace" then
                slots.Core = var 
                return slots
            end

            if string.find(class, "SpaceEngine") then 
                table.insert(slots.Engines.Space, var)
                return slots
            end

            if string.find(class, "AtmosphericEngine") then 
                table.insert(slots.Engines.Atmo, var)
                return slots
            end

            if string.find(class, "RocketEngine") then 
                table.insert(slots.Engines.Rocket, var)
                return slots
            end

            if string.find(class, "VerticalBooster") then 
                table.insert(slots.Engines.VerticalBooster, var)
                return slots
            end

            if class == "CockpitFighterUnit" or class == "CockpitHovercraftUnit" or class == "CockpitCommandmentUnit" or class == "RemoteControlUnit" or class == "Generic" then
                slots.Unit = var
                return slots
            end

        end
        
        return slots
    end

    function self.DetectSlotsInNamespace(container, slotContainer)
        local slots = slotContainer or SlotContainer.new() 

        for slotName,var in pairs(container) do
            slots = identifyUnit(var, slots)
        end

        return slots
    end

    function self.DetectSlotsFromList(list, slotContainer)
        local slots = slotContainer or SlotContainer.new()

        for k,v in pairs(list) do
            local slot = self.VirtualSlot(v)
            slots = identifyUnit(slot, slots)
        end

        return slots
    end
    
    return self
end)()