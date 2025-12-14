-- ⚡☠️ MORTAL PLUGINS V1 ☠️⚡
-- Menu Principal dos Plugins
-- Compatível com Delta Executor + Studio Lite
-- Suporte: Mobile e PC

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Detectar dispositivo
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Cores do tema
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentLight = Color3.fromRGB(180, 80, 255),
    Success = Color3.fromRGB(0, 255, 127),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Red = Color3.fromRGB(255, 50, 80),
    Gold = Color3.fromRGB(255, 215, 0),
    Gradient1 = Color3.fromRGB(138, 43, 226),
    Gradient2 = Color3.fromRGB(255, 0, 128)
}

-- Remover GUI anterior se existir
if playerGui:FindFirstChild("MortalPluginsGUI") then
    playerGui.MortalPluginsGUI:Destroy()
end

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MortalPluginsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Função para criar cantos arredondados
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Função para criar gradiente
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

-- Função para criar sombra
local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

-- Função para animação de hover
local function AddHoverEffect(button)
    local originalSize = button.Size
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 4, originalSize.Y.Scale, originalSize.Y.Offset + 2)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = originalSize
        }):Play()
    end)
end

-- Função para criar notificação
local function ShowNotification(title, message, duration)
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Size = UDim2.new(0, 320, 0, 90)
    notifFrame.Position = UDim2.new(1, 350, 1, -110)
    notifFrame.BackgroundColor3 = Colors.Secondary
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 100
    notifFrame.Parent = ScreenGui
    CreateCorner(notifFrame, 12)
    CreateShadow(notifFrame)
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = Colors.Accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notifFrame
    CreateCorner(accentBar, 12)
    CreateGradient(accentBar, Colors.Accent, Colors.Gold, 90)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Gold
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 101
    titleLabel.Parent = notifFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 15, 0, 40)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Colors.Text
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.ZIndex = 101
    messageLabel.Parent = messageLabel.Parent == nil and notifFrame or messageLabel.Parent
    messageLabel.Parent = notifFrame
    
    -- Animação de entrada
    TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -340, 1, -110)
    }):Play()
    
    -- Animação de saída
    task.delay(duration or 5, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 350, 1, -110)
        }):Play()
        task.wait(0.5)
        notifFrame:Destroy()
    end)
end

-- Criar botão flutuante arrastável
local function CreateToggleButton()
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 20, 0, 100)
    toggleBtn.BackgroundColor3 = Colors.Secondary
    toggleBtn.Text = "☠️"
    toggleBtn.TextSize = 24
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.ZIndex = 50
    toggleBtn.Parent = ScreenGui
    CreateCorner(toggleBtn, 25)
    CreateShadow(toggleBtn)
    
    local glowEffect = Instance.new("Frame")
    glowEffect.Size = UDim2.new(1, 6, 1, 6)
    glowEffect.Position = UDim2.new(0, -3, 0, -3)
    glowEffect.BackgroundTransparency = 0.7
    glowEffect.ZIndex = 49
    glowEffect.Parent = toggleBtn
    CreateCorner(glowEffect, 28)
    CreateGradient(glowEffect, Colors.Accent, Colors.Gold, 45)
    
    -- Sistema de arrastar
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = toggleBtn.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    toggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                updateDrag(input)
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                updateDrag(input)
            end
        end
    end)
    
    return toggleBtn
end

-- Criar menu principal
local function CreateMainMenu()
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, isMobile and 340 or 450, 0, isMobile and 500 or 550)
    mainFrame.Position = UDim2.new(0.5, isMobile and -170 or -225, 0.5, isMobile and -250 or -275)
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.ZIndex = 10
    mainFrame.Parent = ScreenGui
    CreateCorner(mainFrame, 16)
    CreateShadow(mainFrame)
    
    -- Borda com gradiente
    local border = Instance.new("UIStroke")
    border.Color = Colors.Accent
    border.Thickness = 2
    border.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = Colors.Secondary
    header.BorderSizePixel = 0
    header.ZIndex = 11
    header.Parent = mainFrame
    CreateCorner(header, 16)
    
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 20)
    headerFix.Position = UDim2.new(0, 0, 1, -20)
    headerFix.BackgroundColor3 = Colors.Secondary
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 11
    headerFix.Parent = header
    
    -- Título do menu
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡☠️MORTAL PLUGINS V1☠️⚡"
    title.TextColor3 = Colors.Gold
    title.TextSize = isMobile and 16 or 20
    title.Font = Enum.Font.GothamBlack
    title.ZIndex = 12
    title.Parent = header
    
    -- Subtítulo
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 75)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "ALL THE PERFECT PLUGINS TO CREATE YOUR GAME"
    subtitle.TextColor3 = Colors.TextDark
    subtitle.TextSize = isMobile and 10 or 12
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.ZIndex = 11
    subtitle.Parent = mainFrame
    
    -- Container de scroll para plugins
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "PluginsList"
    scrollFrame.Size = UDim2.new(1, -30, 1, -120)
    scrollFrame.Position = UDim2.new(0, 15, 0, 105)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Colors.Accent
    scrollFrame.ZIndex = 11
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = scrollFrame
    
    -- Atualizar tamanho do canvas automaticamente
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)
    
    return mainFrame, scrollFrame
end

-- Função para criar botão de plugin
local function CreatePluginButton(parent, name, description, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 80)
    btn.BackgroundColor3 = Colors.Secondary
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 12
    btn.AutoButtonColor = false
    btn.Parent = parent
    CreateCorner(btn, 12)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 50, 0, 50)
    iconLabel.Position = UDim2.new(0, 15, 0.5, -25)
    iconLabel.BackgroundColor3 = Colors.Background
    iconLabel.Text = icon
    iconLabel.TextSize = 24
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.ZIndex = 13
    iconLabel.Parent = btn
    CreateCorner(iconLabel, 10)
    CreateGradient(iconLabel, Colors.Accent, Colors.AccentLight, 45)
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -100, 0, 25)
    nameLabel.Position = UDim2.new(0, 75, 0, 15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Colors.Text
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 13
    nameLabel.Parent = btn
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -100, 0, 30)
    descLabel.Position = UDim2.new(0, 75, 0, 40)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Colors.TextDark
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.ZIndex = 13
    descLabel.Parent = btn
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 30, 0, 30)
    arrow.Position = UDim2.new(1, -40, 0.5, -15)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▶"
    arrow.TextColor3 = Colors.Accent
    arrow.TextSize = 16
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 13
    arrow.Parent = btn
    
    -- Efeitos hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {Position = UDim2.new(1, -35, 0.5, -15)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {Position = UDim2.new(1, -40, 0.5, -15)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return btn
end

-- Inicialização
local toggleButton = CreateToggleButton()
local mainFrame, pluginsList = CreateMainMenu()

-- Toggle do menu
local menuVisible = false
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    if menuVisible then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, isMobile and 340 or 450, 0, isMobile and 500 or 550),
            Position = UDim2.new(0.5, isMobile and -170 or -225, 0.5, isMobile and -250 or -275)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        mainFrame.Visible = false
    end
end)

-- Criar botões dos plugins
CreatePluginButton(pluginsList, "☠️ Mortal Animator V1 ⚡", "Anime Rigs, Tools, Parts e Models com qualidade AAA", "🎬", function()
    -- Carregar Animator
    if _G.LoadMortalAnimator then
        _G.LoadMortalAnimator()
    end
end)

CreatePluginButton(pluginsList, "🔧 Em Breve...", "Novos plugins serão adicionados", "⏳", function()
    ShowNotification("⏳ Em Breve", "Este plugin ainda está em desenvolvimento!", 3)
end)

-- Mostrar notificação inicial
task.wait(0.5)
ShowNotification("👑☠️MORTAL PLUGINS☠️👑", "Menu carregado com sucesso!\n\nAproveite as ferramentas profissionais⚡", 5)

-- Exportar função para carregar plugins
_G.MortalPluginsLoaded = true
_G.ShowMortalNotification = ShowNotification
_G.MortalColors = Colors
_G.MortalScreenGui = ScreenGui

print("⚡☠️ MORTAL PLUGINS V1 CARREGADO ☠️⚡")

-- ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
-- Parte 1/3 - Interface Principal
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Usar cores do menu principal se disponível
local Colors = _G.MortalColors or {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentLight = Color3.fromRGB(180, 80, 255),
    Success = Color3.fromRGB(0, 255, 127),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Red = Color3.fromRGB(255, 50, 80),
    Gold = Color3.fromRGB(255, 215, 0),
    Green = Color3.fromRGB(50, 205, 50),
    Timeline = Color3.fromRGB(20, 20, 30)
}

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Variáveis do Animator
local AnimatorData = {
    SelectedObject = nil,
    Keyframes = {},
    CurrentFrame = 0,
    TotalFrames = 600,
    FPS = 60,
    IsPlaying = false,
    IsRecording = false,
    LoopEnabled = false,
    TimelineZoom = 1,
    AnimationName = "NewAnimation",
    Bones = {}
}

-- Criar ScreenGui do Animator
local AnimatorGui = Instance.new("ScreenGui")
AnimatorGui.Name = "MortalAnimatorGUI"
AnimatorGui.ResetOnSpawn = false
AnimatorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if playerGui:FindFirstChild("MortalAnimatorGUI") then
    playerGui.MortalAnimatorGUI:Destroy()
end
AnimatorGui.Parent = playerGui

-- Funções utilitárias
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

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

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

-- Botão Toggle do Animator (arrastável)
local animatorToggle = Instance.new("TextButton")
animatorToggle.Name = "AnimatorToggle"
animatorToggle.Size = UDim2.new(0, 50, 0, 50)
animatorToggle.Position = UDim2.new(0, 20, 0, 160)
animatorToggle.BackgroundColor3 = Colors.Secondary
animatorToggle.Text = "☠️"
animatorToggle.TextSize = 24
animatorToggle.Font = Enum.Font.GothamBold
animatorToggle.BorderSizePixel = 0
animatorToggle.ZIndex = 50
animatorToggle.Parent = AnimatorGui
CreateCorner(animatorToggle, 25)
CreateShadow(animatorToggle)

local toggleGlow = Instance.new("Frame")
toggleGlow.Size = UDim2.new(1, 6, 1, 6)
toggleGlow.Position = UDim2.new(0, -3, 0, -3)
toggleGlow.BackgroundColor3 = Colors.Accent
toggleGlow.BackgroundTransparency = 0.7
toggleGlow.ZIndex = 49
toggleGlow.Parent = animatorToggle
CreateCorner(toggleGlow, 28)
CreateGradient(toggleGlow, Colors.Red, Colors.Gold, 45)

-- Sistema de arrastar para o toggle
local draggingToggle = false
local dragStartToggle, startPosToggle

animatorToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = animatorToggle.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartToggle
        animatorToggle.Position = UDim2.new(
            startPosToggle.X.Scale,
            startPosToggle.X.Offset + delta.X,
            startPosToggle.Y.Scale,
            startPosToggle.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = false
    end
end)

