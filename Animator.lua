--[[
    ███╗   ███╗ ██████╗ ██████╗ ████████╗ █████╗ ██╗          
    ████╗ ████║██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗██║          
    ██╔████╔██║██║   ██║██████╔╝   ██║   ███████║██║          
    ██║╚██╔╝██║██║   ██║██╔══██╗   ██║   ██╔══██║██║          
    ██║ ╚═╝ ██║╚██████╔╝██║  ██║   ██║   ██║  ██║███████╗     
    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝     
     █████╗ ███╗   ██╗██╗███╗   ███╗ █████╗ ████████╗ ██████╗ ██████╗ 
    ██╔══██╗████╗  ██║██║████╗ ████║██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
    ███████║██╔██╗ ██║██║██╔████╔██║███████║   ██║   ██║   ██║██████╔╝
    ██╔══██║██║╚██╗██║██║██║╚██╔╝██║██╔══██║   ██║   ██║   ██║██╔══██╗
    ██║  ██║██║ ╚████║██║██║ ╚═╝ ██║██║  ██║   ██║   ╚██████╔╝██║  ██║
    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
    
    Mortal Animator☠️ • V1⚡
    Professional Animation System for Delta Executor
    Compatible with Studio Lite
]]

-- ═══════════════════════════════════════════════════════════════════
-- SERVIÇOS ROBLOX
-- ═══════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local HttpService = game:GetService("HttpService")

-- ═══════════════════════════════════════════════════════════════════
-- VARIÁVEIS GLOBAIS
-- ═══════════════════════════════════════════════════════════════════
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = Workspace.CurrentCamera

-- Configurações do Animator
local MortalAnimator = {
    Version = "V1⚡",
    Name = "Mortal Animator☠️",
    Author = "Mortal Studios",
    IsOpen = true,
    CurrentRig = nil,
    CurrentObject = nil,
    SelectedPart = nil,
    IsPlaying = false,
    IsPaused = false,
    CurrentFrame = 0,
    TotalFrames = 0,
    FPS = 60,
    MaxFPS = 90,
    TimelineZoom = 1,
    TimelineScroll = 0,
    AnimationData = {},
    Keyframes = {},
    UndoStack = {},
    RedoStack = {},
    CopiedKeyframes = {},
    LoopAnimation = false,
    AutoKeyframe = false,
    OnionSkinning = false,
    ShowBones = true,
    SnapToGrid = false,
    GridSize = 0.1,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.InOut,
    IKEnabled = false,
    GhostingFrames = 3,
    PlaybackSpeed = 1,
    CurrentTool = "Move",
    CutsceneMode = false,
    CutsceneCameras = {},
    ExportFormat = "LocalScript"
}

-- Cores do Tema
local Theme = {
    Primary = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(100, 60, 180),
    AccentLight = Color3.fromRGB(140, 90, 220),
    AccentDark = Color3.fromRGB(70, 40, 130),
    Success = Color3.fromRGB(50, 200, 100),
    Warning = Color3.fromRGB(255, 180, 50),
    Error = Color3.fromRGB(255, 70, 70),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
    TextMuted = Color3.fromRGB(120, 120, 130),
    Border = Color3.fromRGB(60, 60, 80),
    Timeline = Color3.fromRGB(20, 20, 28),
    TimelineGrid = Color3.fromRGB(40, 40, 55),
    KeyframeNormal = Color3.fromRGB(80, 200, 120),
    KeyframeSelected = Color3.fromRGB(255, 200, 50),
    KeyframeCurrent = Color3.fromRGB(100, 150, 255),
    Gradient1 = Color3.fromRGB(100, 60, 180),
    Gradient2 = Color3.fromRGB(60, 120, 200),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- ═══════════════════════════════════════════════════════════════════
-- LIMPAR GUI EXISTENTE
-- ═══════════════════════════════════════════════════════════════════
local function CleanupExistingGUI()
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "MortalAnimatorGUI" then
            gui:Destroy()
        end
    end
end

CleanupExistingGUI()

-- ═══════════════════════════════════════════════════════════════════
-- CRIAR GUI PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MortalAnimatorGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Tentar colocar no CoreGui, senão coloca no PlayerGui
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════════════════════════
-- FUNÇÕES UTILITÁRIAS
-- ═══════════════════════════════════════════════════════════════════
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            pcall(function()
                instance[prop] = value
            end)
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function CreateGradient(parent, rotation, colorSequence)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = rotation or 45
    gradient.Color = colorSequence or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Gradient1),
        ColorSequenceKeypoint.new(1, Theme.Gradient2)
    })
    gradient.Parent = parent
    return gradient
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Theme.Shadow
    shadow.ImageTransparency = transparency or 0.5
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

local function CreatePadding(parent, left, right, top, bottom)
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, left or 10)
    padding.PaddingRight = UDim.new(0, right or left or 10)
    padding.PaddingTop = UDim.new(0, top or left or 10)
    padding.PaddingBottom = UDim.new(0, bottom or top or left or 10)
    padding.Parent = parent
    return padding
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function LerpColor(c1, c2, t)
    return Color3.new(
        Lerp(c1.R, c2.R, t),
        Lerp(c1.G, c2.G, t),
        Lerp(c1.B, c2.B, t)
    )
end

local function DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function FormatTime(frames, fps)
    local seconds = frames / fps
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%05.2f", minutes, secs)
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- ═══════════════════════════════════════════════════════════════════
-- SISTEMA DE NOTIFICAÇÃO
-- ═══════════════════════════════════════════════════════════════════
local NotificationContainer = CreateInstance("Frame", {
    Name = "NotificationContainer",
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -20, 1, -20),
    AnchorPoint = Vector2.new(1, 1),
    Size = UDim2.new(0, 350, 0, 400),
    Parent = ScreenGui
})

local NotificationLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 10),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = NotificationContainer
})

local function CreateNotification(title, message, notifType, duration)
    local notifColor = Theme.Accent
    local icon = "⚡"
    
    if notifType == "success" then
        notifColor = Theme.Success
        icon = "✅"
    elseif notifType == "warning" then
        notifColor = Theme.Warning
        icon = "⚠️"
    elseif notifType == "error" then
        notifColor = Theme.Error
        icon = "❌"
    elseif notifType == "crown" then
        notifColor = Color3.fromRGB(255, 200, 50)
        icon = "👑"
    end
    
    local NotifFrame = CreateInstance("Frame", {
        Name = "Notification",
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(0, 330, 0, 0),
        ClipsDescendants = true,
        Parent = NotificationContainer
    })
    CreateCorner(NotifFrame, 12)
    CreateStroke(NotifFrame, notifColor, 2, 0.3)
    CreateShadow(NotifFrame, 40, 0.3)
    
    local AccentBar = CreateInstance("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = notifColor,
        Size = UDim2.new(0, 4, 1, 0),
        BorderSizePixel = 0,
        Parent = NotifFrame
    })
    CreateCorner(AccentBar, 2)
    
    local ContentFrame = CreateInstance("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Parent = NotifFrame
    })
    
    local TitleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 12),
        Size = UDim2.new(1, 0, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = icon .. " " .. title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ContentFrame
    })
    
    local MessageLabel = CreateInstance("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 38),
        Size = UDim2.new(1, -10, 0, 40),
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = Theme.TextSecondary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = ContentFrame
    })
    
    local ProgressBar = CreateInstance("Frame", {
        Name = "ProgressBar",
        BackgroundColor3 = notifColor,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        BorderSizePixel = 0,
        Parent = NotifFrame
    })
    
    -- Animação de entrada
    Tween(NotifFrame, {Size = UDim2.new(0, 330, 0, 90)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Progress bar animation
    Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration or 4, Enum.EasingStyle.Linear)
    
    -- Remover após duração
    task.delay(duration or 4, function()
        Tween(NotifFrame, {Size = UDim2.new(0, 330, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        NotifFrame:Destroy()
    end)
    
    return NotifFrame
end

-- ═══════════════════════════════════════════════════════════════════
-- BOTÃO TOGGLE FLUTUANTE (DRAGGABLE)
-- ═══════════════════════════════════════════════════════════════════
local ToggleButton = CreateInstance("TextButton", {
    Name = "ToggleButton",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 20, 0, 50),
    Size = UDim2.new(0, 50, 0, 50),
    Text = "☠️",
    TextSize = 28,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Parent = ScreenGui
})
CreateCorner(ToggleButton, 25)
CreateStroke(ToggleButton, Theme.Accent, 2, 0.3)
CreateShadow(ToggleButton, 30, 0.4)
CreateGradient(ToggleButton, 45)

-- Sistema de Drag para o botão toggle
local isDraggingToggle = false
local dragStartToggle
local startPosToggle

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDraggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = ToggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDraggingToggle = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if isDraggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or 
       input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartToggle
        local newPos = UDim2.new(
            startPosToggle.X.Scale,
            startPosToggle.X.Offset + delta.X,
            startPosToggle.Y.Scale,
            startPosToggle.Y.Offset + delta.Y
        )
        ToggleButton.Position = newPos
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or 
       input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartToggle
        local newPos = UDim2.new(
            startPosToggle.X.Scale,
            startPosToggle.X.Offset + delta.X,
            startPosToggle.Y.Scale,
            startPosToggle.Y.Offset + delta.Y
        )
        ToggleButton.Position = newPos
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- CONTAINER PRINCIPAL DO ANIMATOR
-- ═══════════════════════════════════════════════════════════════════
local MainContainer = CreateInstance("Frame", {
    Name = "MainContainer",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 1200, 0, 700),
    ClipsDescendants = true,
    Visible = true,
    Parent = ScreenGui
})
CreateCorner(MainContainer, 16)
CreateStroke(MainContainer, Theme.Accent, 2, 0.4)
CreateShadow(MainContainer, 60, 0.5)

-- Responsividade para mobile
if IsMobile() then
    MainContainer.Size = UDim2.new(0.95, 0, 0.85, 0)
end

-- ═══════════════════════════════════════════════════════════════════
-- HEADER DO ANIMATOR
-- ═══════════════════════════════════════════════════════════════════
local Header = CreateInstance("Frame", {
    Name = "Header",
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 50),
    BorderSizePixel = 0,
    Parent = MainContainer
})
CreateCorner(Header, 16)

-- Corrigir cantos inferiores do header
local HeaderFix = CreateInstance("Frame", {
    Name = "HeaderFix",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 0, 1, -16),
    Size = UDim2.new(1, 0, 0, 16),
    BorderSizePixel = 0,
    Parent = Header
})

local TitleLabel = CreateInstance("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 0),
    Size = UDim2.new(0, 400, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "☠️ Mortal Animator☠️ • V1⚡",
    TextColor3 = Theme.TextPrimary,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header
})

-- Gradiente no título
local TitleGradient = CreateGradient(TitleLabel, 0, ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 200, 255))
}))

-- FPS Counter
local FPSLabel = CreateInstance("TextLabel", {
    Name = "FPSLabel",
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -200, 0, 0),
    Size = UDim2.new(0, 80, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "60 FPS",
    TextColor3 = Theme.Success,
    TextSize = 14,
    Parent = Header
})

-- Botões do Header
local HeaderButtons = CreateInstance("Frame", {
    Name = "HeaderButtons",
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -120, 0, 0),
    Size = UDim2.new(0, 110, 1, 0),
    Parent = Header
})

local HeaderButtonsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 10),
    Parent = HeaderButtons
})

local function CreateHeaderButton(name, icon, callback)
    local btn = CreateInstance("TextButton", {
        Name = name,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 35, 0, 35),
        Text = icon,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        AutoButtonColor = false,
        Parent = HeaderButtons
    })
    CreateCorner(btn, 8)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
    
    btn.MouseButton1Click:Connect(callback or function() end)
    
    return btn
end

local MinimizeBtn = CreateHeaderButton("Minimize", "─", function()
    -- Minimizar
end)

local CloseBtn = CreateHeaderButton("Close", "✕", function()
    MortalAnimator.IsOpen = false
    Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
end)

-- Toggle Button Click
ToggleButton.MouseButton1Click:Connect(function()
    if not isDraggingToggle then
        MortalAnimator.IsOpen = not MortalAnimator.IsOpen
        if MortalAnimator.IsOpen then
            MainContainer.Visible = true
            MainContainer.Size = UDim2.new(0, 0, 0, 0)
            local targetSize = IsMobile() and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 1200, 0, 700)
            Tween(MainContainer, {Size = targetSize}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.3)
            MainContainer.Visible = false
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- NOTIFICAÇÃO INICIAL
-- ═══════════════════════════════════════════════════════════════════
task.wait(0.5)
CreateNotification(
    "👑☠️MORTAL ANIMATOR CARREGADO COM SUCESSO☠️👑",
    "Aproveite essa ferramenta profissional⚡",
    "crown",
    5
)

print("✅ Mortal Animator - Parte 1 carregada com sucesso!")
print("📦 Aguardando próxima parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 2: PAINÉIS LATERAIS E TOOLBAR
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- PAINEL LATERAL ESQUERDO (HIERARQUIA / RIG)
-- ═══════════════════════════════════════════════════════════════════
local LeftPanel = CreateInstance("Frame", {
    Name = "LeftPanel",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 0, 0, 50),
    Size = UDim2.new(0, 250, 1, -50),
    BorderSizePixel = 0,
    Parent = MainContainer
})

local LeftPanelHeader = CreateInstance("Frame", {
    Name = "Header",
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(1, 0, 0, 40),
    BorderSizePixel = 0,
    Parent = LeftPanel
})

local LeftPanelTitle = CreateInstance("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(1, -15, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "🦴 Hierarquia",
    TextColor3 = Theme.TextPrimary,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = LeftPanelHeader
})

-- Container de busca
local SearchContainer = CreateInstance("Frame", {
    Name = "SearchContainer",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0, 10, 0, 50),
    Size = UDim2.new(1, -20, 0, 35),
    Parent = LeftPanel
})
CreateCorner(SearchContainer, 8)

local SearchIcon = CreateInstance("TextLabel", {
    Name = "SearchIcon",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(0, 25, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "🔍",
    TextColor3 = Theme.TextMuted,
    TextSize = 14,
    Parent = SearchContainer
})

local SearchBox = CreateInstance("TextBox", {
    Name = "SearchBox",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 40, 0, 0),
    Size = UDim2.new(1, -50, 1, 0),
    Font = Enum.Font.Gotham,
    PlaceholderText = "Buscar parte...",
    PlaceholderColor3 = Theme.TextMuted,
    Text = "",
    TextColor3 = Theme.TextPrimary,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    Parent = SearchContainer
})

-- Lista de hierarquia com scroll
local HierarchyScroll = CreateInstance("ScrollingFrame", {
    Name = "HierarchyScroll",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 5, 0, 95),
    Size = UDim2.new(1, -10, 1, -100),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Accent,
    BorderSizePixel = 0,
    Parent = LeftPanel
})

local HierarchyLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 2),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = HierarchyScroll
})

-- Função para criar item da hierarquia
local function CreateHierarchyItem(name, icon, depth, partRef)
    local item = CreateInstance("TextButton", {
        Name = name,
        BackgroundColor3 = Theme.Tertiary,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 0, 32),
        Text = "",
        AutoButtonColor = false,
        Parent = HierarchyScroll
    })
    CreateCorner(item, 6)
    
    local indent = CreateInstance("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, depth * 15, 1, 0),
        Parent = item
    })
    
    local iconLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, depth * 15 + 8, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = icon,
        TextColor3 = Theme.Accent,
        TextSize = 14,
        Parent = item
    })
    
    local nameLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, depth * 15 + 32, 0, 0),
        Size = UDim2.new(1, -(depth * 15 + 40), 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = item
    })
    
    item.MouseEnter:Connect(function()
        Tween(item, {BackgroundTransparency = 0}, 0.15)
        Tween(nameLabel, {TextColor3 = Theme.TextPrimary}, 0.15)
    end)
    
    item.MouseLeave:Connect(function()
        if MortalAnimator.SelectedPart ~= partRef then
            Tween(item, {BackgroundTransparency = 0.5}, 0.15)
            Tween(nameLabel, {TextColor3 = Theme.TextSecondary}, 0.15)
        end
    end)
    
    item.MouseButton1Click:Connect(function()
        MortalAnimator.SelectedPart = partRef
        -- Destacar parte selecionada
        for _, child in pairs(HierarchyScroll:GetChildren()) do
            if child:IsA("TextButton") then
                Tween(child, {BackgroundTransparency = 0.5, BackgroundColor3 = Theme.Tertiary}, 0.15)
            end
        end
        Tween(item, {BackgroundTransparency = 0, BackgroundColor3 = Theme.Accent}, 0.15)
        CreateNotification("Parte Selecionada", name, "success", 2)
    end)
    
    return item
end

-- ═══════════════════════════════════════════════════════════════════
-- TOOLBAR PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════
local Toolbar = CreateInstance("Frame", {
    Name = "Toolbar",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 250, 0, 50),
    Size = UDim2.new(1, -500, 0, 45),
    BorderSizePixel = 0,
    Parent = MainContainer
})

local ToolbarLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 5),
    Parent = Toolbar
})

CreatePadding(Toolbar, 10, 10, 0, 0)

-- Separador visual
local function CreateSeparator(parent)
    local sep = CreateInstance("Frame", {
        BackgroundColor3 = Theme.Border,
        Size = UDim2.new(0, 1, 0, 30),
        BorderSizePixel = 0,
        Parent = parent
    })
    return sep
end

-- Botão da Toolbar
local function CreateToolbarButton(name, icon, tooltip, callback, isToggle)
    local btn = CreateInstance("TextButton", {
        Name = name,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 40, 0, 35),
        Text = icon,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextSecondary,
        AutoButtonColor = false,
        Parent = Toolbar
    })
    CreateCorner(btn, 8)
    
    local isActive = false
    
    -- Tooltip
    local tooltipLabel = CreateInstance("TextLabel", {
        Name = "Tooltip",
        BackgroundColor3 = Theme.Primary,
        Position = UDim2.new(0.5, 0, 1, 5),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0, 0, 0, 25),
        Font = Enum.Font.Gotham,
        Text = tooltip,
        TextColor3 = Theme.TextPrimary,
        TextSize = 11,
        Visible = false,
        ZIndex = 100,
        ClipsDescendants = true,
        Parent = btn
    })
    CreateCorner(tooltipLabel, 4)
    CreatePadding(tooltipLabel, 8, 8, 0, 0)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15)
        Tween(btn, {TextColor3 = Theme.TextPrimary}, 0.15)
        tooltipLabel.Visible = true
        tooltipLabel.Size = UDim2.new(0, 0, 0, 25)
        Tween(tooltipLabel, {Size = UDim2.new(0, #tooltip * 7 + 16, 0, 25)}, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        if not isActive then
            Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
            Tween(btn, {TextColor3 = Theme.TextSecondary}, 0.15)
        end
        tooltipLabel.Visible = false
    end)
    
    btn.MouseButton1Click:Connect(function()
        if isToggle then
            isActive = not isActive
            if isActive then
                Tween(btn, {BackgroundColor3 = Theme.AccentLight}, 0.15)
            else
                Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
            end
        end
        if callback then callback(isActive) end
    end)
    
    return btn, function(state) isActive = state end
end

-- Grupo de ferramentas de transformação
local MoveBtn = CreateToolbarButton("Move", "↔️", "Mover (M)", function()
    MortalAnimator.CurrentTool = "Move"
    CreateNotification("Ferramenta", "Modo Mover ativado", "success", 2)
end)

local RotateBtn = CreateToolbarButton("Rotate", "🔄", "Rotacionar (R)", function()
    MortalAnimator.CurrentTool = "Rotate"
    CreateNotification("Ferramenta", "Modo Rotacionar ativado", "success", 2)
end)

local ScaleBtn = CreateToolbarButton("Scale", "⬛", "Escalar (S)", function()
    MortalAnimator.CurrentTool = "Scale"
    CreateNotification("Ferramenta", "Modo Escalar ativado", "success", 2)
end)

CreateSeparator(Toolbar)

-- Controles de playback
local PlayBtn = CreateToolbarButton("Play", "▶️", "Reproduzir (Space)", function()
    MortalAnimator.IsPlaying = not MortalAnimator.IsPlaying
    if MortalAnimator.IsPlaying then
        CreateNotification("Playback", "Reproduzindo animação...", "success", 2)
    end
end, true)

local PauseBtn = CreateToolbarButton("Pause", "⏸️", "Pausar", function()
    MortalAnimator.IsPaused = not MortalAnimator.IsPaused
end, true)

local StopBtn = CreateToolbarButton("Stop", "⏹️", "Parar", function()
    MortalAnimator.IsPlaying = false
    MortalAnimator.CurrentFrame = 0
end)

local LoopBtn = CreateToolbarButton("Loop", "🔁", "Loop (L)", function(active)
    MortalAnimator.LoopAnimation = active
    CreateNotification("Loop", active and "Loop ativado" or "Loop desativado", "success", 2)
end, true)

CreateSeparator(Toolbar)

-- Controles de keyframe
local AddKeyBtn = CreateToolbarButton("AddKey", "🔑", "Adicionar Keyframe (K)", function()
    -- Adicionar keyframe
end)

local RemoveKeyBtn = CreateToolbarButton("RemoveKey", "🗑️", "Remover Keyframe (Del)", function()
    -- Remover keyframe
end)

local AutoKeyBtn = CreateToolbarButton("AutoKey", "⚡", "Auto Keyframe (A)", function(active)
    MortalAnimator.AutoKeyframe = active
    CreateNotification("Auto Key", active and "Auto Keyframe ativado" or "Auto Keyframe desativado", "success", 2)
end, true)

CreateSeparator(Toolbar)

-- Controles avançados
local UndoBtn = CreateToolbarButton("Undo", "↩️", "Desfazer (Ctrl+Z)", function()
    -- Undo
end)

local RedoBtn = CreateToolbarButton("Redo", "↪️", "Refazer (Ctrl+Y)", function()
    -- Redo
end)

local CopyBtn = CreateToolbarButton("Copy", "📋", "Copiar Keyframes (Ctrl+C)", function()
    -- Copy keyframes
end)

local PasteBtn = CreateToolbarButton("Paste", "📄", "Colar Keyframes (Ctrl+V)", function()
    -- Paste keyframes
end)

CreateSeparator(Toolbar)

-- Ferramentas especiais
local OnionBtn = CreateToolbarButton("Onion", "🧅", "Onion Skinning (O)", function(active)
    MortalAnimator.OnionSkinning = active
end, true)

local IKBtn = CreateToolbarButton("IK", "🦿", "Inverse Kinematics (I)", function(active)
    MortalAnimator.IKEnabled = active
end, true)

local SnapBtn = CreateToolbarButton("Snap", "🧲", "Snap to Grid (G)", function(active)
    MortalAnimator.SnapToGrid = active
end, true)

-- ═══════════════════════════════════════════════════════════════════
-- PAINEL LATERAL DIREITO (PROPRIEDADES)
-- ═══════════════════════════════════════════════════════════════════
local RightPanel = CreateInstance("Frame", {
    Name = "RightPanel",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(1, -250, 0, 50),
    Size = UDim2.new(0, 250, 1, -50),
    BorderSizePixel = 0,
    Parent = MainContainer
})

local RightPanelHeader = CreateInstance("Frame", {
    Name = "Header",
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(1, 0, 0, 40),
    BorderSizePixel = 0,
    Parent = RightPanel
})

local RightPanelTitle = CreateInstance("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(1, -15, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "⚙️ Propriedades",
    TextColor3 = Theme.TextPrimary,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = RightPanelHeader
})

-- Scroll de propriedades
local PropertiesScroll = CreateInstance("ScrollingFrame", {
    Name = "PropertiesScroll",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 5, 0, 50),
    Size = UDim2.new(1, -10, 1, -55),
    CanvasSize = UDim2.new(0, 0, 0, 600),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Accent,
    BorderSizePixel = 0,
    Parent = RightPanel
})

local PropertiesLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = PropertiesScroll
})

-- Seção de propriedades
local function CreatePropertySection(title, parent)
    local section = CreateInstance("Frame", {
        Name = title,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 35),
        Parent = parent or PropertiesScroll
    })
    CreateCorner(section, 8)
    
    local sectionTitle = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "▼ " .. title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section
    })
    
    local contentFrame = CreateInstance("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Parent = section
    })
    
    local contentLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = contentFrame
    })
    
    CreatePadding(contentFrame, 10, 10, 5, 5)
    
    return section, contentFrame
end

-- Campo numérico
local function CreateNumberField(name, defaultValue, parent, onChange)
    local field = CreateInstance("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        Parent = parent
    })
    
    local label = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = field
    })
    
    local inputBox = CreateInstance("TextBox", {
        BackgroundColor3 = Theme.Primary,
        Position = UDim2.new(0.4, 0, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = tostring(defaultValue or 0),
        TextColor3 = Theme.TextPrimary,
        TextSize = 11,
        Parent = field
    })
    CreateCorner(inputBox, 4)
    
    inputBox.FocusLost:Connect(function()
        local num = tonumber(inputBox.Text) or defaultValue
        inputBox.Text = tostring(num)
        if onChange then onChange(num) end
    end)
    
    return field, inputBox
end

-- Criar seções de propriedades
local TransformSection, TransformContent = CreatePropertySection("Transform")
TransformSection.Size = UDim2.new(1, 0, 0, 150)

local PosXField = CreateNumberField("Position X", 0, TransformContent)
local PosYField = CreateNumberField("Position Y", 0, TransformContent)
local PosZField = CreateNumberField("Position Z", 0, TransformContent)

local RotSection, RotContent = CreatePropertySection("Rotation")
RotSection.Size = UDim2.new(1, 0, 0, 150)

local RotXField = CreateNumberField("Rotation X", 0, RotContent)
local RotYField = CreateNumberField("Rotation Y", 0, RotContent)
local RotZField = CreateNumberField("Rotation Z", 0, RotContent)

local EasingSection, EasingContent = CreatePropertySection("Easing")
EasingSection.Size = UDim2.new(1, 0, 0, 100)

print("✅ Mortal Animator - Parte 2 carregada com sucesso!")
print("📦 Aguardando próxima parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 3: SISTEMA DE TIMELINE
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- ÁREA DE VIEWPORT (PREVIEW)
-- ═══════════════════════════════════════════════════════════════════
local ViewportArea = CreateInstance("Frame", {
    Name = "ViewportArea",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0, 250, 0, 95),
    Size = UDim2.new(1, -500, 0, 250),
    BorderSizePixel = 0,
    Parent = MainContainer
})

local ViewportFrame = CreateInstance("ViewportFrame", {
    Name = "Viewport",
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    Size = UDim2.new(1, 0, 1, 0),
    BorderSizePixel = 0,
    Ambient = Color3.fromRGB(150, 150, 150),
    LightColor = Color3.fromRGB(255, 255, 255),
    LightDirection = Vector3.new(-1, -1, -1),
    Parent = ViewportArea
})
CreateCorner(ViewportFrame, 8)

-- Camera do Viewport
local ViewportCamera = Instance.new("Camera")
ViewportCamera.CFrame = CFrame.new(Vector3.new(0, 5, 10), Vector3.new(0, 0, 0))
ViewportFrame.CurrentCamera = ViewportCamera

-- Controles do Viewport
local ViewportControls = CreateInstance("Frame", {
    Name = "ViewportControls",
    BackgroundColor3 = Theme.Secondary,
    BackgroundTransparency = 0.3,
    Position = UDim2.new(0, 10, 0, 10),
    Size = UDim2.new(0, 150, 0, 35),
    Parent = ViewportArea
})
CreateCorner(ViewportControls, 8)

local ViewportControlsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 5),
    Parent = ViewportControls
})
CreatePadding(ViewportControls, 5, 5, 0, 0)

local function CreateViewportButton(icon, tooltip, callback)
    local btn = CreateInstance("TextButton", {
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 28, 0, 25),
        Text = icon,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextSecondary,
        AutoButtonColor = false,
        Parent = ViewportControls
    })
    CreateCorner(btn, 4)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
    end)
    btn.MouseButton1Click:Connect(callback or function() end)
    
    return btn
end

CreateViewportButton("🔄", "Reset View", function()
    ViewportCamera.CFrame = CFrame.new(Vector3.new(0, 5, 10), Vector3.new(0, 0, 0))
end)

CreateViewportButton("📷", "Front View", function()
    ViewportCamera.CFrame = CFrame.new(Vector3.new(0, 0, 10), Vector3.new(0, 0, 0))
end)

CreateViewportButton("🔝", "Top View", function()
    ViewportCamera.CFrame = CFrame.new(Vector3.new(0, 10, 0), Vector3.new(0, 0, 0))
end)

CreateViewportButton("➡️", "Side View", function()
    ViewportCamera.CFrame = CFrame.new(Vector3.new(10, 0, 0), Vector3.new(0, 0, 0))
end)

-- Info do Frame atual
local FrameInfo = CreateInstance("Frame", {
    Name = "FrameInfo",
    BackgroundColor3 = Theme.Secondary,
    BackgroundTransparency = 0.3,
    Position = UDim2.new(1, -120, 0, 10),
    Size = UDim2.new(0, 110, 0, 35),
    Parent = ViewportArea
})
CreateCorner(FrameInfo, 8)

local FrameLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "Frame: 0 / 0",
    TextColor3 = Theme.TextPrimary,
    TextSize = 12,
    Parent = FrameInfo
})

-- ═══════════════════════════════════════════════════════════════════
-- TIMELINE PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════
local TimelineContainer = CreateInstance("Frame", {
    Name = "TimelineContainer",
    BackgroundColor3 = Theme.Timeline,
    Position = UDim2.new(0, 250, 1, -300),
    Size = UDim2.new(1, -500, 0, 250),
    BorderSizePixel = 0,
    Parent = MainContainer
})
CreateCorner(TimelineContainer, 8)

-- Header da Timeline
local TimelineHeader = CreateInstance("Frame", {
    Name = "TimelineHeader",
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 40),
    BorderSizePixel = 0,
    Parent = TimelineContainer
})
CreateCorner(TimelineHeader, 8)

-- Fix cantos inferiores
local TimelineHeaderFix = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 0, 1, -8),
    Size = UDim2.new(1, 0, 0, 8),
    BorderSizePixel = 0,
    Parent = TimelineHeader
})

-- Controles da Timeline
local TimelineControls = CreateInstance("Frame", {
    Name = "TimelineControls",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(0, 300, 1, 0),
    Parent = TimelineHeader
})

local TimelineControlsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 8),
    Parent = TimelineControls
})

-- Botão de início
local GoToStartBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(0, 30, 0, 28),
    Text = "⏮️",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    Parent = TimelineControls
})
CreateCorner(GoToStartBtn, 6)

GoToStartBtn.MouseButton1Click:Connect(function()
    MortalAnimator.CurrentFrame = 0
end)

-- Botão frame anterior
local PrevFrameBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(0, 30, 0, 28),
    Text = "◀️",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    Parent = TimelineControls
})
CreateCorner(PrevFrameBtn, 6)

PrevFrameBtn.MouseButton1Click:Connect(function()
    MortalAnimator.CurrentFrame = math.max(0, MortalAnimator.CurrentFrame - 1)
end)

-- Botão Play grande
local PlayBigBtn = CreateInstance("TextButton", {
    Name = "PlayBig",
    BackgroundColor3 = Theme.Accent,
    Size = UDim2.new(0, 45, 0, 28),
    Text = "▶️",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    Parent = TimelineControls
})
CreateCorner(PlayBigBtn, 6)
CreateGradient(PlayBigBtn, 45)

PlayBigBtn.MouseButton1Click:Connect(function()
    MortalAnimator.IsPlaying = not MortalAnimator.IsPlaying
    PlayBigBtn.Text = MortalAnimator.IsPlaying and "⏸️" or "▶️"
end)

-- Botão próximo frame
local NextFrameBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(0, 30, 0, 28),
    Text = "▶️",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    Parent = TimelineControls
})
CreateCorner(NextFrameBtn, 6)

NextFrameBtn.MouseButton1Click:Connect(function()
    MortalAnimator.CurrentFrame = MortalAnimator.CurrentFrame + 1
end)

-- Botão final
local GoToEndBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(0, 30, 0, 28),
    Text = "⏭️",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    Parent = TimelineControls
})
CreateCorner(GoToEndBtn, 6)

GoToEndBtn.MouseButton1Click:Connect(function()
    MortalAnimator.CurrentFrame = MortalAnimator.TotalFrames
end)

-- Indicador de tempo
local TimeIndicator = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, -60, 0, 0),
    Size = UDim2.new(0, 120, 1, 0),
    Font = Enum.Font.Code,
    Text = "00:00.00",
    TextColor3 = Theme.AccentLight,
    TextSize = 16,
    Parent = TimelineHeader
})

-- Controles de zoom
local ZoomControls = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -150, 0, 0),
    Size = UDim2.new(0, 140, 1, 0),
    Parent = TimelineHeader
})

local ZoomControlsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 5),
    Parent = ZoomControls
})

local ZoomOutBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(0, 28, 0, 24),
    Text = "➖",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    Parent = ZoomControls
})
CreateCorner(ZoomOutBtn, 4)

ZoomOutBtn.MouseButton1Click:Connect(function()
    MortalAnimator.TimelineZoom = math.max(0.25, MortalAnimator.TimelineZoom - 0.25)
end)

local ZoomLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 50, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "100%",
    TextColor3 = Theme.TextSecondary,
    TextSize = 11,
    Parent = ZoomControls
})

local ZoomInBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(0, 28, 0, 24),
    Text = "➕",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    Parent = ZoomControls
})
CreateCorner(ZoomInBtn, 4)

ZoomInBtn.MouseButton1Click:Connect(function()
    MortalAnimator.TimelineZoom = math.min(4, MortalAnimator.TimelineZoom + 0.25)
end)

-- ═══════════════════════════════════════════════════════════════════
-- ÁREA DA TIMELINE (TRACKS)
-- ═══════════════════════════════════════════════════════════════════
local TimelineTracksContainer = CreateInstance("Frame", {
    Name = "TracksContainer",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 40),
    Size = UDim2.new(1, 0, 1, -40),
    ClipsDescendants = true,
    Parent = TimelineContainer
})

-- Labels das tracks (lado esquerdo)
local TrackLabels = CreateInstance("Frame", {
    Name = "TrackLabels",
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(0, 150, 1, 0),
    BorderSizePixel = 0,
    Parent = TimelineTracksContainer
})

local TrackLabelsScroll = CreateInstance("ScrollingFrame", {
    Name = "Scroll",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 0,
    BorderSizePixel = 0,
    Parent = TrackLabels
})

local TrackLabelsLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 0),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = TrackLabelsScroll
})

-- Área de keyframes (lado direito)
local KeyframeArea = CreateInstance("ScrollingFrame", {
    Name = "KeyframeArea",
    BackgroundColor3 = Theme.Timeline,
    Position = UDim2.new(0, 150, 0, 0),
    Size = UDim2.new(1, -150, 1, 0),
    CanvasSize = UDim2.new(0, 2000, 0, 0),
    ScrollBarThickness = 8,
    ScrollBarImageColor3 = Theme.Accent,
    BorderSizePixel = 0,
    Parent = TimelineTracksContainer
})

-- Régua de frames
local FrameRuler = CreateInstance("Frame", {
    Name = "FrameRuler",
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(0, 2000, 0, 25),
    BorderSizePixel = 0,
    Parent = KeyframeArea
})

-- Criar marcadores de frame na régua
local function UpdateFrameRuler()
    for _, child in pairs(FrameRuler:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local frameWidth = 20 * MortalAnimator.TimelineZoom
    local visibleFrames = math.ceil(2000 / frameWidth)
    
    for i = 0, visibleFrames do
        local xPos = i * frameWidth
        
        -- Linha vertical
        local line = CreateInstance("Frame", {
            BackgroundColor3 = Theme.TimelineGrid,
            Position = UDim2.new(0, xPos, 0, 20),
            Size = UDim2.new(0, 1, 0, 5),
            BorderSizePixel = 0,
            Parent = FrameRuler
        })
        
        -- Número do frame (a cada 5 frames)
        if i % 5 == 0 then
            local label = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, xPos - 10, 0, 2),
                Size = UDim2.new(0, 20, 0, 16),
                Font = Enum.Font.Code,
                Text = tostring(i),
                TextColor3 = Theme.TextMuted,
                TextSize = 10,
                Parent = FrameRuler
            })
            line.Size = UDim2.new(0, 1, 0, 8)
            line.BackgroundColor3 = Theme.TextMuted
        end
    end
end

UpdateFrameRuler()

-- Linha indicadora do frame atual (Playhead)
local Playhead = CreateInstance("Frame", {
    Name = "Playhead",
    BackgroundColor3 = Theme.Error,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 2, 1, 0),
    BorderSizePixel = 0,
    ZIndex = 10,
    Parent = KeyframeArea
})

local PlayheadTop = CreateInstance("Frame", {
    Name = "Top",
    BackgroundColor3 = Theme.Error,
    Position = UDim2.new(0.5, -6, 0, 0),
    AnchorPoint = Vector2.new(0, 0),
    Size = UDim2.new(0, 12, 0, 12),
    BorderSizePixel = 0,
    Rotation = 45,
    ZIndex = 10,
    Parent = Playhead
})

-- ═══════════════════════════════════════════════════════════════════
-- SISTEMA DE TRACKS
-- ═══════════════════════════════════════════════════════════════════
local TracksData = {}

local function CreateTrack(name, icon, partRef)
    local trackIndex = #TracksData + 1
    
    -- Label da track
    local trackLabel = CreateInstance("Frame", {
        Name = "Track_" .. name,
        BackgroundColor3 = trackIndex % 2 == 0 and Theme.Tertiary or Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 30),
        BorderSizePixel = 0,
        Parent = TrackLabelsScroll
    })
    
    local expandBtn = CreateInstance("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Text = "▶",
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMuted,
        Parent = trackLabel
    })
    
    local iconLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = icon,
        TextColor3 = Theme.Accent,
        TextSize = 12,
        Parent = trackLabel
    })
    
    local nameLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 48, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = trackLabel
    })
    
    local muteBtn = CreateInstance("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Text = "🔊",
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMuted,
        Parent = trackLabel
    })
    
    -- Linha de keyframes
    local keyframeLine = CreateInstance("Frame", {
        Name = "KeyframeLine_" .. name,
        BackgroundColor3 = trackIndex % 2 == 0 and Color3.fromRGB(25, 25, 35) or Color3.fromRGB(20, 20, 28),
        Position = UDim2.new(0, 0, 0, 25 + (trackIndex - 1) * 30),
        Size = UDim2.new(0, 2000, 0, 30),
        BorderSizePixel = 0,
        Parent = KeyframeArea
    })
    
    -- Linhas de grid na track
    local frameWidth = 20 * MortalAnimator.TimelineZoom
    for i = 0, math.ceil(2000 / frameWidth) do
        local gridLine = CreateInstance("Frame", {
            BackgroundColor3 = Theme.TimelineGrid,
            BackgroundTransparency = 0.7,
            Position = UDim2.new(0, i * frameWidth, 0, 0),
            Size = UDim2.new(0, 1, 1, 0),
            BorderSizePixel = 0,
            Parent = keyframeLine
        })
    end
    
    -- Armazenar dados da track
    TracksData[trackIndex] = {
        Name = name,
        Icon = icon,
        PartRef = partRef,
        Label = trackLabel,
        KeyframeLine = keyframeLine,
        Keyframes = {},
        Muted = false,
        Expanded = false
    }
    
    -- Atualizar canvas size
    TrackLabelsScroll.CanvasSize = UDim2.new(0, 0, 0, trackIndex * 30)
    
    return trackIndex
end

-- Função para adicionar keyframe
local function AddKeyframe(trackIndex, frame, data)
    local track = TracksData[trackIndex]
    if not track then return end
    
    local frameWidth = 20 * MortalAnimator.TimelineZoom
    local xPos = frame * frameWidth
    
    -- Criar visual do keyframe
    local keyframe = CreateInstance("Frame", {
        Name = "Keyframe_" .. frame,
        BackgroundColor3 = Theme.KeyframeNormal,
        Position = UDim2.new(0, xPos - 6, 0.5, -6),
        Size = UDim2.new(0, 12, 0, 12),
        Rotation = 45,
        BorderSizePixel = 0,
        Parent = track.KeyframeLine
    })
    
    local keyframeBtn = CreateInstance("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = keyframe
    })
    
    keyframeBtn.MouseEnter:Connect(function()
        Tween(keyframe, {BackgroundColor3 = Theme.KeyframeSelected, Size = UDim2.new(0, 14, 0, 14)}, 0.15)
    end)
    
    keyframeBtn.MouseLeave:Connect(function()
        Tween(keyframe, {BackgroundColor3 = Theme.KeyframeNormal, Size = UDim2.new(0, 12, 0, 12)}, 0.15)
    end)
    
    -- Armazenar keyframe
    track.Keyframes[frame] = {
        Frame = frame,
        Data = data,
        Visual = keyframe
    }
    
    return keyframe
end

print("✅ Mortal Animator - Parte 3 carregada com sucesso!")
print("📦 Aguardando próxima parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 4: SISTEMA DE SELEÇÃO DE RIG/OBJETO
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- MENU DE SELEÇÃO DE RIG/OBJETO
-- ═══════════════════════════════════════════════════════════════════
local SelectionMenu = CreateInstance("Frame", {
    Name = "SelectionMenu",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 500, 0, 450),
    Visible = false,
    ZIndex = 50,
    Parent = ScreenGui
})
CreateCorner(SelectionMenu, 16)
CreateStroke(SelectionMenu, Theme.Accent, 2, 0.3)
CreateShadow(SelectionMenu, 50, 0.4)

local SelectionHeader = CreateInstance("Frame", {
    Name = "Header",
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 50),
    BorderSizePixel = 0,
    ZIndex = 51,
    Parent = SelectionMenu
})
CreateCorner(SelectionHeader, 16)

local SelectionHeaderFix = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 0, 1, -16),
    Size = UDim2.new(1, 0, 0, 16),
    BorderSizePixel = 0,
    ZIndex = 51,
    Parent = SelectionHeader
})

local SelectionTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 0),
    Size = UDim2.new(1, -60, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "🎯 Selecionar Objeto para Animar",
    TextColor3 = Theme.TextPrimary,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 51,
    Parent = SelectionHeader
})

local CloseSelectionBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(1, -45, 0.5, -15),
    Size = UDim2.new(0, 30, 0, 30),
    Text = "✕",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    ZIndex = 51,
    Parent = SelectionHeader
})
CreateCorner(CloseSelectionBtn, 6)

CloseSelectionBtn.MouseButton1Click:Connect(function()
    Tween(SelectionMenu, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.3)
    SelectionMenu.Visible = false
end)

-- Tabs de seleção
local SelectionTabs = CreateInstance("Frame", {
    Name = "Tabs",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 55),
    Size = UDim2.new(1, -20, 0, 35),
    ZIndex = 51,
    Parent = SelectionMenu
})

local TabsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 5),
    Parent = SelectionTabs
})

local CurrentSelectionTab = "Rigs"
local TabButtons = {}

local function CreateSelectionTab(name, icon, isDefault)
    local tab = CreateInstance("TextButton", {
        Name = name,
        BackgroundColor3 = isDefault and Theme.Accent or Theme.Tertiary,
        Size = UDim2.new(0, 90, 0, 32),
        Text = icon .. " " .. name,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextColor3 = isDefault and Theme.TextPrimary or Theme.TextSecondary,
        AutoButtonColor = false,
        ZIndex = 51,
        Parent = SelectionTabs
    })
    CreateCorner(tab, 8)
    
    TabButtons[name] = tab
    
    tab.MouseButton1Click:Connect(function()
        CurrentSelectionTab = name
        for tabName, tabBtn in pairs(TabButtons) do
            if tabName == name then
                Tween(tabBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
                Tween(tabBtn, {TextColor3 = Theme.TextPrimary}, 0.2)
            else
                Tween(tabBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                Tween(tabBtn, {TextColor3 = Theme.TextSecondary}, 0.2)
            end
        end
        RefreshSelectionList()
    end)
    
    return tab
end

CreateSelectionTab("Rigs", "🦴", true)
CreateSelectionTab("Models", "📦", false)
CreateSelectionTab("Parts", "🧱", false)
CreateSelectionTab("Tools", "🔧", false)
CreateSelectionTab("Player", "👤", false)

-- Lista de seleção
local SelectionScroll = CreateInstance("ScrollingFrame", {
    Name = "SelectionScroll",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 10, 0, 100),
    Size = UDim2.new(1, -20, 1, -160),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 6,
    ScrollBarImageColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 51,
    Parent = SelectionMenu
})
CreateCorner(SelectionScroll, 8)

local SelectionListLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.Name,
    Parent = SelectionScroll
})

CreatePadding(SelectionScroll, 8, 8, 8, 8)

-- Função para criar item de seleção
local function CreateSelectionItem(name, className, icon, objectRef)
    local item = CreateInstance("TextButton", {
        Name = name,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 50),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 52,
        Parent = SelectionScroll
    })
    CreateCorner(item, 8)
    
    local iconLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = icon,
        TextColor3 = Theme.Accent,
        TextSize = 20,
        ZIndex = 52,
        Parent = item
    })
    
    local nameLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55, 0, 8),
        Size = UDim2.new(1, -100, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 52,
        Parent = item
    })
    
    local classLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55, 0, 28),
        Size = UDim2.new(1, -100, 0, 14),
        Font = Enum.Font.Gotham,
        Text = className,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 52,
        Parent = item
    })
    
    local selectBtn = CreateInstance("TextButton", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(1, -75, 0.5, -12),
        Size = UDim2.new(0, 60, 0, 24),
        Text = "Selecionar",
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        AutoButtonColor = false,
        ZIndex = 52,
        Parent = item
    })
    CreateCorner(selectBtn, 6)
    
    item.MouseEnter:Connect(function()
        Tween(item, {BackgroundColor3 = Theme.Secondary}, 0.15)
    end)
    
    item.MouseLeave:Connect(function()
        Tween(item, {BackgroundColor3 = Theme.Tertiary}, 0.15)
    end)
    
    selectBtn.MouseButton1Click:Connect(function()
        SelectObject(objectRef)
        Tween(SelectionMenu, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        SelectionMenu.Visible = false
    end)
    
    return item
end

-- Função para atualizar lista de seleção
function RefreshSelectionList()
    -- Limpar lista atual
    for _, child in pairs(SelectionScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local items = {}
    
    if CurrentSelectionTab == "Rigs" then
        -- Buscar rigs (Humanoids)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                local rigType = "Custom Rig"
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if humanoid.RigType == Enum.HumanoidRigType.R6 then
                        rigType = "R6 Rig"
                    elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
                        rigType = "R15 Rig"
                    end
                end
                table.insert(items, {Name = obj.Name, Class = rigType, Icon = "🦴", Ref = obj})
            end
        end
        
    elseif CurrentSelectionTab == "Models" then
        -- Buscar modelos
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid") then
                table.insert(items, {Name = obj.Name, Class = "Model", Icon = "📦", Ref = obj})
            end
        end
        
    elseif CurrentSelectionTab == "Parts" then
        -- Buscar parts
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Parent:IsA("Model") then
                table.insert(items, {Name = obj.Name, Class = obj.ClassName, Icon = "🧱", Ref = obj})
            end
        end
        
    elseif CurrentSelectionTab == "Tools" then
        -- Buscar tools
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") then
                table.insert(items, {Name = obj.Name, Class = "Tool", Icon = "🔧", Ref = obj})
            end
        end
        -- Também buscar no ReplicatedStorage
        pcall(function()
            for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if obj:IsA("Tool") then
                    table.insert(items, {Name = obj.Name, Class = "Tool (Storage)", Icon = "🔧", Ref = obj})
                end
            end
        end)
        
    elseif CurrentSelectionTab == "Player" then
        -- Player atual
        if Player.Character then
            table.insert(items, {
                Name = Player.Name .. " (Você)", 
                Class = "Player Character", 
                Icon = "👤", 
                Ref = Player.Character
            })
        end
        -- Outros players
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character then
                table.insert(items, {
                    Name = otherPlayer.Name, 
                    Class = "Player Character", 
                    Icon = "👥", 
                    Ref = otherPlayer.Character
                })
            end
        end
    end
    
    -- Criar itens
    for _, itemData in ipairs(items) do
        CreateSelectionItem(itemData.Name, itemData.Class, itemData.Icon, itemData.Ref)
    end
    
    -- Atualizar canvas size
    SelectionScroll.CanvasSize = UDim2.new(0, 0, 0, #items * 55 + 20)
    
    if #items == 0 then
        local noItems = CreateInstance("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 50),
            Font = Enum.Font.Gotham,
            Text = "Nenhum item encontrado nesta categoria",
            TextColor3 = Theme.TextMuted,
            TextSize = 13,
            ZIndex = 52,
            Parent = SelectionScroll
        })
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- FUNÇÃO PRINCIPAL DE SELEÇÃO DE OBJETO
-- ═══════════════════════════════════════════════════════════════════
function SelectObject(object)
    if not object then return end
    
    MortalAnimator.CurrentObject = object
    MortalAnimator.AnimationData = {}
    MortalAnimator.Keyframes = {}
    
    -- Limpar tracks existentes
    for _, child in pairs(TrackLabelsScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    for _, child in pairs(KeyframeArea:GetChildren()) do
        if child.Name:find("KeyframeLine_") then
            child:Destroy()
        end
    end
    TracksData = {}
    
    -- Limpar hierarquia
    for _, child in pairs(HierarchyScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Detectar tipo de objeto e criar tracks apropriadas
    local humanoid = object:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        -- É um rig
        MortalAnimator.CurrentRig = object
        local rigType = humanoid.RigType
        
        if rigType == Enum.HumanoidRigType.R6 then
            -- R6 Parts
            local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}
            for i, partName in ipairs(r6Parts) do
                local part = object:FindFirstChild(partName)
                if part then
                    CreateHierarchyItem(partName, "🦴", 0, part)
                    CreateTrack(partName, "🦴", part)
                end
            end
            
        elseif rigType == Enum.HumanoidRigType.R15 then
            -- R15 Parts
            local r15Parts = {
                "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart",
                "LeftUpperArm", "LeftLowerArm", "LeftHand",
                "RightUpperArm", "RightLowerArm", "RightHand",
                "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                "RightUpperLeg", "RightLowerLeg", "RightFoot"
            }
            for i, partName in ipairs(r15Parts) do
                local part = object:FindFirstChild(partName)
                if part then
                    local depth = 0
                    if partName:find("Upper") then depth = 1 end
                    if partName:find("Lower") or partName:find("Hand") or partName:find("Foot") then depth = 2 end
                    CreateHierarchyItem(partName, "🦴", depth, part)
                    CreateTrack(partName, "🦴", part)
                end
            end
        else
            -- Custom Rig - buscar todas as partes
            local function AddPartRecursive(part, depth)
                if part:IsA("BasePart") then
                    CreateHierarchyItem(part.Name, "🦴", depth, part)
                    CreateTrack(part.Name, "🦴", part)
                end
                for _, child in pairs(part:GetChildren()) do
                    if child:IsA("BasePart") or child:IsA("Model") then
                        AddPartRecursive(child, depth + 1)
                    end
                end
            end
            AddPartRecursive(object, 0)
        end
        
        -- Adicionar accessories (chapéus, etc)
        for _, accessory in pairs(object:GetChildren()) do
            if accessory:IsA("Accessory") then
                local handle = accessory:FindFirstChild("Handle")
                if handle then
                    CreateHierarchyItem("🎩 " .. accessory.Name, "👒", 1, handle)
                    CreateTrack(accessory.Name, "👒", handle)
                end
            end
        end
        
        CreateNotification("Rig Selecionado", object.Name .. " carregado com sucesso!", "success", 3)
        
    elseif object:IsA("Model") then
        -- É um modelo sem humanoid
        local function AddPartRecursive(part, depth)
            if part:IsA("BasePart") then
                CreateHierarchyItem(part.Name, "🧱", depth, part)
                CreateTrack(part.Name, "🧱", part)
            end
            for _, child in pairs(part:GetChildren()) do
                AddPartRecursive(child, depth + 1)
            end
        end
        AddPartRecursive(object, 0)
        
        CreateNotification("Modelo Selecionado", object.Name .. " carregado!", "success", 3)
        
    elseif object:IsA("BasePart") then
        -- É uma parte única
        CreateHierarchyItem(object.Name, "🧱", 0, object)
        CreateTrack(object.Name, "🧱", object)
        
        CreateNotification("Parte Selecionada", object.Name .. " carregada!", "success", 3)
        
    elseif object:IsA("Tool") then
        -- É uma tool
        for _, part in pairs(object:GetDescendants()) do
            if part:IsA("BasePart") then
                CreateHierarchyItem(part.Name, "🔧", 0, part)
                CreateTrack(part.Name, "🔧", part)
            end
        end
        
        CreateNotification("Tool Selecionada", object.Name .. " carregada!", "success", 3)
    end
    
    -- Atualizar UI
    LeftPanelTitle.Text = "🦴 " .. object.Name
    
    -- Clonar para viewport preview
    UpdateViewportPreview()
end

-- ═══════════════════════════════════════════════════════════════════
-- ATUALIZAR PREVIEW NO VIEWPORT
-- ═══════════════════════════════════════════════════════════════════
function UpdateViewportPreview()
    -- Limpar viewport
    for _, child in pairs(ViewportFrame:GetChildren()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            child:Destroy()
        end
    end
    
    if MortalAnimator.CurrentObject then
        local clone = MortalAnimator.CurrentObject:Clone()
        
        -- Remover scripts
        for _, script in pairs(clone:GetDescendants()) do
            if script:IsA("Script") or script:IsA("LocalScript") or script:IsA("ModuleScript") then
                script:Destroy()
            end
        end
        
        clone.Parent = ViewportFrame
        
        -- Posicionar camera
        local cf, size = clone:GetBoundingBox()
        local maxSize = math.max(size.X, size.Y, size.Z)
        ViewportCamera.CFrame = CFrame.new(cf.Position + Vector3.new(maxSize * 1.5, maxSize, maxSize * 1.5), cf.Position)
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- BOTÃO DE SELEÇÃO NA TOOLBAR
-- ═══════════════════════════════════════════════════════════════════
local SelectObjectBtn = CreateInstance("TextButton", {
    Name = "SelectObject",
    BackgroundColor3 = Theme.Accent,
    Position = UDim2.new(0, 15, 0, 55),
    Size = UDim2.new(0, 220, 0, 35),
    Text = "🎯 Selecionar Objeto",
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    Parent = LeftPanel
})
CreateCorner(SelectObjectBtn, 8)
CreateGradient(SelectObjectBtn, 90)

-- Mover hierarquia para baixo
HierarchyScroll.Position = UDim2.new(0, 5, 0, 140)
HierarchyScroll.Size = UDim2.new(1, -10, 1, -145)
SearchContainer.Position = UDim2.new(0, 10, 0, 95)

SelectObjectBtn.MouseEnter:Connect(function()
    Tween(SelectObjectBtn, {Size = UDim2.new(0, 222, 0, 37)}, 0.15)
end)

SelectObjectBtn.MouseLeave:Connect(function()
    Tween(SelectObjectBtn, {Size = UDim2.new(0, 220, 0, 35)}, 0.15)
end)

SelectObjectBtn.MouseButton1Click:Connect(function()
    SelectionMenu.Visible = true
    SelectionMenu.Size = UDim2.new(0, 0, 0, 0)
    Tween(SelectionMenu, {Size = UDim2.new(0, 500, 0, 450)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    RefreshSelectionList()
end)

-- Botão de refresh
local RefreshBtn = CreateInstance("TextButton", {
    Name = "Refresh",
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(1, -65, 1, -45),
    Size = UDim2.new(0, 50, 0, 30),
    Text = "🔄",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    ZIndex = 51,
    Parent = SelectionMenu
})
CreateCorner(RefreshBtn, 6)

RefreshBtn.MouseButton1Click:Connect(function()
    RefreshSelectionList()
    CreateNotification("Lista Atualizada", "Objetos recarregados", "success", 2)
end)

print("✅ Mortal Animator - Parte 4 carregada com sucesso!")
print("📦 Aguardando próxima parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 5: SISTEMA DE KEYFRAMES E INTERPOLAÇÃO
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- ESTRUTURA DE DADOS PARA KEYFRAMES
-- ═══════════════════════════════════════════════════════════════════
local KeyframeSystem = {
    Data = {},
    SelectedKeyframes = {},
    ClipboardKeyframes = {},
    CurrentEasing = {
        Style = Enum.EasingStyle.Quad,
        Direction = Enum.EasingDirection.InOut
    }
}

-- Easing Styles disponíveis
local EasingStyles = {
    {Name = "Linear", Style = Enum.EasingStyle.Linear, Icon = "📏"},
    {Name = "Quad", Style = Enum.EasingStyle.Quad, Icon = "📈"},
    {Name = "Cubic", Style = Enum.EasingStyle.Cubic, Icon = "📊"},
    {Name = "Quart", Style = Enum.EasingStyle.Quart, Icon = "⚡"},
    {Name = "Quint", Style = Enum.EasingStyle.Quint, Icon = "🚀"},
    {Name = "Sine", Style = Enum.EasingStyle.Sine, Icon = "🌊"},
    {Name = "Expo", Style = Enum.EasingStyle.Exponential, Icon = "💥"},
    {Name = "Circ", Style = Enum.EasingStyle.Circular, Icon = "⭕"},
    {Name = "Elastic", Style = Enum.EasingStyle.Elastic, Icon = "🎯"},
    {Name = "Back", Style = Enum.EasingStyle.Back, Icon = "↩️"},
    {Name = "Bounce", Style = Enum.EasingStyle.Bounce, Icon = "🏀"}
}

local EasingDirections = {
    {Name = "In", Direction = Enum.EasingDirection.In},
    {Name = "Out", Direction = Enum.EasingDirection.Out},
    {Name = "InOut", Direction = Enum.EasingDirection.InOut}
}

-- ═══════════════════════════════════════════════════════════════════
-- FUNÇÕES DE INTERPOLAÇÃO CUSTOMIZADAS
-- ═══════════════════════════════════════════════════════════════════
local function InterpolateCFrame(cf1, cf2, alpha, easingStyle, easingDirection)
    -- Aplicar easing
    local easedAlpha = TweenService:GetValue(alpha, easingStyle, easingDirection)
    
    -- Interpolar posição
    local pos = cf1.Position:Lerp(cf2.Position, easedAlpha)
    
    -- Interpolar rotação usando quaternions para suavidade
    local q1 = {cf1:ToOrientation()}
    local q2 = {cf2:ToOrientation()}
    
    local rx = Lerp(q1[1], q2[1], easedAlpha)
    local ry = Lerp(q1[2], q2[2], easedAlpha)
    local rz = Lerp(q1[3], q2[3], easedAlpha)
    
    return CFrame.new(pos) * CFrame.Angles(rx, ry, rz)
end

local function InterpolateVector3(v1, v2, alpha, easingStyle, easingDirection)
    local easedAlpha = TweenService:GetValue(alpha, easingStyle, easingDirection)
    return v1:Lerp(v2, easedAlpha)
end

local function InterpolateNumber(n1, n2, alpha, easingStyle, easingDirection)
    local easedAlpha = TweenService:GetValue(alpha, easingStyle, easingDirection)
    return Lerp(n1, n2, easedAlpha)
end

local function InterpolateColor(c1, c2, alpha, easingStyle, easingDirection)
    local easedAlpha = TweenService:GetValue(alpha, easingStyle, easingDirection)
    return LerpColor(c1, c2, easedAlpha)
end

-- ═══════════════════════════════════════════════════════════════════
-- ADICIONAR KEYFRAME COMPLETO
-- ═══════════════════════════════════════════════════════════════════
function AddKeyframeToTrack(trackIndex, frame, customData)
    local track = TracksData[trackIndex]
    if not track or not track.PartRef then return end
    
    local part = track.PartRef
    
    -- Capturar estado atual da parte
    local keyframeData = customData or {
        Frame = frame,
        CFrame = part.CFrame,
        Size = part.Size,
        Transparency = part.Transparency,
        Color = part.Color,
        EasingStyle = KeyframeSystem.CurrentEasing.Style,
        EasingDirection = KeyframeSystem.CurrentEasing.Direction,
        Properties = {}
    }
    
    -- Capturar propriedades adicionais
    pcall(function()
        keyframeData.Properties.CanCollide = part.CanCollide
        keyframeData.Properties.Anchored = part.Anchored
        keyframeData.Properties.Material = part.Material
    end)
    
    -- Verificar se já existe keyframe nesse frame
    if track.Keyframes[frame] then
        -- Atualizar keyframe existente
        track.Keyframes[frame].Data = keyframeData
        CreateNotification("Keyframe Atualizado", "Frame " .. frame .. " atualizado", "success", 2)
    else
        -- Criar novo keyframe visual
        local frameWidth = 20 * MortalAnimator.TimelineZoom
        local xPos = frame * frameWidth
        
        local keyframeVisual = CreateInstance("Frame", {
            Name = "Keyframe_" .. frame,
            BackgroundColor3 = Theme.KeyframeNormal,
            Position = UDim2.new(0, xPos - 6, 0.5, -6),
            Size = UDim2.new(0, 12, 0, 12),
            Rotation = 45,
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = track.KeyframeLine
        })
        CreateCorner(keyframeVisual, 2)
        
        -- Adicionar interatividade
        local keyframeBtn = CreateInstance("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 10, 1, 10),
            Position = UDim2.new(0, -5, 0, -5),
            Text = "",
            ZIndex = 6,
            Parent = keyframeVisual
        })
        
        local isSelected = false
        
        keyframeBtn.MouseEnter:Connect(function()
            Tween(keyframeVisual, {
                BackgroundColor3 = Theme.KeyframeSelected, 
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, xPos - 7, 0.5, -7)
            }, 0.1)
        end)
        
        keyframeBtn.MouseLeave:Connect(function()
            if not isSelected then
                Tween(keyframeVisual, {
                    BackgroundColor3 = Theme.KeyframeNormal, 
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0, xPos - 6, 0.5, -6)
                }, 0.1)
            end
        end)
        
        keyframeBtn.MouseButton1Click:Connect(function()
            isSelected = not isSelected
            if isSelected then
                table.insert(KeyframeSystem.SelectedKeyframes, {
                    TrackIndex = trackIndex,
                    Frame = frame
                })
                keyframeVisual.BackgroundColor3 = Theme.KeyframeSelected
            else
                for i, sel in ipairs(KeyframeSystem.SelectedKeyframes) do
                    if sel.TrackIndex == trackIndex and sel.Frame == frame then
                        table.remove(KeyframeSystem.SelectedKeyframes, i)
                        break
                    end
                end
                keyframeVisual.BackgroundColor3 = Theme.KeyframeNormal
            end
        end)
        
        -- Duplo clique para editar
        local lastClick = 0
        keyframeBtn.MouseButton1Click:Connect(function()
            local now = tick()
            if now - lastClick < 0.3 then
                -- Duplo clique - ir para o frame
                MortalAnimator.CurrentFrame = frame
                UpdatePlayhead()
            end
            lastClick = now
        end)
        
        -- Armazenar
        track.Keyframes[frame] = {
            Data = keyframeData,
            Visual = keyframeVisual,
            Selected = false
        }
        
        CreateNotification("Keyframe Adicionado", track.Name .. " - Frame " .. frame, "success", 2)
    end
    
    -- Adicionar ao undo stack
    table.insert(MortalAnimator.UndoStack, {
        Type = "AddKeyframe",
        TrackIndex = trackIndex,
        Frame = frame,
        Data = DeepCopy(keyframeData)
    })
    
    return track.Keyframes[frame]
end

-- ═══════════════════════════════════════════════════════════════════
-- REMOVER KEYFRAME
-- ═══════════════════════════════════════════════════════════════════
function RemoveKeyframe(trackIndex, frame)
    local track = TracksData[trackIndex]
    if not track or not track.Keyframes[frame] then return end
    
    -- Adicionar ao undo stack antes de remover
    table.insert(MortalAnimator.UndoStack, {
        Type = "RemoveKeyframe",
        TrackIndex = trackIndex,
        Frame = frame,
        Data = DeepCopy(track.Keyframes[frame].Data)
    })
    
    -- Remover visual
    if track.Keyframes[frame].Visual then
        track.Keyframes[frame].Visual:Destroy()
    end
    
    -- Remover dados
    track.Keyframes[frame] = nil
    
    CreateNotification("Keyframe Removido", track.Name .. " - Frame " .. frame, "warning", 2)
end

-- ═══════════════════════════════════════════════════════════════════
-- MOVER KEYFRAME
-- ═══════════════════════════════════════════════════════════════════
function MoveKeyframe(trackIndex, fromFrame, toFrame)
    local track = TracksData[trackIndex]
    if not track or not track.Keyframes[fromFrame] then return end
    
    local keyframeData = track.Keyframes[fromFrame]
    
    -- Remover do frame antigo
    RemoveKeyframe(trackIndex, fromFrame)
    
    -- Adicionar no novo frame
    keyframeData.Data.Frame = toFrame
    AddKeyframeToTrack(trackIndex, toFrame, keyframeData.Data)
end

-- ═══════════════════════════════════════════════════════════════════
-- COPIAR/COLAR KEYFRAMES
-- ═══════════════════════════════════════════════════════════════════
function CopySelectedKeyframes()
    KeyframeSystem.ClipboardKeyframes = {}
    
    for _, sel in ipairs(KeyframeSystem.SelectedKeyframes) do
        local track = TracksData[sel.TrackIndex]
        if track and track.Keyframes[sel.Frame] then
            table.insert(KeyframeSystem.ClipboardKeyframes, {
                TrackIndex = sel.TrackIndex,
                TrackName = track.Name,
                Frame = sel.Frame,
                Data = DeepCopy(track.Keyframes[sel.Frame].Data)
            })
        end
    end
    
    CreateNotification("Copiado", #KeyframeSystem.ClipboardKeyframes .. " keyframes copiados", "success", 2)
end

function PasteKeyframes(offsetFrame)
    offsetFrame = offsetFrame or MortalAnimator.CurrentFrame
    
    local minFrame = math.huge
    for _, kf in ipairs(KeyframeSystem.ClipboardKeyframes) do
        minFrame = math.min(minFrame, kf.Frame)
    end
    
    for _, kf in ipairs(KeyframeSystem.ClipboardKeyframes) do
        local newFrame = offsetFrame + (kf.Frame - minFrame)
        local newData = DeepCopy(kf.Data)
        newData.Frame = newFrame
        AddKeyframeToTrack(kf.TrackIndex, newFrame, newData)
    end
    
    CreateNotification("Colado", #KeyframeSystem.ClipboardKeyframes .. " keyframes colados", "success", 2)
end

-- ═══════════════════════════════════════════════════════════════════
-- UNDO/REDO
-- ═══════════════════════════════════════════════════════════════════
function Undo()
    if #MortalAnimator.UndoStack == 0 then
        CreateNotification("Undo", "Nada para desfazer", "warning", 2)
        return
    end
    
    local action = table.remove(MortalAnimator.UndoStack)
    table.insert(MortalAnimator.RedoStack, action)
    
    if action.Type == "AddKeyframe" then
        RemoveKeyframe(action.TrackIndex, action.Frame)
    elseif action.Type == "RemoveKeyframe" then
        AddKeyframeToTrack(action.TrackIndex, action.Frame, action.Data)
    end
    
    CreateNotification("Desfeito", action.Type, "success", 2)
end

function Redo()
    if #MortalAnimator.RedoStack == 0 then
        CreateNotification("Redo", "Nada para refazer", "warning", 2)
        return
    end
    
    local action = table.remove(MortalAnimator.RedoStack)
    table.insert(MortalAnimator.UndoStack, action)
    
    if action.Type == "AddKeyframe" then
        AddKeyframeToTrack(action.TrackIndex, action.Frame, action.Data)
    elseif action.Type == "RemoveKeyframe" then
        RemoveKeyframe(action.TrackIndex, action.Frame)
    end
    
    CreateNotification("Refeito", action.Type, "success", 2)
end

-- ═══════════════════════════════════════════════════════════════════
-- SELETOR DE EASING
-- ═══════════════════════════════════════════════════════════════════
local EasingSelector = CreateInstance("Frame", {
    Name = "EasingSelector",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 400, 0, 350),
    Visible = false,
    ZIndex = 60,
    Parent = ScreenGui
})
CreateCorner(EasingSelector, 12)
CreateStroke(EasingSelector, Theme.Accent, 2, 0.3)
CreateShadow(EasingSelector, 40, 0.4)

local EasingSelectorHeader = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 45),
    BorderSizePixel = 0,
    ZIndex = 61,
    Parent = EasingSelector
})
CreateCorner(EasingSelectorHeader, 12)

local EasingSelectorTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(1, -50, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "🎯 Selecionar Easing",
    TextColor3 = Theme.TextPrimary,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 61,
    Parent = EasingSelectorHeader
})

local CloseEasingBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(1, -40, 0.5, -12),
    Size = UDim2.new(0, 25, 0, 25),
    Text = "✕",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    ZIndex = 61,
    Parent = EasingSelectorHeader
})
CreateCorner(CloseEasingBtn, 4)

