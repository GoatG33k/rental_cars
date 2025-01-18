# rental_cars
This is a vehicle rental script for cars/bikes/trucks, aircraft, and boats. 

This script is forked from the wonderful [qb-rentals by carbontheape](https://github.com/carbontheape/qb-rentals), 
and aims to support both the QBCore and QBox frameworks.

## Features
- Fully Configurable
- Provides physical rental papers item in inventory
- <=0.01ms tick time
- Ability to return all vehicles 

## Dependencies 
### QBCore
- [qb-target](https://github.com/BerkieBb/qb-target)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)

### QBox

# Installation
Go to qb-core/server/player.lua (line 94)
Replace the licenses metadata with the snippet below
```lua
PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
        ['driver'] = true,
        ['business'] = false,
        ['weapon'] = false,
        ['pilot'] = false
}
```
# Optional
*This allows you to add the ability for police to grant and revoke pilot licenses*
Go to qb-policejob/server/main.lua (line 124)
Replace the old line with this
```lua
if args[2] == "driver" or args[2] == "weapon" or args[2] == "pilot" then
```
Go to qb-policejob/server/main.lua (line 148)
Replace the old line with this
```lua
if args[2] == "driver" or args[2] == "weapon" or args[2] == "pilot" then
```
 
# Rental Papers Item
 
 ```lua
  ["rentalpapers"]				 = {["name"] = "rentalpapers", 					["label"] = "Rental Papers", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "rentalpapers.png", 		["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false, 	["combinable"] = nil, 	["description"] = "Yea, this is my car i can prove it!"},
  ```
  # Rental Papers Item Description - qb-inventory/html/js/app.js (Line 577)
  
 ```lua
   } else if (itemData.name == "stickynote") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html('<p>' + itemData.info.label + '</p>');
        } else if (itemData.name == "rentalpapers") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html('<p><strong>Name: </strong><span>'+ itemData.info.firstname + '</span></p><p><strong>Last Name: </strong><span>'+ itemData.info.lastname+ '</span></p><p><strong>Plate: </strong><span>'+ itemData.info.plate + '<p><strong>Model: </strong><span>'+ itemData.info.model +'</span></p>');
```
# Change Logs
- 1.0 - Inital release
- 1.1 - Script optimization / Locales
- 2.0 - Script Revamp

# Credits - [itsHyper](https://github.com/itsHyper) & elfishii 
