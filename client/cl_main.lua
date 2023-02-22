local ESX = nil
local datum = ""
local chance = 0
local firstSpawn = true

-- Wait for ESX to be ready before executing code
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) 
            ESX = obj 
        end)
        Citizen.Wait(0)
        setChance()
    end
end)

-- Trigger the NUI login panel when the player spawns for the first time
AddEventHandler("playerSpawned", function(spawn)
    if firstSpawn then
        openNui()
        firstSpawn = false
    end
end)

-- Receive the server's date and store it as a string
RegisterNetEvent('dv_loginpanel:datum')
AddEventHandler('dv_loginpanel:datum', function(adat)
    datum = tostring(adat)
end)

-- Open the NUI login panel
function openNui()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show",
        name = GetPlayerName(PlayerId()),
        date1 = datum
    })
end

-- Close the NUI login panel
function closeNui()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "hide",
    })
end

-- Check if the player has reached the maximum number of login attempts
function countChance()
    if chance >= Config.Chances then 
        setChance()
        TriggerServerEvent('dv_loginpanel:kick')
    end
end

-- Reset the number of login attempts
function setChance()
    chance = 0
end

-- Show a notification message to the player
RegisterNetEvent('dv_loginpanel:sendNotify')
AddEventHandler('dv_loginpanel:sendNotify', function(msg)
    ESX.ShowNotification(msg)
end)

-- Toggle the NUI login panel on or off
RegisterNetEvent('dv_loginpanel:toggle')
AddEventHandler('dv_loginpanel:toggle', function(type)
    if type == "be" then
        openNui()
    else
        closeNui() 
    end
end)

-- Handle the login response from the server
RegisterNetEvent('dv_loginpanel:login')
AddEventHandler('dv_loginpanel:login', function(type, data)
    if type == "success" then 
        closeNui()
    else
        if Config.Chances ~= false then
            chance = chance + 1
            countChance()
            openNui()
        else
            setChance()
            openNui()
        end
    end
end)

-- Handle the login request from the NUI login panel
RegisterNUICallback('login', function(data)
    ESX.TriggerServerCallback('dv_loginpanel:checkData', function(response)
        if response == "success" then
            closeNui()
        else
            ESX.ShowNotification(response)
        end
    end, data)
end)

-- Handle the registration request from the NUI login panel
RegisterNUICallback('reg', function(data)
    ESX.TriggerServerCallback('dv_loginpanel:setData', function(response)
        ESX.ShowNotification(response)
    end, data)
end)