CloseEasingBtn.MouseButton1Click:Connect(function()
    Tween(EasingSelector, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
    task.wait(0.2)
    EasingSelector.Visible = false
end)

-- Grid de Easing Styles
local EasingGrid = CreateInstance("ScrollingFrame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 55),
    Size = UDim2.new(1, -20, 0, 180),
    CanvasSize = UDim2.new(0, 0, 0, 200),
    ScrollBarThickness = 4,
    ZIndex = 61,
    Parent = EasingSelector
})

local EasingGridLayout = CreateInstance("UIGridLayout", {
    CellSize = UDim2.new(0, 85, 0, 40),
    CellPadding = UDim2.new(0, 8, 0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = EasingGrid
})

for _, easing in ipairs(EasingStyles) do
    local btn = CreateInstance("TextButton", {
        Name = easing.Name,
        BackgroundColor3 = Theme.Tertiary,
        Text = easing.Icon .. " " .. easing.Name,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextSecondary,
        AutoButtonColor = false,
        ZIndex = 62,
        Parent = EasingGrid
    })
    CreateCorner(btn, 6)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        KeyframeSystem.CurrentEasing.Style = easing.Style
        CreateNotification("Easing", easing.Name .. " selecionado", "success", 2)
    end)
end

-- Direction buttons
local DirectionFrame = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 245),
    Size = UDim2.new(1, -20, 0, 40),
    ZIndex = 61,
    Parent = EasingSelector
})

local DirectionLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 10),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Parent = DirectionFrame
})

for _, dir in ipairs(EasingDirections) do
    local btn = CreateInstance("TextButton", {
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 100, 0, 35),
        Text = dir.Name,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextSecondary,
        ZIndex = 62,
        Parent = DirectionFrame
    })
    CreateCorner(btn, 6)
    
    btn.MouseButton1Click:Connect(function()
        KeyframeSystem.CurrentEasing.Direction = dir.Direction
        CreateNotification("Direction", dir.Name .. " selecionado", "success", 2)
    end)
end

-- Apply Button
local ApplyEasingBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Accent,
    Position = UDim2.new(0.5, -60, 1, -50),
    Size = UDim2.new(0, 120, 0, 35),
    Text = "✅ Aplicar",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    ZIndex = 62,
    Parent = EasingSelector
})
CreateCorner(ApplyEasingBtn, 8)
CreateGradient(ApplyEasingBtn, 45)

ApplyEasingBtn.MouseButton1Click:Connect(function()
    -- Aplicar easing aos keyframes selecionados
    for _, sel in ipairs(KeyframeSystem.SelectedKeyframes) do
        local track = TracksData[sel.TrackIndex]
        if track and track.Keyframes[sel.Frame] then
            track.Keyframes[sel.Frame].Data.EasingStyle = KeyframeSystem.CurrentEasing.Style
            track.Keyframes[sel.Frame].Data.EasingDirection = KeyframeSystem.CurrentEasing.Direction
        end
    end
    CreateNotification("Easing Aplicado", "Aplicado a " .. #KeyframeSystem.SelectedKeyframes .. " keyframes", "success", 3)
    
    Tween(EasingSelector, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
    task.wait(0.2)
    EasingSelector.Visible = false
end)

-- Botão para abrir easing selector
local EasingBtn = CreateToolbarButton("Easing", "📈", "Easing Curve (E)", function()
    EasingSelector.Visible = true
    EasingSelector.Size = UDim2.new(0, 0, 0, 0)
    Tween(EasingSelector, {Size = UDim2.new(0, 400, 0, 350)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

print("✅ Mortal Animator - Parte 5 carregada com sucesso!")
print("📦 Aguardando próxima parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 6: SISTEMA DE PLAYBACK E ANIMAÇÃO
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- VARIÁVEIS DE PLAYBACK
-- ═══════════════════════════════════════════════════════════════════
local PlaybackSystem = {
    IsPlaying = false,
    IsPaused = false,
    CurrentFrame = 0,
    LastFrameTime = 0,
    FrameAccumulator = 0,
    OriginalStates = {},
    PreviewStates = {}
}

-- ═══════════════════════════════════════════════════════════════════
-- ATUALIZAR PLAYHEAD
-- ═══════════════════════════════════════════════════════════════════
function UpdatePlayhead()
    local frameWidth = 20 * MortalAnimator.TimelineZoom
    local xPos = MortalAnimator.CurrentFrame * frameWidth
    
    Tween(Playhead, {Position = UDim2.new(0, xPos, 0, 0)}, 0.05, Enum.EasingStyle.Linear)
    
    -- Atualizar labels
    FrameLabel.Text = "Frame: " .. MortalAnimator.CurrentFrame .. " / " .. MortalAnimator.TotalFrames
    TimeIndicator.Text = FormatTime(MortalAnimator.CurrentFrame, MortalAnimator.FPS)
    
    -- Auto-scroll da timeline se necessário
    local scrollPos = KeyframeArea.CanvasPosition.X
    local visibleWidth = KeyframeArea.AbsoluteSize.X
    
    if xPos > scrollPos + visibleWidth - 50 then
        KeyframeArea.CanvasPosition = Vector2.new(xPos - visibleWidth + 100, 0)
    elseif xPos < scrollPos + 50 then
        KeyframeArea.CanvasPosition = Vector2.new(math.max(0, xPos - 100), 0)
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- SALVAR ESTADOS ORIGINAIS
-- ═══════════════════════════════════════════════════════════════════
function SaveOriginalStates()
    PlaybackSystem.OriginalStates = {}
    
    for trackIndex, track in pairs(TracksData) do
        if track.PartRef and track.PartRef:IsA("BasePart") then
            PlaybackSystem.OriginalStates[trackIndex] = {
                CFrame = track.PartRef.CFrame,
                Size = track.PartRef.Size,
                Transparency = track.PartRef.Transparency,
                Color = track.PartRef.Color
            }
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- RESTAURAR ESTADOS ORIGINAIS
-- ═══════════════════════════════════════════════════════════════════
function RestoreOriginalStates()
    for trackIndex, state in pairs(PlaybackSystem.OriginalStates) do
        local track = TracksData[trackIndex]
        if track and track.PartRef and track.PartRef:IsA("BasePart") then
            track.PartRef.CFrame = state.CFrame
            track.PartRef.Size = state.Size
            track.PartRef.Transparency = state.Transparency
            track.PartRef.Color = state.Color
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- OBTER KEYFRAMES ADJACENTES
-- ═══════════════════════════════════════════════════════════════════
function GetAdjacentKeyframes(track, frame)
    local prevKeyframe = nil
    local nextKeyframe = nil
    local prevFrame = -1
    local nextFrame = math.huge
    
    for kfFrame, kfData in pairs(track.Keyframes) do
        if kfFrame <= frame and kfFrame > prevFrame then
            prevFrame = kfFrame
            prevKeyframe = kfData
        end
        if kfFrame > frame and kfFrame < nextFrame then
            nextFrame = kfFrame
            nextKeyframe = kfData
        end
    end
    
    return prevKeyframe, nextKeyframe, prevFrame, nextFrame
end

-- ═══════════════════════════════════════════════════════════════════
-- INTERPOLAR FRAME
-- ═══════════════════════════════════════════════════════════════════
function InterpolateFrame(trackIndex, frame)
    local track = TracksData[trackIndex]
    if not track or not track.PartRef then return end
    
    local part = track.PartRef
    if not part:IsA("BasePart") then return end
    
    -- Verificar se existe keyframe exato
    if track.Keyframes[frame] then
        local kf = track.Keyframes[frame].Data
        part.CFrame = kf.CFrame
        if kf.Size then part.Size = kf.Size end
        if kf.Transparency then part.Transparency = kf.Transparency end
        if kf.Color then part.Color = kf.Color end
        return
    end
    
    -- Obter keyframes adjacentes
    local prevKf, nextKf, prevFrame, nextFrame = GetAdjacentKeyframes(track, frame)
    
    if prevKf and nextKf then
        -- Interpolar entre os dois keyframes
        local totalFrames = nextFrame - prevFrame
        local currentOffset = frame - prevFrame
        local alpha = currentOffset / totalFrames
        
        local easingStyle = nextKf.Data.EasingStyle or Enum.EasingStyle.Quad
        local easingDir = nextKf.Data.EasingDirection or Enum.EasingDirection.InOut
        
        -- Interpolar CFrame
        local newCFrame = InterpolateCFrame(
            prevKf.Data.CFrame, 
            nextKf.Data.CFrame, 
            alpha, 
            easingStyle, 
            easingDir
        )
        part.CFrame = newCFrame
        
        -- Interpolar Size
        if prevKf.Data.Size and nextKf.Data.Size then
            part.Size = InterpolateVector3(
                prevKf.Data.Size, 
                nextKf.Data.Size, 
                alpha, 
                easingStyle, 
                easingDir
            )
        end
        
        -- Interpolar Transparency
        if prevKf.Data.Transparency and nextKf.Data.Transparency then
            part.Transparency = InterpolateNumber(
                prevKf.Data.Transparency, 
                nextKf.Data.Transparency, 
                alpha, 
                easingStyle, 
                easingDir
            )
        end
        
        -- Interpolar Color
        if prevKf.Data.Color and nextKf.Data.Color then
            part.Color = InterpolateColor(
                prevKf.Data.Color, 
                nextKf.Data.Color, 
                alpha, 
                easingStyle, 
                easingDir
            )
        end
        
    elseif prevKf then
        -- Apenas keyframe anterior - manter estado
        part.CFrame = prevKf.Data.CFrame
        if prevKf.Data.Size then part.Size = prevKf.Data.Size end
        if prevKf.Data.Transparency then part.Transparency = prevKf.Data.Transparency end
        if prevKf.Data.Color then part.Color = prevKf.Data.Color end
        
    elseif nextKf then
        -- Apenas keyframe posterior - manter estado original
        -- Não fazer nada, manter estado original
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- APLICAR FRAME ATUAL
-- ═══════════════════════════════════════════════════════════════════
function ApplyCurrentFrame()
    for trackIndex, track in pairs(TracksData) do
        if not track.Muted then
            InterpolateFrame(trackIndex, MortalAnimator.CurrentFrame)
        end
    end
    
    -- Atualizar viewport preview
    UpdateViewportPreview()
end

-- ═══════════════════════════════════════════════════════════════════
-- CALCULAR TOTAL DE FRAMES
-- ═══════════════════════════════════════════════════════════════════
function CalculateTotalFrames()
    local maxFrame = 0
    
    for _, track in pairs(TracksData) do
        for frame, _ in pairs(track.Keyframes) do
            maxFrame = math.max(maxFrame, frame)
        end
    end
    
    MortalAnimator.TotalFrames = maxFrame + 30 -- Adicionar margem
    return maxFrame
end

-- ═══════════════════════════════════════════════════════════════════
-- INICIAR PLAYBACK
-- ═══════════════════════════════════════════════════════════════════
function StartPlayback()
    if MortalAnimator.IsPlaying then return end
    
    SaveOriginalStates()
    MortalAnimator.IsPlaying = true
    MortalAnimator.IsPaused = false
    PlaybackSystem.LastFrameTime = tick()
    PlaybackSystem.FrameAccumulator = 0
    
    PlayBigBtn.Text = "⏸️"
    
    CalculateTotalFrames()
    
    CreateNotification("Playback", "Reproduzindo animação...", "success", 2)
end

-- ═══════════════════════════════════════════════════════════════════
-- PAUSAR PLAYBACK
-- ═══════════════════════════════════════════════════════════════════
function PausePlayback()
    MortalAnimator.IsPaused = not MortalAnimator.IsPaused
    
    if MortalAnimator.IsPaused then
        PlayBigBtn.Text = "▶️"
        CreateNotification("Pausado", "Frame " .. MortalAnimator.CurrentFrame, "warning", 2)
    else
        PlayBigBtn.Text = "⏸️"
        PlaybackSystem.LastFrameTime = tick()
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- PARAR PLAYBACK
-- ═══════════════════════════════════════════════════════════════════
function StopPlayback()
    MortalAnimator.IsPlaying = false
    MortalAnimator.IsPaused = false
    MortalAnimator.CurrentFrame = 0
    
    RestoreOriginalStates()
    UpdatePlayhead()
    
    PlayBigBtn.Text = "▶️"
    
    CreateNotification("Parado", "Animação parada", "warning", 2)
end

-- ═══════════════════════════════════════════════════════════════════
-- LOOP DE PLAYBACK (60-90 FPS)
-- ═══════════════════════════════════════════════════════════════════
local function PlaybackLoop()
    if not MortalAnimator.IsPlaying or MortalAnimator.IsPaused then return end
    
    local currentTime = tick()
    local deltaTime = currentTime - PlaybackSystem.LastFrameTime
    PlaybackSystem.LastFrameTime = currentTime
    
    -- Calcular frames baseado no FPS desejado
    local frameTime = 1 / MortalAnimator.FPS
    PlaybackSystem.FrameAccumulator = PlaybackSystem.FrameAccumulator + deltaTime * MortalAnimator.PlaybackSpeed
    
    while PlaybackSystem.FrameAccumulator >= frameTime do
        PlaybackSystem.FrameAccumulator = PlaybackSystem.FrameAccumulator - frameTime
        MortalAnimator.CurrentFrame = MortalAnimator.CurrentFrame + 1
        
        -- Loop ou parar
        if MortalAnimator.CurrentFrame > MortalAnimator.TotalFrames then
            if MortalAnimator.LoopAnimation then
                MortalAnimator.CurrentFrame = 0
            else
                StopPlayback()
                return
            end
        end
    end
    
    -- Aplicar frame atual
    ApplyCurrentFrame()
    UpdatePlayhead()
end

-- ═══════════════════════════════════════════════════════════════════
-- CONTROLES DE VELOCIDADE
-- ═══════════════════════════════════════════════════════════════════
local SpeedControl = CreateInstance("Frame", {
    Name = "SpeedControl",
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(0, 10, 1, -45),
    Size = UDim2.new(0, 130, 0, 35),
    Parent = LeftPanel
})
CreateCorner(SpeedControl, 8)

local SpeedLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(0, 50, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "⚡ 1.0x",
    TextColor3 = Theme.TextSecondary,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SpeedControl
})

local SpeedSlider = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0, 60, 0.5, -4),
    Size = UDim2.new(0, 60, 0, 8),
    Parent = SpeedControl
})
CreateCorner(SpeedSlider, 4)

local SpeedFill = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Accent,
    Size = UDim2.new(0.5, 0, 1, 0),
    Parent = SpeedSlider
})
CreateCorner(SpeedFill, 4)

local SpeedDragger = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.AccentLight,
    Position = UDim2.new(0.5, -6, 0.5, -6),
    Size = UDim2.new(0, 12, 0, 12),
    Text = "",
    Parent = SpeedSlider
})
CreateCorner(SpeedDragger, 6)

-- Drag para speed
local isDraggingSpeed = false

