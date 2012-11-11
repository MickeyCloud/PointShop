ITEM.Name = "SMG"
ITEM.Enabled = true
ITEM.Description = "Get an SMG!"
ITEM.Cost = 50
ITEM.Model = "models/weapons/w_smg1.mdl"
ITEM.Respawnable = -1

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	Respawn = function(ply, item)
		item.Functions.OnGive(ply, item)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:Give("weapon_smg1")
	end
}