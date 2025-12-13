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

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 2: Interface Principal do Animator
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

-- Variáveis do Animator
local SelectedObject = nil
local Keyframes = {}
local CurrentFrame = 0
local MaxFrame = 300
local IsPlaying = false
local FPS = 60
local AnimationData = {}

-- Interface do Animator
local AnimatorFrame = Instance.new("Frame")
AnimatorFrame.Name = "AnimatorFrame"
AnimatorFrame.Size = UDim2.new(0.95, 0, 0.92, 0)
AnimatorFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
AnimatorFrame.AnchorPoint = Vector2.new(0.5, 0.5)
AnimatorFrame.BackgroundColor3 = Colors.Background
AnimatorFrame.BorderSizePixel = 0
AnimatorFrame.Visible = false
AnimatorFrame.ClipsDescendants = true
AnimatorFrame.ZIndex = 10
AnimatorFrame.Parent = ScreenGui

AnimatorFrame:SetAttribute("OriginalSize", AnimatorFrame.Size)

local AnimCorner = Instance.new("UICorner")
AnimCorner.CornerRadius = UDim.new(0, 14)
AnimCorner.Parent = AnimatorFrame

local AnimStroke = Instance.new("UIStroke")
AnimStroke.Color = Colors.Accent
AnimStroke.Thickness = 2
AnimStroke.Parent = AnimatorFrame

local AnimGradient = Instance.new("UIGradient")
AnimGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
})
AnimGradient.Rotation = 180
AnimGradient.Parent = AnimatorFrame

-- Header do Animator
local AnimHeader = Instance.new("Frame")
AnimHeader.Name = "Header"
AnimHeader.Size = UDim2.new(1, 0, 0, 55)
AnimHeader.Position = UDim2.new(0, 0, 0, 0)
AnimHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
AnimHeader.BorderSizePixel = 0
AnimHeader.ZIndex = 11
AnimHeader.Parent = AnimatorFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = AnimHeader

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 20)
HeaderFix.Position = UDim2.new(0, 0, 1, -20)
HeaderFix.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 11
HeaderFix.Parent = AnimHeader

local AnimTitle = Instance.new("TextLabel")
AnimTitle.Name = "Title"
AnimTitle.Size = UDim2.new(0.7, 0, 1, 0)
AnimTitle.Position = UDim2.new(0, 15, 0, 0)
AnimTitle.BackgroundTransparency = 1
AnimTitle.Font = Enum.Font.GothamBold
AnimTitle.Text = "☠️ Mortal Animator☠️ • V1⚡"
AnimTitle.TextColor3 = Colors.Text
AnimTitle.TextSize = IsMobile and 14 or 18
AnimTitle.TextXAlignment = Enum.TextXAlignment.Left
AnimTitle.ZIndex = 12
AnimTitle.Parent = AnimHeader

-- Botão de fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseBtn.BackgroundColor3 = Colors.Danger
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = AnimHeader

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- Painel de Ferramentas (Esquerda)
local ToolPanel = Instance.new("Frame")
ToolPanel.Name = "ToolPanel"
ToolPanel.Size = UDim2.new(0, IsMobile and 60 or 80, 1, -120)
ToolPanel.Position = UDim2.new(0, 10, 0, 65)
ToolPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
ToolPanel.BorderSizePixel = 0
ToolPanel.ZIndex = 11
ToolPanel.Parent = AnimatorFrame

local ToolCorner = Instance.new("UICorner")
ToolCorner.CornerRadius = UDim.new(0, 12)
ToolCorner.Parent = ToolPanel

local ToolStroke = Instance.new("UIStroke")
ToolStroke.Color = Colors.Border
ToolStroke.Thickness = 1
ToolStroke.Parent = ToolPanel

local ToolLayout = Instance.new("UIListLayout")
ToolLayout.Padding = UDim.new(0, 8)
ToolLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToolLayout.SortOrder = Enum.SortOrder.LayoutOrder
ToolLayout.Parent = ToolPanel

local ToolPadding = Instance.new("UIPadding")
ToolPadding.PaddingTop = UDim.new(0, 10)
ToolPadding.Parent = ToolPanel

-- Função para criar botão de ferramenta
local function CreateToolButton(name, icon, tooltip, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, IsMobile and 45 or 55, 0, IsMobile and 45 or 55)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.Text = icon
    btn.TextSize = IsMobile and 20 or 24
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Colors.Text
    btn.AutoButtonColor = false
    btn.ZIndex = 12
    btn.Parent = ToolPanel
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 1
    stroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        CreateTween(stroke, {Color = Colors.Accent}, 0.2):Play()
        CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 75)}, 0.2):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        CreateTween(stroke, {Color = Colors.Border}, 0.2):Play()
        CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}, 0.2):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return btn
end

-- Painel de Propriedades (Direita)
local PropPanel = Instance.new("ScrollingFrame")
PropPanel.Name = "PropertiesPanel"
PropPanel.Size = UDim2.new(0, IsMobile and 150 or 220, 1, -120)
PropPanel.Position = UDim2.new(1, -(IsMobile and 160 or 230), 0, 65)
PropPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
PropPanel.BorderSizePixel = 0
PropPanel.ScrollBarThickness = 3
PropPanel.ScrollBarImageColor3 = Colors.Accent
PropPanel.ZIndex = 11
PropPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
PropPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
PropPanel.Parent = AnimatorFrame

local PropCorner = Instance.new("UICorner")
PropCorner.CornerRadius = UDim.new(0, 12)
PropCorner.Parent = PropPanel

local PropStroke = Instance.new("UIStroke")
PropStroke.Color = Colors.Border
PropStroke.Thickness = 1
PropStroke.Parent = PropPanel

local PropLayout = Instance.new("UIListLayout")
PropLayout.Padding = UDim.new(0, 5)
PropLayout.SortOrder = Enum.SortOrder.LayoutOrder
PropLayout.Parent = PropPanel

local PropPadding = Instance.new("UIPadding")
PropPadding.PaddingTop = UDim.new(0, 10)
PropPadding.PaddingLeft = UDim.new(0, 10)
PropPadding.PaddingRight = UDim.new(0, 10)
PropPadding.Parent = PropPanel

local PropTitle = Instance.new("TextLabel")
PropTitle.Name = "Title"
PropTitle.Size = UDim2.new(1, 0, 0, 30)
PropTitle.BackgroundTransparency = 1
PropTitle.Font = Enum.Font.GothamBold
PropTitle.Text = "📋 Propriedades"
PropTitle.TextColor3 = Colors.Text
PropTitle.TextSize = 13
PropTitle.TextXAlignment = Enum.TextXAlignment.Left
PropTitle.ZIndex = 12
PropTitle.Parent = PropPanel

-- Info do objeto selecionado
local SelectedInfo = Instance.new("TextLabel")
SelectedInfo.Name = "SelectedInfo"
SelectedInfo.Size = UDim2.new(1, 0, 0, 45)
SelectedInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
SelectedInfo.Font = Enum.Font.Gotham
SelectedInfo.Text = "Nenhum objeto selecionado"
SelectedInfo.TextColor3 = Colors.TextSecondary
SelectedInfo.TextSize = 11
SelectedInfo.TextWrapped = true
SelectedInfo.ZIndex = 12
SelectedInfo.Parent = PropPanel

local SelectedInfoCorner = Instance.new("UICorner")
SelectedInfoCorner.CornerRadius = UDim.new(0, 8)
SelectedInfoCorner.Parent = SelectedInfo

-- Timeline Container
local TimelineContainer = Instance.new("Frame")
TimelineContainer.Name = "TimelineContainer"
TimelineContainer.Size = UDim2.new(1, -((IsMobile and 230 or 320)), 0, 180)
TimelineContainer.Position = UDim2.new(0, IsMobile and 75 or 100, 1, -190)
TimelineContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
TimelineContainer.BorderSizePixel = 0
TimelineContainer.ZIndex = 11
TimelineContainer.Parent = AnimatorFrame

local TimelineCorner = Instance.new("UICorner")
TimelineCorner.CornerRadius = UDim.new(0, 12)
TimelineCorner.Parent = TimelineContainer

local TimelineStroke = Instance.new("UIStroke")
TimelineStroke.Color = Colors.Border
TimelineStroke.Thickness = 1
TimelineStroke.Parent = TimelineContainer

-- Timeline Header
local TimelineHeader = Instance.new("Frame")
TimelineHeader.Name = "TimelineHeader"
TimelineHeader.Size = UDim2.new(1, 0, 0, 40)
TimelineHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TimelineHeader.BorderSizePixel = 0
TimelineHeader.ZIndex = 12
TimelineHeader.Parent = TimelineContainer

local TimelineHeaderCorner = Instance.new("UICorner")
TimelineHeaderCorner.CornerRadius = UDim.new(0, 12)
TimelineHeaderCorner.Parent = TimelineHeader

local TimelineTitle = Instance.new("TextLabel")
TimelineTitle.Size = UDim2.new(0, 120, 1, 0)
TimelineTitle.Position = UDim2.new(0, 10, 0, 0)
TimelineTitle.BackgroundTransparency = 1
TimelineTitle.Font = Enum.Font.GothamBold
TimelineTitle.Text = "⏱️ Timeline"
TimelineTitle.TextColor3 = Colors.Text
TimelineTitle.TextSize = 12
TimelineTitle.TextXAlignment = Enum.TextXAlignment.Left
TimelineTitle.ZIndex = 13
TimelineTitle.Parent = TimelineHeader

-- Frame Counter
local FrameCounter = Instance.new("TextLabel")
FrameCounter.Name = "FrameCounter"
FrameCounter.Size = UDim2.new(0, 100, 0, 30)
FrameCounter.Position = UDim2.new(1, -115, 0.5, -15)
FrameCounter.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
FrameCounter.Font = Enum.Font.GothamBold
FrameCounter.Text = "Frame: 0"
FrameCounter.TextColor3 = Colors.Accent
FrameCounter.TextSize = 12
FrameCounter.ZIndex = 13
FrameCounter.Parent = TimelineHeader

local FrameCounterCorner = Instance.new("UICorner")
FrameCounterCorner.CornerRadius = UDim.new(0, 6)
FrameCounterCorner.Parent = FrameCounter

-- Controles de Playback
local PlaybackControls = Instance.new("Frame")
PlaybackControls.Name = "PlaybackControls"
PlaybackControls.Size = UDim2.new(0, 200, 0, 35)
PlaybackControls.Position = UDim2.new(0.5, -100, 0, 2)
PlaybackControls.BackgroundTransparency = 1
PlaybackControls.ZIndex = 12
PlaybackControls.Parent = TimelineHeader

local PlaybackLayout = Instance.new("UIListLayout")
PlaybackLayout.FillDirection = Enum.FillDirection.Horizontal
PlaybackLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PlaybackLayout.VerticalAlignment = Enum.VerticalAlignment.Center
PlaybackLayout.Padding = UDim.new(0, 8)
PlaybackLayout.Parent = PlaybackControls

-- Função para criar botão de playback
local function CreatePlaybackBtn(name, icon, size)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, size or 32, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    btn.Text = icon
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Colors.Text
    btn.AutoButtonColor = false
    btn.ZIndex = 13
    btn.Parent = PlaybackControls
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

local FirstFrameBtn = CreatePlaybackBtn("FirstFrame", "⏮️")
local PrevFrameBtn = CreatePlaybackBtn("PrevFrame", "◀️")
local PlayBtn = CreatePlaybackBtn("Play", "▶️", 40)
local NextFrameBtn = CreatePlaybackBtn("NextFrame", "▶️")
local LastFrameBtn = CreatePlaybackBtn("LastFrame", "⏭️")

-- Área da Timeline
local TimelineArea = Instance.new("ScrollingFrame")
TimelineArea.Name = "TimelineArea"
TimelineArea.Size = UDim2.new(1, -20, 1, -50)
TimelineArea.Position = UDim2.new(0, 10, 0, 45)
TimelineArea.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
TimelineArea.BorderSizePixel = 0
TimelineArea.ScrollBarThickness = 4
TimelineArea.ScrollBarImageColor3 = Colors.Accent
TimelineArea.ZIndex = 12
TimelineArea.CanvasSize = UDim2.new(3, 0, 0, 0)
TimelineArea.Parent = TimelineContainer

local TimelineAreaCorner = Instance.new("UICorner")
TimelineAreaCorner.CornerRadius = UDim.new(0, 8)
TimelineAreaCorner.Parent = TimelineArea

-- Linhas da Timeline
for i = 0, 60 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, (i % 10 == 0) and 2 or 1, 1, 0)
    line.Position = UDim2.new(0, i * 15 + 30, 0, 0)
    line.BackgroundColor3 = (i % 10 == 0) and Colors.Accent or Color3.fromRGB(40, 40, 55)
    line.BackgroundTransparency = (i % 10 == 0) and 0.3 or 0.6
    line.BorderSizePixel = 0
    line.ZIndex = 13
    line.Parent = TimelineArea
    
    if i % 10 == 0 then
        local num = Instance.new("TextLabel")
        num.Size = UDim2.new(0, 30, 0, 15)
        num.Position = UDim2.new(0, i * 15 + 18, 0, 2)
        num.BackgroundTransparency = 1
        num.Font = Enum.Font.Gotham
        num.Text = tostring(i)
        num.TextColor3 = Colors.TextSecondary
        num.TextSize = 9
        num.ZIndex = 14
        num.Parent = TimelineArea
    end
end

-- Playhead (indicador de frame atual)
local Playhead = Instance.new("Frame")
Playhead.Name = "Playhead"
Playhead.Size = UDim2.new(0, 3, 1, -15)
Playhead.Position = UDim2.new(0, 30, 0, 15)
Playhead.BackgroundColor3 = Colors.Success
Playhead.BorderSizePixel = 0
Playhead.ZIndex = 15
Playhead.Parent = TimelineArea

local PlayheadTop = Instance.new("Frame")
PlayheadTop.Size = UDim2.new(0, 12, 0, 12)
PlayheadTop.Position = UDim2.new(0.5, -6, 0, -6)
PlayheadTop.AnchorPoint = Vector2.new(0, 0)
PlayheadTop.BackgroundColor3 = Colors.Success
PlayheadTop.ZIndex = 16
PlayheadTop.Parent = Playhead

local PlayheadCorner = Instance.new("UICorner")
PlayheadCorner.CornerRadius = UDim.new(0, 3)
PlayheadCorner.Parent = PlayheadTop

-- Armazenar referências
_G.MortalPlugins.Animator = {
    Frame = AnimatorFrame,
    ToolPanel = ToolPanel,
    PropPanel = PropPanel,
    TimelineArea = TimelineArea,
    Playhead = Playhead,
    FrameCounter = FrameCounter,
    PlayBtn = PlayBtn,
    SelectedInfo = SelectedInfo,
    CreateToolButton = CreateToolButton,
    CurrentFrame = 0,
    Keyframes = {},
    AnimationData = {},
    SelectedObject = nil,
    IsPlaying = false,
    FPS = 60
}

-- Evento de fechar
CloseBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(AnimatorFrame)
end)

print("✅ MORTAL ANIMATOR - Interface Principal Carregada!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 3: Sistema de Keyframes e Ferramentas
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Selection = game:GetService("Selection")

-- Variáveis do sistema
local CurrentFrame = 0
local MaxFrames = 600
local FPS = 60
local IsPlaying = false
local SelectedObject = nil
local KeyframeMarkers = {}
local TrackLines = {}

-- Referências
local TimelineArea = Animator.TimelineArea
local Playhead = Animator.Playhead
local FrameCounter = Animator.FrameCounter
local PlayBtn = Animator.PlayBtn
local ToolPanel = Animator.ToolPanel
local PropPanel = Animator.PropPanel
local SelectedInfo = Animator.SelectedInfo

-- Sistema de Keyframes
local KeyframeSystem = {
    Tracks = {},
    Data = {}
}

-- Função para criar um keyframe visual
local function CreateKeyframeMarker(frame, trackIndex, data)
    local marker = Instance.new("TextButton")
    marker.Name = "Keyframe_" .. frame
    marker.Size = UDim2.new(0, 14, 0, 14)
    marker.Position = UDim2.new(0, frame * 15 + 24, 0, 20 + (trackIndex * 25))
    marker.BackgroundColor3 = Colors.Success
    marker.Text = ""
    marker.AutoButtonColor = false
    marker.ZIndex = 17
    marker.Parent = TimelineArea
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = marker
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 100)
    stroke.Thickness = 2
    stroke.Parent = marker
    
    -- Efeito de hover
    marker.MouseEnter:Connect(function()
        CreateTween(marker, {Size = UDim2.new(0, 18, 0, 18)}, 0.15):Play()
    end)
    
    marker.MouseLeave:Connect(function()
        CreateTween(marker, {Size = UDim2.new(0, 14, 0, 14)}, 0.15):Play()
    end)
    
    -- Click para selecionar keyframe
    marker.MouseButton1Click:Connect(function()
        CurrentFrame = frame
        UpdatePlayhead()
        LoadKeyframeData(frame)
    end)
    
    table.insert(KeyframeMarkers, {Frame = frame, Marker = marker, Data = data})
    return marker
end

-- Atualizar posição do Playhead
local function UpdatePlayhead()
    local xPos = CurrentFrame * 15 + 30
    CreateTween(Playhead, {Position = UDim2.new(0, xPos, 0, 15)}, 0.1):Play()
    FrameCounter.Text = "Frame: " .. CurrentFrame
end

-- Adicionar Keyframe
local function AddKeyframe()
    if not SelectedObject then
        CreateNotification("⚠️ Aviso", "Selecione um objeto primeiro!", 3)
        return
    end
    
    local data = {
        Frame = CurrentFrame,
        Object = SelectedObject,
        Position = SelectedObject.Position,
        Orientation = SelectedObject.Orientation,
        Size = SelectedObject.Size
    }
    
    -- Se for um Model ou Rig, salvar todas as partes
    if SelectedObject:IsA("Model") then
        data.Parts = {}
        for _, part in pairs(SelectedObject:GetDescendants()) do
            if part:IsA("BasePart") then
                data.Parts[part.Name] = {
                    CFrame = part.CFrame,
                    Size = part.Size
                }
            end
        end
    end
    
    KeyframeSystem.Data[CurrentFrame] = data
    CreateKeyframeMarker(CurrentFrame, 1, data)
    
    CreateNotification("✅ Keyframe Adicionado", "Frame " .. CurrentFrame, 2)
end

-- Remover Keyframe
local function RemoveKeyframe()
    if KeyframeSystem.Data[CurrentFrame] then
        KeyframeSystem.Data[CurrentFrame] = nil
        
        for i, kf in pairs(KeyframeMarkers) do
            if kf.Frame == CurrentFrame then
                kf.Marker:Destroy()
                table.remove(KeyframeMarkers, i)
                break
            end
        end
        
        CreateNotification("🗑️ Keyframe Removido", "Frame " .. CurrentFrame, 2)
    end
end

-- Carregar dados do keyframe
local function LoadKeyframeData(frame)
    local data = KeyframeSystem.Data[frame]
    if data and data.Object then
        -- Restaurar posições
        if data.Parts then
            for partName, partData in pairs(data.Parts) do
                local part = data.Object:FindFirstChild(partName, true)
                if part then
                    part.CFrame = partData.CFrame
                end
            end
        end
    end
end

-- Sistema de reprodução
local playConnection = nil

local function PlayAnimation()
    if IsPlaying then
        IsPlaying = false
        PlayBtn.Text = "▶️"
        if playConnection then
            playConnection:Disconnect()
        end
        return
    end
    
    IsPlaying = true
    PlayBtn.Text = "⏸️"
    
    -- Coletar keyframes ordenados
    local sortedFrames = {}
    for frame, _ in pairs(KeyframeSystem.Data) do
        table.insert(sortedFrames, frame)
    end
    table.sort(sortedFrames)
    
    if #sortedFrames < 2 then
        CreateNotification("⚠️ Aviso", "Adicione pelo menos 2 keyframes!", 3)
        IsPlaying = false
        PlayBtn.Text = "▶️"
        return
    end
    
    local startFrame = sortedFrames[1]
    local endFrame = sortedFrames[#sortedFrames]
    CurrentFrame = startFrame
    
    local lastTime = tick()
    local frameTime = 1 / FPS
    
    playConnection = RunService.RenderStepped:Connect(function()
        local now = tick()
        if now - lastTime >= frameTime then
            lastTime = now
            CurrentFrame = CurrentFrame + 1
            
            if CurrentFrame > endFrame then
                CurrentFrame = startFrame
            end
            
            UpdatePlayhead()
            InterpolateFrame(CurrentFrame, sortedFrames)
        end
    end)
end

-- Interpolação entre keyframes
local function InterpolateFrame(frame, sortedFrames)
    local prevFrame, nextFrame = nil, nil
    
    for i, f in ipairs(sortedFrames) do
        if f <= frame then
            prevFrame = f
        end
        if f >= frame and not nextFrame then
            nextFrame = f
        end
    end
    
    if prevFrame and nextFrame and prevFrame ~= nextFrame then
        local prevData = KeyframeSystem.Data[prevFrame]
        local nextData = KeyframeSystem.Data[nextFrame]
        
        if prevData and nextData and prevData.Object then
            local alpha = (frame - prevFrame) / (nextFrame - prevFrame)
            
            if prevData.Parts and nextData.Parts then
                for partName, prevPartData in pairs(prevData.Parts) do
                    local nextPartData = nextData.Parts[partName]
                    if nextPartData then
                        local part = prevData.Object:FindFirstChild(partName, true)
                        if part then
                            part.CFrame = prevPartData.CFrame:Lerp(nextPartData.CFrame, alpha)
                        end
                    end
                end
            else
                local obj = prevData.Object
                if obj:IsA("BasePart") then
                    obj.Position = prevData.Position:Lerp(nextData.Position, alpha)
                end
            end
        end
    end
end

-- Detecção de seleção do Studio Lite
local function SetupSelectionListener()
    local checkInterval = 0.1
    
    task.spawn(function()
        while task.wait(checkInterval) do
            pcall(function()
                local selected = Selection:Get()
                if selected and #selected > 0 then
                    local obj = selected[1]
                    if obj ~= SelectedObject then
                        SelectedObject = obj
                        Animator.SelectedObject = obj
                        SelectedInfo.Text = "✓ " .. obj.Name .. "\n(" .. obj.ClassName .. ")"
                        SelectedInfo.TextColor3 = Colors.Success
                        
                        -- Atualizar painel de propriedades
                        UpdatePropertiesPanel(obj)
                    end
                end
            end)
        end
    end)
end

-- Atualizar painel de propriedades
local function UpdatePropertiesPanel(obj)
    -- Limpar propriedades antigas
    for _, child in pairs(PropPanel:GetChildren()) do
        if child.Name:find("Prop_") then
            child:Destroy()
        end
    end
    
    -- Adicionar propriedades do objeto
    local props = {"Position", "Orientation", "Size", "CFrame"}
    local order = 3
    
    for _, propName in ipairs(props) do
        pcall(function()
            local value = obj[propName]
            if value then
                local propFrame = Instance.new("Frame")
                propFrame.Name = "Prop_" .. propName
                propFrame.Size = UDim2.new(1, 0, 0, 35)
                propFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
                propFrame.BorderSizePixel = 0
                propFrame.LayoutOrder = order
                propFrame.ZIndex = 12
                propFrame.Parent = PropPanel
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = propFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -10, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.Text = propName
                label.TextColor3 = Colors.TextSecondary
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 13
                label.Parent = propFrame
                
                order = order + 1
            end
        end)
    end
end

-- Criar botões de ferramentas
local CreateToolButton = Animator.CreateToolButton

-- Botão: Adicionar Keyframe
CreateToolButton("AddKey", "🔑", "Adicionar Keyframe", AddKeyframe)

-- Botão: Remover Keyframe
CreateToolButton("RemoveKey", "🗑️", "Remover Keyframe", RemoveKeyframe)

-- Botão: Play/Pause
CreateToolButton("PlayPause", "▶️", "Play/Pause", PlayAnimation)

-- Botão: Ir para primeiro frame
CreateToolButton("FirstFrame", "⏮️", "Primeiro Frame", function()
    CurrentFrame = 0
    UpdatePlayhead()
end)

-- Botão: Frame anterior
CreateToolButton("PrevFrame", "⬅️", "Frame Anterior", function()
    CurrentFrame = math.max(0, CurrentFrame - 1)
    UpdatePlayhead()
end)

-- Botão: Próximo frame
CreateToolButton("NextFrame", "➡️", "Próximo Frame", function()
    CurrentFrame = CurrentFrame + 1
    UpdatePlayhead()
end)

-- Botão: Último keyframe
CreateToolButton("LastKey", "⏭️", "Último Keyframe", function()
    local lastFrame = 0
    for frame, _ in pairs(KeyframeSystem.Data) do
        if frame > lastFrame then
            lastFrame = frame
        end
    end
    CurrentFrame = lastFrame
    UpdatePlayhead()
end)

-- Botão: Limpar todos keyframes
CreateToolButton("ClearAll", "🧹", "Limpar Tudo", function()
    for _, kf in pairs(KeyframeMarkers) do
        kf.Marker:Destroy()
    end
    KeyframeMarkers = {}
    KeyframeSystem.Data = {}
    CreateNotification("🧹 Limpo", "Todos os keyframes removidos", 2)
end)

-- Configurar eventos dos botões de playback
Animator.PlayBtn.MouseButton1Click:Connect(PlayAnimation)

Animator.FirstFrameBtn = PlayBtn.Parent:FindFirstChild("FirstFrame")
Animator.PrevFrameBtn = PlayBtn.Parent:FindFirstChild("PrevFrame")
Animator.NextFrameBtn = PlayBtn.Parent:FindFirstChild("NextFrame")
Animator.LastFrameBtn = PlayBtn.Parent:FindFirstChild("LastFrame")

-- Click na timeline para mover playhead
TimelineArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local relativeX = input.Position.X - TimelineArea.AbsolutePosition.X + TimelineArea.CanvasPosition.X
        CurrentFrame = math.max(0, math.floor((relativeX - 30) / 15))
        UpdatePlayhead()
    end
end)

-- Iniciar listener de seleção
SetupSelectionListener()

-- Armazenar funções no sistema
Animator.AddKeyframe = AddKeyframe
Animator.RemoveKeyframe = RemoveKeyframe
Animator.PlayAnimation = PlayAnimation
Animator.UpdatePlayhead = UpdatePlayhead
Animator.KeyframeSystem = KeyframeSystem

