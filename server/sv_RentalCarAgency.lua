---@class RentalCar
---@field entity Entity|number
---@field plate string

---
--- This is the class that manages rental cars
---@class RentalCarAgency
---@field rentals table<string, RentalCar>
RentalCarAgency = { rentals = {} }

--- Determine if a player has rental papers
---@param source number
---@return boolean
function RentalCarAgency:hasRentalPapers(source)
    if Config.Resources.Inventory == "ox_inventory" then
        local player = self:_getPlayer(source)
        local itemCount = exports.ox_inventory:GetItemCount(source, Config.ItemKey)
        return itemCount > 0
    else
        error("Failed to determine if player has rental papers (Invalid inventory resource configuration: " ..
            Config.Resources.Inventory .. ")")
    end
end

---@param source number
---@param location RentalCarLocation
---@return boolean result, string? errorMessage
function RentalCarAgency:checkEligibility(source, location)
    if self.rentals[tostring(source)] or self:hasRentalPapers(source) then
        return false, "You already have a rental vehicle"
    end

    local pedPos = GetEntityCoords(GetPlayerPed(source))
    if #(vec4(pedPos[1], pedPos[2], pedPos[3], location.pedCoords[4]) - location.pedCoords) > 15.0 then
        return false, "You are too far away from the rental agent."
    end
    local licenseNeeded = self:_getLicenseType(location.kind)
    local hasLicense = RentalCarAgency:_playerHasLicense(source, licenseNeeded)
    if not licenseNeeded then return true, nil end

    local err = hasLicense and nil or ("You need a " .. licenseNeeded .. " license to rent this type of vehicle")
    return true, err
end

function RentalCarAgency:_getLicenseType(rentalType)
    licenseNeeded = nil
    if rentalType == "vehicle" then
        licenseNeeded = "driver"
    elseif rentalType == "aircraft" then
        licenseNeeded = "pilot"
    end
    return nil
end
--- Request a rental car from the rental agency
---@param source number
---@param licenseKind RentalCarLicenseKind
---@return boolean
function RentalCarAgency:createRentalPapers(source, licenseKind)
    -- Check if they have rental papers in their inventory already
    if self:hasRentalPapers(source) then
        -- TODO: send a warning message to the client
        notifyClient(source, "You already have a rental vehicle", "error")
        return false
    end

    -- Check that they have the correct license kind
    if not self:_playerHasLicense(source, licenseKind) then
        notifyClient(source, "You need a " .. licenseKind .. " license to rent this type of vehicle", "error")
        return false
    end

    local rentalPapersMeta = self:_createItemMeta(source, plate, model)
    if Config.Resources.Inventory == "ox_inventory" then
        exports.ox_inventory:AddItem(source, Config.ItemKey, 1, rentalPapersMeta, false)
    else
        error("Failed to give rental papers (Unsupported inventory resource: " .. Config.Resources.Inventory .. ")")
    end

    return true
end

--- Returns a rental vehicle from the rental agency
---@param source number
function RentalCarAgency:returnRental(source)
    if exports.ox_inventory:GetItemCount(source, Config.ItemKey) == 0 then return false end
    if Config.Resources.Inventory == "ox_inventory" then
        exports.ox_inventory:RemoveItem(source, Config.ItemKey, 1)
        self:_free(source)
    else
        error("Failed to remove rental papers (Unsupported inventory resource: " .. Config.Resources.Inventory .. ")")
    end
    return true
end

---@param source number
---@param price number
---@return boolean
function RentalCarAgency:_chargePlayer(source, price, description)
    if Config.Resources.Framework == "qb-core" or Config.Resources.Framework == "qbx_core" then
        local player = self:_getPlayer(source)
        if player.Functions.GetMoney('cash') < price then
            return false
        end
        player.Functions.RemoveMoney('cash', price, description or "Rental vehicle")
    else
        error("^1Failed to process rental car payment (Unsupported framework: " .. Config.Resources.Framework .. ")")
    end
    return true
end

--- Determine if a player has a certain type of license
---@param source number
---@param licenseKind RentalCarLicenseKind
---@return boolean
function RentalCarAgency:_playerHasLicense(source, licenseKind)
    if licenseKind == nil then return true end
    if Config.Resources.Framework == "qb-core" or Config.Resources.Framework == "qbx_core" then
        ---@type Player
        local player = exports[Config.Resources.Framework]:GetPlayer(source)
        local licenseTable = player.PlayerData.metadata["licences"]
        return licenseTable[licenseKind] == true
    else
        print("^1Failed to check license status (Unsupported framework: " .. Config.Resources.Framework .. ")")
        return false
    end
end

---@param source number
---@return Player
function RentalCarAgency:_getPlayer(source)
    if Config.Resources.Framework == "qb-core" or Config.Resources.Framework == "qbx_core" then
        return exports[Config.Resources.Framework]:GetPlayer(source)
    else
        error("^1Failed to resolve player (Unsupported framework: " .. Config.Resources.Framework .. ")")
    end
end

---@param source number
---@param plate string
---@param model string
---@return RentalPapersMeta
function RentalCarAgency:_createItemMeta(source, plate, model)
    -- Construct a new inventory item for the rental papers with the necessary details
    local citizenID, first, last;

    if Config.Resources.Framework == "qb-core" or Config.Resources.Framework == "qbx_core" then
        local player = self:_getPlayer(source)
        citizenID = player.PlayerData.citizenid
        first = player.PlayerData.charinfo.firstname
        last = player.PlayerData.charinfo.lastname
    else
        error("Failed to give rental papers (Unsupported framework: " .. Framework .. ")")
    end

    return {
        citizenID = citizenID,
        firstName = first,
        lastName = last,
        plate = plate,
        model = model
    }
end

function RentalCarAgency:_free(source)
    local rental = self.rentals[tostring(source)]
    if not rental then return end
    if DoesEntityExist(rental.entity) then DeleteEntity(rental.entity) end
    RentalCarAgency:returnRental(source)
    RentalCarAgency.rentals[k] = nil
end
