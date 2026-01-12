--[[
    Universal Aimbot & ESP (Fixed v6 - Health Bar Fix)
    Credits: Mano Gustavo (_gustavo_2133)
    Discord: https://discord.gg/ZetfngRD
    
    Update: Health Bar completely remade (Working perfectly now).
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

--// CONFIGURAÇÃO //--
local DeleteMob = {
    GUi = {
        Open = true,
        Keybind = Enum.KeyCode.Insert
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = false,
        WallCheck = false,
        ShowFov = false,
        Fov = 100,
        Smoothing = 1,
        AimPart = "Head",
        Keybind = Enum.UserInputType.MouseButton2,
        IsAimKeyDown = false,
        FovColor = Color3.fromRGB(138, 43, 226),
        Thickness = 1,
        Transparency = 1
    },
    ESP = {
        Box = {
            Enabled = false,
            Name = false,
            Distance = false,
            Health = false,
            TeamCheck = false,
            HealthType = "Bar", -- Bar, Text, Both
            BoxColor = Color3.fromRGB(255, 255, 255)
        },
        OutLines = {
            Enabled = false,
            TeamCheck = false,
            TeamColor = false,
            AllwaysShow = true,
            FillColor = Color3.fromRGB(255, 0, 0),
            FillTransparency = 0.5,
            OutlineColor = Color3.fromRGB(255, 255, 255),
            OutlineTransparency = 0
        },
        Tracers = {
            Enabled = false,
            TeamCheck = false,
            TeamColor = false,
            Color = Color3.fromRGB(255, 255, 255)
        }
    }
}

--// UI LIBRARY FIXED //--
local Library = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GustavoHub_v6"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true 

local function MakeDraggable(targetFrame, inputObject)
    local dragging, dragInput, dragStart, startPos
    
    inputObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    inputObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(title)
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local CreditsLabel = Instance.new("TextLabel")
    local CloseBtn = Instance.new("TextButton")
    
    local OpenFrame = Instance.new("Frame")
    local OpenBtn = Instance.new("TextButton")
    local OpenCorner = Instance.new("UICorner")
    local OpenStroke = Instance.new("UIStroke")

    OpenFrame.Name = "OpenFrame"
    OpenFrame.Parent = ScreenGui
    OpenFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    OpenFrame.Position = UDim2.new(0.5, -60, 0.1, 0)
    OpenFrame.Size = UDim2.new(0, 120, 0, 35)
    OpenFrame.Visible = false
    
    OpenCorner.CornerRadius = UDim.new(0, 8)
    OpenCorner.Parent = OpenFrame
    
    OpenStroke.Parent = OpenFrame
    OpenStroke.Color = Color3.fromRGB(255, 255, 255)
    OpenStroke.Thickness = 1
    
    OpenBtn.Parent = OpenFrame
    OpenBtn.Size = UDim2.new(1,0,1,0)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Text = "Open Menu"
    OpenBtn.TextColor3 = Color3.fromRGB(255,255,255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 14
    
    MakeDraggable(OpenFrame, OpenBtn)

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ClipsDescendants = true 

    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar
    
    MakeDraggable(MainFrame, TopBar)

    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    CreditsLabel.Parent = TopBar
    CreditsLabel.BackgroundTransparency = 1
    CreditsLabel.Position = UDim2.new(1, -45, 0, 0)
    CreditsLabel.Size = UDim2.new(0, 200, 1, 0)
    CreditsLabel.AnchorPoint = Vector2.new(1, 0)
    CreditsLabel.Font = Enum.Font.Gotham
    CreditsLabel.Text = "By Mano Gustavo"
    CreditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    CreditsLabel.TextSize = 12
    CreditsLabel.TextXAlignment = Enum.TextXAlignment.Right

    CloseBtn.Name = "CloseButton"
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -30, 0, 5)
    CloseBtn.Size = UDim2.new(0, 25, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.TextSize = 18
    
    local function ToggleMenu(state)
        MainFrame.Visible = state
        OpenFrame.Visible = not state
    end

    CloseBtn.MouseButton1Click:Connect(function()
        ToggleMenu(false)
    end)

    local isDragging = false
    OpenBtn.MouseButton1Down:Connect(function() isDragging = false end)
    OpenBtn.MouseLeave:Connect(function() isDragging = true end)
    
    OpenBtn.MouseButton1Click:Connect(function()
        if not isDragging then ToggleMenu(true) end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == DeleteMob.GUi.Keybind then
            ToggleMenu(not MainFrame.Visible)
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 130, 1, -40)
    Sidebar.BorderSizePixel = 0

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 10)

    local Divider = Instance.new("Frame")
    Divider.Parent = MainFrame
    Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0, 130, 0, 40)
    Divider.Size = UDim2.new(0, 1, 1, -40)

    local Content = Instance.new("Frame")
    Content.Parent = MainFrame
    Content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 140, 0, 50)
    Content.Size = UDim2.new(1, -150, 1, -60)

    local tabs = {}
    local firstTab = true

    function tabs:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        
        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.Size = UDim2.new(0, 110, 0, 35)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Parent = Content
        Page.Active = true
        Page.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 4
        Page.Visible = false
        Page.BorderSizePixel = 0
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 6)

        local PagePad = Instance.new("UIPadding")
        PagePad.Parent = Page
        PagePad.PaddingRight = UDim.new(0, 5)
        PagePad.PaddingBottom = UDim.new(0, 10)

        if firstTab then
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            firstTab = false
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(138, 43, 226), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        local Elements = {}

        function Elements:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Parent = Page
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:CreateToggle(text, callback, default)
            local Frame = Instance.new("Frame")
            local Btn = Instance.new("TextButton")
            local Indicator = Instance.new("Frame")
            local Label = Instance.new("TextLabel")
            
            Frame.Parent = Page
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.Size = UDim2.new(1, 0, 0, 35)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.8, 0, 1, 0)
            Label.Text = text
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            Indicator.Parent = Frame
            Indicator.AnchorPoint = Vector2.new(1, 0.5)
            Indicator.Position = UDim2.new(1, -10, 0.5, 0)
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.BackgroundColor3 = default and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

            Btn.Parent = Frame
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""

            local toggled = default or false
            Btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                local targetColor = toggled and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 50)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                callback(toggled)
            end)
            return Btn
        end
        
        function Elements:CreateButton(text, callback)
            local Frame = Instance.new("Frame")
            local Btn = Instance.new("TextButton")
            
            Frame.Parent = Page
            Frame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            Frame.Size = UDim2.new(1, 0, 0, 35)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            Btn.Parent = Frame
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            
            Btn.MouseButton1Click:Connect(callback)
        end

        function Elements:CreateSlider(text, min, max, default, callback)
            local Frame = Instance.new("Frame")
            local Label = Instance.new("TextLabel")
            local Value = Instance.new("TextLabel")
            local Bar = Instance.new("Frame")
            local Fill = Instance.new("Frame")
            local Btn = Instance.new("TextButton")

            Frame.Parent = Page
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.Size = UDim2.new(1, 0, 0, 50)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Text = text
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            Value.Parent = Frame
            Value.BackgroundTransparency = 1
            Value.Position = UDim2.new(0, 10, 0, 5)
            Value.Size = UDim2.new(1, -20, 0, 20)
            Value.Text = tostring(default)
            Value.Font = Enum.Font.Gotham
            Value.TextColor3 = Color3.fromRGB(150, 150, 150)
            Value.TextSize = 14
            Value.TextXAlignment = Enum.TextXAlignment.Right

            Bar.Parent = Frame
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Bar.Position = UDim2.new(0, 10, 0, 35)
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            Fill.Parent = Bar
            Fill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            Btn.Parent = Bar
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""

            local dragging = false
            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local scale = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local newVal = math.floor(min + ((max - min) * scale))
                    Fill.Size = UDim2.new(scale, 0, 1, 0)
                    Value.Text = tostring(newVal)
                    callback(newVal)
                end
            end)
        end

        function Elements:CreateDropdown(text, options, default, callback)
            local Frame = Instance.new("Frame")
            local Btn = Instance.new("TextButton")
            local Label = Instance.new("TextLabel")
            local StateLabel = Instance.new("TextLabel")

            Frame.Parent = Page
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.Size = UDim2.new(1, 0, 0, 35)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Text = text
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            StateLabel.Parent = Frame
            StateLabel.BackgroundTransparency = 1
            StateLabel.Position = UDim2.new(0.5, 0, 0, 0)
            StateLabel.Size = UDim2.new(0.5, -10, 1, 0)
            StateLabel.Text = default
            StateLabel.Font = Enum.Font.GothamBold
            StateLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
            StateLabel.TextSize = 14
            StateLabel.TextXAlignment = Enum.TextXAlignment.Right

            Btn.Parent = Frame
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""

            local index = table.find(options, default) or 1
            Btn.MouseButton1Click:Connect(function()
                index = index + 1
                if index > #options then index = 1 end
                local choice = options[index]
                StateLabel.Text = choice
                callback(choice)
            end)
        end

        function Elements:CreateRGB(text, defaultColor, callback)
            Elements:CreateLabel(text)
            local r, g, b = math.floor(defaultColor.R*255), math.floor(defaultColor.G*255), math.floor(defaultColor.B*255)
            
            local function UpdateColor()
                local newColor = Color3.fromRGB(r, g, b)
                callback(newColor)
            end

            Elements:CreateSlider("Red", 0, 255, r, function(val) r = val; UpdateColor() end)
            Elements:CreateSlider("Green", 0, 255, g, function(val) g = val; UpdateColor() end)
            Elements:CreateSlider("Blue", 0, 255, b, function(val) b = val; UpdateColor() end)
        end

        return Elements
    end

    return tabs
