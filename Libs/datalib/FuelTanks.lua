--require Fuels.lua

FuelTanks = {
        Space = {
            SpaceFuelSmall = {Name="Space Fuel Tank S", Class = "S", Mass = 182.67, Capacity = 400, FuelType=Fuels.Kergon},
            SpaceFuelMedium = {Name="Space Fuel Tank M", Class = "M", Mass = 988.67, Capacity = 1600, FuelType=Fuels.Kergon},
            SpaceFuelLarge = {Name="Space Fuel Tank L", Class = "L", Mass = 5480, Capacity = 12800, FuelType=Fuels.Kergon},
        },

        Atmosphere = {
            AtmosphericFuelExtraSmall = {Name="Atmospheric Fuel Tank XS", Class = "XS", Mass = 35.03, Capacity = 100, FuelType=Fuels.Nitron},
            AtmosphericFuelSmall = {Name="Atmospheric Fuel Tank S", Class = "S", Mass = 182.67, Capacity = 400, FuelType=Fuels.Nitron},
            AtmosphericFuelMedium = {Name="Atmospheric Fuel Tank M", Class = "M", Mass = 988.67, Capacity = 1600, FuelType=Fuels.Nitron},
            AtmosphericFuelLarge = {Name="Atmospheric Fuel Tank L", Class = "L", Mass = 5480, Capacity = 12800, FuelType=Fuels.Nitron},
        },

        Rocket = {
            RocketFuelExtraSmall = {Name="Rocket Fuel Tank XS", Class = "XS", Mass = 173.42, Capacity = 400, FuelType=Fuels.Xeron},
            RocketFuelSmall = {Name="Rocket Fuel Tank S", Class = "S", Mass = 886.72, Capacity = 800, FuelType=Fuels.Xeron},
            RocketFuelMedium = {Name="Rocket Fuel Tank M", Class = "M", Mass = 4720, Capacity = 6400, FuelType=Fuels.Xeron},
            RocketFuelLarge = {Name="Rocket Fuel Tank L", Class = "L", Mass = 25740, Capacity = 50000, FuelType=Fuels.Xeron},
        }
}
