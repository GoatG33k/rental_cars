fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Carbon#1002, GoatGeek'
description 'rental_cars - Fork of qb-rentals'
version '3.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'shared/functions.lua',
    'config.lua'
}

client_scripts {
    'client/cl_*.lua',
}

server_scripts {
    'server/sv_*.lua',
}

dependency 'ox_lib'
