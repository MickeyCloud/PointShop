ITEM.Name = "Plasma Trail"
ITEM.Enabled = true
ITEM.Description = "Gives you a team colored plasma trail."
ITEM.Cost = 200
ITEM.Material = "trails/plasma"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		SafeRemoveEntity(ply.Trail)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply.Trail = util.SpriteTrail(ply, 0, team.GetColor(ply:Team()), false, 15, 1, 4, 0.125, item.Material .. ".vmt")
	end
}