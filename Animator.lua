--[[
    ⚡☠️ MORTAL PLUGINS V1 ☠️⚡
    Menu Principal de Plugins
    Compatível: Delta Executor, Mobile & PC
    Jogo: Studio Lite
    Parte 1/3 do Sistema Base
]]

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configurações Globais
local MortalConfig = {
    MainColor = Color3.fromRGB(15, 15, 25),
    AccentColor = Color3.fromRGB(138, 43, 226),
    AccentColor2 = Color3.fromRGB(75, 0, 130),
    TextColor = Color3.fromRGB(255, 255, 255),
    SuccessColor = Color3.fromRGB(0, 255, 127),
    DangerColor = Color3.fromRGB(255, 50, 50),
    BorderColor = Color3.fromRGB(138, 43, 226),
    DarkBg = Color3.fromRGB(10, 10, 18),
    CardBg = Color3.fromRGB(25, 25, 40),
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham
}

-- Detectar Dispositivo
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Container Principal
local MortalPlugins = Instance.new("ScreenGui")
MortalPlugins.Name = "MortalPluginsV1"
MortalPlugins.ResetOnSpawn = false
MortalPlugins.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MortalPlugins.IgnoreGuiInset = true

pcall(function()
    MortalPlugins.Parent = CoreGui
end)
if not MortalPlugins.Parent then
    MortalPlugins.Parent = PlayerGui
end

-- Funções Utilitárias
local function CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or MortalConfig.BorderColor
    stroke.Thickness = thickness or 2
    stroke.Parent = parent
    return stroke
end

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function Tween(obj, props, duration, style, direction)
    local tween = TweenService:Create(obj, TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    ), props)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        Tween(frame, {Position = newPos}, 0.1)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Sistema de Notificações
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Position = UDim2.new(1, -320, 1, -20)
NotificationContainer.AnchorPoint = Vector2.new(1, 1)
NotificationContainer.Size = UDim2.new(0, 300, 0, 400)
NotificationContainer.Parent = MortalPlugins

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.Padding = UDim.new(0, 10)
NotificationLayout.Parent = NotificationContainer

local function ShowNotification(title, message, duration)
    duration = duration or 5
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.BackgroundColor3 = MortalConfig.DarkBg
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.ClipsDescendants = true
    notif.Parent = NotificationContainer
    
    CreateCorner(notif, 12)
    CreateStroke(notif, MortalConfig.AccentColor, 2)
    CreateShadow(notif)
    
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.BackgroundColor3 = MortalConfig.AccentColor
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BorderSizePixel = 0
    accent.Parent = notif
    CreateGradient(accent, MortalConfig.AccentColor, MortalConfig.AccentColor2, 90)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.Size = UDim2.new(1, -25, 0, 25)
    titleLabel.Font = MortalConfig.Font
    titleLabel.Text = title
    titleLabel.TextColor3 = MortalConfig.SuccessColor
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.BackgroundTransparency = 1
    messageLabel.Position = UDim2.new(0, 15, 0, 35)
    messageLabel.Size = UDim2.new(1, -25, 0, 40)
    messageLabel.Font = MortalConfig.FontLight
    messageLabel.Text = message
    messageLabel.TextColor3 = MortalConfig.TextColor
    messageLabel.TextSize = 12
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = notif
    
    local progress = Instance.new("Frame")
    progress.Name = "Progress"
    progress.BackgroundColor3 = MortalConfig.AccentColor
    progress.Position = UDim2.new(0, 0, 1, -3)
    progress.Size = UDim2.new(1, 0, 0, 3)
    progress.BorderSizePixel = 0
    progress.Parent = notif
    CreateGradient(progress, MortalConfig.AccentColor, MortalConfig.SuccessColor)
    
    -- Animação de entrada
    Tween(notif, {Size = UDim2.new(1, 0, 0, 85)}, 0.4, Enum.EasingStyle.Back)
    
    -- Progress bar
    Tween(progress, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
    
    -- Remover após duração
    task.delay(duration, function()
        Tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.wait(0.35)
        notif:Destroy()
    end)
end

-- Menu Principal de Plugins
local MainMenuVisible = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = MortalConfig.MainColor
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = IsMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 650, 0, 500)
MainFrame.Visible = false
MainFrame.Parent = MortalPlugins

CreateCorner(MainFrame, 16)
CreateStroke(MainFrame, MortalConfig.AccentColor, 3)
CreateShadow(MainFrame)
CreateGradient(MainFrame, MortalConfig.DarkBg, MortalConfig.MainColor, 135)

-- Header do Menu Principal
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.BackgroundColor3 = MortalConfig.CardBg
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

CreateCorner(Header, 16)
CreateGradient(Header, MortalConfig.AccentColor2, MortalConfig.CardBg, 90)

local headerFix = Instance.new("Frame")
headerFix.BackgroundColor3 = MortalConfig.CardBg
headerFix.Position = UDim2.new(0, 0, 1, -16)
headerFix.Size = UDim2.new(1, 0, 0, 16)
headerFix.BorderSizePixel = 0
headerFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Font = MortalConfig.Font
Title.Text = "⚡☠️MORTAL PLUGINS V1 • ALL THE PERFECT PLUGINS TO CREATE YOUR GAME☠️⚡"
Title.TextColor3 = MortalConfig.TextColor
Title.TextSize = IsMobile and 12 or 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

MakeDraggable(MainFrame, Header)

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.BackgroundColor3 = MortalConfig.DangerColor
CloseBtn.Position = UDim2.new(1, -50, 0.5, 0)
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Font = MortalConfig.Font
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = MortalConfig.TextColor
CloseBtn.TextSize = 18
CloseBtn.Parent = Header
CreateCorner(CloseBtn, 8)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, {BackgroundColor3 = MortalConfig.DangerColor}, 0.2)
end)

-- Container de Plugins
local PluginContainer = Instance.new("ScrollingFrame")
PluginContainer.Name = "PluginContainer"
PluginContainer.BackgroundTransparency = 1
PluginContainer.Position = UDim2.new(0, 15, 0, 75)
PluginContainer.Size = UDim2.new(1, -30, 1, -90)
PluginContainer.ScrollBarThickness = 4
PluginContainer.ScrollBarImageColor3 = MortalConfig.AccentColor
PluginContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
PluginContainer.Parent = MainFrame

local PluginGrid = Instance.new("UIGridLayout")
PluginGrid.CellSize = IsMobile and UDim2.new(0.48, 0, 0, 120) or UDim2.new(0, 195, 0, 130)
PluginGrid.CellPadding = UDim2.new(0, 10, 0, 10)
PluginGrid.SortOrder = Enum.SortOrder.LayoutOrder
PluginGrid.Parent = PluginContainer

local PluginPadding = Instance.new("UIPadding")
PluginPadding.PaddingTop = UDim.new(0, 5)
PluginPadding.Parent = PluginContainer

