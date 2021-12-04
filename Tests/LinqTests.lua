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
        local enabled = data.Select("Enabled").ToArray()

        system.print(data.Select("Enabled").Count())
        data.Select("Enabled").Dump()

        -- Assert
        assert(
            enabled[1] == true and 
            enabled[2] == true and 
            enabled[3] == false and
            enabled[4] == false
            , "Select() should return the property of each element when predicate is a string.")
    end

    function this.TestAll()
        -- Don't run if Linq isn't loaded
        if not Linq then return end

        -- Arrange
        local data = Linq({1,2,3,4,5,6,7,8,9})

        -- Act
        local containsElements = data.All()
        

        -- Assert
        assert(containsElements == true, "All() should return true for a non-empty collection.")
    end

    return this
end)()