SpeedDragger.MouseButton1Down:Connect(function()
    isDraggingSpeed = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingSpeed = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = input.Position.X - SpeedSlider.AbsolutePosition.X
        local percent = math.clamp(relativeX / SpeedSlider.AbsoluteSize.X, 0, 1)
        
        SpeedFill.Size = UDim2.new(percent, 0, 1, 0)
        SpeedDragger.Position = UDim2.new(percent, -6, 0.5, -6)
        
        -- Speed de 0.1x a 3x
        MortalAnimator.PlaybackSpeed = 0.1 + percent * 2.9
        SpeedLabel.Text = string.format("⚡ %.1fx", MortalAnimator.PlaybackSpeed)
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- FPS SELECTOR
-- ═══════════════════════════════════════════════════════════════════
local FPSControl = CreateInstance("Frame", {
    Name = "FPSControl",
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(0, 145, 1, -45),
    Size = UDim2.new(0, 90, 0, 35),
    Parent = LeftPanel
})
CreateCorner(FPSControl, 8)

local FPSButtons = {30, 60, 90}
local FPSButtonsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 2),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Parent = FPSControl
})
CreatePadding(FPSControl, 3, 3, 0, 0)

for _, fps in ipairs(FPSButtons) do
    local fpsBtn = CreateInstance("TextButton", {
        BackgroundColor3 = fps == 60 and Theme.Accent or Theme.Secondary,
        Size = UDim2.new(0, 26, 0, 26),
        Text = tostring(fps),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        Parent = FPSControl
    })
    CreateCorner(fpsBtn, 4)
    
    fpsBtn.MouseButton1Click:Connect(function()
        MortalAnimator.FPS = fps
        FPSLabel.Text = fps .. " FPS"
        
        for _, child in pairs(FPSControl:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.Secondary
            end
        end
        fpsBtn.BackgroundColor3 = Theme.Accent
        
        CreateNotification("FPS", fps .. " FPS selecionado", "success", 2)
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- ONION SKINNING (GHOST FRAMES)
-- ═══════════════════════════════════════════════════════════════════
local GhostParts = {}

function UpdateOnionSkinning()
    -- Limpar ghosts antigos
    for _, ghost in pairs(GhostParts) do
        if ghost and ghost.Parent then
            ghost:Destroy()
        end
    end
    GhostParts = {}
    
    if not MortalAnimator.OnionSkinning or not MortalAnimator.CurrentObject then return end
    
    local ghostFrames = MortalAnimator.GhostingFrames
    
    for offset = -ghostFrames, ghostFrames do
        if offset ~= 0 then
            local frame = MortalAnimator.CurrentFrame + offset
            if frame >= 0 then
                local alpha = 1 - (math.abs(offset) / (ghostFrames + 1))
                local color = offset < 0 and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 100, 255)
                
                for trackIndex, track in pairs(TracksData) do
                    if track.PartRef and track.PartRef:IsA("BasePart") then
                        local ghost = track.PartRef:Clone()
                        ghost.Name = "Ghost_" .. offset
                        ghost.Transparency = 0.7 + (1 - alpha) * 0.3
                        ghost.Color = color
                        ghost.CanCollide = false
                        ghost.Anchored = true
                        ghost.Parent = Workspace
                        
                        -- Aplicar posição do frame
                        local prevKf, nextKf, prevFrame, nextFrame = GetAdjacentKeyframes(track, frame)
                        if prevKf then
                            ghost.CFrame = prevKf.Data.CFrame
                        end
                        
                        table.insert(GhostParts, ghost)
                    end
                end
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- CONEXÃO DO LOOP PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function(deltaTime)
    -- Playback loop
    PlaybackLoop()
    
    -- Atualizar FPS display
    local fps = math.floor(1 / deltaTime)
    FPSLabel.Text = fps .. " FPS"
    
    if fps >= 55 then
        FPSLabel.TextColor3 = Theme.Success
    elseif fps >= 30 then
        FPSLabel.TextColor3 = Theme.Warning
    else
        FPSLabel.TextColor3 = Theme.Error
    end
    
    -- Onion skinning
    if MortalAnimator.OnionSkinning and not MortalAnimator.IsPlaying then
        UpdateOnionSkinning()
    end
end)

-- Conectar botões de playback
PlayBigBtn.MouseButton1Click:Connect(function()
    if MortalAnimator.IsPlaying then
        PausePlayback()
    else
        StartPlayback()
    end
end)

StopBtn.MouseButton1Click:Connect(StopPlayback)
PauseBtn.MouseButton1Click:Connect(PausePlayback)

-- Adicionar keyframe no frame atual
AddKeyBtn.MouseButton1Click:Connect(function()
    if MortalAnimator.SelectedPart then
        for trackIndex, track in pairs(TracksData) do
            if track.PartRef == MortalAnimator.SelectedPart then
                AddKeyframeToTrack(trackIndex, MortalAnimator.CurrentFrame)
                break
            end
        end
    else
        CreateNotification("Aviso", "Selecione uma parte primeiro", "warning", 2)
    end
end)

-- Remover keyframe selecionado
RemoveKeyBtn.MouseButton1Click:Connect(function()
    for _, sel in ipairs(KeyframeSystem.SelectedKeyframes) do
        RemoveKeyframe(sel.TrackIndex, sel.Frame)
    end
    KeyframeSystem.SelectedKeyframes = {}
end)

-- Undo/Redo buttons
UndoBtn.MouseButton1Click:Connect(Undo)
RedoBtn.MouseButton1Click:Connect(Redo)

-- Copy/Paste
CopyBtn.MouseButton1Click:Connect(CopySelectedKeyframes)
PasteBtn.MouseButton1Click:Connect(function()
    PasteKeyframes()
end)

print("✅ Mortal Animator - Parte 6 carregada com sucesso!")
print("📦 Aguardando próxima parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 7: SISTEMA DE CUTSCENES
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- VARIÁVEIS DO SISTEMA DE CUTSCENE
-- ═══════════════════════════════════════════════════════════════════
local CutsceneSystem = {
    IsActive = false,
    Cameras = {},
    CurrentCameraIndex = 1,
    CameraPoints = {},
    Duration = 5,
    IsPreviewPlaying = false,
    TransitionType = "Smooth",
    FOV = 70
}

-- ═══════════════════════════════════════════════════════════════════
-- MENU DE CUTSCENES
-- ═══════════════════════════════════════════════════════════════════
local CutsceneMenu = CreateInstance("Frame", {
    Name = "CutsceneMenu",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 800, 0, 550),
    Visible = false,
    ZIndex = 70,
    Parent = ScreenGui
})
CreateCorner(CutsceneMenu, 16)
CreateStroke(CutsceneMenu, Theme.Accent, 2, 0.3)
CreateShadow(CutsceneMenu, 60, 0.4)

-- Header
local CutsceneHeader = CreateInstance("Frame", {
    Name = "Header",
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 55),
    BorderSizePixel = 0,
    ZIndex = 71,
    Parent = CutsceneMenu
})
CreateCorner(CutsceneHeader, 16)

local CutsceneHeaderFix = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 0, 1, -16),
    Size = UDim2.new(1, 0, 0, 16),
    BorderSizePixel = 0,
    ZIndex = 71,
    Parent = CutsceneHeader
})

local CutsceneTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 0),
    Size = UDim2.new(1, -80, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "🎬 Criar Cutscene⚡",
    TextColor3 = Theme.TextPrimary,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 71,
    Parent = CutsceneHeader
})

local CloseCutsceneBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(1, -50, 0.5, -17),
    Size = UDim2.new(0, 34, 0, 34),
    Text = "✕",
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    ZIndex = 71,
    Parent = CutsceneHeader
})
CreateCorner(CloseCutsceneBtn, 8)

CloseCutsceneBtn.MouseButton1Click:Connect(function()
    Tween(CutsceneMenu, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.3)
    CutsceneMenu.Visible = false
    CutsceneSystem.IsActive = false
end)

-- ═══════════════════════════════════════════════════════════════════
-- PAINEL ESQUERDO - LISTA DE CÂMERAS
-- ═══════════════════════════════════════════════════════════════════
local CutsceneLeftPanel = CreateInstance("Frame", {
    Name = "LeftPanel",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 10, 0, 65),
    Size = UDim2.new(0, 220, 1, -130),
    BorderSizePixel = 0,
    ZIndex = 71,
    Parent = CutsceneMenu
})
CreateCorner(CutsceneLeftPanel, 10)

local CameraListHeader = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(1, 0, 0, 40),
    BorderSizePixel = 0,
    ZIndex = 72,
    Parent = CutsceneLeftPanel
})
CreateCorner(CameraListHeader, 10)

local CameraListTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(1, -50, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "📷 Câmeras",
    TextColor3 = Theme.TextPrimary,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 72,
    Parent = CameraListHeader
})

-- Botão adicionar câmera
local AddCameraBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Accent,
    Position = UDim2.new(1, -38, 0.5, -12),
    Size = UDim2.new(0, 26, 0, 24),
    Text = "+",
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    ZIndex = 72,
    Parent = CameraListHeader
})
CreateCorner(AddCameraBtn, 6)

-- Lista de câmeras
local CameraListScroll = CreateInstance("ScrollingFrame", {
    Name = "CameraList",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 5, 0, 48),
    Size = UDim2.new(1, -10, 1, -55),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 72,
    Parent = CutsceneLeftPanel
})

local CameraListLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = CameraListScroll
})

-- ═══════════════════════════════════════════════════════════════════
-- FUNÇÕES DE CÂMERA
-- ═══════════════════════════════════════════════════════════════════
local CameraMarkers = {}

function CreateCameraPoint(position, lookAt)
    local cameraIndex = #CutsceneSystem.CameraPoints + 1
    
    -- Criar esfera visual no workspace
    local marker = Instance.new("Part")
    marker.Name = "CutsceneCamera_" .. cameraIndex
    marker.Shape = Enum.PartType.Ball
    marker.Size = Vector3.new(2, 2, 2)
    marker.Color = Color3.fromRGB(50, 150, 255)
    marker.Material = Enum.Material.Neon
    marker.Transparency = 0.4
    marker.Anchored = true
    marker.CanCollide = false
    marker.Position = position or Camera.CFrame.Position
    marker.Parent = Workspace
    
    -- Adicionar seta de direção
    local arrow = Instance.new("Part")
    arrow.Name = "Arrow"
    arrow.Size = Vector3.new(0.3, 0.3, 2)
    arrow.Color = Color3.fromRGB(255, 200, 50)
    arrow.Material = Enum.Material.Neon
    arrow.Anchored = true
    arrow.CanCollide = false
    arrow.CFrame = CFrame.new(marker.Position, lookAt or marker.Position + Camera.CFrame.LookVector * 5)
    arrow.Parent = marker
    
    -- Billboard GUI para label
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 60, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = marker
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundColor3 = Theme.Primary
    label.TextColor3 = Theme.TextPrimary
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Text = "📷 " .. cameraIndex
    label.Parent = billboard
    CreateCorner(label, 6)
    
    -- Dados da câmera
    local cameraData = {
        Index = cameraIndex,
        Position = marker.Position,
        LookAt = lookAt or marker.Position + Camera.CFrame.LookVector * 10,
        FOV = CutsceneSystem.FOV,
        Duration = 2,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.InOut,
        Marker = marker,
        WaitTime = 0
    }
    
    table.insert(CutsceneSystem.CameraPoints, cameraData)
    table.insert(CameraMarkers, marker)
    
    -- Criar item na lista
    CreateCameraListItem(cameraData)
    
    CreateNotification("Câmera Adicionada", "Câmera " .. cameraIndex .. " criada", "success", 2)
    
    return cameraData
end

function CreateCameraListItem(cameraData)
    local item = CreateInstance("Frame", {
        Name = "Camera_" .. cameraData.Index,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 65),
        ZIndex = 73,
        Parent = CameraListScroll
    })
    CreateCorner(item, 8)
    
    local icon = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 8),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "📷",
        TextSize = 18,
        ZIndex = 73,
        Parent = item
    })
    
    local nameLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 8),
        Size = UDim2.new(1, -90, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = "Câmera " .. cameraData.Index,
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 73,
        Parent = item
    })
    
    local durationLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 28),
        Size = UDim2.new(1, -50, 0, 14),
        Font = Enum.Font.Gotham,
        Text = "⏱️ " .. cameraData.Duration .. "s",
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 73,
        Parent = item
    })
    
    -- Botões de ação
    local goToBtn = CreateInstance("TextButton", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 10, 1, -28),
        Size = UDim2.new(0, 50, 0, 22),
        Text = "👁️ Ir",
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        ZIndex = 74,
        Parent = item
    })
    CreateCorner(goToBtn, 4)
    
    goToBtn.MouseButton1Click:Connect(function()
        Camera.CFrame = CFrame.new(cameraData.Position, cameraData.LookAt)
    end)
    
    local updateBtn = CreateInstance("TextButton", {
        BackgroundColor3 = Theme.Success,
        Position = UDim2.new(0, 65, 1, -28),
        Size = UDim2.new(0, 70, 0, 22),
        Text = "🔄 Atualizar",
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        ZIndex = 74,
        Parent = item
    })
    CreateCorner(updateBtn, 4)
    
    updateBtn.MouseButton1Click:Connect(function()
        cameraData.Position = Camera.CFrame.Position
        cameraData.LookAt = Camera.CFrame.Position + Camera.CFrame.LookVector * 10
        cameraData.Marker.Position = cameraData.Position
        CreateNotification("Atualizado", "Câmera " .. cameraData.Index .. " atualizada", "success", 2)
    end)
    
    local deleteBtn = CreateInstance("TextButton", {
        BackgroundColor3 = Theme.Error,
        Position = UDim2.new(1, -35, 0, 8),
        Size = UDim2.new(0, 25, 0, 25),
        Text = "🗑️",
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        ZIndex = 74,
        Parent = item
    })
    CreateCorner(deleteBtn, 4)
    
    deleteBtn.MouseButton1Click:Connect(function()
        -- Remover câmera
        cameraData.Marker:Destroy()
        item:Destroy()
        for i, cam in ipairs(CutsceneSystem.CameraPoints) do
            if cam.Index == cameraData.Index then
                table.remove(CutsceneSystem.CameraPoints, i)
                break
            end
        end
        CreateNotification("Removida", "Câmera " .. cameraData.Index .. " removida", "warning", 2)
    end)
    
    -- Atualizar canvas size
    CameraListScroll.CanvasSize = UDim2.new(0, 0, 0, #CutsceneSystem.CameraPoints * 70)
end

AddCameraBtn.MouseButton1Click:Connect(function()
    CreateCameraPoint()
end)

-- ═══════════════════════════════════════════════════════════════════
-- PAINEL CENTRAL - PREVIEW DA CUTSCENE
-- ═══════════════════════════════════════════════════════════════════
local CutsceneCenterPanel = CreateInstance("Frame", {
    Name = "CenterPanel",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 240, 0, 65),
    Size = UDim2.new(1, -480, 1, -130),
    BorderSizePixel = 0,
    ZIndex = 71,
    Parent = CutsceneMenu
})
CreateCorner(CutsceneCenterPanel, 10)

local CutsceneViewport = CreateInstance("ViewportFrame", {
    Name = "Preview",
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    Position = UDim2.new(0, 10, 0, 10),
    Size = UDim2.new(1, -20, 1, -70),
    BorderSizePixel = 0,
    ZIndex = 72,
    Parent = CutsceneCenterPanel
})
CreateCorner(CutsceneViewport, 8)

local CutscenePreviewCamera = Instance.new("Camera")
CutscenePreviewCamera.CFrame = CFrame.new(Vector3.new(0, 10, 20), Vector3.new(0, 0, 0))
CutsceneViewport.CurrentCamera = CutscenePreviewCamera

-- Controles de preview
local PreviewControls = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 1, -55),
    Size = UDim2.new(1, -20, 0, 45),
    ZIndex = 72,
    Parent = CutsceneCenterPanel
})

local PreviewControlsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding = UDim.new(0, 10),
    Parent = PreviewControls
})

local PreviewPlayBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Accent,
    Size = UDim2.new(0, 100, 0, 35),
    Text = "▶️ Preview",
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    ZIndex = 73,
    Parent = PreviewControls
})
CreateCorner(PreviewPlayBtn, 8)
CreateGradient(PreviewPlayBtn, 45)

local FullPreviewBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Success,
    Size = UDim2.new(0, 130, 0, 35),
    Text = "🎬 Preview Completo",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    ZIndex = 73,
    Parent = PreviewControls
})
CreateCorner(FullPreviewBtn, 8)

local StopPreviewBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Error,
    Size = UDim2.new(0, 80, 0, 35),
    Text = "⏹️ Parar",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    ZIndex = 73,
    Parent = PreviewControls
})
CreateCorner(StopPreviewBtn, 8)

-- ═══════════════════════════════════════════════════════════════════
-- PAINEL DIREITO - CONFIGURAÇÕES
-- ═══════════════════════════════════════════════════════════════════
local CutsceneRightPanel = CreateInstance("Frame", {
    Name = "RightPanel",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(1, -230, 0, 65),
    Size = UDim2.new(0, 220, 1, -130),
    BorderSizePixel = 0,
    ZIndex = 71,
    Parent = CutsceneMenu
})
CreateCorner(CutsceneRightPanel, 10)

local SettingsHeader = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(1, 0, 0, 40),
    BorderSizePixel = 0,
    ZIndex = 72,
    Parent = CutsceneRightPanel
})
CreateCorner(SettingsHeader, 10)

local SettingsTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(1, -12, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "⚙️ Configurações",
    TextColor3 = Theme.TextPrimary,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 72,
    Parent = SettingsHeader
})

-- Configurações da Cutscene
local SettingsScroll = CreateInstance("ScrollingFrame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 5, 0, 48),
    Size = UDim2.new(1, -10, 1, -55),
    CanvasSize = UDim2.new(0, 0, 0, 350),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 72,
    Parent = CutsceneRightPanel
})

local SettingsLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = SettingsScroll
})

-- FOV Setting
local FOVSetting = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(1, 0, 0, 55),
    ZIndex = 73,
    Parent = SettingsScroll
})
CreateCorner(FOVSetting, 6)

local FOVLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "📐 FOV: 70",
    TextColor3 = Theme.TextPrimary,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 73,
    Parent = FOVSetting
})

local FOVSlider = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0, 10, 0, 30),
    Size = UDim2.new(1, -20, 0, 15),
    ZIndex = 73,
    Parent = FOVSetting
})
CreateCorner(FOVSlider, 6)

local FOVFill = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Accent,
    Size = UDim2.new(0.5, 0, 1, 0),
    ZIndex = 74,
    Parent = FOVSlider
})
CreateCorner(FOVFill, 6)

-- Transition Type
local TransitionSetting = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Tertiary,
    Size = UDim2.new(1, 0, 0, 80),
    ZIndex = 73,
    Parent = SettingsScroll
})
CreateCorner(TransitionSetting, 6)

local TransitionLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "🔄 Transição",
    TextColor3 = Theme.TextPrimary,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 73,
    Parent = TransitionSetting
})

local TransitionTypes = {"Smooth", "Linear", "Cut", "Fade"}
local TransitionButtonsFrame = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 5, 0, 30),
    Size = UDim2.new(1, -10, 0, 45),
    ZIndex = 73,
    Parent = TransitionSetting
})

local TransitionBtnsLayout = CreateInstance("UIGridLayout", {
    CellSize = UDim2.new(0.48, 0, 0, 20),
    CellPadding = UDim2.new(0.02, 0, 0, 5),
    Parent = TransitionButtonsFrame
})