-- Função para criar cards de plugins
local function CreatePluginCard(name, icon, description, callback)
    local card = Instance.new("Frame")
    card.Name = name
    card.BackgroundColor3 = MortalConfig.CardBg
    card.Parent = PluginContainer
    
    CreateCorner(card, 12)
    CreateStroke(card, MortalConfig.AccentColor, 1)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0.5, 0, 0, 15)
    iconLabel.AnchorPoint = Vector2.new(0.5, 0)
    iconLabel.Size = UDim2.new(1, 0, 0, 35)
    iconLabel.Font = MortalConfig.Font
    iconLabel.Text = icon
    iconLabel.TextColor3 = MortalConfig.AccentColor
    iconLabel.TextSize = 28
    iconLabel.Parent = card
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0.5, 0, 0, 55)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Size = UDim2.new(1, -10, 0, 20)
    nameLabel.Font = MortalConfig.Font
    nameLabel.Text = name
    nameLabel.TextColor3 = MortalConfig.TextColor
    nameLabel.TextSize = 13
    nameLabel.TextScaled = true
    nameLabel.Parent = card
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Desc"
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0.5, 0, 0, 75)
    descLabel.AnchorPoint = Vector2.new(0.5, 0)
    descLabel.Size = UDim2.new(1, -15, 0, 25)
    descLabel.Font = MortalConfig.FontLight
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.TextSize = 10
    descLabel.TextWrapped = true
    descLabel.Parent = card
    
    local openBtn = Instance.new("TextButton")
    openBtn.Name = "OpenBtn"
    openBtn.BackgroundColor3 = MortalConfig.AccentColor
    openBtn.Position = UDim2.new(0.5, 0, 1, -35)
    openBtn.AnchorPoint = Vector2.new(0.5, 0)
    openBtn.Size = UDim2.new(0.85, 0, 0, 28)
    openBtn.Font = MortalConfig.Font
    openBtn.Text = "ABRIR ⚡"
    openBtn.TextColor3 = MortalConfig.TextColor
    openBtn.TextSize = 11
    openBtn.Parent = card
    CreateCorner(openBtn, 6)
    CreateGradient(openBtn, MortalConfig.AccentColor, MortalConfig.AccentColor2)
    
    openBtn.MouseEnter:Connect(function()
        Tween(card, {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}, 0.2)
        Tween(openBtn, {Size = UDim2.new(0.9, 0, 0, 30)}, 0.2, Enum.EasingStyle.Back)
    end)
    
    openBtn.MouseLeave:Connect(function()
        Tween(card, {BackgroundColor3 = MortalConfig.CardBg}, 0.2)
        Tween(openBtn, {Size = UDim2.new(0.85, 0, 0, 28)}, 0.2)
    end)
    
    openBtn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return card
end

-- Atualizar CanvasSize
PluginGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PluginContainer.CanvasSize = UDim2.new(0, 0, 0, PluginGrid.AbsoluteContentSize.Y + 20)
end)

-- Botão Toggle Arrastável
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.BackgroundColor3 = MortalConfig.AccentColor
ToggleBtn.Position = UDim2.new(0, 20, 0, 100)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Font = MortalConfig.Font
ToggleBtn.Text = "☠️"
ToggleBtn.TextColor3 = MortalConfig.TextColor
ToggleBtn.TextSize = 28
ToggleBtn.Parent = MortalPlugins
CreateCorner(ToggleBtn, 30)
CreateStroke(ToggleBtn, MortalConfig.SuccessColor, 2)
CreateShadow(ToggleBtn)
CreateGradient(ToggleBtn, MortalConfig.AccentColor, MortalConfig.AccentColor2, 45)

MakeDraggable(ToggleBtn, ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    MainMenuVisible = not MainMenuVisible
    if MainMenuVisible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(MainFrame, {Size = IsMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 650, 0, 500)}, 0.4, Enum.EasingStyle.Back)
    else
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.delay(0.3, function()
            MainFrame.Visible = false
        end)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainMenuVisible = false
    Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    task.delay(0.3, function()
        MainFrame.Visible = false
    end)
end)

-- Variáveis Globais para Plugins
_G.MortalPlugins = _G.MortalPlugins or {}
_G.MortalPlugins.Config = MortalConfig
_G.MortalPlugins.ShowNotification = ShowNotification
_G.MortalPlugins.CreatePluginCard = CreatePluginCard
_G.MortalPlugins.MainFrame = MainFrame
_G.MortalPlugins.Tween = Tween
_G.MortalPlugins.CreateCorner = CreateCorner
_G.MortalPlugins.CreateStroke = CreateStroke
_G.MortalPlugins.CreateGradient = CreateGradient
_G.MortalPlugins.CreateShadow = CreateShadow
_G.MortalPlugins.MakeDraggable = MakeDraggable
_G.MortalPlugins.IsMobile = IsMobile
_G.MortalPlugins.ScreenGui = MortalPlugins

-- Inicialização
task.wait(0.5)
ShowNotification(
    "👑☠️MORTAL PLUGINS V1☠️👑",
    "Sistema carregado com sucesso!\n\nAproveite os plugins profissionais⚡",
    5
)

task.wait(5.5)
MainFrame.Visible = true
MainFrame.Size = UDim2.new(0, 0, 0, 0)
Tween(MainFrame, {Size = IsMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 650, 0, 500)}, 0.5, Enum.EasingStyle.Back)

print("⚡☠️ MORTAL PLUGINS V1 - Menu Principal Carregado ☠️⚡")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    Plugin de Animação Profissional
    Parte 2/3 - Interface Principal
]]

-- Verificar se o sistema base existe
if not _G.MortalPlugins then
    warn("Execute o Menu Principal primeiro!")
    return
end

local Config = _G.MortalPlugins.Config
local ShowNotification = _G.MortalPlugins.ShowNotification
local CreatePluginCard = _G.MortalPlugins.CreatePluginCard
local Tween = _G.MortalPlugins.Tween
local CreateCorner = _G.MortalPlugins.CreateCorner
local CreateStroke = _G.MortalPlugins.CreateStroke
local CreateGradient = _G.MortalPlugins.CreateGradient
local CreateShadow = _G.MortalPlugins.CreateShadow
local MakeDraggable = _G.MortalPlugins.MakeDraggable
local IsMobile = _G.MortalPlugins.IsMobile
local ScreenGui = _G.MortalPlugins.ScreenGui

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")

local Player = Players.LocalPlayer

-- Dados do Animator
local AnimatorData = {
    SelectedRig = nil,
    SelectedParts = {},
    Keyframes = {},
    CurrentFrame = 0,
    TotalFrames = 300,
    FPS = 60,
    IsPlaying = false,
    IsRecording = false,
    TimelineZoom = 1,
    Mode = "Animate" -- Animate, Cutscene
}

