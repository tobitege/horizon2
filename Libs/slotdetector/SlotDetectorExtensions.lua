SlotDetector.VirtualSlot = function(unitID)
    local self = {}

    if type(unitID) == "table" then
        --This is a real slot
        return unitID
    else
        self.ID = unitID
        local mt = {}
        mt.__index = function(t,k) return function(...) return _NQ_execute_method(t.ID, k, ...) end end
        mt.__tostring = function(t) return "Virtual Slot" end
        setmetatable(self, mt)
    end

    return self
end