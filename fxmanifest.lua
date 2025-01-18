fx_version 'cerulean'
game 'gta5'

author 'Carbon#1002, GoatGeek'
description 'rental_cars - Fork of qb-rentals'
version '3.0.0'

shared_scripts {
    'shared/functions.lua',
    'config.lua'
}

client_scripts {
    'client/cl_*.lua'
}

server_scripts {
    'server/RentalCarAgency.lua',
    'server/sv_*.lua',
}
