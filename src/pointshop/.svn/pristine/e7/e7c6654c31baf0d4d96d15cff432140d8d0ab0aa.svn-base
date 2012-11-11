ITEM.Name = "AR2"
ITEM.Enabled = true
ITEM.Description = "Get an AR2!"
ITEM.Cost = 50
ITEM.Model = "models/weapons/w_irifle.mdl"
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
		ply:Give("weapon_ar2")
	end
}