-- Frame Principal do Animator
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, isMobile and 360 or 900, 0, isMobile and 550 or 600)
mainFrame.Position = UDim2.new(0.5, isMobile and -180 or -450, 0.5, isMobile and -275 or -300)
mainFrame.BackgroundColor3 = Colors.Background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 20
mainFrame.Parent = AnimatorGui
CreateCorner(mainFrame, 16)
CreateShadow(mainFrame)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Colors.Accent
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Header do Animator
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Colors.Secondary
header.BorderSizePixel = 0
header.ZIndex = 21
header.Parent = mainFrame
CreateCorner(header, 16)

local headerBottom = Instance.new("Frame")
headerBottom.Size = UDim2.new(1, 0, 0, 16)
headerBottom.Position = UDim2.new(0, 0, 1, -16)
headerBottom.BackgroundColor3 = Colors.Secondary
headerBottom.BorderSizePixel = 0
headerBottom.ZIndex = 21
headerBottom.Parent = header

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Mortal Animator☠️ • V1⚡"
titleLabel.TextColor3 = Colors.Gold
titleLabel.TextSize = isMobile and 16 or 22
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 22
titleLabel.Parent = header

-- Botão Fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0.5, -17)
closeBtn.BackgroundColor3 = Colors.Red
closeBtn.Text = "✕"
closeBtn.TextColor3 = Colors.Text
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 22
closeBtn.Parent = header
CreateCorner(closeBtn, 8)

-- Painel lateral esquerdo (Hierarquia/Bones)
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, isMobile and 100 or 200, 1, -170)
leftPanel.Position = UDim2.new(0, 10, 0, 60)
leftPanel.BackgroundColor3 = Colors.Secondary
leftPanel.BorderSizePixel = 0
leftPanel.ZIndex = 21
leftPanel.Parent = mainFrame
CreateCorner(leftPanel, 10)

local leftTitle = Instance.new("TextLabel")
leftTitle.Size = UDim2.new(1, 0, 0, 30)
leftTitle.BackgroundColor3 = Colors.Tertiary
leftTitle.Text = "🦴 Hierarquia"
leftTitle.TextColor3 = Colors.Text
leftTitle.TextSize = 12
leftTitle.Font = Enum.Font.GothamBold
leftTitle.ZIndex = 22
leftTitle.Parent = leftPanel
CreateCorner(leftTitle, 10)

local bonesScroll = Instance.new("ScrollingFrame")
bonesScroll.Name = "BonesScroll"
bonesScroll.Size = UDim2.new(1, -10, 1, -40)
bonesScroll.Position = UDim2.new(0, 5, 0, 35)
bonesScroll.BackgroundTransparency = 1
bonesScroll.ScrollBarThickness = 3
bonesScroll.ScrollBarImageColor3 = Colors.Accent
bonesScroll.ZIndex = 22
bonesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
bonesScroll.Parent = leftPanel

local bonesLayout = Instance.new("UIListLayout")
bonesLayout.SortOrder = Enum.SortOrder.LayoutOrder
bonesLayout.Padding = UDim.new(0, 3)
bonesLayout.Parent = bonesScroll

-- Painel de ferramentas superior
local toolsPanel = Instance.new("Frame")
toolsPanel.Name = "ToolsPanel"
toolsPanel.Size = UDim2.new(1, isMobile and -130 or -230, 0, 50)
toolsPanel.Position = UDim2.new(0, isMobile and 115 or 215, 0, 60)
toolsPanel.BackgroundColor3 = Colors.Secondary
toolsPanel.BorderSizePixel = 0
toolsPanel.ZIndex = 21
toolsPanel.Parent = mainFrame
CreateCorner(toolsPanel, 10)

-- Botões de ferramentas (Usa ferramentas do Studio Lite)
local toolButtons = {
    {name = "Select", icon = "🔘", hint = "Selecionar"},
    {name = "Move", icon = "✥", hint = "Mover"},
    {name = "Rotate", icon = "🔄", hint = "Rotacionar"},
    {name = "Scale", icon = "⬛", hint = "Escalar"},
}

local toolsContainer = Instance.new("Frame")
toolsContainer.Size = UDim2.new(0, #toolButtons * 45, 1, -10)
toolsContainer.Position = UDim2.new(0, 10, 0, 5)
toolsContainer.BackgroundTransparency = 1
toolsContainer.ZIndex = 22
toolsContainer.Parent = toolsPanel

local toolsListLayout = Instance.new("UIListLayout")
toolsListLayout.FillDirection = Enum.FillDirection.Horizontal
toolsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
toolsListLayout.Padding = UDim.new(0, 5)
toolsListLayout.Parent = toolsContainer

for i, tool in ipairs(toolButtons) do
    local btn = Instance.new("TextButton")
    btn.Name = tool.name
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.BackgroundColor3 = Colors.Tertiary
    btn.Text = tool.icon
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 23
    btn.Parent = toolsContainer
    CreateCorner(btn, 8)
    
    btn.MouseButton1Click:Connect(function()
        -- Ativar ferramenta do Studio Lite
        local toolName = tool.name
        local pluginToolbar = game:GetService("PluginGuiService")
        -- Usar comandos do Studio Lite
        if toolName == "Select" then
            pcall(function() game:GetService("Selection"):Set({}) end)
        elseif toolName == "Move" then
            pcall(function() 
                local cmd = Instance.new("BindableEvent")
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "🔧 Ferramenta",
                    Text = "Use a ferramenta Move do Studio Lite",
                    Duration = 2
                })
            end)
        end
    end)
end

-- Botões de controle de animação
local controlsContainer = Instance.new("Frame")
controlsContainer.Size = UDim2.new(0, 250, 1, -10)
controlsContainer.Position = UDim2.new(1, -260, 0, 5)
controlsContainer.BackgroundTransparency = 1
controlsContainer.ZIndex = 22
controlsContainer.Parent = toolsPanel

local controlsLayout = Instance.new("UIListLayout")
controlsLayout.FillDirection = Enum.FillDirection.Horizontal
controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
controlsLayout.Padding = UDim.new(0, 5)
controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
controlsLayout.Parent = controlsContainer

local animControls = {
    {name = "Inicio", icon = "⏮", action = "goToStart"},
    {name = "Play", icon = "▶", action = "play"},
    {name = "Pause", icon = "⏸", action = "pause"},
    {name = "Stop", icon = "⏹", action = "stop"},
    {name = "Fim", icon = "⏭", action = "goToEnd"},
    {name = "Loop", icon = "🔁", action = "loop"},
}

for _, ctrl in ipairs(animControls) do
    local btn = Instance.new("TextButton")
    btn.Name = ctrl.name
    btn.Size = UDim2.new(0, 35, 0, 35)
    btn.BackgroundColor3 = Colors.Tertiary
    btn.Text = ctrl.icon
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 23
    btn.Parent = controlsContainer
    CreateCorner(btn, 8)
end

-- Armazenar referências
_G.AnimatorMainFrame = mainFrame
_G.AnimatorData = AnimatorData
_G.AnimatorBonesScroll = bonesScroll
_G.AnimatorToolsPanel = toolsPanel

print("⚡ Mortal Animator - Parte 1 Carregada")

-- ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
-- Parte 2/3 - Timeline e Keyframes
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local AnimatorGui = playerGui:WaitForChild("MortalAnimatorGUI")
local mainFrame = _G.AnimatorMainFrame
local AnimatorData = _G.AnimatorData

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Colors = _G.MortalColors or {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentLight = Color3.fromRGB(180, 80, 255),
    Success = Color3.fromRGB(0, 255, 127),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Red = Color3.fromRGB(255, 50, 80),
    Gold = Color3.fromRGB(255, 215, 0),
    Green = Color3.fromRGB(50, 205, 50),
    Timeline = Color3.fromRGB(20, 20, 30),
    KeyframeColor = Color3.fromRGB(50, 205, 50)
}

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Timeline Principal
local timelineFrame = Instance.new("Frame")
timelineFrame.Name = "TimelineFrame"
timelineFrame.Size = UDim2.new(1, -20, 0, isMobile and 180 or 200)
timelineFrame.Position = UDim2.new(0, 10, 1, isMobile and -190 or -210)
timelineFrame.BackgroundColor3 = Colors.Timeline
timelineFrame.BorderSizePixel = 0
timelineFrame.ZIndex = 21
timelineFrame.Parent = mainFrame
CreateCorner(timelineFrame, 10)

-- Header da Timeline
local timelineHeader = Instance.new("Frame")
timelineHeader.Name = "TimelineHeader"
timelineHeader.Size = UDim2.new(1, 0, 0, 35)
timelineHeader.BackgroundColor3 = Colors.Secondary
timelineHeader.BorderSizePixel = 0
timelineHeader.ZIndex = 22
timelineHeader.Parent = timelineFrame
CreateCorner(timelineHeader, 10)

local timelineTitle = Instance.new("TextLabel")
timelineTitle.Size = UDim2.new(0, 150, 1, 0)
timelineTitle.Position = UDim2.new(0, 10, 0, 0)
timelineTitle.BackgroundTransparency = 1
timelineTitle.Text = "📊 Timeline"
timelineTitle.TextColor3 = Colors.Text
timelineTitle.TextSize = 14
timelineTitle.Font = Enum.Font.GothamBold
timelineTitle.TextXAlignment = Enum.TextXAlignment.Left
timelineTitle.ZIndex = 23
timelineTitle.Parent = timelineHeader

-- Frame Counter
local frameCounter = Instance.new("TextLabel")
frameCounter.Name = "FrameCounter"
frameCounter.Size = UDim2.new(0, 120, 0, 25)
frameCounter.Position = UDim2.new(0.5, -60, 0.5, -12)
frameCounter.BackgroundColor3 = Colors.Tertiary
frameCounter.Text = "Frame: 0 / 600"
frameCounter.TextColor3 = Colors.Gold
frameCounter.TextSize = 12
frameCounter.Font = Enum.Font.GothamBold
frameCounter.ZIndex = 23
frameCounter.Parent = timelineHeader
CreateCorner(frameCounter, 6)

-- FPS Display
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 80, 0, 25)
fpsLabel.Position = UDim2.new(1, -150, 0.5, -12)
fpsLabel.BackgroundColor3 = Colors.Tertiary
fpsLabel.Text = "60 FPS"
fpsLabel.TextColor3 = Colors.Green
fpsLabel.TextSize = 12
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.ZIndex = 23
fpsLabel.Parent = timelineHeader
CreateCorner(fpsLabel, 6)

-- Botão Adicionar Keyframe
local addKeyframeBtn = Instance.new("TextButton")
addKeyframeBtn.Size = UDim2.new(0, 35, 0, 25)
addKeyframeBtn.Position = UDim2.new(1, -55, 0.5, -12)
addKeyframeBtn.BackgroundColor3 = Colors.Green
addKeyframeBtn.Text = "🔑+"
addKeyframeBtn.TextSize = 12
addKeyframeBtn.Font = Enum.Font.GothamBold
addKeyframeBtn.BorderSizePixel = 0
addKeyframeBtn.ZIndex = 23
addKeyframeBtn.Parent = timelineHeader
CreateCorner(addKeyframeBtn, 6)