-- Criar Frame do Animator
local AnimatorFrame = Instance.new("Frame")
AnimatorFrame.Name = "MortalAnimator"
AnimatorFrame.BackgroundColor3 = Config.MainColor
AnimatorFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
AnimatorFrame.AnchorPoint = Vector2.new(0.5, 0.5)
AnimatorFrame.Size = IsMobile and UDim2.new(0.98, 0, 0.92, 0) or UDim2.new(0, 900, 0, 600)
AnimatorFrame.Visible = false
AnimatorFrame.ZIndex = 10
AnimatorFrame.Parent = ScreenGui

CreateCorner(AnimatorFrame, 16)
CreateStroke(AnimatorFrame, Config.AccentColor, 3)
CreateShadow(AnimatorFrame)
CreateGradient(AnimatorFrame, Config.DarkBg, Config.MainColor, 135)

-- Header do Animator
local AnimHeader = Instance.new("Frame")
AnimHeader.Name = "Header"
AnimHeader.BackgroundColor3 = Config.CardBg
AnimHeader.Size = UDim2.new(1, 0, 0, 50)
AnimHeader.BorderSizePixel = 0
AnimHeader.ZIndex = 11
AnimHeader.Parent = AnimatorFrame

CreateCorner(AnimHeader, 16)
CreateGradient(AnimHeader, Config.AccentColor2, Config.CardBg, 90)

local headerFix = Instance.new("Frame")
headerFix.BackgroundColor3 = Config.CardBg
headerFix.Position = UDim2.new(0, 0, 1, -16)
headerFix.Size = UDim2.new(1, 0, 0, 16)
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 11
headerFix.Parent = AnimHeader

local AnimTitle = Instance.new("TextLabel")
AnimTitle.Name = "Title"
AnimTitle.BackgroundTransparency = 1
AnimTitle.Position = UDim2.new(0, 20, 0, 0)
AnimTitle.Size = UDim2.new(1, -100, 1, 0)
AnimTitle.Font = Config.Font
AnimTitle.Text = "☠️ Mortal Animator V1 ⚡"
AnimTitle.TextColor3 = Config.TextColor
AnimTitle.TextSize = IsMobile and 14 or 18
AnimTitle.TextXAlignment = Enum.TextXAlignment.Left
AnimTitle.ZIndex = 12
AnimTitle.Parent = AnimHeader

MakeDraggable(AnimatorFrame, AnimHeader)

-- Botão Fechar Animator
local CloseAnimBtn = Instance.new("TextButton")
CloseAnimBtn.Name = "CloseBtn"
CloseAnimBtn.BackgroundColor3 = Config.DangerColor
CloseAnimBtn.Position = UDim2.new(1, -45, 0.5, 0)
CloseAnimBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseAnimBtn.Size = UDim2.new(0, 32, 0, 32)
CloseAnimBtn.Font = Config.Font
CloseAnimBtn.Text = "✕"
CloseAnimBtn.TextColor3 = Config.TextColor
CloseAnimBtn.TextSize = 16
CloseAnimBtn.ZIndex = 12
CloseAnimBtn.Parent = AnimHeader
CreateCorner(CloseAnimBtn, 6)

-- Container Principal (dividido em painéis)
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.BackgroundTransparency = 1
MainContainer.Position = UDim2.new(0, 0, 0, 55)
MainContainer.Size = UDim2.new(1, 0, 1, -55)
MainContainer.ZIndex = 10
MainContainer.Parent = AnimatorFrame

-- Painel Esquerdo (Hierarquia/Bones)
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.BackgroundColor3 = Config.CardBg
LeftPanel.Position = UDim2.new(0, 10, 0, 5)
LeftPanel.Size = IsMobile and UDim2.new(0.3, -5, 0.55, -10) or UDim2.new(0, 200, 0.6, -10)
LeftPanel.ZIndex = 11
LeftPanel.Parent = MainContainer

CreateCorner(LeftPanel, 10)
CreateStroke(LeftPanel, Config.AccentColor, 1)

local LeftPanelTitle = Instance.new("TextLabel")
LeftPanelTitle.BackgroundTransparency = 1
LeftPanelTitle.Size = UDim2.new(1, 0, 0, 30)
LeftPanelTitle.Font = Config.Font
LeftPanelTitle.Text = "📦 HIERARQUIA"
LeftPanelTitle.TextColor3 = Config.AccentColor
LeftPanelTitle.TextSize = 12
LeftPanelTitle.ZIndex = 12
LeftPanelTitle.Parent = LeftPanel

local HierarchyScroll = Instance.new("ScrollingFrame")
HierarchyScroll.Name = "HierarchyScroll"
HierarchyScroll.BackgroundTransparency = 1
HierarchyScroll.Position = UDim2.new(0, 5, 0, 35)
HierarchyScroll.Size = UDim2.new(1, -10, 1, -40)
HierarchyScroll.ScrollBarThickness = 3
HierarchyScroll.ScrollBarImageColor3 = Config.AccentColor
HierarchyScroll.ZIndex = 12
HierarchyScroll.Parent = LeftPanel

local HierarchyLayout = Instance.new("UIListLayout")
HierarchyLayout.SortOrder = Enum.SortOrder.Name
HierarchyLayout.Padding = UDim.new(0, 3)
HierarchyLayout.Parent = HierarchyScroll

-- Painel Central (Viewport/Preview)
local CenterPanel = Instance.new("Frame")
CenterPanel.Name = "CenterPanel"
CenterPanel.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
CenterPanel.Position = IsMobile and UDim2.new(0.3, 5, 0, 5) or UDim2.new(0, 220, 0, 5)
CenterPanel.Size = IsMobile and UDim2.new(0.7, -15, 0.55, -10) or UDim2.new(1, -440, 0.6, -10)
CenterPanel.ZIndex = 11
CenterPanel.Parent = MainContainer

CreateCorner(CenterPanel, 10)
CreateStroke(CenterPanel, Config.AccentColor, 1)

local ViewportLabel = Instance.new("TextLabel")
ViewportLabel.BackgroundTransparency = 1
ViewportLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ViewportLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ViewportLabel.Size = UDim2.new(1, 0, 0, 60)
ViewportLabel.Font = Config.FontLight
ViewportLabel.Text = "🎬 VIEWPORT\n\nSelecione um Rig/Objeto no Explorer"
ViewportLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
ViewportLabel.TextSize = 14
ViewportLabel.ZIndex = 12
ViewportLabel.Parent = CenterPanel

-- Painel Direito (Propriedades)
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.BackgroundColor3 = Config.CardBg
RightPanel.Position = UDim2.new(1, -210, 0, 5)
RightPanel.Size = UDim2.new(0, 200, 0.6, -10)
RightPanel.ZIndex = 11
RightPanel.Visible = not IsMobile
RightPanel.Parent = MainContainer

