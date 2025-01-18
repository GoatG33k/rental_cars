--- Add a location to the config
---@param opts RentalCarLocation
function addLocation(opts)
    if type(opts) ~= 'table' then error("Invalid data provided to addLocation(): " .. type(opts)) end
    if type(opts.kind) ~= 'string' or opts.kind ~= 'vehicle' and opts.kind ~= 'aircraft' and opts.kind ~= 'boat' then
        error("Invalid kind provided to addLocation(): " .. type(opts.kind))
    end

    if type(opts.pedModel) ~= 'number' then error("Invalid pedModel provided to addLocation(): " .. type(opts.pedModel)) end
    if type(opts.pedCoords) ~= 'vector4' then
        error("Invalid pedCoords provided to addLocation(): " ..
            type(opts.pedCoords))
    end
    if type(opts.vehSpawn) ~= 'vector4' then error("Invalid vehSpawn provided to addLocation(): " .. type(opts.vehSpawn)) end

    -- Validate vehicles
    for i, vehicle in ipairs(opts.vehicles) do
        if type(vehicle.model) ~= 'string' then
            error("Invalid model provided to addLocation() #" .. i .. ": " .. tostring(vehicle.model))
        end
        if type(vehicle.dailyCost) ~= 'number' then
            error("Invalid dailyCost provided to addLocation() #" .. i .. ": " .. tostring(vehicle.dailyCost))
        end

        print("^3Registered ^4" ..
            opts.kind .. " ^3location with vehicle ^4" .. vehicle.model .. " ^3for ^6$" .. vehicle.dailyCost .. "/day^0")
    end

    Config.Locations[#Config.Locations + 1] = opts
end

--- Register a cleanup handler to run when the resource stops
local _cleanupHandlers = {}
function cleanupHandler(fn) _cleanupHandlers[#_cleanupHandlers + 1] = fn end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if #_cleanupHandlers == 0 then return end
        print("Running cleanup handlers... (" .. #_cleanupHandlers .. " found)")
        for _, handler in ipairs(_cleanupHandlers) do handler() end
    end
end)
