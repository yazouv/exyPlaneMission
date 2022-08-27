local Token = math.random(999, 9999) .. "-exyPlaneMission-" ..
	math.random(999, 9999) .. "-FIVEDEV-" .. math.random(999, 9999)


RegisterServerEvent('exyPlaneMission:RequestToken')
AddEventHandler('exyPlaneMission:RequestToken', function()
	local source = source
	TriggerClientEvent('exyPlaneMission:OnRequestToken', source, Token)
end)

RegisterNetEvent("exyPlaneMission:giveMoney")
AddEventHandler("exyPlaneMission:giveMoney", function(tk, pay)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	xPlayer.addMoney(pay)
end)

ESX.RegisterServerCallback('exyPlaneMission:CheckMoney', function(source, cb, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= price then --utilisez getAccount('money').money si vous utilisez par account
		xPlayer.removeMoney(price) --utilisez xPlayer.removeAccountMoney('money', tonumber(price)) si vous utilisez par account
		cb(true)
	else
		cb(false)
	end
end)