end

--// LÓGICA DO JOGO (AIMBOT & ESP) //--

local FOVFFrame = Instance.new("Frame")
FOVFFrame.Parent = ScreenGui
FOVFFrame.Name = "FOVFFrame"
FOVFFrame.BackgroundColor3 = DeleteMob.Aimbot.FovColor
FOVFFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
FOVFFrame.BorderSizePixel = 0
FOVFFrame.BackgroundTransparency = 1 
FOVFFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFFrame.Visible = false

local UICornerFOV = Instance.new("UICorner")
UICornerFOV.CornerRadius = UDim.new(1, 0)
UICornerFOV.Parent = FOVFFrame

local UIStrokeFOV = Instance.new("UIStroke")
UIStrokeFOV.Color = DeleteMob.Aimbot.FovColor
UIStrokeFOV.Parent = FOVFFrame
UIStrokeFOV.Thickness = DeleteMob.Aimbot.Thickness
UIStrokeFOV.ApplyStrokeMode = "Border"

local BoxContainer = Instance.new("ScreenGui", Workspace) BoxContainer.Name = "BoxContainer"
local HighlightContainer = Instance.new("ScreenGui", Workspace) HighlightContainer.Name = "Highlights"
local TracersContainer = Instance.new("ScreenGui", ScreenGui) TracersContainer.Name = "Tracers"

