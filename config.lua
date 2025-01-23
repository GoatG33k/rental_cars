---@type RentalCarsConfig
Config = {
    --- The unique item key for the rental papers
    ItemKey = "rentalpapers",

    --- Configure integrations with other resources
    Resources = {
        --- Set the framework you want to use here.
        ---
        ---   Supported:
        ---     "qbx_core" (QBox)
        ---
        Framework = "qbx_core",

        --- Set the framework you want to use for rendering menus
        ---
        ---   Supported:
        ---     "qbx_core" (QBox core menu)
        ---
        Menu = "qbx_core",

        --- The targeting resource to integrate with
        ---
        ---   Supported:
        ---     "ox_target"
        ---
        Target = "ox_target",

        --- The notification resource to integrate with
        ---
        ---   Supported:
        ---     "qbx_core"  (QBox)
        ---
        Notify = "qbx_core",

        --- The inventory resource to integrate with
        ---
        ---   Supported:
        ---     "ox_inventory"
        ---
        Inventory = "ox_inventory",
    },
    -- Future locations data, see below!
    Locations = {},
}

---
--- Use the area below here to define your locations
---
---   Each location includes:
---     * kind      - a vehicle kind (vehicle, aircraft, boat)
---     * pedModel  - a ped model to use
---     * scenario  - a ped scenario to play
---     * pedCoords - the coordinates for the ped
---     * vehSpawn  - the coordinates for the vehicle spawn point
---     * vehicles  - a list of vehicles available at this location
---     * blip?     - custom options for blips
---

addLocation {
    kind = "vehicle",
    pedModel = `a_m_y_business_03`,
    scenario = "WORLD_HUMAN_COP_IDLES",
    pedCoords = vector4(114.6518, -1083.8407, 28.1613, 72.3361),
    vehSpawn = vector4(111.4223, -1081.24, 29.192, 340.0),
    blip = { color = 50, sprite = 56 },
    vehicles = {
        { model = "futo",    dailyCost = 600 },
        { model = "bison",   dailyCost = 800 },
        { model = "sanchez", dailyCost = 750 },
    }
}

-- addLocation {
--     kind = "aircraft",
--     pedModel = `s_m_y_airworker`,
--     scenario = "WORLD_HUMAN_COP_IDLES",
--     pedCoords = vector4(-1686.57, -3149.22, 12.99, 240.88),
--     vehSpawn = vector4(-1673.4, -3158.47, 13.99, 331.49),
--     blip = { color = 32, sprite = 578 },
--     vehicles = {
--         { model = "seasparrow", dailyCost = 7500 },
--         { model = "frogger2",   dailyCost = 9500 },
--         { model = "swift",      dailyCost = 11000 },
--     }
-- }

-- addLocation {
--     kind = "boat",
--     pedModel = `mp_m_boatstaff_01`,
--     scenario = "WORLD_HUMAN_COP_IDLES",
--     pedCoords = vector4(-753.5, -1512.27, 4.02, 25.61),
--     vehSpawn = vector4(-794.95, -1506.27, 1.08, 107.79),
--     blip = { color = 42, sprite = 410 },
--     vehicles = {
--         { model = "seashark3", dailyCost = 5000 },
--         { model = "dinghy3",   dailyCost = 7500 },
--         { model = "longfin",   dailyCost = 11000 },
--     }
-- }
