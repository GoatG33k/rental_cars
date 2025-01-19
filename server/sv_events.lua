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

    local location = RentalConfig.Locations[idx]
    local eligible, err = RentalCarAgency:checkEligibility(source, location)
    if not eligible then
        return notifyClient(source, err, "error")
    else
        TriggerClientEvent("rental_cars:openMenu", source, idx)
    end
end)

---@param idx number
---@param vehicleIdx number
RegisterNetEvent("rental_cars:rent", function(idx, vehicleIdx)
    local source = source ---@type number
    if not RentalConfig.Locations[idx] or not RentalConfig.Locations[idx].vehicles[vehicleIdx] then
        return notifyClient(source, "Invalid rental vehicle requested.", "error")
    end

    local location = RentalConfig.Locations[idx]
    local eligible, err = RentalCarAgency:checkEligibility(source, location)
    if not eligible then return notifyClient(source, err, "error") end

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
        netID, veh = qbx.spawnVehicle({
            model = GetHashKey(rentalVehicle.model),
            spawnSource = location.vehSpawn,
            warp = GetPlayerPed(source),
        })
        if not netID then
            print("^1Failed to spawn vehicle for " .. source .. " (" .. GetPlayerName(source) .. ")^0")
            return notifyClient(source, "Failed to spawn rental vehicle.", "error")
        end

        print("Spawned vehicle " .. rentalVehicle.model .. " for " .. source .. " (" .. GetPlayerName(source) .. ")")
        RentalCarAgency.rentals[tostring(source)] = {
            entity = veh,
            plate = GetVehicleNumberPlateText(veh),
        }
    else
        error("Unsupported framework: " .. RentalConfig.Resources.Framework)
    end
    TriggerClientEvent("rental_cars:spawn", source, idx, vehicleIdx, VehToNet(netID))
end)

--- Handle a player returning a vehicle
RegisterNetEvent("rental_cars:return", function()
    RentalCarAgency:returnRental(source)
end)

--- Automatically clean up rentals when a player disconnects
AddEventHandler("playerDropped", function()
    local source = tonumber(source)
    local rental = RentalCarAgency.rentals[tostring(source)]
    if rental then RentalCarAgency:returnRental(source) end
end)

AddEventHandler("entityDeleted", function(entity)
    if GetEntityType(entity) ~= 2 then return end
    for k, v in pairs(RentalCarAgency.rentals) do
        if v.entity == entity then
            print("returning rental for " .. GetPlayerName(k) .. " (vehicle was deleted)")
            RentalCarAgency:returnRental(tonumber(k))
        end
    end
end)
