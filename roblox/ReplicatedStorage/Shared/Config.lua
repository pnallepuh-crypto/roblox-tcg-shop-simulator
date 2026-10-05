local Config = {
    GameName = "Card Shop Simulator",
    StartingMoney = 250,
    StartingXP = 0,
    XPPerLevel = 120,
    LevelCap = 999,

    PackConfigs = {
        Starter = {
            Name = "Starter Pack",
            Cost = 25,
            RarityWeights = {
                Common = 0.74,
                Rare = 0.20,
                Epic = 0.05,
                Legendary = 0.01,
            }
        },
        Bronze = {
            Name = "Bronze Pack",
            Cost = 80,
            RarityWeights = {
                Common = 0.35,
                Rare = 0.42,
                Epic = 0.18,
                Legendary = 0.05,
            }
        },
        Gold = {
            Name = "Gold Pack",
            Cost = 180,
            RarityWeights = {
                Common = 0.15,
                Rare = 0.42,
                Epic = 0.32,
                Legendary = 0.11,
            }
        },
        Mythic = {
            Name = "Mythic Pack",
            Cost = 420,
            RarityWeights = {
                Common = 0.06,
                Rare = 0.26,
                Epic = 0.42,
                Legendary = 0.26,
            }
        }
    },

    SellMultiplier = 0.82,
    LeaderboardScoreScale = 1000,

    SoundIds = {
        Buy = "rbxassetid://0000000",
        OpenPack = "rbxassetid://0000000",
        Win = "rbxassetid://0000000",
        Lose = "rbxassetid://0000000",
        Music = "rbxassetid://0000000",
    },

    Colors = {
        Common = Color3.fromRGB(200, 200, 200),
        Rare = Color3.fromRGB(90, 160, 255),
        Epic = Color3.fromRGB(180, 100, 255),
        Legendary = Color3.fromRGB(255, 180, 60),
        Background = Color3.fromRGB(18, 22, 30),
        Panel = Color3.fromRGB(31, 37, 49),
        Accent = Color3.fromRGB(64, 200, 175),
        Warning = Color3.fromRGB(255, 120, 70),
        Text = Color3.fromRGB(245, 245, 245),
    },

    TutorialSteps = {
        "Welcome to Card Shop Simulator!",
        "Buy a pack to collect cards.",
        "Sell cards to earn money.",
        "Use the coinflip minigame to double your value.",
        "Level up to unlock higher tier packs!"
    }
}

return Config
