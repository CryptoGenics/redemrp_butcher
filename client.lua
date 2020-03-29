local active = false
local ButcherPrompt
local hasAlreadyEnteredMarker, lastZone
local currentZone = nil

function SetupButcherPrompt()
    Citizen.CreateThread(function()
        local str = 'Sell to butcher'
        ButcherPrompt = PromptRegisterBegin()
        PromptSetControlAction(ButcherPrompt, 0xE8342FF2)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(ButcherPrompt, str)
        PromptSetEnabled(ButcherPrompt, false)
        PromptSetVisible(ButcherPrompt, false)
        PromptSetHoldMode(ButcherPrompt, true)
        PromptRegisterEnd(ButcherPrompt)
    end)
end

AddEventHandler('cryptos_butcher:hasEnteredMarker', function(zone)
	currentZone     = zone
end)

AddEventHandler('cryptos_butcher:hasExitedMarker', function(zone)
    if active == true then
        PromptSetEnabled(ButcherPrompt, false)
        PromptSetVisible(ButcherPrompt, false)
        active = false
    end
	currentZone = nil
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    SetupButcherPrompt()
	while true do
		Citizen.Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
		local isInMarker, currentZone = false

        for k = 1, #Config.shops do 
            local VectorCoords = vector3(coords)
            local ShopCoords = vector3(Config.shops[k]["x"], Config.shops[k]["y"], Config.shops[k]["z"])
            local distance = Vdist(ShopCoords, VectorCoords)
            if distance < 1.5 then
                isInMarker  = true
                currentZone = 'butcher'
                lastZone    = 'butcher'
            end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('cryptos_butcher:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('cryptos_butcher:hasExitedMarker', lastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        if currentZone then
            if active == false then
                PromptSetEnabled(ButcherPrompt, true)
                PromptSetVisible(ButcherPrompt, true)
                active = true
            end
            if PromptHasHoldModeCompleted(ButcherPrompt) then
				if currentZone == 'butcher' then
                    Selltobutcher()
                    PromptSetEnabled(ButcherPrompt, false)
                    PromptSetVisible(ButcherPrompt, false)
                    active = false
				end

				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

function Selltobutcher()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for k = 1, #Config.shops do 
        local VectorCoords = vector3(coords)
        local ShopCoords = vector3(Config.shops[k]["x"], Config.shops[k]["y"], Config.shops[k]["z"])
        local distance = Vdist(ShopCoords, VectorCoords)
        if distance < 3.0 then
            local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
            local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)
            local model = GetEntityModel(holding)
            local type = GetPedType(holding)
            if holding ~= false then
                for i, row in pairs(Config.Animal) do
                    if type == 28 then
                        if model == Config.Animal[i]["model"] then

                            local reward = Config.shops[k]["gain"] * Config.Animal[i]["reward"]
                            local level = Config.shops[k]["gain"] * Config.Animal[i]["xp"]

                            SetEntityAsMissionEntity(holding, true, true)
                            Wait(100)
                            DeleteEntity(holding)
                            Wait(500)

                            local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
                            local holdingcheck = GetPedType(entitycheck)
            
                            if holdingcheck == 0 then
                                TriggerServerEvent("cryptos_butcher:giveitem", Config.Animal[i]["item"], 1)
                                TriggerServerEvent("cryptos_butcher:givemoney", reward)
                                TriggerServerEvent("cryptos_butcher:givexp", level)
                                TriggerEvent("redemrp_notification:start", "You earned $" .. reward .. ", " .. level .. " xp and " .. Config.Animal[i]["item"] .. ' Meat', 5, "success")
                            else
                                TriggerEvent("redemrp_notification:start", "DELETE ENTITY NATIVE IS SCUFFED - RELOG PLZ", 2, "success")
                            end

                        end
                    end
                    if quality ~= false then
                        if quality == Config.Animal[i]["poor"] then

                            local rewardresult = Config.shops[k]["gain"] * Config.Animal[i]["reward"]
                            local levelresult = Config.shops[k]["gain"] * Config.Animal[i]["xp"]
                            local reward = rewardresult * 0.5
                            local level = levelresult * 0.5

                            SetEntityAsMissionEntity(holding, true, true)
                            Wait(100)
                            DeleteEntity(holding)
                            Wait(500)

                            local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
                            local holdingcheck = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)           
                            if holdingcheck == false then
                                TriggerServerEvent("cryptos_butcher:givemoney", reward)
                                TriggerServerEvent("cryptos_butcher:givexp", level)
                                TriggerEvent("redemrp_notification:start", "You earned $" .. reward .. " and " .. level .. " xp", 5, "success")
                            else
                                TriggerEvent("redemrp_notification:start", "DELETE ENTITY NATIVE IS SCUFFED - RELOG PLZ", 2, "success")
                            end

                        elseif quality == Config.Animal[i]["good"] then

                            local rewardresult = Config.shops[k]["gain"] * Config.Animal[i]["reward"]
                            local levelresult = Config.shops[k]["gain"] * Config.Animal[i]["xp"]
                            local reward = rewardresult * 0.75
                            local level = levelresult * 0.75

                            SetEntityAsMissionEntity(holding, true, true)
                            Wait(100)
                            DeleteEntity(holding)
                            Wait(500)

                            local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
                            local holdingcheck = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)          
                            if holdingcheck == false then
                                TriggerServerEvent("cryptos_butcher:givemoney", reward)
                                TriggerServerEvent("cryptos_butcher:givexp", level)
                                TriggerEvent("redemrp_notification:start", "You earned $" .. reward .. " and " .. level .. " xp", 5, "success")
                            else
                                TriggerEvent("redemrp_notification:start", "DELETE ENTITY NATIVE IS SCUFFED - RELOG PLZ", 2, "success")
                            end

                        elseif quality == Config.Animal[i]["perfect"] then

                            local reward = Config.shops[k]["gain"] * Config.Animal[i]["reward"]
                            local level = Config.shops[k]["gain"] * Config.Animal[i]["xp"]

                            SetEntityAsMissionEntity(holding, true, true)
                            Wait(100)
                            DeleteEntity(holding)
                            Wait(500)

                            local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
                            local holdingcheck = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)           
                            if holdingcheck == false then
                                TriggerServerEvent("cryptos_butcher:givemoney", reward)
                                TriggerServerEvent("cryptos_butcher:givexp", level)
                                TriggerEvent("redemrp_notification:start", "You earned $" .. reward .. " and " .. level .. " xp", 5, "success")
                            else
                                TriggerEvent("redemrp_notification:start", "DELETE ENTITY NATIVE IS SCUFFED - RELOG PLZ", 2, "success")
                            end

                        end
                    end
                end
            else
                TriggerEvent("redemrp_notification:start", "Not Holding Anything", 2, "error")
            end
        end
    end
end
