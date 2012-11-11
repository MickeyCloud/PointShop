ITEM.Name = "Third Person"
ITEM.Enabled = true
ITEM.Description = "Allows you to use Third person Camera."
ITEM.Cost = 200
ITEM.Model = "models/weapons/w_toolgun.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		ply:SetArmor(ply:Armor() - 100)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:ConCommand("ThirdPerson")
	end
}