-- Área da Timeline com Scroll Horizontal
local timelineScroll = Instance.new("ScrollingFrame")
timelineScroll.Name = "TimelineScroll"
timelineScroll.Size = UDim2.new(1, -10, 1, -45)
timelineScroll.Position = UDim2.new(0, 5, 0, 40)
timelineScroll.BackgroundColor3 = Colors.Background
timelineScroll.BorderSizePixel = 0
timelineScroll.ScrollBarThickness = 6
timelineScroll.ScrollBarImageColor3 = Colors.Accent
timelineScroll.ZIndex = 22
timelineScroll.CanvasSize = UDim2.new(0, 2000, 0, 0)
timelineScroll.ScrollingDirection = Enum.ScrollingDirection.X
timelineScroll.Parent = timelineFrame
CreateCorner(timelineScroll, 6)

-- Ruler (Régua de frames)
local ruler = Instance.new("Frame")
ruler.Name = "Ruler"
ruler.Size = UDim2.new(0, 2000, 0, 25)
ruler.Position = UDim2.new(0, 0, 0, 0)
ruler.BackgroundColor3 = Colors.Tertiary
ruler.BorderSizePixel = 0
ruler.ZIndex = 23
ruler.Parent = timelineScroll

-- Criar marcadores da régua
for i = 0, 600, 10 do
    local marker = Instance.new("Frame")
    marker.Size = UDim2.new(0, 1, 0, i % 50 == 0 and 15 or 8)
    marker.Position = UDim2.new(0, 50 + (i * 3), 1, i % 50 == 0 and -15 or -8)
    marker.BackgroundColor3 = i % 50 == 0 and Colors.Text or Colors.TextDark
    marker.BorderSizePixel = 0
    marker.ZIndex = 24
    marker.Parent = ruler
    
    if i % 50 == 0 then
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 30, 0, 10)
        label.Position = UDim2.new(0, 50 + (i * 3) - 15, 0, 2)
        label.BackgroundTransparency = 1
        label.Text = tostring(i)
        label.TextColor3 = Colors.TextDark
        label.TextSize = 8
        label.Font = Enum.Font.Gotham
        label.ZIndex = 24
        label.Parent = ruler
    end
end

-- Playhead (Indicador de frame atual)
local playhead = Instance.new("Frame")
playhead.Name = "Playhead"
playhead.Size = UDim2.new(0, 2, 1, 0)
playhead.Position = UDim2.new(0, 50, 0, 0)
playhead.BackgroundColor3 = Colors.Red
playhead.BorderSizePixel = 0
playhead.ZIndex = 30
playhead.Parent = timelineScroll

local playheadTop = Instance.new("Frame")
playheadTop.Size = UDim2.new(0, 12, 0, 12)
playheadTop.Position = UDim2.new(0.5, -6, 0, 0)
playheadTop.BackgroundColor3 = Colors.Red
playheadTop.ZIndex = 31
playheadTop.Parent = playhead
CreateCorner(playheadTop, 6)

-- Área de tracks (pistas de animação)
local tracksArea = Instance.new("Frame")
tracksArea.Name = "TracksArea"
tracksArea.Size = UDim2.new(0, 2000, 1, -30)
tracksArea.Position = UDim2.new(0, 0, 0, 28)
tracksArea.BackgroundTransparency = 1
tracksArea.ZIndex = 23
tracksArea.Parent = timelineScroll

-- Linhas de grade
for i = 0, 20 do
    local gridLine = Instance.new("Frame")
    gridLine.Size = UDim2.new(1, 0, 0, 1)
    gridLine.Position = UDim2.new(0, 0, 0, i * 8)
    gridLine.BackgroundColor3 = Colors.Tertiary
    gridLine.BackgroundTransparency = 0.7
    gridLine.BorderSizePixel = 0
    gridLine.ZIndex = 23
    gridLine.Parent = tracksArea
end

-- Sistema de Keyframes
local KeyframeSystem = {}
KeyframeSystem.Keyframes = {}
KeyframeSystem.Tracks = {}

function KeyframeSystem:CreateTrack(name, object)
    local trackFrame = Instance.new("Frame")
    trackFrame.Name = "Track_" .. name
    trackFrame.Size = UDim2.new(0, 2000, 0, 20)
    trackFrame.BackgroundColor3 = Colors.Secondary
    trackFrame.BackgroundTransparency = 0.5
    trackFrame.BorderSizePixel = 0
    trackFrame.ZIndex = 24
    trackFrame.Parent = tracksArea
    
    local trackLayout = Instance.new("UIListLayout")
    trackLayout.FillDirection = Enum.FillDirection.Vertical
    trackLayout.Parent = tracksArea
    
    self.Tracks[name] = {
        Frame = trackFrame,
        Object = object,
        Keyframes = {}
    }
    
    return trackFrame
end

function KeyframeSystem:AddKeyframe(trackName, frame, data)
    if not self.Tracks[trackName] then return end
    
    local track = self.Tracks[trackName]
    local xPos = 50 + (frame * 3)
    
    -- Criar visual do keyframe (círculo verde)
    local keyframeVisual = Instance.new("Frame")
    keyframeVisual.Name = "Keyframe_" .. frame
    keyframeVisual.Size = UDim2.new(0, 12, 0, 12)
    keyframeVisual.Position = UDim2.new(0, xPos - 6, 0.5, -6)
    keyframeVisual.BackgroundColor3 = Colors.KeyframeColor
    keyframeVisual.BorderSizePixel = 0
    keyframeVisual.ZIndex = 26
    keyframeVisual.Parent = track.Frame
    CreateCorner(keyframeVisual, 6)
    
    -- Glow effect
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 4, 1, 4)
    glow.Position = UDim2.new(0, -2, 0, -2)
    glow.BackgroundColor3 = Colors.KeyframeColor
    glow.BackgroundTransparency = 0.6
    glow.ZIndex = 25
    glow.Parent = keyframeVisual
    CreateCorner(glow, 8)
    
    -- Armazenar dados do keyframe
    track.Keyframes[frame] = {
        Visual = keyframeVisual,
        Data = data,
        Frame = frame
    }
    
    return keyframeVisual
end

function KeyframeSystem:RemoveKeyframe(trackName, frame)
    if not self.Tracks[trackName] then return end
    local track = self.Tracks[trackName]
    
    if track.Keyframes[frame] then
        track.Keyframes[frame].Visual:Destroy()
        track.Keyframes[frame] = nil
    end
end

function KeyframeSystem:GetKeyframeData(trackName, frame)
    if not self.Tracks[trackName] then return nil end
    local track = self.Tracks[trackName]
    return track.Keyframes[frame] and track.Keyframes[frame].Data or nil
end

-- Sistema de Playback
local PlaybackSystem = {}
PlaybackSystem.IsPlaying = false
PlaybackSystem.CurrentFrame = 0
PlaybackSystem.Connection = nil

function PlaybackSystem:Play()
    if self.IsPlaying then return end
    self.IsPlaying = true
    
    self.Connection = RunService.Heartbeat:Connect(function(dt)
        if not self.IsPlaying then return end
        
        self.CurrentFrame = self.CurrentFrame + (AnimatorData.FPS * dt)
        
        if self.CurrentFrame >= AnimatorData.TotalFrames then
            if AnimatorData.LoopEnabled then
                self.CurrentFrame = 0
            else
                self:Stop()
                return
            end
        end
        
        -- Atualizar posição do playhead
        local xPos = 50 + (math.floor(self.CurrentFrame) * 3)
        playhead.Position = UDim2.new(0, xPos, 0, 0)
        
        -- Atualizar contador
        frameCounter.Text = "Frame: " .. math.floor(self.CurrentFrame) .. " / " .. AnimatorData.TotalFrames
        
        -- Aplicar animação
        self:ApplyFrame(math.floor(self.CurrentFrame))
    end)
end

function PlaybackSystem:Pause()
    self.IsPlaying = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

function PlaybackSystem:Stop()
    self:Pause()
    self.CurrentFrame = 0
    playhead.Position = UDim2.new(0, 50, 0, 0)
    frameCounter.Text = "Frame: 0 / " .. AnimatorData.TotalFrames
end

function PlaybackSystem:GoToFrame(frame)
    self.CurrentFrame = math.clamp(frame, 0, AnimatorData.TotalFrames)
    local xPos = 50 + (self.CurrentFrame * 3)
    playhead.Position = UDim2.new(0, xPos, 0, 0)
    frameCounter.Text = "Frame: " .. self.CurrentFrame .. " / " .. AnimatorData.TotalFrames
    self:ApplyFrame(self.CurrentFrame)
end

function PlaybackSystem:ApplyFrame(frame)
    for trackName, track in pairs(KeyframeSystem.Tracks) do
        local object = track.Object
        if not object then continue end
        
        -- Encontrar keyframes anterior e próximo
        local prevFrame, nextFrame = nil, nil
        local prevData, nextData = nil, nil
        
        for kf, data in pairs(track.Keyframes) do
            if kf <= frame and (not prevFrame or kf > prevFrame) then
                prevFrame = kf
                prevData = data.Data
            end
            if kf > frame and (not nextFrame or kf < nextFrame) then
                nextFrame = kf
                nextData = data.Data
            end
        end
        
        -- Interpolar entre keyframes
        if prevData and nextData and prevFrame and nextFrame then
            local alpha = (frame - prevFrame) / (nextFrame - prevFrame)
            
            if prevData.CFrame and nextData.CFrame then
                object.CFrame = prevData.CFrame:Lerp(nextData.CFrame, alpha)
            end
            if prevData.Size and nextData.Size then
                object.Size = prevData.Size:Lerp(nextData.Size, alpha)
            end
        elseif prevData then
            if prevData.CFrame then
                object.CFrame = prevData.CFrame
            end
            if prevData.Size then
                object.Size = prevData.Size
            end
        end
    end
end

-- Interação com o playhead
local draggingPlayhead = false

timelineScroll.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingPlayhead = true
        local xPos = input.Position.X - timelineScroll.AbsolutePosition.X + timelineScroll.CanvasPosition.X
        local frame = math.clamp(math.floor((xPos - 50) / 3), 0, AnimatorData.TotalFrames)
        PlaybackSystem:GoToFrame(frame)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingPlayhead and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local xPos = input.Position.X - timelineScroll.AbsolutePosition.X + timelineScroll.CanvasPosition.X
        local frame = math.clamp(math.floor((xPos - 50) / 3), 0, AnimatorData.TotalFrames)
        PlaybackSystem:GoToFrame(frame)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingPlayhead = false
    end
end)

-- Exportar sistemas
_G.KeyframeSystem = KeyframeSystem
_G.PlaybackSystem = PlaybackSystem
_G.AnimatorTimeline = timelineFrame

print("⚡ Mortal Animator - Parte 2 Carregada (Timeline)")

-- ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
-- Parte 5 - Sistema Completo de Cutscenes
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local AnimatorGui = playerGui:WaitForChild("MortalAnimatorGUI")
local mainFrame = _G.AnimatorMainFrame

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Colors = _G.MortalColors or {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentLight = Color3.fromRGB(180, 80, 255),
    Success = Color3.fromRGB(0, 255, 127),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Red = Color3.fromRGB(255, 50, 80),
    Gold = Color3.fromRGB(255, 215, 0),
    Green = Color3.fromRGB(50, 205, 50),
    Blue = Color3.fromRGB(30, 144, 255),
    Cyan = Color3.fromRGB(0, 255, 255)
}

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

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

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

