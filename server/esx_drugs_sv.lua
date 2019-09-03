ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingCoke    = {}
local PlayersTransformingCoke  = {}
local PlayersSellingCoke       = {}
local PlayersHarvestingMeth    = {}
local PlayersTransformingMeth  = {}
local PlayersSellingMeth       = {}
local PlayersHarvestingWeed    = {}
local PlayersTransformingWeed  = {}
local PlayersSellingWeed       = {}
local PlayersHarvestingOpium   = {}
local PlayersTransformingOpium = {}
local PlayersSellingOpium      = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

--coke
local function HarvestCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent("pNotify:SendNotification", source, {text =  _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local coke = xPlayer.getInventoryItem('coke')

			if coke.limit ~= -1 and coke.count >= coke.limit then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('inv_full_coke'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.addInventoryItem('coke', 1)
				HarvestCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestCoke')
AddEventHandler('esx_drugs:startHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('pickup_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


	HarvestCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestCoke')
AddEventHandler('esx_drugs:stopHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false

end)

local function TransformCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('too_many_pouches'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			elseif cokeQuantity < 5 then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('not_enough_coke'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.removeInventoryItem('coke', 1)
				xPlayer.addInventoryItem('coke_pooch', 1)
			
				TransformCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformCoke')
AddEventHandler('esx_drugs:startTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('packing_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


	TransformCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformCoke')
AddEventHandler('esx_drugs:stopTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = false

end)

local function SellCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent("pNotify:SendNotification", source, {text =  _U('no_pouches_sale'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })
				
			else
				xPlayer.removeInventoryItem('coke_pooch', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 70)
					TriggerClientEvent("pNotify:SendNotification", source, {text =  _U('sold_one_coke'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 80)
					TriggerClientEvent("pNotify:SendNotification", source, {text =  _U('sold_one_coke'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 90)
					TriggerClientEvent("pNotify:SendNotification", source, {text =  _U('sold_one_coke'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 100)
					TriggerClientEvent("pNotify:SendNotification", source, {text =  _U('sold_one_coke'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 110)
					TriggerClientEvent("pNotify:SendNotification", source, {text =  _U('sold_one_coke'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 120)
					TriggerClientEvent("pNotify:SendNotification", source, {text =  _U('sold_one_coke'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				end
				
				SellCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellCoke')
AddEventHandler('esx_drugs:startSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text =  _U('sale_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


	SellCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopSellCoke')
AddEventHandler('esx_drugs:stopSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = false

end)

--meth
local function HarvestMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end
	
	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local meth = xPlayer.getInventoryItem('meth')

			if meth.limit ~= -1 and meth.count >= meth.limit then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('inv_full_meth'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.addInventoryItem('meth', 1)
				HarvestMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestMeth')
AddEventHandler('esx_drugs:startHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('pickup_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })
	
	HarvestMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestMeth')
AddEventHandler('esx_drugs:stopHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = false

end)

local function TransformMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local methQuantity = xPlayer.getInventoryItem('meth').count
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('too_many_pouches'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				
			elseif methQuantity < 5 then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('not_enough_meth'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.removeInventoryItem('meth', 1)
				xPlayer.addInventoryItem('meth_pooch', 1)
				
				TransformMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformMeth')
AddEventHandler('esx_drugs:startTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('packing_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


	TransformMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformMeth')
AddEventHandler('esx_drugs:stopTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = false

end)

local function SellMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('no_pouches_sale'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.removeInventoryItem('meth_pooch', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 180)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_meth', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 190)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_meth', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 200)
					
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_meth', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 220)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_meth', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 230)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_meth', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 5 then
					xPlayer.addAccountMoney('black_money', 250)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_meth', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', 270)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_meth', CopsConnected, Config.RequiredCopsMeth),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				end
				
				SellMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellMeth')
AddEventHandler('esx_drugs:startSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('sale_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


	SellMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopSellMeth')
AddEventHandler('esx_drugs:stopSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = false

end)

--weed
local function HarvestWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local weed = xPlayer.getInventoryItem('weed')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('inv_full_weed'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.addInventoryItem('weed', 1)
				HarvestWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestWeed')
AddEventHandler('esx_drugs:startHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('pickup_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


	HarvestWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestWeed')
AddEventHandler('esx_drugs:stopHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = false

end)

local function TransformWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('too_many_pouches'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			elseif weedQuantity < 5 then
			
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('not_enough_weed'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.removeInventoryItem('weed', 1)
				xPlayer.addInventoryItem('weed_pooch', 1)
				
				TransformWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformWeed')
AddEventHandler('esx_drugs:startTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('packing_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

	TransformWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformWeed')
AddEventHandler('esx_drugs:stopTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = false

end)

local function SellWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('no_pouches_sale'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.removeInventoryItem('weed_pooch', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 200)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_weed'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 210)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_weed'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 220)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_weed'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 230)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_weed'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected >= 4 then
					xPlayer.addAccountMoney('black_money', 250)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_weed'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				end
				
				SellWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellWeed')
AddEventHandler('esx_drugs:startSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = true


	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('sale_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


	SellWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopSellWeed')
AddEventHandler('esx_drugs:stopSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = false

end)


--opium

local function HarvestOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingOpium[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local opium = xPlayer.getInventoryItem('opium')

			if opium.limit ~= -1 and opium.count >= opium.limit then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('inv_full_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.addInventoryItem('opium', 1)
				HarvestOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestOpium')
AddEventHandler('esx_drugs:startHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('pickup_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

	HarvestOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestOpium')
AddEventHandler('esx_drugs:stopHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = false

end)

local function TransformOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('too_many_pouches'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			elseif opiumQuantity < 5 then
				
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('not_enough_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.removeInventoryItem('opium', 1)
				xPlayer.addInventoryItem('opium_pooch', 1)
			
				TransformOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformOpium')
AddEventHandler('esx_drugs:startTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('packing_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

	TransformOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformOpium')
AddEventHandler('esx_drugs:stopTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = false

end)

local function SellOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent("pNotify:SendNotification", source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent("pNotify:SendNotification", source, {text = _U('no_pouches_sale'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

			else
				xPlayer.removeInventoryItem('opium_pooch', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 220)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 230)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 240)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 250)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 260)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 5 then
					xPlayer.addAccountMoney('black_money', 270)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 6 then
					xPlayer.addAccountMoney('black_money', 280)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 7 then
					xPlayer.addAccountMoney('black_money', 290)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 8 then
					xPlayer.addAccountMoney('black_money', 300)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected == 9 then
					xPlayer.addAccountMoney('black_money', 310)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

				elseif CopsConnected >= 10 then
					xPlayer.addAccountMoney('black_money', 320)
					TriggerClientEvent("pNotify:SendNotification", source, {text = _U('sold_one_opium'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


				end
				
				SellOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellOpium')
AddEventHandler('esx_drugs:startSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = true

	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('sale_in_prog'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })


	SellOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopSellOpium')
AddEventHandler('esx_drugs:stopSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = false

end)

RegisterServerEvent('esx_drugs:GetUserInventory')
AddEventHandler('esx_drugs:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_drugs:ReturnInventory', 
		_source, 
		xPlayer.getInventoryItem('coke').count, 
		xPlayer.getInventoryItem('coke_pooch').count,
		xPlayer.getInventoryItem('meth').count, 
		xPlayer.getInventoryItem('meth_pooch').count, 
		xPlayer.getInventoryItem('weed').count, 
		xPlayer.getInventoryItem('weed_pooch').count, 
		xPlayer.getInventoryItem('opium').count, 
		xPlayer.getInventoryItem('opium_pooch').count,
		xPlayer.job.name, 
		currentZone
	)
end)

ESX.RegisterUsableItem('weed', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('esx_drugs:onPot', _source)
	TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('used_one_weed'),type = "warning",queue = "duty", theme = "metroui", timeout = 2500,layout = "topRight" })

end)