local function isVisible(targetPart, ...)
    if not DeleteMob.Aimbot.WallCheck then return true end
    return #CurrentCamera:GetPartsObscuringTarget({ targetPart.Position }, { CurrentCamera, LocalPlayer.Character, ... }) == 0
end

local function GetClosestPlayer()
    local ClosestDist = DeleteMob.Aimbot.Fov
    local Target = nil

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if DeleteMob.Aimbot.TeamCheck and v.Team == LocalPlayer.Team then continue end

            local AimPart = v.Character:FindFirstChild(DeleteMob.Aimbot.AimPart)
            if AimPart then
                local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(AimPart.Position)
                local MousePos = UserInputService:GetMouseLocation()
                local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

                if OnScreen and Dist < ClosestDist then
                    if isVisible(AimPart, v.Character) then
                        ClosestDist = Dist
                        Target = v
                    end
                end
            end
        end
    end
    return Target
end

local function AddVisuals(plr)
    local bbg = Instance.new("BillboardGui", BoxContainer)
    bbg.Name = plr.Name
    bbg.AlwaysOnTop = true
    bbg.Size = UDim2.new(4,0,5.4,0)
    bbg.ClipsDescendants = false
    bbg.Enabled = false

    local outlines = Instance.new("Frame", bbg)
    outlines.Size = UDim2.new(1,0,1,0)
    outlines.BorderSizePixel = 0
    outlines.BackgroundTransparency = 1
    local stroke = Instance.new("UIStroke", outlines)
    stroke.Thickness = 1.5
    stroke.Color = DeleteMob.ESP.Box.BoxColor

    local info = Instance.new("BillboardGui", bbg)
    info.Name = "info"
    info.Size = UDim2.new(3,0,0,54)
    info.StudsOffset = Vector3.new(3.6,-3,0)
    info.AlwaysOnTop = true
    info.Enabled = false

    local namelabel = Instance.new("TextLabel", info)
    namelabel.BackgroundTransparency = 1
    namelabel.TextStrokeTransparency = 0
    namelabel.TextXAlignment = Enum.TextXAlignment.Left
    namelabel.Size = UDim2.new(0,100,0,18)
    namelabel.Text = plr.Name
    namelabel.TextColor3 = DeleteMob.ESP.Box.BoxColor
    namelabel.Font = Enum.Font.GothamBold
    namelabel.TextSize = 12

    local distancel = Instance.new("TextLabel", info)
    distancel.BackgroundTransparency = 1
    distancel.TextStrokeTransparency = 0
    distancel.TextXAlignment = Enum.TextXAlignment.Left
    distancel.Size = UDim2.new(0,100,0,18)
    distancel.Position = UDim2.new(0,0,0,14)
    distancel.TextColor3 = DeleteMob.ESP.Box.BoxColor
    distancel.Font = Enum.Font.Gotham
    distancel.TextSize = 12

    local healthl = Instance.new("TextLabel", info)
    healthl.BackgroundTransparency = 1
    healthl.TextStrokeTransparency = 0
    healthl.TextXAlignment = Enum.TextXAlignment.Left
    healthl.Size = UDim2.new(0,100,0,18)
    healthl.Position = UDim2.new(0,0,0,28)
    healthl.Font = Enum.Font.Gotham
    healthl.TextSize = 12

    -- CORREÇÃO DEFINITIVA DA HEALTH BAR
    -- Ela agora é filha de 'outlines' para seguir a caixa, mas posicionada ao lado
    local healthBar = Instance.new("Frame", outlines)
    healthBar.Name = "HealthBar"
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Position = UDim2.new(0, -5, 0, 0) -- 5 pixels a esquerda da caixa
    healthBar.Size = UDim2.new(0, 3, 1, 0) -- 3 pixels de largura
    healthBar.Visible = false

    local healthFill = Instance.new("Frame", healthBar)
    healthFill.Name = "Fill"
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.AnchorPoint = Vector2.new(0, 1) -- Cresce de baixo pra cima
    healthFill.Position = UDim2.new(0, 0, 1, 0)
    healthFill.Size = UDim2.new(1, 0, 1, 0)

    local highlight = Instance.new("Highlight")
    highlight.Parent = HighlightContainer
    highlight.Enabled = false
    highlight.Adornee = plr.Character

    local tracer = Instance.new("Frame")
    tracer.Parent = TracersContainer
    tracer.BorderSizePixel = 0
    tracer.Visible = false
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)

    RunService.RenderStepped:Connect(function()
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr ~= LocalPlayer then
            local Root = plr.Character.HumanoidRootPart
            local Hum = plr.Character.Humanoid
            
            bbg.Adornee = Root
            info.Adornee = Root
            highlight.Adornee = plr.Character

            local IsTeammate = (plr.Team == LocalPlayer.Team)
            local ShowESP = true
            if DeleteMob.ESP.Box.TeamCheck and IsTeammate then ShowESP = false end
            if not DeleteMob.ESP.Box.Enabled then ShowESP = false end

            if ShowESP then
                bbg.Enabled = true
                info.Enabled = true
                stroke.Color = DeleteMob.ESP.Box.BoxColor
                namelabel.TextColor3 = DeleteMob.ESP.Box.BoxColor
                distancel.TextColor3 = DeleteMob.ESP.Box.BoxColor
                
                namelabel.Visible = DeleteMob.ESP.Box.Name
                
                if DeleteMob.ESP.Box.Distance then
                    distancel.Visible = true
                    local mag = (LocalPlayer.Character.HumanoidRootPart.Position - Root.Position).Magnitude
                    distancel.Text = math.floor(mag) .. "m"
                else
                    distancel.Visible = false
                end

                if DeleteMob.ESP.Box.Health then
                    local hPercent = Hum.Health / Hum.MaxHealth
                    hPercent = math.clamp(hPercent, 0, 1) -- Evita erros
                    
                    healthFill.Size = UDim2.new(1, 0, hPercent, 0)
                    healthFill.BackgroundColor3 = Color3.fromHSV(hPercent * 0.3, 1, 1) -- Cor dinâmica
                    
                    if DeleteMob.ESP.Box.HealthType == "Bar" then
                        healthBar.Visible = true
                        healthl.Visible = false
                    elseif DeleteMob.ESP.Box.HealthType == "Text" then
                        healthBar.Visible = false
                        healthl.Visible = true
                        healthl.Text = math.floor(Hum.Health) .. " HP"
                        healthl.TextColor3 = healthFill.BackgroundColor3
                    elseif DeleteMob.ESP.Box.HealthType == "Both" then
                        healthBar.Visible = true
                        healthl.Visible = true
                        healthl.Text = math.floor(Hum.Health) .. " HP"
                        healthl.TextColor3 = healthFill.BackgroundColor3
                    end
                else
                    healthBar.Visible = false
                    healthl.Visible = false
                end
            else
                bbg.Enabled = false
                info.Enabled = false
            end

            local ShowOutline = DeleteMob.ESP.OutLines.Enabled
            if DeleteMob.ESP.OutLines.TeamCheck and IsTeammate then ShowOutline = false end
            
            if ShowOutline then
                highlight.Enabled = true
                highlight.FillTransparency = DeleteMob.ESP.OutLines.FillTransparency
                highlight.OutlineTransparency = DeleteMob.ESP.OutLines.OutlineTransparency
                highlight.OutlineColor = DeleteMob.ESP.OutLines.OutlineColor
                highlight.FillColor = DeleteMob.ESP.OutLines.TeamColor and plr.TeamColor.Color or DeleteMob.ESP.OutLines.FillColor
                highlight.DepthMode = DeleteMob.ESP.OutLines.AllwaysShow and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
            else
                highlight.Enabled = false
            end

            local ShowTracer = DeleteMob.ESP.Tracers.Enabled
            if DeleteMob.ESP.Tracers.TeamCheck and IsTeammate then ShowTracer = false end
            local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(Root.Position)
            
            if ShowTracer and OnScreen then
                tracer.Visible = true
                tracer.BackgroundColor3 = DeleteMob.ESP.Tracers.TeamColor and plr.TeamColor.Color or DeleteMob.ESP.Tracers.Color
                local Vector = Vector2.new(ScreenPos.X, ScreenPos.Y)
                local Origin = Vector2.new(CurrentCamera.ViewportSize.X/2, CurrentCamera.ViewportSize.Y - 10)
                local Position = (Origin + Vector) / 2
                local Length = (Origin - Vector).Magnitude
                tracer.Rotation = math.deg(math.atan2(Vector.Y - Origin.Y, Vector.X - Origin.X))
                tracer.Position = UDim2.new(0, Position.X, 0, Position.Y)
                tracer.Size = UDim2.new(0, Length, 0, 1.5)
            else
                tracer.Visible = false
            end
        else
            bbg.Enabled = false
            info.Enabled = false
            highlight.Enabled = false
            tracer.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do AddVisuals(p) end
Players.PlayerAdded:Connect(AddVisuals)

RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    FOVFFrame.Position = UDim2.new(0, MousePos.X, 0, MousePos.Y)
    FOVFFrame.Size = UDim2.new(0, DeleteMob.Aimbot.Fov*2, 0, DeleteMob.Aimbot.Fov*2)
    FOVFFrame.Visible = DeleteMob.Aimbot.ShowFov
    UIStrokeFOV.Color = DeleteMob.Aimbot.FovColor

    if DeleteMob.Aimbot.Enabled and DeleteMob.Aimbot.IsAimKeyDown then
        local Target = GetClosestPlayer()
        if Target then
            local AimPart = Target.Character[DeleteMob.Aimbot.AimPart]
            local TargetPos = AimPart.Position
            local Smoothness = DeleteMob.Aimbot.Smoothing < 1 and 1 or DeleteMob.Aimbot.Smoothing
            CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.new(CurrentCamera.CFrame.Position, TargetPos), 1/Smoothness)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp then
        if input.UserInputType == DeleteMob.Aimbot.Keybind then DeleteMob.Aimbot.IsAimKeyDown = true end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == DeleteMob.Aimbot.Keybind then DeleteMob.Aimbot.IsAimKeyDown = false end
