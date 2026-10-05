local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shared = ReplicatedStorage:WaitForChild("Shared")
local config = require(shared:WaitForChild("Config"))

local remotes = ReplicatedStorage:WaitForChild("CardShopRemotes")
local stateEvent = remotes:WaitForChild("StateEvent")
local resultEvent = remotes:WaitForChild("ResultEvent")
local toastEvent = remotes:WaitForChild("ToastEvent")

local uiState = {
    cards = {},
    money = 0,
    level = 1,
    xp = 0,
    tutorialSeen = false,
    stats = {},
    settings = {
        music = true,
        sound = true,
    },
}

local selectionSet = {}
local selectedPack = "Starter"

local function round(num, digits)
    local mult = 10 ^ (digits or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function create(instanceType, props)
    local instance = Instance.new(instanceType)
    for key, value in pairs(props) do
        instance[key] = value
    end
    return instance
end

local function playSound(soundId, volume)
    if not soundId or soundId == "rbxassetid://0000000" then
        return
    end

    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound.Parent = SoundService
    sound:Play()
    task.delay(2, function()
        if sound.Parent then
            sound:Destroy()
        end
    end)
end

local function makeButton(parent, text, size, pos, callback, color)
    local button = create("TextButton", {
        Parent = parent,
        Size = size,
        Position = pos,
        BackgroundColor3 = color or config.Colors.Accent,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = text,
        TextColor3 = config.Colors.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextWrapped = true,
        CornerRadius = UDim.new(0, 10),
    })

    local stroke = create("UIStroke", {
        Parent = button,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.35,
    })

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

local function buildUI()
    local gui = create("ScreenGui", {
        Name = "CardShopGui",
        Parent = playerGui,
        ResetOnSpawn = false,
    })

    local loading = create("Frame", {
        Parent = gui,
        Name = "LoadingScreen",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = config.Colors.Background,
        BorderSizePixel = 0,
    })

    local title = create("TextLabel", {
        Parent = loading,
        Size = UDim2.new(1, 0, 0.2, 0),
        Position = UDim2.new(0, 0, 0.25, 0),
        BackgroundTransparency = 1,
        Text = config.GameName,
        TextColor3 = config.Colors.Text,
        Font = Enum.Font.GothamBlack,
        TextSize = 42,
        TextScaled = true,
        Alignment = Enum.TextXAlignment.Center,
    })

    local loadingBar = create("Frame", {
        Parent = loading,
        Size = UDim2.new(0.5, 0, 0.04, 0),
        Position = UDim2.new(0.25, 0, 0.56, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
    })

    local loadingBarFill = create("Frame", {
        Parent = loadingBar,
        Size = UDim2.new(0.4, 0, 1, 0),
        BackgroundColor3 = config.Colors.Accent,
        BorderSizePixel = 0,
    })

    local tween = TweenService:Create(loadingBarFill, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()

    task.delay(1.5, function()
        loading:TweenPosition(UDim2.new(-1, 0, 0, 0), "Out", "Quad", 0.4)
        task.delay(0.5, function()
            loading:Destroy()
        end)
    end)

    local root = create("Frame", {
        Parent = gui,
        Name = "Root",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = config.Colors.Background,
        BorderSizePixel = 0,
    })

    local header = create("Frame", {
        Parent = root,
        Size = UDim2.new(1, 0, 0.12, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = config.Colors.Panel,
        BorderSizePixel = 0,
    })

    local moneyText = create("TextLabel", {
        Parent = header,
        Size = UDim2.new(0.3, 0, 0.6, 0),
        Position = UDim2.new(0.03, 0, 0.2, 0),
        BackgroundTransparency = 1,
        Text = "Money: $0",
        TextColor3 = config.Colors.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local xpText = create("TextLabel", {
        Parent = header,
        Size = UDim2.new(0.35, 0, 0.6, 0),
        Position = UDim2.new(0.34, 0, 0.2, 0),
        BackgroundTransparency = 1,
        Text = "Level 1",
        TextColor3 = config.Colors.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local coinflipButton = makeButton(header, "Coin Flip", UDim2.new(0.12, 0, 0.5, 0), UDim2.new(0.8, 0, 0.25, 0), function()
        local side = math.random(1, 2) == 1 and "Heads" or "Tails"
        local bet = math.floor(uiState.money * 0.1)
        if bet <= 0 then bet = 10 end
        remotes:WaitForChild("ResultEvent"):FireServer("CoinFlip", { side = side, betAmount = bet })
    end, config.Colors.Warning)

    local leftPanel = create("Frame", {
        Parent = root,
        Size = UDim2.new(0.45, 0, 0.8, 0),
        Position = UDim2.new(0.04, 0, 0.16, 0),
        BackgroundColor3 = config.Colors.Panel,
        BorderSizePixel = 0,
    })

    local rightPanel = create("Frame", {
        Parent = root,
        Size = UDim2.new(0.47, 0, 0.8, 0),
        Position = UDim2.new(0.51, 0, 0.16, 0),
        BackgroundColor3 = config.Colors.Panel,
        BorderSizePixel = 0,
    })

    local shopLabel = create("TextLabel", {
        Parent = leftPanel,
        Size = UDim2.new(1, -20, 0.07, 0),
        Position = UDim2.new(0, 10, 0.02, 0),
        BackgroundTransparency = 1,
        Text = "Shop",
        TextColor3 = config.Colors.Text,
        Font = Enum.Font.GothamBlack,
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local packList = create("Frame", {
        Parent = leftPanel,
        Size = UDim2.new(1, -20, 0.55, 0),
        Position = UDim2.new(0, 10, 0.12, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })

    local function createPackButton(packName, cost)
        local btn = makeButton(packList, packName .. " - $" .. cost, UDim2.new(0.46, -8, 0.18, 0), UDim2.new(0, 0, 0, 0), function()
            selectedPack = packName
            remotes:WaitForChild("ResultEvent"):FireServer("OpenPack", packName)
            playSound(config.SoundIds.OpenPack, 0.5)
        end, config.Colors.Accent)
        return btn
    end

    local packButtonPositions = {
        {"Starter", 25, UDim2.new(0, 0, 0, 0)},
        {"Bronze", 80, UDim2.new(0.5, 0, 0, 0)},
        {"Gold", 180, UDim2.new(0, 0, 0.22, 0)},
        {"Mythic", 420, UDim2.new(0.5, 0, 0.22, 0)},
    }

    for _, pack in ipairs(packButtonPositions) do
        local name, cost, pos = unpack(pack)
        local btn = createPackButton(name, cost)
        btn.Position = pos
    end

    local inventoryLabel = create("TextLabel", {
        Parent = rightPanel,
        Size = UDim2.new(1, -20, 0.07, 0),
        Position = UDim2.new(0, 10, 0.02, 0),
        BackgroundTransparency = 1,
        Text = "Inventory",
        TextColor3 = config.Colors.Text,
        Font = Enum.Font.GothamBlack,
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local inventoryScroll = create("ScrollingFrame", {
        Parent = rightPanel,
        Size = UDim2.new(1, -20, 0.52, 0),
        Position = UDim2.new(0, 10, 0.12, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 6,
    })

    local sellButton = makeButton(rightPanel, "Sell Selected", UDim2.new(0.42, 0, 0.09, 0), UDim2.new(0.04, 0, 0.72, 0), function()
        local selectedList = {}
        for key, value in pairs(selectionSet) do
            if value then
                table.insert(selectedList, key)
            end
        end
        remotes:WaitForChild("ResultEvent"):FireServer("SellSelected", selectedList)
        playSound(config.SoundIds.Buy, 0.4)
    end, config.Colors.Warning)

    local selectAllButton = makeButton(rightPanel, "Select All", UDim2.new(0.42, 0, 0.09, 0), UDim2.new(0.52, 0, 0.72, 0), function()
        if next(uiState.cards) == nil then
            return
        end

        for cardId, _ in pairs(uiState.cards) do
            selectionSet[cardId] = true
        end
        renderInventory()
    end, config.Colors.Accent)

    local tutorialFrame = create("Frame", {
        Parent = gui,
        Name = "Tutorial",
        Size = UDim2.new(0.45, 0, 0.4, 0),
        Position = UDim2.new(0.275, 0, 0.28, 0),
        BackgroundColor3 = config.Colors.Panel,
        BorderSizePixel = 0,
        Visible = false,
    })

    local tutorialTitle = create("TextLabel", {
        Parent = tutorialFrame,
        Size = UDim2.new(1, -20, 0.18, 0),
        Position = UDim2.new(0, 10, 0.04, 0),
        BackgroundTransparency = 1,
        Text = "Quick Tutorial",
        TextColor3 = config.Colors.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 24,
    })

    local tutorialText = create("TextLabel", {
        Parent = tutorialFrame,
        Size = UDim2.new(1, -20, 0.45, 0),
        Position = UDim2.new(0, 10, 0.22, 0),
        BackgroundTransparency = 1,
        Text = config.TutorialSteps[1],
        TextColor3 = config.Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextWrapped = true,
    })

    local tutorialNext = makeButton(tutorialFrame, "Next", UDim2.new(0.28, 0, 0.14, 0), UDim2.new(0.36, 0, 0.78, 0), function()
        if uiState.tutorialIndex == nil then
            uiState.tutorialIndex = 1
        end

        uiState.tutorialIndex = (uiState.tutorialIndex % #config.TutorialSteps) + 1
        tutorialText.Text = config.TutorialSteps[uiState.tutorialIndex]
    end, config.Colors.Accent)

    local tutorialClose = makeButton(tutorialFrame, "Close", UDim2.new(0.18, 0, 0.14, 0), UDim2.new(0.7, 0, 0.78, 0), function()
        tutorialFrame.Visible = false
        remotes:WaitForChild("ResultEvent"):FireServer("TutorialSeen", true)
    end, config.Colors.Warning)

    local function renderInventory()
        for _, child in ipairs(inventoryScroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local index = 0
        local cardOrder = {}
        for cardId, count in pairs(uiState.cards) do
            table.insert(cardOrder, { cardId = cardId, count = count })
        end

        table.sort(cardOrder, function(a, b)
            return a.cardId < b.cardId
        end)

        for _, entry in ipairs(cardOrder) do
            local cardId = entry.cardId
            local count = entry.count
            local card = require(shared:WaitForChild("CardData")).Cards[1]
            for _, c in ipairs(require(shared:WaitForChild("CardData")).Cards) do
                if c.id == cardId then
                    card = c
                    break
                end
            end

            local cardFrame = create("Frame", {
                Parent = inventoryScroll,
                Size = UDim2.new(1, -10, 0, 70),
                Position = UDim2.new(0, 5, 0, index * 76),
                BackgroundColor3 = card.color,
                BorderSizePixel = 0,
            })

            local cardLabel = create("TextLabel", {
                Parent = cardFrame,
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0.05, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = card.name .. " x" .. count,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local selectionButton = create("TextButton", {
                Parent = cardFrame,
                Size = UDim2.new(0.16, 0, 0.42, 0),
                Position = UDim2.new(0.75, 0, 0.3, 0),
                BackgroundColor3 = selectionSet[cardId] and Color3.fromRGB(60, 225, 140) or Color3.fromRGB(120, 120, 120),
                BorderSizePixel = 0,
                Text = selectionSet[cardId] and "On" or "Off",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
            })

            selectionButton.MouseButton1Click:Connect(function()
                selectionSet[cardId] = not selectionSet[cardId]
                selectionButton.Text = selectionSet[cardId] and "On" or "Off"
                selectionButton.BackgroundColor3 = selectionSet[cardId] and Color3.fromRGB(60, 225, 140) or Color3.fromRGB(120, 120, 120)
            end)

            index = index + 1
        end

        inventoryScroll.CanvasSize = UDim2.new(0, 0, 0, index * 76)
    end

    local function updateHud()
        moneyText.Text = "Money: $" .. tostring(math.floor(uiState.money or 0))
        xpText.Text = "Level " .. tostring(uiState.level or 1) .. " | XP " .. tostring(uiState.xp or 0)
        if not uiState.tutorialSeen then
            tutorialFrame.Visible = true
            tutorialText.Text = config.TutorialSteps[1]
            uiState.tutorialIndex = 1
        end
    end

    stateEvent.OnClientEvent:Connect(function(data)
        uiState = data or uiState
        selectionSet = {}
        renderInventory()
        updateHud()
    end)

    toastEvent.OnClientEvent:Connect(function(text)
        local toast = create("TextLabel", {
            Parent = gui,
            Size = UDim2.new(0.3, 0, 0.06, 0),
            Position = UDim2.new(0.35, 0, 0.8, 0),
            BackgroundColor3 = config.Colors.Panel,
            BorderSizePixel = 0,
            Text = tostring(text),
            TextColor3 = config.Colors.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            Visible = true,
        })

        toast:TweenPosition(UDim2.new(0.35, 0, 0.76, 0), "Out", "Sine", 0.18)
        task.delay(1.8, function()
            toast:Destroy()
        end)
    end)

    resultEvent.OnClientEvent:Connect(function(payload)
        if payload.resultType == "pack" then
            local card = payload.card
            local message = "Opened " .. payload.packType .. " pack! You got " .. card.name .. " (" .. card.rarity .. ")"
            toastEvent:FireServer(message)
            playSound(config.SoundIds.OpenPack, 0.6)
        elseif payload.resultType == "sell" then
            playSound(config.SoundIds.Buy, 0.5)
        elseif payload.resultType == "coinflip" then
            if payload.win then
                playSound(config.SoundIds.Win, 0.7)
            else
                playSound(config.SoundIds.Lose, 0.7)
            end
        end
    end)

    updateHud()
    return gui
end

buildUI()
stateEvent:FireServer()

if config.SoundIds.Music and config.SoundIds.Music ~= "rbxassetid://0000000" then
    local music = Instance.new("Sound")
    music.SoundId = config.SoundIds.Music
    music.Volume = 0.25
    music.Looped = true
    music.Parent = SoundService
    music:Play()
end
