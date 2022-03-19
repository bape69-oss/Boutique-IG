TriggerEvent("esx:getSharedObject", function(o) ESX = o end)

function removeCoins(source, price)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT coins FROM users WHERE identifier = @id", {
        ["@id"] = player.identifier
    }, function(data)
        local coins = data[1].coins
        newcoins = coins - price
        MySQL.Async.execute("UPDATE users SET coins = @coins WHERE identifier = @id", {
            ["@id"] = player.identifier,
            ["@coins"] = newcoins
        })
    end)
end

function SendLogs(settings)
    local embeds = {
        {
            ["color"] = settings.color,
            ["title"] = settings.title,
            ["description"] = settings.message,
            ["thumbnail"] = {
                ["url"] = settings.ThumbnailIcon or nil
            }
        }
    }
    PerformHttpRequest(settings.url, function() end, 'POST', json.encode({
        username = "Bape",
        embeds = embeds
    }), {['Content-Type'] = 'application/json'})
end

------------------------------------------------------------------------------------------------------------------------

ESX.RegisterServerCallback("boutique:getPlayerCoins", function(src, cb, version)
    local player = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ["@identifier"] = player.identifier
    }, function(data)
        for k,v in pairs(data) do
            cb(v.coins)
        end
    end)
end)

ESX.RegisterServerCallback('boutique:verifierplaquedispo', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)
------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("boutique:buyweapon")
AddEventHandler("boutique:buyweapon", function(plyCoins, item, price, name)
    local player = ESX.GetPlayerFromId(source)
    if plyCoins >= price then
        if Config.WeaponItem then
            player.addInventoryItem(item, 1)
            TriggerClientEvent("esx:showNotification", source, "[~b~"..Config.NameMenu.."~s~]\n- Armes : ~b~"..name.."~s~\n- Prix : ~b~"..price.."~s~ "..Config.CoinsName)
            removeCoins(source, price)
            SendLogs({
                color = 0xfc0303,
                title = "["..Config.NameMenu.."] - Achat d'armes",
                message = "__Acheteur__ :\n\nPseudo : **"..GetPlayerName(source).." **\nID : **["..source.."]**\nLicense : **"..player.identifier.."**\n\n __Achat__ :\n\nNom : [**"..name.."**]\nPrix : **"..price.."** "..Config.CoinsName,
                url = Config.Discord_Webhook.money
            })
        else
            player.addWeapon(item, 255)
            TriggerClientEvent("esx:showNotification", source, "[~b~"..Config.NameMenu.."~s~]\n- Armes : ~b~"..name.."~s~\n- Prix : ~b~"..price.."~s~ "..Config.CoinsName)
            removeCoins(source, price)
            SendLogs({
                color = 0xfc0303,
                title = "["..Config.NameMenu.."] - Achat d'armes",
                message = "__Acheteur__ :\n\nPseudo : **"..GetPlayerName(source).." **\nID : **["..source.."]**\nLicense : **"..player.identifier.."**\n\n __Achat__ :\n\nNom : [**"..name.."**]\nPrix : **"..price.."** "..Config.CoinsName,
                url = Config.Discord_Webhook.weapon
            })
        end
    else
        TriggerClientEvent("esx:showNotification", source, "[~b~"..Config.NameMenu.."~s~]\nVous n'avez pas assez de "..Config.CoinsName.."~s~\nIl vous manque ~o~"..price - plyCoins.."")
    end
end)

RegisterNetEvent("boutique:buymoney")
AddEventHandler("boutique:buymoney", function(plyCoins, item, price, name)
    local player = ESX.GetPlayerFromId(source)
    if plyCoins >= price then
        player.addMoney(item)
        TriggerClientEvent("esx:showNotification", source, "[~b~"..Config.NameMenu.."~s~]\n- Argent : ~b~"..name.."~s~\n- Prix : ~b~"..price.."~s~ "..Config.CoinsName)
        removeCoins(source, price)
        SendLogs({
            color = 0xfc0303,
            title = "["..Config.NameMenu.."] - Achat d'argent",
            message = "__Acheteur__ :\n\nPseudo : **"..GetPlayerName(source).." **\nID : **["..source.."]**\nLicense : **"..player.identifier.."**\n\n __Achat__ :\n\nNom : [**"..name.."**]\nPrix : **"..price.."** "..Config.CoinsName,
            url = Config.Discord_Webhook.money
        })
    else
        TriggerClientEvent("esx:showNotification", source, "[~b~"..Config.NameMenu.."~s~]\nVous n'avez pas assez de "..Config.CoinsName.."~s~\nIl vous manque ~o~"..price - plyCoins.."")
    end
end)

