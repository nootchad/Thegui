local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local folderName = "Hesiz Fortile"

local RenameGui = Instance.new("ScreenGui")
RenameGui.Name = "RenameBuildGUI"
RenameGui.Parent = game.CoreGui
RenameGui.Enabled = true

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = RenameGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(25,25,25)
Title.Text = "Rename Build"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
CloseBtn.Parent = Frame
CloseBtn.MouseButton1Click:Connect(function()
    RenameGui.Enabled = false
end)

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1,-20,0,30)
Input.Position = UDim2.new(0,10,0,360)
Input.BackgroundColor3 = Color3.fromRGB(60,60,60)
Input.PlaceholderText = "New name"
Input.TextColor3 = Color3.fromRGB(255,255,255)
Input.Parent = Frame

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(1,-20,0,30)
SaveBtn.Position = UDim2.new(0,10,0,330)
SaveBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
SaveBtn.Text = "Confirm rename"
SaveBtn.TextColor3 = Color3.fromRGB(255,255,255)
SaveBtn.Parent = Frame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1,-20,0,300)
ScrollingFrame.Position = UDim2.new(0,10,0,30)
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
ScrollingFrame.Parent = Frame

local selectedBuild

local function GetBuilds()
    if not isfolder(folderName) then return {} end
    local files = listfiles(folderName)
    local builds = {}
    for _, file in ipairs(files) do
        local name = file:match(folderName.."/(.+)%.json")
        if name then table.insert(builds, name) end
    end
    return builds
end

local function UpdateScrollingBuilds()
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local builds = GetBuilds()
    local y = 0
    for _, build in ipairs(builds) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,25)
        btn.Position = UDim2.new(0,0,0,y)
        btn.Text = build
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Parent = ScrollingFrame
        y = y + 30

        btn.MouseButton1Click:Connect(function()
            if selectedBuild then
                selectedBuild.BackgroundColor3 = Color3.fromRGB(70,70,70)
            end
            selectedBuild = btn
            selectedBuild.BackgroundColor3 = Color3.fromRGB(0,170,0)
        end)
    end
    ScrollingFrame.CanvasSize = UDim2.new(0,0,0,y)
end

UpdateScrollingBuilds()

SaveBtn.MouseButton1Click:Connect(function()
    if selectedBuild and Input.Text~="" then
        local oldPath = folderName.."/"..selectedBuild.Text..".json"
        local newPath = folderName.."/"..Input.Text..".json"
        if isfile(oldPath) then
            writefile(newPath, readfile(oldPath))
            delfile(oldPath)
            StarterGui:SetCore("SendNotification", {
                Title = "Hesiz Hub",
                Text = "Build renamed successfully. Please refresh the build list.",
                Duration = 5
            })
            selectedBuild.Text = Input.Text
            selectedBuild.BackgroundColor3 = Color3.fromRGB(70,70,70)
            selectedBuild = nil
            UpdateScrollingBuilds()
        end
    end
end)
