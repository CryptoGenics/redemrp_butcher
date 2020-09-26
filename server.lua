local data = {}

TriggerEvent("redemrp_inventory:getData",function(call)
	data = call
end)

RegisterServerEvent("cryptos_butcher:giveitem")
AddEventHandler("cryptos_butcher:giveitem", function(item, amount)
	local _source = source
	data.addItem(_source, item, amount)
end)

RegisterServerEvent("cryptos_butcher:reward")
AddEventHandler("cryptos_butcher:reward", function(amount, xp)
	local _source = source
	local _amount = tonumber(string.format("%.2f", amount))
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		user.addMoney(_amount)
		user.addXP(xp)
	end)
end)