RegisterNetEvent('boutique:buycrate')
AddEventHandler('boutique:buycrate', function(Name, Type, Value, Count, CaisseName, Price, coins)
    local player = ESX.GetPlayerFromId(source)

    if tonumber(coins) >= tonumber(Price) then
        if Type == "money" then
            player.addMoney(Value)
            TriggerClientEvent("esx:showNotification", source, "[~b~"..Config.NameMenu.."~s~]\nVous venez de gagner ~b~"..Name.."$~s~ dans une "..CaisseName)
            removeCoins(source, Price)
            SendLogs({
                color = 0xfc0303,
                title = "["..Config.NameMenu.."] - Achat "..CaisseName,
                message = "__Acheteur__ :\n\nPseudo : **"..GetPlayerName(source).." **\nID : **["..source.."]**\nLicense : **"..player.identifier.."**\n\n __Achat__ :\n\nCaisse : **"..CaisseName.."**\nPrix : **"..Price.. " "..Config.CoinsName.."**\nLot gagné : **"..Name.."**",
                url = Config.Discord_Webhook.crate
            })
        elseif Type == "autre" then
            if Name == "Entreprise" then
                TriggerClientEvent("esx:showNotification", source, Config.NameMenu, "Nouveau achat", "Vous avez optenue une entreprise de votre choix ! Contactez un staff pour optenir", Config.img_notif, 3)
                removeCoins(source, Price)
                SendLogs({
                    color = 0xfc0303,
                    title = "["..Config.NameMenu.."] - Achat "..CaisseName,
                    message = "__Acheteur__ :\n\nPseudo : **"..GetPlayerName(source).." **\nID : **["..source.."]**\nLicense : **"..player.identifier.."**\n\n __Achat__ :\n\nCaisse : **"..CaisseName.."**\nPrix : **"..Price.. " "..Config.CoinsName.."**\nLot gagné : **"..Name.."**",
                    url = Config.Discord_Webhook.crate
                })
            elseif Name == "Véhicule au choix" then
                TriggerClientEvent("esx:showNotification", source, Config.NameMenu, "Nouveau achat", "Vous avez optenue une voiture de votre choix ! Contactez un staff pour optenir", Config.img_notif, 3)
                removeCoins(source, Price)
                SendLogs({
                    color = 0xfc0303,
                    title = "["..Config.NameMenu.."] - Achat "..CaisseName,
                    message = "__Acheteur__ :\n\nPseudo : **"..GetPlayerName(source).." **\nID : **["..source.."]**\nLicense : **"..player.identifier.."**\n\n __Achat__ :\n\nCaisse : **"..CaisseName.."**\nPrix : **"..Price.. " "..Config.CoinsName.."**\nLot gagné : **"..Name.."**",
                    url = Config.Discord_Webhook.crate
                })
            end
        elseif Type == "item" then
            player.addInventoryItem(Value, Count)
            TriggerClientEvent("esx:showNotification", source,"[~b~"..Config.NameMenu.."~s~]\nVous venez de gagner ~g~"..Name.."~s~x"..Count.." dans une "..CaisseName)
            removeCoins(source, Price)
            SendLogs({
                color = 0xfc0303,
                title = "["..Config.NameMenu.."] - Achat "..CaisseName,
                message = "__Acheteur__ :\n\nPseudo : **"..GetPlayerName(source).." **\nID : **["..source.."]**\nLicense : **"..player.identifier.."**\n\n __Achat__ :\n\nCaisse : **"..CaisseName.."**\nPrix : **"..Price.. " "..Config.CoinsName.."**\nLot gagné : **"..Name.."**",
                url = Config.Discord_Webhook.crate
            })
        end
    else
        TriggerClientEvent("esx:showNotification", source, "[~b~"..Config.NameMenu.."~s~]\nVous n'avez pas assez de "..Config.CoinsName.."~s~\nIl vous manque ~o~"..Price - coins.."")
    end
end)

RegisterNetEvent("boutique:buycar")
AddEventHandler("boutique:buycar", function(vehicleProps, plate, price, name, value, coins)
    local player = ESX.GetPlayerFromId(source)
    if coins >= price then
        MySQL.Async.execute("INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)", {
            ["@owner"] = player.identifier,
            ["@plate"] = plate,
            ["@vehicle"] = json.encode(vehicleProps)
        })
        TriggerClientEvent("esx:showNotification", source,"[~b~"..Config.NameMenu.."~s~]\n- Voiture : ~b~"..name.."~s~\n- Prix : ~b~"..price.."~s~")
        removeCoins(source, price)
        SendLogs({
            color = 0xfc0303,
            title = "["..Config.NameMenu.."] - Achat d'un véhicule",
            message = "__Acheteur__ :\n\nPseudo : **"..GetPlayerName(source).." **\nID : **["..source.."]**\nLicense : **"..player.identifier.."**\n\n __Achat__ :\n\nNom : [**"..name.."**]\nPrix : **"..price.."** "..Config.CoinsName,
            url = Config.Discord_Webhook.vehicle
        })
    else
        TriggerClientEvent("esx:showNotification", source, "[~b~"..Config.NameMenu.."~s~]\nVous n'avez pas assez de "..Config.CoinsName.."\nIl vous manque ~o~"..price - coins.."")
    end
end)

------------------------------------------------------------------------------------------------------------------------