CreateThread(function()
    --- Create the rental papers inventory item
    if Config.Resources.Framework == "qb-core" or Config.Resources.Framework == "qbx_core" then
        ---@param source number
        ---@item QB:Item
        exports[Config.Resources.Framework]:CreateUsableItem(Config.ItemKey, function(source, item, plate)
            if not RentalCarAgency:hasRentalPapers(source) then return end
            TriggerEvent("vehiclekeys:client:SetOwner", plate)
        end)
    else
        error("Failed to initialize inventory item '" ..
            Config.ItemKey .. "' (unsupported framework: " .. Config.Resources.Framework .. ")")
    end
end)
