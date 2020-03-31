AddCSLuaFile()

daki = {}
daki.Textures = {"daki/dakimakura", "daki/tooru", "daki/maki", "daki/honkai", "daki/megumin", "daki/yuno", "daki/shinobu", "daki/mikasa", "daki/saber", "daki/asuna"}


if (SERVER) then
	if (file.Exists("custompillows.txt", "DATA")) then
		local customs = util.JSONToTable(file.Read("custompillows.txt", "DATA"))
		for k,v in pairs(customs) do
			table.insert(daki.Textures, v)
		end
	else
		local customs = {}
		file.Write("custompillows.txt", util.TableToJSON(customs))
	end
	
	hook.Add("PlayerInitialSpawn", "send_custom", function(ply)
		net.Start("pillow_send_custom")
		net.WriteTable(daki.Textures)
		net.Send(ply)
	end)
	util.AddNetworkString("pillow_send_custom")
end

if (CLIENT) then
	hook.Add("Think", "cancel", function()
		if (!LocalPlayer():Alive()) then
			LocalPlayer():GetViewModel():SetMaterial("")
		end
	end)
end

print("shared config loaded...")