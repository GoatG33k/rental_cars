local RentalConfig = Config ---@as RentalCarsConfig

-- Support displaying notifications from the server
---@param msg string
---@param kind "error"|"warning"|"info"
---@param durationMs number
RegisterNetEvent("rental_cars:notify", function(msg, kind, durationMs)
    if RentalConfig.Resources.Notify == "qbx_core" then
        exports[RentalConfig.Resources.Notify]:Notify(msg, kind, durationMs)
    else
        error("Unable to handle unsupported notification framework: " .. RentalConfig.Resources.Notify)
    end
end)

RegisterNetEvent("rental_cars:openMenu", function(idx)
    print("Server told us to open #" .. idx .. "!")
    CreateMenu(idx)
end)


---@param idx number
---@param netID number|nil
RegisterNetEvent("rental_cars:spawn", function(idx, netID)
    ---@type Entity
    local vehicleEntity = 0
    local location = RentalConfig.Locations[idx]

    if netID ~= nil then
        for i = 1, 1000 do
            i += 1
            vehicleEntity = NetworkGetEntityFromNetworkId(netID)
            if vehicleEntity and vehicleEntity ~= 0 then break end
            if i >= 1000 then return end
        end
    end

    if not vehicleEntity or vehicleEntity == 0 then
        error("^1Failed to spawn vehicle: ent=" .. (vehicleEntity or 0) .. ", netID=" .. (netID or 0))
    end

    SetEntityHeading(vehicleEntity, location.vehSpawn[4])
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicleEntity, -1)
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
    SetVehicleEngineOn(vehicleEntity, true, true, false)
    SetVehicleDirtLevel(vehicleEntity, 0.0)
end)

RegisterNetEvent("rental_cars:return", function()
    -- TODO
end)