CreateCorner(RightPanel, 10)
CreateStroke(RightPanel, Config.AccentColor, 1)

local RightPanelTitle = Instance.new("TextLabel")
RightPanelTitle.BackgroundTransparency = 1
RightPanelTitle.Size = UDim2.new(1, 0, 0, 30)
RightPanelTitle.Font = Config.Font
RightPanelTitle.Text = "⚙️ PROPRIEDADES"
RightPanelTitle.TextColor3 = Config.AccentColor
RightPanelTitle.TextSize = 12
RightPanelTitle.ZIndex = 12
RightPanelTitle.Parent = RightPanel

local PropertiesScroll = Instance.new("ScrollingFrame")
PropertiesScroll.Name = "PropertiesScroll"
PropertiesScroll.BackgroundTransparency = 1
PropertiesScroll.Position = UDim2.new(0, 5, 0, 35)
PropertiesScroll.Size = UDim2.new(1, -10, 1, -40)
PropertiesScroll.ScrollBarThickness = 3
PropertiesScroll.ScrollBarImageColor3 = Config.AccentColor
PropertiesScroll.ZIndex = 12
PropertiesScroll.Parent = RightPanel

local PropertiesLayout = Instance.new("UIListLayout")
PropertiesLayout.SortOrder = Enum.SortOrder.LayoutOrder
PropertiesLayout.Padding = UDim.new(0, 5)
PropertiesLayout.Parent = PropertiesScroll

-- Timeline Container
local TimelineContainer = Instance.new("Frame")
TimelineContainer.Name = "TimelineContainer"
TimelineContainer.BackgroundColor3 = Config.CardBg
TimelineContainer.Position = IsMobile and UDim2.new(0, 10, 0.55, 0) or UDim2.new(0, 10, 0.6, 0)
TimelineContainer.Size = IsMobile and UDim2.new(1, -20, 0.45, -10) or UDim2.new(1, -20, 0.4, -10)
TimelineContainer.ZIndex = 11
TimelineContainer.Parent = MainContainer

CreateCorner(TimelineContainer, 10)
CreateStroke(TimelineContainer, Config.AccentColor, 1)

-- Toolbar da Timeline
local TimelineToolbar = Instance.new("Frame")
TimelineToolbar.Name = "Toolbar"
TimelineToolbar.BackgroundColor3 = Config.DarkBg
TimelineToolbar.Size = UDim2.new(1, 0, 0, 45)
TimelineToolbar.ZIndex = 12
TimelineToolbar.Parent = TimelineContainer

CreateCorner(TimelineToolbar, 10)

local toolbarFix = Instance.new("Frame")
toolbarFix.BackgroundColor3 = Config.DarkBg
toolbarFix.Position = UDim2.new(0, 0, 1, -10)
toolbarFix.Size = UDim2.new(1, 0, 0, 10)
toolbarFix.BorderSizePixel = 0
toolbarFix.ZIndex = 12
toolbarFix.Parent = TimelineToolbar

-- Botões de Controle de Playback
local function CreateToolbarButton(name, icon, pos, size, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.BackgroundColor3 = Config.CardBg
    btn.Position = pos
    btn.Size = size or UDim2.new(0, 35, 0, 35)
    btn.Font = Config.Font
    btn.Text = icon
    btn.TextColor3 = Config.TextColor
    btn.TextSize = 16
    btn.ZIndex = 13
    btn.Parent = TimelineToolbar
    CreateCorner(btn, 6)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Config.AccentColor}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = Config.CardBg}, 0.2)
    end)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

-- Botões de Playback
local PlayBtn = CreateToolbarButton("Play", "▶️", UDim2.new(0, 10, 0.5, -17))
local PauseBtn = CreateToolbarButton("Pause", "⏸️", UDim2.new(0, 50, 0.5, -17))
local StopBtn = CreateToolbarButton("Stop", "⏹️", UDim2.new(0, 90, 0.5, -17))
local RecordBtn = CreateToolbarButton("Record", "🔴", UDim2.new(0, 130, 0.5, -17))

-- Separador
local Separator1 = Instance.new("Frame")
Separator1.BackgroundColor3 = Config.AccentColor
Separator1.Position = UDim2.new(0, 175, 0.2, 0)
Separator1.Size = UDim2.new(0, 2, 0.6, 0)
Separator1.ZIndex = 13
Separator1.Parent = TimelineToolbar

-- Botões de Keyframe
local AddKeyBtn = CreateToolbarButton("AddKey", "🔑+", UDim2.new(0, 185, 0.5, -17))
local DelKeyBtn = CreateToolbarButton("DelKey", "🔑-", UDim2.new(0, 225, 0.5, -17))
local PrevKeyBtn = CreateToolbarButton("PrevKey", "⏮️", UDim2.new(0, 265, 0.5, -17))
local NextKeyBtn = CreateToolbarButton("NextKey", "⏭️", UDim2.new(0, 305, 0.5, -17))

-- Separador
local Separator2 = Instance.new("Frame")
Separator2.BackgroundColor3 = Config.AccentColor
Separator2.Position = UDim2.new(0, 350, 0.2, 0)
Separator2.Size = UDim2.new(0, 2, 0.6, 0)
Separator2.ZIndex = 13
Separator2.Parent = TimelineToolbar

-- Botões Especiais
local LoopBtn = CreateToolbarButton("Loop", "🔁", UDim2.new(0, 360, 0.5, -17))
local EaseBtn = CreateToolbarButton("Ease", "📈", UDim2.new(0, 400, 0.5, -17))
local CutsceneBtn = CreateToolbarButton("Cutscene", "🎬", UDim2.new(0, 440, 0.5, -17), UDim2.new(0, 100, 0, 35))
CutsceneBtn.Text = "Criar Cutscene⚡"
CutsceneBtn.TextSize = 10

-- FPS Counter
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Name = "FPSLabel"
FPSLabel.BackgroundColor3 = Config.CardBg
FPSLabel.Position = UDim2.new(1, -120, 0.5, -17)
FPSLabel.Size = UDim2.new(0, 60, 0, 35)
FPSLabel.Font = Config.Font
FPSLabel.Text = "60 FPS"
FPSLabel.TextColor3 = Config.SuccessColor
FPSLabel.TextSize = 12
FPSLabel.ZIndex = 13
FPSLabel.Parent = TimelineToolbar
CreateCorner(FPSLabel, 6)

-- Frame Counter
local FrameLabel = Instance.new("TextLabel")
FrameLabel.Name = "FrameLabel"
FrameLabel.BackgroundColor3 = Config.CardBg
FrameLabel.Position = UDim2.new(1, -55, 0.5, -17)
FrameLabel.Size = UDim2.new(0, 45, 0, 35)
FrameLabel.Font = Config.Font
FrameLabel.Text = "0/300"
FrameLabel.TextColor3 = Config.TextColor
FrameLabel.TextSize = 10
FrameLabel.ZIndex = 13
FrameLabel.Parent = TimelineToolbar
CreateCorner(FrameLabel, 6)