-- Sistema de Cutscenes
local CutsceneSystem = {}
CutsceneSystem.CameraPoints = {}
CutsceneSystem.CurrentCutscene = nil
CutsceneSystem.IsPlaying = false
CutsceneSystem.Duration = 10
CutsceneSystem.CameraFolder = nil

-- Criar pasta para câmeras
local function GetCameraFolder()
    if not CutsceneSystem.CameraFolder then
        CutsceneSystem.CameraFolder = Workspace:FindFirstChild("MortalCutsceneCameras")
        if not CutsceneSystem.CameraFolder then
            CutsceneSystem.CameraFolder = Instance.new("Folder")
            CutsceneSystem.CameraFolder.Name = "MortalCutsceneCameras"
            CutsceneSystem.CameraFolder.Parent = Workspace
        end
    end
    return CutsceneSystem.CameraFolder
end

-- Frame principal do Cutscene Editor
local cutsceneFrame = Instance.new("Frame")
cutsceneFrame.Name = "CutsceneFrame"
cutsceneFrame.Size = UDim2.new(0, isMobile and 340 or 800, 0, isMobile and 500 or 550)
cutsceneFrame.Position = UDim2.new(0.5, isMobile and -170 or -400, 0.5, isMobile and -250 or -275)
cutsceneFrame.BackgroundColor3 = Colors.Background
cutsceneFrame.BorderSizePixel = 0
cutsceneFrame.Visible = false
cutsceneFrame.ZIndex = 35
cutsceneFrame.Parent = AnimatorGui
CreateCorner(cutsceneFrame, 16)
CreateShadow(cutsceneFrame)

local cutsceneStroke = Instance.new("UIStroke")
cutsceneStroke.Color = Colors.Cyan
cutsceneStroke.Thickness = 2
cutsceneStroke.Parent = cutsceneFrame

-- Header do Cutscene
local cutsceneHeader = Instance.new("Frame")
cutsceneHeader.Name = "Header"
cutsceneHeader.Size = UDim2.new(1, 0, 0, 50)
cutsceneHeader.BackgroundColor3 = Colors.Secondary
cutsceneHeader.BorderSizePixel = 0
cutsceneHeader.ZIndex = 36
cutsceneHeader.Parent = cutsceneFrame
CreateCorner(cutsceneHeader, 16)

local cutsceneTitle = Instance.new("TextLabel")
cutsceneTitle.Size = UDim2.new(0.8, 0, 1, 0)
cutsceneTitle.Position = UDim2.new(0, 15, 0, 0)
cutsceneTitle.BackgroundTransparency = 1
cutsceneTitle.Text = "🎬 CRIAR CUTSCENE⚡ - Mortal Animator"
cutsceneTitle.TextColor3 = Colors.Cyan
cutsceneTitle.TextSize = isMobile and 14 or 20
cutsceneTitle.Font = Enum.Font.GothamBlack
cutsceneTitle.TextXAlignment = Enum.TextXAlignment.Left
cutsceneTitle.ZIndex = 37
cutsceneTitle.Parent = cutsceneHeader

-- Botão Fechar Cutscene
local closeCutsceneBtn = Instance.new("TextButton")
closeCutsceneBtn.Size = UDim2.new(0, 35, 0, 35)
closeCutsceneBtn.Position = UDim2.new(1, -45, 0.5, -17)
closeCutsceneBtn.BackgroundColor3 = Colors.Red
closeCutsceneBtn.Text = "✕"
closeCutsceneBtn.TextColor3 = Colors.Text
closeCutsceneBtn.TextSize = 16
closeCutsceneBtn.Font = Enum.Font.GothamBold
closeCutsceneBtn.BorderSizePixel = 0
closeCutsceneBtn.ZIndex = 37
closeCutsceneBtn.Parent = cutsceneHeader
CreateCorner(closeCutsceneBtn, 8)

closeCutsceneBtn.MouseButton1Click:Connect(function()
    TweenService:Create(cutsceneFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    cutsceneFrame.Visible = false
end)

-- Painel de Ferramentas de Câmera
local cameraToolsPanel = Instance.new("Frame")
cameraToolsPanel.Name = "CameraTools"
cameraToolsPanel.Size = UDim2.new(0, isMobile and 90 or 180, 1, -170)
cameraToolsPanel.Position = UDim2.new(0, 10, 0, 60)
cameraToolsPanel.BackgroundColor3 = Colors.Secondary
cameraToolsPanel.BorderSizePixel = 0
cameraToolsPanel.ZIndex = 36
cameraToolsPanel.Parent = cutsceneFrame
CreateCorner(cameraToolsPanel, 10)

local cameraToolsTitle = Instance.new("TextLabel")
cameraToolsTitle.Size = UDim2.new(1, 0, 0, 30)
cameraToolsTitle.BackgroundColor3 = Colors.Tertiary
cameraToolsTitle.Text = "📷 Câmeras"
cameraToolsTitle.TextColor3 = Colors.Text
cameraToolsTitle.TextSize = 12
cameraToolsTitle.Font = Enum.Font.GothamBold
cameraToolsTitle.ZIndex = 37
cameraToolsTitle.Parent = cameraToolsPanel
CreateCorner(cameraToolsTitle, 10)

-- Lista de Pontos de Câmera
local cameraListScroll = Instance.new("ScrollingFrame")
cameraListScroll.Name = "CameraList"
cameraListScroll.Size = UDim2.new(1, -10, 1, -80)
cameraListScroll.Position = UDim2.new(0, 5, 0, 35)
cameraListScroll.BackgroundTransparency = 1
cameraListScroll.ScrollBarThickness = 3
cameraListScroll.ScrollBarImageColor3 = Colors.Cyan
cameraListScroll.ZIndex = 37
cameraListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
cameraListScroll.Parent = cameraToolsPanel

local cameraListLayout = Instance.new("UIListLayout")
cameraListLayout.SortOrder = Enum.SortOrder.LayoutOrder
cameraListLayout.Padding = UDim.new(0, 5)
cameraListLayout.Parent = cameraListScroll

-- Botão Adicionar Câmera
local addCameraBtn = Instance.new("TextButton")
addCameraBtn.Name = "AddCamera"
addCameraBtn.Size = UDim2.new(1, -10, 0, 35)
addCameraBtn.Position = UDim2.new(0, 5, 1, -40)
addCameraBtn.BackgroundColor3 = Colors.Cyan
addCameraBtn.Text = "➕ Criar Câmera"
addCameraBtn.TextColor3 = Colors.Background
addCameraBtn.TextSize = isMobile and 10 or 12
addCameraBtn.Font = Enum.Font.GothamBold
addCameraBtn.BorderSizePixel = 0
addCameraBtn.ZIndex = 37
addCameraBtn.Parent = cameraToolsPanel
CreateCorner(addCameraBtn, 8)

-- Função para criar ponto de câmera (esfera azul semi-transparente)
function CutsceneSystem:CreateCameraPoint(position)
    local folder = GetCameraFolder()
    local pointNum = #self.CameraPoints + 1
    
    -- Criar esfera azul semi-transparente
    local sphere = Instance.new("Part")
    sphere.Name = "CameraPoint_" .. pointNum
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(3, 3, 3)
    sphere.Position = position or (Workspace.CurrentCamera.CFrame.Position + Workspace.CurrentCamera.CFrame.LookVector * 10)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Transparency = 0.5
    sphere.Color = Color3.fromRGB(0, 170, 255)
    sphere.Material = Enum.Material.Neon
    sphere.Parent = folder
    
    -- Criar BillboardGui para mostrar número
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 50, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = sphere
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "📷 " .. pointNum
    label.TextColor3 = Colors.Cyan
    label.TextSize = 18
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0.5
    label.Parent = billboard
    
    -- Criar linha conectando ao ponto anterior
    if #self.CameraPoints > 0 then
        local prevPoint = self.CameraPoints[#self.CameraPoints]
        local line = Instance.new("Part")
        line.Name = "CameraLine_" .. pointNum
        line.Anchored = true
        line.CanCollide = false
        line.Transparency = 0.7
        line.Color = Colors.Cyan
        line.Material = Enum.Material.Neon
        
        local distance = (sphere.Position - prevPoint.Sphere.Position).Magnitude
        line.Size = Vector3.new(0.2, 0.2, distance)
        line.CFrame = CFrame.lookAt(prevPoint.Sphere.Position, sphere.Position) * CFrame.new(0, 0, -distance/2)
        line.Parent = folder
        
        prevPoint.Line = line
    end
    
    -- Armazenar dados
    local cameraData = {
        Sphere = sphere,
        Position = sphere.Position,
        LookAt = sphere.Position + Vector3.new(0, 0, -10),
        Duration = 2,
        EasingStyle = "Quad",
        EasingDirection = "InOut",
        Index = pointNum,
        Line = nil
    }
    
    table.insert(self.CameraPoints, cameraData)
    
    -- Adicionar na lista UI
    self:AddCameraToList(cameraData)
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("📷 Câmera Criada", "Ponto de câmera #" .. pointNum .. " adicionado!", 2)
    end
    
    return cameraData
end

-- Adicionar câmera na lista visual
function CutsceneSystem:AddCameraToList(cameraData)
    local btn = Instance.new("TextButton")
    btn.Name = "Camera_" .. cameraData.Index
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Colors.Tertiary
    btn.Text = "📷 Câmera " .. cameraData.Index
    btn.TextColor3 = Colors.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 38
    btn.Parent = cameraListScroll
    CreateCorner(btn, 6)
    
    -- Selecionar câmera ao clicar
    btn.MouseButton1Click:Connect(function()
        self:SelectCamera(cameraData)
        
        -- Destacar selecionado
        for _, c in ipairs(cameraListScroll:GetChildren()) do
            if c:IsA("TextButton") then
                c.BackgroundColor3 = Colors.Tertiary
            end
        end
        btn.BackgroundColor3 = Colors.Cyan
    end)
    
    -- Atualizar canvas
    cameraListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        cameraListScroll.CanvasSize = UDim2.new(0, 0, 0, cameraListLayout.AbsoluteContentSize.Y + 10)
    end)
end

-- Selecionar câmera para edição
function CutsceneSystem:SelectCamera(cameraData)
    self.SelectedCamera = cameraData
    
    -- Mover a câmera do jogo para a posição selecionada
    local camera = Workspace.CurrentCamera
    TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        CFrame = CFrame.new(cameraData.Position) * CFrame.Angles(0, 0, 0)
    }):Play()
    
    -- Highlight na esfera
    for _, point in ipairs(self.CameraPoints) do
        point.Sphere.Transparency = 0.5
        point.Sphere.Size = Vector3.new(3, 3, 3)
    end
    cameraData.Sphere.Transparency = 0.3
    cameraData.Sphere.Size = Vector3.new(3.5, 3.5, 3.5)
end

-- Remover câmera
function CutsceneSystem:RemoveCamera(index)
    local cameraData = self.CameraPoints[index]
    if cameraData then
        cameraData.Sphere:Destroy()
        if cameraData.Line then
            cameraData.Line:Destroy()
        end
        table.remove(self.CameraPoints, index)
        
        -- Atualizar lista visual
        local btn = cameraListScroll:FindFirstChild("Camera_" .. index)
        if btn then btn:Destroy() end
    end
