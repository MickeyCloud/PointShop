ITEM.Name = "Crowbar"
ITEM.Enabled = true
ITEM.Description = "Get a crowbar!"
ITEM.Cost = 50
ITEM.Model = "models/weapons/w_crowbar.mdl"
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
		ply:Give("weapon_crowbar")
	end
}