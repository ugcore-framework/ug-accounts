fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ug-accounts'
description 'Accounts Script for UgCore by UgDev'
author 'UgDev'
version '3.5'
url 'https://github.com/UgDevOfc/ug-accounts/'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/accounts.lua',
    'server/functions.lua',
    'server/events.lua',
    'server/callbacks.lua',
}