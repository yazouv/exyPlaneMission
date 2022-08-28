local currentToken = ""

function _TriggerServerEvent(eventName, ...)
    TriggerServerEvent(eventName, currentToken, ...)
end

RegisterNetEvent("exyPlaneMission:OnRequestToken")
AddEventHandler("exyPlaneMission:OnRequestToken", function(newToken)
    currentToken = newToken
end)

Citizen.CreateThread(function()
    TriggerServerEvent("exyPlaneMission:RequestToken")
end)

ShowHelpNotification = function(text)
    AddTextEntry("HelpNotification", text)
    DisplayHelpTextThisFrame("HelpNotification", false)
end
ShowNotification = function(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

DeleteVehicle = function(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteEntity(vehicle)
    DeletePed(ped)
    DeletePed(ped2)
    DeletePed(ped3)
    DeletePed(ped4)
    DeletePed(ped5)
end

StartBliper = function(Veh)
    local model = GetHashKey(Veh)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    vehicle = CreateVehicle(model, Config.SpawnPoint.x, Config.SpawnPoint.y, Config.SpawnPoint.z, Config.SpawnPoint.h,
        true, false)
    TaskEnterVehicle(GetPlayerPed(-1), vehicle, 20000, -1, 1.0, 3, 0)
    SetVehicleDirtLevel(vehicle, 0.0)
    FreezeEntityPosition(vehicle, true)
    ShowNotification("<C>Attendez que tout les passagers embarquent")
    Wait(4000)
    RequestModel(GetHashKey("s_m_y_dealer_01"))
    while (not HasModelLoaded(GetHashKey("s_m_y_dealer_01"))) do
        Citizen.Wait(1)
    end
    ped = CreatePed(4, 0xE497BBEF, -987.18878173828, -3005.7377929688, 13.945065498352, 330.73, true)
    ped2 = CreatePed(4, 0xE497BBEF, -987.18878173828, -3005.7377929688, 13.945065498352, 330.73, true)
    ped3 = CreatePed(4, 0xE497BBEF, -987.18878173828, -3005.7377929688, 13.945065498352, 330.73, true)
    ped4 = CreatePed(4, 0xE497BBEF, -987.18878173828, -3005.7377929688, 13.945065498352, 330.73, true)
    ped5 = CreatePed(4, 0xE497BBEF, -987.18878173828, -3005.7377929688, 13.945065498352, 330.73, true)
    Wait(4000)
    TaskEnterVehicle(ped, vehicle, 20000, 1, 1.0, 3, 0)
    Wait(4000)
    TaskEnterVehicle(ped2, vehicle, 20000, 2, 1.0, 3, 0)
    Wait(4000)
    TaskEnterVehicle(ped3, vehicle, 20000, 3, 1.0, 3, 0)
    Wait(4000)
    TaskEnterVehicle(ped4, vehicle, 20000, 4, 1.0, 3, 0)
    Wait(4000)
    TaskEnterVehicle(ped5, vehicle, 20000, 5, 1.0, 3, 0)
    Wait(4000)
    FreezeEntityPosition(vehicle, false)
    -----------------------------------------------------------------------------------
    Blip = AddBlipForCoord(Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z)
    SetBlipColour(Blip, 2)
    SetBlipRoute(Blip, true)
    inJob = true
    ShowNotification("<C>[~b~Mission~s~]\nRejoignez le point GPS, bonne route")
    -----------------------------------------------------------------------------------
end

Citizen.CreateThread(function()
    if (Config.EnableBlip == true) then
        local blip = AddBlipForCoord(Config.Start.x, Config.Start.y, Config.Start.z)
        SetBlipSprite(blip, 307)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Start.label)
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPos = GetEntityCoords(GetPlayerPed(-1))
        local distance_point = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Config.Start.x,
            Config.Start.y, Config.Start.z, true)
        local wait = 800

        if distance_point < 15 then
            wait = 0
            DrawMarker(27, Config.Start.x, Config.Start.y, Config.Start.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255
                , 0, 0, 100, false, false, 2, false, false, false, false)
        end

        if distance_point < 1.5 then
            wait = 0
            ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu des ~b~avions~w~.")
            if IsControlJustPressed(1, 38) then
                menuActions()
            end
        end

        Citizen.Wait(wait)
    end
end)