end)

--// CONSTRUÇÃO DA INTERFACE //--
local Window = Library:CreateWindow("Universal Script v6")
local AimbotTab = Window:CreateTab("Aimbot")
local VisualsTab = Window:CreateTab("ESP Box")
local HighlightsTab = Window:CreateTab("Outlines")
local CreditsTab = Window:CreateTab("Credits")

-- TAB AIMBOT
AimbotTab:CreateToggle("Enable Aimbot", function(v) DeleteMob.Aimbot.Enabled = v end, DeleteMob.Aimbot.Enabled)
AimbotTab:CreateToggle("Show FOV", function(v) DeleteMob.Aimbot.ShowFov = v end, DeleteMob.Aimbot.ShowFov)
AimbotTab:CreateToggle("Team Check", function(v) DeleteMob.Aimbot.TeamCheck = v end, DeleteMob.Aimbot.TeamCheck)
AimbotTab:CreateToggle("Wall Check", function(v) DeleteMob.Aimbot.WallCheck = v end, DeleteMob.Aimbot.WallCheck)
AimbotTab:CreateDropdown("Aim Part", {"Head", "HumanoidRootPart"}, "Head", function(v) DeleteMob.Aimbot.AimPart = v end)
AimbotTab:CreateSlider("FOV Radius", 10, 800, 100, function(v) DeleteMob.Aimbot.Fov = v end)
AimbotTab:CreateSlider("Smoothing", 1, 50, 1, function(v) DeleteMob.Aimbot.Smoothing = v end)
AimbotTab:CreateRGB("FOV Color", DeleteMob.Aimbot.FovColor, function(v) DeleteMob.Aimbot.FovColor = v end)

