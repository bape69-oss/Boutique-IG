TriggerEvent('esx:getSharedObject', function(o) ESX = o end)

local coins = 0
local currentVehicle = {}

function RefreshCoins()
    ESX.TriggerServerCallback("boutique:getPlayerCoins", function(data)
        coins = data
    end)
end

function RequestPtfx(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

function openBoutiqueMenu(name, desc)
    local main_menu = RageUI.CreateMenu(name, desc)
    local main_menu_vehicle = RageUI.CreateSubMenu(main_menu, name, desc)
    local main_menu_caisse = RageUI.CreateSubMenu(main_menu, name, desc)
    local main_menu_weapon = RageUI.CreateSubMenu(main_menu, name, desc)
    local main_menu_money = RageUI.CreateSubMenu(main_menu, name, desc)
    local main_menu_vehicle_buy = RageUI.CreateSubMenu(main_menu_vehicle, name, desc)
    main_menu:SetRectangleBanner(0, 0, 0, 155) main_menu_caisse:SetRectangleBanner(0, 0, 0, 155) main_menu_vehicle:SetRectangleBanner(0, 0, 0, 155) main_menu_vehicle_buy:SetRectangleBanner(0, 0, 0, 155) main_menu_weapon:SetRectangleBanner(0, 0, 0, 155) main_menu_money:SetRectangleBanner(0, 0, 0, 155)

    main_menu_vehicle_buy.Closed = function() currentVehicle = {}  end
    if open then
        open = false
    else
        open = true
        RageUI.Visible(main_menu, true)
    end
    CreateThread(function()
        while open do
            Wait(0)

            RageUI.IsVisible(main_menu, function()
                RageUI.Separator("Vos points ~b~"..ESX.Math.GroupDigits(coins).."~s~ "..Config.CoinsName)
                if Config.Vehicle then
                    RageUI.Button("Véhicules", nil, {}, true, {}, main_menu_vehicle)
                end
                if Config.Crate then
                    RageUI.Button("Caisses mystères", nil, {}, true, {}, main_menu_caisse)
                end
                if Config.Weapon then
                    RageUI.Button("Armes", nil, {}, true, {}, main_menu_weapon)
                end
                if Config.Money then
                    RageUI.Button("Argent", nil, {}, true, {},main_menu_money)
                end
            end)
            RageUI.IsVisible(main_menu_caisse, function()
                for k,crate in pairs(Config.ListCrate) do
                    RageUI.Button(crate.NameButton, crate.Description, {RightLabel = "~b~"..ESX.Math.GroupDigits(crate.Price).."~s~ "..Config.CoinsName}, true, {
                        onSelected = function()
                            local random = math.random(1, #crate.contenue)
                            currentName = crate.contenue[random].name
                            currentType = crate.contenue[random].type
                            currentValue = crate.contenue[random].value
                            currentCount = crate.contenue[random].count
                            ESX.ShowNotification("[~b~"..Config.NameMenu.."~s~] ouverture de votre "..crate.NameButton.." dans "..Config.WaitToOpenCrate.." secondes")
                            Wait(Config.WaitToOpenCrate * 1000)

                            local coords = GetEntityCoords(GetPlayerPed(-1))
                            RequestPtfx('scr_rcbarry1')
                            UseParticleFxAsset('scr_rcbarry1')
                            StartNetworkedParticleFxNonLoopedAtCoord('scr_alien_teleport', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)

                            TriggerServerEvent("boutique:buycrate", currentName, currentType, currentValue, currentCount, crate.NameButton, crate.Price, coins)
                            RageUI.CloseAll()
                        end
                    })
                end
            end)
            RageUI.IsVisible(main_menu_weapon, function()
                for k,weapon in pairs(Config.ListWeapon) do
                    RageUI.Button(weapon.NameButton, nil, {RightLabel = "~b~"..ESX.Math.GroupDigits(weapon.Price).."~s~ "..Config.CoinsName}, true, {
                        onSelected = function()
                            TriggerServerEvent("boutique:buyweapon", coins, weapon.value, weapon.Price, weapon.NameButton)
                            RageUI.CloseAll()
                        end
                    })
                end
            end)
            RageUI.IsVisible(main_menu_vehicle, function()
                for k, vehicle in pairs(Config.ListVehicle) do
                    RageUI.Button(vehicle.NameButton, nil, {RightLabel = "~b~"..ESX.Math.GroupDigits(vehicle.Price).."~s~ "..Config.CoinsName}, true, {
                        onSelected = function()
                            table.insert(currentVehicle, {
                                name = vehicle.NameButton,
                                value = vehicle.value,
                                price = vehicle.Price
                            })
                        end
                    }, main_menu_vehicle_buy)
                end
            end)
            RageUI.IsVisible(main_menu_money, function()
                for k,money in pairs(Config.ListMoney) do
                    RageUI.Button(money.NameButton, nil, {RightLabel = "~b~"..ESX.Math.GroupDigits(money.Price).."~s~ "..Config.CoinsName}, true, {
                        onSelected = function()
                            TriggerServerEvent("boutique:buymoney", coins, money.value, money.Price, money.NameButton)
                            RageUI.CloseAll()
                        end
                    })
                end
            end)

            for k,v in pairs(currentVehicle) do
                RageUI.IsVisible(main_menu_vehicle_buy, function()
                    RageUI.Separator("Véhicule : ~b~"..v.name)
                    RageUI.Separator("Nombre de place : ~b~"..GetVehicleModelNumberOfSeats(v.value))
                    RageUI.Button("Essayer le véhicules", nil, {}, true, {
                        onSelected = function()
                            posessaie = GetEntityCoords(PlayerPedId())
                            spawntestcar(v.value)
                        end
                    })
                    RageUI.Button("Acheter le véhicule", nil, {RightLabel = "~b~"..v.price.."~s~ "..Config.CoinsName}, true, {
                        onSelected = function()
                            if coins >= v.price then
                                local coords = GetEntityCoords(PlayerPedId())
                                ESX.Game.SpawnVehicle(v.value, {
                                    x = coords.x,
                                    y = coords.y,
                                    z = coords.z
                                }, GetEntityHeading(PlayerPedId()), function(veh)
                                    local plate = GeneratePlate()
                                    print(plate)
                                    local vehicleProps = ESX.Game.GetVehicleProperties(veh)
                                    vehicleProps.plate = plate
                                    SetVehicleNumberPlateText(veh, plate)
                                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                    TriggerServerEvent("boutique:buycar", vehicleProps, plate, v.price, v.name, v.value, coins)
                                end)
                            else
                                ESX.ShowNotification("[~b~"..Config.NameMenu.."~s~]\nVous n'avez pas assez de "..Config.CoinsName.."\nIl vous manque ~o~"..v.price - coins.."")
                            end
                        end
                    })

                end, function()
                    RageUI.StatisticPanel((GetVehicleModelMaxSpeed(v.value, true)/60), "Vitesse maximal")
                    RageUI.StatisticPanel((GetVehicleModelAcceleration(v.value, true)/0.5), "Acceleration")
                    RageUI.StatisticPanel((GetVehicleModelMaxBraking(v.value, true)/1.5), "Freinage")
                    RageUI.StatisticPanel((GetVehicleModelMaxTraction(v.value, true)/5), "Couple")
                end, 1)
            end
        end
    end)
end

function spawntestcar(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, -899.62, -3298.74, 13.94, 58.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleDoorsLocked(vehicle, 4)
    ESX.ShowNotification("Vous avez 20 secondes pour tester le véhicule.")
    local timer = 20
    local breakable = false
    breakable = false
    while not breakable do
        Wait(1000)
        timer = timer - 1
        if timer == 10 then
            ESX.ShowNotification("Il vous reste plus que 10 secondes.")
        end
        if timer == 5 then
            ESX.ShowNotification("Il vous reste plus que 5 secondes.")
        end
        if timer <= 0 then
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
            DeleteEntity(vehicle)
            ESX.ShowNotification("~r~Vous avez terminé la période d'essai.")
            SetEntityCoords(PlayerPedId(), posessaie)
            breakable = true
            break
        end
    end
end


RegisterKeyMapping("boutique_ig", "Ouvrir la boutque IG", 'keyboard', "F4")
RegisterCommand("boutique_ig", function()
    RefreshCoins()
    openBoutiqueMenu(Config.NameMenu, Config.Description)
end)