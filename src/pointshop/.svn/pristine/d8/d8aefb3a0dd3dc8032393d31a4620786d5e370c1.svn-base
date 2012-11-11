ITEM.Name = "Allow Inflator"
ITEM.Enabled = true
ITEM.Description = "Allows you to use the inflator tool."
ITEM.Cost = 200
ITEM.Model = "models/weapons/w_toolgun.mdl"

ITEM.ConstantHooks = {
	CanTool = function(ply, item, tr, toolmode)
		if toolmode == "inflator" then
			return ply:PS_HasItem(item.ID)
		end
	end
}