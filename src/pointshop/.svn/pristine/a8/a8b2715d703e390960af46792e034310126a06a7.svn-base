ITEM.Name = "Monitor Head 2"
ITEM.Enabled = true
ITEM.Description = "Gives you a monitor2 (css prop) head."
ITEM.Cost = 400
ITEM.Model = "models/props/cs_office/computer_monitor.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(0.6, 0)
		pos = pos + (ang:Forward() * -5) + (ang:Up() * -5)
		return ent, pos, ang
	end,
}