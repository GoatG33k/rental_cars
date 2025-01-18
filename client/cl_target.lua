CreateThread(function()
    local dist <const> = 3.0;
    local radius <const> = 0.4;
    local spawnPoints <const> = {
        Vehicle = {
            pos = vector3(109.9739, -1088.61, 28.302),
            opts = {
                icon = "fas fa-car",
                LicenseType = "driver",
                MenuType = "vehicle",
            }
        },
        Aircraft = {
            pos = vector3(-1686.57, -3149.22, 12.99),
            opts = {
                icon = "fas fa-car",
                LicenseType = "pilot",
                MenuType = "aircraft",
            }
        },
        Boat = {
            pos = vector3(-753.5, -1512.27, 4.02),
            opts = {
                icon = "fas fa-boat",
                MenuType = "boat"
            }
        }
    }

    for k, data in pairs(spawnPoints) do
        local pos = data.pos
        local opts = data.opts
        local name = "rental_cars_" .. k

        exports['qb-target']:AddCircleZone(name, pos, radius, { name = name, debugPoly = false }, {
            options = {
                type = "client",
                event       = "qb-rental:client:LicenseCheck",
                label       = "Rent " .. k,
                icon        = opts.icon,
                LicenseType = opts.LicenseType,
                MenuType    = opts.MenuType
            },
            distance = dist
        })
    end
end)