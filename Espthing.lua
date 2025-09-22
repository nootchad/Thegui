-- ESP Backend para Fortline
-- No crea GUI, solo aplica la configuración de getgenv().ESPSettings

-- Servidores
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuración ESP global
getgenv().ESPSettings = getgenv().ESPSettings or {
    ESPType = "Normal", -- "Normal" o "FamilyGuy"
    Box = false,
    Outline = false,
    HealthBar = false,
    Tracers = false,
    Chams = false
}

local ESPPlayers = {}

-- Cargar Twilight (ESP normal)
local Twilight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/twilight"))()
Twilight.Load()

-- Función para agregar imagen FamilyGuy
local function addESPImage(player)
    if ESPPlayers[player] then return end
    local char = player.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end
    if getgenv().ESPSettings.ESPType ~= "FamilyGuy" then return end

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
        if getgenv().ESPSettings.ESPType == "FamilyGuy" then
            addESPImage(player)
        else
            removeESPImage(player)
        end
    end)
end

-- Inicializar jugadores actuales
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        updatePlayerESP(player)
        task.wait(0.5)
        if getgenv().ESPSettings.ESPType == "FamilyGuy" then addESPImage(player) end
    end
end

-- Conectar nuevos jugadores
Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        updatePlayerESP(player)
        task.wait(0.5)
        if getgenv().ESPSettings.ESPType == "FamilyGuy" then addESPImage(player) end
    end
end)

-- Actualizar ESP cada frame según configuración
RunService.RenderStepped:Connect(function()
    Twilight.settings.boxEnabled = getgenv().ESPSettings.Box
    Twilight.settings.outlineBoxEnabled = getgenv().ESPSettings.Outline
    Twilight.settings.healthBarEnabled = getgenv().ESPSettings.HealthBar
    Twilight.settings.tracersEnabled = getgenv().ESPSettings.Tracers
    Twilight.settings.chamsEnabled = getgenv().ESPSettings.Chams

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            if getgenv().ESPSettings.ESPType == "FamilyGuy" then
                addESPImage(player)
            else
                removeESPImage(player)
            end
        end
    end
end)
