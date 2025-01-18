--- Add a location to the config
---@param opts RentalCarLocationOpts
function addLocation(opts)
    -- TODO: validate shit
    -- TODO: blip support
    table.insert(Config.Locations,
        { kind = opts.kind, pedhash = opts.pedhash, coords = opts.coords, spawnpoint = opts.spawnpoint })
end

local comma_value = function(n) -- credit http://richard.warburton.it
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end