-- Timeline Scroll Area
local TimelineScroll = Instance.new("ScrollingFrame")
TimelineScroll.Name = "TimelineScroll"
TimelineScroll.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
TimelineScroll.Position = UDim2.new(0, 5, 0, 50)
TimelineScroll.Size = UDim2.new(1, -10, 1, -55)
TimelineScroll.ScrollBarThickness = 6
TimelineScroll.ScrollBarImageColor3 = Config.AccentColor
TimelineScroll.CanvasSize = UDim2.new(3, 0, 0, 0)
TimelineScroll.ZIndex = 12
TimelineScroll.Parent = TimelineContainer

CreateCorner(TimelineScroll, 8)

-- Linha de Time Indicator
local TimeIndicator = Instance.new("Frame")
TimeIndicator.Name = "TimeIndicator"
TimeIndicator.BackgroundColor3 = Config.DangerColor
TimeIndicator.Position = UDim2.new(0, 50, 0, 0)
TimeIndicator.Size = UDim2.new(0, 2, 1, 0)
TimeIndicator.ZIndex = 20
TimeIndicator.Parent = TimelineScroll

-- Marcadores de Tempo
local TimeRuler = Instance.new("Frame")
TimeRuler.Name = "TimeRuler"
TimeRuler.BackgroundColor3 = Config.CardBg
TimeRuler.Size = UDim2.new(1, 0, 0, 25)
TimeRuler.ZIndex = 13
TimeRuler.Parent = TimelineScroll

for i = 0, 30 do
    local mark = Instance.new("Frame")
    mark.BackgroundColor3 = i % 5 == 0 and Config.AccentColor or Color3.fromRGB(60, 60, 80)
    mark.Position = UDim2.new(0, 50 + i * 30, 0.6, 0)
    mark.Size = UDim2.new(0, 1, 0, i % 5 == 0 and 12 or 6)
    mark.ZIndex = 14
    mark.Parent = TimeRuler
    
    if i % 5 == 0 then
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 50 + i * 30 - 15, 0, 0)
        label.Size = UDim2.new(0, 30, 0, 15)
        label.Font = Config.FontLight
        label.Text = tostring(i * 10)
        label.TextColor3 = Config.TextColor
        label.TextSize = 9
        label.ZIndex = 14
        label.Parent = TimeRuler
    end
end

-- Tracks Container
local TracksContainer = Instance.new("Frame")
TracksContainer.Name = "TracksContainer"
TracksContainer.BackgroundTransparency = 1
TracksContainer.Position = UDim2.new(0, 0, 0, 30)
TracksContainer.Size = UDim2.new(1, 0, 1, -30)
TracksContainer.ZIndex = 13
TracksContainer.Parent = TimelineScroll

local TracksLayout = Instance.new("UIListLayout")
TracksLayout.SortOrder = Enum.SortOrder.LayoutOrder
TracksLayout.Padding = UDim.new(0, 2)
TracksLayout.Parent = TracksContainer

-- Função para criar Track
local function CreateTrack(name, partRef)
    local track = Instance.new("Frame")
    track.Name = name
    track.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    track.Size = UDim2.new(1, 0, 0, 30)
    track.ZIndex = 14
    track.Parent = TracksContainer
    
    local trackLabel = Instance.new("TextLabel")
    trackLabel.BackgroundColor3 = Config.CardBg
    trackLabel.Position = UDim2.new(0, 0, 0, 0)
    trackLabel.Size = UDim2.new(0, 100, 1, 0)
    trackLabel.Font = Config.FontLight
    trackLabel.Text = " " .. name
    trackLabel.TextColor3 = Config.TextColor
    trackLabel.TextSize = 10
    trackLabel.TextXAlignment = Enum.TextXAlignment.Left
    trackLabel.ZIndex = 15
    trackLabel.Parent = track
    
    local keyframeContainer = Instance.new("Frame")
    keyframeContainer.Name = "Keyframes"
    keyframeContainer.BackgroundTransparency = 1
    keyframeContainer.Position = UDim2.new(0, 105, 0, 0)
    keyframeContainer.Size = UDim2.new(1, -105, 1, 0)
    keyframeContainer.ZIndex = 15
    keyframeContainer.Parent = track
    
    -- Linhas de grid
    for i = 1, 30 do
        local gridLine = Instance.new("Frame")
        gridLine.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        gridLine.BackgroundTransparency = 0.7
        gridLine.Position = UDim2.new(0, i * 30, 0, 0)
        gridLine.Size = UDim2.new(0, 1, 1, 0)
        gridLine.ZIndex = 14
        gridLine.Parent = keyframeContainer
    end
    
    return track, keyframeContainer
end

-- Export Button
local ExportBtn = CreateToolbarButton("Export", "📤", UDim2.new(0, 550, 0.5, -17), UDim2.new(0, 70, 0, 35))
ExportBtn.Text = "Export"
ExportBtn.TextSize = 11

-- Guardar referências
_G.MortalPlugins.Animator = {
    Frame = AnimatorFrame,
    Data = AnimatorData,
    CreateTrack = CreateTrack,
    HierarchyScroll = HierarchyScroll,
    TimelineScroll = TimelineScroll,
    TracksContainer = TracksContainer,
    TimeIndicator = TimeIndicator,
    FrameLabel = FrameLabel,
    PropertiesScroll = PropertiesScroll
}

print("⚡☠️ MORTAL ANIMATOR V1 - Interface Carregada ☠️⚡")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    Plugin de Animação Profissional
    Parte 3/3 - Lógica e Funcionalidades
]]

if not _G.MortalPlugins or not _G.MortalPlugins.Animator then
    warn("Execute as partes anteriores primeiro!")
    return
end

local Config = _G.MortalPlugins.Config
local ShowNotification = _G.MortalPlugins.ShowNotification
local Tween = _G.MortalPlugins.Tween
local CreateCorner = _G.MortalPlugins.CreateCorner
local CreateStroke = _G.MortalPlugins.CreateStroke
local CreateGradient = _G.MortalPlugins.CreateGradient
local IsMobile = _G.MortalPlugins.IsMobile
local ScreenGui = _G.MortalPlugins.ScreenGui

local Animator = _G.MortalPlugins.Animator
local AnimatorFrame = Animator.Frame
local AnimatorData = Animator.Data
local CreateTrack = Animator.CreateTrack
local HierarchyScroll = Animator.HierarchyScroll
local TimelineScroll = Animator.TimelineScroll
local TracksContainer = Animator.TracksContainer
local TimeIndicator = Animator.TimeIndicator
local FrameLabel = Animator.FrameLabel
local PropertiesScroll = Animator.PropertiesScroll

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