-- TAB VISUALS
VisualsTab:CreateToggle("Enable Box ESP", function(v) DeleteMob.ESP.Box.Enabled = v end, DeleteMob.ESP.Box.Enabled)
VisualsTab:CreateToggle("Show Name", function(v) DeleteMob.ESP.Box.Name = v end, DeleteMob.ESP.Box.Name)
VisualsTab:CreateToggle("Show Distance", function(v) DeleteMob.ESP.Box.Distance = v end, DeleteMob.ESP.Box.Distance)
VisualsTab:CreateToggle("Show Health", function(v) DeleteMob.ESP.Box.Health = v end, DeleteMob.ESP.Box.Health)
VisualsTab:CreateToggle("Team Check", function(v) DeleteMob.ESP.Box.TeamCheck = v end, DeleteMob.ESP.Box.TeamCheck)
VisualsTab:CreateDropdown("Health Type", {"Bar", "Text", "Both"}, "Bar", function(v) DeleteMob.ESP.Box.HealthType = v end)
VisualsTab:CreateRGB("Box Color", DeleteMob.ESP.Box.BoxColor, function(v) DeleteMob.ESP.Box.BoxColor = v end)
VisualsTab:CreateLabel(" -- Tracers -- ")
VisualsTab:CreateToggle("Enable Tracers", function(v) DeleteMob.ESP.Tracers.Enabled = v end, DeleteMob.ESP.Tracers.Enabled)
VisualsTab:CreateToggle("Team Check Tracers", function(v) DeleteMob.ESP.Tracers.TeamCheck = v end, DeleteMob.ESP.Tracers.TeamCheck)
VisualsTab:CreateToggle("Team Color Tracers", function(v) DeleteMob.ESP.Tracers.TeamColor = v end, DeleteMob.ESP.Tracers.TeamColor)
VisualsTab:CreateRGB("Tracer Color", DeleteMob.ESP.Tracers.Color, function(v) DeleteMob.ESP.Tracers.Color = v end)

