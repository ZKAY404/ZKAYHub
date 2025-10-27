local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "ZKAYHub-[🌱]Grow a Garden☘️[Freemium]",
    SubTitle = "by zkayreal",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-- Create ScreenGui in CoreGui for highest visibility
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "ToggleGui"
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.ResetOnSpawn = false
ToggleGui.DisplayOrder = 999999
ToggleGui.IgnoreGuiInset = true
ToggleGui.Parent = game:GetService("CoreGui")

-- Create circular ImageButton
local Toggle = Instance.new("ImageButton")
Toggle.Name = "Toggle"
Toggle.Parent = ToggleGui
Toggle.BackgroundTransparency = 1
Toggle.Position = UDim2.new(0, 10, 0.2, 0)
Toggle.Size = UDim2.new(0, 60, 0, 60) -- size of the circle
Toggle.Image = "rbxassetid://131658654015166"

-- Round it into a perfect circle using UICorner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- fully rounded
UICorner.Parent = Toggle
Toggle.MouseButton1Click:connect(function()
    local vim = game:service("VirtualInputManager")
    vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, nil)
    task.wait(0.1)
    vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, nil)
end)

-- Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Shop = Window:AddTab({
        Title = "Shop",
        Icon = ""
    }),
    Farming = Window:AddTab({
        Title = "Farming",
        Icon = ""
    }),
    Misc = Window:AddTab({
        Title = "Misc",
        Icon = ""
    }),
    Webhook = Window:AddTab({
        Title = "Tab Webhook",
        Icon = ""
    }),
    Info = Window:AddTab({
        Title = "Info Anh Join Server",
        Icon = ""
    })
}

local Options = Fluent.Options