end

-- Conectar botão de adicionar câmera
addCameraBtn.MouseButton1Click:Connect(function()
    CutsceneSystem:CreateCameraPoint()
end)

-- Painel de Preview e Controles
local previewPanel = Instance.new("Frame")
previewPanel.Name = "PreviewPanel"
previewPanel.Size = UDim2.new(1, isMobile and -110 or -210, 0, isMobile and 200 or 250)
previewPanel.Position = UDim2.new(0, isMobile and 105 or 200, 0, 60)
previewPanel.BackgroundColor3 = Colors.Secondary
previewPanel.BorderSizePixel = 0
previewPanel.ZIndex = 36
previewPanel.Parent = cutsceneFrame
CreateCorner(previewPanel, 10)

local previewTitle = Instance.new("TextLabel")
previewTitle.Size = UDim2.new(1, 0, 0, 30)
previewTitle.BackgroundColor3 = Colors.Tertiary
previewTitle.Text = "🎥 Preview da Cutscene"
previewTitle.TextColor3 = Colors.Text
previewTitle.TextSize = 12
previewTitle.Font = Enum.Font.GothamBold
previewTitle.ZIndex = 37
previewTitle.Parent = previewPanel
CreateCorner(previewTitle, 10)

-- Viewport para preview
local viewportFrame = Instance.new("ViewportFrame")
viewportFrame.Size = UDim2.new(1, -20, 1, -80)
viewportFrame.Position = UDim2.new(0, 10, 0, 35)
viewportFrame.BackgroundColor3 = Color3.new(0, 0, 0)
viewportFrame.BorderSizePixel = 0
viewportFrame.ZIndex = 37
viewportFrame.Parent = previewPanel
CreateCorner(viewportFrame, 8)

-- Controles de Playback da Cutscene
local cutsceneControls = Instance.new("Frame")
cutsceneControls.Size = UDim2.new(1, -20, 0, 35)
cutsceneControls.Position = UDim2.new(0, 10, 1, -40)
cutsceneControls.BackgroundColor3 = Colors.Tertiary
cutsceneControls.BorderSizePixel = 0
cutsceneControls.ZIndex = 37
cutsceneControls.Parent = previewPanel
CreateCorner(cutsceneControls, 8)

local cutsceneControlsLayout = Instance.new("UIListLayout")
cutsceneControlsLayout.FillDirection = Enum.FillDirection.Horizontal
cutsceneControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
cutsceneControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
cutsceneControlsLayout.Padding = UDim.new(0, 10)
cutsceneControlsLayout.Parent = cutsceneControls

local cutscenePlaybackButtons = {
    {name = "PlayCutscene", icon = "▶", color = Colors.Green},
    {name = "PauseCutscene", icon = "⏸", color = Colors.Gold},
    {name = "StopCutscene", icon = "⏹", color = Colors.Red},
    {name = "PreviewCutscene", icon = "👁", color = Colors.Cyan},
}

for _, ctrl in ipairs(cutscenePlaybackButtons) do
    local btn = Instance.new("TextButton")
    btn.Name = ctrl.name
    btn.Size = UDim2.new(0, 40, 0, 28)
    btn.BackgroundColor3 = ctrl.color
    btn.Text = ctrl.icon
    btn.TextColor3 = Colors.Text
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 38
    btn.Parent = cutsceneControls
    CreateCorner(btn, 6)
end

-- Função de reproduzir cutscene
function CutsceneSystem:PlayCutscene()
    if #self.CameraPoints < 2 then
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("⚠️ Aviso", "Adicione pelo menos 2 pontos de câmera!", 3)
        end
        return
    end
    
    self.IsPlaying = true
    local camera = Workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable
    
    -- Reproduzir movimento entre cada ponto
    for i = 1, #self.CameraPoints - 1 do
        if not self.IsPlaying then break end
        
        local currentPoint = self.CameraPoints[i]
        local nextPoint = self.CameraPoints[i + 1]
        
        local tween = TweenService:Create(camera, TweenInfo.new(
            currentPoint.Duration,
            Enum.EasingStyle[currentPoint.EasingStyle],
            Enum.EasingDirection[currentPoint.EasingDirection]
        ), {
            CFrame = CFrame.new(nextPoint.Position, nextPoint.LookAt)
        })
        
        tween:Play()
        tween.Completed:Wait()
    end
    
    self.IsPlaying = false
    camera.CameraType = Enum.CameraType.Custom
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🎬 Cutscene", "Reprodução finalizada!", 2)
    end
end

function CutsceneSystem:StopCutscene()
    self.IsPlaying = false
    local camera = Workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Custom
end

-- Conectar botões de controle
local playBtn = cutsceneControls:FindFirstChild("PlayCutscene")
if playBtn then
    playBtn.MouseButton1Click:Connect(function()
        CutsceneSystem:PlayCutscene()
    end)
end

local stopBtn = cutsceneControls:FindFirstChild("StopCutscene")
if stopBtn then
    stopBtn.MouseButton1Click:Connect(function()
        CutsceneSystem:StopCutscene()
    end)
end

-- Timeline da Cutscene
local cutsceneTimeline = Instance.new("Frame")
cutsceneTimeline.Name = "CutsceneTimeline"
cutsceneTimeline.Size = UDim2.new(1, -20, 0, isMobile and 100 or 120)
cutsceneTimeline.Position = UDim2.new(0, 10, 1, isMobile and -110 or -130)
cutsceneTimeline.BackgroundColor3 = Colors.Secondary
cutsceneTimeline.BorderSizePixel = 0
cutsceneTimeline.ZIndex = 36
cutsceneTimeline.Parent = cutsceneFrame
CreateCorner(cutsceneTimeline, 10)

local cutsceneTimelineTitle = Instance.new("TextLabel")
cutsceneTimelineTitle.Size = UDim2.new(1, 0, 0, 25)
cutsceneTimelineTitle.BackgroundColor3 = Colors.Tertiary
cutsceneTimelineTitle.Text = "📊 Timeline da Cutscene"
cutsceneTimelineTitle.TextColor3 = Colors.Text
cutsceneTimelineTitle.TextSize = 11
cutsceneTimelineTitle.Font = Enum.Font.GothamBold
cutsceneTimelineTitle.ZIndex = 37
cutsceneTimelineTitle.Parent = cutsceneTimeline
CreateCorner(cutsceneTimelineTitle, 10)

local cutsceneTimelineScroll = Instance.new("ScrollingFrame")
cutsceneTimelineScroll.Size = UDim2.new(1, -10, 1, -35)
cutsceneTimelineScroll.Position = UDim2.new(0, 5, 0, 30)
cutsceneTimelineScroll.BackgroundColor3 = Colors.Background
cutsceneTimelineScroll.BorderSizePixel = 0
cutsceneTimelineScroll.ScrollBarThickness = 4
cutsceneTimelineScroll.ScrollBarImageColor3 = Colors.Cyan
cutsceneTimelineScroll.ZIndex = 37
cutsceneTimelineScroll.CanvasSize = UDim2.new(0, 1000, 0, 0)
cutsceneTimelineScroll.ScrollingDirection = Enum.ScrollingDirection.X
cutsceneTimelineScroll.Parent = cutsceneTimeline
CreateCorner(cutsceneTimelineScroll, 6)

-- Painel de Propriedades da Câmera
local cameraPropertiesPanel = Instance.new("Frame")
cameraPropertiesPanel.Name = "CameraProperties"
cameraPropertiesPanel.Size = UDim2.new(1, isMobile and -110 or -210, 0, isMobile and 80 or 100)
cameraPropertiesPanel.Position = UDim2.new(0, isMobile and 105 or 200, 0, isMobile and 270 or 320)
cameraPropertiesPanel.BackgroundColor3 = Colors.Secondary
cameraPropertiesPanel.BorderSizePixel = 0
cameraPropertiesPanel.ZIndex = 36
cameraPropertiesPanel.Parent = cutsceneFrame
CreateCorner(cameraPropertiesPanel, 10)

local propsTitle = Instance.new("TextLabel")
propsTitle.Size = UDim2.new(1, 0, 0, 25)
propsTitle.BackgroundColor3 = Colors.Tertiary
propsTitle.Text = "⚙️ Propriedades da Câmera"
propsTitle.TextColor3 = Colors.Text
propsTitle.TextSize = 11
propsTitle.Font = Enum.Font.GothamBold
propsTitle.ZIndex = 37
propsTitle.Parent = cameraPropertiesPanel
CreateCorner(propsTitle, 10)

-- Duração
local durationLabel = Instance.new("TextLabel")
durationLabel.Size = UDim2.new(0.3, 0, 0, 25)
durationLabel.Position = UDim2.new(0, 10, 0, 35)
durationLabel.BackgroundTransparency = 1
durationLabel.Text = "Duração:"
durationLabel.TextColor3 = Colors.TextDark
durationLabel.TextSize = 11
durationLabel.Font = Enum.Font.Gotham
durationLabel.TextXAlignment = Enum.TextXAlignment.Left
durationLabel.ZIndex = 37
durationLabel.Parent = cameraPropertiesPanel

local durationInput = Instance.new("TextBox")
durationInput.Size = UDim2.new(0, 60, 0, 25)
durationInput.Position = UDim2.new(0.3, 0, 0, 35)
durationInput.BackgroundColor3 = Colors.Tertiary
durationInput.Text = "2"
durationInput.TextColor3 = Colors.Text
durationInput.TextSize = 12
durationInput.Font = Enum.Font.GothamBold
durationInput.PlaceholderText = "Segundos"
durationInput.BorderSizePixel = 0
durationInput.ZIndex = 37
durationInput.Parent = cameraPropertiesPanel
CreateCorner(durationInput, 6)

-- Easing Style
local easingLabel = Instance.new("TextLabel")
easingLabel.Size = UDim2.new(0.2, 0, 0, 25)
easingLabel.Position = UDim2.new(0.5, 10, 0, 35)
easingLabel.BackgroundTransparency = 1
easingLabel.Text = "Easing:"
easingLabel.TextColor3 = Colors.TextDark
easingLabel.TextSize = 11
easingLabel.Font = Enum.Font.Gotham
easingLabel.TextXAlignment = Enum.TextXAlignment.Left
easingLabel.ZIndex = 37
easingLabel.Parent = cameraPropertiesPanel

-- Dropdown para Easing (simplificado como botão)
local easingBtn = Instance.new("TextButton")
easingBtn.Size = UDim2.new(0.25, -10, 0, 25)
easingBtn.Position = UDim2.new(0.7, 0, 0, 35)
easingBtn.BackgroundColor3 = Colors.Tertiary
easingBtn.Text = "Quad ▼"
easingBtn.TextColor3 = Colors.Text
easingBtn.TextSize = 10
easingBtn.Font = Enum.Font.GothamBold
easingBtn.BorderSizePixel = 0
easingBtn.ZIndex = 37
easingBtn.Parent = cameraPropertiesPanel
CreateCorner(easingBtn, 6)

