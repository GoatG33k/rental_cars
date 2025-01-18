local RentalConfig = Config ---@as RentalCarsConfig

function notifyClient(source, msg, kind, durationMs)
    durationMs = durationMs or 5000
    TriggerClientEvent("QBCore:Notify", source, msg, kind, durationMs)
end

--- The event for when a client is requesting to open a menu
---@param idx number
RegisterNetEvent("rental_cars:requestMenu", function(idx)
    if not RentalConfig.Locations[idx] then
        return notifyClient(source, "Invalid rental location requested.", "error")
    end

    -- Distance check
    local location = RentalConfig.Locations[idx]
    local pedPos = GetEntityCoords(GetPlayerPed(source))
    if #(vec4(pedPos[1], pedPos[2], pedPos[3], location.pedCoords[4]) - location.pedCoords) > 15.0 then
        return notifyClient(source, "You are too far away from the rental agent.", "error")
    end

    if not RentalCarAgency:isEligible(source, location) then
        return notifyClient(source, "You don't have the proper license for this type of vehicle.", "error")
    else
        TriggerClientEvent("rental_cars:openMenu", source, idx)
    end
end)

---@param idx number
---@param vehicleIdx number
RegisterNetEvent("rental_cars:rent", function(idx, vehicleIdx)
    if not RentalConfig.Locations[idx] or not RentalConfig.Locations[idx].vehicles[vehicleIdx] then
        local source = source
        return notifyClient(source, "Invalid rental vehicle requested.", "error")
    end

    local location = RentalConfig.Locations[idx]
    if not RentalCarAgency:isEligible(source, location) then
        return notifyClient(source, "You don't have the proper license for this type of vehicle.", "error")
    end

    local rentalVehicle = RentalConfig.Locations[idx].vehicles[vehicleIdx]
    print("User " .. source .. " is requesting to rent a " .. rentalVehicle.model ..
        " for $" .. rentalVehicle.dailyCost .. " per day.")

    local licenseNeeded = RentalCarAgency:_getLicenseType(location.kind)
    local wasIssued = RentalCarAgency:createRentalPapers(source, licenseNeeded)
    if not wasIssued then
        print("^1Failed to issue rental papers to " .. source .. " (" .. GetPlayerName(source) .. ")^0")
        return notifyClient(source, "Failed to issue rental papers.", "error")
    end

    if not RentalCarAgency:_chargePlayer(source, rentalVehicle.dailyCost) then
        return notifyClient(source, "You don't have enough cash on you to rent this vehicle.", "error")
    end

    notifyClient(source,
        "You have rented a " .. rentalVehicle.model .. " for $" .. rentalVehicle.dailyCost .. " per day.", "success")

    -- If we're running on QBox, we must create it server-side
    local netID = nil
    if RentalConfig.Resources.Framework == "qbx_core" then
        print("model=" .. rentalVehicle.model .. ", hash=" .. GetHashKey(rentalVehicle.model))
        netID, _ = qbx.spawnVehicle({
            model = GetHashKey(rentalVehicle.model),
            spawnSource = location.vehSpawn,
            warp = GetPlayerPed(source),
        })
    end
    TriggerClientEvent("rental_cars:spawn", source, idx, vehicleIdx, netID)
end)

RegisterNetEvent("rental_cars:return", function()
    RentalCarAgency:returnRental(source)
end)