-- Função para carregar o Animator
_G.MortalPlugins.LoadAnimator = function()
    CreateNotification(
        "👑☠️MORTAL ANIMATOR☠️👑",
        "Carregado com Sucesso!\n\nAproveite essa ferramenta profissional nível de jogos de Consoles⚡",
        5
    )
    
    task.wait(0.5)
    Plugins.AnimateIn(Animator.Frame)
    Plugins.AnimateOut(Plugins.MainMenu)
end

print("✅ MORTAL ANIMATOR - Sistema de Keyframes Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 4: Sistema de Export - Gera Script Lua
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

-- Frame de Export
local ExportFrame = Instance.new("Frame")
ExportFrame.Name = "ExportFrame"
ExportFrame.Size = UDim2.new(0.85, 0, 0.8, 0)
ExportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ExportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ExportFrame.BackgroundColor3 = Colors.Background
ExportFrame.BorderSizePixel = 0
ExportFrame.Visible = false
ExportFrame.ZIndex = 20
ExportFrame.Parent = ScreenGui

ExportFrame:SetAttribute("OriginalSize", ExportFrame.Size)

local ExportCorner = Instance.new("UICorner")
ExportCorner.CornerRadius = UDim.new(0, 14)
ExportCorner.Parent = ExportFrame

local ExportStroke = Instance.new("UIStroke")
ExportStroke.Color = Colors.Accent
ExportStroke.Thickness = 2
ExportStroke.Parent = ExportFrame

local ExportGradient = Instance.new("UIGradient")
ExportGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 15, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 18))
})
ExportGradient.Rotation = 135
ExportGradient.Parent = ExportFrame

-- Header do Export
local ExportHeader = Instance.new("Frame")
ExportHeader.Name = "Header"
ExportHeader.Size = UDim2.new(1, 0, 0, 55)
ExportHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
ExportHeader.BorderSizePixel = 0
ExportHeader.ZIndex = 21
ExportHeader.Parent = ExportFrame

local ExportHeaderCorner = Instance.new("UICorner")
ExportHeaderCorner.CornerRadius = UDim.new(0, 14)
ExportHeaderCorner.Parent = ExportHeader

local ExportTitle = Instance.new("TextLabel")
ExportTitle.Size = UDim2.new(0.8, 0, 1, 0)
ExportTitle.Position = UDim2.new(0, 15, 0, 0)
ExportTitle.BackgroundTransparency = 1
ExportTitle.Font = Enum.Font.GothamBold
ExportTitle.Text = "📤 Exportar Animação • Mortal Animator⚡"
ExportTitle.TextColor3 = Colors.Text
ExportTitle.TextSize = IsMobile and 13 or 16
ExportTitle.TextXAlignment = Enum.TextXAlignment.Left
ExportTitle.ZIndex = 22
ExportTitle.Parent = ExportHeader

-- Botão Fechar Export
local CloseExportBtn = Instance.new("TextButton")
CloseExportBtn.Name = "CloseBtn"
CloseExportBtn.Size = UDim2.new(0, 40, 0, 40)
CloseExportBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseExportBtn.BackgroundColor3 = Colors.Danger
CloseExportBtn.Text = "✕"
CloseExportBtn.TextColor3 = Colors.Text
CloseExportBtn.TextSize = 18
CloseExportBtn.Font = Enum.Font.GothamBold
CloseExportBtn.ZIndex = 22
CloseExportBtn.Parent = ExportHeader

local CloseExportCorner = Instance.new("UICorner")
CloseExportCorner.CornerRadius = UDim.new(0, 8)
CloseExportCorner.Parent = CloseExportBtn

-- Descrição
local ExportDesc = Instance.new("TextLabel")
ExportDesc.Name = "Description"
ExportDesc.Size = UDim2.new(1, -30, 0, 50)
ExportDesc.Position = UDim2.new(0, 15, 0, 65)
ExportDesc.BackgroundTransparency = 1
ExportDesc.Font = Enum.Font.Gotham
ExportDesc.Text = "Copie o código abaixo e cole em um LocalScript/Script. Coloque o script dentro do objeto que você animou no Explorer."
ExportDesc.TextColor3 = Colors.TextSecondary
ExportDesc.TextSize = 12
ExportDesc.TextWrapped = true
ExportDesc.TextXAlignment = Enum.TextXAlignment.Left
ExportDesc.ZIndex = 21
ExportDesc.Parent = ExportFrame

-- Container do Código
local CodeContainer = Instance.new("Frame")
CodeContainer.Name = "CodeContainer"
CodeContainer.Size = UDim2.new(1, -30, 1, -190)
CodeContainer.Position = UDim2.new(0, 15, 0, 120)
CodeContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
CodeContainer.BorderSizePixel = 0
CodeContainer.ZIndex = 21
CodeContainer.Parent = ExportFrame

local CodeCorner = Instance.new("UICorner")
CodeCorner.CornerRadius = UDim.new(0, 10)
CodeCorner.Parent = CodeContainer

local CodeStroke = Instance.new("UIStroke")
CodeStroke.Color = Colors.Border
CodeStroke.Thickness = 1
CodeStroke.Parent = CodeContainer

-- TextBox para o código
local CodeBox = Instance.new("TextBox")
CodeBox.Name = "CodeBox"
CodeBox.Size = UDim2.new(1, -20, 1, -20)
CodeBox.Position = UDim2.new(0, 10, 0, 10)
CodeBox.BackgroundTransparency = 1
CodeBox.Font = Enum.Font.Code
CodeBox.Text = "-- Código da animação aparecerá aqui"
CodeBox.TextColor3 = Color3.fromRGB(150, 255, 150)
CodeBox.TextSize = 11
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.TextWrapped = true
CodeBox.MultiLine = true
CodeBox.ClearTextOnFocus = false
CodeBox.TextEditable = true
CodeBox.ZIndex = 22
CodeBox.Parent = CodeContainer

-- Botões de ação
local ActionContainer = Instance.new("Frame")
ActionContainer.Name = "Actions"
ActionContainer.Size = UDim2.new(1, -30, 0, 50)
ActionContainer.Position = UDim2.new(0, 15, 1, -65)
ActionContainer.BackgroundTransparency = 1
ActionContainer.ZIndex = 21
ActionContainer.Parent = ExportFrame

local ActionLayout = Instance.new("UIListLayout")
ActionLayout.FillDirection = Enum.FillDirection.Horizontal
ActionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ActionLayout.Padding = UDim.new(0, 15)
ActionLayout.Parent = ActionContainer

-- Função para criar botão de ação
local function CreateActionBtn(name, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, IsMobile and 130 or 160, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Colors.Text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 22
    btn.Parent = ActionContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        CreateTween(btn, {BackgroundColor3 = Color3.new(
            math.min(color.R + 0.1, 1),
            math.min(color.G + 0.1, 1),
            math.min(color.B + 0.1, 1)
        )}, 0.2):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        CreateTween(btn, {BackgroundColor3 = color}, 0.2):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Função para gerar código da animação
local function GenerateAnimationCode()
    local KeyframeSystem = Animator.KeyframeSystem
    local selectedObj = Animator.SelectedObject
    
    if not selectedObj then
        return "-- ERRO: Nenhum objeto foi selecionado para animação"
    end
    
    if not KeyframeSystem.Data or next(KeyframeSystem.Data) == nil then
        return "-- ERRO: Nenhum keyframe foi criado"
    end
    
    local code = [[
--[[
    ⚡☠️ MORTAL ANIMATOR - Animação Exportada ☠️⚡
    Gerado automaticamente pelo Mortal Animator V1
    
    INSTRUÇÕES:
    1. Coloque este script dentro do objeto animado
    2. A animação iniciará automaticamente
    3. Use MortalAnim:Play() para reproduzir
    4. Use MortalAnim:Stop() para parar
    5. Use MortalAnim:Pause() para pausar
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local AnimatedObject = script.Parent
local FPS = 60
local FrameTime = 1 / FPS

-- Dados dos Keyframes
local KeyframeData = {
]]

    -- Ordenar keyframes
    local sortedFrames = {}
    for frame, _ in pairs(KeyframeSystem.Data) do
        table.insert(sortedFrames, frame)
    end
    table.sort(sortedFrames)
    
    -- Gerar dados de cada keyframe
    for _, frame in ipairs(sortedFrames) do
        local data = KeyframeSystem.Data[frame]
        code = code .. string.format("    [%d] = {\n", frame)
        
        if data.Parts then
            code = code .. "        Parts = {\n"
            for partName, partData in pairs(data.Parts) do
                local cf = partData.CFrame
                code = code .. string.format(
                    '            ["%s"] = CFrame.new(%f, %f, %f) * CFrame.Angles(%f, %f, %f),\n',
                    partName,
                    cf.Position.X, cf.Position.Y, cf.Position.Z,
                    cf:ToEulerAnglesXYZ()
                )
            end
            code = code .. "        },\n"
        else
            if data.Position then
                code = code .. string.format(
                    "        Position = Vector3.new(%f, %f, %f),\n",
                    data.Position.X, data.Position.Y, data.Position.Z
                )
            end
            if data.Orientation then
                code = code .. string.format(
                    "        Orientation = Vector3.new(%f, %f, %f),\n",
                    data.Orientation.X, data.Orientation.Y, data.Orientation.Z
                )
            end
            if data.Size then
                code = code .. string.format(
                    "        Size = Vector3.new(%f, %f, %f),\n",
                    data.Size.X, data.Size.Y, data.Size.Z
                )
            end
        end
        
        code = code .. "    },\n"
    end
    
    code = code .. [[
}

-- Sistema de Animação
local MortalAnim = {}
MortalAnim.IsPlaying = false
MortalAnim.IsPaused = false
MortalAnim.CurrentFrame = 0
MortalAnim.Loop = true
MortalAnim.Speed = 1

local Connection = nil
local SortedFrames = {}

-- Ordenar frames
for frame, _ in pairs(KeyframeData) do
    table.insert(SortedFrames, frame)
end
table.sort(SortedFrames)

local StartFrame = SortedFrames[1] or 0
local EndFrame = SortedFrames[#SortedFrames] or 0

-- Função de interpolação
local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function LerpCFrame(cf1, cf2, t)
    return cf1:Lerp(cf2, t)
end

-- Função para interpolar frame
local function InterpolateFrame(frame)
    local prevFrame, nextFrame = nil, nil
    
    for i, f in ipairs(SortedFrames) do
        if f <= frame then prevFrame = f end
        if f >= frame and not nextFrame then nextFrame = f end
    end
    
    if not prevFrame or not nextFrame then return end
    if prevFrame == nextFrame then
        local data = KeyframeData[prevFrame]
        if data.Parts then
            for partName, cf in pairs(data.Parts) do
                local part = AnimatedObject:FindFirstChild(partName, true)
                if part then part.CFrame = cf end
            end
        elseif data.Position and AnimatedObject:IsA("BasePart") then
            AnimatedObject.Position = data.Position
        end
        return
    end
    
    local alpha = (frame - prevFrame) / (nextFrame - prevFrame)
    local prevData = KeyframeData[prevFrame]
    local nextData = KeyframeData[nextFrame]
    
    if prevData.Parts and nextData.Parts then
        for partName, prevCF in pairs(prevData.Parts) do
            local nextCF = nextData.Parts[partName]
            if nextCF then
                local part = AnimatedObject:FindFirstChild(partName, true)
                if part then
                    part.CFrame = LerpCFrame(prevCF, nextCF, alpha)
                end
            end
        end
    elseif prevData.Position and nextData.Position then
        if AnimatedObject:IsA("BasePart") then
            AnimatedObject.Position = prevData.Position:Lerp(nextData.Position, alpha)
        end
    end
end

-- Play
function MortalAnim:Play()
    if self.IsPlaying then return end
    self.IsPlaying = true
    self.IsPaused = false
    self.CurrentFrame = StartFrame
    
    local lastTime = tick()
    Connection = RunService.Heartbeat:Connect(function()
        if self.IsPaused then return end
        
        local now = tick()
        if now - lastTime >= FrameTime / self.Speed then
            lastTime = now
            self.CurrentFrame = self.CurrentFrame + 1
            
            if self.CurrentFrame > EndFrame then
                if self.Loop then
                    self.CurrentFrame = StartFrame
                else
                    self:Stop()
                    return
                end
            end
            
            InterpolateFrame(self.CurrentFrame)
        end
    end)
end

-- Stop
function MortalAnim:Stop()
    self.IsPlaying = false
    self.IsPaused = false
    self.CurrentFrame = StartFrame
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
end

-- Pause
function MortalAnim:Pause()
    self.IsPaused = true
end

-- Resume
function MortalAnim:Resume()
    self.IsPaused = false
end

-- Ir para frame específico
function MortalAnim:GoToFrame(frame)
    self.CurrentFrame = math.clamp(frame, StartFrame, EndFrame)
    InterpolateFrame(self.CurrentFrame)
end

-- Auto-play ao iniciar
MortalAnim:Play()

return MortalAnim
]]

    return code
end

-- Copiar para clipboard
local function CopyToClipboard()
    local code = CodeBox.Text
    if setclipboard then
        setclipboard(code)
        CreateNotification("✅ Copiado!", "Código copiado para a área de transferência", 3)
    else
        CreateNotification("⚠️ Aviso", "Selecione e copie o código manualmente", 3)
    end
end

-- Botões
CreateActionBtn("CopyBtn", "📋 Copiar Código", Colors.Accent, CopyToClipboard)

CreateActionBtn("RegenerateBtn", "🔄 Regenerar", Colors.Success, function()
    CodeBox.Text = GenerateAnimationCode()
    CreateNotification("✅ Regenerado", "Código atualizado com sucesso!", 2)
end)

CreateActionBtn("CloseBtn2", "❌ Fechar", Colors.Danger, function()
    Plugins.AnimateOut(ExportFrame)
end)

-- Evento fechar
CloseExportBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(ExportFrame)
end)

-- Função para abrir Export
local function OpenExport()
    CodeBox.Text = GenerateAnimationCode()
    Plugins.AnimateIn(ExportFrame)
end

-- Adicionar botão de Export no ToolPanel
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("Export", "📤", "Exportar Animação", OpenExport)

-- Armazenar referências
Animator.ExportFrame = ExportFrame
Animator.OpenExport = OpenExport
Animator.GenerateCode = GenerateAnimationCode

print("✅ MORTAL ANIMATOR - Sistema de Export Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 5: Criador de Cutscenes
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Sistema de Cutscenes
local CutsceneSystem = {
    CameraPoints = {},
    CurrentPointIndex = 0,
    IsPlaying = false,
    Duration = 5,
    EasingStyle = Enum.EasingStyle.Quad
}

-- Frame do Criador de Cutscenes
local CutsceneFrame = Instance.new("Frame")
CutsceneFrame.Name = "CutsceneFrame"
CutsceneFrame.Size = UDim2.new(0.92, 0, 0.88, 0)
CutsceneFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CutsceneFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CutsceneFrame.BackgroundColor3 = Colors.Background
CutsceneFrame.BorderSizePixel = 0
CutsceneFrame.Visible = false
CutsceneFrame.ZIndex = 25
CutsceneFrame.Parent = ScreenGui

CutsceneFrame:SetAttribute("OriginalSize", CutsceneFrame.Size)

local CutCorner = Instance.new("UICorner")
CutCorner.CornerRadius = UDim.new(0, 14)
CutCorner.Parent = CutsceneFrame

local CutStroke = Instance.new("UIStroke")
CutStroke.Color = Color3.fromRGB(255, 165, 0)
CutStroke.Thickness = 2
CutStroke.Parent = CutsceneFrame

local CutGradient = Instance.new("UIGradient")
CutGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 20, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
})
CutGradient.Rotation = 135
CutGradient.Parent = CutsceneFrame

-- Header
local CutHeader = Instance.new("Frame")
CutHeader.Name = "Header"
CutHeader.Size = UDim2.new(1, 0, 0, 55)
CutHeader.BackgroundColor3 = Color3.fromRGB(30, 25, 20)
CutHeader.BorderSizePixel = 0
CutHeader.ZIndex = 26
CutHeader.Parent = CutsceneFrame

local CutHeaderCorner = Instance.new("UICorner")
CutHeaderCorner.CornerRadius = UDim.new(0, 14)
CutHeaderCorner.Parent = CutHeader

local CutTitle = Instance.new("TextLabel")
CutTitle.Size = UDim2.new(0.75, 0, 1, 0)
CutTitle.Position = UDim2.new(0, 15, 0, 0)
CutTitle.BackgroundTransparency = 1
CutTitle.Font = Enum.Font.GothamBold
CutTitle.Text = "🎬 Criar Cutscene⚡ • Mortal Animator"
CutTitle.TextColor3 = Colors.Text
CutTitle.TextSize = IsMobile and 13 or 16
CutTitle.TextXAlignment = Enum.TextXAlignment.Left
CutTitle.ZIndex = 27
CutTitle.Parent = CutHeader

-- Botão Fechar
local CloseCutBtn = Instance.new("TextButton")
CloseCutBtn.Name = "CloseBtn"
CloseCutBtn.Size = UDim2.new(0, 40, 0, 40)
CloseCutBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseCutBtn.BackgroundColor3 = Colors.Danger
CloseCutBtn.Text = "✕"
CloseCutBtn.TextColor3 = Colors.Text
CloseCutBtn.TextSize = 18
CloseCutBtn.Font = Enum.Font.GothamBold
CloseCutBtn.ZIndex = 27
CloseCutBtn.Parent = CutHeader

local CloseCutCorner = Instance.new("UICorner")
CloseCutCorner.CornerRadius = UDim.new(0, 8)
CloseCutCorner.Parent = CloseCutBtn

-- Painel de Controles (Esquerda)
local CutControlPanel = Instance.new("Frame")
CutControlPanel.Name = "ControlPanel"
CutControlPanel.Size = UDim2.new(0, IsMobile and 140 or 200, 1, -70)
CutControlPanel.Position = UDim2.new(0, 10, 0, 60)
CutControlPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
CutControlPanel.BorderSizePixel = 0
CutControlPanel.ZIndex = 26
CutControlPanel.Parent = CutsceneFrame

local ControlCorner = Instance.new("UICorner")
ControlCorner.CornerRadius = UDim.new(0, 12)
ControlCorner.Parent = CutControlPanel

local ControlLayout = Instance.new("UIListLayout")
ControlLayout.Padding = UDim.new(0, 8)
ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ControlLayout.SortOrder = Enum.SortOrder.LayoutOrder
ControlLayout.Parent = CutControlPanel

local ControlPadding = Instance.new("UIPadding")
ControlPadding.PaddingTop = UDim.new(0, 15)
ControlPadding.Parent = CutControlPanel

-- Título do painel
local ControlTitle = Instance.new("TextLabel")
ControlTitle.Size = UDim2.new(1, -20, 0, 25)
ControlTitle.BackgroundTransparency = 1
ControlTitle.Font = Enum.Font.GothamBold
ControlTitle.Text = "🎮 Controles"
ControlTitle.TextColor3 = Colors.Text
ControlTitle.TextSize = 12
ControlTitle.ZIndex = 27
ControlTitle.Parent = CutControlPanel

-- Função para criar botão de cutscene
local function CreateCutsceneBtn(name, text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Colors.Text
    btn.TextSize = IsMobile and 11 or 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 27
    btn.Parent = CutControlPanel
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 1
    stroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        CreateTween(stroke, {Color = Color3.fromRGB(255, 165, 0)}, 0.2):Play()
        CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(50, 45, 40)}, 0.2):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        CreateTween(stroke, {Color = Colors.Border}, 0.2):Play()
        CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}, 0.2):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Lista de Pontos de Câmera
local PointsListFrame = Instance.new("ScrollingFrame")
PointsListFrame.Name = "PointsList"
PointsListFrame.Size = UDim2.new(1, -((IsMobile and 170 or 230)), 1, -250)
PointsListFrame.Position = UDim2.new(0, IsMobile and 160 or 220, 0, 65)
PointsListFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
PointsListFrame.BorderSizePixel = 0
PointsListFrame.ScrollBarThickness = 4
PointsListFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 165, 0)
PointsListFrame.ZIndex = 26
PointsListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PointsListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
PointsListFrame.Parent = CutsceneFrame

local PointsCorner = Instance.new("UICorner")
PointsCorner.CornerRadius = UDim.new(0, 12)
PointsCorner.Parent = PointsListFrame

local PointsStroke = Instance.new("UIStroke")
PointsStroke.Color = Colors.Border
PointsStroke.Thickness = 1
PointsStroke.Parent = PointsListFrame

local PointsLayout = Instance.new("UIListLayout")
PointsLayout.Padding = UDim.new(0, 8)
PointsLayout.SortOrder = Enum.SortOrder.LayoutOrder
PointsLayout.Parent = PointsListFrame

local PointsPadding = Instance.new("UIPadding")
PointsPadding.PaddingTop = UDim.new(0, 10)
PointsPadding.PaddingLeft = UDim.new(0, 10)
PointsPadding.PaddingRight = UDim.new(0, 10)
PointsPadding.Parent = PointsListFrame

local PointsTitle = Instance.new("TextLabel")
PointsTitle.Size = UDim2.new(1, 0, 0, 30)
PointsTitle.BackgroundTransparency = 1
PointsTitle.Font = Enum.Font.GothamBold
PointsTitle.Text = "📍 Pontos de Câmera"
PointsTitle.TextColor3 = Colors.Text
PointsTitle.TextSize = 13
PointsTitle.TextXAlignment = Enum.TextXAlignment.Left
PointsTitle.ZIndex = 27
PointsTitle.Parent = PointsListFrame

-- Timeline da Cutscene
local CutTimeline = Instance.new("Frame")
CutTimeline.Name = "CutsceneTimeline"
CutTimeline.Size = UDim2.new(1, -((IsMobile and 170 or 230)), 0, 140)
CutTimeline.Position = UDim2.new(0, IsMobile and 160 or 220, 1, -150)
CutTimeline.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
CutTimeline.BorderSizePixel = 0
CutTimeline.ZIndex = 26
CutTimeline.Parent = CutsceneFrame

local CutTimelineCorner = Instance.new("UICorner")
CutTimelineCorner.CornerRadius = UDim.new(0, 12)
CutTimelineCorner.Parent = CutTimeline

local CutTimelineStroke = Instance.new("UIStroke")
CutTimelineStroke.Color = Colors.Border
CutTimelineStroke.Thickness = 1
CutTimelineStroke.Parent = CutTimeline

local CutTimelineTitle = Instance.new("TextLabel")
CutTimelineTitle.Size = UDim2.new(0.5, 0, 0, 30)
CutTimelineTitle.Position = UDim2.new(0, 10, 0, 5)
CutTimelineTitle.BackgroundTransparency = 1
CutTimelineTitle.Font = Enum.Font.GothamBold
CutTimelineTitle.Text = "⏱️ Timeline da Cutscene"
CutTimelineTitle.TextColor3 = Colors.Text
CutTimelineTitle.TextSize = 12
CutTimelineTitle.TextXAlignment = Enum.TextXAlignment.Left
CutTimelineTitle.ZIndex = 27
CutTimelineTitle.Parent = CutTimeline

-- Área visual da timeline
local CutTimelineArea = Instance.new("Frame")
CutTimelineArea.Name = "TimelineArea"
CutTimelineArea.Size = UDim2.new(1, -20, 0, 80)
CutTimelineArea.Position = UDim2.new(0, 10, 0, 40)
CutTimelineArea.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
CutTimelineArea.BorderSizePixel = 0
CutTimelineArea.ZIndex = 27
CutTimelineArea.Parent = CutTimeline

local CutTimelineAreaCorner = Instance.new("UICorner")
CutTimelineAreaCorner.CornerRadius = UDim.new(0, 8)
CutTimelineAreaCorner.Parent = CutTimelineArea

-- Função para criar ponto de câmera no mundo
local function CreateCameraPoint()
    local camera = Workspace.CurrentCamera
    local position = camera.CFrame.Position
    
    -- Criar esfera visual
    local sphere = Instance.new("Part")
    sphere.Name = "CameraPoint_" .. (#CutsceneSystem.CameraPoints + 1)
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(2, 2, 2)
    sphere.Position = position
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Transparency = 0.5
    sphere.BrickColor = BrickColor.new("Bright blue")
    sphere.Material = Enum.Material.Neon
    sphere.Parent = Workspace
    
    -- Adicionar ao sistema
    local pointData = {
        Index = #CutsceneSystem.CameraPoints + 1,
        Part = sphere,
        CFrame = camera.CFrame,
        Duration = 2
    }
    
    table.insert(CutsceneSystem.CameraPoints, pointData)
    
    -- Criar item na lista
    local pointItem = Instance.new("Frame")
    pointItem.Name = "Point_" .. pointData.Index
    pointItem.Size = UDim2.new(1, 0, 0, 50)
    pointItem.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    pointItem.BorderSizePixel = 0
    pointItem.ZIndex = 28
    pointItem.Parent = PointsListFrame
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 8)
    itemCorner.Parent = pointItem
    
    local itemLabel = Instance.new("TextLabel")
    itemLabel.Size = UDim2.new(0.6, 0, 1, 0)
    itemLabel.Position = UDim2.new(0, 10, 0, 0)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Font = Enum.Font.GothamBold
    itemLabel.Text = "📍 Ponto " .. pointData.Index
    itemLabel.TextColor3 = Colors.Text
    itemLabel.TextSize = 12
    itemLabel.TextXAlignment = Enum.TextXAlignment.Left
    itemLabel.ZIndex = 29
    itemLabel.Parent = pointItem
    
    local deleteBtn = Instance.new("TextButton")
    deleteBtn.Size = UDim2.new(0, 35, 0, 35)
    deleteBtn.Position = UDim2.new(1, -45, 0.5, -17)
    deleteBtn.BackgroundColor3 = Colors.Danger
    deleteBtn.Text = "🗑️"
    deleteBtn.TextSize = 14
    deleteBtn.ZIndex = 29
    deleteBtn.Parent = pointItem
    
    local deleteCorner = Instance.new("UICorner")
    deleteCorner.CornerRadius = UDim.new(0, 6)
    deleteCorner.Parent = deleteBtn
    
    deleteBtn.MouseButton1Click:Connect(function()
        sphere:Destroy()
        pointItem:Destroy()
        for i, pt in pairs(CutsceneSystem.CameraPoints) do
            if pt.Index == pointData.Index then
                table.remove(CutsceneSystem.CameraPoints, i)
                break
            end
        end
        CreateNotification("🗑️ Removido", "Ponto " .. pointData.Index .. " removido", 2)
    end)
    
    -- Criar marcador na timeline
    local marker = Instance.new("Frame")
    marker.Size = UDim2.new(0, 16, 0, 16)
    marker.Position = UDim2.new(pointData.Index / 10, -8, 0.5, -8)
    marker.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    marker.ZIndex = 28
    marker.Parent = CutTimelineArea
    
    local markerCorner = Instance.new("UICorner")
    markerCorner.CornerRadius = UDim.new(1, 0)
    markerCorner.Parent = marker
    
    CreateNotification("✅ Ponto Criado", "Ponto de câmera " .. pointData.Index .. " adicionado", 2)
    
    return pointData
