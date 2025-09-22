getgenv().NoAnticheatPresent = true
getgenv().InterfaceName = "Twilight ESP + Image"

local Twilight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/twilight"))()
Twilight.Load()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local imageUrls = {
    "https://qzin7brpptfttivm.public.blob.vercel-storage.com/1000195915-fotor-bg-remover-20250921172037.png",
    "https://qzin7brpptfttivm.public.blob.vercel-storage.com/1000195914-fotor-bg-remover-2025092117227.png"
}
local localFiles = {"image1.png","image2.png"}

for i, url in ipairs(imageUrls) do
    if not isfile(localFiles[i]) then
        local success, content = pcall(function() return game:HttpGet(url) end)
        if success then
            writefile(localFiles[i], content)
        end
    end
end

getgenv().ESPSettings = getgenv().ESPSettings or {
    TypeESP = "Normal",
    BoxEnabled = false,
    OutlineBoxEnabled = false,
    HealthBarEnabled = false,
    TracersEnabled = false,
    ChamsEnabled = false
}

local function addESPImage(player)
    local character = player.Character
    if not character then return end
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not torso then return end
    if torso:FindFirstChild("ESPGui") then torso.ESPGui:Destroy() end
    if getgenv().ESPSettings.TypeESP ~= "FamilyGuy" then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPGui"
    billboard.Size = UDim2.new(0,60,0,60)
    billboard.StudsOffset = Vector3.new(0,0,0)
    billboard.Adornee = torso
    billboard.AlwaysOnTop = true
    billboard.Parent = torso

    local imgLabel = Instance.new("ImageLabel")
    imgLabel.Size = UDim2.new(1,0,1,0)
    imgLabel.BackgroundTransparency = 1
    imgLabel.Image = getcustomasset(localFiles[1])
    imgLabel.ScaleType = Enum.ScaleType.Fit
    imgLabel.Parent = billboard
end

local function UpdateESP()
    Twilight.settings.boxEnabled = getgenv().ESPSettings.BoxEnabled
    Twilight.settings.outlineBoxEnabled = getgenv().ESPSettings.OutlineBoxEnabled
    Twilight.settings.healthBarEnabled = getgenv().ESPSettings.HealthBarEnabled
    Twilight.settings.tracersEnabled = getgenv().ESPSettings.TracersEnabled
    Twilight.settings.chamsEnabled = getgenv().ESPSettings.ChamsEnabled
    Twilight:EnablePlayerESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            addESPImage(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        addESPImage(player)
    end)
end)

UpdateESP()
