game 'gta5'

fx_version 'adamant'

version '1.0.0'

author 'daavee'

decription 'esx login system'

shared_script 'config.lua'

client_scripts {
    'client/cl_main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/sv_main.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/*.js',
    'ui/*.css'
}

exports {
    'openNui',
    'closeNui'
}