-- Função para abrir menu de cutscene
local function OpenCutsceneEditor()
    cutsceneFrame.Visible = true
    cutsceneFrame.Size = UDim2.new(0, 0, 0, 0)
    cutsceneFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(cutsceneFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, isMobile and 340 or 800, 0, isMobile and 500 or 550),
        Position = UDim2.new(0.5, isMobile and -170 or -400, 0.5, isMobile and -250 or -275)
    }):Play()
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🎬 Editor de Cutscene", "Crie cutscenes cinematográficas profissionais!", 3)
    end
end

-- Conectar ao botão de cutscene do Animator
local actionsScroll = mainFrame:FindFirstChild("ActionsPanel")
if actionsScroll then
    local scrollFrame = actionsScroll:FindFirstChild("ScrollingFrame")
    if scrollFrame then
        local cutsceneBtn = scrollFrame:FindFirstChild("Cutscene")
        if cutsceneBtn then
            cutsceneBtn.MouseButton1Click:Connect(function()
                OpenCutsceneEditor()
            end)
        end
    end
end

-- Exportar sistema
_G.CutsceneSystem = CutsceneSystem
_G.OpenCutsceneEditor = OpenCutsceneEditor

print("⚡ Mortal Animator - Parte 5 Carregada (Sistema de Cutscenes)")

-- ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
-- Parte 6 - Funcionalidades Avançadas
-- Onion Skinning, Easing Curves, Copy/Paste, Auto Keyframe

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local AnimatorGui = playerGui:WaitForChild("MortalAnimatorGUI")
local mainFrame = _G.AnimatorMainFrame
local AnimatorData = _G.AnimatorData
local KeyframeSystem = _G.KeyframeSystem
local PlaybackSystem = _G.PlaybackSystem

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Colors = _G.MortalColors or {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentLight = Color3.fromRGB(180, 80, 255),
    Success = Color3.fromRGB(0, 255, 127),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Red = Color3.fromRGB(255, 50, 80),
    Gold = Color3.fromRGB(255, 215, 0),
    Green = Color3.fromRGB(50, 205, 50),
    Blue = Color3.fromRGB(30, 144, 255),
    Orange = Color3.fromRGB(255, 165, 0),
    Pink = Color3.fromRGB(255, 105, 180)
}

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE ONION SKINNING
-- ═══════════════════════════════════════════════════════════════

local OnionSkinSystem = {}
OnionSkinSystem.Enabled = false
OnionSkinSystem.PreviousFrames = 2
OnionSkinSystem.NextFrames = 2
OnionSkinSystem.Ghosts = {}

function OnionSkinSystem:CreateGhost(object, cframe, transparency, color)
    if not object:IsA("BasePart") then return end
    
    local ghost = object:Clone()
    ghost.Name = "OnionGhost"
    ghost.CanCollide = false
    ghost.Anchored = true
    ghost.CFrame = cframe
    ghost.Transparency = transparency
    ghost.Color = color
    ghost.Material = Enum.Material.ForceField
    ghost.Parent = Workspace
    
    -- Remover scripts e filhos desnecessários
    for _, child in ipairs(ghost:GetDescendants()) do
        if child:IsA("Script") or child:IsA("LocalScript") then
            child:Destroy()
        end
    end
    
    table.insert(self.Ghosts, ghost)
    return ghost
end

function OnionSkinSystem:ClearGhosts()
    for _, ghost in ipairs(self.Ghosts) do
        if ghost and ghost.Parent then
            ghost:Destroy()
        end
    end
    self.Ghosts = {}
end

function OnionSkinSystem:UpdateOnionSkin(currentFrame)
    self:ClearGhosts()
    
    if not self.Enabled then return end
    
    for trackName, track in pairs(KeyframeSystem.Tracks) do
        local object = track.Object
        if not object or not object:IsA("BasePart") then continue end
        
        -- Frames anteriores (vermelho/laranja)
        for i = 1, self.PreviousFrames do
            local prevFrame = currentFrame - (i * 10)
            local keyframeData = KeyframeSystem:GetKeyframeData(trackName, prevFrame)
            if keyframeData and keyframeData.CFrame then
                local alpha = 0.3 + (i * 0.2)
                self:CreateGhost(object, keyframeData.CFrame, alpha, Color3.fromRGB(255, 100, 100))
            end
        end
        
        -- Frames próximos (azul/verde)
        for i = 1, self.NextFrames do
            local nextFrame = currentFrame + (i * 10)
            local keyframeData = KeyframeSystem:GetKeyframeData(trackName, nextFrame)
            if keyframeData and keyframeData.CFrame then
                local alpha = 0.3 + (i * 0.2)
                self:CreateGhost(object, keyframeData.CFrame, alpha, Color3.fromRGB(100, 200, 255))
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE EASING CURVES
-- ═══════════════════════════════════════════════════════════════

local EasingSystem = {}
EasingSystem.CurrentStyle = Enum.EasingStyle.Quad
EasingSystem.CurrentDirection = Enum.EasingDirection.InOut

EasingSystem.Styles = {
    "Linear", "Quad", "Cubic", "Quart", "Quint",
    "Sine", "Exponential", "Circular", "Elastic",
    "Back", "Bounce"
}

EasingSystem.Directions = {
    "In", "Out", "InOut"
}

function EasingSystem:SetEasing(style, direction)
    self.CurrentStyle = Enum.EasingStyle[style] or Enum.EasingStyle.Quad
    self.CurrentDirection = Enum.EasingDirection[direction] or Enum.EasingDirection.InOut
end

function EasingSystem:Interpolate(startValue, endValue, alpha)
    -- Aplicar curva de easing
    local tweenInfo = TweenInfo.new(1, self.CurrentStyle, self.CurrentDirection)
    
    if typeof(startValue) == "CFrame" then
        return startValue:Lerp(endValue, alpha)
    elseif typeof(startValue) == "Vector3" then
        return startValue:Lerp(endValue, alpha)
    elseif typeof(startValue) == "number" then
        return startValue + (endValue - startValue) * alpha
    end
    
    return endValue
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE COPY/PASTE KEYFRAMES
-- ═══════════════════════════════════════════════════════════════

local ClipboardSystem = {}
ClipboardSystem.CopiedKeyframes = {}

function ClipboardSystem:CopyKeyframes(trackName, frame)
    local data = KeyframeSystem:GetKeyframeData(trackName, frame)
    if data then
        self.CopiedKeyframes = {
            TrackName = trackName,
            Frame = frame,
            Data = {
                CFrame = data.CFrame,
                Size = data.Size,
                Transparency = data.Transparency
            }
        }
        
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("📋 Copiado", "Keyframe copiado do frame " .. frame, 2)
        end
        return true
    end
    return false
end

function ClipboardSystem:PasteKeyframes(trackName, frame)
    if not self.CopiedKeyframes or not self.CopiedKeyframes.Data then
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("⚠️ Aviso", "Nenhum keyframe copiado!", 2)
        end
        return false
    end
    
    KeyframeSystem:AddKeyframe(trackName, frame, self.CopiedKeyframes.Data)
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("📋 Colado", "Keyframe colado no frame " .. frame, 2)
    end
    return true
end

function ClipboardSystem:CopyAllKeyframesAtFrame(frame)
    self.CopiedKeyframes = {}
    
    for trackName, track in pairs(KeyframeSystem.Tracks) do
        if track.Keyframes[frame] then
            self.CopiedKeyframes[trackName] = {
                CFrame = track.Keyframes[frame].Data.CFrame,
                Size = track.Keyframes[frame].Data.Size,
                Transparency = track.Keyframes[frame].Data.Transparency
            }
        end
    end
    
    if _G.ShowMortalNotification then
        local count = 0
        for _ in pairs(self.CopiedKeyframes) do count = count + 1 end
        _G.ShowMortalNotification("📋 Copiados", count .. " keyframes copiados do frame " .. frame, 2)
    end
end

function ClipboardSystem:PasteAllKeyframesAtFrame(frame)
    if not self.CopiedKeyframes or type(self.CopiedKeyframes) ~= "table" then
        return false
    end
    
    local count = 0
    for trackName, data in pairs(self.CopiedKeyframes) do
        if KeyframeSystem.Tracks[trackName] then
            KeyframeSystem:AddKeyframe(trackName, frame, data)
            count = count + 1
        end
    end
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("📋 Colados", count .. " keyframes colados no frame " .. frame, 2)
    end
    return true
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO KEYFRAME
-- ═══════════════════════════════════════════════════════════════

local AutoKeyframeSystem = {}
AutoKeyframeSystem.Enabled = false
AutoKeyframeSystem.TrackedObjects = {}
AutoKeyframeSystem.LastStates = {}
AutoKeyframeSystem.Connection = nil

function AutoKeyframeSystem:StartTracking()
    if self.Connection then return end
    
    self.Enabled = true
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        
        local currentFrame = math.floor(PlaybackSystem.CurrentFrame)
        
        for trackName, track in pairs(KeyframeSystem.Tracks) do
            local object = track.Object
            if not object or not object:IsA("BasePart") then continue end
            
            local currentState = {
                CFrame = object.CFrame,
                Size = object.Size
            }
            
            local lastState = self.LastStates[trackName]
            
            -- Verificar se houve mudança
            if lastState then
                local cfChanged = (currentState.CFrame.Position - lastState.CFrame.Position).Magnitude > 0.01
                local rotChanged = false
                
                local _, _, _, r00, r01, r02, r10, r11, r12, r20, r21, r22 = currentState.CFrame:GetComponents()
                local _, _, _, lr00, lr01, lr02, lr10, lr11, lr12, lr20, lr21, lr22 = lastState.CFrame:GetComponents()
                
                rotChanged = math.abs(r00 - lr00) > 0.01 or math.abs(r11 - lr11) > 0.01 or math.abs(r22 - lr22) > 0.01
                
                local sizeChanged = (currentState.Size - lastState.Size).Magnitude > 0.01
                
                if cfChanged or rotChanged or sizeChanged then
                    KeyframeSystem:AddKeyframe(trackName, currentFrame, currentState)
                end
            end
            
            self.LastStates[trackName] = currentState
        end
    end)
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🔴 Auto Key ATIVADO", "Keyframes serão criados automaticamente!", 2)
    end
end

function AutoKeyframeSystem:StopTracking()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("⚪ Auto Key DESATIVADO", "Keyframes manuais apenas", 2)
    end
end

function AutoKeyframeSystem:Toggle()
    if self.Enabled then
        self:StopTracking()
    else
        self:StartTracking()
    end
    return self.Enabled
end

-- ═══════════════════════════════════════════════════════════════
-- PAINEL DE FERRAMENTAS AVANÇADAS
-- ═══════════════════════════════════════════════════════════════

local advancedPanel = Instance.new("Frame")
advancedPanel.Name = "AdvancedPanel"
advancedPanel.Size = UDim2.new(0, isMobile and 320 or 250, 0, isMobile and 250 or 300)
advancedPanel.Position = UDim2.new(0, isMobile and 115 or 220, 0, 115)
advancedPanel.BackgroundColor3 = Colors.Secondary
advancedPanel.BorderSizePixel = 0
advancedPanel.ZIndex = 25
advancedPanel.Visible = true
advancedPanel.Parent = mainFrame
CreateCorner(advancedPanel, 10)

