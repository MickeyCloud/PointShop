ITEM.Name = "Headcrab Hat"
ITEM.Enabled = true
ITEM.AdminOnly = true
ITEM.Description = "Gives you a Headcrab hat."
ITEM.Cost = 100
ITEM.Model = "models/headcrabclassic.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(0.7, 0)
		pos = pos + (ang:Forward() * 2)
		ang:RotateAroundAxis(ang:Right(), 20)
		return ent, pos, ang
	end,
}