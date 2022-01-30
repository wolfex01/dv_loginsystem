ESX = nil

TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)

local Webhook = "webhook_here"
local Profile = Config.WebhookImg

RegisterServerEvent('dv_loginpanel:setData')
AddEventHandler('dv_loginpanel:setData', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    local user = data.username
    local pass = data.passw
    local identifier = xPlayer.getIdentifier()

    local registered = MySQL.Sync.fetchAll("SELECT identifier FROM login_data WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })

    if registered[1] == nil then 
        registered = false
    else 
        registered = true
    end

    if not registered then
        date = os.date("%Y/%m/%d %X")
        local numBase = math.random(10000,99999)

        local crypt = GetPasswordHash(pass)

            MySQL.Async.insert("INSERT INTO login_data (`identifier`, `name`, `pass`, `date`) VALUES(@identifier, @name, @pass, @date)", {
                ['@identifier'] = identifier,
                ['@name'] = user,
                ['@pass'] = crypt,
                ['@date'] = date
            })
            TriggerClientEvent('dv_loginpanel:sendNotify', src, "You have registered successful, please login now!")
            TriggerClientEvent('dv_loginpanel:toggle', src, "be")
            if Config.EnableLog then
                if Webhook ~= "webhook_here" or nil then
                    PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Login System', avatar_url = Profile, content = '```css\n[dv_loginsystem]\n``````ini\n[ID] ' .. src .. ' | [Name] ' .. xPlayer.name .. ' ('.. actualUser[1].name ..') - Just registered!```'}), { ['Content-Type'] = 'application/json' })
                else
                    print(GetCurrentResourceName()..": Webhook not found!")
                end
            end
    else 
        TriggerClientEvent('dv_loginpanel:sendNotify', src, "You have already registered!")
        TriggerClientEvent('dv_loginpanel:login', src, "fail")
    end
end)

RegisterServerEvent('dv_loginpanel:checkData')
AddEventHandler('dv_loginpanel:checkData', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    local user = data.username
    local pass = data.passw

    local identifier = xPlayer.getIdentifier()
    datum1 = MySQL.Sync.fetchAll("SELECT date FROM login_data WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if datum1[1] ~= nil then
        date1 = tostring(datum1[1].date)
    end

    local reg2 = MySQL.Sync.fetchAll("SELECT identifier FROM login_data WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })

    if reg2[1] == nil then 
        reg2 = false
    else 
        reg2 = true
    end

    local actualUser = MySQL.Sync.fetchAll("SELECT name FROM login_data WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })

    local actualPass = MySQL.Sync.fetchAll("SELECT pass FROM login_data WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })                                                                                                                             

    if reg2 == true then 
        if user == actualUser[1].name and VerifyPasswordHash(data.passw, actualPass[1].pass) then
            TriggerClientEvent('dv_loginpanel:login', src, "success", data)
            TriggerClientEvent('dv_loginpanel:sendNotify', src, "Login successful!")
            if Config.EnableLog then
                if Webhook ~= "webhook_here" or nil then
                    PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Login System', avatar_url = Profile, content = '```css\n[dv_loginsystem]\n``````ini\n[ID] ' .. src .. ' | [Name] ' .. xPlayer.name .. ' ('.. actualUser[1].name ..') - Just logged in!```'}), { ['Content-Type'] = 'application/json' })
                else
                    print(GetCurrentResourceName()..": Webhook not found!")
                end
            end
        else
            TriggerClientEvent('dv_loginpanel:sendNotify', src, "Incorrect data!")
            TriggerClientEvent('dv_loginpanel:login', src, "fail")
        end
    else
        TriggerClientEvent('dv_loginpanel:sendNotify', src, "You haven't registered yet!")
        TriggerClientEvent('dv_loginpanel:login', src, "fail", data)
    end
end)

RegisterServerEvent('dv_loginpanel:kick')
AddEventHandler('dv_loginpanel:kick', function()
    DropPlayer(source, "[📌] "..GetCurrentResourceName()..": " ..Config.KickMessage)
end)
