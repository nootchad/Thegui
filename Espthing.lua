-- ESP Script completo para GitHub

-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuración global
getgenv().ESPSettings = getgenv().ESPSettings or {
    ESPType = "Normal",
    Box = false,
    Outline = false,
    HealthBar = false,
    Tracers = false,
    Chams = false
}

local ESPPlayers = {}
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

-- Función para remover imagen FamilyGuy
local function removeESPImage(player)
    if ESPPlayers[player] then
        ESPPlayers[player]:Destroy()
        ESPPlayers[player] = nil
    end
end

-- Conecta eventos de respawn de jugador
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

-- Inicializa ESP para todos los jugadores actuales
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        updatePlayerESP(player)
        task.wait(0.5)
        if getgenv().ESPSettings.ESPType == "FamilyGuy" then
            addESPImage(player)
        end
    end
end

-- Evento para jugadores que se unan
Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        updatePlayerESP(player)
        task.wait(0.5)
        if getgenv().ESPSettings.ESPType == "FamilyGuy" then
            addESPImage(player)
        end
    end
end)

-- Actualiza ESP cada frame
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

-- Integración con Luna GUI
if not TabPVP then return end -- Asegura que TabPVP exista

local PVPSection = TabPVP:CreateSection("ESP Settings")

PVPSection:CreateButton({
    Name="Family Guy ESP",
    Callback=function() getgenv().ESPSettings.ESPType="FamilyGuy" end
})

PVPSection:CreateButton({
    Name="Normal ESP",
    Callback=function() getgenv().ESPSettings.ESPType="Normal" end
})

PVPSection:CreateToggle({Name="Box ESP",CurrentValue=false,Callback=function(v) getgenv().ESPSettings.Box=v end})
PVPSection:CreateToggle({Name="Outline ESP",CurrentValue=false,Callback=function(v) getgenv().ESPSettings.Outline=v end})
PVPSection:CreateToggle({Name="Health Bar",CurrentValue=false,Callback=function(v) getgenv().ESPSettings.HealthBar=v end})
PVPSection:CreateToggle({Name="Tracers",CurrentValue=false,Callback=function(v) getgenv().ESPSettings.Tracers=v end})
PVPSection:CreateToggle({Name="Chams",CurrentValue=false,Callback=function(v) getgenv().ESPSettings.Chams=v end})