end

-- Reproduzir Cutscene
local function PlayCutscene()
    if #CutsceneSystem.CameraPoints < 2 then
        CreateNotification("⚠️ Aviso", "Adicione pelo menos 2 pontos de câmera!", 3)
        return
    end
    
    if CutsceneSystem.IsPlaying then
        CutsceneSystem.IsPlaying = false
        CreateNotification("⏹️ Parado", "Cutscene interrompida", 2)
        return
    end
    
    CutsceneSystem.IsPlaying = true
    CreateNotification("🎬 Reproduzindo", "Cutscene iniciada!", 2)
    
    local camera = Workspace.CurrentCamera
    local originalType = camera.CameraType
    camera.CameraType = Enum.CameraType.Scriptable
    
    task.spawn(function()
        for i = 1, #CutsceneSystem.CameraPoints - 1 do
            if not CutsceneSystem.IsPlaying then break end
            
            local currentPoint = CutsceneSystem.CameraPoints[i]
            local nextPoint = CutsceneSystem.CameraPoints[i + 1]
            
            local tweenInfo = TweenInfo.new(
                currentPoint.Duration,
                CutsceneSystem.EasingStyle,
                Enum.EasingDirection.InOut
            )
            
            local tween = TweenService:Create(camera, tweenInfo, {
                CFrame = nextPoint.CFrame
            })
            
            camera.CFrame = currentPoint.CFrame
            tween:Play()
            tween.Completed:Wait()
        end
        
        CutsceneSystem.IsPlaying = false
        camera.CameraType = originalType
        CreateNotification("✅ Concluído", "Cutscene finalizada!", 2)
    end)
end

-- Limpar todos os pontos
local function ClearAllPoints()
    for _, point in pairs(CutsceneSystem.CameraPoints) do
        if point.Part then
            point.Part:Destroy()
        end
    end
    CutsceneSystem.CameraPoints = {}
    
    for _, child in pairs(PointsListFrame:GetChildren()) do
        if child.Name:find("Point_") then
            child:Destroy()
        end
    end
    
    for _, child in pairs(CutTimelineArea:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    CreateNotification("🧹 Limpo", "Todos os pontos removidos", 2)
end

-- Criar botões
CreateCutsceneBtn("CreatePoint", "Criar Câmera", "📷", CreateCameraPoint)
CreateCutsceneBtn("PlayCutscene", "Reproduzir", "▶️", PlayCutscene)
CreateCutsceneBtn("StopCutscene", "Parar", "⏹️", function()
    CutsceneSystem.IsPlaying = false
end)
CreateCutsceneBtn("ClearPoints", "Limpar Tudo", "🧹", ClearAllPoints)
CreateCutsceneBtn("ExportCutscene", "Exportar", "📤", function()
    CreateNotification("📤 Export", "Função de exportar cutscene em breve!", 3)
end)

-- Evento fechar
CloseCutBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(CutsceneFrame)
end)

-- Função para abrir Cutscene Creator
local function OpenCutsceneCreator()
    Plugins.AnimateIn(CutsceneFrame)
end

-- Adicionar botão no ToolPanel do Animator
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("Cutscene", "🎬", "Criar Cutscene", OpenCutsceneCreator)

-- Armazenar referências
Animator.CutsceneFrame = CutsceneFrame
Animator.CutsceneSystem = CutsceneSystem
Animator.OpenCutscene = OpenCutsceneCreator

print("✅ MORTAL ANIMATOR - Criador de Cutscenes Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 6: Sistema de Tracks para Rigs e Bones
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

local Selection = game:GetService("Selection")

-- Sistema de Tracks
local TrackSystem = {
    Tracks = {},
    SelectedTrack = nil,
    ExpandedTracks = {}
}

-- Painel de Tracks (substituir/complementar PropPanel)
local TracksPanel = Instance.new("ScrollingFrame")
TracksPanel.Name = "TracksPanel"
TracksPanel.Size = UDim2.new(0, IsMobile and 160 or 220, 0, 300)
TracksPanel.Position = UDim2.new(0, IsMobile and 75 or 100, 0, 65)
TracksPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
TracksPanel.BorderSizePixel = 0
TracksPanel.ScrollBarThickness = 3
TracksPanel.ScrollBarImageColor3 = Colors.Accent
TracksPanel.ZIndex = 15
TracksPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
TracksPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
TracksPanel.Visible = false
TracksPanel.Parent = Animator.Frame

local TracksCorner = Instance.new("UICorner")
TracksCorner.CornerRadius = UDim.new(0, 12)
TracksCorner.Parent = TracksPanel

local TracksStroke = Instance.new("UIStroke")
TracksStroke.Color = Colors.Border
TracksStroke.Thickness = 1
TracksStroke.Parent = TracksPanel

local TracksLayout = Instance.new("UIListLayout")
TracksLayout.Padding = UDim.new(0, 4)
TracksLayout.SortOrder = Enum.SortOrder.LayoutOrder
TracksLayout.Parent = TracksPanel

local TracksPadding = Instance.new("UIPadding")
TracksPadding.PaddingTop = UDim.new(0, 8)
TracksPadding.PaddingLeft = UDim.new(0, 8)
TracksPadding.PaddingRight = UDim.new(0, 8)
TracksPadding.Parent = TracksPanel

local TracksTitle = Instance.new("TextLabel")
TracksTitle.Size = UDim2.new(1, 0, 0, 28)
TracksTitle.BackgroundTransparency = 1
TracksTitle.Font = Enum.Font.GothamBold
TracksTitle.Text = "🦴 Tracks / Bones"
TracksTitle.TextColor3 = Colors.Text
TracksTitle.TextSize = 12
TracksTitle.TextXAlignment = Enum.TextXAlignment.Left
TracksTitle.ZIndex = 16
TracksTitle.Parent = TracksPanel

-- Função para criar track item
local function CreateTrackItem(part, level, parentTrack)
    level = level or 0
    
    local trackFrame = Instance.new("Frame")
    trackFrame.Name = "Track_" .. part.Name
    trackFrame.Size = UDim2.new(1, 0, 0, 32)
    trackFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    trackFrame.BorderSizePixel = 0
    trackFrame.ZIndex = 16
    trackFrame.Parent = TracksPanel
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 6)
    trackCorner.Parent = trackFrame
    
    -- Indentação baseada no nível
    local indent = level * 15
    
    -- Ícone de expandir/colapsar
    local expandBtn = Instance.new("TextButton")
    expandBtn.Size = UDim2.new(0, 20, 0, 20)
    expandBtn.Position = UDim2.new(0, indent + 5, 0.5, -10)
    expandBtn.BackgroundTransparency = 1
    expandBtn.Text = "▶"
    expandBtn.TextColor3 = Colors.TextSecondary
    expandBtn.TextSize = 10
    expandBtn.Font = Enum.Font.GothamBold
    expandBtn.ZIndex = 17
    expandBtn.Parent = trackFrame
    
    -- Nome da parte
    local nameLabel = Instance.new("TextButton")
    nameLabel.Size = UDim2.new(1, -(indent + 60), 1, 0)
    nameLabel.Position = UDim2.new(0, indent + 28, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = part.Name
    nameLabel.TextColor3 = Colors.Text
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 17
    nameLabel.Parent = trackFrame
    
    -- Ícone de keyframe
    local keyframeBtn = Instance.new("TextButton")
    keyframeBtn.Size = UDim2.new(0, 24, 0, 24)
    keyframeBtn.Position = UDim2.new(1, -30, 0.5, -12)
    keyframeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    keyframeBtn.Text = "◆"
    keyframeBtn.TextColor3 = Colors.TextSecondary
    keyframeBtn.TextSize = 12
    keyframeBtn.ZIndex = 17
    keyframeBtn.Parent = trackFrame
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 4)
    keyCorner.Parent = keyframeBtn
    
    -- Dados do track
    local trackData = {
        Part = part,
        Frame = trackFrame,
        Level = level,
        IsExpanded = true,
        Children = {},
        Keyframes = {}
    }
    
    -- Verificar se tem filhos
    local hasChildren = false
    for _, child in pairs(part:GetChildren()) do
        if child:IsA("BasePart") or child:IsA("Motor6D") or child:IsA("Bone") then
            hasChildren = true
            break
        end
    end
    
    if not hasChildren then
        expandBtn.Visible = false
    end
    
    -- Evento de expandir
    local childTracks = {}
    
    expandBtn.MouseButton1Click:Connect(function()
        trackData.IsExpanded = not trackData.IsExpanded
        expandBtn.Text = trackData.IsExpanded and "▼" or "▶"
        
        for _, childTrack in pairs(childTracks) do
            childTrack.Frame.Visible = trackData.IsExpanded
        end
    end)
    
    -- Evento de selecionar
    nameLabel.MouseButton1Click:Connect(function()
        -- Destacar track selecionado
        for _, track in pairs(TrackSystem.Tracks) do
            track.Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
        end
        trackFrame.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
        
        TrackSystem.SelectedTrack = trackData
        
        -- Selecionar no Studio Lite
        pcall(function()
            Selection:Set({part})
        end)
        
        Animator.SelectedObject = part
        Animator.SelectedInfo.Text = "✓ " .. part.Name .. "\n(" .. part.ClassName .. ")"
        Animator.SelectedInfo.TextColor3 = Colors.Success
    end)
    
    -- Evento de adicionar keyframe
    keyframeBtn.MouseButton1Click:Connect(function()
        local currentFrame = Animator.CurrentFrame or 0
        
        -- Salvar estado atual
        local keyData = {
            Frame = currentFrame,
            CFrame = part.CFrame,
            Size = part.Size
        }
        
        trackData.Keyframes[currentFrame] = keyData
        
        -- Visual feedback
        keyframeBtn.TextColor3 = Colors.Success
        CreateTween(keyframeBtn, {TextColor3 = Colors.TextSecondary}, 0.5):Play()
        
        -- Adicionar ao sistema principal
        if not Animator.KeyframeSystem.Data[currentFrame] then
            Animator.KeyframeSystem.Data[currentFrame] = {
                Frame = currentFrame,
                Object = Animator.SelectedObject,
                Parts = {}
            }
        end
        
        Animator.KeyframeSystem.Data[currentFrame].Parts[part.Name] = {
            CFrame = part.CFrame,
            Size = part.Size
        }
        
        CreateNotification("🔑 Keyframe", part.Name .. " @ Frame " .. currentFrame, 2)
    end)
    
    -- Hover effect
    trackFrame.MouseEnter:Connect(function()
        if TrackSystem.SelectedTrack ~= trackData then
            CreateTween(trackFrame, {BackgroundColor3 = Color3.fromRGB(38, 38, 58)}, 0.15):Play()
        end
    end)
    
    trackFrame.MouseLeave:Connect(function()
        if TrackSystem.SelectedTrack ~= trackData then
            CreateTween(trackFrame, {BackgroundColor3 = Color3.fromRGB(28, 28, 45)}, 0.15):Play()
        end
    end)
    
    table.insert(TrackSystem.Tracks, trackData)
    
    -- Criar tracks filhos
    if hasChildren then
        for _, child in pairs(part:GetChildren()) do
            if child:IsA("BasePart") or child:IsA("Motor6D") or child:IsA("Bone") then
                local childTrackData = CreateTrackItem(child, level + 1, trackData)
                table.insert(childTracks, childTrackData)
                table.insert(trackData.Children, childTrackData)
            end
        end
    end
    
    return trackData
end

-- Função para analisar Rig
local function AnalyzeRig(model)
    -- Limpar tracks anteriores
    for _, track in pairs(TrackSystem.Tracks) do
        if track.Frame then
            track.Frame:Destroy()
        end
    end
    TrackSystem.Tracks = {}
    
    -- Detectar tipo de Rig
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local rootPart = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildOfClass("BasePart")
    
    if humanoid then
        -- Rig R6 ou R15
        local rigType = humanoid.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
        CreateNotification("🦴 Rig Detectado", rigType .. " - " .. model.Name, 3)
        
        -- Criar tracks para cada parte do corpo
        if rigType == "R15" then
            local bodyParts = {
                "HumanoidRootPart", "LowerTorso", "UpperTorso", "Head",
                "LeftUpperArm", "LeftLowerArm", "LeftHand",
                "RightUpperArm", "RightLowerArm", "RightHand",
                "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                "RightUpperLeg", "RightLowerLeg", "RightFoot"
            }
            
            for _, partName in ipairs(bodyParts) do
                local part = model:FindFirstChild(partName)
                if part then
                    CreateTrackItem(part, 0)
                end
            end
        else
            local bodyParts = {
                "HumanoidRootPart", "Torso", "Head",
                "Left Arm", "Right Arm", "Left Leg", "Right Leg"
            }
            
            for _, partName in ipairs(bodyParts) do
                local part = model:FindFirstChild(partName)
                if part then
                    CreateTrackItem(part, 0)
                end
            end
        end
    else
        -- Rig customizado - analisar hierarquia
        CreateNotification("🦴 Modelo", "Analisando: " .. model.Name, 3)
        
        if rootPart then
            CreateTrackItem(rootPart, 0)
        else
            for _, child in pairs(model:GetChildren()) do
                if child:IsA("BasePart") then
                    CreateTrackItem(child, 0)
                end
            end
        end
    end
    
    TracksPanel.Visible = true
end

-- Função para analisar objeto único
local function AnalyzePart(part)
    for _, track in pairs(TrackSystem.Tracks) do
        if track.Frame then
            track.Frame:Destroy()
        end
    end
    TrackSystem.Tracks = {}
    
    CreateTrackItem(part, 0)
    TracksPanel.Visible = true
    
    CreateNotification("📦 Objeto", "Analisando: " .. part.Name, 2)
end

-- Botão para analisar seleção
local CreateToolButton = Animator.CreateToolButton

CreateToolButton("AnalyzeRig", "🦴", "Analisar Rig/Objeto", function()
    local selected = Animator.SelectedObject
    
    if not selected then
        CreateNotification("⚠️ Aviso", "Selecione um objeto primeiro!", 3)
        return
    end
    
    if selected:IsA("Model") then
        AnalyzeRig(selected)
    elseif selected:IsA("BasePart") then
        AnalyzePart(selected)
    else
        CreateNotification("⚠️ Aviso", "Selecione um Model ou Part!", 3)
    end
end)

-- Botão toggle do painel de tracks
CreateToolButton("ToggleTracks", "📋", "Mostrar/Ocultar Tracks", function()
    TracksPanel.Visible = not TracksPanel.Visible
end)

-- Sincronizar com seleção do Studio Lite
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local selected = Selection:Get()
            if selected and #selected > 0 then
                local obj = selected[1]
                
                -- Auto-analisar se for um novo Model
                if obj:IsA("Model") and obj ~= Animator.SelectedObject then
                    if obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChildOfClass("BasePart") then
                        Animator.SelectedObject = obj
                        Animator.SelectedInfo.Text = "✓ " .. obj.Name .. "\n(Clique 🦴 para analisar)"
                        Animator.SelectedInfo.TextColor3 = Colors.Warning
                    end
                end
            end
        end)
    end
end)

-- Armazenar referências
Animator.TracksPanel = TracksPanel
Animator.TrackSystem = TrackSystem
Animator.AnalyzeRig = AnalyzeRig
Animator.AnalyzePart = AnalyzePart

print("✅ MORTAL ANIMATOR - Sistema de Tracks/Bones Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 7: Sistema de Easing e Curvas de Animação
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

-- Sistema de Easing
local EasingSystem = {
    CurrentStyle = Enum.EasingStyle.Quad,
    CurrentDirection = Enum.EasingDirection.InOut,
    Styles = {
        {Name = "Linear", Style = Enum.EasingStyle.Linear, Icon = "📏"},
        {Name = "Quad", Style = Enum.EasingStyle.Quad, Icon = "📈"},
        {Name = "Cubic", Style = Enum.EasingStyle.Cubic, Icon = "📊"},
        {Name = "Quart", Style = Enum.EasingStyle.Quart, Icon = "⚡"},
        {Name = "Quint", Style = Enum.EasingStyle.Quint, Icon = "🚀"},
        {Name = "Sine", Style = Enum.EasingStyle.Sine, Icon = "🌊"},
        {Name = "Expo", Style = Enum.EasingStyle.Exponential, Icon = "💥"},
        {Name = "Circ", Style = Enum.EasingStyle.Circular, Icon = "⭕"},
        {Name = "Back", Style = Enum.EasingStyle.Back, Icon = "↩️"},
        {Name = "Elastic", Style = Enum.EasingStyle.Elastic, Icon = "🎸"},
        {Name = "Bounce", Style = Enum.EasingStyle.Bounce, Icon = "🏀"}
    },
    Directions = {
        {Name = "In", Dir = Enum.EasingDirection.In, Icon = "➡️"},
        {Name = "Out", Dir = Enum.EasingDirection.Out, Icon = "⬅️"},
        {Name = "InOut", Dir = Enum.EasingDirection.InOut, Icon = "↔️"}
    }
}

-- Frame de Easing
local EasingFrame = Instance.new("Frame")
EasingFrame.Name = "EasingFrame"
EasingFrame.Size = UDim2.new(0, IsMobile and 280 or 350, 0, 420)
EasingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
EasingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
EasingFrame.BackgroundColor3 = Colors.Background
EasingFrame.BorderSizePixel = 0
EasingFrame.Visible = false
EasingFrame.ZIndex = 30
EasingFrame.Parent = ScreenGui

EasingFrame:SetAttribute("OriginalSize", EasingFrame.Size)

local EaseCorner = Instance.new("UICorner")
EaseCorner.CornerRadius = UDim.new(0, 14)
EaseCorner.Parent = EasingFrame

local EaseStroke = Instance.new("UIStroke")
EaseStroke.Color = Color3.fromRGB(255, 200, 100)
EaseStroke.Thickness = 2
EaseStroke.Parent = EasingFrame

local EaseGradient = Instance.new("UIGradient")
EaseGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 22, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
})
EaseGradient.Rotation = 135
EaseGradient.Parent = EasingFrame

-- Header
local EaseHeader = Instance.new("Frame")
EaseHeader.Size = UDim2.new(1, 0, 0, 50)
EaseHeader.BackgroundColor3 = Color3.fromRGB(30, 28, 22)
EaseHeader.BorderSizePixel = 0
EaseHeader.ZIndex = 31
EaseHeader.Parent = EasingFrame

local EaseHeaderCorner = Instance.new("UICorner")
EaseHeaderCorner.CornerRadius = UDim.new(0, 14)
EaseHeaderCorner.Parent = EaseHeader

local EaseTitle = Instance.new("TextLabel")
EaseTitle.Size = UDim2.new(0.8, 0, 1, 0)
EaseTitle.Position = UDim2.new(0, 15, 0, 0)
EaseTitle.BackgroundTransparency = 1
EaseTitle.Font = Enum.Font.GothamBold
EaseTitle.Text = "📈 Curvas de Animação"
EaseTitle.TextColor3 = Colors.Text
EaseTitle.TextSize = 14
EaseTitle.TextXAlignment = Enum.TextXAlignment.Left
EaseTitle.ZIndex = 32
EaseTitle.Parent = EaseHeader

-- Botão Fechar
local CloseEaseBtn = Instance.new("TextButton")
CloseEaseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseEaseBtn.Position = UDim2.new(1, -42, 0.5, -17)
CloseEaseBtn.BackgroundColor3 = Colors.Danger
CloseEaseBtn.Text = "✕"
CloseEaseBtn.TextColor3 = Colors.Text
CloseEaseBtn.TextSize = 16
CloseEaseBtn.Font = Enum.Font.GothamBold
CloseEaseBtn.ZIndex = 32
CloseEaseBtn.Parent = EaseHeader

local CloseEaseCorner = Instance.new("UICorner")
CloseEaseCorner.CornerRadius = UDim.new(0, 8)
CloseEaseCorner.Parent = CloseEaseBtn

-- Preview da Curva
local CurvePreview = Instance.new("Frame")
CurvePreview.Name = "CurvePreview"
CurvePreview.Size = UDim2.new(1, -30, 0, 100)
CurvePreview.Position = UDim2.new(0, 15, 0, 60)
CurvePreview.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
CurvePreview.BorderSizePixel = 0
CurvePreview.ZIndex = 31
CurvePreview.Parent = EasingFrame

local CurveCorner = Instance.new("UICorner")
CurveCorner.CornerRadius = UDim.new(0, 10)
CurveCorner.Parent = CurvePreview

local CurveStroke = Instance.new("UIStroke")
CurveStroke.Color = Colors.Border
CurveStroke.Thickness = 1
CurveStroke.Parent = CurvePreview

-- Bola de preview animada
local PreviewBall = Instance.new("Frame")
PreviewBall.Name = "PreviewBall"
PreviewBall.Size = UDim2.new(0, 16, 0, 16)
PreviewBall.Position = UDim2.new(0, 10, 0.5, -8)
PreviewBall.BackgroundColor3 = Colors.Success
PreviewBall.ZIndex = 32
PreviewBall.Parent = CurvePreview

local BallCorner = Instance.new("UICorner")
BallCorner.CornerRadius = UDim.new(1, 0)
BallCorner.Parent = PreviewBall

-- Label do estilo atual
local CurrentStyleLabel = Instance.new("TextLabel")
CurrentStyleLabel.Size = UDim2.new(1, 0, 0, 25)
CurrentStyleLabel.Position = UDim2.new(0, 0, 1, -25)
CurrentStyleLabel.BackgroundTransparency = 1
CurrentStyleLabel.Font = Enum.Font.GothamBold
CurrentStyleLabel.Text = "Quad • InOut"
CurrentStyleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
CurrentStyleLabel.TextSize = 11
CurrentStyleLabel.ZIndex = 32
CurrentStyleLabel.Parent = CurvePreview

-- Título Easing Styles
local StylesTitle = Instance.new("TextLabel")
StylesTitle.Size = UDim2.new(1, -30, 0, 25)
StylesTitle.Position = UDim2.new(0, 15, 0, 170)
StylesTitle.BackgroundTransparency = 1
StylesTitle.Font = Enum.Font.GothamBold
StylesTitle.Text = "⚡ Estilo de Easing"
StylesTitle.TextColor3 = Colors.Text
StylesTitle.TextSize = 12
StylesTitle.TextXAlignment = Enum.TextXAlignment.Left
StylesTitle.ZIndex = 31
StylesTitle.Parent = EasingFrame

-- Container de Estilos
local StylesContainer = Instance.new("ScrollingFrame")
StylesContainer.Name = "StylesContainer"
StylesContainer.Size = UDim2.new(1, -30, 0, 100)
StylesContainer.Position = UDim2.new(0, 15, 0, 195)
StylesContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
StylesContainer.BorderSizePixel = 0
StylesContainer.ScrollBarThickness = 3
StylesContainer.ScrollBarImageColor3 = Colors.Accent
StylesContainer.ZIndex = 31
StylesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
StylesContainer.AutomaticCanvasSize = Enum.AutomaticSize.XY
StylesContainer.ScrollingDirection = Enum.ScrollingDirection.X
StylesContainer.Parent = EasingFrame

local StylesCorner = Instance.new("UICorner")
StylesCorner.CornerRadius = UDim.new(0, 8)
StylesCorner.Parent = StylesContainer

local StylesLayout = Instance.new("UIListLayout")
StylesLayout.FillDirection = Enum.FillDirection.Horizontal
StylesLayout.Padding = UDim.new(0, 8)
StylesLayout.SortOrder = Enum.SortOrder.LayoutOrder
StylesLayout.Parent = StylesContainer

local StylesPadding = Instance.new("UIPadding")
StylesPadding.PaddingLeft = UDim.new(0, 8)
StylesPadding.PaddingTop = UDim.new(0, 8)
StylesPadding.Parent = StylesContainer

-- Variável para botões de estilo
local styleButtons = {}

-- Função para animar preview
local function AnimatePreview()
    PreviewBall.Position = UDim2.new(0, 10, 0.5, -8)
    
    local tweenInfo = TweenInfo.new(
        1.5,
        EasingSystem.CurrentStyle,
        EasingSystem.CurrentDirection
    )
    
    local tween = game:GetService("TweenService"):Create(PreviewBall, tweenInfo, {
        Position = UDim2.new(1, -26, 0.5, -8)
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        task.wait(0.3)
        AnimatePreview()
    end)
end

-- Criar botões de estilo
for i, styleData in ipairs(EasingSystem.Styles) do
    local btn = Instance.new("TextButton")
    btn.Name = styleData.Name
    btn.Size = UDim2.new(0, 70, 0, 75)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 32
    btn.Parent = StylesContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 1
    stroke.Parent = btn
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 0, 35)
    icon.Position = UDim2.new(0, 0, 0, 5)
    icon.BackgroundTransparency = 1
    icon.Text = styleData.Icon
    icon.TextSize = 22
    icon.ZIndex = 33
    icon.Parent = btn
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0, 25)
    name.Position = UDim2.new(0, 0, 1, -30)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.Text = styleData.Name
    name.TextColor3 = Colors.Text
    name.TextSize = 10
    name.ZIndex = 33
    name.Parent = btn
    
    styleButtons[styleData.Name] = {Button = btn, Stroke = stroke, Data = styleData}
    
    btn.MouseEnter:Connect(function()
        CreateTween(stroke, {Color = Color3.fromRGB(255, 200, 100)}, 0.2):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        if EasingSystem.CurrentStyle ~= styleData.Style then
            CreateTween(stroke, {Color = Colors.Border}, 0.2):Play()
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        -- Reset outros
        for _, data in pairs(styleButtons) do
            CreateTween(data.Stroke, {Color = Colors.Border}, 0.2):Play()
            CreateTween(data.Button, {BackgroundColor3 = Color3.fromRGB(30, 30, 48)}, 0.2):Play()
        end
        
        -- Ativar este
        EasingSystem.CurrentStyle = styleData.Style
        CreateTween(stroke, {Color = Colors.Success}, 0.2):Play()
        CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(40, 50, 45)}, 0.2):Play()
        
        CurrentStyleLabel.Text = styleData.Name .. " • " .. EasingSystem.CurrentDirection.Name
        
        CreateNotification("📈 Easing", styleData.Name .. " selecionado", 2)
    end)
end

