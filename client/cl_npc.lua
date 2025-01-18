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
            CreateThread(function()
                Wait(1250)
                FreezeEntityPosition(ped, true)
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", 0, true)
            end)

            print("Created ped " .. ped .. " for location #" .. i .. " of kind " .. data.kind)
            cleanupHandler(function() DeleteEntity(ped) end)
        end
    end
end)
