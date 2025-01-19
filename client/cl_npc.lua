local RentalConfig = Config ---@as RentalCarsConfig

--- A thread to create all of the NPCs
CreateThread(function()
    for i, data in pairs(RentalConfig.Locations) do
        local pos = data.pedCoords
        local pedModel = data.pedModel

        -- Create blip
        local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
        SetBlipSprite(blip, data.blip and data.blip.sprite or 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, data.blip and data.blip.color or 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Vehicle Rentals")
        EndTextCommandSetBlipName(blip)
        cleanupHandler(function() RemoveBlip(blip) end)

        -- Create ped
        RequestModel(pedModel)
        local n = 0
        while not HasModelLoaded(pedModel) and n < 1000 do
            RequestModel(pedModel)
            Wait(10)
            n = n + 1
        end

        if n >= 1000 then
            print("^1Failed to load ped model " ..
                pedModel .. " for location #" .. i .. " of kind " .. data.kind .. "... skipping")
        else
            local ped = CreatePed(5, pedModel, pos[1], pos[2], pos[3], pos[4], false, false)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            TaskStartScenarioInPlace(ped, data.scenario or "WORLD_HUMAN_STAND_MOBILE", 0, true)
            cleanupHandler(function() DeleteEntity(ped) end)

            local dist <const> = 5.0;
            local name = "rental_cars_menu_" .. i
            if RentalConfig.Resources.Target == "ox_target" then
                -- Rent car
                exports.ox_target:addLocalEntity({ ped }, {
                    name = name,
                    onSelect = function() TriggerServerEvent("rental_cars:requestMenu", i) end,
                    icon = "fa-solid fa-car",
                    label = "Rent " .. data.kind,
                })
                -- Return car
                exports.ox_target:addLocalEntity({ ped }, {
                    name = name .. "_return",
                    onSelect = function() TriggerServerEvent("rental_cars:return", i) end,
                    icon = "fa-solid fa-car",
                    label = "Return Rental"
                })
                cleanupHandler(function() exports.ox_target:removeZone(name) end)
            end
        end
    end
end)

--- Create targets on the NPC
CreateThread(function()
    -- Register each of the spawn points
    for i, data in pairs(RentalConfig.Locations) do
        local name = "rental_cars_menu_" .. i
        local pos = data.pedCoords
        print("Registering " .. data.kind .. " rental location with " .. RentalConfig.Resources.Target .. " at " .. pos)
    end
end)
