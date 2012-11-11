ITEM.Name = "Super Speed"
ITEM.Enabled = true
ITEM.Description = "Gives you super speed!"
ITEM.Cost = 200
ITEM.Model = "models/weapons/w_toolgun.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		local oldWalk = ply.OldWalkSpeed or 250
		local oldRun = ply.OldRunSpeed or 500
		ply:SetWalkSpeed(oldWalk)
		ply:SetRunSpeed(oldRun)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		if not ply.OldWalkSpeed and not ply.OldRunSpeed then
			ply.OldWalkSpeed = ply:GetWalkSpeed()
			ply.OldRunSpeed = ply:GetRunSpeed()
		end
		
		ply:SetWalkSpeed(500)
		ply:SetRunSpeed(1000)
	end
}