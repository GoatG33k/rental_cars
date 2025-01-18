local RentalConfig = Config ---@as RentalCarsConfig
CreateThread(function()
    local dist <const> = 5.0;

    -- Register each of the spawn points
    for i, data in pairs(RentalConfig.Locations) do
        local name = "rental_cars_menu_" .. i
        local pos = data.pedCoords
        print("Registering " .. data.kind .. " rental location with " .. RentalConfig.Resources.Target .. " at " .. pos)

        if RentalConfig.Resources.Target == "ox_target" then
            exports.ox_target:addSphereZone({
                name = name,
                coords = vector3(pos[1], pos[2], pos[3]),
                radius = dist,
                options = {
                    distance = dist,
                    onSelect = function() TriggerServerEvent("rental_cars:requestMenu", i) end,
                    icon = "",
                    label = "Rent " .. data.kind,
                }
            })
            cleanupHandler(function() exports.ox_target:removeZone(name) end)
        end
    end
end)