function menuActions()

    local menuAction = RageUI.CreateMenu("Pilote", "Choissiez l'avion que vous voulez prendre")

    RageUI.Visible(menuAction, not RageUI.Visible(menuAction))

    while menuAction do

        Citizen.Wait(0)

        RageUI.IsVisible(menuAction, true, true, true, function()

            for i = 1, #Config.Planes, 1 do
                RageUI.ButtonWithStyle(Config.Planes[i].label, nil, { RightLabel = "→ ~g~" ..
                    Config.Planes[i].price .. "$" }, true,
                    function(Hovered, Active, Selected)
                        if Selected then
                            LabelVeh = Config.Planes[i].label
                            ESX.TriggerServerCallback('exyPlaneMission:CheckMoney', function(hasMoney)
                                if hasMoney then
                                    StartBliper(LabelVeh)
                                    RageUI.CloseAll()
                                else
                                    ShowNotification("Vous n'avez pas assez d'argent")
                                end
                            end, Config.Planes[i].price)
                        end
                    end)
            end
        end, function()
        end)
        if not RageUI.Visible(menuAction) then
            menuAction = RMenu:DeleteType("Titre", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local wait = 800

        if inJob == true then

            wait = 0
            DrawMarker(27, Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0
                , 5.0, 5.0, 255, 0, 0, 100,
                false, false, 2, false, false, false, false)
            if GetDistanceBetweenCoords(Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z,
                GetEntityCoords(GetPlayerPed(-1), true)) < 3 then
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour confirmer le débarquement de l'avion",
                        time_display = 1 })
                    if IsControlJustPressed(1, 38) then
                        FreezeEntityPosition(vehicle, true)
                        RemoveBlip(Blip)
                        TaskLeaveVehicle(ped, vehicle, 0)
                        Wait(4000)
                        TaskLeaveVehicle(ped2, vehicle, 0)
                        Wait(4000)
                        TaskLeaveVehicle(ped3, vehicle, 0)
                        Wait(4000)
                        TaskLeaveVehicle(ped4, vehicle, 0)
                        Wait(4000)
                        TaskLeaveVehicle(ped5, vehicle, 0)
                        FreezeEntityPosition(vehicle, false)
                        ShowNotification("<C>[~b~Mission~s~]\nVous avez fait un excellent trajet, faites maintenant le retour")
                        inJob = false
                        inBack = true
                        BlipDe = AddBlipForCoord(Config.FinalPoint.x, Config.FinalPoint.y, Config.FinalPoint.z)
                        SetBlipColour(BlipDe, 2)
                        SetBlipRoute(BlipDe, true)
                    end
                else
                    RageUI.Text({ message = "Vous n'avez pas votre avion", time_display = 1 })
                end
            end
        end
        Citizen.Wait(wait)
    end
end)


Citizen.CreateThread(function()
    while true do
        local wait = 800
        if inBack == true then
            wait = 0
            DrawMarker(27, Config.FinalPoint.x, Config.FinalPoint.y, Config.FinalPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0
                , 5.0, 5.0, 255, 0,
                0, 100, false, false, 2, false, false, false, false)
            if GetDistanceBetweenCoords(Config.FinalPoint.x, Config.FinalPoint.y, Config.FinalPoint.z,
                GetEntityCoords(GetPlayerPed(-1), true))
                < 3 then
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour confirmer l'arrivée finale de l'avion",
                        time_display = 1 })

                    if IsControlJustPressed(1, 38) then
                        RemoveBlip(BlipDe)
                        ShowNotification("<C>[~b~Mission~s~]\nVous avez fait un excellent travail, voici votre paye.")
                        local pay = math.random(Config.Pay["Minimum"], Config.Pay["Maximum"])
                        _TriggerServerEvent("exyPlaneMission:giveMoney", pay)
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        DeleteVehicle(vehicle)
                        inJob = false
                        inBack = false
                    end

                else
                    RageUI.Text({ message = "Vous n'avez pas votre avion", time_display = 1 })
                end

            end

        end
        Citizen.Wait(wait)
    end
end)