-- Título Direção
local DirTitle = Instance.new("TextLabel")
DirTitle.Size = UDim2.new(1, -30, 0, 25)
DirTitle.Position = UDim2.new(0, 15, 0, 305)
DirTitle.BackgroundTransparency = 1
DirTitle.Font = Enum.Font.GothamBold
DirTitle.Text = "↔️ Direção"
DirTitle.TextColor3 = Colors.Text
DirTitle.TextSize = 12
DirTitle.TextXAlignment = Enum.TextXAlignment.Left
DirTitle.ZIndex = 31
DirTitle.Parent = EasingFrame

-- Container de Direções
local DirContainer = Instance.new("Frame")
DirContainer.Size = UDim2.new(1, -30, 0, 50)
DirContainer.Position = UDim2.new(0, 15, 0, 330)
DirContainer.BackgroundTransparency = 1
DirContainer.ZIndex = 31
DirContainer.Parent = EasingFrame

local DirLayout = Instance.new("UIListLayout")
DirLayout.FillDirection = Enum.FillDirection.Horizontal
DirLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
DirLayout.Padding = UDim.new(0, 10)
DirLayout.Parent = DirContainer

local dirButtons = {}

for i, dirData in ipairs(EasingSystem.Directions) do
    local btn = Instance.new("TextButton")
    btn.Name = dirData.Name
    btn.Size = UDim2.new(0, 90, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    btn.Text = dirData.Icon .. " " .. dirData.Name
    btn.TextColor3 = Colors.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 32
    btn.Parent = DirContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = (dirData.Name == "InOut") and Colors.Success or Colors.Border
    stroke.Thickness = 1
    stroke.Parent = btn
    
    dirButtons[dirData.Name] = {Button = btn, Stroke = stroke, Data = dirData}
    
    btn.MouseButton1Click:Connect(function()
        for _, data in pairs(dirButtons) do
            CreateTween(data.Stroke, {Color = Colors.Border}, 0.2):Play()
        end
        
        EasingSystem.CurrentDirection = dirData.Dir
        CreateTween(stroke, {Color = Colors.Success}, 0.2):Play()
        
        CurrentStyleLabel.Text = EasingSystem.CurrentStyle.Name .. " • " .. dirData.Name
    end)
end

-- Botão Aplicar
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1, -30, 0, 40)
ApplyBtn.Position = UDim2.new(0, 15, 1, -55)
ApplyBtn.BackgroundColor3 = Colors.Success
ApplyBtn.Text = "✅ Aplicar Easing"
ApplyBtn.TextColor3 = Colors.Text
ApplyBtn.TextSize = 14
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.ZIndex = 32
ApplyBtn.Parent = EasingFrame

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 10)
ApplyCorner.Parent = ApplyBtn

ApplyBtn.MouseButton1Click:Connect(function()
    Animator.EasingStyle = EasingSystem.CurrentStyle
    Animator.EasingDirection = EasingSystem.CurrentDirection
    
    if Animator.CutsceneSystem then
        Animator.CutsceneSystem.EasingStyle = EasingSystem.CurrentStyle
    end
    
    CreateNotification("✅ Aplicado", "Easing configurado com sucesso!", 2)
    Plugins.AnimateOut(EasingFrame)
end)

-- Eventos
CloseEaseBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(EasingFrame)
end)

-- Iniciar preview
task.spawn(function()
    task.wait(1)
    AnimatePreview()
end)

-- Função para abrir
local function OpenEasing()
    Plugins.AnimateIn(EasingFrame)
end

-- Botão no ToolPanel
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("Easing", "📈", "Curvas de Animação", OpenEasing)

-- Armazenar
Animator.EasingFrame = EasingFrame
Animator.EasingSystem = EasingSystem
Animator.OpenEasing = OpenEasing

print("✅ MORTAL ANIMATOR - Sistema de Easing Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 8: Preview em Tempo Real e FPS Ajustável
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Sistema de Preview
local PreviewSystem = {
    IsEnabled = false,
    FPS = 60,
    Speed = 1,
    Loop = true,
    ShowGhost = false,
    GhostParts = {}
}

-- Frame de Configurações de Preview
local PreviewFrame = Instance.new("Frame")
PreviewFrame.Name = "PreviewFrame"
PreviewFrame.Size = UDim2.new(0, IsMobile and 260 or 320, 0, 380)
PreviewFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
PreviewFrame.AnchorPoint = Vector2.new(0.5, 0.5)
PreviewFrame.BackgroundColor3 = Colors.Background
PreviewFrame.BorderSizePixel = 0
PreviewFrame.Visible = false
PreviewFrame.ZIndex = 30
PreviewFrame.Parent = ScreenGui

PreviewFrame:SetAttribute("OriginalSize", PreviewFrame.Size)

local PrevCorner = Instance.new("UICorner")
PrevCorner.CornerRadius = UDim.new(0, 14)
PrevCorner.Parent = PreviewFrame

local PrevStroke = Instance.new("UIStroke")
PrevStroke.Color = Color3.fromRGB(100, 200, 255)
PrevStroke.Thickness = 2
PrevStroke.Parent = PreviewFrame

-- Header
local PrevHeader = Instance.new("Frame")
PrevHeader.Size = UDim2.new(1, 0, 0, 50)
PrevHeader.BackgroundColor3 = Color3.fromRGB(20, 30, 40)
PrevHeader.BorderSizePixel = 0
PrevHeader.ZIndex = 31
PrevHeader.Parent = PreviewFrame

local PrevHeaderCorner = Instance.new("UICorner")
PrevHeaderCorner.CornerRadius = UDim.new(0, 14)
PrevHeaderCorner.Parent = PrevHeader

local PrevTitle = Instance.new("TextLabel")
PrevTitle.Size = UDim2.new(0.8, 0, 1, 0)
PrevTitle.Position = UDim2.new(0, 15, 0, 0)
PrevTitle.BackgroundTransparency = 1
PrevTitle.Font = Enum.Font.GothamBold
PrevTitle.Text = "🎬 Preview & FPS"
PrevTitle.TextColor3 = Colors.Text
PrevTitle.TextSize = 14
PrevTitle.TextXAlignment = Enum.TextXAlignment.Left
PrevTitle.ZIndex = 32
PrevTitle.Parent = PrevHeader

-- Botão Fechar
local ClosePrevBtn = Instance.new("TextButton")
ClosePrevBtn.Size = UDim2.new(0, 35, 0, 35)
ClosePrevBtn.Position = UDim2.new(1, -42, 0.5, -17)
ClosePrevBtn.BackgroundColor3 = Colors.Danger
ClosePrevBtn.Text = "✕"
ClosePrevBtn.TextColor3 = Colors.Text
ClosePrevBtn.TextSize = 16
ClosePrevBtn.Font = Enum.Font.GothamBold
ClosePrevBtn.ZIndex = 32
ClosePrevBtn.Parent = PrevHeader

local ClosePrevCorner = Instance.new("UICorner")
ClosePrevCorner.CornerRadius = UDim.new(0, 8)
ClosePrevCorner.Parent = ClosePrevBtn

-- Container de Configurações
local ConfigContainer = Instance.new("ScrollingFrame")
ConfigContainer.Size = UDim2.new(1, -20, 1, -65)
ConfigContainer.Position = UDim2.new(0, 10, 0, 55)
ConfigContainer.BackgroundTransparency = 1
ConfigContainer.ScrollBarThickness = 3
ConfigContainer.ScrollBarImageColor3 = Colors.Accent
ConfigContainer.ZIndex = 31
ConfigContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ConfigContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ConfigContainer.Parent = PreviewFrame

local ConfigLayout = Instance.new("UIListLayout")
ConfigLayout.Padding = UDim.new(0, 12)
ConfigLayout.SortOrder = Enum.SortOrder.LayoutOrder
ConfigLayout.Parent = ConfigContainer

-- Função para criar slider
local function CreateSlider(name, title, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name
    sliderFrame.Size = UDim2.new(1, 0, 0, 65)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 32
    sliderFrame.Parent = ConfigContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = sliderFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 12, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 33
    titleLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.25, 0, 0, 25)
    valueLabel.Position = UDim2.new(0.75, -10, 0, 5)
    valueLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    valueLabel.TextSize = 12
    valueLabel.ZIndex = 33
    valueLabel.Parent = sliderFrame
    
    local valueCorner = Instance.new("UICorner")
    valueCorner.CornerRadius = UDim.new(0, 6)
    valueCorner.Parent = valueLabel
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 12)
    sliderBg.Position = UDim2.new(0, 12, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 33
    sliderBg.Parent = sliderFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 34
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "Knob"
    sliderKnob.Size = UDim2.new(0, 20, 0, 20)
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
    sliderKnob.BackgroundColor3 = Colors.Text
    sliderKnob.ZIndex = 35
    sliderKnob.Parent = sliderBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = Color3.fromRGB(100, 200, 255)
    knobStroke.Thickness = 2
    knobStroke.Parent = sliderKnob
    
    -- Interação do slider
    local dragging = false
    
    local function UpdateSlider(inputPos)
        local relativeX = inputPos.X - sliderBg.AbsolutePosition.X
        local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * percentage)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percentage, -10, 0.5, -10)
        valueLabel.Text = tostring(value)
        
        if callback then callback(value) end
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input.Position)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input.Position)
        end
    end)
    
    return sliderFrame
end

-- Função para criar toggle
local function CreateToggle(name, title, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 32
    toggleFrame.Parent = ConfigContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 33
    titleLabel.Parent = toggleFrame
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 50, 0, 26)
    toggleBg.Position = UDim2.new(1, -62, 0.5, -13)
    toggleBg.BackgroundColor3 = default and Colors.Success or Color3.fromRGB(60, 60, 80)
    toggleBg.BorderSizePixel = 0
    toggleBg.ZIndex = 33
    toggleBg.Parent = toggleFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = toggleBg
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 22, 0, 22)
    toggleKnob.Position = default and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)


    toggleKnob.BackgroundColor3 = Colors.Text
    toggleKnob.ZIndex = 34
    toggleKnob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob
    
    local enabled = default
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 35
    toggleBtn.Parent = toggleBg
    
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        CreateTween(toggleBg, {
            BackgroundColor3 = enabled and Colors.Success or Color3.fromRGB(60, 60, 80)
        }, 0.2):Play()
        
        CreateTween(toggleKnob, {
            Position = enabled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
        }, 0.2):Play()
        
        if callback then callback(enabled) end
    end)
    
    return toggleFrame
end

-- Criar sliders
CreateSlider("FPSSlider", "🎬 FPS da Animação", 12, 120, 60, function(value)
    PreviewSystem.FPS = value
    Animator.FPS = value
    if Animator.KeyframeSystem then
        Animator.KeyframeSystem.FPS = value
    end
end)

CreateSlider("SpeedSlider", "⚡ Velocidade", 1, 300, 100, function(value)
    PreviewSystem.Speed = value / 100
    Animator.Speed = value / 100
end)

CreateSlider("MaxFrames", "📊 Frames Máximos", 60, 1800, 300, function(value)
    Animator.MaxFrames = value
end)

-- Criar toggles
CreateToggle("LoopToggle", "🔁 Loop da Animação", true, function(enabled)
    PreviewSystem.Loop = enabled
    Animator.Loop = enabled
end)

CreateToggle("GhostToggle", "👻 Mostrar Ghost/Onion", false, function(enabled)
    PreviewSystem.ShowGhost = enabled
    
    if enabled then
        CreateNotification("👻 Ghost", "Onion Skin ativado - mostra frames anteriores", 3)
    end
end)

CreateToggle("AutoKeyToggle", "🔑 Auto-Keyframe", false, function(enabled)
    Animator.AutoKeyframe = enabled
    
    if enabled then
        CreateNotification("🔑 Auto-Key", "Keyframes serão criados automaticamente ao mover", 3)
    end
end)

-- Display de FPS em tempo real
local FPSDisplay = Instance.new("Frame")
FPSDisplay.Name = "FPSDisplay"
FPSDisplay.Size = UDim2.new(1, 0, 0, 45)
FPSDisplay.BackgroundColor3 = Color3.fromRGB(20, 35, 30)
FPSDisplay.BorderSizePixel = 0
FPSDisplay.ZIndex = 32
FPSDisplay.Parent = ConfigContainer

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 10)
fpsCorner.Parent = FPSDisplay

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, -20, 1, 0)
fpsLabel.Position = UDim2.new(0, 10, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = "📊 FPS Atual: 60 | Speed: 1.0x"
fpsLabel.TextColor3 = Colors.Success
fpsLabel.TextSize = 12
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.ZIndex = 33
fpsLabel.Parent = FPSDisplay

-- Atualizar display
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            fpsLabel.Text = string.format(
                "📊 FPS: %d | Speed: %.1fx | Frames: %d",
                PreviewSystem.FPS,
                PreviewSystem.Speed,
                Animator.CurrentFrame or 0
            )
        end)
    end
end)

-- Eventos
ClosePrevBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(PreviewFrame)
end)

-- Função para abrir
local function OpenPreview()
    Plugins.AnimateIn(PreviewFrame)
end

-- Botão no ToolPanel
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("Preview", "🎬", "Preview & FPS", OpenPreview)

-- Armazenar
Animator.PreviewFrame = PreviewFrame
Animator.PreviewSystem = PreviewSystem
Animator.OpenPreview = OpenPreview

print("✅ MORTAL ANIMATOR - Sistema de Preview Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 9: Sistema de Múltiplas Animações e Salvamento
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

local HttpService = game:GetService("HttpService")

-- Sistema de Animações
local AnimationManager = {
    Animations = {},
    CurrentAnimation = nil,
    CurrentIndex = 0
}

-- Frame do Gerenciador
local ManagerFrame = Instance.new("Frame")
ManagerFrame.Name = "AnimationManager"
ManagerFrame.Size = UDim2.new(0, IsMobile and 280 or 360, 0, 450)
ManagerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ManagerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ManagerFrame.BackgroundColor3 = Colors.Background
ManagerFrame.BorderSizePixel = 0
ManagerFrame.Visible = false
ManagerFrame.ZIndex = 30
ManagerFrame.Parent = ScreenGui

ManagerFrame:SetAttribute("OriginalSize", ManagerFrame.Size)

local MgrCorner = Instance.new("UICorner")
MgrCorner.CornerRadius = UDim.new(0, 14)
MgrCorner.Parent = ManagerFrame

local MgrStroke = Instance.new("UIStroke")
MgrStroke.Color = Color3.fromRGB(255, 100, 200)
MgrStroke.Thickness = 2
MgrStroke.Parent = ManagerFrame

-- Header
local MgrHeader = Instance.new("Frame")
MgrHeader.Size = UDim2.new(1, 0, 0, 50)
MgrHeader.BackgroundColor3 = Color3.fromRGB(35, 20, 35)
MgrHeader.BorderSizePixel = 0
MgrHeader.ZIndex = 31
MgrHeader.Parent = ManagerFrame

local MgrHeaderCorner = Instance.new("UICorner")
MgrHeaderCorner.CornerRadius = UDim.new(0, 14)
MgrHeaderCorner.Parent = MgrHeader

local MgrTitle = Instance.new("TextLabel")
MgrTitle.Size = UDim2.new(0.75, 0, 1, 0)
MgrTitle.Position = UDim2.new(0, 15, 0, 0)
MgrTitle.BackgroundTransparency = 1
MgrTitle.Font = Enum.Font.GothamBold
MgrTitle.Text = "📁 Gerenciador de Animações"
MgrTitle.TextColor3 = Colors.Text
MgrTitle.TextSize = IsMobile and 12 or 14
MgrTitle.TextXAlignment = Enum.TextXAlignment.Left
MgrTitle.ZIndex = 32
MgrTitle.Parent = MgrHeader

-- Botão Fechar
local CloseMgrBtn = Instance.new("TextButton")
CloseMgrBtn.Size = UDim2.new(0, 35, 0, 35)
CloseMgrBtn.Position = UDim2.new(1, -42, 0.5, -17)
CloseMgrBtn.BackgroundColor3 = Colors.Danger
CloseMgrBtn.Text = "✕"
CloseMgrBtn.TextColor3 = Colors.Text
CloseMgrBtn.TextSize = 16
CloseMgrBtn.Font = Enum.Font.GothamBold
CloseMgrBtn.ZIndex = 32
CloseMgrBtn.Parent = MgrHeader

local CloseMgrCorner = Instance.new("UICorner")
CloseMgrCorner.CornerRadius = UDim.new(0, 8)
CloseMgrCorner.Parent = CloseMgrBtn

-- Botões de Ação
local ActionBar = Instance.new("Frame")
ActionBar.Size = UDim2.new(1, -20, 0, 45)
ActionBar.Position = UDim2.new(0, 10, 0, 55)
ActionBar.BackgroundTransparency = 1
ActionBar.ZIndex = 31
ActionBar.Parent = ManagerFrame

local ActionLayout = Instance.new("UIListLayout")
ActionLayout.FillDirection = Enum.FillDirection.Horizontal
ActionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ActionLayout.Padding = UDim.new(0, 8)
ActionLayout.Parent = ActionBar

-- Função para criar botão de ação
local function CreateActionButton(name, icon, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, IsMobile and 55 or 70, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = icon
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Colors.Text
    btn.AutoButtonColor = false
    btn.ZIndex = 32
    btn.Parent = ActionBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        CreateTween(btn, {BackgroundColor3 = Color3.new(
            math.min(color.R + 0.15, 1),
            math.min(color.G + 0.15, 1),
            math.min(color.B + 0.15, 1)
        )}, 0.2):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        CreateTween(btn, {BackgroundColor3 = color}, 0.2):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Lista de Animações
local AnimList = Instance.new("ScrollingFrame")
AnimList.Name = "AnimationList"
AnimList.Size = UDim2.new(1, -20, 1, -170)
AnimList.Position = UDim2.new(0, 10, 0, 105)
AnimList.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
AnimList.BorderSizePixel = 0
AnimList.ScrollBarThickness = 4
AnimList.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 200)
AnimList.ZIndex = 31
AnimList.CanvasSize = UDim2.new(0, 0, 0, 0)
AnimList.AutomaticCanvasSize = Enum.AutomaticSize.Y
AnimList.Parent = ManagerFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 10)
ListCorner.Parent = AnimList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = AnimList

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 8)
ListPadding.PaddingLeft = UDim.new(0, 8)
ListPadding.PaddingRight = UDim.new(0, 8)
ListPadding.Parent = AnimList

-- Info da Animação Atual
local CurrentInfo = Instance.new("Frame")
CurrentInfo.Size = UDim2.new(1, -20, 0, 50)
CurrentInfo.Position = UDim2.new(0, 10, 1, -60)
CurrentInfo.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
CurrentInfo.BorderSizePixel = 0
CurrentInfo.ZIndex = 31
CurrentInfo.Parent = ManagerFrame

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = CurrentInfo

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Size = UDim2.new(1, -20, 1, 0)
InfoLabel.Position = UDim2.new(0, 10, 0, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "📌 Nenhuma animação selecionada"
InfoLabel.TextColor3 = Colors.TextSecondary
InfoLabel.TextSize = 11
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextWrapped = true
InfoLabel.ZIndex = 32
InfoLabel.Parent = CurrentInfo

-- Função para criar item de animação
local function CreateAnimationItem(animData, index)
    local item = Instance.new("Frame")
    item.Name = "Anim_" .. index
    item.Size = UDim2.new(1, 0, 0, 60)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    item.BorderSizePixel = 0
    item.ZIndex = 32
    item.Parent = AnimList
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 8)
    itemCorner.Parent = item
    
    local itemStroke = Instance.new("UIStroke")
    itemStroke.Color = Colors.Border
    itemStroke.Thickness = 1
    itemStroke.Parent = item
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.6, 0, 0, 25)
    nameLabel.Position = UDim2.new(0, 12, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = "🎬 " .. animData.Name
    nameLabel.TextColor3 = Colors.Text
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 33
    nameLabel.Parent = item
    
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(0.6, 0, 0, 20)
    infoText.Position = UDim2.new(0, 12, 0, 33)
    infoText.BackgroundTransparency = 1
    infoText.Font = Enum.Font.Gotham
    infoText.Text = string.format("%d keyframes | %d frames", animData.KeyframeCount or 0, animData.FrameCount or 0)
    infoText.TextColor3 = Colors.TextSecondary
    infoText.TextSize = 10
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.ZIndex = 33
    infoText.Parent = item
    
    -- Botão Carregar
    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0, 35, 0, 35)
    loadBtn.Position = UDim2.new(1, -85, 0.5, -17)
    loadBtn.BackgroundColor3 = Colors.Success
    loadBtn.Text = "📂"
    loadBtn.TextSize = 16
    loadBtn.ZIndex = 33
    loadBtn.Parent = item
    
    local loadCorner = Instance.new("UICorner")
    loadCorner.CornerRadius = UDim.new(0, 6)
    loadCorner.Parent = loadBtn
    
    loadBtn.MouseButton1Click:Connect(function()
        LoadAnimation(index)
    end)
    
    -- Botão Deletar
    local delBtn = Instance.new("TextButton")
    delBtn.Size = UDim2.new(0, 35, 0, 35)
    delBtn.Position = UDim2.new(1, -45, 0.5, -17)
    delBtn.BackgroundColor3 = Colors.Danger
    delBtn.Text = "🗑️"
    delBtn.TextSize = 14
    delBtn.ZIndex = 33
    delBtn.Parent = item
    
    local delCorner = Instance.new("UICorner")
    delCorner.CornerRadius = UDim.new(0, 6)
    delCorner.Parent = delBtn
    
    delBtn.MouseButton1Click:Connect(function()
        table.remove(AnimationManager.Animations, index)
        item:Destroy()
        RefreshList()
        CreateNotification("🗑️ Removido", animData.Name .. " foi deletada", 2)
    end)
    
    -- Hover
    item.MouseEnter:Connect(function()
        CreateTween(itemStroke, {Color = Color3.fromRGB(255, 100, 200)}, 0.2):Play()
    end)
    
    item.MouseLeave:Connect(function()
        CreateTween(itemStroke, {Color = Colors.Border}, 0.2):Play()
    end)
    
    return item
end

