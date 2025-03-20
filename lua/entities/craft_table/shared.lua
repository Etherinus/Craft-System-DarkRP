ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Craft Table"
ENT.Author          = "Etherinus"
ENT.Category        = "Craft"

ENT.Spawnable       = true
ENT.AdminSpawnable  = true

ENT.Recipes = {
    ["weapon_ak472"] = {
        name = "AK72",
        desc = "A light and agile weapon boasting high accuracy.",
        materials = {
            { class = "craft_metal",   required = 5, name = "Metal" },
            { class = "craft_plastic", required = 2, name = "Plastic" },
            { class = "craft_shutter", required = 1, name = "Shutter" },
            { class = "craft_barrel",  required = 1, name = "Barrel" },
            { class = "craft_handle",  required = 1, name = "Handle" },
            { class = "craft_store",   required = 1, name = "Magazine" }
        },
        result = "weapon_ak472"
    },
    ["weapon_deagle2"] = {
        name = "Deagle",
        desc = "A powerful and precise weapon capable of dealing devastating damage.",
        materials = {
            { class = "craft_metal",   required = 10, name = "Metal" },
            { class = "craft_plastic", required = 5,  name = "Plastic" },
            { class = "craft_shutter", required = 1,  name = "Shutter" },
            { class = "craft_barrel",  required = 1,  name = "Barrel" },
            { class = "craft_handle",  required = 1,  name = "Handle" },
            { class = "craft_store",   required = 2,  name = "Magazine" }
        },
        result = "weapon_deagle2"
    },
    ["weapon_m42"] = {
        name = "M42",
        desc = "A modern weapon combining high reliability.",
        materials = {
            { class = "craft_metal",   required = 8,  name = "Metal" },
            { class = "craft_tree",    required = 4,  name = "Wood" },
            { class = "craft_shutter", required = 1,  name = "Shutter" },
            { class = "craft_barrel",  required = 1,  name = "Barrel" },
            { class = "craft_handle",  required = 1,  name = "Handle" },
            { class = "craft_store",   required = 2,  name = "Magazine" }
        },
        result = "weapon_m42"
    },

    ["weed_plant"] = {
        name = "My Box",
        desc = "Description of your item.",
        materials = {
            { class = "craft_tree",    required = 1, name = "Wood" },
            { class = "craft_metal",   required = 1, name = "Metal" },
        },
        result = "weed_plant",
        isEntity = true
    }
}
