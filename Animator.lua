--[[
    ⚡☠️ MORTAL PLUGINS V1 ☠️⚡
    PARTE 1: Menu Principal + Sistema de Notificações
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Detectar dispositivo
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Configurações de cores
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    BackgroundSecondary = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentSecondary = Color3.fromRGB(75, 0, 130),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(0, 255, 127),
    Warning = Color3.fromRGB(255, 165, 0),
    Danger = Color3.fromRGB(255, 50, 50),
    Border = Color3.fromRGB(60, 60, 80),
    Glow = Color3.fromRGB(180, 100, 255)
}

-- Utilitários de animação
local function CreateTween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function AnimateIn(frame)
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Visible = true
    CreateTween(frame, {Size = frame:GetAttribute("OriginalSize") or UDim2.new(0.8, 0, 0.85, 0)}, 0.4, Enum.EasingStyle.Back):Play()
end

local function AnimateOut(frame, callback)
    local tween = CreateTween(frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween:Play()
    tween.Completed:Connect(function()
        frame.Visible = false
        if callback then callback() end
    end)
end

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MortalPluginsV1"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Sistema de Notificações
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 320, 1, 0)
NotificationContainer.Position = UDim2.new(1, -330, 0, 0)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Padding = UDim.new(0, 10)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Parent = NotificationContainer

local NotificationPadding = Instance.new("UIPadding")
NotificationPadding.PaddingBottom = UDim.new(0, 20)
NotificationPadding.Parent = NotificationContainer

local function CreateNotification(title, message, duration)
    duration = duration or 5
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.Size = UDim2.new(1, -20, 0, 100)
    NotifFrame.BackgroundColor3 = Colors.Background
    NotifFrame.BorderSizePixel = 0
    NotifFrame.BackgroundTransparency = 0.1
    NotifFrame.ClipsDescendants = true
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = NotifFrame
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Colors.Accent
    NotifStroke.Thickness = 2
    NotifStroke.Transparency = 0.3
    NotifStroke.Parent = NotifFrame
    
    local NotifGradient = Instance.new("UIGradient")
    NotifGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.AccentSecondary),
        ColorSequenceKeypoint.new(1, Colors.Background)
    })
    NotifGradient.Rotation = 45
    NotifGradient.Parent = NotifFrame
    
    local GlowEffect = Instance.new("Frame")
    GlowEffect.Name = "Glow"
    GlowEffect.Size = UDim2.new(0, 4, 1, 0)
    GlowEffect.Position = UDim2.new(0, 0, 0, 0)
    GlowEffect.BackgroundColor3 = Colors.Accent
    GlowEffect.BorderSizePixel = 0
    GlowEffect.Parent = NotifFrame
    
    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(0, 12)
    GlowCorner.Parent = GlowEffect
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -20, 0, 35)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextWrapped = true
    TitleLabel.Parent = NotifFrame
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message"
    MessageLabel.Size = UDim2.new(1, -20, 0, 45)
    MessageLabel.Position = UDim2.new(0, 15, 0, 45)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Colors.TextSecondary
    MessageLabel.TextSize = 12
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextWrapped = true
    MessageLabel.Parent = NotifFrame
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "Progress"
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.BackgroundColor3 = Colors.Accent
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = NotifFrame
    
    NotifFrame.Position = UDim2.new(1, 50, 0, 0)
    NotifFrame.Parent = NotificationContainer
    
    CreateTween(NotifFrame, {Position = UDim2.new(0, 10, 0, 0)}, 0.5, Enum.EasingStyle.Back):Play()
    CreateTween(ProgressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear):Play()
    
    task.delay(duration, function()
        local exitTween = CreateTween(NotifFrame, {Position = UDim2.new(1, 50, 0, 0)}, 0.4)
        exitTween:Play()
        exitTween.Completed:Connect(function()
            NotifFrame:Destroy()
        end)
    end)
    
    return NotifFrame
end

-- Botão Toggle Arrastável
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 15, 0, 50)
ToggleButton.BackgroundColor3 = Colors.Background
ToggleButton.Text = "☠️"
ToggleButton.TextSize = 28
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Colors.Text
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Colors.Accent
ToggleStroke.Thickness = 3
ToggleStroke.Parent = ToggleButton

local ToggleGradient = Instance.new("UIGradient")
ToggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Colors.Accent),
    ColorSequenceKeypoint.new(1, Colors.AccentSecondary)
})
ToggleGradient.Rotation = 45
ToggleGradient.Parent = ToggleButton

-- Sistema de arrastar
local dragging = false
local dragStart = nil
local startPos = nil

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Menu Principal dos Plugins
local MainMenu = Instance.new("Frame")
MainMenu.Name = "MainMenu"
MainMenu.Size = UDim2.new(0.85, 0, 0.88, 0)
MainMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
MainMenu.AnchorPoint = Vector2.new(0.5, 0.5)
MainMenu.BackgroundColor3 = Colors.Background
MainMenu.BorderSizePixel = 0
MainMenu.Visible = false
MainMenu.ClipsDescendants = true
MainMenu.Parent = ScreenGui

MainMenu:SetAttribute("OriginalSize", MainMenu.Size)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainMenu

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2
MainStroke.Transparency = 0.2
MainStroke.Parent = MainMenu

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(0.5, Colors.Background),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 15, 35))
})
MainGradient.Rotation = 135
MainGradient.Parent = MainMenu