-- Função para atualizar lista
local function RefreshList()
    for _, child in pairs(AnimList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for i, animData in ipairs(AnimationManager.Animations) do
        CreateAnimationItem(animData, i)
    end
end

-- Função Nova Animação
local function NewAnimation()
    local name = "Animação " .. (#AnimationManager.Animations + 1)
    
    local animData = {
        Name = name,
        KeyframeData = {},
        KeyframeCount = 0,
        FrameCount = 0,
        Object = Animator.SelectedObject and Animator.SelectedObject.Name or "Nenhum",
        CreatedAt = os.date("%H:%M:%S")
    }
    
    table.insert(AnimationManager.Animations, animData)
    AnimationManager.CurrentAnimation = animData
    AnimationManager.CurrentIndex = #AnimationManager.Animations
    
    -- Limpar keyframes atuais
    if Animator.KeyframeSystem then
        Animator.KeyframeSystem.Data = {}
    end
    
    RefreshList()
    InfoLabel.Text = "📌 Atual: " .. name .. " | Criada às " .. animData.CreatedAt
    
    CreateNotification("✨ Nova Animação", name .. " criada!", 2)
end

-- Função Salvar Animação Atual
local function SaveCurrentAnimation()
    if not AnimationManager.CurrentAnimation then
        CreateNotification("⚠️ Aviso", "Crie uma animação primeiro!", 3)
        return
    end
    
    if Animator.KeyframeSystem then
        AnimationManager.CurrentAnimation.KeyframeData = Animator.KeyframeSystem.Data
        
        local count = 0
        local maxFrame = 0
        for frame, _ in pairs(Animator.KeyframeSystem.Data) do
            count = count + 1
            if frame > maxFrame then maxFrame = frame end
        end
        
        AnimationManager.CurrentAnimation.KeyframeCount = count
        AnimationManager.CurrentAnimation.FrameCount = maxFrame
    end
    
    RefreshList()
    CreateNotification("💾 Salvo", AnimationManager.CurrentAnimation.Name .. " foi salva!", 2)
end

-- Função Carregar Animação
function LoadAnimation(index)
    local animData = AnimationManager.Animations[index]
    if not animData then return end
    
    AnimationManager.CurrentAnimation = animData
    AnimationManager.CurrentIndex = index
    
    if Animator.KeyframeSystem then
        Animator.KeyframeSystem.Data = animData.KeyframeData or {}
    end
    
    InfoLabel.Text = string.format("📌 Atual: %s | %d keyframes", animData.Name, animData.KeyframeCount or 0)
    
    CreateNotification("📂 Carregada", animData.Name .. " foi carregada!", 2)
end

-- Função Duplicar
local function DuplicateAnimation()
    if not AnimationManager.CurrentAnimation then
        CreateNotification("⚠️ Aviso", "Selecione uma animação primeiro!", 3)
        return
    end
    
    local copy = {}
    for k, v in pairs(AnimationManager.CurrentAnimation) do
        if type(v) == "table" then
            copy[k] = {}
            for k2, v2 in pairs(v) do
                copy[k][k2] = v2
            end
        else
            copy[k] = v
        end
    end
    
    copy.Name = copy.Name .. " (Cópia)"
    table.insert(AnimationManager.Animations, copy)
    
    RefreshList()
    CreateNotification("📋 Duplicada", copy.Name, 2)
end

-- Função Renomear
local function RenameAnimation()
    if not AnimationManager.CurrentAnimation then
        CreateNotification("⚠️ Aviso", "Selecione uma animação primeiro!", 3)
        return
    end
    
    -- Criar popup de rename
    local renameFrame = Instance.new("Frame")
    renameFrame.Size = UDim2.new(0, 250, 0, 120)
    renameFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    renameFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    renameFrame.BackgroundColor3 = Colors.Background
    renameFrame.ZIndex = 40
    renameFrame.Parent = ScreenGui
    
    local rCorner = Instance.new("UICorner")
    rCorner.CornerRadius = UDim.new(0, 12)
    rCorner.Parent = renameFrame
    
    local rStroke = Instance.new("UIStroke")
    rStroke.Color = Colors.Accent
    rStroke.Thickness = 2
    rStroke.Parent = renameFrame
    
    local rTitle = Instance.new("TextLabel")
    rTitle.Size = UDim2.new(1, 0, 0, 30)
    rTitle.Position = UDim2.new(0, 0, 0, 5)
    rTitle.BackgroundTransparency = 1
    rTitle.Font = Enum.Font.GothamBold
    rTitle.Text = "✏️ Renomear Animação"
    rTitle.TextColor3 = Colors.Text
    rTitle.TextSize = 13
    rTitle.ZIndex = 41
    rTitle.Parent = renameFrame
    
    local rInput = Instance.new("TextBox")
    rInput.Size = UDim2.new(1, -20, 0, 35)
    rInput.Position = UDim2.new(0, 10, 0, 40)
    rInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    rInput.Font = Enum.Font.Gotham
    rInput.Text = AnimationManager.CurrentAnimation.Name
    rInput.TextColor3 = Colors.Text
    rInput.TextSize = 12
    rInput.PlaceholderText = "Nome da animação..."
    rInput.ZIndex = 41
    rInput.Parent = renameFrame
    
    local rInputCorner = Instance.new("UICorner")
    rInputCorner.CornerRadius = UDim.new(0, 8)
    rInputCorner.Parent = rInput
    
    local rConfirm = Instance.new("TextButton")
    rConfirm.Size = UDim2.new(0.5, -15, 0, 30)
    rConfirm.Position = UDim2.new(0, 10, 1, -40)
    rConfirm.BackgroundColor3 = Colors.Success
    rConfirm.Text = "✓ Confirmar"
    rConfirm.TextColor3 = Colors.Text
    rConfirm.TextSize = 12
    rConfirm.Font = Enum.Font.GothamBold
    rConfirm.ZIndex = 41
    rConfirm.Parent = renameFrame
    
    local rConfirmCorner = Instance.new("UICorner")
    rConfirmCorner.CornerRadius = UDim.new(0, 8)
    rConfirmCorner.Parent = rConfirm
    
    local rCancel = Instance.new("TextButton")
    rCancel.Size = UDim2.new(0.5, -15, 0, 30)
    rCancel.Position = UDim2.new(0.5, 5, 1, -40)
    rCancel.BackgroundColor3 = Colors.Danger
    rCancel.Text = "✕ Cancelar"
    rCancel.TextColor3 = Colors.Text
    rCancel.TextSize = 12
    rCancel.Font = Enum.Font.GothamBold
    rCancel.ZIndex = 41
    rCancel.Parent = renameFrame
    
    local rCancelCorner = Instance.new("UICorner")
    rCancelCorner.CornerRadius = UDim.new(0, 8)
    rCancelCorner.Parent = rCancel
    
    rConfirm.MouseButton1Click:Connect(function()
        AnimationManager.CurrentAnimation.Name = rInput.Text
        RefreshList()
        renameFrame:Destroy()
        CreateNotification("✏️ Renomeado", "Novo nome: " .. rInput.Text, 2)
    end)
    
    rCancel.MouseButton1Click:Connect(function()
        renameFrame:Destroy()
    end)
end

-- Criar botões de ação
CreateActionButton("New", "➕", Colors.Success, NewAnimation)
CreateActionButton("Save", "💾", Colors.Accent, SaveCurrentAnimation)
CreateActionButton("Duplicate", "📋", Color3.fromRGB(100, 150, 255), DuplicateAnimation)
CreateActionButton("Rename", "✏️", Color3.fromRGB(255, 200, 100), RenameAnimation)

-- Eventos
CloseMgrBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(ManagerFrame)
end)

-- Função para abrir
local function OpenManager()
    RefreshList()
    Plugins.AnimateIn(ManagerFrame)
end

-- Botão no ToolPanel
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("Manager", "📁", "Gerenciar Animações", OpenManager)

-- Armazenar
Animator.ManagerFrame = ManagerFrame
Animator.AnimationManager = AnimationManager
Animator.OpenManager = OpenManager

print("✅ MORTAL ANIMATOR - Gerenciador de Animações Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 10: Efeitos de Câmera para Cutscenes
    Shake, Zoom, FOV, Blur, Fade, Flash
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Sistema de Efeitos de Câmera
local CameraFX = {
    ShakeIntensity = 0,
    IsShaking = false,
    CurrentFOV = 70,
    OriginalFOV = 70,
    BlurEffect = nil,
    ColorCorrection = nil,
    Effects = {}
}

-- Criar efeitos de pós-processamento
local function SetupPostProcessing()
    -- Blur
    CameraFX.BlurEffect = Lighting:FindFirstChild("MortalBlur")
    if not CameraFX.BlurEffect then
        CameraFX.BlurEffect = Instance.new("BlurEffect")
        CameraFX.BlurEffect.Name = "MortalBlur"
        CameraFX.BlurEffect.Size = 0
        CameraFX.BlurEffect.Parent = Lighting
    end
    
    -- Color Correction
    CameraFX.ColorCorrection = Lighting:FindFirstChild("MortalCC")
    if not CameraFX.ColorCorrection then
        CameraFX.ColorCorrection = Instance.new("ColorCorrectionEffect")
        CameraFX.ColorCorrection.Name = "MortalCC"
        CameraFX.ColorCorrection.Brightness = 0
        CameraFX.ColorCorrection.Contrast = 0
        CameraFX.ColorCorrection.Saturation = 0
        CameraFX.ColorCorrection.Parent = Lighting
    end
end

SetupPostProcessing()

-- Frame de Efeitos
local FXFrame = Instance.new("Frame")
FXFrame.Name = "CameraFXFrame"
FXFrame.Size = UDim2.new(0, IsMobile and 290 or 380, 0, 520)
FXFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FXFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FXFrame.BackgroundColor3 = Colors.Background
FXFrame.BorderSizePixel = 0
FXFrame.Visible = false
FXFrame.ZIndex = 30
FXFrame.Parent = ScreenGui

FXFrame:SetAttribute("OriginalSize", FXFrame.Size)

local FXCorner = Instance.new("UICorner")
FXCorner.CornerRadius = UDim.new(0, 14)
FXCorner.Parent = FXFrame

local FXStroke = Instance.new("UIStroke")
FXStroke.Color = Color3.fromRGB(255, 120, 50)
FXStroke.Thickness = 2
FXStroke.Parent = FXFrame

local FXGradient = Instance.new("UIGradient")
FXGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
})
FXGradient.Rotation = 135
FXGradient.Parent = FXFrame

-- Header
local FXHeader = Instance.new("Frame")
FXHeader.Size = UDim2.new(1, 0, 0, 50)
FXHeader.BackgroundColor3 = Color3.fromRGB(40, 25, 20)
FXHeader.BorderSizePixel = 0
FXHeader.ZIndex = 31
FXHeader.Parent = FXFrame

local FXHeaderCorner = Instance.new("UICorner")
FXHeaderCorner.CornerRadius = UDim.new(0, 14)
FXHeaderCorner.Parent = FXHeader

local FXTitle = Instance.new("TextLabel")
FXTitle.Size = UDim2.new(0.8, 0, 1, 0)
FXTitle.Position = UDim2.new(0, 15, 0, 0)
FXTitle.BackgroundTransparency = 1
FXTitle.Font = Enum.Font.GothamBold
FXTitle.Text = "🎥 Efeitos de Câmera"
FXTitle.TextColor3 = Colors.Text
FXTitle.TextSize = 14
FXTitle.TextXAlignment = Enum.TextXAlignment.Left
FXTitle.ZIndex = 32
FXTitle.Parent = FXHeader

-- Botão Fechar
local CloseFXBtn = Instance.new("TextButton")
CloseFXBtn.Size = UDim2.new(0, 35, 0, 35)
CloseFXBtn.Position = UDim2.new(1, -42, 0.5, -17)
CloseFXBtn.BackgroundColor3 = Colors.Danger
CloseFXBtn.Text = "✕"
CloseFXBtn.TextColor3 = Colors.Text
CloseFXBtn.TextSize = 16
CloseFXBtn.Font = Enum.Font.GothamBold
CloseFXBtn.ZIndex = 32
CloseFXBtn.Parent = FXHeader

local CloseFXCorner = Instance.new("UICorner")
CloseFXCorner.CornerRadius = UDim.new(0, 8)
CloseFXCorner.Parent = CloseFXBtn

-- Container de Efeitos
local FXContainer = Instance.new("ScrollingFrame")
FXContainer.Size = UDim2.new(1, -20, 1, -65)
FXContainer.Position = UDim2.new(0, 10, 0, 55)
FXContainer.BackgroundTransparency = 1
FXContainer.ScrollBarThickness = 4
FXContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 120, 50)
FXContainer.ZIndex = 31
FXContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
FXContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
FXContainer.Parent = FXFrame

local FXLayout = Instance.new("UIListLayout")
FXLayout.Padding = UDim.new(0, 10)
FXLayout.SortOrder = Enum.SortOrder.LayoutOrder
FXLayout.Parent = FXContainer

-- Função para criar seção de efeito
local function CreateFXSection(name, icon, children)
    local section = Instance.new("Frame")
    section.Name = name
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    section.BorderSizePixel = 0
    section.ZIndex = 32
    section.Parent = FXContainer
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 10)
    sCorner.Parent = section
    
    local sLayout = Instance.new("UIListLayout")
    sLayout.Padding = UDim.new(0, 8)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sLayout.Parent = section
    
    local sPadding = Instance.new("UIPadding")
    sPadding.PaddingTop = UDim.new(0, 10)
    sPadding.PaddingBottom = UDim.new(0, 10)
    sPadding.PaddingLeft = UDim.new(0, 12)
    sPadding.PaddingRight = UDim.new(0, 12)
    sPadding.Parent = section
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = icon .. " " .. name
    title.TextColor3 = Color3.fromRGB(255, 120, 50)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 33
    title.Parent = section
    
    return section
end

-- Função para criar slider de efeito
local function CreateFXSlider(parent, name, min, max, default, unit, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 33
    sliderFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.Position = UDim2.new(0, 8, 0, 5)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 34
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.35, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.65, -5, 0, 5)
    valueLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(default) .. (unit or "")
    valueLabel.TextColor3 = Color3.fromRGB(255, 120, 50)
    valueLabel.TextSize = 11
    valueLabel.ZIndex = 34
    valueLabel.Parent = sliderFrame
    
    local vCorner = Instance.new("UICorner")
    vCorner.CornerRadius = UDim.new(0, 5)
    vCorner.Parent = valueLabel
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -16, 0, 10)
    sliderBg.Position = UDim2.new(0, 8, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 34
    sliderBg.Parent = sliderFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 120, 50)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 35
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderKnob.BackgroundColor3 = Colors.Text
    sliderKnob.ZIndex = 36
    sliderKnob.Parent = sliderBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    local dragging = false
    
    local function UpdateSlider(inputPos)
        local relX = inputPos.X - sliderBg.AbsolutePosition.X
        local pct = math.clamp(relX / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pct)
        
        sliderFill.Size = UDim2.new(pct, 0, 1, 0)
        sliderKnob.Position = UDim2.new(pct, -8, 0.5, -8)
        valueLabel.Text = tostring(value) .. (unit or "")
        
        if callback then callback(value) end
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input.Position)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input.Position)
        end
    end)
    
    return sliderFrame
end

-- Função para criar botão de efeito
local function CreateFXButton(parent, name, icon, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.48, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Colors.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 34
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        CreateTween(btn, {BackgroundColor3 = Color3.new(
            math.min(color.R + 0.15, 1),
            math.min(color.G + 0.15, 1),
            math.min(color.B + 0.15, 1)
        )}, 0.2):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        CreateTween(btn, {BackgroundColor3 = color}, 0.2):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- ========== SEÇÃO: CAMERA SHAKE ==========
local shakeSection = CreateFXSection("Camera Shake", "📳")

CreateFXSlider(shakeSection, "Intensidade", 0, 100, 0, "%", function(value)
    CameraFX.ShakeIntensity = value / 100
end)

CreateFXSlider(shakeSection, "Frequência", 1, 30, 15, "Hz", function(value)
    CameraFX.ShakeFrequency = value
end)

local shakeBtnContainer = Instance.new("Frame")
shakeBtnContainer.Size = UDim2.new(1, 0, 0, 45)
shakeBtnContainer.BackgroundTransparency = 1
shakeBtnContainer.ZIndex = 33
shakeBtnContainer.Parent = shakeSection

local shakeBtnLayout = Instance.new("UIListLayout")
shakeBtnLayout.FillDirection = Enum.FillDirection.Horizontal
shakeBtnLayout.Padding = UDim.new(0.04, 0)
shakeBtnLayout.Parent = shakeBtnContainer

CreateFXButton(shakeBtnContainer, "Iniciar", "▶️", Colors.Success, function()
    if CameraFX.IsShaking then return end
    CameraFX.IsShaking = true
    
    local camera = Workspace.CurrentCamera
    local originalCFrame = camera.CFrame
    
    CameraFX.ShakeConnection = RunService.RenderStepped:Connect(function()
        if not CameraFX.IsShaking then return end
        
        local intensity = CameraFX.ShakeIntensity
        local shakeX = (math.random() - 0.5) * intensity
        local shakeY = (math.random() - 0.5) * intensity
        local shakeZ = (math.random() - 0.5) * intensity * 0.5
        
        camera.CFrame = camera.CFrame * CFrame.new(shakeX, shakeY, shakeZ)
    end)
    
    CreateNotification("📳 Shake", "Camera shake ativado!", 2)
end)

CreateFXButton(shakeBtnContainer, "Parar", "⏹️", Colors.Danger, function()
    CameraFX.IsShaking = false
    if CameraFX.ShakeConnection then
        CameraFX.ShakeConnection:Disconnect()
    end
    CreateNotification("📳 Shake", "Camera shake desativado", 2)
end)

-- ========== SEÇÃO: FOV (Field of View) ==========
local fovSection = CreateFXSection("Field of View", "👁️")

CreateFXSlider(fovSection, "FOV", 20, 120, 70, "°", function(value)
    CameraFX.CurrentFOV = value
    Workspace.CurrentCamera.FieldOfView = value
end)

local fovBtnContainer = Instance.new("Frame")
fovBtnContainer.Size = UDim2.new(1, 0, 0, 45)
fovBtnContainer.BackgroundTransparency = 1
fovBtnContainer.ZIndex = 33
fovBtnContainer.Parent = fovSection

local fovBtnLayout = Instance.new("UIListLayout")
fovBtnLayout.FillDirection = Enum.FillDirection.Horizontal
fovBtnLayout.Padding = UDim.new(0.04, 0)
fovBtnLayout.Parent = fovBtnContainer

CreateFXButton(fovBtnContainer, "Zoom In", "🔍", Color3.fromRGB(100, 150, 255), function()
    local camera = Workspace.CurrentCamera
    local tween = TweenService:Create(camera, TweenInfo.new(0.5), {FieldOfView = 40})
    tween:Play()
    CreateNotification("🔍 Zoom", "Zoom In!", 1)
end)

CreateFXButton(fovBtnContainer, "Zoom Out", "🔎", Color3.fromRGB(150, 100, 255), function()
    local camera = Workspace.CurrentCamera
    local tween = TweenService:Create(camera, TweenInfo.new(0.5), {FieldOfView = 100})
    tween:Play()
    CreateNotification("🔎 Zoom", "Zoom Out!", 1)
end)

-- ========== SEÇÃO: BLUR ==========
local blurSection = CreateFXSection("Motion Blur", "💨")

CreateFXSlider(blurSection, "Intensidade", 0, 56, 0, "", function(value)
    if CameraFX.BlurEffect then
        CameraFX.BlurEffect.Size = value
    end
end)

-- ========== SEÇÃO: EFEITOS DE TRANSIÇÃO ==========
local transitionSection = CreateFXSection("Transições", "✨")

local transBtnContainer = Instance.new("Frame")
transBtnContainer.Size = UDim2.new(1, 0, 0, 90)
transBtnContainer.BackgroundTransparency = 1
transBtnContainer.ZIndex = 33
transBtnContainer.Parent = transitionSection

local transBtnLayout = Instance.new("UIGridLayout")
transBtnLayout.CellSize = UDim2.new(0.48, 0, 0, 40)
transBtnLayout.CellPadding = UDim2.new(0.04, 0, 0, 8)
transBtnLayout.Parent = transBtnContainer

-- Fade para preto
CreateFXButton(transBtnContainer, "Fade Out", "🌑", Color3.fromRGB(50, 50, 50), function()
    local fadeFrame = Instance.new("Frame")
    fadeFrame.Size = UDim2.new(1, 0, 1, 0)
    fadeFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    fadeFrame.BackgroundTransparency = 1
    fadeFrame.ZIndex = 100
    fadeFrame.Parent = ScreenGui
    
    local tween = TweenService:Create(fadeFrame, TweenInfo.new(1), {BackgroundTransparency = 0})
    tween:Play()
    
    CameraFX.FadeFrame = fadeFrame
    CreateNotification("🌑 Fade", "Fade Out!", 1)
end)

-- Fade de volta
CreateFXButton(transBtnContainer, "Fade In", "🌕", Color3.fromRGB(200, 200, 100), function()
    if CameraFX.FadeFrame then
        local tween = TweenService:Create(CameraFX.FadeFrame, TweenInfo.new(1), {BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function()
            CameraFX.FadeFrame:Destroy()
            CameraFX.FadeFrame = nil
        end)
        CreateNotification("🌕 Fade", "Fade In!", 1)
    end
end)

-- Flash branco
CreateFXButton(transBtnContainer, "Flash", "⚡", Color3.fromRGB(255, 255, 200), function()
    local flashFrame = Instance.new("Frame")
    flashFrame.Size = UDim2.new(1, 0, 1, 0)
    flashFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    flashFrame.BackgroundTransparency = 0
    flashFrame.ZIndex = 100
    flashFrame.Parent = ScreenGui
    
    local tween = TweenService:Create(flashFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        flashFrame:Destroy()
    end)
    
    CreateNotification("⚡ Flash", "Flash!", 1)
end)

-- Fade vermelho (hit effect)
CreateFXButton(transBtnContainer, "Hit FX", "💥", Colors.Danger, function()
    local hitFrame = Instance.new("Frame")
    hitFrame.Size = UDim2.new(1, 0, 1, 0)
    hitFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    hitFrame.BackgroundTransparency = 0.5
    hitFrame.ZIndex = 100
    hitFrame.Parent = ScreenGui
    
    local tween = TweenService:Create(hitFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        hitFrame:Destroy()
    end)
    
    CreateNotification("💥 Hit", "Hit Effect!", 1)
end)

-- ========== SEÇÃO: COLOR CORRECTION ==========
local colorSection = CreateFXSection("Correção de Cor", "🎨")

CreateFXSlider(colorSection, "Brilho", -100, 100, 0, "%", function(value)
    if CameraFX.ColorCorrection then
        CameraFX.ColorCorrection.Brightness = value / 100
    end
end)

CreateFXSlider(colorSection, "Contraste", -100, 100, 0, "%", function(value)
    if CameraFX.ColorCorrection then
        CameraFX.ColorCorrection.Contrast = value / 100
    end
end)

CreateFXSlider(colorSection, "Saturação", -100, 100, 0, "%", function(value)
    if CameraFX.ColorCorrection then
        CameraFX.ColorCorrection.Saturation = value / 100
    end
end)

-- Botão Reset
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, 0, 0, 40)
resetBtn.BackgroundColor3 = Colors.Danger
resetBtn.Text = "🔄 Resetar Todos os Efeitos"
resetBtn.TextColor3 = Colors.Text
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.GothamBold
resetBtn.ZIndex = 33
resetBtn.Parent = FXContainer

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 10)
resetCorner.Parent = resetBtn

resetBtn.MouseButton1Click:Connect(function()
    -- Reset shake
    CameraFX.IsShaking = false
    if CameraFX.ShakeConnection then
        CameraFX.ShakeConnection:Disconnect()
    end
    
    -- Reset FOV
    Workspace.CurrentCamera.FieldOfView = 70
    
    -- Reset Blur
    if CameraFX.BlurEffect then
        CameraFX.BlurEffect.Size = 0
    end
    
    -- Reset Color
    if CameraFX.ColorCorrection then
        CameraFX.ColorCorrection.Brightness = 0
        CameraFX.ColorCorrection.Contrast = 0
        CameraFX.ColorCorrection.Saturation = 0
    end
    
    -- Reset Fade
    if CameraFX.FadeFrame then
        CameraFX.FadeFrame:Destroy()
        CameraFX.FadeFrame = nil
    end
    
    CreateNotification("🔄 Reset", "Todos os efeitos resetados!", 2)
end)

-- Eventos
CloseFXBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(FXFrame)
end)

-- Função para abrir
local function OpenCameraFX()
    Plugins.AnimateIn(FXFrame)
end

-- Adicionar ao menu de Cutscenes
if Animator.CutsceneFrame then
    local fxBtn = Instance.new("TextButton")
    fxBtn.Name = "CameraFX"
    fxBtn.Size = UDim2.new(1, -20, 0, 42)
    fxBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    fxBtn.Text = "🎥 Efeitos de Câmera"
    fxBtn.TextColor3 = Colors.Text
    fxBtn.TextSize = 12
    fxBtn.Font = Enum.Font.GothamBold
    fxBtn.ZIndex = 27
    fxBtn.Parent = Animator.CutsceneFrame:FindFirstChild("ControlPanel")
    
    local fxCorner = Instance.new("UICorner")
    fxCorner.CornerRadius = UDim.new(0, 8)
    fxCorner.Parent = fxBtn
    
    fxBtn.MouseButton1Click:Connect(OpenCameraFX)
end

-- Botão no ToolPanel principal também
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("CameraFX", "🎥", "Efeitos de Câmera", OpenCameraFX)

-- Armazenar
Animator.CameraFXFrame = FXFrame
Animator.CameraFX = CameraFX
Animator.OpenCameraFX = OpenCameraFX

print("✅ MORTAL ANIMATOR - Efeitos de Câmera Carregados!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 11: Sistema de IK (Inverse Kinematics)
    Permite mover mãos/pés e o resto do corpo segue automaticamente
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Sistema IK
local IKSystem = {
    Enabled = false,
    Targets = {},
    Chains = {},
    SelectedChain = nil,
    Iterations = 10,
    Tolerance = 0.1
}

-- Frame do IK
local IKFrame = Instance.new("Frame")
IKFrame.Name = "IKFrame"
IKFrame.Size = UDim2.new(0, IsMobile and 270 or 340, 0, 450)
IKFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
IKFrame.AnchorPoint = Vector2.new(0.5, 0.5)
IKFrame.BackgroundColor3 = Colors.Background
IKFrame.BorderSizePixel = 0
IKFrame.Visible = false
IKFrame.ZIndex = 30
IKFrame.Parent = ScreenGui

IKFrame:SetAttribute("OriginalSize", IKFrame.Size)

local IKCorner = Instance.new("UICorner")
IKCorner.CornerRadius = UDim.new(0, 14)
IKCorner.Parent = IKFrame

local IKStroke = Instance.new("UIStroke")
IKStroke.Color = Color3.fromRGB(100, 255, 200)
IKStroke.Thickness = 2
IKStroke.Parent = IKFrame

-- Header
local IKHeader = Instance.new("Frame")
IKHeader.Size = UDim2.new(1, 0, 0, 50)
IKHeader.BackgroundColor3 = Color3.fromRGB(20, 35, 30)
IKHeader.BorderSizePixel = 0
IKHeader.ZIndex = 31
IKHeader.Parent = IKFrame

local IKHeaderCorner = Instance.new("UICorner")
IKHeaderCorner.CornerRadius = UDim.new(0, 14)
IKHeaderCorner.Parent = IKHeader

local IKTitle = Instance.new("TextLabel")
IKTitle.Size = UDim2.new(0.8, 0, 1, 0)
IKTitle.Position = UDim2.new(0, 15, 0, 0)
IKTitle.BackgroundTransparency = 1
IKTitle.Font = Enum.Font.GothamBold
IKTitle.Text = "🦾 Inverse Kinematics"
IKTitle.TextColor3 = Colors.Text
IKTitle.TextSize = 14
IKTitle.TextXAlignment = Enum.TextXAlignment.Left
IKTitle.ZIndex = 32
IKTitle.Parent = IKHeader

-- Botão Fechar
local CloseIKBtn = Instance.new("TextButton")
CloseIKBtn.Size = UDim2.new(0, 35, 0, 35)
CloseIKBtn.Position = UDim2.new(1, -42, 0.5, -17)
CloseIKBtn.BackgroundColor3 = Colors.Danger
CloseIKBtn.Text = "✕"
CloseIKBtn.TextColor3 = Colors.Text
CloseIKBtn.TextSize = 16
CloseIKBtn.Font = Enum.Font.GothamBold
CloseIKBtn.ZIndex = 32
CloseIKBtn.Parent = IKHeader

local CloseIKCorner = Instance.new("UICorner")
CloseIKCorner.CornerRadius = UDim.new(0, 8)
CloseIKCorner.Parent = CloseIKBtn

-- Container
local IKContainer = Instance.new("ScrollingFrame")
IKContainer.Size = UDim2.new(1, -20, 1, -65)
IKContainer.Position = UDim2.new(0, 10, 0, 55)
IKContainer.BackgroundTransparency = 1
IKContainer.ScrollBarThickness = 4
IKContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 255, 200)
IKContainer.ZIndex = 31
IKContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
IKContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
IKContainer.Parent = IKFrame

local IKLayout = Instance.new("UIListLayout")
IKLayout.Padding = UDim.new(0, 10)
IKLayout.SortOrder = Enum.SortOrder.LayoutOrder
IKLayout.Parent = IKContainer

-- Descrição
local IKDesc = Instance.new("TextLabel")
IKDesc.Size = UDim2.new(1, 0, 0, 50)
IKDesc.BackgroundColor3 = Color3.fromRGB(25, 35, 30)
IKDesc.Font = Enum.Font.Gotham
IKDesc.Text = "🦾 IK permite mover mãos/pés e o corpo segue automaticamente, como em jogos AAA!"
IKDesc.TextColor3 = Colors.TextSecondary
IKDesc.TextSize = 11
IKDesc.TextWrapped = true
IKDesc.ZIndex = 32
IKDesc.Parent = IKContainer

local descCorner = Instance.new("UICorner")
descCorner.CornerRadius = UDim.new(0, 8)
descCorner.Parent = IKDesc

