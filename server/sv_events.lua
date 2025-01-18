---@param rentalType RentalCarKind
RegisterNetEvent("rental_cars:rent", function(rentalType)
    local licenseNeeded = nil
    if rentalType == "vehicle" then
        licenseNeeded = "driver"
    elseif rentalType == "aircraft" then
        licenseNeeded = "pilot"
    end
    RentalCarAgency:createRentalPapers(source, licenseNeeded)
end)

RegisterNetEvent("rental_cars:return", function()
    RentalCarAgency:returnRental(source)
end)
