ITEM.Name = "football Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a football head."
ITEM.Cost = 200
ITEM.Model = "models/props_phx/misc/soccerball.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(0.5, 0)
		pos = pos + (ang:Forward() * -2)
		ang:RotateAroundAxis(ang:Right(), 90)
		return ent, pos, ang
	end,
}