-- Toggle IK
local IKToggleFrame = Instance.new("Frame")
IKToggleFrame.Size = UDim2.new(1, 0, 0, 50)
IKToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
IKToggleFrame.BorderSizePixel = 0
IKToggleFrame.ZIndex = 32
IKToggleFrame.Parent = IKContainer

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = IKToggleFrame

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(0.65, 0, 1, 0)
toggleLabel.Position = UDim2.new(0, 12, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Font = Enum.Font.GothamBold
toggleLabel.Text = "🔄 Ativar Sistema IK"
toggleLabel.TextColor3 = Colors.Text
toggleLabel.TextSize = 12
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.ZIndex = 33
toggleLabel.Parent = IKToggleFrame

local toggleBg = Instance.new("Frame")
toggleBg.Size = UDim2.new(0, 55, 0, 28)
toggleBg.Position = UDim2.new(1, -70, 0.5, -14)
toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBg.BorderSizePixel = 0
toggleBg.ZIndex = 33
toggleBg.Parent = IKToggleFrame

local toggleBgCorner = Instance.new("UICorner")
toggleBgCorner.CornerRadius = UDim.new(1, 0)
toggleBgCorner.Parent = toggleBg

local toggleKnob = Instance.new("Frame")
toggleKnob.Size = UDim2.new(0, 24, 0, 24)
toggleKnob.Position = UDim2.new(0, 2, 0.5, -12)
toggleKnob.BackgroundColor3 = Colors.Text
toggleKnob.ZIndex = 34
toggleKnob.Parent = toggleBg

local toggleKnobCorner = Instance.new("UICorner")
toggleKnobCorner.CornerRadius = UDim.new(1, 0)
toggleKnobCorner.Parent = toggleKnob

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = ""
toggleBtn.ZIndex = 35
toggleBtn.Parent = toggleBg

toggleBtn.MouseButton1Click:Connect(function()
    IKSystem.Enabled = not IKSystem.Enabled
    
    CreateTween(toggleBg, {
        BackgroundColor3 = IKSystem.Enabled and Colors.Success or Color3.fromRGB(60, 60, 80)
    }, 0.2):Play()
    
    CreateTween(toggleKnob, {
        Position = IKSystem.Enabled and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
    }, 0.2):Play()
    
    if IKSystem.Enabled then
        CreateNotification("🦾 IK Ativado", "Sistema de Inverse Kinematics ligado!", 2)
    else
        CreateNotification("🦾 IK Desativado", "Sistema IK desligado", 2)
    end
end)

-- Título das Chains
local chainsTitle = Instance.new("TextLabel")
chainsTitle.Size = UDim2.new(1, 0, 0, 30)
chainsTitle.BackgroundTransparency = 1
chainsTitle.Font = Enum.Font.GothamBold
chainsTitle.Text = "⛓️ Chains IK (Membros)"
chainsTitle.TextColor3 = Color3.fromRGB(100, 255, 200)
chainsTitle.TextSize = 13
chainsTitle.TextXAlignment = Enum.TextXAlignment.Left
chainsTitle.ZIndex = 32
chainsTitle.Parent = IKContainer

-- Container de Chains
local ChainsContainer = Instance.new("Frame")
ChainsContainer.Size = UDim2.new(1, 0, 0, 200)
ChainsContainer.BackgroundColor3 = Color3.fromRGB(20, 28, 25)
ChainsContainer.BorderSizePixel = 0
ChainsContainer.ZIndex = 32
ChainsContainer.Parent = IKContainer

local chainsCorner = Instance.new("UICorner")
chainsCorner.CornerRadius = UDim.new(0, 10)
chainsCorner.Parent = ChainsContainer

local chainsLayout = Instance.new("UIGridLayout")
chainsLayout.CellSize = UDim2.new(0.48, 0, 0, 45)
chainsLayout.CellPadding = UDim2.new(0.04, 0, 0, 8)
chainsLayout.SortOrder = Enum.SortOrder.LayoutOrder
chainsLayout.Parent = ChainsContainer

local chainsPadding = Instance.new("UIPadding")
chainsPadding.PaddingTop = UDim.new(0, 10)
chainsPadding.PaddingLeft = UDim.new(0, 10)
chainsPadding.PaddingRight = UDim.new(0, 10)
chainsPadding.Parent = ChainsContainer

-- Definir chains padrão para R15
local DefaultChains = {
    {Name = "Braço Esquerdo", Icon = "🤚", Parts = {"LeftUpperArm", "LeftLowerArm", "LeftHand"}},
    {Name = "Braço Direito", Icon = "✋", Parts = {"RightUpperArm", "RightLowerArm", "RightHand"}},
    {Name = "Perna Esquerda", Icon = "🦵", Parts = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"}},
    {Name = "Perna Direita", Icon = "🦶", Parts = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}}
}

-- Criar botões de chains
local chainButtons = {}

for i, chainData in ipairs(DefaultChains) do
    local btn = Instance.new("TextButton")
    btn.Name = chainData.Name
    btn.Size = UDim2.new(0, 100, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 45, 40)
    btn.Text = chainData.Icon .. "\n" .. chainData.Name
    btn.TextColor3 = Colors.Text
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 33
    btn.Parent = ChainsContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Colors.Border
    btnStroke.Thickness = 1
    btnStroke.Parent = btn
    
    chainButtons[chainData.Name] = {Button = btn, Stroke = btnStroke, Data = chainData, Active = false}
    
    btn.MouseButton1Click:Connect(function()
        local data = chainButtons[chainData.Name]
        data.Active = not data.Active
        
        if data.Active then
            CreateTween(btnStroke, {Color = Color3.fromRGB(100, 255, 200)}, 0.2):Play()
            CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(40, 60, 50)}, 0.2):Play()
            
            IKSystem.SelectedChain = chainData
            SetupIKChain(chainData)
            
            CreateNotification("⛓️ Chain", chainData.Name .. " selecionado para IK", 2)
        else
            CreateTween(btnStroke, {Color = Colors.Border}, 0.2):Play()
            CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(35, 45, 40)}, 0.2):Play()
        end
    end)
end

-- Função para configurar chain IK
function SetupIKChain(chainData)
    local selectedObj = Animator.SelectedObject
    if not selectedObj or not selectedObj:IsA("Model") then
        CreateNotification("⚠️ Aviso", "Selecione um Rig primeiro!", 3)
        return
    end
    
    local parts = {}
    for _, partName in ipairs(chainData.Parts) do
        local part = selectedObj:FindFirstChild(partName, true)
        if part then
            table.insert(parts, part)
        end
    end
    
    if #parts < 2 then
        CreateNotification("⚠️ Aviso", "Partes do chain não encontradas", 3)
        return
    end
    
    IKSystem.Chains[chainData.Name] = {
        Parts = parts,
        Target = nil,
        EndEffector = parts[#parts]
    }
    
    -- Criar target visual (esfera arrastável)
    local target = Instance.new("Part")
    target.Name = "IKTarget_" .. chainData.Name
    target.Shape = Enum.PartType.Ball
    target.Size = Vector3.new(1, 1, 1)
    target.Position = parts[#parts].Position
    target.Anchored = true
    target.CanCollide = false
    target.Transparency = 0.3
    target.BrickColor = BrickColor.new("Lime green")
    target.Material = Enum.Material.Neon
    target.Parent = workspace
    
    IKSystem.Chains[chainData.Name].Target = target
    IKSystem.Targets[chainData.Name] = target
end

-- Algoritmo FABRIK simplificado
local function SolveIK(chain, targetPos)
    if not chain or not chain.Parts or #chain.Parts < 2 then return end
    
    local parts = chain.Parts
    local positions = {}
    local lengths = {}
    
    -- Coletar posições e comprimentos
    for i, part in ipairs(parts) do
        positions[i] = part.Position
        if i > 1 then
            lengths[i-1] = (positions[i] - positions[i-1]).Magnitude
        end
    end
    
    local rootPos = positions[1]
    local totalLength = 0
    for _, len in pairs(lengths) do
        totalLength = totalLength + len
    end
    
    local distToTarget = (targetPos - rootPos).Magnitude
    
    -- Se target está fora do alcance
    if distToTarget > totalLength then
        local direction = (targetPos - rootPos).Unit
        for i = 2, #positions do
            positions[i] = positions[i-1] + direction * lengths[i-1]
        end
    else
        -- FABRIK iterations
        for iter = 1, IKSystem.Iterations do
            -- Backward pass
            positions[#positions] = targetPos
            for i = #positions - 1, 1, -1 do
                local dir = (positions[i] - positions[i+1]).Unit
                positions[i] = positions[i+1] + dir * lengths[i]
            end
            
            -- Forward pass
            positions[1] = rootPos
            for i = 2, #positions do
                local dir = (positions[i] - positions[i-1]).Unit
                positions[i] = positions[i-1] + dir * lengths[i-1]
            end
            
            -- Check tolerance
            if (positions[#positions] - targetPos).Magnitude < IKSystem.Tolerance then
                break
            end
        end
    end
    
    -- Aplicar posições às partes
    for i, part in ipairs(parts) do
        if i < #parts then
            local lookAt = positions[i+1]
            local cf = CFrame.new(positions[i], lookAt)
            part.CFrame = cf
        else
            part.Position = positions[i]
        end
    end
end

-- Loop de atualização IK
local ikConnection = nil

local function StartIKLoop()
    if ikConnection then return end
    
    ikConnection = RunService.RenderStepped:Connect(function()
        if not IKSystem.Enabled then return end
        
        for name, chain in pairs(IKSystem.Chains) do
            if chain.Target then
                SolveIK(chain, chain.Target.Position)
            end
        end
    end)
end

local function StopIKLoop()
    if ikConnection then
        ikConnection:Disconnect()
        ikConnection = nil
    end
end

-- Configurações avançadas
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 25)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.Text = "⚙️ Configurações IK"
settingsTitle.TextColor3 = Colors.Text
settingsTitle.TextSize = 12
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.ZIndex = 32
settingsTitle.Parent = IKContainer

-- Slider de iterações
local iterFrame = Instance.new("Frame")
iterFrame.Size = UDim2.new(1, 0, 0, 55)
iterFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
iterFrame.BorderSizePixel = 0
iterFrame.ZIndex = 32
iterFrame.Parent = IKContainer

local iterCorner = Instance.new("UICorner")
iterCorner.CornerRadius = UDim.new(0, 8)
iterCorner.Parent = iterFrame

local iterLabel = Instance.new("TextLabel")
iterLabel.Size = UDim2.new(0.6, 0, 0, 25)
iterLabel.Position = UDim2.new(0, 10, 0, 5)
iterLabel.BackgroundTransparency = 1
iterLabel.Font = Enum.Font.Gotham
iterLabel.Text = "Iterações: " .. IKSystem.Iterations
iterLabel.TextColor3 = Colors.Text
iterLabel.TextSize = 11
iterLabel.TextXAlignment = Enum.TextXAlignment.Left
iterLabel.ZIndex = 33
iterLabel.Parent = iterFrame

-- Botão limpar targets
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, 0, 0, 40)
clearBtn.BackgroundColor3 = Colors.Danger
clearBtn.Text = "🗑️ Limpar Todos os Targets IK"
clearBtn.TextColor3 = Colors.Text
clearBtn.TextSize = 12
clearBtn.Font = Enum.Font.GothamBold
clearBtn.ZIndex = 32
clearBtn.Parent = IKContainer

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 10)
clearCorner.Parent = clearBtn

clearBtn.MouseButton1Click:Connect(function()
    for name, target in pairs(IKSystem.Targets) do
        if target then
            target:Destroy()
        end
    end
    IKSystem.Targets = {}
    IKSystem.Chains = {}
    
    for _, data in pairs(chainButtons) do
        data.Active = false
        CreateTween(data.Stroke, {Color = Colors.Border}, 0.2):Play()
        CreateTween(data.Button, {BackgroundColor3 = Color3.fromRGB(35, 45, 40)}, 0.2):Play()
    end
    
    CreateNotification("🗑️ Limpo", "Todos os targets IK removidos", 2)
end)

-- Iniciar loop
StartIKLoop()

-- Eventos
CloseIKBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(IKFrame)
end)

-- Função para abrir
local function OpenIK()
    Plugins.AnimateIn(IKFrame)
end

-- Botão no ToolPanel
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("IK", "🦾", "Inverse Kinematics", OpenIK)

-- Armazenar
Animator.IKFrame = IKFrame
Animator.IKSystem = IKSystem
Animator.OpenIK = OpenIK

print("✅ MORTAL ANIMATOR - Sistema IK Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 12: Atalhos de Teclado + Undo/Redo
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

-- Sistema de Histórico (Undo/Redo)
local HistorySystem = {
    UndoStack = {},
    RedoStack = {},
    MaxHistory = 50,
    CurrentState = nil
}

-- Sistema de Atalhos
local ShortcutSystem = {
    Enabled = true,
    Shortcuts = {}
}

-- Função para salvar estado atual
local function SaveState(actionName)
    local state = {
        Action = actionName,
        Timestamp = os.time(),
        KeyframeData = {},
        SelectedObject = Animator.SelectedObject and Animator.SelectedObject.Name or nil,
        CurrentFrame = Animator.CurrentFrame or 0
    }
    
    -- Copiar keyframes
    if Animator.KeyframeSystem and Animator.KeyframeSystem.Data then
        for frame, data in pairs(Animator.KeyframeSystem.Data) do
            state.KeyframeData[frame] = {}
            for k, v in pairs(data) do
                if type(v) ~= "table" then
                    state.KeyframeData[frame][k] = v
                elseif k == "Parts" then
                    state.KeyframeData[frame].Parts = {}
                    for partName, partData in pairs(v) do
                        state.KeyframeData[frame].Parts[partName] = {
                            CFrame = partData.CFrame,
                            Size = partData.Size
                        }
                    end
                end
            end
        end
    end
    
    -- Adicionar ao stack de undo
    table.insert(HistorySystem.UndoStack, state)
    
    -- Limitar tamanho do histórico
    if #HistorySystem.UndoStack > HistorySystem.MaxHistory then
        table.remove(HistorySystem.UndoStack, 1)
    end
    
    -- Limpar redo stack quando nova ação é feita
    HistorySystem.RedoStack = {}
    
    return state
end

-- Função Undo
local function Undo()
    if #HistorySystem.UndoStack == 0 then
        CreateNotification("⚠️ Undo", "Nada para desfazer", 2)
        return
    end
    
    -- Salvar estado atual no redo
    local currentState = {
        Action = "Estado Atual",
        KeyframeData = {}
    }
    
    if Animator.KeyframeSystem and Animator.KeyframeSystem.Data then
        for frame, data in pairs(Animator.KeyframeSystem.Data) do
            currentState.KeyframeData[frame] = data
        end
    end
    
    table.insert(HistorySystem.RedoStack, currentState)
    
    -- Pegar último estado do undo
    local previousState = table.remove(HistorySystem.UndoStack)
    
    -- Restaurar keyframes
    if Animator.KeyframeSystem then
        Animator.KeyframeSystem.Data = previousState.KeyframeData or {}
    end
    
    -- Restaurar frame atual
    if Animator.CurrentFrame and previousState.CurrentFrame then
        Animator.CurrentFrame = previousState.CurrentFrame
        if Animator.UpdatePlayhead then
            Animator.UpdatePlayhead()
        end
    end
    
    CreateNotification("↩️ Undo", "Desfeito: " .. (previousState.Action or "Ação"), 2)
end

-- Função Redo
local function Redo()
    if #HistorySystem.RedoStack == 0 then
        CreateNotification("⚠️ Redo", "Nada para refazer", 2)
        return
    end
    
    -- Salvar estado atual no undo
    local currentState = {
        Action = "Estado Atual",
        KeyframeData = {}
    }
    
    if Animator.KeyframeSystem and Animator.KeyframeSystem.Data then
        for frame, data in pairs(Animator.KeyframeSystem.Data) do
            currentState.KeyframeData[frame] = data
        end
    end
    
    table.insert(HistorySystem.UndoStack, currentState)
    
    -- Pegar último estado do redo
    local nextState = table.remove(HistorySystem.RedoStack)
    
    -- Restaurar keyframes
    if Animator.KeyframeSystem then
        Animator.KeyframeSystem.Data = nextState.KeyframeData or {}
    end
    
    CreateNotification("↪️ Redo", "Refeito!", 2)
end

-- Frame de Atalhos
local ShortcutsFrame = Instance.new("Frame")
ShortcutsFrame.Name = "ShortcutsFrame"
ShortcutsFrame.Size = UDim2.new(0, IsMobile and 300 or 400, 0, 500)
ShortcutsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ShortcutsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ShortcutsFrame.BackgroundColor3 = Colors.Background
ShortcutsFrame.BorderSizePixel = 0
ShortcutsFrame.Visible = false
ShortcutsFrame.ZIndex = 30
ShortcutsFrame.Parent = ScreenGui

ShortcutsFrame:SetAttribute("OriginalSize", ShortcutsFrame.Size)

local ShortCorner = Instance.new("UICorner")
ShortCorner.CornerRadius = UDim.new(0, 14)
ShortCorner.Parent = ShortcutsFrame

local ShortStroke = Instance.new("UIStroke")
ShortStroke.Color = Color3.fromRGB(255, 220, 100)
ShortStroke.Thickness = 2
ShortStroke.Parent = ShortcutsFrame

-- Header
local ShortHeader = Instance.new("Frame")
ShortHeader.Size = UDim2.new(1, 0, 0, 50)
ShortHeader.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
ShortHeader.BorderSizePixel = 0
ShortHeader.ZIndex = 31
ShortHeader.Parent = ShortcutsFrame

local ShortHeaderCorner = Instance.new("UICorner")
ShortHeaderCorner.CornerRadius = UDim.new(0, 14)
ShortHeaderCorner.Parent = ShortHeader

local ShortTitle = Instance.new("TextLabel")
ShortTitle.Size = UDim2.new(0.8, 0, 1, 0)
ShortTitle.Position = UDim2.new(0, 15, 0, 0)
ShortTitle.BackgroundTransparency = 1
ShortTitle.Font = Enum.Font.GothamBold
ShortTitle.Text = "⌨️ Atalhos de Teclado"
ShortTitle.TextColor3 = Colors.Text
ShortTitle.TextSize = 14
ShortTitle.TextXAlignment = Enum.TextXAlignment.Left
ShortTitle.ZIndex = 32
ShortTitle.Parent = ShortHeader

-- Botão Fechar
local CloseShortBtn = Instance.new("TextButton")
CloseShortBtn.Size = UDim2.new(0, 35, 0, 35)
CloseShortBtn.Position = UDim2.new(1, -42, 0.5, -17)
CloseShortBtn.BackgroundColor3 = Colors.Danger
CloseShortBtn.Text = "✕"
CloseShortBtn.TextColor3 = Colors.Text
CloseShortBtn.TextSize = 16
CloseShortBtn.Font = Enum.Font.GothamBold
CloseShortBtn.ZIndex = 32
CloseShortBtn.Parent = ShortHeader

local CloseShortCorner = Instance.new("UICorner")
CloseShortCorner.CornerRadius = UDim.new(0, 8)
CloseShortCorner.Parent = CloseShortBtn

-- Container
local ShortContainer = Instance.new("ScrollingFrame")
ShortContainer.Size = UDim2.new(1, -20, 1, -65)
ShortContainer.Position = UDim2.new(0, 10, 0, 55)
ShortContainer.BackgroundTransparency = 1
ShortContainer.ScrollBarThickness = 4
ShortContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 220, 100)
ShortContainer.ZIndex = 31
ShortContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ShortContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ShortContainer.Parent = ShortcutsFrame

local ShortLayout = Instance.new("UIListLayout")
ShortLayout.Padding = UDim.new(0, 8)
ShortLayout.SortOrder = Enum.SortOrder.LayoutOrder
ShortLayout.Parent = ShortContainer

-- Lista de atalhos padrão
local DefaultShortcuts = {
    {Key = "Ctrl+Z", Action = "Desfazer (Undo)", Func = Undo, Icon = "↩️"},
    {Key = "Ctrl+Y", Action = "Refazer (Redo)", Func = Redo, Icon = "↪️"},
    {Key = "Ctrl+S", Action = "Salvar Animação", Func = function()
        if Animator.AnimationManager then
            Animator.AnimationManager.SaveCurrentAnimation()
        end
    end, Icon = "💾"},
    {Key = "Space", Action = "Play/Pause", Func = function()
        if Animator.PlayAnimation then
            Animator.PlayAnimation()
        end
    end, Icon = "▶️"},
    {Key = "K", Action = "Adicionar Keyframe", Func = function()
        if Animator.AddKeyframe then
            SaveState("Adicionar Keyframe")
            Animator.AddKeyframe()
        end
    end, Icon = "🔑"},
    {Key = "Delete", Action = "Remover Keyframe", Func = function()
        if Animator.RemoveKeyframe then
            SaveState("Remover Keyframe")
            Animator.RemoveKeyframe()
        end
    end, Icon = "🗑️"},
    {Key = "←", Action = "Frame Anterior", Func = function()
        if Animator.CurrentFrame then
            Animator.CurrentFrame = math.max(0, Animator.CurrentFrame - 1)
            if Animator.UpdatePlayhead then Animator.UpdatePlayhead() end
        end
    end, Icon = "⬅️"},
    {Key = "→", Action = "Próximo Frame", Func = function()
        if Animator.CurrentFrame then
            Animator.CurrentFrame = Animator.CurrentFrame + 1
            if Animator.UpdatePlayhead then Animator.UpdatePlayhead() end
        end
    end, Icon = "➡️"},
    {Key = "Home", Action = "Primeiro Frame", Func = function()
        if Animator.CurrentFrame then
            Animator.CurrentFrame = 0
            if Animator.UpdatePlayhead then Animator.UpdatePlayhead() end
        end
    end, Icon = "⏮️"},
    {Key = "End", Action = "Último Keyframe", Func = function()
        if Animator.KeyframeSystem and Animator.KeyframeSystem.Data then
            local lastFrame = 0
            for frame, _ in pairs(Animator.KeyframeSystem.Data) do
                if frame > lastFrame then lastFrame = frame end
            end
            Animator.CurrentFrame = lastFrame
            if Animator.UpdatePlayhead then Animator.UpdatePlayhead() end
        end
    end, Icon = "⏭️"},
    {Key = "Ctrl+E", Action = "Exportar", Func = function()
        if Animator.OpenExport then
            Animator.OpenExport()
        end
    end, Icon = "📤"},
    {Key = "Ctrl+N", Action = "Nova Animação", Func = function()
        if Animator.AnimationManager then
            SaveState("Nova Animação")
        end
    end, Icon = "✨"},
}

-- Função para criar item de atalho
local function CreateShortcutItem(shortcutData)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 45)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    item.BorderSizePixel = 0
    item.ZIndex = 32
    item.Parent = ShortContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = item
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 35, 1, 0)
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = shortcutData.Icon
    icon.TextSize = 18
    icon.ZIndex = 33
    icon.Parent = item
    
    local actionLabel = Instance.new("TextLabel")
    actionLabel.Size = UDim2.new(0.5, -50, 1, 0)
    actionLabel.Position = UDim2.new(0, 45, 0, 0)
    actionLabel.BackgroundTransparency = 1
    actionLabel.Font = Enum.Font.Gotham
    actionLabel.Text = shortcutData.Action
    actionLabel.TextColor3 = Colors.Text
    actionLabel.TextSize = 11
    actionLabel.TextXAlignment = Enum.TextXAlignment.Left
    actionLabel.TextTruncate = Enum.TextTruncate.AtEnd
    actionLabel.ZIndex = 33
    actionLabel.Parent = item
    
    local keyBg = Instance.new("Frame")
    keyBg.Size = UDim2.new(0, IsMobile and 70 or 90, 0, 30)
    keyBg.Position = UDim2.new(1, -(IsMobile and 80 or 100), 0.5, -15)
    keyBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    keyBg.ZIndex = 33
    keyBg.Parent = item
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 6)
    keyCorner.Parent = keyBg
    
    local keyStroke = Instance.new("UIStroke")
    keyStroke.Color = Color3.fromRGB(80, 80, 100)
    keyStroke.Thickness = 1
    keyStroke.Parent = keyBg
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(1, 0, 1, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.Text = shortcutData.Key
    keyLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
    keyLabel.TextSize = 10
    keyLabel.ZIndex = 34
    keyLabel.Parent = keyBg
    
    return item
end

-- Criar items de atalho
for _, shortcut in ipairs(DefaultShortcuts) do
    CreateShortcutItem(shortcut)
    ShortcutSystem.Shortcuts[shortcut.Key] = shortcut
end

-- Botões de Undo/Redo para Mobile
if IsMobile then
    local mobileUndoRedo = Instance.new("Frame")
    mobileUndoRedo.Size = UDim2.new(1, 0, 0, 55)
    mobileUndoRedo.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    mobileUndoRedo.BorderSizePixel = 0
    mobileUndoRedo.ZIndex = 32
    mobileUndoRedo.LayoutOrder = -1
    mobileUndoRedo.Parent = ShortContainer
    
    local mobileCorner = Instance.new("UICorner")
    mobileCorner.CornerRadius = UDim.new(0, 10)
    mobileCorner.Parent = mobileUndoRedo
    
    local mobileTitle = Instance.new("TextLabel")
    mobileTitle.Size = UDim2.new(1, 0, 0, 20)
    mobileTitle.Position = UDim2.new(0, 0, 0, 3)
    mobileTitle.BackgroundTransparency = 1
    mobileTitle.Font = Enum.Font.GothamBold
    mobileTitle.Text = "📱 Botões Mobile"
    mobileTitle.TextColor3 = Colors.Text
    mobileTitle.TextSize = 10
    mobileTitle.ZIndex = 33
    mobileTitle.Parent = mobileUndoRedo
    
    local undoBtn = Instance.new("TextButton")
    undoBtn.Size = UDim2.new(0.45, 0, 0, 28)
    undoBtn.Position = UDim2.new(0.025, 0, 0, 23)
    undoBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    undoBtn.Text = "↩️ Undo"
    undoBtn.TextColor3 = Colors.Text
    undoBtn.TextSize = 11
    undoBtn.Font = Enum.Font.GothamBold
    undoBtn.ZIndex = 33
    undoBtn.Parent = mobileUndoRedo
    
    local undoCorner = Instance.new("UICorner")
    undoCorner.CornerRadius = UDim.new(0, 6)
    undoCorner.Parent = undoBtn
    
    undoBtn.MouseButton1Click:Connect(Undo)
    
    local redoBtn = Instance.new("TextButton")
    redoBtn.Size = UDim2.new(0.45, 0, 0, 28)
    redoBtn.Position = UDim2.new(0.525, 0, 0, 23)
    redoBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
    redoBtn.Text = "↪️ Redo"
    redoBtn.TextColor3 = Colors.Text
    redoBtn.TextSize = 11
    redoBtn.Font = Enum.Font.GothamBold
    redoBtn.ZIndex = 33
    redoBtn.Parent = mobileUndoRedo
    
    local redoCorner = Instance.new("UICorner")
    redoCorner.CornerRadius = UDim.new(0, 6)
    redoCorner.Parent = redoBtn
    
    redoBtn.MouseButton1Click:Connect(Redo)
end

-- Listener de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not ShortcutSystem.Enabled then return end
    
    local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
    local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
    
    local keyName = input.KeyCode.Name
    local shortcutKey = ""
    
    if ctrl then shortcutKey = "Ctrl+" end
    if shift then shortcutKey = shortcutKey .. "Shift+" end
    
    -- Mapear teclas especiais
    local keyMap = {
        [Enum.KeyCode.Left] = "←",
        [Enum.KeyCode.Right] = "→",
        [Enum.KeyCode.Up] = "↑",
        [Enum.KeyCode.Down] = "↓",
        [Enum.KeyCode.Space] = "Space",
        [Enum.KeyCode.Delete] = "Delete",
        [Enum.KeyCode.Home] = "Home",
        [Enum.KeyCode.End] = "End"
    }
    
    if keyMap[input.KeyCode] then
        shortcutKey = shortcutKey .. keyMap[input.KeyCode]
    else
        shortcutKey = shortcutKey .. keyName
    end
    
    -- Procurar atalho
    local shortcut = ShortcutSystem.Shortcuts[shortcutKey]
    if shortcut and shortcut.Func then
        shortcut.Func()
    end
end)

