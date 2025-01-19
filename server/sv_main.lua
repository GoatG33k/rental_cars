CreateThread(function()
    local Config = Config ---@as RentalCarsConfig
    --- Create the rental papers inventory item
    if Config.Resources.Framework == "qb-core" or Config.Resources.Framework == "qbx_core" then
        exports[Config.Resources.Framework]:CreateUseableItem(Config.ItemKey, function(source, item)
            if not RentalCarAgency:hasRentalPapers(source) then return end
            print(item.metadata.plate)
            TriggerEvent("vehiclekeys:client:SetOwner", item.metadata.plate)
        end)
    else
        error("Failed to initialize inventory item '" ..
            Config.ItemKey .. "' (unsupported framework: " .. Config.Resources.Framework .. ")")
    end
end)
