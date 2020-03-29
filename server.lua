local data = {}

TriggerEvent("redemrp_inventory:getData",function(call)
	data = call
end)

RegisterServerEvent("cryptos_butcher:giveitem")
AddEventHandler("cryptos_butcher:giveitem", function(item, amount)
	local _source = source
	data.addItem(_source, item, amount)
end)

RegisterServerEvent("cryptos_butcher:givexp")
AddEventHandler("cryptos_butcher:givexp", function(item)
	local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		user.addXP(item)
	end)
end)

RegisterServerEvent("cryptos_butcher:givemoney")
AddEventHandler("cryptos_butcher:givemoney", function(price)
	local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		user.addMoney(price)
	end)
end)
