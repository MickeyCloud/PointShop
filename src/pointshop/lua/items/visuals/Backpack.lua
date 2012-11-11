ITEM.Name = "Backpack"
ITEM.Enabled = true
ITEM.Description = "Gives you a wearable backpack."
ITEM.Cost = 100
ITEM.Model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.Bone = "ValveBiped.Bip01_Spine2"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(0.7, 0)
		pos = pos + (ang:Right() * 5) + (ang:Up() * 7) + (ang:Forward() * 2)
		return ent, pos, ang
	end,
}