do

    Tabs.Shop:AddSection("Merchant")

    local MerchantDropdown = Tabs.Shop:AddDropdown("MerchantDropdown", {
        Title = "Select Item Shop Merchant",
        Values = {"Prickly Pear Seed", "Cauliflower Seed", "Kiwi Seed", "Avocado Seed", "Bell Pepper Seed",
                  "Loquat Seed", "Pitcher Plant", "Green Apple Seed", "Feijoa Seed", "Pineapple Seed", "Rafflesia Seed",
                  "Banana Seed", "Mutation Spray Verdant", "Mutation Spray Wet", "Mutation Spray Disco",
                  "Mutation Spray Windstruck", "Flower Seed Pack", "Bee Egg", "Bee Crate", "Honey Sprinkler",
                  "Honey Crafters Crate", "Iconic Gnome Crate", "Common Gnome Crate", "Farmers Gnome Crate",
                  "Mutation Spray Cloudtouched", "Star Caller", "Night Staff", "Firework Flower", "Firework",
                  "July 4th Crate", "Bald Eagle", "Liberty Lily"},
        Multi = true,
        Default = {}
    })

    local MerchantToggle = Tabs.Shop:AddToggle("MerchantToggle", {
        Title = "Auto Buy Shop Merchant",
        Default = false
    })

    MerchantToggle:OnChanged(function()
        while Options.MerchantToggle.Value do
            local selectedMerchants = {}
            for merchantName, isSelected in pairs(Options.MerchantDropdown.Value) do
                if isSelected then
                    table.insert(selectedMerchants, merchantName)
                end
            end
            for _, merchant in ipairs(selectedMerchants) do
                local frame =
                    game:GetService("Players").LocalPlayer.PlayerGui.EventShop_UI.Frame.ScrollingFrame:FindFirstChild(
                        merchant)
                if frame and frame.Main_Frame and frame.Main_Frame.Stock_Text then
                    local stockText = frame.Main_Frame.Stock_Text.Text
                    local stock = tonumber(stockText:match("%d+")) or 0

                    if stock > 0 then
                        game:GetService("ReplicatedStorage").GameEvents.BuyTravelingMerchantStock:FireServer(merchant)
                    end
                end
            end
            task.wait(0.01) -- Cooldown between checks
        end
    end)

    Tabs.Shop:AddSection("Shop Beanstalk Event")

    local BeanDropdown = Tabs.Shop:AddDropdown("BeanDropdown", {
        Title = "Select Item Shop Beanstalk",
        Values = {"Bean Gnome Crate", "Beanflare", "Hot Spring", "Bean Seed Pack", "Bean Sand", "Bean Crate",
                  "Tranquil Radar", "Pet Shard Tranquil", "Bean Egg", "Spiked Mango", "Koi", "Soft Sunshine"},
        Multi = true,
        Default = {}
    })

    local BeanToggle = Tabs.Shop:AddToggle("BeanToggle", {
        Title = "Auto Buy Shop Bean",
        Default = false
    })

    BeanToggle:OnChanged(function()
        while Options.BeanToggle.Value do
            local selectedBeans = {}
            for beanName, isSelected in pairs(Options.BeanDropdown.Value) do
                if isSelected then
                    table.insert(selectedBeans, beanName)
                end
            end
            for _, bean in ipairs(selectedBeans) do
                local frame =
                    game:GetService("Players").LocalPlayer.PlayerGui.EventShop_UI.Frame.ScrollingFrame:FindFirstChild(
                        bean)
                if frame and frame.Main_Frame and frame.Main_Frame.Stock_Text then
                    local stockText = frame.Main_Frame.Stock_Text.Text
                    local stock = tonumber(stockText:match("%d+")) or 0

                    if stock > 0 then
                        game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock:FireServer(bean)
                    end
                end
            end
            task.wait(0.01) -- Cooldown between checks
        end
    end)

    Tabs.Shop:AddSection("Shop Seeds")

    local SeedsDropdown = Tabs.Shop:AddDropdown("SeedsDropdown", {
        Title = "Select Seed",
        Values = {"Carrot Seed", "Strawberry Seed", "Blueberry Seed", "Orange Tulip", "Tomato Seed", "Corn Seed",
                  "Daffodil Seed", "Watermelon Seed", "Pumpkin Seed", "Apple Seed", "Bamboo Seed", "Coconut Seed",
                  "Cactus Seed", "Dragon Fruit Seed", "Mango Seed", "Grape Seed", "Mushroom Seed", "Pepper Seed",
                  "Cacao Seed", "Beanstalk Seed", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone Seed"},
        Multi = true,
        Default = {}
    })

    local SeedsToggle = Tabs.Shop:AddToggle("SeedsToggle", {
        Title = "Auto Buy Seed",
        Default = false
    })

    SeedsToggle:OnChanged(function()
        while Options.SeedsToggle.Value do
            local selectedSeeds = {}
            for seedName, isSelected in pairs(Options.SeedsDropdown.Value) do
                if isSelected then
                    table.insert(selectedSeeds, seedName)
                end
            end
            for _, seed in ipairs(selectedSeeds) do
                local cleanName = seed:gsub(" Seed$", "")
                local frame =
                    game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.ScrollingFrame:FindFirstChild(
                        cleanName)
                if frame and frame.Main_Frame and frame.Main_Frame.Stock_Text then
                    local stockText = frame.Main_Frame.Stock_Text.Text
                    local stock = tonumber(stockText:match("%d+")) or 0

                    if stock > 0 then
                        game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(cleanName)
                    end
                end
            end
            task.wait(0.01) -- Cooldown between checks
        end
    end)

    Tabs.Shop:AddSection("Shop Gears")

    local GearsDropdown = Tabs.Shop:AddDropdown("GearsDropdown", {
        Title = "Select Gear",
        Values = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Medium Toy",
                  "Medium Treat", "Godly Sprinkler", "Magnifying Glass", "Tanning Mirror", "Master Sprinkler",
                  "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot", "Levelup Lollipop"},
        Multi = true,
        Default = {}
    })

    local GearsToggle = Tabs.Shop:AddToggle("GearsToggle", {
        Title = "Auto Buy Gear",
        Default = false
    })

    GearsToggle:OnChanged(function()
        while Options.GearsToggle.Value do
            local selectedGears = {}
            for gearName, isSelected in pairs(Options.GearsDropdown.Value) do
                if isSelected then
                    table.insert(selectedGears, gearName)
                end
            end
            for _, gear in ipairs(selectedGears) do
                local frame =
                    game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Frame.ScrollingFrame:FindFirstChild(gear)
                if frame and frame.Main_Frame and frame.Main_Frame.Stock_Text then
                    local stockText = frame.Main_Frame.Stock_Text.Text
                    local stock = tonumber(stockText:match("%d+")) or 0

                    if stock > 0 then
                        game:GetService("ReplicatedStorage").GameEvents.BuyGearStock:FireServer(gear)
                    end
                end
            end
            task.wait(0.01) -- Cooldown between checks
        end
    end)

    Tabs.Shop:AddSection("Shop Eggs")

    local EggsDropdown = Tabs.Shop:AddDropdown("EggsDropdown", {
        Title = "Select Egg",
        Values = {"Common Egg", "Common Summer Egg", "Rare Summer Egg", "Mythical Egg", "Paradise Egg", "Bug Egg"},
        Multi = true,
        Default = {}
    })

    local EggsToggle = Tabs.Shop:AddToggle("EggsToggle", {
        Title = "Auto Buy Egg",
        Default = false
    })

    EggsToggle:OnChanged(function()
        while Options.EggsToggle.Value do
            local selectedEggs = {}
            for eggName, isSelected in pairs(Options.EggsDropdown.Value) do
                if isSelected then
                    table.insert(selectedEggs, eggName)
                end
            end
            for _, egg in ipairs(selectedEggs) do
                local frame =
                    game:GetService("Players").LocalPlayer.PlayerGui.PetShop_UI.Frame.ScrollingFrame:FindFirstChild(egg)
                if frame and frame.Main_Frame and frame.Main_Frame.Stock_Text then
                    local stockText = frame.Main_Frame.Stock_Text.Text
                    local stock = tonumber(stockText:match("%d+")) or 0

                    if stock > 0 then
                        game:GetService("ReplicatedStorage").GameEvents.BuyPetEgg:FireServer(egg)
                    end
                end
            end
            task.wait(0.01) -- Cooldown between checks
        end
    end)

    Tabs.Farming:AddSection("Auto Collect")

    Tabs.Farming:AddParagraph({
        Title = "About Select Method:",
        Content = "Auto Collect will ignore what u have choosen"
    })

    local MutationDropdown = Tabs.Farming:AddDropdown("MutationDropdown", {
        Title = "Select Mutation",
        Values = {"Wet", "Windstruck", "Moonlit", "Chilled", "Choc", "Pollinated", "Sandy", "Clay", "Verdant", "Bloodlit", "Twisted", "Drenched", "HoneyGlazed",
        "Cloudtouched", "Frobean", "Tempestuous", "Aurora", "Shocked", "Celestial", "Dawnbound", "Burnt", "Wiltproof", "Plasma", "Heavenly", "Fried", "Amber",
        "Cooked", "Toxic", "Chakra", "Eclipsed", "Tranquil", "OldAmber", "Zombified", "Molten", "Ceramic", "Enlightened", "AncientAmber", "Friendbound",
        "Infected", "Radioactive", "Sundried", "FoxfireChakra", "Paradisal", "Alienlike", "Galactic", "Disco", "Meteoric", "Voidtouched"},
        Multi = true,
        Default = {}
    })

    local VariantDropdown = Tabs.Farming:AddDropdown("VariantDropdown", {
        Title = "Select Variant",
        Values = {"Gold", "Rainbow"},
        Multi = true,
        Default = {}
    })

    local FruitDropdown = Tabs.Farming:AddDropdown("FruitDropdown", {
        Title = "Select Fruit",
        Values = {"Carrot", "Strawberry", "Pink Tulip", "Chocolate Carrot",
        "Blueberry", "Rose", "Orange Tulip", "Monoblooma", "Red Lollipop", "Nightshade", "Crocus", "Lavender", "Manuka Flower", "Wild Carrot", "Blue Lollipop", "Stonebite",
        "Tomato", "Daffodil", "Cauliflower", "Raspberry", "Foxglove", "Peace Lily", "Corn", "Horsetail", "Beanflare", "Serenity", "Candy Sunflower", "Mint", "Glowshroom", "Dandelion", "Nectarshade", "Succulent", "Bee Balm", "Pear", "Delphinium", "Liberty Lily", "Noble Flower", "Paradise Petal",
        "Watermelon", "Pumpkin", "Avocado", "Green Apple", "Apple", "Banana", "Lilac", "Taro Flower", "Bamboo", "Rafflesia", "Lingonberry", "Soft Sunshine", "Cranberry", "Durian", "Papaya", "Moonflower", "Starfruit", "Lumira", "Violet Corn", "Nectar Thorn", "Cantaloupe", "Aloe Vera", "Firework Flower", "Dragon Sapling", "Horned Dinoshroom", "Boneboo",
        "Peach", "Pineapple", "Amber Spine", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Kiwi", "Bell Pepper", "Prickly Pear", "Pink Lily", "Purple Dahlia", "Hinomai", "Bean Rocks", "Spiked Mango", "Easter Egg", "Eggplant", "Passionfruit", "Lemon", "Moonglow", "Moon Melon", "Blood Banana", "Celestiberry", "Guanabana", "Nectarine", "Honeysuckle", "Suncoil", "Bendboo", "Cocovine", "Parasol Flower", "Lily Of The Valley", "Firefly Fern", "Moon Mango",
        "Grape", "Loquat", "Mushroom", "Pepper", "Cacao", "Feijoa", "Pitcher Plant", "Grand Volcania", "Sunflower", "Maple Apple", "Candy Blossom", "Cherry Blossom", "Crimson Vine", "Lotus", "Venus Fly Trap", "Cursed Fruit", "Soul Fruit", "Mega Mushroom", "Moon Blossom", "Hive Fruit", "Dragon Pepper", "Rosy Delight", "Traveler's Fruit", "Fossilight",
        "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elephant Ears",
        "Bone Blossom"},
        Multi = true,
        Default = {}
    })

    local WeatherCollect = Tabs.Farming:AddToggle("WeatherCollect", {
        Title = "Collect during weather events",
        Default = false
    })

    local AutoCollect = Tabs.Farming:AddToggle("AutoCollect", {
        Title = "Auto Collect",
        Default = false
    })

    AutoCollect:OnChanged(function()
        if not Options.AutoCollect.Value then return end

        task.spawn(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            local function isWeatherActive()
                local ui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Bottom_UI")
                local list = ui and ui:FindFirstChild("BottomFrame") and ui.BottomFrame:FindFirstChild("Holder") and ui.BottomFrame.Holder:FindFirstChild("List")
                if not list then return false end

                for _, child in ipairs(list:GetChildren()) do
                    if child:IsA("UIListLayout") then continue end
                    if child:IsA("GuiObject") and (child.Visible or child.Active) then
                        return true
                    end
                end
                return false
            end

            local function countKG()
                local total = 0
                for _, src in ipairs({LocalPlayer:FindFirstChild("Backpack"), workspace:FindFirstChild("ZKAY404ERROR")}) do
                    if src then
                        for _, item in ipairs(src:GetChildren()) do
                            if item:IsA("Tool") and item.Name:find("kg") then
                                total += 1
                            end
                        end
                    end
                end
                return total
            end

            local function getMyFarm()
                local farms = workspace:FindFirstChild("Farm")
                if not farms then return nil end
                for _, f in ipairs(farms:GetChildren()) do
                    local owner = f:FindFirstChild("Important") and f.Important:FindFirstChild("Data") and f.Important.Data:FindFirstChild("Owner")
                    if owner and owner.Value == LocalPlayer.Name then
                        return f
                    end
                end
            end

            local function toSet(m)
                local set = {}
                for k, v in pairs(m or {}) do
                    if v then set[k] = true end
                end
                return set
            end

            local function passBlacklist(val, set)
                if not set or next(set) == nil then return true end
                return not set[val]
            end

            local function passMutationBlacklist(inst, set)
                if not set or next(set) == nil then return true end
                for mutName in pairs(set) do
                    if inst:GetAttribute(mutName) == true then
                        return false
                    end
                end
                return true
            end

            local function passesFilter(inst)
                local fruitSet = toSet(Options.FruitDropdown.Value)
                local variantSet = toSet(Options.VariantDropdown.Value)
                local mutationSet = toSet(Options.MutationDropdown.Value)

                local fruitName = inst.Name
                local variantVal = inst:FindFirstChild("Variant") and inst.Variant.Value or nil

                return passBlacklist(fruitName, fruitSet)
                    and passBlacklist(variantVal, variantSet)
                    and passMutationBlacklist(inst, mutationSet)
            end

            while Options.AutoCollect.Value do
                if not Options.WeatherCollect.Value and isWeatherActive() then
                    task.wait(0.5)
                    continue
                end

                if countKG() >= 200 then
                    task.wait(0.5)
                    continue
                end

                local farm = getMyFarm()
                if not farm then
                    task.wait(0.5)
                    continue
                end

                local phys = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Plants_Physical")
                if not phys then
                    task.wait(0.5)
                    continue
                end

                for _, plant in ipairs(phys:GetChildren()) do
                    if countKG() >= 200 then break end

                    local targets = {}
                    local fruitsFolder = plant:FindFirstChild("Fruits")
                    if fruitsFolder and #fruitsFolder:GetChildren() > 0 then
                        for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                            table.insert(targets, fruit)
                        end
                    else
                        table.insert(targets, plant)
                    end

                    for _, inst in ipairs(targets) do
                        if countKG() >= 200 then break end
                        if not passesFilter(inst) then continue end
                        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Crops"):WaitForChild("Collect"):FireServer({inst})
                        task.wait(0.1)
                    end
                end
            end
        end)
    end)

    Tabs.Farming:AddSection("Sell")

    local InputSlot = Tabs.Farming:AddInput("InputSlot", {
        Title = "Amount Fruit To Sell",
        Default = "200",
    })

    local AutoSell = Tabs.Farming:AddToggle("AutoSell", {
        Title = "Auto Sell",
        Default = false,
    })

    AutoSell:OnChanged(function()
        while Options.AutoSell.Value do
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local HRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not HRP then return end
            local function countKG()
                local total = 0
                for _, src in ipairs({LocalPlayer:FindFirstChild("Backpack"), workspace:FindFirstChild(LocalPlayer.Name)}) do
                    if src then
                        for _, item in ipairs(src:GetChildren()) do
                            if item:IsA("Tool") and item.Name:find("kg") then
                                total += 1
                            end
                        end
                    end
                end
                return total
            end
            if countKG() >= 200 then
                HRP.CFrame = workspace.NPCS.Steven.HumanoidRootPart.CFrame
                game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
                task.wait(1)
            end
        end
    end)
end

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("ZKAYHub")
SaveManager:SetFolder("ZKAYHub")

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
local player = game:GetService("Players").LocalPlayer
local username = player.Name
SaveManager:Load(username .. "-GAG")

Fluent:Notify({
    Title = "Notification",
    Content = "ZKAYHub Loaded Successfully!",
    SubContent = "Enjoy using the hub ♡!",
    Duration = 8
})

while true do
    local result
    local success, err = pcall(function()
        result = SaveManager:Save(username .. "-GAG")
    end)
    
    if not success then
        warn("Auto-save failed:", result)
    end
    
    task.wait(1) -- Wait exactly 1 second between saves

end

