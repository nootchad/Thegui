local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local folderName = "Hesiz Fortile"
local espConfigFile = folderName.."/config/esp.json"

-- Crea la carpeta y el archivo si no existen
if not isfolder(folderName) then makefolder(folderName) end
if not isfolder(folderName.."/config") then makefolder(folderName.."/config") end
if not isfile(espConfigFile) then
    writefile(espConfigFile, HttpService:JSONEncode({
        ESPType = "Normal",
        Box = false,
        Outline = false,
        HealthBar = false,
        Tracers = false,
        Chams = false
    }))
end

-- Twilight ESP
local Twilight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/twilight"))()
Twilight.Load()

local ESPPlayers = {}

local function addESPImage(player)
    if ESPPlayers[player] then return end
    local char = player.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end
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
    imgLabel.Image = getcustomasset("image1.png")
    imgLabel.ScaleType = Enum.ScaleType.Fit
    imgLabel.Parent = billboard
    ESPPlayers[player] = billboard
end

local function removeESPImage(player)
    if ESPPlayers[player] then
        ESPPlayers[player]:Destroy()
        ESPPlayers[player] = nil
    end
end

local function updatePlayerESP(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        local cfg = HttpService:JSONDecode(readfile(espConfigFile))
        if cfg.ESPType == "FamilyGuy" then addESPImage(player) else removeESPImage(player) end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        updatePlayerESP(player)
        task.wait(0.5)
        local cfg = HttpService:JSONDecode(readfile(espConfigFile))
        if cfg.ESPType == "FamilyGuy" then addESPImage(player) end
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        updatePlayerESP(player)
        task.wait(0.5)
        local cfg = HttpService:JSONDecode(readfile(espConfigFile))
        if cfg.ESPType == "FamilyGuy" then addESPImage(player) end
    end
end)

-- Actualiza ESP cada frame leyendo esp.json
RunService.RenderStepped:Connect(function()
    local cfg = HttpService:JSONDecode(readfile(espConfigFile))
    Twilight.settings.boxEnabled = cfg.Box
    Twilight.settings.outlineBoxEnabled = cfg.Outline
    Twilight.settings.healthBarEnabled = cfg.HealthBar
    Twilight.settings.tracersEnabled = cfg.Tracers
    Twilight.settings.chamsEnabled = cfg.Chams

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            if cfg.ESPType == "FamilyGuy" then addESPImage(player) else removeESPImage(player) end
        end
    end
end)