-- Header do Menu
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 70)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Colors.BackgroundSecondary
Header.BorderSizePixel = 0
Header.Parent = MainMenu

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 20)
HeaderFix.Position = UDim2.new(0, 0, 1, -20)
HeaderFix.BackgroundColor3 = Colors.BackgroundSecondary
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Colors.AccentSecondary),
    ColorSequenceKeypoint.new(0.5, Colors.BackgroundSecondary),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 20, 80))
})
HeaderGradient.Rotation = 90
HeaderGradient.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡☠️MORTAL PLUGINS V1 • ALL THE PERFECT PLUGINS TO CREATE YOUR GAME☠️⚡"
TitleLabel.TextColor3 = Colors.Text
TitleLabel.TextSize = IsMobile and 11 or 14
TitleLabel.TextWrapped = true
TitleLabel.Parent = Header

-- Container de Plugins
local PluginContainer = Instance.new("ScrollingFrame")
PluginContainer.Name = "PluginContainer"
PluginContainer.Size = UDim2.new(1, -30, 1, -90)
PluginContainer.Position = UDim2.new(0, 15, 0, 80)
PluginContainer.BackgroundTransparency = 1
PluginContainer.ScrollBarThickness = 4
PluginContainer.ScrollBarImageColor3 = Colors.Accent
PluginContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
PluginContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
PluginContainer.Parent = MainMenu

local PluginGrid = Instance.new("UIGridLayout")
PluginGrid.CellSize = IsMobile and UDim2.new(0.48, 0, 0, 140) or UDim2.new(0, 220, 0, 160)
PluginGrid.CellPadding = UDim2.new(0, 15, 0, 15)
PluginGrid.SortOrder = Enum.SortOrder.LayoutOrder
PluginGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
PluginGrid.Parent = PluginContainer

local PluginPadding = Instance.new("UIPadding")
PluginPadding.PaddingTop = UDim.new(0, 10)
PluginPadding.Parent = PluginContainer

-- Função para criar botão de plugin
local function CreatePluginButton(name, icon, description, callback)
    local PluginBtn = Instance.new("TextButton")
    PluginBtn.Name = name
    PluginBtn.Size = UDim2.new(0, 220, 0, 160)
    PluginBtn.BackgroundColor3 = Colors.BackgroundSecondary
    PluginBtn.Text = ""
    PluginBtn.AutoButtonColor = false
    PluginBtn.Parent = PluginContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 14)
    BtnCorner.Parent = PluginBtn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Colors.Border
    BtnStroke.Thickness = 1.5
    BtnStroke.Parent = PluginBtn
    
    local BtnGradient = Instance.new("UIGradient")
    BtnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
        ColorSequenceKeypoint.new(1, Colors.BackgroundSecondary)
    })
    BtnGradient.Rotation = 135
    BtnGradient.Parent = PluginBtn
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(1, 0, 0, 50)
    IconLabel.Position = UDim2.new(0, 0, 0, 15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Text = icon
    IconLabel.TextSize = 38
    IconLabel.TextColor3 = Colors.Accent
    IconLabel.Parent = PluginBtn
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "Name"
    NameLabel.Size = UDim2.new(1, -20, 0, 30)
    NameLabel.Position = UDim2.new(0, 10, 0, 70)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Text = name
    NameLabel.TextSize = 13
    NameLabel.TextColor3 = Colors.Text
    NameLabel.TextWrapped = true
    NameLabel.Parent = PluginBtn
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "Description"
    DescLabel.Size = UDim2.new(1, -20, 0, 40)
    DescLabel.Position = UDim2.new(0, 10, 0, 100)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = description
    DescLabel.TextSize = 10
    DescLabel.TextColor3 = Colors.TextSecondary
    DescLabel.TextWrapped = true
    DescLabel.Parent = PluginBtn
    
    -- Efeito hover
    PluginBtn.MouseEnter:Connect(function()
        CreateTween(BtnStroke, {Color = Colors.Accent}, 0.2):Play()
        CreateTween(PluginBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}, 0.2):Play()
    end)
    
    PluginBtn.MouseLeave:Connect(function()
        CreateTween(BtnStroke, {Color = Colors.Border}, 0.2):Play()
        CreateTween(PluginBtn, {BackgroundColor3 = Colors.BackgroundSecondary}, 0.2):Play()
    end)
    
    PluginBtn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return PluginBtn
end

-- Toggle do menu
local menuVisible = false

local function ToggleMenu()
    menuVisible = not menuVisible
    if menuVisible then
        AnimateIn(MainMenu)
        CreateTween(ToggleStroke, {Color = Colors.Success}, 0.3):Play()
    else
        AnimateOut(MainMenu)
        CreateTween(ToggleStroke, {Color = Colors.Accent}, 0.3):Play()
    end
end

ToggleButton.MouseButton1Click:Connect(ToggleMenu)

-- Tabela para armazenar os plugins carregados
_G.MortalPlugins = {
    Colors = Colors,
    CreateTween = CreateTween,
    CreateNotification = CreateNotification,
    CreatePluginButton = CreatePluginButton,
    AnimateIn = AnimateIn,
    AnimateOut = AnimateOut,
    ScreenGui = ScreenGui,
    MainMenu = MainMenu,
    IsMobile = IsMobile,
    PluginContainer = PluginContainer
}

-- Criar botão do Animator
CreatePluginButton(
    "Mortal Animator☠️",
    "🎬",
    "Animator profissional AAA para animar Rigs, Models, Parts e mais",
    function()
        if _G.MortalPlugins.LoadAnimator then
            _G.MortalPlugins.LoadAnimator()
        end
    end
)

-- Notificação inicial
task.wait(0.5)
CreateNotification(
    "👑☠️MORTAL PLUGINS V1☠️👑",
    "Sistema carregado com sucesso! Toque no ☠️ para abrir o menu de plugins⚡",
    5
)

task.wait(5.5)
ToggleMenu()

print("✅ MORTAL PLUGINS V1 - Menu Principal Carregado!")

