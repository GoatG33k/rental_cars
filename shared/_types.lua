---@alias RentalCarKind "vehicle"|"aircraft"|"boat"
---@alias RentalCarTargetFramework "ox_target"
---@alias RentalCarFramework "qbx_core"
---@alias RentalCarMenuFramework "qbx_core"
---@alias RentalCarInventoryFramework "ox_inventory"
---@alias RentalCarLicenseKind "driver"|"pilot"|nil
---@alias RentalCarNotifyFramework "qbx_core"|"ox_notify"

---@class RentalCarsConfigResourceOptions
---@field Framework RentalCarFramework
---@field Menu RentalCarMenuFramework
---@field Target RentalCarTargetFramework
---@field Inventory RentalCarInventoryFramework
---@field Notify RentalCarNotifyFramework

---@class RentalCarsConfig
---@field Resources RentalCarsConfigResourceOptions
---@field Locations table<number, RentalCarLocation>
---@field ItemKey string

---@class RentalCarLocation
---@field kind RentalCarKind
---@field pedModel string
---@field pedCoords vector4
---@field vehSpawn vector4
---@field vehicles RentalCarLocationVehicleList
---@field blip? {sprite?:number,color?:number}

---@alias RentalCarLocationVehicleList table<number, {model:string,dailyCost:number}>

---@class RentalPapersMeta
---@field citizenID string
---@