-- TAB HIGHLIGHTS
HighlightsTab:CreateToggle("Enable Outlines", function(v) DeleteMob.ESP.OutLines.Enabled = v end, DeleteMob.ESP.OutLines.Enabled)
HighlightsTab:CreateToggle("Team Check", function(v) DeleteMob.ESP.OutLines.TeamCheck = v end, DeleteMob.ESP.OutLines.TeamCheck)
HighlightsTab:CreateToggle("Use Team Color", function(v) DeleteMob.ESP.OutLines.TeamColor = v end, DeleteMob.ESP.OutLines.TeamColor)
HighlightsTab:CreateToggle("Always On Top", function(v) DeleteMob.ESP.OutLines.AllwaysShow = v end, DeleteMob.ESP.OutLines.AllwaysShow)
HighlightsTab:CreateSlider("Fill Transparency", 0, 10, 5, function(v) DeleteMob.ESP.OutLines.FillTransparency = v/10 end)
HighlightsTab:CreateSlider("Outline Transparency", 0, 10, 0, function(v) DeleteMob.ESP.OutLines.OutlineTransparency = v/10 end)
HighlightsTab:CreateRGB("Fill Color", DeleteMob.ESP.OutLines.FillColor, function(v) DeleteMob.ESP.OutLines.FillColor = v end)
HighlightsTab:CreateRGB("Outline Color", DeleteMob.ESP.OutLines.OutlineColor, function(v) DeleteMob.ESP.OutLines.OutlineColor = v end)

-- TAB CREDITS
CreditsTab:CreateLabel("User: _gustavo_2133")
CreditsTab:CreateLabel("Discord Server:")
CreditsTab:CreateButton("Copy Discord Link", function() 
    setclipboard("https://discord.gg/ZetfngRD") 
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Discord", Text = "Link copied!"})
end)
CreditsTab:CreateLabel("Script by Mano Gustavo")

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Loaded", Text = "By Mano Gustavo"})