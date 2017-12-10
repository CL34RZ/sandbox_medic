AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
AddCSLuaFile("languages.lua")
util.AddNetworkString("mavgivehealth")
util.AddNetworkString("mavgivearmor")
util.AddNetworkString("mavshop")

include("config.lua")
include("shared.lua")
include("languages.lua")

function ENT:Initialize( )
	
	self:SetModel( MavNPCModel )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and caller:IsPlayer() then
		if not MedicIsFrench then
			if MedicShouldSpeak then
				self:EmitSound("vo/npc/male01/hi02.wav",self:GetPos())
			end
		end
		net.Start("mavshop")
		net.Send(caller)
	end
end

function ENT:OnTakeDamage()
	return false
end

function BuyHealth(length, activator)
	if activator:Health() < MavMaxHealth then
		activator:SetHealth(MavMaxHealth)
		hook.Run("Maverick_BuyHealth", activator, MavHealthCost)
		notification.AddLegacy("Health Replenished",0,4)
    else
    	notification.AddLegacy("Health is full!",1,4)
    end
end
net.Receive("mavgivehealth", BuyHealth)

function BuyArmor(length, activator)
	if activator:Armor() < MavMaxArmor then
		activator:SetArmor(MavMaxArmor)
		hook.Run("Maverick_BuyArmor", activator, MavArmorCost)
		notification.AddLegacy("Armor Replenished",0,4)
    else
    	notification.AddLegacy("Armor is full!",1,4)
    end
end
net.Receive("mavgivearmor", BuyArmor)