for _, transType in ipairs(TransitionTypes) do
    local btn = CreateInstance("TextButton", {
        BackgroundColor3 = transType == "Smooth" and Theme.Accent or Theme.Secondary,
        Text = transType,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        ZIndex = 74,
        Parent = TransitionButtonsFrame
    })
    CreateCorner(btn, 4)
    
    btn.MouseButton1Click:Connect(function()
        CutsceneSystem.TransitionType = transType
        for _, child in pairs(TransitionButtonsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.Secondary
            end
        end
        btn.BackgroundColor3 = Theme.Accent
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- TIMELINE DA CUTSCENE
-- ═══════════════════════════════════════════════════════════════════
local CutsceneTimeline = CreateInstance("Frame", {
    Name = "Timeline",
    BackgroundColor3 = Theme.Timeline,
    Position = UDim2.new(0, 10, 1, -55),
    Size = UDim2.new(1, -20, 0, 45),
    ZIndex = 71,
    Parent = CutsceneMenu
})
CreateCorner(CutsceneTimeline, 8)

local CutsceneTimelineLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(0, 100, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "📽️ Timeline",
    TextColor3 = Theme.TextSecondary,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 72,
    Parent = CutsceneTimeline
})

-- ═══════════════════════════════════════════════════════════════════
-- FUNÇÕES DE PREVIEW DA CUTSCENE
-- ═══════════════════════════════════════════════════════════════════
function PlayCutscenePreview(inViewport)
    if #CutsceneSystem.CameraPoints < 2 then
        CreateNotification("Erro", "Adicione pelo menos 2 câmeras", "error", 3)
        return
    end
    
    CutsceneSystem.IsPreviewPlaying = true
    
    local targetCamera = inViewport and CutscenePreviewCamera or Camera
    
    task.spawn(function()
        for i, camPoint in ipairs(CutsceneSystem.CameraPoints) do
            if not CutsceneSystem.IsPreviewPlaying then break end
            
            local nextCam = CutsceneSystem.CameraPoints[i + 1]
            
            if nextCam then
                local startCF = CFrame.new(camPoint.Position, camPoint.LookAt)
                local endCF = CFrame.new(nextCam.Position, nextCam.LookAt)
                local duration = camPoint.Duration
                
                local startTime = tick()
                
                while tick() - startTime < duration and CutsceneSystem.IsPreviewPlaying do


                                local alpha = (tick() - startTime) / duration
                    local easedAlpha = TweenService:GetValue(alpha, camPoint.EasingStyle, camPoint.EasingDirection)
                    
                    targetCamera.CFrame = startCF:Lerp(endCF, easedAlpha)
                    targetCamera.FieldOfView = Lerp(camPoint.FOV, nextCam.FOV, easedAlpha)
                    
                    RunService.RenderStepped:Wait()
                end
                
                -- Wait time
                if camPoint.WaitTime > 0 then
                    task.wait(camPoint.WaitTime)
                end
            end
        end
        
        CutsceneSystem.IsPreviewPlaying = false
        CreateNotification("Cutscene", "Preview finalizado", "success", 2)
    end)
end

function StopCutscenePreview()
    CutsceneSystem.IsPreviewPlaying = false
end

PreviewPlayBtn.MouseButton1Click:Connect(function()
    PlayCutscenePreview(true)
end)

FullPreviewBtn.MouseButton1Click:Connect(function()
    PlayCutscenePreview(false)
end)

StopPreviewBtn.MouseButton1Click:Connect(function()
    StopCutscenePreview()
end)

-- ═══════════════════════════════════════════════════════════════════
-- BOTÃO PARA ABRIR MENU DE CUTSCENE
-- ═══════════════════════════════════════════════════════════════════
local CutsceneBtn = CreateInstance("TextButton", {
    Name = "CutsceneBtn",
    BackgroundColor3 = Theme.Accent,
    Position = UDim2.new(1, -240, 0, 5),
    Size = UDim2.new(0, 150, 0, 32),
    Text = "🎬 Criar Cutscene⚡",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    ZIndex = 10,
    Parent = Toolbar
})
CreateCorner(CutsceneBtn, 8)
CreateGradient(CutsceneBtn, 90, ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 100))
}))

CutsceneBtn.MouseButton1Click:Connect(function()
    CutsceneMenu.Visible = true
    CutsceneMenu.Size = UDim2.new(0, 0, 0, 0)
    Tween(CutsceneMenu, {Size = UDim2.new(0, 800, 0, 550)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    CutsceneSystem.IsActive = true
    CreateNotification("Cutscene Mode", "Modo de criação de Cutscene ativado", "success", 3)
end)

print("✅ Mortal Animator - Parte 7 carregada com sucesso!")
print("📦 Aguardando próxima parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 8: SISTEMA DE EXPORT
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- MENU DE EXPORT
-- ═══════════════════════════════════════════════════════════════════
local ExportMenu = CreateInstance("Frame", {
    Name = "ExportMenu",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 650, 0, 500),
    Visible = false,
    ZIndex = 80,
    Parent = ScreenGui
})
CreateCorner(ExportMenu, 16)
CreateStroke(ExportMenu, Theme.Accent, 2, 0.3)
CreateShadow(ExportMenu, 50, 0.4)

-- Header
local ExportHeader = CreateInstance("Frame", {
    Name = "Header",
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 55),
    BorderSizePixel = 0,
    ZIndex = 81,
    Parent = ExportMenu
})
CreateCorner(ExportHeader, 16)

local ExportHeaderFix = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 0, 1, -16),
    Size = UDim2.new(1, 0, 0, 16),
    BorderSizePixel = 0,
    ZIndex = 81,
    Parent = ExportHeader
})

local ExportTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 0),
    Size = UDim2.new(1, -80, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "📤 Exportar Animação",
    TextColor3 = Theme.TextPrimary,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 81,
    Parent = ExportHeader
})

local CloseExportBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(1, -50, 0.5, -17),
    Size = UDim2.new(0, 34, 0, 34),
    Text = "✕",
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    AutoButtonColor = false,
    ZIndex = 81,
    Parent = ExportHeader
})
CreateCorner(CloseExportBtn, 8)

CloseExportBtn.MouseButton1Click:Connect(function()
    Tween(ExportMenu, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.3)
    ExportMenu.Visible = false
end)

-- ═══════════════════════════════════════════════════════════════════
-- CONFIGURAÇÕES DE EXPORT
-- ═══════════════════════════════════════════════════════════════════
local ExportConfig = CreateInstance("Frame", {
    Name = "Config",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 15, 0, 65),
    Size = UDim2.new(0, 200, 1, -80),
    BorderSizePixel = 0,
    ZIndex = 81,
    Parent = ExportMenu
})
CreateCorner(ExportConfig, 10)

local ConfigTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(1, -15, 0, 25),
    Font = Enum.Font.GothamBold,
    Text = "⚙️ Configurações",
    TextColor3 = Theme.TextPrimary,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 82,
    Parent = ExportConfig
})

-- Nome da animação
local AnimNameFrame = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(0, 10, 0, 45),
    Size = UDim2.new(1, -20, 0, 60),
    ZIndex = 82,
    Parent = ExportConfig
})
CreateCorner(AnimNameFrame, 8)

local AnimNameLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "📝 Nome da Animação",
    TextColor3 = Theme.TextSecondary,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 82,
    Parent = AnimNameFrame
})

local AnimNameInput = CreateInstance("TextBox", {
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0, 10, 0, 28),
    Size = UDim2.new(1, -20, 0, 25),
    Font = Enum.Font.Gotham,
    Text = "MortalAnimation",
    TextColor3 = Theme.TextPrimary,
    TextSize = 12,
    PlaceholderText = "Nome...",
    PlaceholderColor3 = Theme.TextMuted,
    ZIndex = 83,
    Parent = AnimNameFrame
})
CreateCorner(AnimNameInput, 4)

-- Tipo de script
local ScriptTypeFrame = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(0, 10, 0, 115),
    Size = UDim2.new(1, -20, 0, 85),
    ZIndex = 82,
    Parent = ExportConfig
})
CreateCorner(ScriptTypeFrame, 8)

local ScriptTypeLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "📜 Tipo de Script",
    TextColor3 = Theme.TextSecondary,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 82,
    Parent = ScriptTypeFrame
})

local ScriptTypes = {"LocalScript", "Script", "ModuleScript"}
local SelectedScriptType = "LocalScript"
local ScriptTypeBtnsFrame = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 5, 0, 28),
    Size = UDim2.new(1, -10, 0, 50),
    ZIndex = 82,
    Parent = ScriptTypeFrame
})

local ScriptTypeBtnsLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 5),
    Parent = ScriptTypeBtnsFrame
})

local ScriptTypeBtns = {}
for _, scriptType in ipairs(ScriptTypes) do
    local btn = CreateInstance("TextButton", {
        BackgroundColor3 = scriptType == "LocalScript" and Theme.Accent or Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 22),
        Text = scriptType,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        ZIndex = 83,
        Parent = ScriptTypeBtnsFrame
    })
    CreateCorner(btn, 4)
    ScriptTypeBtns[scriptType] = btn
    
    btn.MouseButton1Click:Connect(function()
        SelectedScriptType = scriptType
        for t, b in pairs(ScriptTypeBtns) do
            b.BackgroundColor3 = t == scriptType and Theme.Accent or Theme.Secondary
        end
    end)
end

-- Include Cutscene
local IncludeCutsceneFrame = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(0, 10, 0, 210),
    Size = UDim2.new(1, -20, 0, 45),
    ZIndex = 82,
    Parent = ExportConfig
})
CreateCorner(IncludeCutsceneFrame, 8)

local IncludeCutsceneLabel = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(1, -60, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "🎬 Incluir Cutscene",
    TextColor3 = Theme.TextSecondary,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 82,
    Parent = IncludeCutsceneFrame
})

local IncludeCutsceneToggle = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(1, -50, 0.5, -12),
    Size = UDim2.new(0, 40, 0, 24),
    Text = "OFF",
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextMuted,
    ZIndex = 83,
    Parent = IncludeCutsceneFrame
})
CreateCorner(IncludeCutsceneToggle, 12)

local IncludeCutscene = false
IncludeCutsceneToggle.MouseButton1Click:Connect(function()
    IncludeCutscene = not IncludeCutscene
    if IncludeCutscene then
        IncludeCutsceneToggle.Text = "ON"
        IncludeCutsceneToggle.BackgroundColor3 = Theme.Success
        IncludeCutsceneToggle.TextColor3 = Theme.TextPrimary
    else
        IncludeCutsceneToggle.Text = "OFF"
        IncludeCutsceneToggle.BackgroundColor3 = Theme.Secondary
        IncludeCutsceneToggle.TextColor3 = Theme.TextMuted
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- ÁREA DO CÓDIGO GERADO
-- ═══════════════════════════════════════════════════════════════════
local CodeArea = CreateInstance("Frame", {
    Name = "CodeArea",
    BackgroundColor3 = Theme.Secondary,
    Position = UDim2.new(0, 225, 0, 65),
    Size = UDim2.new(1, -240, 1, -130),
    BorderSizePixel = 0,
    ZIndex = 81,
    Parent = ExportMenu
})
CreateCorner(CodeArea, 10)

local CodeTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(1, -100, 0, 25),
    Font = Enum.Font.GothamBold,
    Text = "💻 Código Lua Gerado",
    TextColor3 = Theme.TextPrimary,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 82,
    Parent = CodeArea
})

local CopyCodeBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Accent,
    Position = UDim2.new(1, -90, 0, 8),
    Size = UDim2.new(0, 80, 0, 28),
    Text = "📋 Copiar",
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    ZIndex = 83,
    Parent = CodeArea
})
CreateCorner(CopyCodeBtn, 6)

local CodeScroll = CreateInstance("ScrollingFrame", {
    BackgroundColor3 = Color3.fromRGB(18, 18, 24),
    Position = UDim2.new(0, 10, 0, 45),
    Size = UDim2.new(1, -20, 1, -55),
    CanvasSize = UDim2.new(0, 0, 0, 1000),
    ScrollBarThickness = 6,
    ScrollBarImageColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 82,
    Parent = CodeArea
})
CreateCorner(CodeScroll, 8)

local CodeText = CreateInstance("TextBox", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 10),
    Size = UDim2.new(1, -20, 1, -10),
    Font = Enum.Font.Code,
    Text = "-- Código será gerado aqui...",
    TextColor3 = Color3.fromRGB(150, 200, 150),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    MultiLine = true,
    ClearTextOnFocus = false,
    TextWrapped = true,
    ZIndex = 83,
    Parent = CodeScroll
})

-- ═══════════════════════════════════════════════════════════════════
-- BOTÕES DE AÇÃO
-- ═══════════════════════════════════════════════════════════════════
local ExportActions = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 1, -55),
    Size = UDim2.new(1, -30, 0, 45),
    ZIndex = 81,
    Parent = ExportMenu
})

local ExportActionsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 15),
    Parent = ExportActions
})

local GenerateCodeBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Accent,
    Size = UDim2.new(0, 150, 0, 38),
    Text = "⚡ Gerar Código",
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    ZIndex = 82,
    Parent = ExportActions
})
CreateCorner(GenerateCodeBtn, 8)
CreateGradient(GenerateCodeBtn, 45)

local CreateScriptBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Success,
    Size = UDim2.new(0, 180, 0, 38),
    Text = "📜 Criar Script no Explorer",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextPrimary,
    ZIndex = 82,
    Parent = ExportActions
})
CreateCorner(CreateScriptBtn, 8)

local ExportFileBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Warning,
    Size = UDim2.new(0, 130, 0, 38),
    Text = "💾 Salvar Arquivo",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Primary,
    ZIndex = 82,
    Parent = ExportActions
})
CreateCorner(ExportFileBtn, 8)

