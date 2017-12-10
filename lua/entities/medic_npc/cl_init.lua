include("config.lua")
include("shared.lua")
include("languages.lua")

function ENT:Initialize()
	self.AutomaticFrameAdvance = true
end

surface.CreateFont("MaverickFont", {
	size = 55,
	font = "Impact",
	antialias = true
})
surface.CreateFont("barTopInfo",{
	size = 25,
	font = "Arial",
	antialias = true
})
surface.CreateFont("medic_topText", {
	font = Arial,
	size = 75,
	antialias = true
})

local function leftlerp(self,w,h,speed,color)
	self.left = (self.left or 0)
	if self:IsHovered() then
		self.left = Lerp(speed,self.left,w)
	else
		self.left = Lerp(speed,self.left,0)
	end
	draw.RoundedBox(0,0,0,self.left,h,color)
end

local function rightlerp(self,w,h,speed,color)
	self.right = (self.right or w)
	if self:IsHovered() then
		self.right = Lerp(speed,self.right,0)
	else
		self.right = Lerp(speed,self.right,w)
	end
	draw.RoundedBox(0,self.right,0,w-self.right,h,color)
end

function ENT:Draw()
	self.Entity:DrawModel()
	local mypos = self:GetPos()
	if (LocalPlayer():GetPos():Distance(mypos) >= 1000) then return end
	local offset = Vector(0, 0, 80)
	local pos = mypos + offset
	local ang = (LocalPlayer():EyePos() - pos):Angle()
	ang.p = 0
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 180)
	cam.Start3D2D(pos,ang,0.04)
		draw.RoundedBox(6,-250-2,0-2,500+4,150+4,Color(255,255,255))
		draw.RoundedBox(6,-250,0,500,150,Color(0,0,0))
		draw.SimpleText("Medic NPC","medic_topText",0,75,Color(255,255,255),1,1)
	cam.End3D2D()
end

function NPCMenu()
	local NPCPanel = vgui.Create("DFrame")
	NPCPanel:SetSize(500,260)
	NPCPanel:SetDraggable(true)
	NPCPanel:SetTitle("")
	NPCPanel:MakePopup()
	NPCPanel:SetSizable(false)
	NPCPanel:SetDeleteOnClose(false)
	NPCPanel:ShowCloseButton(false)
	NPCPanel:Center()
	NPCPanel.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur(self)
		draw.RoundedBox(8,0,0,w,h,MavPanelBorder)
		draw.RoundedBox(8,2,2,w-4,h-4,MavPanelColor)
		if not MedicIsFrench then
			draw.SimpleText("Let's get you patched up then shall we?","barTopInfo",250,100,Color(255,255,255),1,1)
			draw.SimpleTextOutlined("Medic","medic_topText",250,50,Color(255,255,255),1,1,2,Color(0,0,0))
		else
			draw.SimpleText("Allons-nous vous remémer, alors devons-nous?","barTopInfo",250,100,Color(255,255,255),1,1)
			draw.SimpleTextOutlined("Medecin","medic_topText",250,50,Color(255,255,255),1,1,2,Color(0,0,0))
		end
	end

	local HealthButton = vgui.Create("DButton", NPCPanel)
		HealthButton:SetPos(25,175)
		HealthButton:SetSize(125,50)
		if not MedicIsFrench then
			HealthButton:SetText(" Health")
		else
			HealthButton:SetText(" Santé")
		end
		HealthButton:SetTextColor(CLTextColor)
		local leftlerp = (leftlerp or 0)
		HealthButton.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(150,0,0))
			leftlerp(self,w+1,h,0.02,TextHoverColor)
		end
		HealthButton.DoClick = function()
			NPCPanel:Close()
			net.Start("mavgivehealth")
			net.SendToServer(ply)
		end

	local ArmorButton = vgui.Create("DButton", NPCPanel)
		ArmorButton:SetPos(500-150,175)
		ArmorButton:SetSize(125,50)
		if not MedicIsFrench then
			ArmorButton:SetText(" Armor")
		else
			ArmorButton:SetText(" Armure")
		end
		ArmorButton:SetTextColor(CLTextColor)
		ArmorButton.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,150))
			rightlerp(self,w+1,h,0.02,TextHoverColor)
		end
		ArmorButton.DoClick = function()
			NPCPanel:Close()
			net.Start("mavgivearmor")
			net.SendToServer(ply)
		end

	local CloseButton = vgui.Create("DButton" , NPCPanel)
	CloseButton:SetPos(500-25,4)
	CloseButton:SetSize(20,20)
	CloseButton:SetText("X")
	CloseButton:SetTextColor(Color(255,255,255,255))
	CloseButton.Paint = function(self,w,h)
		draw.RoundedBox(150,0,0,w-1,h,Color(255,0,0))
	end
	CloseButton.DoClick = function()
		NPCPanel:Close()
	end
end
net.Receive("mavshop", NPCMenu)