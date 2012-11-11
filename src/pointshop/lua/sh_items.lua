POINTSHOP.Items = {}

function file.FindInLua( str )

	local files, dir = file.Find( str, "LUA" )

	for k, v in pairs( dir ) do
		files[#files+1] = v
	end

	return files

end

if SERVER then

	util.AddNetworkString( "PointShop - Get Items" )

	for _, fname in pairs(file.FindInLua("items/*")) do
		if #file.FindInLua("items/" .. fname .. "/__category.lua") > 0 then

			CATEGORY = {}
			if SERVER then AddCSLuaFile("items/" .. fname .. "/__category.lua") end
			include("items/" .. fname .. "/__category.lua")
			
			if not POINTSHOP.Items[CATEGORY.Name] then
				CATEGORY.Items = {}
				POINTSHOP.Items[CATEGORY.Name] = CATEGORY
			end
			
			for _, name in pairs(file.FindInLua("items/" .. fname .. "/*.lua")) do
				if name ~= "__category.lua" then
					ITEM = {}
					if SERVER then AddCSLuaFile("items/" .. fname .. "/" .. name) end
					include("items/" .. fname .. "/" .. name)
					ITEM.ID = string.lower(string.sub(name, 1, -5))
					POINTSHOP.Items[CATEGORY.Name].Items[ITEM.ID] = ITEM
				end
			end

		end
	end

	hook.Add( "PlayerInitialSpawn", "PointShop Cats/Items", function( ply )

		timer.Simple( 0.1, function()
			if not (ply and IsValid(ply)) then return end
			net.Start( "PointShop - Get Items" )
				net.WriteTable( POINTSHOP.Items )
			net.Send( ply )
		end )

	end )

else

	net.Receive( "PointShop - Get Items", function()

		local tab = net.ReadTable()

		POINTSHOP.Items = tab

	end )

end