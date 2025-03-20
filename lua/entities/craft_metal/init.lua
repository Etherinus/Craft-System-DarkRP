AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_vehicles/carparts_muffler01a.mdl")
   self:SetModel("models/props_interiors/pot01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(10)

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:OnTakeDamage(dmginfo)
    if self:Health() <= 0 then return end
    
    self:SetHealth(self:Health() - dmginfo:GetDamage())
    
    if self:Health() <= 0 then
        self:Break()
    end
end

function ENT:Break()
    self:Remove()
end