-- Sistema de Keyframes
local KeyframeSystem = {
    tracks = {},
    keyframes = {},
    selectedKeyframe = nil
}

-- Função para adicionar keyframe visual
local function AddKeyframeVisual(trackContainer, frameNum, data)
    local keyframe = Instance.new("TextButton")
    keyframe.Name = "Keyframe_" .. frameNum
    keyframe.BackgroundColor3 = Config.SuccessColor
    keyframe.Position = UDim2.new(0, (frameNum * 3) - 5, 0.5, -8)
    keyframe.Size = UDim2.new(0, 16, 0, 16)
    keyframe.Text = ""
    keyframe.ZIndex = 18
    keyframe.Parent = trackContainer
    
    CreateCorner(keyframe, 8)
    CreateStroke(keyframe, Color3.fromRGB(255, 255, 255), 2)
    
    -- Efeito de brilho
    local glow = Instance.new("ImageLabel")
    glow.BackgroundTransparency = 1
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Size = UDim2.new(0, 30, 0, 30)
    glow.Image = "rbxassetid://6015897843"
    glow.ImageColor3 = Config.SuccessColor
    glow.ImageTransparency = 0.7
    glow.ZIndex = 17
    glow.Parent = keyframe
    
    keyframe.MouseButton1Click:Connect(function()
        KeyframeSystem.selectedKeyframe = {frame = frameNum, data = data, visual = keyframe}
        AnimatorData.CurrentFrame = frameNum
        TimeIndicator.Position = UDim2.new(0, 50 + (frameNum * 3), 0, 0)
        FrameLabel.Text = frameNum .. "/" .. AnimatorData.TotalFrames
        
        -- Destacar keyframe selecionado
        for _, kf in pairs(trackContainer:GetChildren()) do
            if kf:IsA("TextButton") and kf.Name:find("Keyframe") then
                kf.BackgroundColor3 = Config.SuccessColor
            end
        end
        keyframe.BackgroundColor3 = Config.AccentColor
    end)
    
    return keyframe
end

-- Função para capturar estado atual do objeto
local function CaptureState(obj)
    local state = {}
    
    if obj:IsA("BasePart") then
        state.CFrame = obj.CFrame
        state.Size = obj.Size
        state.Transparency = obj.Transparency
        state.Color = obj.Color
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then
            state.CFrame = obj:GetPrimaryPartCFrame()
        end
        state.Children = {}
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("BasePart") then
                state.Children[child.Name] = {
                    CFrame = child.CFrame,
                    Size = child.Size
                }
            end
        end
    end
    
    return state
end

-- Função para aplicar estado
local function ApplyState(obj, state)
    if obj:IsA("BasePart") and state.CFrame then
        obj.CFrame = state.CFrame
        if state.Size then obj.Size = state.Size end
        if state.Transparency then obj.Transparency = state.Transparency end
        if state.Color then obj.Color = state.Color end
    elseif obj:IsA("Model") and state.CFrame then
        if obj.PrimaryPart then
            obj:SetPrimaryPartCFrame(state.CFrame)
        end
    end
end

-- Função para interpolar entre estados
local function InterpolateStates(state1, state2, alpha)
    local result = {}
    
    if state1.CFrame and state2.CFrame then
        result.CFrame = state1.CFrame:Lerp(state2.CFrame, alpha)
    end
    if state1.Size and state2.Size then
        result.Size = state1.Size:Lerp(state2.Size, alpha)
    end
    if state1.Transparency and state2.Transparency then
        result.Transparency = state1.Transparency + (state2.Transparency - state1.Transparency) * alpha
    end
    if state1.Color and state2.Color then
        result.Color = state1.Color:Lerp(state2.Color, alpha)
    end
    
    return result
end