-- ═══════════════════════════════════════════════════════════════════
-- FUNÇÃO DE GERAÇÃO DE CÓDIGO
-- ═══════════════════════════════════════════════════════════════════
function GenerateAnimationCode()
    local animName = AnimNameInput.Text ~= "" and AnimNameInput.Text or "MortalAnimation"
    local objectName = MortalAnimator.CurrentObject and MortalAnimator.CurrentObject.Name or "Object"
    
    local code = [[
--[[
    ═══════════════════════════════════════════════════════════════
    ]] .. animName .. [[
    
    Gerado por Mortal Animator☠️ • V1⚡
    ═══════════════════════════════════════════════════════════════
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Configurações da Animação
local AnimationConfig = {
    Name = "]] .. animName .. [[",
    FPS = ]] .. MortalAnimator.FPS .. [[,
    TotalFrames = ]] .. MortalAnimator.TotalFrames .. [[,
    Loop = ]] .. tostring(MortalAnimator.LoopAnimation) .. [[
}

-- Dados dos Keyframes
local KeyframeData = {
]]

    -- Adicionar dados de cada track
    for trackIndex, track in pairs(TracksData) do
        if track.PartRef then
            code = code .. "    [\"" .. track.Name .. "\"] = {\n"
            
            local sortedFrames = {}
            for frame, kfData in pairs(track.Keyframes) do
                table.insert(sortedFrames, {Frame = frame, Data = kfData.Data})
            end
            table.sort(sortedFrames, function(a, b) return a.Frame < b.Frame end)
            
            for _, kf in ipairs(sortedFrames) do
                local cf = kf.Data.CFrame
                local pos = cf.Position
                local rx, ry, rz = cf:ToEulerAnglesXYZ()
                
                code = code .. string.format([[        {
            Frame = %d,
            Position = Vector3.new(%.4f, %.4f, %.4f),
            Rotation = Vector3.new(%.4f, %.4f, %.4f),
            EasingStyle = Enum.EasingStyle.%s,
            EasingDirection = Enum.EasingDirection.%s
        },
]], kf.Frame, pos.X, pos.Y, pos.Z, 
    math.deg(rx), math.deg(ry), math.deg(rz),
    tostring(kf.Data.EasingStyle):match("%.(%w+)$") or "Quad",
    tostring(kf.Data.EasingDirection):match("%.(%w+)$") or "InOut")
            end
            
            code = code .. "    },\n"
        end
    end
    
    code = code .. [[}

-- Módulo de Animação
local Animation = {}
Animation.__index = Animation

function Animation.new(targetObject)
    local self = setmetatable({}, Animation)
    self.Target = targetObject
    self.IsPlaying = false
    self.CurrentFrame = 0
    self.Parts = {}
    
    -- Encontrar partes
    for partName, _ in pairs(KeyframeData) do
        local part = targetObject:FindFirstChild(partName, true)
        if part then
            self.Parts[partName] = part
        end
    end
    
    return self
end

function Animation:GetKeyframes(partName, frame)
    local keyframes = KeyframeData[partName]
    if not keyframes then return nil, nil end
    
    local prevKf, nextKf
    local prevFrame, nextFrame = -1, math.huge
    
    for _, kf in ipairs(keyframes) do
        if kf.Frame <= frame and kf.Frame > prevFrame then
            prevFrame = kf.Frame
            prevKf = kf
        end
        if kf.Frame > frame and kf.Frame < nextFrame then
            nextFrame = kf.Frame
            nextKf = kf
        end
    end
    
    return prevKf, nextKf, prevFrame, nextFrame
end

function Animation:InterpolateFrame(frame)
    for partName, part in pairs(self.Parts) do
        local prevKf, nextKf, prevFrame, nextFrame = self:GetKeyframes(partName, frame)
        
        if prevKf and nextKf then
            local alpha = (frame - prevFrame) / (nextFrame - prevFrame)
            local easedAlpha = TweenService:GetValue(alpha, nextKf.EasingStyle, nextKf.EasingDirection)
            
            local pos = prevKf.Position:Lerp(nextKf.Position, easedAlpha)
            local rot = prevKf.Rotation:Lerp(nextKf.Rotation, easedAlpha)
            
            part.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(rot.X), math.rad(rot.Y), math.rad(rot.Z))
            
        elseif prevKf then
            part.CFrame = CFrame.new(prevKf.Position) * CFrame.Angles(
                math.rad(prevKf.Rotation.X), 
                math.rad(prevKf.Rotation.Y), 
                math.rad(prevKf.Rotation.Z)
            )
        end
    end
end

function Animation:Play()
    if self.IsPlaying then return end
    self.IsPlaying = true
    self.CurrentFrame = 0
    
    local frameTime = 1 / AnimationConfig.FPS
    local connection
    
    connection = RunService.Heartbeat:Connect(function(dt)
        if not self.IsPlaying then
            connection:Disconnect()
            return
        end
        
        self.CurrentFrame = self.CurrentFrame + (dt / frameTime)
        
        if self.CurrentFrame >= AnimationConfig.TotalFrames then
            if AnimationConfig.Loop then
                self.CurrentFrame = 0
            else
                self:Stop()
                return
            end
        end
        
        self:InterpolateFrame(math.floor(self.CurrentFrame))
    end)
end

function Animation:Stop()
    self.IsPlaying = false
    self.CurrentFrame = 0
end

function Animation:Pause()
    self.IsPlaying = false
end

function Animation:Resume()
    self.IsPlaying = true
end

return Animation
]]

    -- Adicionar código de cutscene se necessário
    if IncludeCutscene and #CutsceneSystem.CameraPoints > 0 then
        code = code .. [[

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE CUTSCENE
-- ═══════════════════════════════════════════════════════════════
local CutsceneData = {
]]
        for i, cam in ipairs(CutsceneSystem.CameraPoints) do
            code = code .. string.format([[    {
        Position = Vector3.new(%.4f, %.4f, %.4f),
        LookAt = Vector3.new(%.4f, %.4f, %.4f),
        FOV = %d,
        Duration = %.2f
    },
]], cam.Position.X, cam.Position.Y, cam.Position.Z,
    cam.LookAt.X, cam.LookAt.Y, cam.LookAt.Z,
    cam.FOV, cam.Duration)
        end
        code = code .. [[}

function PlayCutscene()
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable
    
    for i, camPoint in ipairs(CutsceneData) do
        local nextCam = CutsceneData[i + 1]
        if nextCam then
            local startCF = CFrame.new(camPoint.Position, camPoint.LookAt)
            local endCF = CFrame.new(nextCam.Position, nextCam.LookAt)
            
            local startTime = tick()
            while tick() - startTime < camPoint.Duration do
                local alpha = (tick() - startTime) / camPoint.Duration
                camera.CFrame = startCF:Lerp(endCF, alpha)
                camera.FieldOfView = camPoint.FOV + (nextCam.FOV - camPoint.FOV) * alpha
                game:GetService("RunService").RenderStepped:Wait()
            end
        end
    end
    
    camera.CameraType = Enum.CameraType.Custom
end
]]
    end

    return code
end

-- ═══════════════════════════════════════════════════════════════════
-- EVENTOS DOS BOTÕES
-- ═══════════════════════════════════════════════════════════════════
GenerateCodeBtn.MouseButton1Click:Connect(function()
    local code = GenerateAnimationCode()
    CodeText.Text = code
    CodeScroll.CanvasSize = UDim2.new(0, 0, 0, #code * 0.5)
    CreateNotification("Código Gerado", "Código Lua gerado com sucesso!", "success", 3)
end)

CopyCodeBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(CodeText.Text)
        CreateNotification("Copiado!", "Código copiado para a área de transferência", "success", 2)
    else
        CreateNotification("Erro", "Função de copiar não disponível", "error", 3)
    end
end)

CreateScriptBtn.MouseButton1Click:Connect(function()
    -- Tentar criar script diretamente no explorer
    local success, err = pcall(function()
        local newScript
        
        if SelectedScriptType == "LocalScript" then
            newScript = Instance.new("LocalScript")
        elseif SelectedScriptType == "Script" then
            newScript = Instance.new("Script")
        else
            newScript = Instance.new("ModuleScript")
        end
        
        newScript.Name = AnimNameInput.Text ~= "" and AnimNameInput.Text or "MortalAnimation"
        newScript.Source = GenerateAnimationCode()
        
        -- Tentar colocar no objeto animado
        if MortalAnimator.CurrentObject then
            newScript.Parent = MortalAnimator.CurrentObject
        else
            newScript.Parent = Workspace
        end
        
        CreateNotification("Script Criado!", newScript.Name .. " criado no Explorer", "success", 3)
    else
        CreateNotification("Erro", "Função de salvar arquivo não disponível", "error", 3)
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- BOTÃO DE EXPORT NA TOOLBAR
-- ═══════════════════════════════════════════════════════════════════
local ExportBtn = CreateToolbarButton("Export", "📤", "Exportar Animação", function()
    ExportMenu.Visible = true
    ExportMenu.Size = UDim2.new(0, 0, 0, 0)
    Tween(ExportMenu, {Size = UDim2.new(0, 650, 0, 500)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

print("✅ Mortal Animator - Parte 8 carregada com sucesso!")
print("📦 Aguardando próxima parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 9: ATALHOS DE TECLADO E GIZMOS
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- SISTEMA DE ATALHOS DE TECLADO
-- ═══════════════════════════════════════════════════════════════════
local KeyboardShortcuts = {
    -- Playback
    {Key = Enum.KeyCode.Space, Action = "PlayPause", Description = "Play/Pause"},
    {Key = Enum.KeyCode.Return, Action = "Stop", Description = "Parar"},
    
    -- Navegação
    {Key = Enum.KeyCode.Left, Action = "PrevFrame", Description = "Frame Anterior"},
    {Key = Enum.KeyCode.Right, Action = "NextFrame", Description = "Próximo Frame"},
    {Key = Enum.KeyCode.Home, Action = "GoToStart", Description = "Ir para Início"},
    {Key = Enum.KeyCode.End, Action = "GoToEnd", Description = "Ir para Fim"},
    
    -- Ferramentas
    {Key = Enum.KeyCode.M, Action = "MoveTool", Description = "Ferramenta Mover"},
    {Key = Enum.KeyCode.R, Action = "RotateTool", Description = "Ferramenta Rotacionar"},
    {Key = Enum.KeyCode.S, Action = "ScaleTool", Description = "Ferramenta Escalar"},
    
    -- Keyframes
    {Key = Enum.KeyCode.K, Action = "AddKeyframe", Description = "Adicionar Keyframe"},
    {Key = Enum.KeyCode.Delete, Action = "DeleteKeyframe", Description = "Deletar Keyframe"},
    {Key = Enum.KeyCode.A, Action = "ToggleAutoKey", Description = "Auto Keyframe"},
    
    -- Edição
    {Key = Enum.KeyCode.Z, Ctrl = true, Action = "Undo", Description = "Desfazer"},
    {Key = Enum.KeyCode.Y, Ctrl = true, Action = "Redo", Description = "Refazer"},
    {Key = Enum.KeyCode.C, Ctrl = true, Action = "Copy", Description = "Copiar"},
    {Key = Enum.KeyCode.V, Ctrl = true, Action = "Paste", Description = "Colar"},
    {Key = Enum.KeyCode.D, Ctrl = true, Action = "Duplicate", Description = "Duplicar"},
    
    -- View
    {Key = Enum.KeyCode.L, Action = "ToggleLoop", Description = "Alternar Loop"},
    {Key = Enum.KeyCode.O, Action = "ToggleOnion", Description = "Onion Skinning"},
    {Key = Enum.KeyCode.G, Action = "ToggleSnap", Description = "Snap to Grid"},
    {Key = Enum.KeyCode.I, Action = "ToggleIK", Description = "Inverse Kinematics"},
    
    -- Geral
    {Key = Enum.KeyCode.E, Action = "OpenEasing", Description = "Abrir Easing"},
    {Key = Enum.KeyCode.F, Action = "FocusSelected", Description = "Focar Selecionado"},
    {Key = Enum.KeyCode.H, Action = "ToggleUI", Description = "Esconder/Mostrar UI"}
}

local function ExecuteShortcut(action)
    if action == "PlayPause" then
        if MortalAnimator.IsPlaying then
            PausePlayback()
        else
            StartPlayback()
        end
    elseif action == "Stop" then
        StopPlayback()
    elseif action == "PrevFrame" then
        MortalAnimator.CurrentFrame = math.max(0, MortalAnimator.CurrentFrame - 1)
        ApplyCurrentFrame()
        UpdatePlayhead()
    elseif action == "NextFrame" then
        MortalAnimator.CurrentFrame = MortalAnimator.CurrentFrame + 1
        ApplyCurrentFrame()
        UpdatePlayhead()
    elseif action == "GoToStart" then
        MortalAnimator.CurrentFrame = 0
        UpdatePlayhead()
    elseif action == "GoToEnd" then
        CalculateTotalFrames()
        MortalAnimator.CurrentFrame = MortalAnimator.TotalFrames
        UpdatePlayhead()
    elseif action == "MoveTool" then
        MortalAnimator.CurrentTool = "Move"
        CreateNotification("Ferramenta", "Modo Mover ativado", "success", 1.5)
    elseif action == "RotateTool" then
        MortalAnimator.CurrentTool = "Rotate"
        CreateNotification("Ferramenta", "Modo Rotacionar ativado", "success", 1.5)
    elseif action == "ScaleTool" then
        MortalAnimator.CurrentTool = "Scale"
        CreateNotification("Ferramenta", "Modo Escalar ativado", "success", 1.5)
    elseif action == "AddKeyframe" then
        if MortalAnimator.SelectedPart then
            for trackIndex, track in pairs(TracksData) do
                if track.PartRef == MortalAnimator.SelectedPart then
                    AddKeyframeToTrack(trackIndex, MortalAnimator.CurrentFrame)
                    break
                end
            end
        end
    elseif action == "DeleteKeyframe" then
        for _, sel in ipairs(KeyframeSystem.SelectedKeyframes) do
            RemoveKeyframe(sel.TrackIndex, sel.Frame)
        end
        KeyframeSystem.SelectedKeyframes = {}
    elseif action == "ToggleAutoKey" then
        MortalAnimator.AutoKeyframe = not MortalAnimator.AutoKeyframe
        CreateNotification("Auto Key", MortalAnimator.AutoKeyframe and "Ativado" or "Desativado", "success", 1.5)
    elseif action == "Undo" then
        Undo()
    elseif action == "Redo" then
        Redo()
    elseif action == "Copy" then
        CopySelectedKeyframes()
    elseif action == "Paste" then
        PasteKeyframes()
    elseif action == "Duplicate" then
        CopySelectedKeyframes()
        PasteKeyframes(MortalAnimator.CurrentFrame + 10)
    elseif action == "ToggleLoop" then
        MortalAnimator.LoopAnimation = not MortalAnimator.LoopAnimation
        CreateNotification("Loop", MortalAnimator.LoopAnimation and "Ativado" or "Desativado", "success", 1.5)
    elseif action == "ToggleOnion" then
        MortalAnimator.OnionSkinning = not MortalAnimator.OnionSkinning
        CreateNotification("Onion Skin", MortalAnimator.OnionSkinning and "Ativado" or "Desativado", "success", 1.5)
    elseif action == "ToggleSnap" then
        MortalAnimator.SnapToGrid = not MortalAnimator.SnapToGrid
        CreateNotification("Snap", MortalAnimator.SnapToGrid and "Ativado" or "Desativado", "success", 1.5)
    elseif action == "ToggleIK" then
        MortalAnimator.IKEnabled = not MortalAnimator.IKEnabled
        CreateNotification("IK", MortalAnimator.IKEnabled and "Ativado" or "Desativado", "success", 1.5)
    elseif action == "OpenEasing" then
        EasingSelector.Visible = true
        Tween(EasingSelector, {Size = UDim2.new(0, 400, 0, 350)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    elseif action == "FocusSelected" then
        if MortalAnimator.SelectedPart then
            Camera.CFrame = CFrame.new(
                MortalAnimator.SelectedPart.Position + Vector3.new(5, 5, 5),
                MortalAnimator.SelectedPart.Position
            )
        end
    elseif action == "ToggleUI" then
        MainContainer.Visible = not MainContainer.Visible
    end
end

-- Listener de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local ctrlHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or 
                     UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
    local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or 
                      UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
    
    for _, shortcut in ipairs(KeyboardShortcuts) do
        if input.KeyCode == shortcut.Key then
            if shortcut.Ctrl and not ctrlHeld then continue end
            if shortcut.Shift and not shiftHeld then continue end
            if not shortcut.Ctrl and ctrlHeld then continue end
            
            ExecuteShortcut(shortcut.Action)
            break
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- MENU DE ATALHOS
-- ═══════════════════════════════════════════════════════════════════
local ShortcutsMenu = CreateInstance("Frame", {
    Name = "ShortcutsMenu",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 450, 0, 500),
    Visible = false,
    ZIndex = 90,
    Parent = ScreenGui
})
CreateCorner(ShortcutsMenu, 16)
CreateStroke(ShortcutsMenu, Theme.Accent, 2, 0.3)
CreateShadow(ShortcutsMenu, 50, 0.4)

local ShortcutsHeader = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 50),
    BorderSizePixel = 0,
    ZIndex = 91,
    Parent = ShortcutsMenu
})
CreateCorner(ShortcutsHeader, 16)

local ShortcutsTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 0),
    Size = UDim2.new(1, -70, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "⌨️ Atalhos de Teclado",
    TextColor3 = Theme.TextPrimary,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 91,
    Parent = ShortcutsHeader
})

local CloseShortcutsBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(1, -45, 0.5, -15),
    Size = UDim2.new(0, 30, 0, 30),
    Text = "✕",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    ZIndex = 91,
    Parent = ShortcutsHeader
})
CreateCorner(CloseShortcutsBtn, 6)

CloseShortcutsBtn.MouseButton1Click:Connect(function()
    Tween(ShortcutsMenu, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
    task.wait(0.2)
    ShortcutsMenu.Visible = false
end)

local ShortcutsScroll = CreateInstance("ScrollingFrame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 60),
    Size = UDim2.new(1, -20, 1, -70),
    CanvasSize = UDim2.new(0, 0, 0, #KeyboardShortcuts * 35),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Accent,
    ZIndex = 91,
    Parent = ShortcutsMenu
})

local ShortcutsLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 5),
    Parent = ShortcutsScroll
})

for _, shortcut in ipairs(KeyboardShortcuts) do
    local item = CreateInstance("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 30),
        ZIndex = 92,
        Parent = ShortcutsScroll
    })
    CreateCorner(item, 6)
    
    local keyText = shortcut.Key.Name
    if shortcut.Ctrl then keyText = "Ctrl + " .. keyText end
    if shortcut.Shift then keyText = "Shift + " .. keyText end
    
    local keyLabel = CreateInstance("TextLabel", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 8, 0.5, -10),
        Size = UDim2.new(0, 90, 0, 20),
        Font = Enum.Font.Code,
        Text = keyText,
        TextColor3 = Theme.TextPrimary,
        TextSize = 10,
        ZIndex = 93,
        Parent = item
    })
    CreateCorner(keyLabel, 4)
    
    local descLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 110, 0, 0),
        Size = UDim2.new(1, -120, 1, 0),
        Font = Enum.Font.Gotham,
        Text = shortcut.Description,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 93,
        Parent = item
    })
end

-- Botão para abrir menu de atalhos
local ShortcutsBtn = CreateToolbarButton("Shortcuts", "⌨️", "Atalhos de Teclado (?)", function()
    ShortcutsMenu.Visible = true
    ShortcutsMenu.Size = UDim2.new(0, 0, 0, 0)
    Tween(ShortcutsMenu, {Size = UDim2.new(0, 450, 0, 500)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- ═══════════════════════════════════════════════════════════════════
-- SISTEMA DE GIZMOS 3D
-- ═══════════════════════════════════════════════════════════════════
local GizmoSystem = {
    Active = false,
    CurrentGizmo = nil,
    DraggingAxis = nil,
    OriginalCFrame = nil,
    OriginalMousePos = nil,
    Sensitivity = 0.1
}

local GizmoColors = {
    X = Color3.fromRGB(255, 80, 80),
    Y = Color3.fromRGB(80, 255, 80),
    Z = Color3.fromRGB(80, 80, 255),
    Center = Color3.fromRGB(255, 255, 100)
}

-- Container para os gizmos
local GizmoFolder = Instance.new("Folder")
GizmoFolder.Name = "MortalAnimatorGizmos"
GizmoFolder.Parent = Workspace

-- Criar gizmo de movimento
function CreateMoveGizmo()
    local gizmo = Instance.new("Model")
    gizmo.Name = "MoveGizmo"
    
    -- Eixo X (Vermelho)
    local xAxis = Instance.new("Part")
    xAxis.Name = "X"
    xAxis.Size = Vector3.new(2, 0.1, 0.1)
    xAxis.Color = GizmoColors.X
    xAxis.Material = Enum.Material.Neon
    xAxis.Anchored = true
    xAxis.CanCollide = false
    xAxis.Parent = gizmo
    
    local xArrow = Instance.new("Part")
    xArrow.Name = "XArrow"
    xArrow.Size = Vector3.new(0.3, 0.3, 0.3)
    xArrow.Color = GizmoColors.X
    xArrow.Material = Enum.Material.Neon
    xArrow.Anchored = true
    xArrow.CanCollide = false
    xArrow.Shape = Enum.PartType.Ball
    xArrow.Parent = gizmo
    
    -- Eixo Y (Verde)
    local yAxis = Instance.new("Part")
    yAxis.Name = "Y"
    yAxis.Size = Vector3.new(0.1, 2, 0.1)
    yAxis.Color = GizmoColors.Y
    yAxis.Material = Enum.Material.Neon
    yAxis.Anchored = true
    yAxis.CanCollide = false
    yAxis.Parent = gizmo
    
    local yArrow = Instance.new("Part")
    yArrow.Name = "YArrow"
    yArrow.Size = Vector3.new(0.3, 0.3, 0.3)
    yArrow.Color = GizmoColors.Y
    yArrow.Material = Enum.Material.Neon
    yArrow.Anchored = true
    yArrow.CanCollide = false
    yArrow.Shape = Enum.PartType.Ball
    yArrow.Parent = gizmo
    
    -- Eixo Z (Azul)
    local zAxis = Instance.new("Part")
    zAxis.Name = "Z"
    zAxis.Size = Vector3.new(0.1, 0.1, 2)
    zAxis.Color = GizmoColors.Z
    zAxis.Material = Enum.Material.Neon
    zAxis.Anchored = true
    zAxis.CanCollide = false
    zAxis.Parent = gizmo
    
    local zArrow = Instance.new("Part")
    zArrow.Name = "ZArrow"
    zArrow.Size = Vector3.new(0.3, 0.3, 0.3)
    zArrow.Color = GizmoColors.Z
    zArrow.Material = Enum.Material.Neon
    zArrow.Anchored = true
    zArrow.CanCollide = false
    zArrow.Shape = Enum.PartType.Ball
    zArrow.Parent = gizmo
    
    -- Centro
    local center = Instance.new("Part")
    center.Name = "Center"
    center.Size = Vector3.new(0.4, 0.4, 0.4)
    center.Color = GizmoColors.Center
    center.Material = Enum.Material.Neon
    center.Anchored = true
    center.CanCollide = false
    center.Shape = Enum.PartType.Ball
    center.Parent = gizmo
    
    gizmo.Parent = GizmoFolder
    
    return gizmo
end

-- Criar gizmo de rotação
function CreateRotateGizmo()
    local gizmo = Instance.new("Model")
    gizmo.Name = "RotateGizmo"
    
    local function CreateRing(name, color, rotation)
        local ring = Instance.new("Part")
        ring.Name = name
        ring.Size = Vector3.new(3, 0.1, 3)
        ring.Color = color
        ring.Material = Enum.Material.Neon
        ring.Transparency = 0.3
        ring.Anchored = true
        ring.CanCollide = false
        ring.Shape = Enum.PartType.Cylinder
        ring.CFrame = rotation
        ring.Parent = gizmo
        
        -- Adicionar mesh para parecer um anel
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Cylinder
        mesh.Scale = Vector3.new(0.1, 1, 1)
        mesh.Parent = ring
        
        return ring
    end
    
    CreateRing("X", GizmoColors.X, CFrame.Angles(0, 0, math.rad(90)))
    CreateRing("Y", GizmoColors.Y, CFrame.Angles(0, 0, 0))
    CreateRing("Z", GizmoColors.Z, CFrame.Angles(math.rad(90), 0, 0))
    
    gizmo.Parent = GizmoFolder
    
    return gizmo
end

-- Criar gizmo de escala
function CreateScaleGizmo()
    local gizmo = Instance.new("Model")
    gizmo.Name = "ScaleGizmo"
    
    -- Similar ao move, mas com cubos nas pontas
    local function CreateScaleAxis(name, color, direction)
        local axis = Instance.new("Part")
        axis.Name = name
        axis.Size = direction * 1.5 + Vector3.new(0.08, 0.08, 0.08)
        axis.Color = color
        axis.Material = Enum.Material.Neon
        axis.Anchored = true
        axis.CanCollide = false
        axis.Parent = gizmo
        
        local cube = Instance.new("Part")
        cube.Name = name .. "Cube"
        cube.Size = Vector3.new(0.25, 0.25, 0.25)
        cube.Color = color
        cube.Material = Enum.Material.Neon
        cube.Anchored = true
        cube.CanCollide = false
        cube.Parent = gizmo
        
        return axis, cube
    end
    
    CreateScaleAxis("X", GizmoColors.X, Vector3.new(1, 0, 0))
    CreateScaleAxis("Y", GizmoColors.Y, Vector3.new(0, 1, 0))
    CreateScaleAxis("Z", GizmoColors.Z, Vector3.new(0, 0, 1))
    
    -- Centro para escala uniforme
    local center = Instance.new("Part")
    center.Name = "Center"
    center.Size = Vector3.new(0.35, 0.35, 0.35)
    center.Color = GizmoColors.Center
    center.Material = Enum.Material.Neon
    center.Anchored = true
    center.CanCollide = false
    center.Parent = gizmo
    
    gizmo.Parent = GizmoFolder
    
    return gizmo
end

-- Atualizar posição do gizmo
function UpdateGizmoPosition()
    if not MortalAnimator.SelectedPart then
        -- Esconder gizmos
        for _, child in pairs(GizmoFolder:GetChildren()) do
            for _, part in pairs(child:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
        return
    end
    
    local targetCFrame = MortalAnimator.SelectedPart.CFrame
    local targetPos = targetCFrame.Position
    
    -- Atualizar gizmo baseado na ferramenta atual
    for _, gizmo in pairs(GizmoFolder:GetChildren()) do
        local isActive = (gizmo.Name == "MoveGizmo" and MortalAnimator.CurrentTool == "Move") or
                        (gizmo.Name == "RotateGizmo" and MortalAnimator.CurrentTool == "Rotate") or
                        (gizmo.Name == "ScaleGizmo" and MortalAnimator.CurrentTool == "Scale")
        
        for _, part in pairs(gizmo:GetDescendants()) do
            if part:IsA("BasePart") then
                if isActive then
                    part.Transparency = part.Name == "Center" and 0 or 0.2
                    
                    -- Posicionar
                    if part.Name == "X" then
                        part.CFrame = CFrame.new(targetPos + Vector3.new(1, 0, 0))
                    elseif part.Name == "XArrow" or part.Name == "XCube" then
                        part.Position = targetPos + Vector3.new(2, 0, 0)
                    elseif part.Name == "Y" then
                        part.CFrame = CFrame.new(targetPos + Vector3.new(0, 1, 0))
                    elseif part.Name == "YArrow" or part.Name == "YCube" then
                        part.Position = targetPos + Vector3.new(0, 2, 0)
                    elseif part.Name == "Z" then
                        part.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, 1))
                    elseif part.Name == "ZArrow" or part.Name == "ZCube" then
                        part.Position = targetPos + Vector3.new(0, 0, 2)
                    elseif part.Name == "Center" then
                        part.Position = targetPos
                    end
                else
                    part.Transparency = 1
                end
            end
        end
    end
end

-- Criar os gizmos
local MoveGizmo = CreateMoveGizmo()
local RotateGizmo = CreateRotateGizmo()
local ScaleGizmo = CreateScaleGizmo()

-- ═══════════════════════════════════════════════════════════════════
-- MANIPULAÇÃO COM MOUSE/TOUCH
-- ═══════════════════════════════════════════════════════════════════
local isDraggingGizmo = false
local dragAxis = nil
local dragStartPos = nil
local originalTransform = nil

function GetAxisFromPart(part)
    if part then
        local name = part.Name
        if name == "X" or name == "XArrow" or name == "XCube" then
            return "X", Vector3.new(1, 0, 0)
        elseif name == "Y" or name == "YArrow" or name == "YCube" then
            return "Y", Vector3.new(0, 1, 0)
        elseif name == "Z" or name == "ZArrow" or name == "ZCube" then
            return "Z", Vector3.new(0, 0, 1)
        elseif name == "Center" then
            return "All", Vector3.new(1, 1, 1)
        end
    end
    return nil, nil
end

function StartGizmoDrag(part)
    if not MortalAnimator.SelectedPart then return end
    
    local axis, direction = GetAxisFromPart(part)
    if not axis then return end
    
    isDraggingGizmo = true
    dragAxis = axis
    dragStartPos = Mouse.Hit.Position
    originalTransform = {
        CFrame = MortalAnimator.SelectedPart.CFrame,
        Size = MortalAnimator.SelectedPart.Size
    }
    
    -- Highlight do eixo
    part.Material = Enum.Material.ForceField
end

function UpdateGizmoDrag()
    if not isDraggingGizmo or not MortalAnimator.SelectedPart then return end
    
    local currentPos = Mouse.Hit.Position
    local delta = currentPos - dragStartPos
    
    if MortalAnimator.CurrentTool == "Move" then
        local newPos = originalTransform.CFrame.Position
        
        if dragAxis == "X" then
            newPos = newPos + Vector3.new(delta.X, 0, 0)
        elseif dragAxis == "Y" then
            newPos = newPos + Vector3.new(0, delta.Y, 0)
        elseif dragAxis == "Z" then
            newPos = newPos + Vector3.new(0, 0, delta.Z)
        elseif dragAxis == "All" then
            newPos = newPos + delta
        end
        
        -- Snap to grid
        if MortalAnimator.SnapToGrid then
            local gridSize = MortalAnimator.GridSize
            newPos = Vector3.new(
                math.round(newPos.X / gridSize) * gridSize,
                math.round(newPos.Y / gridSize) * gridSize,
                math.round(newPos.Z / gridSize) * gridSize
            )
        end
        
        MortalAnimator.SelectedPart.CFrame = CFrame.new(newPos) * (originalTransform.CFrame - originalTransform.CFrame.Position)
        
    elseif MortalAnimator.CurrentTool == "Rotate" then
        local rotationAmount = delta.Magnitude * GizmoSystem.Sensitivity
        
        local rotation = CFrame.new()
        if dragAxis == "X" then
            rotation = CFrame.Angles(rotationAmount, 0, 0)
        elseif dragAxis == "Y" then
            rotation = CFrame.Angles(0, rotationAmount, 0)
        elseif dragAxis == "Z" then
            rotation = CFrame.Angles(0, 0, rotationAmount)
        end
        
        MortalAnimator.SelectedPart.CFrame = originalTransform.CFrame * rotation
        
    elseif MortalAnimator.CurrentTool == "Scale" then
        local scaleAmount = 1 + delta.Y * GizmoSystem.Sensitivity
        scaleAmount = math.clamp(scaleAmount, 0.1, 10)
        
        local newSize = originalTransform.Size
        
        if dragAxis == "X" then
            newSize = Vector3.new(originalTransform.Size.X * scaleAmount, newSize.Y, newSize.Z)
        elseif dragAxis == "Y" then
            newSize = Vector3.new(newSize.X, originalTransform.Size.Y * scaleAmount, newSize.Z)
        elseif dragAxis == "Z" then
            newSize = Vector3.new(newSize.X, newSize.Y, originalTransform.Size.Z * scaleAmount)
        elseif dragAxis == "All" then
            newSize = originalTransform.Size * scaleAmount
        end
        
        MortalAnimator.SelectedPart.Size = newSize
    end
    
    -- Auto keyframe
    if MortalAnimator.AutoKeyframe then
        for trackIndex, track in pairs(TracksData) do
            if track.PartRef == MortalAnimator.SelectedPart then
                AddKeyframeToTrack(trackIndex, MortalAnimator.CurrentFrame)
                break
            end
        end
    end
end

function EndGizmoDrag()
    isDraggingGizmo = false
    dragAxis = nil
    
    -- Restaurar material dos gizmos
    for _, gizmo in pairs(GizmoFolder:GetChildren()) do
        for _, part in pairs(gizmo:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.Neon
            end
        end
    end
end

-- Eventos de mouse para gizmos
Mouse.Button1Down:Connect(function()
    local target = Mouse.Target
    if target and target.Parent and target.Parent.Parent == GizmoFolder then
        StartGizmoDrag(target)
    end
end)

Mouse.Button1Up:Connect(function()
    if isDraggingGizmo then
        EndGizmoDrag()
    end
end)

Mouse.Move:Connect(function()
    if isDraggingGizmo then
        UpdateGizmoDrag()
    end
    
    -- Highlight ao passar o mouse
    local target = Mouse.Target
    if target and target.Parent and target.Parent.Parent == GizmoFolder then
        target.Transparency = 0
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- SELEÇÃO COM CLICK
-- ═══════════════════════════════════════════════════════════════════
Mouse.Button1Down:Connect(function()
    if isDraggingGizmo then return end
    
    local target = Mouse.Target
    if not target then return end
    
    -- Verificar se clicou em um gizmo
    if target.Parent and target.Parent.Parent == GizmoFolder then
        return
    end
    
    -- Verificar se é uma parte do objeto atual
    if MortalAnimator.CurrentObject then
        if target:IsDescendantOf(MortalAnimator.CurrentObject) or target == MortalAnimator.CurrentObject then
            MortalAnimator.SelectedPart = target
            
            -- Atualizar hierarquia
            for _, child in pairs(HierarchyScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundTransparency = 0.5
                    child.BackgroundColor3 = Theme.Tertiary
                end
            end
            
            -- Destacar na lista
            for _, child in pairs(HierarchyScroll:GetChildren()) do
                if child.Name == target.Name then
                    child.BackgroundTransparency = 0
                    child.BackgroundColor3 = Theme.Accent
                    break
                end
            end
            
            CreateNotification("Selecionado", target.Name, "success", 1.5)
            UpdateGizmoPosition()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- ATUALIZAÇÃO CONTÍNUA DOS GIZMOS
-- ═══════════════════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    UpdateGizmoPosition()
end)

-- ═══════════════════════════════════════════════════════════════════
-- CONTROLES MOBILE PARA TRANSFORMAÇÃO
-- ═══════════════════════════════════════════════════════════════════
if IsMobile() then
    local MobileTransformPanel = CreateInstance("Frame", {
        Name = "MobileTransformPanel",
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0.5, -150, 1, -80),
        Size = UDim2.new(0, 300, 0, 70),
        ZIndex = 100,
        Parent = ScreenGui
    })
    CreateCorner(MobileTransformPanel, 12)
    CreateStroke(MobileTransformPanel, Theme.Accent, 1, 0.5)
    
    local MobileTransformLayout = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        Parent = MobileTransformPanel
    })
    
    local function CreateMobileTransformBtn(icon, axis, tool)
        local btn = CreateInstance("TextButton", {
            BackgroundColor3 = Theme.Tertiary,
            Size = UDim2.new(0, 50, 0, 50),
            Text = icon,
            TextSize = 24,
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.TextPrimary,
            ZIndex = 101,
            Parent = MobileTransformPanel
        })
        CreateCorner(btn, 10)
        
        local isPressed = false
        
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isPressed = true
                MortalAnimator.CurrentTool = tool
                btn.BackgroundColor3 = Theme.Accent
            end
        end)
        
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isPressed = false
                btn.BackgroundColor3 = Theme.Tertiary
            end
        end)
        
        return btn
    end
    
    CreateMobileTransformBtn("↔️", "Move", "Move")
    CreateMobileTransformBtn("🔄", "Rotate", "Rotate")
    CreateMobileTransformBtn("📐", "Scale", "Scale")
    CreateMobileTransformBtn("🔑", "Key", "Key")
    CreateMobileTransformBtn("▶️", "Play", "Play")
