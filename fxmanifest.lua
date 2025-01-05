fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'qb-radiation'
description 'radiation zone'
author '77Killer'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'radiation_zone.lua'
}

server_scripts {
    'server.lua'
}


dependency 'ox_lib'


