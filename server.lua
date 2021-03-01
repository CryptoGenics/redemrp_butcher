local data = {}
TriggerEvent("redemrp_inventory:getData",function(call)
	data = call
end)

RegisterServerEvent('cryptos_loot')
AddEventHandler("cryptos_loot", function()
  local _source = source
  TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
    local get_item, lootpay, item, amount = false

    -- Money
    if Config.GiveMoney then
      local loot = math.random(1, Config.MaxPayRoll)
      local pay = loot / Config.PayDevider
	  lootpay = tonumber(string.format("%.2f", pay))
    end

    -- Items
    if Config.GiveItems then
      local item_chance = math.random(98, 100)
      if item_chance > 97 then
        local max_items = tonumber(#Config.ItemPayout['2percent'])
        local item_roll = math.random(1, max_items)
		item, amount = Config.ItemPayout['2percent'][item_roll].item, Config.ItemPayout['2percent'][item_roll].amount
		get_item = true
      elseif item_chance > 90 then
        local max_items = tonumber(#Config.ItemPayout['2percent'])
        local item_roll = math.random(1, max_items)
		item, amount = Config.ItemPayout['6percent'][item_roll].item, Config.ItemPayout['6percent'][item_roll].amount
		get_item = true
      elseif item_chance > 80 then
        local max_items = tonumber(#Config.ItemPayout['2percent'])
        local item_roll = math.random(1, max_items)
		item, amount = Config.ItemPayout['10percent'][item_roll].item, Config.ItemPayout['10percent'][item_roll].amount
		get_item = true
      end
    end

    -- Give Loot
    if get_item then
      if Config.Redemrp_Inventory2 == false then
        data.addItem(_source, item, tonumber(amount))
        if Config.GiveMoney then
          user.addMoney(lootpay)
          TriggerClientEvent("redemrp_notification:start", _source, "You stole $"..lootpay.." and "..amount..' '..item, 3, "success")
        else
          TriggerClientEvent("redemrp_notification:start", _source, "You stole "..amount..' '..item, 3, "success")
        end
      elseif Config.Redemrp_Inventory2 == true then
        local ItemInfo = data.getItemData(item)
        local ItemData = data.getItem(_source, item)
        if ItemData.ItemAmount >= ItemInfo.limit then
          TriggerClientEvent("redemrp_notification:start", _source, "You already have to many "..item, 2, "error")
        else
          ItemData.AddItem(tonumber(amount))
          if Config.GiveMoney then
            user.addMoney(lootpay)
            TriggerClientEvent("redemrp_notification:start", _source, "You stole $"..lootpay.." and "..amount..' '..item, 3, "success")
          else
            TriggerClientEvent("redemrp_notification:start", _source, "You stole "..amount..' '..item, 3, "success")
          end
        end  
      end
    else
      if Config.GiveMoney then
        user.addMoney(lootpay)
        TriggerClientEvent("redemrp_notification:start", _source, "You stole $"..lootpay, 3, "success")
      end  
    end

  end)
end)