local advancedTitle = Instance.new("TextLabel")
advancedTitle.Size = UDim2.new(1, 0, 0, 28)
advancedTitle.BackgroundColor3 = Colors.Tertiary
advancedTitle.Text = "🔧 Ferramentas Avançadas"
advancedTitle.TextColor3 = Colors.Gold
advancedTitle.TextSize = 12
advancedTitle.Font = Enum.Font.GothamBold
advancedTitle.ZIndex = 26
advancedTitle.Parent = advancedPanel
CreateCorner(advancedTitle, 10)

local advancedScroll = Instance.new("ScrollingFrame")
advancedScroll.Size = UDim2.new(1, -10, 1, -38)
advancedScroll.Position = UDim2.new(0, 5, 0, 33)
advancedScroll.BackgroundTransparency = 1
advancedScroll.ScrollBarThickness = 3
advancedScroll.ScrollBarImageColor3 = Colors.Accent
advancedScroll.ZIndex = 26
advancedScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
advancedScroll.Parent = advancedPanel

local advancedLayout = Instance.new("UIListLayout")
advancedLayout.SortOrder = Enum.SortOrder.LayoutOrder
advancedLayout.Padding = UDim.new(0, 5)
advancedLayout.Parent = advancedScroll

-- Criar botões de ferramentas avançadas
local advancedTools = {
    {name = "Onion Skin", icon = "👻", color = Colors.Pink, system = "onion"},
    {name = "Auto Keyframe", icon = "🔴", color = Colors.Red, system = "autokey"},
    {name = "Copy Frame", icon = "📋", color = Colors.Blue, system = "copy"},
    {name = "Paste Frame", icon = "📄", color = Colors.Green, system = "paste"},
    {name = "Easing: Quad", icon = "📈", color = Colors.Orange, system = "easing"},
    {name = "Reverse Anim", icon = "🔄", color = Colors.Accent, system = "reverse"},
    {name = "Mirror Anim", icon = "🪞", color = Colors.Cyan, system = "mirror"},
    {name = "Clear All", icon = "🗑️", color = Colors.Red, system = "clear"},
    {name = "Zoom +", icon = "🔍+", color = Colors.TextDark, system = "zoomin"},
    {name = "Zoom -", icon = "🔍-", color = Colors.TextDark, system = "zoomout"},
}

for _, tool in ipairs(advancedTools) do
    local btn = Instance.new("TextButton")
    btn.Name = tool.name
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = tool.color
    btn.Text = tool.icon .. " " .. tool.name
    btn.TextColor3 = Colors.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 27
    btn.Parent = advancedScroll
    CreateCorner(btn, 6)
    
    btn.MouseButton1Click:Connect(function()
        local currentFrame = math.floor(PlaybackSystem.CurrentFrame)
        
        if tool.system == "onion" then
            OnionSkinSystem.Enabled = not OnionSkinSystem.Enabled
            if OnionSkinSystem.Enabled then
                OnionSkinSystem:UpdateOnionSkin(currentFrame)
                btn.Text = "👻 Onion Skin ✓"
            else
                OnionSkinSystem:ClearGhosts()
                btn.Text = "👻 Onion Skin"
            end
            
        elseif tool.system == "autokey" then
            local enabled = AutoKeyframeSystem:Toggle()
            btn.Text = enabled and "🔴 Auto Key ✓" or "⚪ Auto Keyframe"
            btn.BackgroundColor3 = enabled and Colors.Red or Colors.TextDark
            
        elseif tool.system == "copy" then
            ClipboardSystem:CopyAllKeyframesAtFrame(currentFrame)
            
        elseif tool.system == "paste" then
            ClipboardSystem:PasteAllKeyframesAtFrame(currentFrame)
            
        elseif tool.system == "easing" then
            -- Ciclar entre estilos de easing
            local currentIndex = 1
            for i, style in ipairs(EasingSystem.Styles) do
                if Enum.EasingStyle[style] == EasingSystem.CurrentStyle then
                    currentIndex = i
                    break
                end
            end
            currentIndex = (currentIndex % #EasingSystem.Styles) + 1
            EasingSystem:SetEasing(EasingSystem.Styles[currentIndex], "InOut")
            btn.Text = "📈 Easing: " .. EasingSystem.Styles[currentIndex]
            
        elseif tool.system == "reverse" then
            -- Reverter animação
            for trackName, track in pairs(KeyframeSystem.Tracks) do
                local newKeyframes = {}
                local maxFrame = 0
                
                for frame, _ in pairs(track.Keyframes) do
                    maxFrame = math.max(maxFrame, frame)
                end
                
                for frame, data in pairs(track.Keyframes) do
                    local newFrame = maxFrame - frame
                    newKeyframes[newFrame] = data
                end
                
                -- Limpar e recriar
                for frame, _ in pairs(track.Keyframes) do
                    KeyframeSystem:RemoveKeyframe(trackName, frame)
                end
                
                for frame, data in pairs(newKeyframes) do
                    KeyframeSystem:AddKeyframe(trackName, frame, data.Data)
                end
            end
            
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("🔄 Revertido", "Animação revertida com sucesso!", 2)
            end
            
        elseif tool.system == "mirror" then
            -- Espelhar animação (inverter X)
            for trackName, track in pairs(KeyframeSystem.Tracks) do
                for frame, keyframeData in pairs(track.Keyframes) do
                    if keyframeData.Data.CFrame then
                        local cf = keyframeData.Data.CFrame
                        local newCFrame = CFrame.new(-cf.X, cf.Y, cf.Z) * cf.Rotation
                        keyframeData.Data.CFrame = newCFrame
                    end
                end
            end
            
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("🪞 Espelhado", "Animação espelhada com sucesso!", 2)
            end
            
        elseif tool.system == "clear" then
            for trackName, track in pairs(KeyframeSystem.Tracks) do
                for frame, _ in pairs(track.Keyframes) do
                    KeyframeSystem:RemoveKeyframe(trackName, frame)
                end
            end
            
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("🗑️ Limpo", "Todos os keyframes removidos!", 2)
            end
            
        elseif tool.system == "zoomin" then
            AnimatorData.TimelineZoom = math.min(AnimatorData.TimelineZoom * 1.2, 3)
            -- Atualizar timeline visual
            local timeline = mainFrame:FindFirstChild("TimelineFrame")
            if timeline then
                local scroll = timeline:FindFirstChild("TimelineScroll")
                if scroll then
                    scroll.CanvasSize = UDim2.new(0, 2000 * AnimatorData.TimelineZoom, 0, 0)
                end
            end
            
        elseif tool.system == "zoomout" then
            AnimatorData.TimelineZoom = math.max(AnimatorData.TimelineZoom / 1.2, 0.5)
            local timeline = mainFrame:FindFirstChild("TimelineFrame")
            if timeline then
                local scroll = timeline:FindFirstChild("TimelineScroll")
                if scroll then
                    scroll.CanvasSize = UDim2.new(0, 2000 * AnimatorData.TimelineZoom, 0, 0)
                end
            end
        end
    end)
end

-- Atualizar canvas
advancedLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    advancedScroll.CanvasSize = UDim2.new(0, 0, 0, advancedLayout.AbsoluteContentSize.Y + 10)
end)

-- Atualizar Onion Skin quando o frame mudar
if PlaybackSystem then
    local originalGoToFrame = PlaybackSystem.GoToFrame
    PlaybackSystem.GoToFrame = function(self, frame)
        originalGoToFrame(self, frame)
        if OnionSkinSystem.Enabled then
            OnionSkinSystem:UpdateOnionSkin(frame)
        end
    end
end

-- Exportar sistemas
_G.OnionSkinSystem = OnionSkinSystem
_G.EasingSystem = EasingSystem
_G.ClipboardSystem = ClipboardSystem
_G.AutoKeyframeSystem = AutoKeyframeSystem

print("⚡ Mortal Animator - Parte 6 Carregada (Ferramentas Avançadas)")

-- ⚡☠️ MORTAL ANIMATOR V1 ☠️⚡
-- Parte 7 - Integração com Studio Lite + Detecção de Rigs
-- Usa ferramentas nativas do Studio Lite

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local AnimatorGui = playerGui:WaitForChild("MortalAnimatorGUI")
local mainFrame = _G.AnimatorMainFrame
local AnimatorData = _G.AnimatorData
local KeyframeSystem = _G.KeyframeSystem
local PlaybackSystem = _G.PlaybackSystem
local SelectionSystem = _G.SelectionSystem
local bonesScroll = _G.AnimatorBonesScroll

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Colors = _G.MortalColors or {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(138, 43, 226),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Red = Color3.fromRGB(255, 50, 80),
    Gold = Color3.fromRGB(255, 215, 0),
    Green = Color3.fromRGB(50, 205, 50),
    Blue = Color3.fromRGB(30, 144, 255),
    Cyan = Color3.fromRGB(0, 255, 255)
}

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE DETECÇÃO DE RIGS
-- ═══════════════════════════════════════════════════════════════

local RigDetectionSystem = {}
RigDetectionSystem.CurrentRig = nil
RigDetectionSystem.RigType = nil -- "R6", "R15", "Custom", "Model", "Part"

-- Partes do R6
RigDetectionSystem.R6Parts = {
    "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
    "HumanoidRootPart"
}

-- Partes do R15
RigDetectionSystem.R15Parts = {
    "Head", "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot",
    "HumanoidRootPart"
}

function RigDetectionSystem:DetectRigType(model)
    if not model then return "Unknown" end
    
    -- Verificar se é um Model
    if not model:IsA("Model") then
        if model:IsA("BasePart") then
            return "Part"
        elseif model:IsA("Tool") then
            return "Tool"
        end
        return "Unknown"
    end
    
    -- Verificar R15
    local r15Count = 0
    for _, partName in ipairs(self.R15Parts) do
        if model:FindFirstChild(partName) then
            r15Count = r15Count + 1
        end
    end
    
    if r15Count >= 12 then
        return "R15"
    end
    
    -- Verificar R6
    local r6Count = 0
    for _, partName in ipairs(self.R6Parts) do
        if model:FindFirstChild(partName) then
            r6Count = r6Count + 1
        end
    end
    
    if r6Count >= 5 then
        return "R6"
    end
    
    -- Verificar se tem Humanoid (rig customizado)
    if model:FindFirstChildOfClass("Humanoid") then
        return "Custom"
    end
    
    -- É apenas um modelo normal
    return "Model"
end

function RigDetectionSystem:GetAllAnimatableParts(object)
    local parts = {}
    
    if object:IsA("BasePart") then
        table.insert(parts, object)
    end
    
    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(parts, descendant)
        elseif descendant:IsA("Motor6D") then
            -- Adicionar partes conectadas pelo Motor6D
            if descendant.Part0 and not table.find(parts, descendant.Part0) then
                table.insert(parts, descendant.Part0)
            end
            if descendant.Part1 and not table.find(parts, descendant.Part1) then
                table.insert(parts, descendant.Part1)
            end
        elseif descendant:IsA("Bone") then
            -- Bones para animação
            table.insert(parts, descendant)
        end
    end
    
    return parts
end

function RigDetectionSystem:GetMotor6Ds(model)
    local motors = {}
    
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("Motor6D") then
            table.insert(motors, descendant)
        end
    end
    
    return motors