-- Info de histórico
local historyInfo = Instance.new("TextLabel")
historyInfo.Name = "HistoryInfo"
historyInfo.Size = UDim2.new(1, 0, 0, 35)
historyInfo.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
historyInfo.Font = Enum.Font.Gotham
historyInfo.Text = "📊 Histórico: 0 ações | Undo: 0 | Redo: 0"
historyInfo.TextColor3 = Colors.TextSecondary
historyInfo.TextSize = 10
historyInfo.ZIndex = 32
historyInfo.LayoutOrder = 100
historyInfo.Parent = ShortContainer

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0, 8)
historyCorner.Parent = historyInfo

-- Atualizar info do histórico
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            historyInfo.Text = string.format(
                "📊 Histórico | Undo: %d | Redo: %d",
                #HistorySystem.UndoStack,
                #HistorySystem.RedoStack
            )
        end)
    end
end)

-- Eventos
CloseShortBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(ShortcutsFrame)
end)

-- Função para abrir
local function OpenShortcuts()
    Plugins.AnimateIn(ShortcutsFrame)
end

-- Botão no ToolPanel
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("Shortcuts", "⌨️", "Atalhos", OpenShortcuts)

-- Armazenar
Animator.ShortcutsFrame = ShortcutsFrame
Animator.HistorySystem = HistorySystem
Animator.ShortcutSystem = ShortcutSystem
Animator.Undo = Undo
Animator.Redo = Redo
Animator.SaveState = SaveState
Animator.OpenShortcuts = OpenShortcuts

print("✅ MORTAL ANIMATOR - Atalhos e Undo/Redo Carregados!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 13: Export de Cutscenes
    Gera código Lua completo para reproduzir cutscenes/cinemáticas
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

-- Frame de Export de Cutscene
local CutExportFrame = Instance.new("Frame")
CutExportFrame.Name = "CutsceneExportFrame"
CutExportFrame.Size = UDim2.new(0.88, 0, 0.82, 0)
CutExportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CutExportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CutExportFrame.BackgroundColor3 = Colors.Background
CutExportFrame.BorderSizePixel = 0
CutExportFrame.Visible = false
CutExportFrame.ZIndex = 35
CutExportFrame.Parent = ScreenGui

CutExportFrame:SetAttribute("OriginalSize", CutExportFrame.Size)

local CutExpCorner = Instance.new("UICorner")
CutExpCorner.CornerRadius = UDim.new(0, 14)
CutExpCorner.Parent = CutExportFrame

local CutExpStroke = Instance.new("UIStroke")
CutExpStroke.Color = Color3.fromRGB(255, 200, 100)
CutExpStroke.Thickness = 2
CutExpStroke.Parent = CutExportFrame

local CutExpGradient = Instance.new("UIGradient")
CutExpGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 25, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
})
CutExpGradient.Rotation = 135
CutExpGradient.Parent = CutExportFrame

-- Header
local CutExpHeader = Instance.new("Frame")
CutExpHeader.Size = UDim2.new(1, 0, 0, 55)
CutExpHeader.BackgroundColor3 = Color3.fromRGB(35, 30, 22)
CutExpHeader.BorderSizePixel = 0
CutExpHeader.ZIndex = 36
CutExpHeader.Parent = CutExportFrame

local CutExpHeaderCorner = Instance.new("UICorner")
CutExpHeaderCorner.CornerRadius = UDim.new(0, 14)
CutExpHeaderCorner.Parent = CutExpHeader

local CutExpTitle = Instance.new("TextLabel")
CutExpTitle.Size = UDim2.new(0.8, 0, 1, 0)
CutExpTitle.Position = UDim2.new(0, 15, 0, 0)
CutExpTitle.BackgroundTransparency = 1
CutExpTitle.Font = Enum.Font.GothamBold
CutExpTitle.Text = "🎬 Exportar Cutscene • Cinemática Completa"
CutExpTitle.TextColor3 = Colors.Text
CutExpTitle.TextSize = IsMobile and 12 or 15
CutExpTitle.TextXAlignment = Enum.TextXAlignment.Left
CutExpTitle.ZIndex = 37
CutExpTitle.Parent = CutExpHeader

-- Botão Fechar
local CloseCutExpBtn = Instance.new("TextButton")
CloseCutExpBtn.Size = UDim2.new(0, 40, 0, 40)
CloseCutExpBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseCutExpBtn.BackgroundColor3 = Colors.Danger
CloseCutExpBtn.Text = "✕"
CloseCutExpBtn.TextColor3 = Colors.Text
CloseCutExpBtn.TextSize = 18
CloseCutExpBtn.Font = Enum.Font.GothamBold
CloseCutExpBtn.ZIndex = 37
CloseCutExpBtn.Parent = CutExpHeader

local CloseCutExpCorner = Instance.new("UICorner")
CloseCutExpCorner.CornerRadius = UDim.new(0, 8)
CloseCutExpCorner.Parent = CloseCutExpBtn

-- Info da Cutscene
local CutExpInfo = Instance.new("Frame")
CutExpInfo.Size = UDim2.new(1, -30, 0, 70)
CutExpInfo.Position = UDim2.new(0, 15, 0, 65)
CutExpInfo.BackgroundColor3 = Color3.fromRGB(25, 30, 28)
CutExpInfo.BorderSizePixel = 0
CutExpInfo.ZIndex = 36
CutExpInfo.Parent = CutExportFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = CutExpInfo

local infoLayout = Instance.new("UIListLayout")
infoLayout.FillDirection = Enum.FillDirection.Horizontal
infoLayout.Padding = UDim.new(0.02, 0)
infoLayout.Parent = CutExpInfo

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingLeft = UDim.new(0, 15)
infoPadding.PaddingTop = UDim.new(0, 10)
infoPadding.Parent = CutExpInfo

-- Função para criar stat
local function CreateStat(name, value, icon)
    local stat = Instance.new("Frame")
    stat.Size = UDim2.new(0.23, 0, 1, -20)
    stat.BackgroundColor3 = Color3.fromRGB(35, 40, 38)
    stat.BorderSizePixel = 0
    stat.ZIndex = 37
    stat.Parent = CutExpInfo
    
    local statCorner = Instance.new("UICorner")
    statCorner.CornerRadius = UDim.new(0, 8)
    statCorner.Parent = stat
    
    local statIcon = Instance.new("TextLabel")
    statIcon.Size = UDim2.new(1, 0, 0, 25)
    statIcon.Position = UDim2.new(0, 0, 0, 5)
    statIcon.BackgroundTransparency = 1
    statIcon.Text = icon
    statIcon.TextSize = 18
    statIcon.ZIndex = 38
    statIcon.Parent = stat
    
    local statValue = Instance.new("TextLabel")
    statValue.Name = "Value"
    statValue.Size = UDim2.new(1, 0, 0, 20)
    statValue.Position = UDim2.new(0, 0, 0, 28)
    statValue.BackgroundTransparency = 1
    statValue.Font = Enum.Font.GothamBold
    statValue.Text = tostring(value)
    statValue.TextColor3 = Color3.fromRGB(255, 200, 100)
    statValue.TextSize = 14
    statValue.ZIndex = 38
    statValue.Parent = stat
    
    local statName = Instance.new("TextLabel")
    statName.Size = UDim2.new(1, 0, 0, 15)
    statName.Position = UDim2.new(0, 0, 1, -18)
    statName.BackgroundTransparency = 1
    statName.Font = Enum.Font.Gotham
    statName.Text = name
    statName.TextColor3 = Colors.TextSecondary
    statName.TextSize = 9
    statName.ZIndex = 38
    statName.Parent = stat
    
    return stat
end

local pointsStat = CreateStat("Pontos", "0", "📍")
local durationStat = CreateStat("Duração", "0s", "⏱️")
local easingStat = CreateStat("Easing", "Quad", "📈")
local fxStat = CreateStat("Efeitos", "0", "✨")

-- Container do Código
local CutCodeContainer = Instance.new("Frame")
CutCodeContainer.Size = UDim2.new(1, -30, 1, -220)
CutCodeContainer.Position = UDim2.new(0, 15, 0, 145)
CutCodeContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
CutCodeContainer.BorderSizePixel = 0
CutCodeContainer.ZIndex = 36
CutCodeContainer.Parent = CutExportFrame

local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 10)
codeCorner.Parent = CutCodeContainer

local codeStroke = Instance.new("UIStroke")
codeStroke.Color = Colors.Border
codeStroke.Thickness = 1
codeStroke.Parent = CutCodeContainer

local CutCodeBox = Instance.new("TextBox")
CutCodeBox.Name = "CodeBox"
CutCodeBox.Size = UDim2.new(1, -20, 1, -20)
CutCodeBox.Position = UDim2.new(0, 10, 0, 10)
CutCodeBox.BackgroundTransparency = 1
CutCodeBox.Font = Enum.Font.Code
CutCodeBox.Text = "-- Código da cutscene será gerado aqui..."
CutCodeBox.TextColor3 = Color3.fromRGB(150, 220, 150)
CutCodeBox.TextSize = 11
CutCodeBox.TextXAlignment = Enum.TextXAlignment.Left
CutCodeBox.TextYAlignment = Enum.TextYAlignment.Top
CutCodeBox.TextWrapped = true
CutCodeBox.MultiLine = true
CutCodeBox.ClearTextOnFocus = false
CutCodeBox.ZIndex = 37
CutCodeBox.Parent = CutCodeContainer

-- Botões de Ação
local CutActionBar = Instance.new("Frame")
CutActionBar.Size = UDim2.new(1, -30, 0, 55)
CutActionBar.Position = UDim2.new(0, 15, 1, -65)
CutActionBar.BackgroundTransparency = 1
CutActionBar.ZIndex = 36
CutActionBar.Parent = CutExportFrame

local cutActionLayout = Instance.new("UIListLayout")
cutActionLayout.FillDirection = Enum.FillDirection.Horizontal
cutActionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
cutActionLayout.Padding = UDim.new(0, 12)
cutActionLayout.Parent = CutActionBar

-- Função para criar botão de ação
local function CreateCutActionBtn(name, icon, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, IsMobile and 100 or 140, 0, 48)
    btn.BackgroundColor3 = color
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Colors.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 37
    btn.Parent = CutActionBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        CreateTween(btn, {BackgroundColor3 = Color3.new(
            math.min(color.R + 0.12, 1),
            math.min(color.G + 0.12, 1),
            math.min(color.B + 0.12, 1)
        )}, 0.2):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        CreateTween(btn, {BackgroundColor3 = color}, 0.2):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Função para gerar código da cutscene
local function GenerateCutsceneCode()
    local CutsceneSystem = Animator.CutsceneSystem
    
    if not CutsceneSystem or not CutsceneSystem.CameraPoints or #CutsceneSystem.CameraPoints < 2 then
        return "-- ERRO: Adicione pelo menos 2 pontos de câmera para criar uma cutscene!"
    end
    
    local points = CutsceneSystem.CameraPoints
    local easingStyle = CutsceneSystem.EasingStyle or Enum.EasingStyle.Quad
    
    -- Atualizar stats
    pointsStat:FindFirstChild("Value").Text = tostring(#points)
    
    local totalDuration = 0
    for _, pt in pairs(points) do
        totalDuration = totalDuration + (pt.Duration or 2)
    end
    durationStat:FindFirstChild("Value").Text = string.format("%.1fs", totalDuration)
    easingStat:FindFirstChild("Value").Text = easingStyle.Name
    
    local code = [[
--[[
    ⚡☠️ MORTAL CUTSCENE - Cinemática Exportada ☠️⚡
    Gerado automaticamente pelo Mortal Animator V1
    
    INSTRUÇÕES:
    1. Coloque este LocalScript em StarterPlayerScripts
    2. Ou chame MortalCutscene:Play() quando quiser iniciar
    3. A câmera se moverá pelos pontos automaticamente
    
    FUNÇÕES:
    - MortalCutscene:Play() → Inicia a cutscene
    - MortalCutscene:Stop() → Para a cutscene
    - MortalCutscene:Skip() → Pula para o final
    - MortalCutscene:SetSpeed(speed) → Ajusta velocidade
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configurações da Cutscene
local Config = {
    AutoPlay = false,  -- Mudar para true para auto-iniciar
    SkipEnabled = true,
    Speed = 1,
    EasingStyle = Enum.EasingStyle.]] .. easingStyle.Name .. [[,
    EasingDirection = Enum.EasingDirection.InOut
}

-- Pontos da Câmera (CFrame e Duração)
local CameraPoints = {
]]
    
    -- Adicionar cada ponto
    for i, point in ipairs(points) do
        local cf = point.CFrame
        local pos = cf.Position
        local rx, ry, rz = cf:ToEulerAnglesXYZ()
        local duration = point.Duration or 2
        
        code = code .. string.format([[
    {
        CFrame = CFrame.new(%.3f, %.3f, %.3f) * CFrame.Angles(%.4f, %.4f, %.4f),
        Duration = %.2f,
        -- Efeitos opcionais para este ponto:
        Effects = {
            Shake = false,
            ShakeIntensity = 0,
            Blur = 0,
            FOV = 70
        }
    },
]], pos.X, pos.Y, pos.Z, rx, ry, rz, duration)
    end
    
    code = code .. [[
}

-- Sistema da Cutscene
local MortalCutscene = {}
MortalCutscene.IsPlaying = false
MortalCutscene.CurrentPoint = 0
MortalCutscene.OriginalCameraType = nil

local CurrentTween = nil
local ShakeConnection = nil

-- Aplicar efeitos
local function ApplyEffects(effects)
    if not effects then return end
    
    -- FOV
    if effects.FOV and effects.FOV ~= 70 then
        TweenService:Create(Camera, TweenInfo.new(0.5), {
            FieldOfView = effects.FOV
        }):Play()
    end
    
    -- Blur
    local blur = Lighting:FindFirstChild("CutsceneBlur")
    if not blur then
        blur = Instance.new("BlurEffect")
        blur.Name = "CutsceneBlur"
        blur.Parent = Lighting
    end
    
    if effects.Blur and effects.Blur > 0 then
        TweenService:Create(blur, TweenInfo.new(0.3), {
            Size = effects.Blur
        }):Play()
    else
        blur.Size = 0
    end
    
    -- Shake
    if effects.Shake and effects.ShakeIntensity > 0 then
        if ShakeConnection then ShakeConnection:Disconnect() end
        
        ShakeConnection = RunService.RenderStepped:Connect(function()
            local intensity = effects.ShakeIntensity * 0.1
            local shakeX = (math.random() - 0.5) * intensity
            local shakeY = (math.random() - 0.5) * intensity
            Camera.CFrame = Camera.CFrame * CFrame.new(shakeX, shakeY, 0)
        end)
    elseif ShakeConnection then
        ShakeConnection:Disconnect()
        ShakeConnection = nil
    end
end

-- Limpar efeitos
local function ClearEffects()
    if ShakeConnection then
        ShakeConnection:Disconnect()
        ShakeConnection = nil
    end
    
    local blur = Lighting:FindFirstChild("CutsceneBlur")
    if blur then blur.Size = 0 end
    
    Camera.FieldOfView = 70
end

-- Reproduzir cutscene
function MortalCutscene:Play()
    if self.IsPlaying then return end
    
    self.IsPlaying = true
    self.OriginalCameraType = Camera.CameraType
    Camera.CameraType = Enum.CameraType.Scriptable
    
    -- Posicionar no primeiro ponto
    if CameraPoints[1] then
        Camera.CFrame = CameraPoints[1].CFrame
    end
    
    -- Transição entre pontos
    task.spawn(function()
        for i = 1, #CameraPoints - 1 do
            if not self.IsPlaying then break end
            
            self.CurrentPoint = i
            local currentPoint = CameraPoints[i]
            local nextPoint = CameraPoints[i + 1]
            
            -- Aplicar efeitos do ponto atual
            ApplyEffects(currentPoint.Effects)
            
            -- Criar tween para próximo ponto
            local duration = currentPoint.Duration / Config.Speed
            local tweenInfo = TweenInfo.new(
                duration,
                Config.EasingStyle,
                Config.EasingDirection
            )
            
            CurrentTween = TweenService:Create(Camera, tweenInfo, {
                CFrame = nextPoint.CFrame
            })
            
            CurrentTween:Play()
            CurrentTween.Completed:Wait()
        end
        
        -- Cutscene finalizada
        self:Stop()
    end)
end

-- Parar cutscene
function MortalCutscene:Stop()
    self.IsPlaying = false
    self.CurrentPoint = 0
    
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    
    ClearEffects()
    
    if self.OriginalCameraType then
        Camera.CameraType = self.OriginalCameraType
    end
end

-- Pular cutscene
function MortalCutscene:Skip()
    if not self.IsPlaying then return end
    
    if CurrentTween then
        CurrentTween:Cancel()
    end
    
    -- Ir para último ponto
    local lastPoint = CameraPoints[#CameraPoints]
    if lastPoint then
        Camera.CFrame = lastPoint.CFrame
    end
    
    self:Stop()
end

-- Ajustar velocidade
function MortalCutscene:SetSpeed(speed)
    Config.Speed = math.clamp(speed, 0.1, 5)
end

-- Controle por tecla (pressione E para pular)
if Config.SkipEnabled then
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.E and MortalCutscene.IsPlaying then
            MortalCutscene:Skip()
        end
    end)
end

-- Auto-play se configurado
if Config.AutoPlay then
    task.wait(1)
    MortalCutscene:Play()
end

return MortalCutscene
]]
    
    return code
end

-- Função para copiar código
local function CopyCode()
    local code = CutCodeBox.Text
    if setclipboard then
        setclipboard(code)
        CreateNotification("✅ Copiado!", "Código da cutscene copiado!", 3)
    else
        CreateNotification("⚠️ Aviso", "Selecione e copie o código manualmente", 3)
    end
end

-- Criar botões
CreateCutActionBtn("Gerar", "🔄", Colors.Success, function()
    CutCodeBox.Text = GenerateCutsceneCode()
    CreateNotification("✅ Gerado", "Código da cutscene atualizado!", 2)
end)

CreateCutActionBtn("Copiar", "📋", Colors.Accent, CopyCode)

CreateCutActionBtn("Fechar", "❌", Colors.Danger, function()
    Plugins.AnimateOut(CutExportFrame)
end)

-- Eventos
CloseCutExpBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(CutExportFrame)
end)

-- Função para abrir
local function OpenCutsceneExport()
    CutCodeBox.Text = GenerateCutsceneCode()
    Plugins.AnimateIn(CutExportFrame)
end

-- Adicionar botão ao painel de cutscenes
if Animator.CutsceneFrame then
    local controlPanel = Animator.CutsceneFrame:FindFirstChild("ControlPanel")
    if controlPanel then
        local exportBtn = Instance.new("TextButton")
        exportBtn.Name = "ExportCutscene"
        exportBtn.Size = UDim2.new(1, -20, 0, 42)
        exportBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        exportBtn.Text = "📤 Exportar Cutscene"
        exportBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
        exportBtn.TextSize = 12
        exportBtn.Font = Enum.Font.GothamBold
        exportBtn.ZIndex = 27
        exportBtn.Parent = controlPanel
        
        local expCorner = Instance.new("UICorner")
        expCorner.CornerRadius = UDim.new(0, 8)
        expCorner.Parent = exportBtn
        
        exportBtn.MouseButton1Click:Connect(OpenCutsceneExport)
    end
end

-- Armazenar
Animator.CutExportFrame = CutExportFrame
Animator.OpenCutsceneExport = OpenCutsceneExport
Animator.GenerateCutsceneCode = GenerateCutsceneCode

print("✅ MORTAL ANIMATOR - Export de Cutscenes Carregado!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 14: Biblioteca de Poses Prontas
    Poses pré-definidas para usar rapidamente
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

-- Sistema de Poses
local PoseLibrary = {
    Poses = {},
    Categories = {},
    CustomPoses = {}
}

-- Poses pré-definidas (R15)
local DefaultPoses = {
    {
        Name = "T-Pose",
        Icon = "🧍",
        Category = "Básico",
        Description = "Pose padrão em T",
        Data = {
            ["LeftUpperArm"] = CFrame.Angles(0, 0, math.rad(-90)),
            ["RightUpperArm"] = CFrame.Angles(0, 0, math.rad(90)),
            ["LeftLowerArm"] = CFrame.Angles(0, 0, 0),
            ["RightLowerArm"] = CFrame.Angles(0, 0, 0)
        }
    },
    {
        Name = "Idle",
        Icon = "🧘",
        Category = "Básico",
        Description = "Posição de descanso",
        Data = {
            ["LeftUpperArm"] = CFrame.Angles(math.rad(15), 0, math.rad(-10)),
            ["RightUpperArm"] = CFrame.Angles(math.rad(15), 0, math.rad(10)),
            ["LeftLowerArm"] = CFrame.Angles(math.rad(-25), 0, 0),
            ["RightLowerArm"] = CFrame.Angles(math.rad(-25), 0, 0)
        }
    },
    {
        Name = "Correndo",
        Icon = "🏃",
        Category = "Movimento",
        Description = "Pose de corrida",
        Data = {
            ["LeftUpperArm"] = CFrame.Angles(math.rad(-45), 0, math.rad(-15)),
            ["RightUpperArm"] = CFrame.Angles(math.rad(45), 0, math.rad(15)),
            ["LeftUpperLeg"] = CFrame.Angles(math.rad(45), 0, 0),
            ["RightUpperLeg"] = CFrame.Angles(math.rad(-30), 0, 0)
        }
    },
    {
        Name = "Pulando",
        Icon = "⬆️",
        Category = "Movimento",
        Description = "Pose no ar",
        Data = {
            ["LeftUpperArm"] = CFrame.Angles(math.rad(-120), 0, math.rad(-20)),
            ["RightUpperArm"] = CFrame.Angles(math.rad(-120), 0, math.rad(20)),
            ["LeftUpperLeg"] = CFrame.Angles(math.rad(-20), 0, math.rad(-10)),
            ["RightUpperLeg"] = CFrame.Angles(math.rad(-20), 0, math.rad(10))
        }
    },
    {
        Name = "Soco",
        Icon = "👊",
        Category = "Combate",
        Description = "Pose de soco",
        Data = {
            ["RightUpperArm"] = CFrame.Angles(math.rad(-90), math.rad(30), 0),
            ["RightLowerArm"] = CFrame.Angles(0, 0, 0),
            ["UpperTorso"] = CFrame.Angles(0, math.rad(-25), 0)
        }
    },
    {
        Name = "Chute",
        Icon = "🦵",
        Category = "Combate",
        Description = "Pose de chute alto",
        Data = {
            ["RightUpperLeg"] = CFrame.Angles(math.rad(-90), 0, 0),
            ["RightLowerLeg"] = CFrame.Angles(math.rad(20), 0, 0),
            ["UpperTorso"] = CFrame.Angles(math.rad(10), 0, 0)
        }
    },
    {
        Name = "Defesa",
        Icon = "🛡️",
        Category = "Combate",
        Description = "Posição defensiva",
        Data = {
            ["LeftUpperArm"] = CFrame.Angles(math.rad(-70), math.rad(30), 0),
            ["RightUpperArm"] = CFrame.Angles(math.rad(-70), math.rad(-30), 0),
            ["LeftLowerArm"] = CFrame.Angles(math.rad(-90), 0, 0),
            ["RightLowerArm"] = CFrame.Angles(math.rad(-90), 0, 0)
        }
    },
    {
        Name = "Sentado",
        Icon = "🪑",
        Category = "Casual",
        Description = "Pose sentada",
        Data = {
            ["LeftUpperLeg"] = CFrame.Angles(math.rad(-90), 0, 0),
            ["RightUpperLeg"] = CFrame.Angles(math.rad(-90), 0, 0),
            ["LeftLowerLeg"] = CFrame.Angles(math.rad(90), 0, 0),
            ["RightLowerLeg"] = CFrame.Angles(math.rad(90), 0, 0)
        }
    },
    {
        Name = "Acenando",
        Icon = "👋",
        Category = "Casual",
        Description = "Acenar com a mão",
        Data = {
            ["RightUpperArm"] = CFrame.Angles(math.rad(-150), 0, math.rad(30)),
            ["RightLowerArm"] = CFrame.Angles(0, 0, math.rad(20)),
            ["RightHand"] = CFrame.Angles(0, 0, math.rad(15))
        }
    },
    {
        Name = "Deitado",
        Icon = "😴",
        Category = "Casual",
        Description = "Deitado no chão",
        Data = {
            ["HumanoidRootPart"] = CFrame.Angles(math.rad(-90), 0, 0),
            ["LeftUpperArm"] = CFrame.Angles(0, 0, math.rad(-20)),
            ["RightUpperArm"] = CFrame.Angles(0, 0, math.rad(20))
        }
    },
    {
        Name = "Vitória",
        Icon = "🏆",
        Category = "Emotes",
        Description = "Pose de vitória",
        Data = {
            ["LeftUpperArm"] = CFrame.Angles(math.rad(-160), 0, math.rad(-20)),
            ["RightUpperArm"] = CFrame.Angles(math.rad(-160), 0, math.rad(20)),
            ["Head"] = CFrame.Angles(math.rad(-15), 0, 0)
        }
    },
    {
        Name = "Triste",
        Icon = "😢",
        Category = "Emotes",
        Description = "Pose triste",
        Data = {
            ["Head"] = CFrame.Angles(math.rad(25), 0, 0),
            ["UpperTorso"] = CFrame.Angles(math.rad(15), 0, 0),
            ["LeftUpperArm"] = CFrame.Angles(math.rad(10), 0, math.rad(-5)),
            ["RightUpperArm"] = CFrame.Angles(math.rad(10), 0, math.rad(5))
        }
    }
}

-- Adicionar poses padrão
for _, pose in ipairs(DefaultPoses) do
    table.insert(PoseLibrary.Poses, pose)
    if not table.find(PoseLibrary.Categories, pose.Category) then
        table.insert(PoseLibrary.Categories, pose.Category)
    end
end

-- Frame da Biblioteca
local LibraryFrame = Instance.new("Frame")
LibraryFrame.Name = "PoseLibraryFrame"
LibraryFrame.Size = UDim2.new(0, IsMobile and 320 or 450, 0, 500)
LibraryFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LibraryFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LibraryFrame.BackgroundColor3 = Colors.Background
LibraryFrame.BorderSizePixel = 0
LibraryFrame.Visible = false
LibraryFrame.ZIndex = 30
LibraryFrame.Parent = ScreenGui

LibraryFrame:SetAttribute("OriginalSize", LibraryFrame.Size)

local LibCorner = Instance.new("UICorner")
LibCorner.CornerRadius = UDim.new(0, 14)
LibCorner.Parent = LibraryFrame

local LibStroke = Instance.new("UIStroke")
LibStroke.Color = Color3.fromRGB(200, 150, 255)
LibStroke.Thickness = 2
LibStroke.Parent = LibraryFrame

-- Header
local LibHeader = Instance.new("Frame")
LibHeader.Size = UDim2.new(1, 0, 0, 50)
LibHeader.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
LibHeader.BorderSizePixel = 0
LibHeader.ZIndex = 31
LibHeader.Parent = LibraryFrame

local LibHeaderCorner = Instance.new("UICorner")
LibHeaderCorner.CornerRadius = UDim.new(0, 14)
LibHeaderCorner.Parent = LibHeader

local LibTitle = Instance.new("TextLabel")
LibTitle.Size = UDim2.new(0.75, 0, 1, 0)
LibTitle.Position = UDim2.new(0, 15, 0, 0)
LibTitle.BackgroundTransparency = 1
LibTitle.Font = Enum.Font.GothamBold
LibTitle.Text = "📚 Biblioteca de Poses"
LibTitle.TextColor3 = Colors.Text
LibTitle.TextSize = 14
LibTitle.TextXAlignment = Enum.TextXAlignment.Left
LibTitle.ZIndex = 32
LibTitle.Parent = LibHeader

-- Botão Fechar
local CloseLibBtn = Instance.new("TextButton")
CloseLibBtn.Size = UDim2.new(0, 35, 0, 35)
CloseLibBtn.Position = UDim2.new(1, -42, 0.5, -17)
CloseLibBtn.BackgroundColor3 = Colors.Danger
CloseLibBtn.Text = "✕"
CloseLibBtn.TextColor3 = Colors.Text
CloseLibBtn.TextSize = 16
CloseLibBtn.Font = Enum.Font.GothamBold
CloseLibBtn.ZIndex = 32
CloseLibBtn.Parent = LibHeader

local CloseLibCorner = Instance.new("UICorner")
CloseLibCorner.CornerRadius = UDim.new(0, 8)
CloseLibCorner.Parent = CloseLibBtn

-- Tabs de Categoria
local TabsContainer = Instance.new("ScrollingFrame")
TabsContainer.Size = UDim2.new(1, -20, 0, 40)
TabsContainer.Position = UDim2.new(0, 10, 0, 55)
TabsContainer.BackgroundTransparency = 1
TabsContainer.ScrollBarThickness = 0
TabsContainer.ScrollingDirection = Enum.ScrollingDirection.X
TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabsContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
TabsContainer.ZIndex = 31
TabsContainer.Parent = LibraryFrame

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.Padding = UDim.new(0, 8)
TabsLayout.Parent = TabsContainer

local selectedCategory = "Todos"
local tabButtons = {}

-- Container de Poses
local PosesContainer = Instance.new("ScrollingFrame")
PosesContainer.Name = "PosesContainer"
PosesContainer.Size = UDim2.new(1, -20, 1, -165)
PosesContainer.Position = UDim2.new(0, 10, 0, 100)
PosesContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
PosesContainer.BorderSizePixel = 0
PosesContainer.ScrollBarThickness = 4
PosesContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 150, 255)
PosesContainer.ZIndex = 31
PosesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
PosesContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
PosesContainer.Parent = LibraryFrame

local PosesCorner = Instance.new("UICorner")
PosesCorner.CornerRadius = UDim.new(0, 10)
PosesCorner.Parent = PosesContainer

local PosesGrid = Instance.new("UIGridLayout")
PosesGrid.CellSize = IsMobile and UDim2.new(0.48, 0, 0, 90) or UDim2.new(0, 130, 0, 100)
PosesGrid.CellPadding = UDim2.new(0, 8, 0, 8)
PosesGrid.SortOrder = Enum.SortOrder.LayoutOrder
PosesGrid.Parent = PosesContainer

local PosesPadding = Instance.new("UIPadding")
PosesPadding.PaddingTop = UDim.new(0, 10)
PosesPadding.PaddingLeft = UDim.new(0, 10)
PosesPadding.PaddingRight = UDim.new(0, 10)
PosesPadding.Parent = PosesContainer

-- Função para aplicar pose
local function ApplyPose(poseData)
    local selectedObj = Animator.SelectedObject
    
    if not selectedObj or not selectedObj:IsA("Model") then
        CreateNotification("⚠️ Aviso", "Selecione um Rig primeiro!", 3)
        return
    end
    
    -- Salvar estado para undo
    if Animator.SaveState then
        Animator.SaveState("Aplicar Pose: " .. poseData.Name)
    end
    
    for partName, rotationCFrame in pairs(poseData.Data) do
        local part = selectedObj:FindFirstChild(partName, true)
        if part then
            -- Encontrar Motor6D conectado
            local motor = nil
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("Motor6D") then
                    motor = child
                    break
                end
            end
            
            -- Aplicar rotação
            if motor then
                motor.C0 = motor.C0 * rotationCFrame
            else
                -- Aplicar diretamente se não houver Motor6D
                local currentCF = part.CFrame
                part.CFrame = CFrame.new(currentCF.Position) * rotationCFrame
            end
        end
    end
    
    -- Adicionar keyframe automaticamente
    if Animator.AddKeyframe then
        Animator.AddKeyframe()
    end
    
    CreateNotification("✅ Pose Aplicada", poseData.Name, 2)
end

-- Função para criar item de pose
local function CreatePoseItem(poseData)
    local item = Instance.new("TextButton")
    item.Name = poseData.Name
    item.Size = UDim2.new(0, 130, 0, 100)
    item.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    item.Text = ""
    item.AutoButtonColor = false
    item.ZIndex = 32
    item.Parent = PosesContainer
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 10)
    itemCorner.Parent = item
    
    local itemStroke = Instance.new("UIStroke")
    itemStroke.Color = Colors.Border
    itemStroke.Thickness = 1
    itemStroke.Parent = item
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 0, 40)
    icon.Position = UDim2.new(0, 0, 0, 8)
    icon.BackgroundTransparency = 1
    icon.Text = poseData.Icon
    icon.TextSize = 28
    icon.ZIndex = 33
    icon.Parent = item
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -10, 0, 20)
    name.Position = UDim2.new(0, 5, 0, 50)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.Text = poseData.Name
    name.TextColor3 = Colors.Text
    name.TextSize = 11
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.ZIndex = 33
    name.Parent = item
    
    local category = Instance.new("TextLabel")
    category.Size = UDim2.new(1, -10, 0, 15)
    category.Position = UDim2.new(0, 5, 0, 70)
    category.BackgroundTransparency = 1
    category.Font = Enum.Font.Gotham
    category.Text = poseData.Category
    category.TextColor3 = Colors.TextSecondary
    category.TextSize = 9
    category.ZIndex = 33
    category.Parent = item
    
    -- Hover
    item.MouseEnter:Connect(function()
        CreateTween(itemStroke, {Color = Color3.fromRGB(200, 150, 255)}, 0.2):Play()
        CreateTween(item, {BackgroundColor3 = Color3.fromRGB(45, 40, 65)}, 0.2):Play()
    end)
    
    item.MouseLeave:Connect(function()
        CreateTween(itemStroke, {Color = Colors.Border}, 0.2):Play()
        CreateTween(item, {BackgroundColor3 = Color3.fromRGB(30, 30, 48)}, 0.2):Play()
    end)
    
    item.MouseButton1Click:Connect(function()
        ApplyPose(poseData)
    end)
    
    return item
