CreateConVar("pillow_call_to_home", 1, FCVAR_ARCHIVE)

local call_to_home = GetConVar("pillow_call_to_home"):GetInt()

if (call_to_home == 1) then
	local info = {}
	info.ip = game.GetIPAddress()
	if (!info.ip == "0.0.0.0:0") then
		http.Post("http://konosuba.moe/gmod/addons.php", {
			["ip"] = game.GetIPAddress(),
			["hostname"] = GetHostName(),
			["addon"] = "Body Pillow",
			["gamemode"] = engine.ActiveGamemode()
		}, function(result)
			if result then print ("Body Pillow Called To Home!") end
		end, function(failed)
			print("Body Pillow Couldn't Call To Home!")
		end)
	end
end