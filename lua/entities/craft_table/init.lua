AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("CraftMenu")
util.AddNetworkString("CraftItem")
util.AddNetworkString("RequestCraft")
util.AddNetworkString("CraftUpdate")

local validClasses = {
    craft_barrel  = true,
    craft_glass   = true,
    craft_handle  = true,
    craft_metal   = true,
    craft_plastic = true,
    craft_shutter = true,
    craft_store   = true,
    craft_tree    = true
}

function ENT:Initialize()
    self:SetModel("models/props_wasteland/controlroom_desk001b.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetHealth(10)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self.StoredItems = {}
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

function ENT:CanAcceptItem(ent)
    if not IsValid(ent) then return false end
    return validClasses[ent:GetClass()] or false
end

function ENT:StartTouch(ent)
    if self:CanAcceptItem(ent) then
        local class = ent:GetClass()
        self.StoredItems[class] = (self.StoredItems[class] or 0) + 1
        ent:Remove()
    end
end

function ENT:HasMaterialsFor(recipeKey)
    local recipe = self.Recipes and self.Recipes[recipeKey]
    if not recipe then return false end

    for _, matData in ipairs(recipe.materials) do
        local stored = self.StoredItems[matData.class] or 0
        if stored < matData.required then
            return false
        end
    end
    return true
end

function ENT:ConsumeMaterials(recipeKey)
    local recipe = self.Recipes and self.Recipes[recipeKey]
    if not recipe then return end

    for _, matData in ipairs(recipe.materials) do
        local stored = self.StoredItems[matData.class] or 0
        self.StoredItems[matData.class] = math.max(stored - matData.required, 0)
    end
end

function ENT:Use(activator)
    if IsValid(activator) and activator:IsPlayer() then
        net.Start("CraftMenu")
            net.WriteEntity(self)
            net.WriteTable(self.StoredItems or {})
        net.Send(activator)
    end
end

net.Receive("RequestCraft", function(_, ply)
    local craftEnt = net.ReadEntity()
    if not IsValid(craftEnt) then return end

    net.Start("CraftUpdate")
        net.WriteEntity(craftEnt)
        net.WriteTable(craftEnt.StoredItems or {})
    net.Send(ply)
end)

net.Receive("CraftItem", function(_, ply)
    local craftEnt  = net.ReadEntity()
    local recipeKey = net.ReadString()
    if not IsValid(craftEnt) then return end

    if craftEnt:GetPos():Distance(ply:GetPos()) > 200 then return end

    if not craftEnt:HasMaterialsFor(recipeKey) then
        if DarkRP and DarkRP.notify then
            DarkRP.notify(ply, 1, 4, "You don't have enough materials for crafting!")
        end
        return
    end

    craftEnt:ConsumeMaterials(recipeKey)

    local recipe = craftEnt.Recipes and craftEnt.Recipes[recipeKey]
    if recipe and recipe.result then
        if recipe.isEntity then
            local ent = ents.Create(recipe.result)
            if IsValid(ent) then
                local mins, maxs = craftEnt:OBBMins(), craftEnt:OBBMaxs()
                local tableHeight = maxs.z - mins.z
                local spawnPos = craftEnt:GetPos() + Vector(0, 0, tableHeight + 5)
                ent:SetPos(spawnPos)
                ent:Spawn()

                local phys = ent:GetPhysicsObject()
                if IsValid(phys) then
                    phys:Wake()
                end
            end
        else
            ply:Give(recipe.result)
        end

        if DarkRP and DarkRP.notify then
            DarkRP.notify(ply, 0, 4, "You have successfully crafted the item!")
        end
    end
end)