end

print("✅ Mortal Animator - Parte 9 carregada com sucesso!")
print("📦 Aguardando última parte...")

-- ═══════════════════════════════════════════════════════════════════
-- PARTE 10: FINALIZAÇÃO E INTEGRAÇÃO
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- MENU DE CONFIGURAÇÕES
-- ═══════════════════════════════════════════════════════════════════
local SettingsMenu = CreateInstance("Frame", {
    Name = "SettingsMenu",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 400, 0, 450),
    Visible = false,
    ZIndex = 95,
    Parent = ScreenGui
})
CreateCorner(SettingsMenu, 16)
CreateStroke(SettingsMenu, Theme.Accent, 2, 0.3)
CreateShadow(SettingsMenu, 50, 0.4)

local SettingsMenuHeader = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 50),
    BorderSizePixel = 0,
    ZIndex = 96,
    Parent = SettingsMenu
})
CreateCorner(SettingsMenuHeader, 16)

local SettingsMenuTitle = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 0),
    Size = UDim2.new(1, -70, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "⚙️ Configurações",
    TextColor3 = Theme.TextPrimary,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 96,
    Parent = SettingsMenuHeader
})

local CloseSettingsBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(1, -45, 0.5, -15),
    Size = UDim2.new(0, 30, 0, 30),
    Text = "✕",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    ZIndex = 96,
    Parent = SettingsMenuHeader
})
CreateCorner(CloseSettingsBtn, 6)

CloseSettingsBtn.MouseButton1Click:Connect(function()
    Tween(SettingsMenu, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
    task.wait(0.2)
    SettingsMenu.Visible = false
end)

local SettingsScroll2 = CreateInstance("ScrollingFrame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 60),
    Size = UDim2.new(1, -20, 1, -70),
    CanvasSize = UDim2.new(0, 0, 0, 500),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Accent,
    ZIndex = 96,
    Parent = SettingsMenu
})

local SettingsLayout2 = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 10),
    Parent = SettingsScroll2
})

-- Função para criar toggle de configuração
local function CreateSettingToggle(name, description, defaultValue, onChange)
    local frame = CreateInstance("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 60),
        ZIndex = 97,
        Parent = SettingsScroll2
    })
    CreateCorner(frame, 8)
    
    local nameLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -80, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 97,
        Parent = frame
    })
    
    local descLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 32),
        Size = UDim2.new(1, -80, 0, 18),
        Font = Enum.Font.Gotham,
        Text = description,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 97,
        Parent = frame
    })
    
    local toggleBtn = CreateInstance("TextButton", {
        BackgroundColor3 = defaultValue and Theme.Success or Theme.Secondary,
        Position = UDim2.new(1, -60, 0.5, -12),
        Size = UDim2.new(0, 45, 0, 24),
        Text = defaultValue and "ON" or "OFF",
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        ZIndex = 98,
        Parent = frame
    })
    CreateCorner(toggleBtn, 12)
    
    local isOn = defaultValue
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggleBtn.Text = isOn and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = isOn and Theme.Success or Theme.Secondary
        if onChange then onChange(isOn) end
    end)
    
    return frame
end

-- Função para criar slider de configuração
local function CreateSettingSlider(name, description, min, max, default, onChange)
    local frame = CreateInstance("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 75),
        ZIndex = 97,
        Parent = SettingsScroll2
    })
    CreateCorner(frame, 8)
    
    local nameLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(1, -80, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 97,
        Parent = frame
    })
    
    local valueLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 8),
        Size = UDim2.new(0, 50, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = tostring(default),
        TextColor3 = Theme.Accent,
        TextSize = 12,
        ZIndex = 97,
        Parent = frame
    })
    
    local descLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 28),
        Size = UDim2.new(1, -30, 0, 16),
        Font = Enum.Font.Gotham,
        Text = description,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 97,
        Parent = frame
    })
    
    local sliderBg = CreateInstance("Frame", {
        BackgroundColor3 = Theme.Primary,
        Position = UDim2.new(0, 15, 0, 50),
        Size = UDim2.new(1, -30, 0, 12),
        ZIndex = 97,
        Parent = frame
    })
    CreateCorner(sliderBg, 6)
    
    local sliderFill = CreateInstance("Frame", {
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        ZIndex = 98,
        Parent = sliderBg
    })
    CreateCorner(sliderFill, 6)
    
    local sliderDragger = CreateInstance("TextButton", {
        BackgroundColor3 = Theme.AccentLight,
        Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Text = "",
        ZIndex = 99,
        Parent = sliderBg
    })
    CreateCorner(sliderDragger, 8)
    
    local isDragging = false
    
    sliderDragger.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = input.Position.X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            value = math.round(value * 10) / 10
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderDragger.Position = UDim2.new(percent, -8, 0.5, -8)
            valueLabel.Text = tostring(value)
            
            if onChange then onChange(value) end
        end
    end)
    
    return frame
end

-- Criar configurações
CreateSettingToggle("Auto Keyframe", "Criar keyframe automaticamente ao mover", false, function(v)
    MortalAnimator.AutoKeyframe = v
end)

CreateSettingToggle("Onion Skinning", "Mostrar frames anteriores/posteriores", false, function(v)
    MortalAnimator.OnionSkinning = v
end)

CreateSettingToggle("Snap to Grid", "Encaixar na grade ao mover", false, function(v)
    MortalAnimator.SnapToGrid = v
end)

CreateSettingToggle("Loop Animation", "Repetir animação continuamente", false, function(v)
    MortalAnimator.LoopAnimation = v
end)

CreateSettingToggle("Show Bones", "Mostrar estrutura de ossos", true, function(v)
    MortalAnimator.ShowBones = v
end)

CreateSettingSlider("Grid Size", "Tamanho da grade para snap", 0.1, 2, 0.5, function(v)
    MortalAnimator.GridSize = v
end)

CreateSettingSlider("Ghost Frames", "Quantidade de frames fantasma", 1, 10, 3, function(v)
    MortalAnimator.GhostingFrames = math.round(v)
end)

CreateSettingSlider("Gizmo Sensitivity", "Sensibilidade do gizmo", 0.01, 0.5, 0.1, function(v)
    GizmoSystem.Sensitivity = v
end)

-- Botão de configurações na toolbar
local SettingsBtn = CreateToolbarButton("Settings", "⚙️", "Configurações", function()
    SettingsMenu.Visible = true
    SettingsMenu.Size = UDim2.new(0, 0, 0, 0)
    Tween(SettingsMenu, {Size = UDim2.new(0, 400, 0, 450)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- ═══════════════════════════════════════════════════════════════════
-- MENU SOBRE/CRÉDITOS
-- ═══════════════════════════════════════════════════════════════════
local AboutMenu = CreateInstance("Frame", {
    Name = "AboutMenu",
    BackgroundColor3 = Theme.Primary,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 380, 0, 350),
    Visible = false,
    ZIndex = 95,
    Parent = ScreenGui
})
CreateCorner(AboutMenu, 16)
CreateStroke(AboutMenu, Theme.Accent, 2, 0.3)
CreateShadow(AboutMenu, 50, 0.4)

local AboutHeader = CreateInstance("Frame", {
    BackgroundColor3 = Theme.Secondary,
    Size = UDim2.new(1, 0, 0, 50),
    BorderSizePixel = 0,
    ZIndex = 96,
    Parent = AboutMenu
})
CreateCorner(AboutHeader, 16)

local CloseAboutBtn = CreateInstance("TextButton", {
    BackgroundColor3 = Theme.Tertiary,
    Position = UDim2.new(1, -45, 0.5, -15),
    Size = UDim2.new(0, 30, 0, 30),
    Text = "✕",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.TextSecondary,
    ZIndex = 96,
    Parent = AboutHeader
})
CreateCorner(CloseAboutBtn, 6)

CloseAboutBtn.MouseButton1Click:Connect(function()
    Tween(AboutMenu, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
    task.wait(0.2)
    AboutMenu.Visible = false
end)

local AboutContent = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 60),
    Size = UDim2.new(1, -40, 1, -70),
    ZIndex = 96,
    Parent = AboutMenu
})

local AboutLogo = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 50),
    Font = Enum.Font.GothamBold,
    Text = "☠️ Mortal Animator☠️",
    TextColor3 = Theme.TextPrimary,
    TextSize = 24,
    ZIndex = 96,
    Parent = AboutContent
})
CreateGradient(AboutLogo, 0)

local AboutVersion = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 50),
    Size = UDim2.new(1, 0, 0, 25),
    Font = Enum.Font.GothamBold,
    Text = "V1⚡ • Professional Animation System",
    TextColor3 = Theme.Accent,
    TextSize = 14,
    ZIndex = 96,
    Parent = AboutContent
})

local AboutDesc = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 90),
    Size = UDim2.new(1, 0, 0, 80),
    Font = Enum.Font.Gotham,
    Text = "Animator profissional para Roblox Studio Lite.\n\nCrie animações fluidas de nível AAA para Rigs, Models, Parts, Tools e muito mais!\n\nCompatível com Delta Executor.",
    TextColor3 = Theme.TextSecondary,
    TextSize = 12,
    TextWrapped = true,
    TextYAlignment = Enum.TextYAlignment.Top,
    ZIndex = 96,
    Parent = AboutContent
})

local AboutFeatures = CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 180),
    Size = UDim2.new(1, 0, 0, 90),
    Font = Enum.Font.Gotham,
    Text = "✅ Timeline Infinita\n✅ Keyframes Avançados\n✅ Sistema de Cutscenes\n✅ Export para Scripts\n✅ 60-90 FPS Suave\n✅ Suporte Mobile & PC",
    TextColor3 = Theme.Success,
    TextSize = 11,
    TextWrapped = true,
    TextYAlignment = Enum.TextYAlignment.Top,
    ZIndex = 96,
    Parent = AboutContent
})

-- Botão sobre
local AboutBtn = CreateToolbarButton("About", "ℹ️", "Sobre", function()
    AboutMenu.Visible = true
    AboutMenu.Size = UDim2.new(0, 0, 0, 0)
    Tween(AboutMenu, {Size = UDim2.new(0, 380, 0, 350)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- ═══════════════════════════════════════════════════════════════════
-- RESPONSIVIDADE MOBILE
-- ═══════════════════════════════════════════════════════════════════
local function UpdateLayoutForMobile()
    if IsMobile() then
        MainContainer.Size = UDim2.new(0.98, 0, 0.9, 0)
        MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        -- Ajustar painéis para mobile
        LeftPanel.Size = UDim2.new(0, 180, 1, -50)
        RightPanel.Size = UDim2.new(0, 180, 1, -50)
        RightPanel.Position = UDim2.new(1, -180, 0, 50)
        
        -- Ajustar timeline
        TimelineContainer.Position = UDim2.new(0, 180, 1, -200)
        TimelineContainer.Size = UDim2.new(1, -360, 0, 150)
        
        -- Ajustar viewport
        ViewportArea.Size = UDim2.new(1, -360, 0, 200)
    end
end

UpdateLayoutForMobile()

-- ═══════════════════════════════════════════════════════════════════
-- LIMPEZA AO SAIR
-- ═══════════════════════════════════════════════════════════════════
local function Cleanup()
    -- Limpar gizmos
    if GizmoFolder then
        GizmoFolder:Destroy()
    end
    
    -- Limpar ghost parts
    for _, ghost in pairs(GhostParts) do
        if ghost and ghost.Parent then
            ghost:Destroy()
        end
    end
    
    -- Limpar marcadores de câmera
    for _, marker in pairs(CameraMarkers) do
        if marker and marker.Parent then
            marker:Destroy()
        end
    end
    
    -- Restaurar estados originais
    RestoreOriginalStates()
end

-- Conectar limpeza
game:BindToClose(Cleanup)
Player.CharacterRemoving:Connect(Cleanup)

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-SAVE (OPCIONAL)
-- ═══════════════════════════════════════════════════════════════════
local AutoSaveEnabled = false
local AutoSaveInterval = 60 -- segundos

if AutoSaveEnabled then
    task.spawn(function()
        while true do
            task.wait(AutoSaveInterval)
            if MortalAnimator.CurrentObject and #TracksData > 0 then
                local code = GenerateAnimationCode()
                if writefile then
                    writefile("MortalAnimator_AutoSave.lua", code)
                    CreateNotification("Auto-Save", "Animação salva automaticamente", "success", 2)
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- INICIALIZAÇÃO FINAL
-- ═══════════════════════════════════════════════════════════════════
local function Initialize()
    -- Animação de entrada do menu principal
    MainContainer.Size = UDim2.new(0, 0, 0, 0)
    MainContainer.Visible = true
    
    task.wait(0.2)
    
    local targetSize = IsMobile() and UDim2.new(0.98, 0, 0.9, 0) or UDim2.new(0, 1200, 0, 700)
    Tween(MainContainer, {Size = targetSize}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Atualizar régua de frames
    UpdateFrameRuler()
    
    -- Atualizar playhead
    UpdatePlayhead()
    
    print("═══════════════════════════════════════════════════════════")
    print("  ☠️ MORTAL ANIMATOR V1⚡ - CARREGADO COM SUCESSO!")
    print("═══════════════════════════════════════════════════════════")
    print("  📱 Mobile: " .. tostring(IsMobile()))
    print("  🎮 FPS Target: " .. MortalAnimator.FPS)
    print("  ⚡ Status: READY")
    print("═══════════════════════════════════════════════════════════")
end

-- Executar inicialização
Initialize()

-- ═══════════════════════════════════════════════════════════════════
-- COMANDOS DE DEBUG (OPCIONAL)
-- ═══════════════════════════════════════════════════════════════════
_G.MortalAnimator = MortalAnimator
_G.MortalAnimatorDebug = {
    GetTracksData = function() return TracksData end,
    GetKeyframes = function() return KeyframeSystem end,
    GetCutscene = function() return CutsceneSystem end,
    ForceRefresh = function()
        UpdateFrameRuler()
        UpdatePlayhead()
        UpdateGizmoPosition()
    end,
    TestNotification = function(msg)
        CreateNotification("Debug", msg or "Test", "success", 3)
    end
}

print("✅ Mortal Animator - Parte 10 (FINAL) carregada com sucesso!")
print("")
print("╔═══════════════════════════════════════════════════════════╗")
print("║  👑☠️ MORTAL ANIMATOR COMPLETO E PRONTO PARA USO! ☠️👑    ║")
print("║                                                           ║")
print("║  ⚡ Todas as 10 partes carregadas com sucesso!            ║")
print("║  📱 Compatível com PC e Mobile                            ║")
print("║  🎬 Sistema de Cutscenes incluído                         ║")
print("║  📤 Sistema de Export funcional                           ║")
print("║                                                           ║")
print("║  Aproveite essa ferramenta profissional! ⚡               ║")
print("╚═══════════════════════════════════════════════════════════╝")
