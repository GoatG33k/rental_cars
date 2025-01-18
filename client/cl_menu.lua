local RentalConfig = Config ---@as RentalCarsConfig

--- Determine if any vehicle is blocking the spawn location
local function CheckIfAnyVehicleBlocking(idx)
    local radius = 2.0
    local location = RentalConfig.Locations[idx]
    if location.kind == "aircraft" then
        radius = 15.0
    elseif location.kind == "boat" then
        radius = 10.0
    end
    return IsAnyVehicleNearPoint(location.vehSpawn[1], location.vehSpawn[2], location.vehSpawn[3], radius)
end


--- Render a menu for a given vehicle spawn point
---@param idx number The index of the vehicle location to open
function CreateMenu(idx)
    if not RentalConfig.Locations[idx] then
        return error("Invalid rental location index requested: " .. idx)
    end
    local location = RentalConfig.Locations[idx]

    if RentalConfig.Resources.Menu == "qbx_core" then
        local contextName = "rental_cars_menu_" .. idx
        local vehicleListContextName = contextName .. "_VEH"

        local vehicleOptions = {}
        for k, v in ipairs(location.vehicles) do
            vehicleOptions[#vehicleOptions + 1] = {
                id = contextName .. "_" .. k,
                title = v.model,
                description = "Rent this vehicle for $" .. v.dailyCost .. " per day",
                onSelect = function()
                    if CheckIfAnyVehicleBlocking(idx) then
                        TriggerEvent("rental_cars:notify", "There is a vehicle blocking the spawn point.", "error")
                        return
                    else
                        TriggerServerEvent("rental_cars:rent", idx, k)
                    end
                end
            }
        end

        lib.registerContext({
            id = vehicleListContextName,
            title = "Rent " .. location.kind,
            options = vehicleOptions
        })

        lib.registerContext({
            id = contextName,
            title = "Rent " .. location.kind,
            options = {
                {
                    title = "Rent",
                    description = "Rent a " .. location.kind,
                    onSelect = function() lib.showContext(vehicleListContextName) end
                },
                {
                    title = "Return Rental",
                    description = "Return a rental " .. location.kind,
                    onSelect = function() TriggerServerEvent("rental_cars:return", idx, k) end
                }
            }
        })

        lib.showContext(contextName)
    else
        error("Unsupported menu framework: " .. RentalConfig.Resources.Menu)
    end
end
