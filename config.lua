Config = {}

Config.SharedObject = 'esx:getSharedObject'

Config.EnableLog = true -- log system // add webhook in server.lua
Config.WebhookImg = "https://i.imgur.com/CyFGInF.png" -- webhook img url

Config.OpenOnJoin = true -- automatic open
Config.Chances = false -- Set chances to specific number to get kicked, when player failed to type her own password successfully, if don't want to kick just set to false
Config.KickMessage = "You have entered wrong password too many times!" -- Kick message when password was wrote wrong specific times

function Notification(msg)
    --- YOUR CODE FOR NOTIFY ---
	ESX.ShowNotification(msg)

    --- FOR EXAMPLE ---
    -- mythic_notify
    --exports['mythic_notify']:SendAlert('inform', msg)
end