-- Atualizar Hierarquia
local function UpdateHierarchy()
    for _, child in pairs(HierarchyScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    if not AnimatorData.SelectedRig then return end
    
    local parts = {}
    if AnimatorData.SelectedRig:IsA("Model") then
        for _, part in pairs(AnimatorData.SelectedRig:GetDescendants()) do
            if part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end
    else
        table.insert(parts, AnimatorData.SelectedRig)
    end
    
    for i, part in ipairs(parts) do
        local btn = Instance.new("TextButton")
        btn.Name = part.Name
        btn.BackgroundColor3 = Config.CardBg
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.Font = Config.FontLight
        btn.Text = "  " .. part.Name
        btn.TextColor3 = Config.TextColor
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.ZIndex = 13
        btn.LayoutOrder = i
        btn.Parent = HierarchyScroll
        CreateCorner(btn, 5)
        
        btn.MouseButton1Click:Connect(function()
            AnimatorData.SelectedParts = {part}
            
            for _, child in pairs(HierarchyScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Config.CardBg
                end
            end
            btn.BackgroundColor3 = Config.AccentColor
            
            -- Criar track se não existir
            local trackName = part.Name
            if not KeyframeSystem.tracks[trackName] then
                local track, container = CreateTrack(trackName, part)
                KeyframeSystem.tracks[trackName] = {
                    track = track,
                    container = container,
                    part = part,
                    keyframes = {}
                }
            end
        end)
    end
    
    HierarchyScroll.CanvasSize = UDim2.new(0, 0, 0, #parts * 31)
end

-- Selecionar Rig/Objeto do Studio Lite
local function SelectFromWorkspace()
    local workspace = game:GetService("Workspace")
    
    -- Procurar por modelos/rigs selecionados no Studio Lite
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            -- Verificar se é um rig (tem Humanoid ou MeshParts)
            local isRig = false
            if obj:IsA("Model") then
                isRig = obj:FindFirstChildOfClass("Humanoid") ~= nil or 
                        #obj:GetChildren() > 0
            else
                isRig = true
            end
            
            if isRig then
                -- Criar botão de seleção
                local selectBtn = Instance.new("TextButton")
                selectBtn.Name = obj.Name
                selectBtn.BackgroundColor3 = Config.CardBg
                selectBtn.Size = UDim2.new(1, 0, 0, 30)
                selectBtn.Font = Config.FontLight
                selectBtn.Text = "  📦 " .. obj.Name
                selectBtn.TextColor3 = Config.TextColor
                selectBtn.TextSize = 11
                selectBtn.TextXAlignment = Enum.TextXAlignment.Left
                selectBtn.ZIndex = 13
                selectBtn.Parent = HierarchyScroll
                CreateCorner(selectBtn, 5)
                
                selectBtn.MouseButton1Click:Connect(function()
                    AnimatorData.SelectedRig = obj
                    UpdateHierarchy()
                    ShowNotification("☠️ Rig Selecionado", obj.Name .. " foi selecionado para animação!", 3)
                end)
            end
        end
    end
end

-- Playback System
local playbackConnection = nil

local function PlayAnimation()
    if AnimatorData.IsPlaying then return end
    AnimatorData.IsPlaying = true
    
    local startFrame = AnimatorData.CurrentFrame
    local frameTime = 1 / AnimatorData.FPS
    local lastUpdate = tick()
    
    playbackConnection = RunService.Heartbeat:Connect(function()
        local now = tick()
        if now - lastUpdate >= frameTime then
            lastUpdate = now
            AnimatorData.CurrentFrame = AnimatorData.CurrentFrame + 1
            
            if AnimatorData.CurrentFrame > AnimatorData.TotalFrames then
                AnimatorData.CurrentFrame = 0
            end
            
            -- Atualizar visual
            TimeIndicator.Position = UDim2.new(0, 50 + (AnimatorData.CurrentFrame * 3), 0, 0)
            FrameLabel.Text = AnimatorData.CurrentFrame .. "/" .. AnimatorData.TotalFrames
            
            -- Interpolar animações
            for trackName, trackData in pairs(KeyframeSystem.tracks) do
                local keyframes = trackData.keyframes
                local sortedFrames = {}
                for frame, _ in pairs(keyframes) do
                    table.insert(sortedFrames, frame)
                end
                table.sort(sortedFrames)
                
                local prevFrame, nextFrame = nil, nil
                for i, frame in ipairs(sortedFrames) do
                    if frame <= AnimatorData.CurrentFrame then
                        prevFrame = frame
                    end
                    if frame > AnimatorData.CurrentFrame and not nextFrame then
                        nextFrame = frame
                    end
                end
                
                if prevFrame and nextFrame and keyframes[prevFrame] and keyframes[nextFrame] then
                    local alpha = (AnimatorData.CurrentFrame - prevFrame) / (nextFrame - prevFrame)
                    local interpolated = InterpolateStates(keyframes[prevFrame], keyframes[nextFrame], alpha)
                    ApplyState(trackData.part, interpolated)
                elseif prevFrame and keyframes[prevFrame] then
                    ApplyState(trackData.part, keyframes[prevFrame])
                end
            end
        end
    end)
end

local function PauseAnimation()
    AnimatorData.IsPlaying = false
    if playbackConnection then
        playbackConnection:Disconnect()
        playbackConnection = nil
    end
end

local function StopAnimation()
    PauseAnimation()
    AnimatorData.CurrentFrame = 0
    TimeIndicator.Position = UDim2.new(0, 50, 0, 0)
    FrameLabel.Text = "0/" .. AnimatorData.TotalFrames
end

-- Adicionar Keyframe
local function AddKeyframe()
    if #AnimatorData.SelectedParts == 0 then
        ShowNotification("⚠️ Aviso", "Selecione uma parte primeiro!", 3)
        return
    end
    
    for _, part in pairs(AnimatorData.SelectedParts) do
        local trackName = part.Name
        local trackData = KeyframeSystem.tracks[trackName]
        
        if trackData then
            local state = CaptureState(part)
            trackData.keyframes[AnimatorData.CurrentFrame] = state
            AddKeyframeVisual(trackData.container, AnimatorData.CurrentFrame, state)
            
            ShowNotification("🔑 Keyframe Adicionado", "Frame " .. AnimatorData.CurrentFrame .. " - " .. part.Name, 2)
        end
    end
end

-- Deletar Keyframe
local function DeleteKeyframe()
    if KeyframeSystem.selectedKeyframe then
        local frame = KeyframeSystem.selectedKeyframe.frame
        local visual = KeyframeSystem.selectedKeyframe.visual
        
        for trackName, trackData in pairs(KeyframeSystem.tracks) do
            if trackData.keyframes[frame] then
                trackData.keyframes[frame] = nil
            end
        end
        
        if visual then
            visual:Destroy()
        end
        
        KeyframeSystem.selectedKeyframe = nil
        ShowNotification("🗑️ Keyframe Removido", "Frame " .. frame, 2)
    end
end

-- Gerar código de exportação
local function GenerateExportCode()
    local code = [[
-- ⚡☠️ MORTAL ANIMATOR EXPORT ☠️⚡
-- Animação gerada automaticamente

local TweenService = game:GetService("TweenService")

local AnimationData = {
]]
    
    for trackName, trackData in pairs(KeyframeSystem.tracks) do
        code = code .. string.format('    ["%s"] = {\n', trackName)
        
        local sortedFrames = {}
        for frame, _ in pairs(trackData.keyframes) do
            table.insert(sortedFrames, frame)
        end
        table.sort(sortedFrames)
        
        for _, frame in ipairs(sortedFrames) do
            local state = trackData.keyframes[frame]
            if state.CFrame then
                local cf = state.CFrame
                code = code .. string.format('        [%d] = CFrame.new(%f, %f, %f) * CFrame.Angles(%f, %f, %f),\n', 
                    frame, cf.X, cf.Y, cf.Z, cf:ToEulerAnglesXYZ())
            end
        end
        
        code = code .. "    },\n"
    end
    
    code = code .. [[
}

local function PlayAnimation(model)
    local fps = 60
    local totalFrames = ]] .. AnimatorData.TotalFrames .. [[
    
    for frame = 0, totalFrames do
        for partName, keyframes in pairs(AnimationData) do
            local part = model:FindFirstChild(partName, true)
            if part then
                -- Encontrar frames anterior e próximo
                local prevFrame, nextFrame = nil, nil
                local sortedFrames = {}
                for f, _ in pairs(keyframes) do
                    table.insert(sortedFrames, f)
                end
                table.sort(sortedFrames)
                
                for i, f in ipairs(sortedFrames) do
                    if f <= frame then prevFrame = f end
                    if f > frame and not nextFrame then nextFrame = f end
                end
                
                if prevFrame and nextFrame then
                    local alpha = (frame - prevFrame) / (nextFrame - prevFrame)
                    part.CFrame = keyframes[prevFrame]:Lerp(keyframes[nextFrame], alpha)
                elseif prevFrame then
                    part.CFrame = keyframes[prevFrame]
                end
            end
        end
        task.wait(1/fps)
    end
end

return PlayAnimation
]]
    
    return code
end

-- Menu de Export
local ExportMenu = Instance.new("Frame")
ExportMenu.Name = "ExportMenu"
ExportMenu.BackgroundColor3 = Config.DarkBg
ExportMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
ExportMenu.AnchorPoint = Vector2.new(0.5, 0.5)
ExportMenu.Size = UDim2.new(0, 500, 0, 400)
ExportMenu.Visible = false
ExportMenu.ZIndex = 50
ExportMenu.Parent = ScreenGui

CreateCorner(ExportMenu, 12)
CreateStroke(ExportMenu, Config.AccentColor, 2)

local ExportTitle = Instance.new("TextLabel")
ExportTitle.BackgroundTransparency = 1
ExportTitle.Size = UDim2.new(1, 0, 0, 40)
ExportTitle.Font = Config.Font
ExportTitle.Text = "📤 EXPORTAR ANIMAÇÃO"
ExportTitle.TextColor3 = Config.AccentColor
ExportTitle.TextSize = 16
ExportTitle.ZIndex = 51
ExportTitle.Parent = ExportMenu

local ExportCodeBox = Instance.new("TextBox")
ExportCodeBox.BackgroundColor3 = Config.CardBg
ExportCodeBox.Position = UDim2.new(0.5, 0, 0.5, 0)
ExportCodeBox.AnchorPoint = Vector2.new(0.5, 0.5)
ExportCodeBox.Size = UDim2.new(0.95, 0, 0.7, 0)
ExportCodeBox.Font = Enum.Font.Code
ExportCodeBox.Text = ""
ExportCodeBox.TextColor3 = Config.TextColor
ExportCodeBox.TextSize = 10
ExportCodeBox.TextXAlignment = Enum.TextXAlignment.Left
ExportCodeBox.TextYAlignment = Enum.TextYAlignment.Top
ExportCodeBox.TextWrapped = true
ExportCodeBox.ClearTextOnFocus = false
ExportCodeBox.MultiLine = true
ExportCodeBox.ZIndex = 51
ExportCodeBox.Parent = ExportMenu
CreateCorner(ExportCodeBox, 8)

local CloseExportBtn = Instance.new("TextButton")
CloseExportBtn.BackgroundColor3 = Config.DangerColor
CloseExportBtn.Position = UDim2.new(1, -40, 0, 5)
CloseExportBtn.Size = UDim2.new(0, 35, 0, 35)
CloseExportBtn.Font = Config.Font
CloseExportBtn.Text = "✕"
CloseExportBtn.TextColor3 = Config.TextColor
CloseExportBtn.TextSize = 16
CloseExportBtn.ZIndex = 52
CloseExportBtn.Parent = ExportMenu
CreateCorner(CloseExportBtn, 6)

CloseExportBtn.MouseButton1Click:Connect(function()
    Tween(ExportMenu, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    task.wait(0.3)
    ExportMenu.Visible = false
end)

-- Conectar botões
local PlayBtn = AnimatorFrame:FindFirstChild("TimelineContainer"):FindFirstChild("Toolbar"):FindFirstChild("Play")
local PauseBtn = AnimatorFrame:FindFirstChild("TimelineContainer"):FindFirstChild("Toolbar"):FindFirstChild("Pause")
local StopBtn = AnimatorFrame:FindFirstChild("TimelineContainer"):FindFirstChild("Toolbar"):FindFirstChild("Stop")
local AddKeyBtn = AnimatorFrame:FindFirstChild("TimelineContainer"):FindFirstChild("Toolbar"):FindFirstChild("AddKey")
local DelKeyBtn = AnimatorFrame:FindFirstChild("TimelineContainer"):FindFirstChild("Toolbar"):FindFirstChild("DelKey")
local ExportBtn = AnimatorFrame:FindFirstChild("TimelineContainer"):FindFirstChild("Toolbar"):FindFirstChild("Export")
local CloseAnimBtn = AnimatorFrame:FindFirstChild("Header"):FindFirstChild("CloseBtn")

if PlayBtn then PlayBtn.MouseButton1Click:Connect(PlayAnimation) end
if PauseBtn then PauseBtn.MouseButton1Click:Connect(PauseAnimation) end
if StopBtn then StopBtn.MouseButton1Click:Connect(StopAnimation) end
if AddKeyBtn then AddKeyBtn.MouseButton1Click:Connect(AddKeyframe) end
if DelKeyBtn then DelKeyBtn.MouseButton1Click:Connect(DeleteKeyframe) end

if ExportBtn then
    ExportBtn.MouseButton1Click:Connect(function()
        local code = GenerateExportCode()
        ExportCodeBox.Text = code
        ExportMenu.Visible = true
        ExportMenu.Size = UDim2.new(0, 0, 0, 0)
        Tween(ExportMenu, {Size = UDim2.new(0, 500, 0, 400)}, 0.4, Enum.EasingStyle.Back)
    end)
end

if CloseAnimBtn then
    CloseAnimBtn.MouseButton1Click:Connect(function()
        Tween(AnimatorFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        AnimatorFrame.Visible = false
    end)
end

-- Toggle Button para Animator
local AnimatorToggle = Instance.new("TextButton")
AnimatorToggle.Name = "AnimatorToggle"
AnimatorToggle.BackgroundColor3 = Config.AccentColor
AnimatorToggle.Position = UDim2.new(0, 20, 0, 170)
AnimatorToggle.Size = UDim2.new(0, 55, 0, 55)
AnimatorToggle.Font = Config.Font
AnimatorToggle.Text = "🎬"
AnimatorToggle.TextColor3 = Config.TextColor
AnimatorToggle.TextSize = 24
AnimatorToggle.Visible = false
AnimatorToggle.Parent = ScreenGui
CreateCorner(AnimatorToggle, 30)
CreateStroke(AnimatorToggle, Config.SuccessColor, 2)
CreateGradient(AnimatorToggle, Config.AccentColor2, Config.AccentColor, 45)

_G.MortalPlugins.MakeDraggable(AnimatorToggle, AnimatorToggle)

AnimatorToggle.MouseButton1Click:Connect(function()
    if AnimatorFrame.Visible then
        Tween(AnimatorFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        AnimatorFrame.Visible = false
    else
        AnimatorFrame.Visible = true
        AnimatorFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(AnimatorFrame, {Size = IsMobile and UDim2.new(0.98, 0, 0.92, 0) or UDim2.new(0, 900, 0, 600)}, 0.4, Enum.EasingStyle.Back)
        SelectFromWorkspace()
    end
end)

-- Registrar no menu de plugins
_G.MortalPlugins.CreatePluginCard(
    "Mortal Animator",
    "🎬",
    "Animador profissional AAA para Rigs e Objetos",
    function()
        ShowNotification("👑☠️Mortal Animator☠️👑", "Carregado com Sucesso!\n\nAproveite essa ferramenta profissional nível de jogos de Consoles⚡", 5)
        AnimatorToggle.Visible = true
        
        task.wait(1)
        AnimatorFrame.Visible = true
        AnimatorFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(AnimatorFrame, {Size = IsMobile and UDim2.new(0.98, 0, 0.92, 0) or UDim2.new(0, 900, 0, 600)}, 0.5, Enum.EasingStyle.Back)
        SelectFromWorkspace()
        
        -- Fechar menu principal
        Tween(_G.MortalPlugins.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        _G.MortalPlugins.MainFrame.Visible = false
    end
)

print("⚡☠️ MORTAL ANIMATOR V1 - Lógica Carregada ☠️⚡")
print("✅ Plugin completo e funcional!")



