include("sh_config.lua")
AddCSLuaFile()

SWEP.PrintName			= "Body Pillow"
SWEP.Author			= "Nguyen" 
SWEP.Instructions		= "Right Click to Change Pillow Case, Hold R To Inspect, While Holding R; Left Click To Flip Pillow"
SWEP.Spawnable = true
SWEP.HoldType = "revolver"
SWEP.AdminOnly = true
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"
SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/daki/dakimakura.mdl"
SWEP.WorldModel			= "models/daki/dakimakura.mdl"
SWEP.Texture			= ""


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetModelScale(1)
	holder = self
end
function SWEP:PrimaryAttack()

end

function SWEP:Reload()

end

function SWEP:Deploy()

end

function SWEP:Holster()
	self.Owner:GetViewModel():SetMaterial("")
	return true
end

function SWEP:SecondaryAttack()
	if (SERVER) then
		net.Start("open_pillow")
		net.Send(self.Owner)
	end
end

if (CLIENT) then
	function SWEP:DrawWorldModel()
		local iBone = self.Owner:LookupBone("ValveBiped.Bip01_L_Hand")
		if(iBone) then
			self:SetRenderOrigin((self.Owner:GetBonePosition(iBone) + self:GetUp() * -8 + self:GetForward() * 3 + self:GetRight() * 2)+Vector(0,0,0))
			self:SetRenderAngles(Angle(15, self.Owner:GetAngles().y, 0))
		end
		
		self:DrawModel()
	end
	function SWEP:GetViewModelPosition(vPos, aAngles)
		if (input.IsKeyDown(KEY_R)) then
			if (input.IsMouseDown(MOUSE_LEFT)) then
				vPos = vPos + LocalPlayer():GetUp() * -20
				vPos = vPos + LocalPlayer():GetAimVector() * 50
				vPos = vPos + LocalPlayer():GetRight()
				aAngles:RotateAroundAxis(aAngles:Right(), 0)
				aAngles:RotateAroundAxis(aAngles:Forward(), 0)
				aAngles:RotateAroundAxis(aAngles:Up(), 180)				
			else
				vPos = vPos + LocalPlayer():GetUp() * -20
				vPos = vPos + LocalPlayer():GetAimVector() * 50
				vPos = vPos + LocalPlayer():GetRight()
				aAngles:RotateAroundAxis(aAngles:Right(), 0)
				aAngles:RotateAroundAxis(aAngles:Forward(), 0)
			end			
		else
			vPos = vPos + LocalPlayer():GetUp() * -20
			vPos = vPos + LocalPlayer():GetAimVector() * 20
			vPos = vPos + LocalPlayer():GetRight() * 12
			aAngles:RotateAroundAxis(aAngles:Right(), 0)
			aAngles:RotateAroundAxis(aAngles:Forward(), 0)
		end
			if self.Owner:GetActiveWeapon():GetClass() == "weapon_bodypillow" and self.Texture != "" then
				self.Owner:GetViewModel():SetMaterial(self.Texture)
			end
		return vPos, aAngles
	end
	net.Receive("open_pillow", function()
		local pillowMenu = vgui.Create("DFrame")
		pillowMenu:SetSize(600,300)
		pillowMenu:SetTitle("Choose You Waifu")
		pillowMenu:Center()
		pillowMenu:MakePopup()
		local pillowTexturePanel = vgui.Create("DPanel", pillowMenu)
		pillowTexturePanel:SetPos(5,30)
		pillowTexturePanel:SetSize(590, 265)
		local pillowScrollPanel = vgui.Create("DScrollPanel", pillowTexturePanel)
		pillowScrollPanel:Dock(FILL)
		local pillowGrid = vgui.Create("DGrid", pillowScrollPanel)
		pillowGrid:SetPos(5,5)
		pillowGrid:SetCols(5)
		pillowGrid:SetRowHeight(115)
		pillowGrid:SetColWide(115)
		for k,v in pairs(daki.Textures) do
			local pillowMaterial = vgui.Create("DImageButton")
			pillowMaterial:SetText("")
			pillowMaterial:SetSize(107,107)
			pillowMaterial:SetImage(v)
			pillowMaterial.DoClick = function()
				holder.Texture = v
				net.Start("pillow_send_texture")
				net.WriteString(v)
				net.WriteEntity(self)
				net.SendToServer()
			end
			pillowGrid:AddItem(pillowMaterial)
		end
	end)
	net.Receive("pillow_send_custom", function()
		daki.Textures = net.ReadTable()
	end)
end

if (SERVER) then
	net.Receive("pillow_send_texture", function(len, ply)
		if ply:GetActiveWeapon():GetClass() == "weapon_bodypillow" then
			local text = net.ReadString()
			local pillow = net.ReadEntity()
			holder:SetMaterial(text)
		end
	end)
	util.AddNetworkString("open_pillow")
	util.AddNetworkString("pillow_send_texture")
end