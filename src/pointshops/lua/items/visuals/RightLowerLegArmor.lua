ITEM.Name = "RL Leg Armor"
ITEM.Enabled = true
ITEM.Description = "Armor for your right lower leg."
ITEM.Cost = 100
ITEM.Model = "models/props_combine/CombineInnerwall001a.mdl"
ITEM.Bone = "ValveBiped.Bip01_R_Calf"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(0.025, 0)
		--pos = pos + (ang:Right() * 2)
		pos = pos + (ang:Forward() * 8)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
		return ent, pos, ang
	end,
}