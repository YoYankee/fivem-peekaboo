-- fxmanifest 文件
fx_version 'adamant'
game 'gta5'
name '躲猫猫'
author 'yoyankee - https://github.com/YoYankee'
version 'v0.0.1'

ui_page {
    'nui/index.html',
}

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

files {
	'nui/index.html',
	'nui/js/app.js', 
	'nui/css/style.css',
    'nui/img/background.png'
}