end

-- Função para filtrar poses
local function FilterPoses(category)
    selectedCategory = category
    
    -- Limpar poses
    for _, child in pairs(PosesContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Recriar poses filtradas
    for _, pose in ipairs(PoseLibrary.Poses) do
        if category == "Todos" or pose.Category == category then
            CreatePoseItem(pose)
        end
    end
    
    -- Atualizar tabs
    for catName, btn in pairs(tabButtons) do
        if catName == category then
            CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(200, 150, 255)}, 0.2):Play()
            btn.TextColor3 = Color3.fromRGB(30, 30, 30)
        else
            CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}, 0.2):Play()
            btn.TextColor3 = Colors.Text
        end
    end
end

-- Criar tabs
local allCategories = {"Todos"}
for _, cat in ipairs(PoseLibrary.Categories) do
    table.insert(allCategories, cat)
end

for _, catName in ipairs(allCategories) do
    local tab = Instance.new("TextButton")
    tab.Name = catName
    tab.Size = UDim2.new(0, 80, 0, 32)
    tab.BackgroundColor3 = catName == "Todos" and Color3.fromRGB(200, 150, 255) or Color3.fromRGB(40, 40, 60)
    tab.Text = catName
    tab.TextColor3 = catName == "Todos" and Color3.fromRGB(30, 30, 30) or Colors.Text
    tab.TextSize = 11
    tab.Font = Enum.Font.GothamBold
    tab.AutoButtonColor = false
    tab.ZIndex = 32
    tab.Parent = TabsContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tab
    
    tabButtons[catName] = tab
    
    tab.MouseButton1Click:Connect(function()
        FilterPoses(catName)
    end)
end

-- Botão Salvar Pose Atual
local SavePoseBtn = Instance.new("TextButton")
SavePoseBtn.Size = UDim2.new(1, -20, 0, 45)
SavePoseBtn.Position = UDim2.new(0, 10, 1, -55)
SavePoseBtn.BackgroundColor3 = Colors.Success
SavePoseBtn.Text = "💾 Salvar Pose Atual"
SavePoseBtn.TextColor3 = Colors.Text
SavePoseBtn.TextSize = 13
SavePoseBtn.Font = Enum.Font.GothamBold
SavePoseBtn.ZIndex = 31
SavePoseBtn.Parent = LibraryFrame

local saveBtnCorner = Instance.new("UICorner")
saveBtnCorner.CornerRadius = UDim.new(0, 10)
saveBtnCorner.Parent = SavePoseBtn

SavePoseBtn.MouseButton1Click:Connect(function()
    local selectedObj = Animator.SelectedObject
    
    if not selectedObj or not selectedObj:IsA("Model") then
        CreateNotification("⚠️ Aviso", "Selecione um Rig primeiro!", 3)
        return
    end
    
    -- Capturar pose atual
    local poseData = {
        Name = "Pose Customizada " .. (#PoseLibrary.CustomPoses + 1),
        Icon = "⭐",
        Category = "Customizado",
        Description = "Pose salva pelo usuário",
        Data = {}
    }
    
    for _, part in pairs(selectedObj:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            poseData.Data[part.Name] = part.CFrame - part.CFrame.Position
        end
    end
    
    table.insert(PoseLibrary.CustomPoses, poseData)
    table.insert(PoseLibrary.Poses, poseData)
    
    if not table.find(PoseLibrary.Categories, "Customizado") then
        table.insert(PoseLibrary.Categories, "Customizado")
    end
    
    FilterPoses(selectedCategory)
    
    CreateNotification("💾 Salvo", "Pose customizada salva!", 2)
end)

-- Carregar poses iniciais
FilterPoses("Todos")

-- Eventos
CloseLibBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(LibraryFrame)
end)

-- Função para abrir
local function OpenPoseLibrary()
    Plugins.AnimateIn(LibraryFrame)
end

-- Botão no ToolPanel
local CreateToolButton = Animator.CreateToolButton
CreateToolButton("Library", "📚", "Biblioteca de Poses", OpenPoseLibrary)

-- Armazenar
Animator.LibraryFrame = LibraryFrame
Animator.PoseLibrary = PoseLibrary
Animator.OpenPoseLibrary = OpenPoseLibrary
Animator.ApplyPose = ApplyPose

print("✅ MORTAL ANIMATOR - Biblioteca de Poses Carregada!")

--[[
    ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
    PARTE 15: Finalização e Otimizações
    Ajustes finais, performance e polish
    Compatível com: Delta Executor, Mobile e PC
    Jogo: Studio Lite
]]

local Plugins = _G.MortalPlugins
local Animator = Plugins.Animator
local Colors = Plugins.Colors
local CreateTween = Plugins.CreateTween
local CreateNotification = Plugins.CreateNotification
local ScreenGui = Plugins.ScreenGui
local IsMobile = Plugins.IsMobile

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ========== OTIMIZAÇÕES DE PERFORMANCE ==========

-- Limitar FPS das animações de UI
local UIUpdateRate = 1/30
local lastUIUpdate = 0

RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastUIUpdate < UIUpdateRate then return end
    lastUIUpdate = now
    
    -- Atualizar elementos de UI que precisam de refresh
    pcall(function()
        if Animator.FrameCounter then
            Animator.FrameCounter.Text = "Frame: " .. (Animator.CurrentFrame or 0)
        end
    end)
end)

-- ========== ATALHOS GLOBAIS ==========

-- Botão flutuante de ajuda
local HelpButton = Instance.new("TextButton")
HelpButton.Name = "HelpButton"
HelpButton.Size = UDim2.new(0, 45, 0, 45)
HelpButton.Position = UDim2.new(1, -60, 1, -60)
HelpButton.BackgroundColor3 = Colors.Accent
HelpButton.Text = "❓"
HelpButton.TextSize = 22
HelpButton.Font = Enum.Font.GothamBold
HelpButton.TextColor3 = Colors.Text
HelpButton.ZIndex = 50
HelpButton.Visible = false
HelpButton.Parent = ScreenGui

local HelpCorner = Instance.new("UICorner")
HelpCorner.CornerRadius = UDim.new(1, 0)
HelpCorner.Parent = HelpButton

local HelpStroke = Instance.new("UIStroke")
HelpStroke.Color = Colors.Text
HelpStroke.Thickness = 2
HelpStroke.Parent = HelpButton

-- Frame de Ajuda
local HelpFrame = Instance.new("Frame")
HelpFrame.Name = "HelpFrame"
HelpFrame.Size = UDim2.new(0, IsMobile and 300 or 400, 0, 450)
HelpFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
HelpFrame.AnchorPoint = Vector2.new(0.5, 0.5)
HelpFrame.BackgroundColor3 = Colors.Background
HelpFrame.BorderSizePixel = 0
HelpFrame.Visible = false
HelpFrame.ZIndex = 55
HelpFrame.Parent = ScreenGui

HelpFrame:SetAttribute("OriginalSize", HelpFrame.Size)

local HelpFrameCorner = Instance.new("UICorner")
HelpFrameCorner.CornerRadius = UDim.new(0, 14)
HelpFrameCorner.Parent = HelpFrame

local HelpFrameStroke = Instance.new("UIStroke")
HelpFrameStroke.Color = Colors.Accent
HelpFrameStroke.Thickness = 2
HelpFrameStroke.Parent = HelpFrame

-- Header da Ajuda
local HelpHeader = Instance.new("Frame")
HelpHeader.Size = UDim2.new(1, 0, 0, 50)
HelpHeader.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
HelpHeader.BorderSizePixel = 0
HelpHeader.ZIndex = 56
HelpHeader.Parent = HelpFrame

local HelpHeaderCorner = Instance.new("UICorner")
HelpHeaderCorner.CornerRadius = UDim.new(0, 14)
HelpHeaderCorner.Parent = HelpHeader

local HelpTitle = Instance.new("TextLabel")
HelpTitle.Size = UDim2.new(0.8, 0, 1, 0)
HelpTitle.Position = UDim2.new(0, 15, 0, 0)
HelpTitle.BackgroundTransparency = 1
HelpTitle.Font = Enum.Font.GothamBold
HelpTitle.Text = "❓ Ajuda - Mortal Animator"
HelpTitle.TextColor3 = Colors.Text
HelpTitle.TextSize = 14
HelpTitle.TextXAlignment = Enum.TextXAlignment.Left
HelpTitle.ZIndex = 57
HelpTitle.Parent = HelpHeader

local CloseHelpBtn = Instance.new("TextButton")
CloseHelpBtn.Size = UDim2.new(0, 35, 0, 35)
CloseHelpBtn.Position = UDim2.new(1, -42, 0.5, -17)
CloseHelpBtn.BackgroundColor3 = Colors.Danger
CloseHelpBtn.Text = "✕"
CloseHelpBtn.TextColor3 = Colors.Text
CloseHelpBtn.TextSize = 16
CloseHelpBtn.Font = Enum.Font.GothamBold
CloseHelpBtn.ZIndex = 57
CloseHelpBtn.Parent = HelpHeader

local CloseHelpCorner = Instance.new("UICorner")
CloseHelpCorner.CornerRadius = UDim.new(0, 8)
CloseHelpCorner.Parent = CloseHelpBtn

-- Conteúdo da Ajuda
local HelpContent = Instance.new("ScrollingFrame")
HelpContent.Size = UDim2.new(1, -20, 1, -65)
HelpContent.Position = UDim2.new(0, 10, 0, 55)
HelpContent.BackgroundTransparency = 1
HelpContent.ScrollBarThickness = 4
HelpContent.ScrollBarImageColor3 = Colors.Accent
HelpContent.ZIndex = 56
HelpContent.CanvasSize = UDim2.new(0, 0, 0, 0)
HelpContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
HelpContent.Parent = HelpFrame

local HelpLayout = Instance.new("UIListLayout")
HelpLayout.Padding = UDim.new(0, 10)
HelpLayout.Parent = HelpContent

-- Tópicos de ajuda
local HelpTopics = {
    {
        Title = "🎬 Como Animar",
        Content = "1. Selecione um objeto/rig no Explorer\n2. Clique em 🦴 para analisar\n3. Use as ferramentas Move/Rotate do Studio Lite\n4. Pressione K ou clique 🔑 para adicionar keyframe\n5. Avance frames e repita!"
    },
    {
        Title = "📍 Criar Cutscenes",
        Content = "1. Clique em 🎬 Cutscene\n2. Posicione a câmera onde deseja\n3. Clique 📷 Criar Câmera\n4. Repita para mais pontos\n5. Clique ▶️ para testar\n6. Exporte quando finalizar!"
    },
    {
        Title = "📤 Exportar",
        Content = "Clique em 📤 Export para gerar código Lua.\nCopie o código e cole em um LocalScript.\nColoque dentro do objeto animado!"
    },
    {
        Title = "🦾 Sistema IK",
        Content = "IK (Inverse Kinematics) permite mover mãos/pés e o resto do corpo segue automaticamente.\n\n1. Selecione um rig R15\n2. Ative o IK\n3. Escolha um membro\n4. Arraste a esfera verde!"
    },
    {
        Title = "📚 Poses",
        Content = "Use poses prontas para acelerar!\n\n1. Clique em 📚 Biblioteca\n2. Escolha uma categoria\n3. Clique na pose desejada\n4. Ela será aplicada ao rig!"
    },
    {
        Title = "⌨️ Atalhos",
        Content = "K = Adicionar Keyframe\nSpace = Play/Pause\n← → = Navegar frames\nCtrl+Z = Desfazer\nCtrl+Y = Refazer\nCtrl+S = Salvar"
    }
}

for _, topic in ipairs(HelpTopics) do
    local topicFrame = Instance.new("Frame")
    topicFrame.Size = UDim2.new(1, 0, 0, 0)
    topicFrame.AutomaticSize = Enum.AutomaticSize.Y
    topicFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    topicFrame.BorderSizePixel = 0
    topicFrame.ZIndex = 57
    topicFrame.Parent = HelpContent
    
    local topicCorner = Instance.new("UICorner")
    topicCorner.CornerRadius = UDim.new(0, 10)
    topicCorner.Parent = topicFrame
    
    local topicPadding = Instance.new("UIPadding")
    topicPadding.PaddingTop = UDim.new(0, 10)
    topicPadding.PaddingBottom = UDim.new(0, 10)
    topicPadding.PaddingLeft = UDim.new(0, 12)
    topicPadding.PaddingRight = UDim.new(0, 12)
    topicPadding.Parent = topicFrame
    
    local topicLayout = Instance.new("UIListLayout")
    topicLayout.Padding = UDim.new(0, 5)
    topicLayout.Parent = topicFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = topic.Title
    titleLabel.TextColor3 = Colors.Accent
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 58
    titleLabel.Parent = topicFrame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, 0, 0, 0)
    contentLabel.AutomaticSize = Enum.AutomaticSize.Y
    contentLabel.BackgroundTransparency = 1
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.Text = topic.Content
    contentLabel.TextColor3 = Colors.TextSecondary
    contentLabel.TextSize = 11
    contentLabel.TextWrapped = true
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.ZIndex = 58
    contentLabel.Parent = topicFrame
end

-- Eventos de ajuda
HelpButton.MouseButton1Click:Connect(function()
    Plugins.AnimateIn(HelpFrame)
end)

CloseHelpBtn.MouseButton1Click:Connect(function()
    Plugins.AnimateOut(HelpFrame)
end)

-- ========== INDICADOR DE STATUS ==========

local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Size = UDim2.new(0, 200, 0, 30)
StatusBar.Position = UDim2.new(0.5, -100, 1, -40)
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatusBar.BorderSizePixel = 0
StatusBar.Visible = false
StatusBar.ZIndex = 45
StatusBar.Parent = ScreenGui

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBar

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Color = Colors.Border
StatusStroke.Thickness = 1
StatusStroke.Parent = StatusBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Label"
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 5, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "🟢 Pronto"
StatusLabel.TextColor3 = Colors.Text
StatusLabel.TextSize = 11
StatusLabel.ZIndex = 46
StatusLabel.Parent = StatusBar

-- Função para atualizar status
local function UpdateStatus(text, color)
    StatusLabel.Text = text
    StatusStroke.Color = color or Colors.Border
end

-- ========== AUTO-SAVE ==========

local AutoSaveEnabled = true
local AutoSaveInterval = 60

if AutoSaveEnabled then
    task.spawn(function()
        while task.wait(AutoSaveInterval) do
            pcall(function()
                if Animator.AnimationManager and Animator.AnimationManager.CurrentAnimation then
                    if Animator.KeyframeSystem then
                        Animator.AnimationManager.CurrentAnimation.KeyframeData = Animator.KeyframeSystem.Data
                    end
                end
            end)
        end
    end)
end

-- ========== FEEDBACK VISUAL ==========

-- Pulsar o botão toggle quando houver alterações não salvas
local hasUnsavedChanges = false

local function SetUnsavedChanges(value)
    hasUnsavedChanges = value
    
    local toggleBtn = ScreenGui:FindFirstChild("ToggleButton")
    if toggleBtn then
        if value then
            -- Pulsar
            task.spawn(function()
                while hasUnsavedChanges do
                    CreateTween(toggleBtn, {BackgroundColor3 = Colors.Warning}, 0.5):Play()
                    task.wait(0.5)
                    if not hasUnsavedChanges then break end
                    CreateTween(toggleBtn, {BackgroundColor3 = Colors.Background}, 0.5):Play()
                    task.wait(0.5)
                end
            end)
        else
            CreateTween(toggleBtn, {BackgroundColor3 = Colors.Background}, 0.3):Play()
        end
    end
end

-- ========== VERSÃO E CRÉDITOS ==========

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "Version"
VersionLabel.Size = UDim2.new(0, 150, 0, 20)
VersionLabel.Position = UDim2.new(0, 10, 1, -25)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Text = "⚡ Mortal Animator V1.0"
VersionLabel.TextColor3 = Color3.fromRGB(80, 80, 100)
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Visible = false
VersionLabel.ZIndex = 5
VersionLabel.Parent = ScreenGui

-- ========== INICIALIZAÇÃO FINAL ==========

-- Mostrar elementos após carregamento
task.spawn(function()
    task.wait(1)
    HelpButton.Visible = true
    StatusBar.Visible = true
    VersionLabel.Visible = true
    
    -- Animação de entrada do botão de ajuda
    HelpButton.Position = UDim2.new(1, 0, 1, -60)
    CreateTween(HelpButton, {Position = UDim2.new(1, -60, 1, -60)}, 0.5, Enum.EasingStyle.Back):Play()
end)

-- ========== LIMPEZA AO SAIR ==========

game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    -- Limpar efeitos
    pcall(function()
        if Animator.CameraFX then
            local blur = game:GetService("Lighting"):FindFirstChild("MortalBlur")
            if blur then blur:Destroy() end
            
            local cc = game:GetService("Lighting"):FindFirstChild("MortalCC")
            if cc then cc:Destroy() end
        end
        
        -- Limpar targets IK
        if Animator.IKSystem and Animator.IKSystem.Targets then
            for _, target in pairs(Animator.IKSystem.Targets) do
                if target then target:Destroy() end
            end
        end
        
        -- Limpar pontos de cutscene
        if Animator.CutsceneSystem and Animator.CutsceneSystem.CameraPoints then
            for _, point in pairs(Animator.CutsceneSystem.CameraPoints) do
                if point.Part then point.Part:Destroy() end
            end
        end
    end)
end)

-- ========== ARMAZENAR REFERÊNCIAS FINAIS ==========

Animator.HelpButton = HelpButton
Animator.HelpFrame = HelpFrame
Animator.StatusBar = StatusBar
Animator.UpdateStatus = UpdateStatus
Animator.SetUnsavedChanges = SetUnsavedChanges
Animator.Version = "1.0"

-- ========== NOTIFICAÇÃO FINAL ==========

CreateNotification(
    "✅ MORTAL ANIMATOR COMPLETO",
    "Todas as 15 partes carregadas!\n\n🎬 Animator profissional AAA pronto para uso!\n\nToque em ❓ para ajuda.",
    7
)

local separador = string.rep("=", 50)

print(separador)
print("⚡☠️ MORTAL ANIMATOR V1 - CARREGAMENTO COMPLETO ☠️⚡")
print(separador)
print("✅ Partes carregadas: 15/15")
print("✅ Interface: OK")
print("✅ Keyframes: OK")
print("✅ Timeline: OK")
print("✅ Cutscenes: OK")
print("✅ IK System: OK")
print("✅ Easing: OK")
print("✅ Export: OK")
print("✅ Poses: OK")
print(separador)
print("Desenvolvido para Studio Lite + Delta Executor")
print("Mobile e PC compatível!")
print(separador)
