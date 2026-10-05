local CardData = {
    Cards = {
        {id = "c_1", name = "Copper Goblin", rarity = "Common", value = 8, color = Color3.fromRGB(180, 180, 180), pack = "Starter"},
        {id = "c_2", name = "Dusty Knight", rarity = "Common", value = 10, color = Color3.fromRGB(180, 180, 180), pack = "Starter"},
        {id = "c_3", name = "Lantern Fairy", rarity = "Common", value = 12, color = Color3.fromRGB(180, 180, 180), pack = "Starter"},
        {id = "c_4", name = "Gravel Peddler", rarity = "Common", value = 14, color = Color3.fromRGB(180, 180, 180), pack = "Starter"},

        {id = "r_1", name = "Silver Fox", rarity = "Rare", value = 28, color = Color3.fromRGB(90, 160, 255), pack = "Bronze"},
        {id = "r_2", name = "Moon Mage", rarity = "Rare", value = 34, color = Color3.fromRGB(90, 160, 255), pack = "Bronze"},
        {id = "r_3", name = "Cinder Archer", rarity = "Rare", value = 36, color = Color3.fromRGB(90, 160, 255), pack = "Bronze"},
        {id = "r_4", name = "Sun Petal", rarity = "Rare", value = 42, color = Color3.fromRGB(90, 160, 255), pack = "Bronze"},

        {id = "e_1", name = "Dawnblade Paladin", rarity = "Epic", value = 75, color = Color3.fromRGB(180, 100, 255), pack = "Gold"},
        {id = "e_2", name = "Storm Weaver", rarity = "Epic", value = 86, color = Color3.fromRGB(180, 100, 255), pack = "Gold"},
        {id = "e_3", name = "Crystal Beast", rarity = "Epic", value = 98, color = Color3.fromRGB(180, 100, 255), pack = "Gold"},
        {id = "e_4", name = "Ember Seraph", rarity = "Epic", value = 110, color = Color3.fromRGB(180, 100, 255), pack = "Gold"},

        {id = "l_1", name = "Titan of the Hollow", rarity = "Legendary", value = 200, color = Color3.fromRGB(255, 180, 60), pack = "Mythic"},
        {id = "l_2", name = "Eclipse Oracle", rarity = "Legendary", value = 225, color = Color3.fromRGB(255, 180, 60), pack = "Mythic"},
        {id = "l_3", name = "Godfall Dragon", rarity = "Legendary", value = 260, color = Color3.fromRGB(255, 180, 60), pack = "Mythic"},
        {id = "l_4", name = "Astra Crown", rarity = "Legendary", value = 320, color = Color3.fromRGB(255, 180, 60), pack = "Mythic"},

        {id = "l_5", name = "Golden Petal Queen", rarity = "Legendary", value = 370, color = Color3.fromRGB(255, 180, 60), pack = "Mythic"},
        {id = "r_5", name = "River Runner", rarity = "Rare", value = 52, color = Color3.fromRGB(90, 160, 255), pack = "Bronze"},
        {id = "e_5", name = "Velvet Warden", rarity = "Epic", value = 125, color = Color3.fromRGB(180, 100, 255), pack = "Gold"},
        {id = "c_5", name = "Copper Courier", rarity = "Common", value = 16, color = Color3.fromRGB(180, 180, 180), pack = "Starter"},
    },

    PackPools = {
        Starter = {
            "c_1", "c_2", "c_3", "c_4", "c_5",
            "r_1", "r_2", "r_3"
        },
        Bronze = {
            "c_1", "c_2", "c_3", "c_4", "c_5",
            "r_1", "r_2", "r_3", "r_4", "r_5"
        },
        Gold = {
            "r_1", "r_2", "r_3", "r_4", "r_5",
            "e_1", "e_2", "e_3", "e_4", "e_5"
        },
        Mythic = {
            "e_1", "e_2", "e_3", "e_4", "e_5",
            "l_1", "l_2", "l_3", "l_4", "l_5"
        }
    },

    RarityTable = {
        Common = 0.65,
        Rare = 0.25,
        Epic = 0.08,
        Legendary = 0.02,
    }
}

return CardData
