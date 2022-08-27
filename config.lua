Config = {
    UseESX = true,
    ESXTrigg = "esx:getSharedObject"
}

Config.Start = { x = -941.48, y = -2955.03, z = 12.95, label = "Activité pilote d'avions" }
Config.SpawnPoint = { x = -981.21, y = -3006.55, z = 12.95, h = 60.0 }
Config.EnableBlip = true

Config.Planes = {
    { model = "luxor", label = "Luxor", price = 5000 },
    { model = "luxor2", label = "Luxor luxe", price = 5000 },
}


Config.StartPoint = { x = 1698.9973144531, y = 3251.5947265625, z = 40.94730758667 }
Config.FinalPoint = { x = -979.81512451172, y = -2996.3254394531, z = 13.90 }

Config.Pay = {
    ["Minimum"] = 5000,
    ["Maximum"] = 10000,
}

if Config.UseESX == true then
    if IsDuplicityVersion() then
        ESX = nil
        TriggerEvent(Config.ESXTrigg, function(obj) ESX = obj end)
    else
        ESX = nil
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent(Config.ESXTrigg, function(obj) ESX = obj end)
                Citizen.Wait(0)
            end
        end)
    end
end
