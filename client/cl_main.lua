ESX = nil
firstSpawn = true

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)
        Citizen.Wait(0)
        setChance()
    end
end)

AddEventHandler("playerSpawned", function(spawn)
    if firstSpawn then
        openNui()
        firstSpawn = false
    end
end)

RegisterNetEvent('dv_loginpanel:datum')
AddEventHandler('dv_loginpanel:datum', function(adat)
    datum = tostring(adat)
end)

function openNui()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show",
        name = GetPlayerName(PlayerId()),
        date1 = datum
    })
end

function closeNui()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "hide",
    })
end

function countChance()
    if chance >= Config.Chances then 
        setChance()
        TriggerServerEvent('dv_loginpanel:kick')
    end
end

function setChance()
    chance = 0
end

RegisterNetEvent('dv_loginpanel:sendNotify')
AddEventHandler('dv_loginpanel:sendNotify', function(msg)
    Notification(msg)
end)

RegisterNetEvent('dv_loginpanel:toggle')
AddEventHandler('dv_loginpanel:toggle', function(type)
    if type == "be" then
        openNui()
    else
        closeNui() 
    end
end)

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

RegisterNUICallback('login', function(data)
    TriggerServerEvent('dv_loginpanel:checkData', data)
end)

RegisterNUICallback('reg', function(data)
    TriggerServerEvent('dv_loginpanel:setData', data)
end)
