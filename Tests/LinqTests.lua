return (function()
    local this = {}

    function this.TestSelect()
        -- Don't run if Linq isn't loaded
        if not Linq then return end

        -- Arrange
        local data = Linq({
            {Name = "One", IsEnabled = true},
            {Name = "Two", IsEnabled = true},
            {Name = "Three", IsEnabled = false},
            {Name = "Four", IsEnabled = false}
        })

        -- Act
        local enabled = data.Select("IsEnabled").ToArray()
        local disabled = data.Select(function(v, k) return v.IsEnabled end)

        -- Assert
        assert(
            enabled[1] == true and 
            enabled[2] == true and 
            enabled[3] == false and
            enabled[4] == false
            , "Select() should return the property of each element when predicate is a string.")

        assert(
            enabled[1] == true and 
            enabled[2] == true and 
            enabled[3] == false and
            enabled[4] == false
            , "Select() should return the property of each element when predicate is a function.")
    end

    function this.TestWhere()

    end

    function this.TestAll()
        -- Don't run if Linq isn't loaded
        if not Linq then return end

        -- Arrange
        local data = Linq({1,2,3,4,5,6,7,8,9})

        -- Act
        local containsElements = data.All()
        local allGreaterThanZero = data.All(function (v,k) return v>0 end)
        local allLessThanZero = data.All(function (v,k) return v<0 end)
        

        -- Assert
        assert(containsElements == true, "All() should return true for a non-empty collection.")
        assert(allGreaterThanZero == true, "Should be true for array of greater than 0 values.")
        assert(allLessThanZero == false, "Should be false for array of greater than 0 values.")
    end

    return this
end)()