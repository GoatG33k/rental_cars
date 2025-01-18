---@alias RentalCarKind "vehicle"|"aircraft"|"boat"
---@alias RentalCarFramework "qb-core"|"qbx_core"
---@alias RentalCarMenuFramework "qbx_core"|"qb-menu"
---@alias RentalCarInventoryFramework "qb-inventory"|"ox_inventory"
---@alias RentalCarFuelFramework "lj-fuel"
---@alias RentalCarLicenseKind "driver"|"pilot"|nil

---@class RentalCarLocation
---@field kind RentalCarKind
---@field pedhash Hash
---@field coords vector4
---@field spawnpoint vector4

---@class RentalCarsConfig
---@field Resources {Framework:RentalCarFramework,Menu:RentalCarMenuFramework,Fuel:RentalCarFuelFramework,Inventory:RentalCarInventoryFramework}
---@field Locations table<number, RentalCarLocation>
---@field ItemKey string

---@class RentalCarLocationOpts
---@field kind RentalCarKind
---@field pedModel string
---@field pedCoords vector4
---@field vehSpawn vector4
---@field vehicles RentalCarLocationVehicleList
---@field blip? {sprite?:number,color?:number}

---@alias RentalCarLocationVehicleList table<number, {model:string,hourlyCost:number}>

---@class RentalPapersMeta
---@field citizenID string
---@
