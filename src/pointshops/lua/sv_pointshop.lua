POINTSHOP.Hats = {}

local KeyToHook = {
	F1 = "ShowHelp",
	F2 = "ShowTeam",
	F3 = "ShowSpare1",
	F4 = "ShowSpare2",
	None = "ThisHookDoesNotExist"
}

hook.Add("OnNPCKilled", "PointShop_OnNPCKilled", function(ent, attacker, inflictor)
	if attacker:IsPlayer() and attacker:IsValid() then
		attacker:PS_GivePoints(10, "killed " .. ent:GetClass())
	end
end)

hook.Add("PlayerDeath", "PointShop_PlayerDeath", function(victim, inflictor, attacker)
	if attacker:IsPlayer() and attacker:IsValid() and not victim == attacker then
		attacker:PS_GivePoints(10, "killed " .. victim:Nick())
	end
end)

hook.Add(KeyToHook[POINTSHOP.Config.ShopKey], "PointShop_ShopKey", function(ply)
	ply:PS_ShowShop(true)
end)

hook.Add("InitPostEntity", "PointShop_InitPostEntity", function()
	if POINTSHOP.Config.SellersEnabled then
		if not POINTSHOP.Config.Sellers[game.GetMap()] then return end
		for seller_id, seller in pairs(POINTSHOP.Config.Sellers[game.GetMap()]) do
			local npc = ents.Create("npc_citizen")
			npc:SetPos(seller.Position or Vector(0, 0, 0))
			npc:SetAngles(seller.Angle or Angle(0, 0, 0))
			npc:SetModel(seller.Model or "models/Humans/Group02/male_07.mdl")
			npc:Spawn()
			npc:Activate()
			npc:SetAnimation(ACT_IDLE_ANGRY)
			npc:CapabilitiesClear()
			npc:CapabilitiesAdd( bit.band(CAP_ANIMATEDFACE, CAP_TURN_HEAD) )
			npc:SetNWBool("IsPointShopNPC", true)
			npc:SetNWInt("PointShopID", seller_id)
			npc.PointShopID = seller_id
			for _,v in pairs(ents.GetAll()) do npc:AddEntityRelationship(v, D_LI, 99) end
			npc:SetNWBool("IsPointShopNPC", true)
			npc:SetNWInt("PointShopID", seller_id)
			npc.PointShopID = seller_id
		end
	end
end)

hook.Add("KeyPress", "PointShop_KeyPress", function(ply, key)
	if key == IN_USE then
		local npc = ply:GetEyeTrace().Entity
		if IsValid(npc) and npc:IsNPC() and npc:GetNWBool("IsPointShopNPC") then
			ply:PS_ShowShop(true, npc.PointShopID)
		end
	end
end)

hook.Add("ScaleNPCDamage", "PointShop_ScaleNPCDamage", function(npc, hit, dmg)
	if npc:GetNWBool("IsPointShopNPC") then
		dmg:SetDamage(0)
	end
end)

hook.Add("EntityTakeDamage", "PointShop_EntityTakeDamage", function(ent, inflictor, attacker, amount)
	if ent:GetNWBool("IsPointShopNPC") then
		return false
	end
end)

hook.Add("PlayerInitialSpawn", "PointShop_PlayerInitialSpawn", function(ply)
	ply.PS_Points = false
	ply.PS_Items = false
	
	ply:PS_UpdatePoints()
	ply:PS_UpdateItems()
	ply:PS_SendHats()
		
	for _, item_id in pairs(ply.PS_Items) do
		local item = POINTSHOP.FindItemByID(item_id)
		
		if item and item.Functions and item.Functions.OnGive then
			item.Functions.OnGive(ply, item)
		end
	end

	local timerName = "PointShop_"..ply:UniqueID()
	
	if POINTSHOP.Config.PointsTimer then
		timer.Create(timerName, 60 * POINTSHOP.Config.PointsTimerDelay, 0, function()
			if not (ply and IsValid(ply)) then
				if timerName then timer.Destroy( timerName ) end
				return
			end
			ply:PS_GivePoints(POINTSHOP.Config.PointsTimerAmount, POINTSHOP.Config.PointsTimerDelay .. " minutes on server")
		end)
	end
	
	if POINTSHOP.Config.ShopNotify then
		ply:PS_Notify('You have ' .. ply:PS_GetPoints() .. ' points to spend! Press ' .. POINTSHOP.Config.ShopKey .. ' to open the Shop!')
	end
end)