end

function RigDetectionSystem:SetupRig(model)
    self.CurrentRig = model
    self.RigType = self:DetectRigType(model)
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification(
            "🤖 Rig Detectado",
            "Tipo: " .. self.RigType .. "\nObjeto: " .. model.Name,
            3
        )
    end
    
    return self.RigType
end

-- ═══════════════════════════════════════════════════════════════
-- INTEGRAÇÃO COM FERRAMENTAS DO STUDIO LITE
-- ═══════════════════════════════════════════════════════════════

local StudioLiteIntegration = {}
StudioLiteIntegration.CurrentTool = nil
StudioLiteIntegration.LastTransforms = {}
StudioLiteIntegration.TrackingConnection = nil

-- Detectar mudanças nas transformações usando as ferramentas nativas
function StudioLiteIntegration:StartTracking()
    if self.TrackingConnection then
        self.TrackingConnection:Disconnect()
    end
    
    self.TrackingConnection = RunService.Heartbeat:Connect(function()
        -- Verificar seleção atual do Studio Lite
        local selected = Selection:Get()
        
        for _, object in ipairs(selected) do
            if object:IsA("BasePart") then
                local lastTransform = self.LastTransforms[object]
                local currentCFrame = object.CFrame
                local currentSize = object.Size
                
                if lastTransform then
                    -- Verificar se houve mudança
                    local posChanged = (currentCFrame.Position - lastTransform.Position).Magnitude > 0.001
                    local sizeChanged = (currentSize - lastTransform.Size).Magnitude > 0.001
                    
                    -- Verificar rotação
                    local rotChanged = false
                    local _, _, _, r00, r01, r02, r10, r11, r12, r20, r21, r22 = currentCFrame:GetComponents()
                    local _, _, _, lr00, lr01, lr02, lr10, lr11, lr12, lr20, lr21, lr22 = lastTransform.CFrame:GetComponents()
                    
                    if math.abs(r00 - lr00) > 0.001 or math.abs(r11 - lr11) > 0.001 or math.abs(r22 - lr22) > 0.001 then
                        rotChanged = true
                    end
                    
                    if posChanged or rotChanged or sizeChanged then
                        -- Objeto foi transformado com ferramenta do Studio Lite
                        self:OnTransformDetected(object, currentCFrame, currentSize)
                    end
                end
                
                self.LastTransforms[object] = {
                    CFrame = currentCFrame,
                    Position = currentCFrame.Position,
                    Size = currentSize
                }
            end
        end
    end)
end

function StudioLiteIntegration:StopTracking()
    if self.TrackingConnection then
        self.TrackingConnection:Disconnect()
        self.TrackingConnection = nil
    end
end

function StudioLiteIntegration:OnTransformDetected(object, cframe, size)
    -- Se Auto Keyframe estiver ativo, criar keyframe
    if _G.AutoKeyframeSystem and _G.AutoKeyframeSystem.Enabled then
        local currentFrame = math.floor(PlaybackSystem.CurrentFrame)
        local trackName = object.Name
        
        if KeyframeSystem.Tracks[trackName] then
            KeyframeSystem:AddKeyframe(trackName, currentFrame, {
                CFrame = cframe,
                Size = size,
                Transparency = object.Transparency
            })
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- INSTRUÇÕES PARA O USUÁRIO
-- ═══════════════════════════════════════════════════════════════

local instructionsPanel = Instance.new("Frame")
instructionsPanel.Name = "InstructionsPanel"
instructionsPanel.Size = UDim2.new(0, isMobile and 200 or 280, 0, 120)
instructionsPanel.Position = UDim2.new(1, isMobile and -210 or -290, 1, isMobile and -340 or -360)
instructionsPanel.BackgroundColor3 = Colors.Secondary
instructionsPanel.BorderSizePixel = 0
instructionsPanel.ZIndex = 25
instructionsPanel.Parent = mainFrame
CreateCorner(instructionsPanel, 10)

local instructionsTitle = Instance.new("TextLabel")
instructionsTitle.Size = UDim2.new(1, 0, 0, 25)
instructionsTitle.BackgroundColor3 = Colors.Cyan
instructionsTitle.Text = "📋 Como Animar"
instructionsTitle.TextColor3 = Colors.Background
instructionsTitle.TextSize = 11
instructionsTitle.Font = Enum.Font.GothamBold
instructionsTitle.ZIndex = 26
instructionsTitle.Parent = instructionsPanel
CreateCorner(instructionsTitle, 10)

local instructionsText = Instance.new("TextLabel")
instructionsText.Size = UDim2.new(1, -10, 1, -30)
instructionsText.Position = UDim2.new(0, 5, 0, 28)
instructionsText.BackgroundTransparency = 1
instructionsText.Text = [[
1. Selecione objeto no Explorer
2. Clique em "🎯 Selecionar"
3. Use Move/Rotate/Scale do Studio
4. Clique "🔑 Add Key" para salvar
5. Mova o Playhead e repita!

Ative "Auto Key" para automático!
]]
instructionsText.TextColor3 = Colors.TextDark
instructionsText.TextSize = isMobile and 9 or 10
instructionsText.Font = Enum.Font.Gotham
instructionsText.TextXAlignment = Enum.TextXAlignment.Left
instructionsText.TextYAlignment = Enum.TextYAlignment.Top
instructionsText.TextWrapped = true
instructionsText.ZIndex = 26
instructionsText.Parent = instructionsPanel

-- ═══════════════════════════════════════════════════════════════
-- PAINEL DE INFORMAÇÕES DO RIG
-- ═══════════════════════════════════════════════════════════════

local rigInfoPanel = Instance.new("Frame")
rigInfoPanel.Name = "RigInfoPanel"
rigInfoPanel.Size = UDim2.new(0, isMobile and 100 or 150, 0, 80)
rigInfoPanel.Position = UDim2.new(0, isMobile and 115 or 220, 0, isMobile and 370 or 390)
rigInfoPanel.BackgroundColor3 = Colors.Secondary
rigInfoPanel.BorderSizePixel = 0
rigInfoPanel.ZIndex = 25
rigInfoPanel.Parent = mainFrame
CreateCorner(rigInfoPanel, 10)

local rigInfoTitle = Instance.new("TextLabel")
rigInfoTitle.Size = UDim2.new(1, 0, 0, 22)
rigInfoTitle.BackgroundColor3 = Colors.Tertiary
rigInfoTitle.Text = "🤖 Rig Info"
rigInfoTitle.TextColor3 = Colors.Text
rigInfoTitle.TextSize = 10
rigInfoTitle.Font = Enum.Font.GothamBold
rigInfoTitle.ZIndex = 26
rigInfoTitle.Parent = rigInfoPanel
CreateCorner(rigInfoTitle, 10)

local rigTypeLabel = Instance.new("TextLabel")
rigTypeLabel.Name = "RigTypeLabel"
rigTypeLabel.Size = UDim2.new(1, -10, 0, 20)
rigTypeLabel.Position = UDim2.new(0, 5, 0, 27)
rigTypeLabel.BackgroundTransparency = 1
rigTypeLabel.Text = "Tipo: Nenhum"
rigTypeLabel.TextColor3 = Colors.Gold
rigTypeLabel.TextSize = 10
rigTypeLabel.Font = Enum.Font.GothamBold
rigTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
rigTypeLabel.ZIndex = 26
rigTypeLabel.Parent = rigInfoPanel

local rigPartsLabel = Instance.new("TextLabel")
rigPartsLabel.Name = "RigPartsLabel"
rigPartsLabel.Size = UDim2.new(1, -10, 0, 20)
rigPartsLabel.Position = UDim2.new(0, 5, 0, 47)
rigPartsLabel.BackgroundTransparency = 1
rigPartsLabel.Text = "Partes: 0"
rigPartsLabel.TextColor3 = Colors.TextDark
rigPartsLabel.TextSize = 10
rigPartsLabel.Font = Enum.Font.Gotham
rigPartsLabel.TextXAlignment = Enum.TextXAlignment.Left
rigPartsLabel.ZIndex = 26
rigPartsLabel.Parent = rigInfoPanel

-- Atualizar info quando selecionar objeto
local originalSelectObject = SelectionSystem.SelectObject
SelectionSystem.SelectObject = function(self, object)
    originalSelectObject(self, object)
    
    if object then
        local rigType = RigDetectionSystem:SetupRig(object)
        local parts = RigDetectionSystem:GetAllAnimatableParts(object)
        
        rigTypeLabel.Text = "Tipo: " .. rigType
        rigPartsLabel.Text = "Partes: " .. #parts
        
        -- Atualizar cores baseado no tipo
        if rigType == "R15" then
            rigTypeLabel.TextColor3 = Colors.Green
        elseif rigType == "R6" then
            rigTypeLabel.TextColor3 = Colors.Blue
        elseif rigType == "Custom" then
            rigTypeLabel.TextColor3 = Colors.Gold
        else
            rigTypeLabel.TextColor3 = Colors.Text
        end
    end
end

-- Iniciar tracking das ferramentas do Studio Lite
StudioLiteIntegration:StartTracking()

-- ═══════════════════════════════════════════════════════════════
-- ATALHOS DE TECLADO (PC)
-- ═══════════════════════════════════════════════════════════════

if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            -- Play/Pause
            if PlaybackSystem.IsPlaying then
                PlaybackSystem:Pause()
            else
                PlaybackSystem:Play()
            end
            
        elseif input.KeyCode == Enum.KeyCode.K then
            -- Adicionar Keyframe
            local currentFrame = math.floor(PlaybackSystem.CurrentFrame)
            for _, part in ipairs(SelectionSystem.SelectedParts) do
                if part:IsA("BasePart") then
                    KeyframeSystem:AddKeyframe(part.Name, currentFrame, {
                        CFrame = part.CFrame,
                        Size = part.Size,
                        Transparency = part.Transparency
                    })
                end
            end
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("🔑 Keyframe", "Adicionado no frame " .. currentFrame, 1)
            end
            
        elseif input.KeyCode == Enum.KeyCode.Home then
            -- Ir para início
            PlaybackSystem:GoToFrame(0)
            
        elseif input.KeyCode == Enum.KeyCode.End then
            -- Ir para fim
            PlaybackSystem:GoToFrame(AnimatorData.TotalFrames)
            
        elseif input.KeyCode == Enum.KeyCode.Left then
            -- Frame anterior
            PlaybackSystem:GoToFrame(math.max(0, PlaybackSystem.CurrentFrame - 1))
            
        elseif input.KeyCode == Enum.KeyCode.Right then
            -- Próximo frame
            PlaybackSystem:GoToFrame(math.min(AnimatorData.TotalFrames, PlaybackSystem.CurrentFrame + 1))
        end
    end)
end

-- Exportar sistemas
_G.RigDetectionSystem = RigDetectionSystem
_G.StudioLiteIntegration = StudioLiteIntegration

print("⚡ Mortal Animator - Parte 7 Carregada (Integração Studio Lite)")
print("═══════════════════════════════════════════════════════════")
print("⚡☠️ MORTAL ANIMATOR V1 - TOTALMENTE CARREGADO ☠️⚡")
print("═══════════════════════════════════════════════════════════")