for id, category in pairs(POINTSHOP.Items) do
	if category.Enabled then
		for item_id, item in pairs(category.Items) do
			if item.Enabled then
				if item.Hooks then
					for name, func in pairs(item.Hooks) do
						timer.Simple(1, function()
							hook.Add(name, "PointShop_" .. item_id .. "_" .. name, function(ply, ...) -- Pass any arguments through.
								if ply:PS_HasItem(item_id) then -- only run the hook if the player actually has this item.
									item.ID = item_id -- Pass the ID incase it's needed in the hook.
									return func(ply, item, unpack({...}))
								end
							end)
						end)
					end
				end
				if item.ConstantHooks then
					for name, func in pairs(item.ConstantHooks) do
						hook.Add(name, "PointShop_" .. item_id .. "_Constant_" .. name, function(ply, ...) -- Pass any arguments through.
							item.ID = item_id
							return func(ply, item, unpack({...}))
						end)
					end
				end
			end
		end
	end
end

concommand.Add("pointshop_buy", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if ply:PS_HasItem(item_id) then
		ply:PS_Notify('You already have this item!')
		return
	end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	local category = POINTSHOP.FindCategoryByItemID(item_id)
	
	if not item.Enabled then
		ply:PS_Notify('This item isn\'t enabled!')
		return
	end
	
	if not category.Enabled then
		ply:PS_Notify('The category ' .. category.Name .. 'is not enabled!')
		return
	end
	
	if item.AdminOnly and not ply:IsAdmin() then
		ply:PS_Notify('Only admins can buy this item!')
		return
	end
	
	if item.Functions and item.Functions.CanPlayerBuy then
		local canbuy, reason = item.Functions.CanPlayerBuy(ply)
		if not canbuy then
			ply:PS_Notify('Can\'t buy item (' .. reason .. ')')
			return
		end
	end
	
	if category.NumAllowedItems and ply:PS_NumItemsFromCategory(category) >= category.NumAllowedItems then -- More than would never happen, but just incase.
		ply:PS_Notify('You can only have ' .. category.NumAllowedItems .. ' items from the ' .. category.Name .. ' category!')
		return
	end
	
	if not ply:PS_CanAfford(item_id) then
		ply:PS_Notify('You can\'t afford this!')
		return
	end
	
	if item.Respawnable and item.Respawnable >= 0 then
		ply:SetPData("PS_" .. item_id .. "_Respawns", item.Respawnable)
	end
	
	ply:PS_GiveItem(item_id, true)
	ply:PS_ShowShop(false)
	
end)

concommand.Add("pointshop_sell", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if not ply:PS_HasItem(item_id) then return end
	
	ply:PS_TakeItem(item_id, true)
end)

concommand.Add("pointshop_respawn", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if not ply:PS_HasItem(item_id) then return end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	if not item.Respawnable then return end
	
	local respawns
	
	if item.Respawnable >= 0 then
		respawns = tonumber(ply:GetPData("PS_" .. item_id .. "_Respawns") or item.Respawnable)
	
		if respawns == 0 then
			ply:PS_Notify("You have no more available respawns of this item!")
			return
		elseif respawns > 0 then
			ply:PS_Notify("You have " ..respawns .. " more available respawns of this item!")
		end
	end
	
	if item.Functions and item.Functions.Respawn then
		item.Functions.Respawn(ply, item)
		if item.Respawnable > 0 then
			ply:SetPData("PS_" .. item_id .. "_Respawns", respawns - 1)
		end
	end
end)

concommand.Add("ps_givepoints", function(ply, cmd, args)
	-- Give Points
	if not ply:IsAdmin() then return end
	
	local to_give = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_give or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_give) == "player" then
		if to_give then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_give:PS_GivePoints(num, "given by " .. ply:Nick() .. "!")
	end
end)

concommand.Add("ps_takepoints", function(ply, cmd, args)
	-- Take Points
	if not ply:IsAdmin() then return end
	
	local to_take = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_take or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_take) == "player" then
		if to_take then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_take:PS_TakePoints(num, "taken by " .. ply:Nick() .. "!")
	end
end)

concommand.Add("ps_setpoints", function(ply, cmd, args)
	-- Set Points
	if not ply:IsAdmin() then return end
	
	local to_set = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_set or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_set) == "player" then
		if to_set then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_set:PS_SetPoints(num)
		to_set:PS_Notify("Points set to " .. num .. " by " .. ply:Nick() .. "!")
	end
end)