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
-- Parte 3/3 - Funções Avançadas, Cutscene e Export
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local AnimatorGui = playerGui:WaitForChild("MortalAnimatorGUI")
local mainFrame = _G.AnimatorMainFrame
local AnimatorData = _G.AnimatorData
local KeyframeSystem = _G.KeyframeSystem
local PlaybackSystem = _G.PlaybackSystem
local bonesScroll = _G.AnimatorBonesScroll

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
    Blue = Color3.fromRGB(30, 144, 255)
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

-- Painel de Ações (lado direito)
local actionsPanel = Instance.new("Frame")
actionsPanel.Name = "ActionsPanel"
actionsPanel.Size = UDim2.new(0, isMobile and 80 or 150, 0, isMobile and 200 or 250)
actionsPanel.Position = UDim2.new(1, isMobile and -90 or -160, 0, 115)
actionsPanel.BackgroundColor3 = Colors.Secondary
actionsPanel.BorderSizePixel = 0
actionsPanel.ZIndex = 21
actionsPanel.Parent = mainFrame
CreateCorner(actionsPanel, 10)

local actionsTitle = Instance.new("TextLabel")
actionsTitle.Size = UDim2.new(1, 0, 0, 25)
actionsTitle.BackgroundColor3 = Colors.Tertiary
actionsTitle.Text = "⚡ Ações"
actionsTitle.TextColor3 = Colors.Text
actionsTitle.TextSize = 11
actionsTitle.Font = Enum.Font.GothamBold
actionsTitle.ZIndex = 22
actionsTitle.Parent = actionsPanel
CreateCorner(actionsTitle, 10)

-- Botões de ação
local actionButtons = {
    {name = "Selecionar", icon = "🎯", color = Colors.Accent},
    {name = "Add Key", icon = "🔑", color = Colors.Green},
    {name = "Del Key", icon = "🗑️", color = Colors.Red},
    {name = "Cutscene", icon = "🎬", color = Colors.Gold},
    {name = "Export", icon = "💾", color = Colors.Blue},
    {name = "Importar", icon = "📂", color = Colors.Accent},
}

local actionsScroll = Instance.new("ScrollingFrame")
actionsScroll.Size = UDim2.new(1, -10, 1, -35)
actionsScroll.Position = UDim2.new(0, 5, 0, 30)
actionsScroll.BackgroundTransparency = 1
actionsScroll.ScrollBarThickness = 2
actionsScroll.ZIndex = 22
actionsScroll.CanvasSize = UDim2.new(0, 0, 0, #actionButtons * 40)
actionsScroll.Parent = actionsPanel

local actionsLayout = Instance.new("UIListLayout")
actionsLayout.Padding = UDim.new(0, 5)
actionsLayout.Parent = actionsScroll

for _, action in ipairs(actionButtons) do
    local btn = Instance.new("TextButton")
    btn.Name = action.name
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = action.color
    btn.Text = action.icon .. " " .. (isMobile and "" or action.name)
    btn.TextColor3 = Colors.Text
    btn.TextSize = isMobile and 16 or 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 23
    btn.Parent = actionsScroll
    CreateCorner(btn, 8)
end

-- Sistema de seleção de objetos
local SelectionSystem = {}
SelectionSystem.SelectedObject = nil
SelectionSystem.SelectedParts = {}

function SelectionSystem:SelectObject(object)
    self.SelectedObject = object
    AnimatorData.SelectedObject = object
    
    -- Limpar hierarquia
    for _, child in ipairs(bonesScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Preencher hierarquia
    if object then
        local function AddToHierarchy(part, indent)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -5, 0, 22)
            btn.BackgroundColor3 = Colors.Tertiary
            btn.Text = string.rep("  ", indent) .. "▸ " .. part.Name
            btn.TextColor3 = Colors.Text
            btn.TextSize = 10
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BorderSizePixel = 0
            btn.ZIndex = 23
            btn.Parent = bonesScroll
            CreateCorner(btn, 4)
            
            btn.MouseButton1Click:Connect(function()
                self:SelectPart(part)
                -- Destacar botão selecionado
                for _, c in ipairs(bonesScroll:GetChildren()) do
                    if c:IsA("TextButton") then
                        c.BackgroundColor3 = Colors.Tertiary
                    end
                end
                btn.BackgroundColor3 = Colors.Accent
            end)
            
            -- Criar track na timeline
            if part:IsA("BasePart") or part:IsA("Model") then
                KeyframeSystem:CreateTrack(part.Name, part)
            end
        end
        
        -- Adicionar objeto principal
        AddToHierarchy(object, 0)
        
        -- Adicionar descendentes
        local function ProcessDescendants(parent, indent)
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("BasePart") or child:IsA("Motor6D") or child:IsA("Bone") then
                    AddToHierarchy(child, indent)
                end
                ProcessDescendants(child, indent + 1)
            end
        end
        
        ProcessDescendants(object, 1)
    end
    
    -- Atualizar canvas size
    local layout = bonesScroll:FindFirstChild("UIListLayout")
    if layout then
        bonesScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end
end

function SelectionSystem:SelectPart(part)
    table.insert(self.SelectedParts, part)
    
    -- Visual feedback
    if part:IsA("BasePart") then
        local highlight = Instance.new("SelectionBox")
        highlight.Name = "AnimatorSelection"
        highlight.Adornee = part
        highlight.Color3 = Colors.Accent
        highlight.LineThickness = 0.03
        highlight.Parent = part
        
        task.delay(0.5, function()
            if highlight then highlight:Destroy() end
        end)
    end
end

-- Botão Selecionar Objeto
local selectBtn = actionsScroll:FindFirstChild("Selecionar")
if selectBtn then
    selectBtn.MouseButton1Click:Connect(function()
        -- Usar seleção do Studio Lite
        local selected = Selection:Get()
        if #selected > 0 then
            SelectionSystem:SelectObject(selected[1])
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("✅ Objeto Selecionado", selected[1].Name, 2)
            end
        else
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("⚠️ Aviso", "Selecione um objeto no Explorer primeiro!", 3)
            end
        end
    end)
end

-- Botão Adicionar Keyframe
local addKeyBtn = actionsScroll:FindFirstChild("Add Key")
if addKeyBtn then
    addKeyBtn.MouseButton1Click:Connect(function()
        local currentFrame = math.floor(PlaybackSystem.CurrentFrame)
        
        for _, part in ipairs(SelectionSystem.SelectedParts) do
            if part:IsA("BasePart") then
                local data = {
                    CFrame = part.CFrame,
                    Size = part.Size,
                    Transparency = part.Transparency
                }
                KeyframeSystem:AddKeyframe(part.Name, currentFrame, data)
            end
        end
        
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("🔑 Keyframe Adicionado", "Frame: " .. currentFrame, 2)
        end
    end)
end

-- Botão Deletar Keyframe
local delKeyBtn = actionsScroll:FindFirstChild("Del Key")
if delKeyBtn then
    delKeyBtn.MouseButton1Click:Connect(function()
        local currentFrame = math.floor(PlaybackSystem.CurrentFrame)
        
        for _, part in ipairs(SelectionSystem.SelectedParts) do
            KeyframeSystem:RemoveKeyframe(part.Name, currentFrame)
        end
        
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("🗑️ Keyframe Removido", "Frame: " .. currentFrame, 2)
        end
    end)
end

-- Sistema de Export
local ExportSystem = {}

function ExportSystem:GenerateCode()
    local code = [[
-- ⚡☠️ MORTAL ANIMATOR - Animação Exportada ☠️⚡
-- Gerado automaticamente pelo Mortal Animator V1

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local AnimationData = {
    FPS = ]] .. AnimatorData.FPS .. [[,
    TotalFrames = ]] .. AnimatorData.TotalFrames .. [[,
    Tracks = {
]]
    
    for trackName, track in pairs(KeyframeSystem.Tracks) do
        code = code .. "        [\"" .. trackName .. "\"] = {\n"
        code = code .. "            Keyframes = {\n"
        
        for frame, keyframeData in pairs(track.Keyframes) do
            local data = keyframeData.Data
            if data.CFrame then
                local cf = data.CFrame
                code = code .. string.format(
                    "                [%d] = {CFrame = CFrame.new(%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f)},\n",
                    frame,
                    cf.X, cf.Y, cf.Z,
                    cf:GetComponents()
                )
            end
        end
        
        code = code .. "            }\n"
        code = code .. "        },\n"
    end
    
    code = code .. [[
    }
}

-- Função para reproduzir animação
local function PlayAnimation(targetObject)
    local connection
    local currentFrame = 0
    
    connection = RunService.Heartbeat:Connect(function(dt)
        currentFrame = currentFrame + (AnimationData.FPS * dt)
        
        if currentFrame >= AnimationData.TotalFrames then
            connection:Disconnect()
            return
        end
        
        -- Aplicar transformações
        for trackName, trackData in pairs(AnimationData.Tracks) do
            local part = targetObject:FindFirstChild(trackName, true)
            if part then
                -- Interpolação entre keyframes
                local prevFrame, nextFrame = nil, nil
                local prevData, nextData = nil, nil
                
                for kf, data in pairs(trackData.Keyframes) do
                    if kf <= currentFrame and (not prevFrame or kf > prevFrame) then
                        prevFrame = kf
                        prevData = data
                    end
                    if kf > currentFrame and (not nextFrame or kf < nextFrame) then
                        nextFrame = kf
                        nextData = data
                    end
                end
                
                if prevData and nextData and prevFrame and nextFrame then
                    local alpha = (currentFrame - prevFrame) / (nextFrame - prevFrame)
                    if prevData.CFrame and nextData.CFrame then
                        part.CFrame = prevData.CFrame:Lerp(nextData.CFrame, alpha)
                    end
                elseif prevData and prevData.CFrame then
                    part.CFrame = prevData.CFrame
                end
            end
        end
    end)
    
    return connection
end

return PlayAnimation
]]
    
    return code
end

function ExportSystem:ShowExportDialog()
    local exportFrame = Instance.new("Frame")
    exportFrame.Name = "ExportDialog"
    exportFrame.Size = UDim2.new(0, isMobile and 320 or 500, 0, isMobile and 400 or 450)
    exportFrame.Position = UDim2.new(0.5, isMobile and -160 or -250, 0.5, isMobile and -200 or -225)
    exportFrame.BackgroundColor3 = Colors.Background
    exportFrame.BorderSizePixel = 0
    exportFrame.ZIndex = 40
    exportFrame.Parent = AnimatorGui
    CreateCorner(exportFrame, 16)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Gold
    stroke.Thickness = 2
    stroke.Parent = exportFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Colors.Secondary
    title.Text = "💾 EXPORTAR ANIMAÇÃO"
    title.TextColor3 = Colors.Gold
    title.TextSize = 18
    title.Font = Enum.Font.GothamBlack
    title.ZIndex = 41
    title.Parent = exportFrame
    CreateCorner(title, 16)
    
    local closeExport = Instance.new("TextButton")
    closeExport.Size = UDim2.new(0, 30, 0, 30)
    closeExport.Position = UDim2.new(1, -35, 0, 5)
    closeExport.BackgroundColor3 = Colors.Red
    closeExport.Text = "✕"
    closeExport.TextColor3 = Colors.Text
    closeExport.TextSize = 14
    closeExport.Font = Enum.Font.GothamBold
    closeExport.BorderSizePixel = 0
    closeExport.ZIndex = 42
    closeExport.Parent = exportFrame
    CreateCorner(closeExport, 8)
    
    closeExport.MouseButton1Click:Connect(function()
        TweenService:Create(exportFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        exportFrame:Destroy()
    end)
    
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -20, 0, 40)
    description.Position = UDim2.new(0, 10, 0, 45)
    description.BackgroundTransparency = 1
    description.Text = "Copie o código abaixo e cole em um LocalScript/Script"
    description.TextColor3 = Colors.TextDark
    description.TextSize = 12
    description.Font = Enum.Font.Gotham
    description.TextWrapped = true
    description.ZIndex = 41
    description.Parent = exportFrame
    
    local codeBox = Instance.new("ScrollingFrame")
    codeBox.Size = UDim2.new(1, -20, 1, -140)
    codeBox.Position = UDim2.new(0, 10, 0, 90)
    codeBox.BackgroundColor3 = Colors.Tertiary
    codeBox.BorderSizePixel = 0
    codeBox.ScrollBarThickness = 4
    codeBox.ZIndex = 41
    codeBox.Parent = exportFrame
    CreateCorner(codeBox, 8)
    
    local codeText = Instance.new("TextBox")
    codeText.Size = UDim2.new(1, -10, 0, 2000)
    codeText.Position = UDim2.new(0, 5, 0, 5)
    codeText.BackgroundTransparency = 1
    codeText.Text = self:GenerateCode()
    codeText.TextColor3 = Colors.Green
    codeText.TextSize = 10
    codeText.Font = Enum.Font.Code
    codeText.TextXAlignment = Enum.TextXAlignment.Left
    codeText.TextYAlignment = Enum.TextYAlignment.Top
    codeText.TextWrapped = true
    codeText.ClearTextOnFocus = false
    codeText.ZIndex = 42
    codeText.Parent = codeBox
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(1, -20, 0, 35)
    copyBtn.Position = UDim2.new(0, 10, 1, -45)
    copyBtn.BackgroundColor3 = Colors.Green
    copyBtn.Text = "📋 COPIAR CÓDIGO"
    copyBtn.TextColor3 = Colors.Text
    copyBtn.TextSize = 14
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.BorderSizePixel = 0
    copyBtn.ZIndex = 41
    copyBtn.Parent = exportFrame
    CreateCorner(copyBtn, 8)
    
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(codeText.Text)
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("✅ Copiado!", "Código copiado para a área de transferência", 2)
            end
        else
            codeText:CaptureFocus()
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("📋 Selecione", "Selecione e copie manualmente (Ctrl+C)", 3)
            end
        end
    end)
    
    -- Animação de entrada
    exportFrame.Size = UDim2.new(0, 0, 0, 0)
    exportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(exportFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, isMobile and 320 or 500, 0, isMobile and 400 or 450),
        Position = UDim2.new(0.5, isMobile and -160 or -250, 0.5, isMobile and -200 or -225)
    }):Play()
end

-- Conectar botão Export
local exportBtn = actionsScroll:FindFirstChild("Export")
if exportBtn then
    exportBtn.MouseButton1Click:Connect(function()
        ExportSystem:ShowExportDialog()
    end)
end

-- Toggle do Animator
local animatorToggle = AnimatorGui:FindFirstChild("AnimatorToggle")
local animatorVisible = false

if animatorToggle then
    animatorToggle.MouseButton1Click:Connect(function()
        animatorVisible = not animatorVisible
        
        if animatorVisible then
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, isMobile and 360 or 900, 0, isMobile and 550 or 600),
                Position = UDim2.new(0.5, isMobile and -180 or -450, 0.5, isMobile and -275 or -300)
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
end

-- Botão fechar
local closeBtn = mainFrame:FindFirstChild("Header"):FindFirstChild("TextButton") or mainFrame.Header:GetChildren()[3]
for _, child in ipairs(mainFrame.Header:GetChildren()) do
    if child:IsA("TextButton") and child.Text == "✕" then
        child.MouseButton1Click:Connect(function()
            animatorVisible = false
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
            task.wait(0.3)
            mainFrame.Visible = false
        end)
    end
end

-- Exportar sistemas
_G.SelectionSystem = SelectionSystem
_G.ExportSystem = ExportSystem

-- Notificação de carregamento
task.wait(0.5)
if _G.ShowMortalNotification then
    _G.ShowMortalNotification(
        "👑☠️MORTAL ANIMATOR☠️👑",
        "Carregado com Sucesso!\n\nAproveite essa ferramenta profissional nível de jogos de Consoles⚡",
        5
    )
end

-- Função para carregar o Animator (usado pelo menu principal)
_G.LoadMortalAnimator = function()
    animatorVisible = true
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, isMobile and 360 or 900, 0, isMobile and 550 or 600),
        Position = UDim2.new(0.5, isMobile and -180 or -450, 0.5, isMobile and -275 or -300)
    }):Play()
end

print("⚡☠️ MORTAL ANIMATOR V1 - COMPLETAMENTE CARREGADO ☠️⚡")

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

-- 🌑☠️ MORTAL DARKNESS TERRAIN EDITOR V1 ☠️🌑
-- Parte 1 - Interface Principal
-- Inspirado em: Blender, Unreal 5.7, Unity, Roblox Studio
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Cores do tema escuro
local Colors = {
    Background = Color3.fromRGB(10, 10, 15),
    Secondary = Color3.fromRGB(20, 20, 28),
    Tertiary = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(100, 50, 150),
    AccentDark = Color3.fromRGB(60, 20, 100),
    Purple = Color3.fromRGB(138, 43, 226),
    DarkPurple = Color3.fromRGB(75, 0, 130),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(160, 160, 170),
    Red = Color3.fromRGB(200, 50, 70),
    Green = Color3.fromRGB(50, 200, 100),
    Blue = Color3.fromRGB(50, 150, 255),
    Gold = Color3.fromRGB(255, 200, 50),
    Orange = Color3.fromRGB(255, 140, 0),
    Cyan = Color3.fromRGB(0, 200, 200),
    TerrainGreen = Color3.fromRGB(80, 150, 80),
    TerrainBrown = Color3.fromRGB(139, 90, 43),
    Water = Color3.fromRGB(30, 100, 180)
}

-- Remover GUI anterior
if playerGui:FindFirstChild("MortalTerrainGUI") then
    playerGui.MortalTerrainGUI:Destroy()
end

-- Criar ScreenGui
local TerrainGui = Instance.new("ScreenGui")
TerrainGui.Name = "MortalTerrainGUI"
TerrainGui.ResetOnSpawn = false
TerrainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TerrainGui.Parent = playerGui

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
    shadow.ImageTransparency = 0.4
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Accent
    stroke.Thickness = thickness or 2
    stroke.Parent = parent
    return stroke
end

-- Dados do Terrain Editor
local TerrainData = {
    BrushSize = 10,
    BrushStrength = 0.5,
    BrushShape = "Circle", -- Circle, Square
    CurrentTool = "Raise",
    CurrentMaterial = Enum.Material.Grass,
    CurrentStyle = "Realistic",
    WaterLevel = 0,
    IsEditing = false,
    UndoStack = {},
    RedoStack = {}
}

-- Materiais disponíveis com cores
local TerrainMaterials = {
    {name = "Grass", material = Enum.Material.Grass, color = Color3.fromRGB(80, 150, 80), icon = "🌿"},
    {name = "Sand", material = Enum.Material.Sand, color = Color3.fromRGB(220, 190, 130), icon = "🏖️"},
    {name = "Rock", material = Enum.Material.Rock, color = Color3.fromRGB(120, 120, 120), icon = "🪨"},
    {name = "Ground", material = Enum.Material.Ground, color = Color3.fromRGB(139, 90, 43), icon = "🟤"},
    {name = "Snow", material = Enum.Material.Snow, color = Color3.fromRGB(240, 240, 255), icon = "❄️"},
    {name = "Mud", material = Enum.Material.Mud, color = Color3.fromRGB(90, 60, 40), icon = "💩"},
    {name = "Slate", material = Enum.Material.Slate, color = Color3.fromRGB(80, 80, 90), icon = "⬛"},
    {name = "Concrete", material = Enum.Material.Concrete, color = Color3.fromRGB(150, 150, 150), icon = "🧱"},
    {name = "Brick", material = Enum.Material.Brick, color = Color3.fromRGB(180, 80, 60), icon = "🧱"},
    {name = "Cobblestone", material = Enum.Material.Cobblestone, color = Color3.fromRGB(100, 100, 100), icon = "🔲"},
    {name = "Ice", material = Enum.Material.Ice, color = Color3.fromRGB(200, 230, 255), icon = "🧊"},
    {name = "Glacier", material = Enum.Material.Glacier, color = Color3.fromRGB(180, 220, 255), icon = "🏔️"},
    {name = "Sandstone", material = Enum.Material.Sandstone, color = Color3.fromRGB(200, 170, 130), icon = "🏜️"},
    {name = "Basalt", material = Enum.Material.Basalt, color = Color3.fromRGB(50, 50, 55), icon = "⚫"},
    {name = "CrackedLava", material = Enum.Material.CrackedLava, color = Color3.fromRGB(200, 50, 0), icon = "🌋"},
    {name = "Asphalt", material = Enum.Material.Asphalt, color = Color3.fromRGB(40, 40, 45), icon = "🛣️"},
    {name = "LeafyGrass", material = Enum.Material.LeafyGrass, color = Color3.fromRGB(60, 140, 60), icon = "🍃"},
    {name = "Limestone", material = Enum.Material.Limestone, color = Color3.fromRGB(200, 195, 180), icon = "⬜"},
    {name = "Pavement", material = Enum.Material.Pavement, color = Color3.fromRGB(130, 130, 130), icon = "🚶"},
    {name = "Salt", material = Enum.Material.Salt, color = Color3.fromRGB(250, 250, 250), icon = "🧂"},
}

-- Botão Toggle (arrastável)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "TerrainToggle"
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 20, 0, 220)
toggleBtn.BackgroundColor3 = Colors.Secondary
toggleBtn.Text = "🌑"
toggleBtn.TextSize = 28
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 50
toggleBtn.Parent = TerrainGui
CreateCorner(toggleBtn, 27)
CreateShadow(toggleBtn)

local toggleGlow = Instance.new("Frame")
toggleGlow.Size = UDim2.new(1, 8, 1, 8)
toggleGlow.Position = UDim2.new(0, -4, 0, -4)
toggleGlow.BackgroundTransparency = 0.6
toggleGlow.ZIndex = 49
toggleGlow.Parent = toggleBtn
CreateCorner(toggleGlow, 31)
CreateGradient(toggleGlow, Colors.DarkPurple, Colors.Purple, 45)

-- Sistema de arrastar
local dragging = false
local dragStart, startPos

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Frame Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, isMobile and 350 or 950, 0, isMobile and 520 or 600)
mainFrame.Position = UDim2.new(0.5, isMobile and -175 or -475, 0.5, isMobile and -260 or -300)
mainFrame.BackgroundColor3 = Colors.Background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 20
mainFrame.Parent = TerrainGui
CreateCorner(mainFrame, 16)
CreateShadow(mainFrame)
CreateStroke(mainFrame, Colors.DarkPurple, 2)

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 55)
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

-- Título com efeito
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌑☠️ MORTAL DARKNESS TERRAIN EDITOR ☠️🌑"
titleLabel.TextColor3 = Colors.Purple
titleLabel.TextSize = isMobile and 12 or 18
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 22
titleLabel.Parent = header

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, 0, 0, 20)
subtitleLabel.Position = UDim2.new(0, 0, 0, 58)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Ultra Realistic Terrain • 4K Textures • Physics • Inspired by Unreal 5.7 & Blender"
subtitleLabel.TextColor3 = Colors.TextDark
subtitleLabel.TextSize = isMobile and 9 or 11
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.ZIndex = 21
subtitleLabel.Parent = mainFrame

-- Botão Fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0.5, -20)
closeBtn.BackgroundColor3 = Colors.Red
closeBtn.Text = "✕"
closeBtn.TextColor3 = Colors.Text
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 22
closeBtn.Parent = header
CreateCorner(closeBtn, 10)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    mainFrame.Visible = false
end)

-- Painel Esquerdo - Ferramentas
local toolsPanel = Instance.new("Frame")
toolsPanel.Name = "ToolsPanel"
toolsPanel.Size = UDim2.new(0, isMobile and 80 or 180, 1, -180)
toolsPanel.Position = UDim2.new(0, 10, 0, 85)
toolsPanel.BackgroundColor3 = Colors.Secondary
toolsPanel.BorderSizePixel = 0
toolsPanel.ZIndex = 21
toolsPanel.Parent = mainFrame
CreateCorner(toolsPanel, 12)

local toolsTitle = Instance.new("TextLabel")
toolsTitle.Size = UDim2.new(1, 0, 0, 30)
toolsTitle.BackgroundColor3 = Colors.Tertiary
toolsTitle.Text = "🔧 Ferramentas"
toolsTitle.TextColor3 = Colors.Text
toolsTitle.TextSize = 11
toolsTitle.Font = Enum.Font.GothamBold
toolsTitle.ZIndex = 22
toolsTitle.Parent = toolsPanel
CreateCorner(toolsTitle, 12)

-- Lista de Ferramentas
local toolsScroll = Instance.new("ScrollingFrame")
toolsScroll.Size = UDim2.new(1, -10, 1, -40)
toolsScroll.Position = UDim2.new(0, 5, 0, 35)
toolsScroll.BackgroundTransparency = 1
toolsScroll.ScrollBarThickness = 3
toolsScroll.ScrollBarImageColor3 = Colors.Purple
toolsScroll.ZIndex = 22
toolsScroll.CanvasSize = UDim2.new(0, 0, 0, 600)
toolsScroll.Parent = toolsPanel

local toolsLayout = Instance.new("UIListLayout")
toolsLayout.SortOrder = Enum.SortOrder.LayoutOrder
toolsLayout.Padding = UDim.new(0, 5)
toolsLayout.Parent = toolsScroll

-- Ferramentas disponíveis
local tools = {
    {name = "Raise", icon = "⬆️", desc = "Elevar terreno", color = Colors.Green},
    {name = "Lower", icon = "⬇️", desc = "Abaixar terreno", color = Colors.Red},
    {name = "Flatten", icon = "➖", desc = "Nivelar terreno", color = Colors.Blue},
    {name = "Smooth", icon = "〰️", desc = "Suavizar terreno", color = Colors.Cyan},
    {name = "Paint", icon = "🎨", desc = "Pintar material", color = Colors.Purple},
    {name = "Erode", icon = "💨", desc = "Erosão natural", color = Colors.Orange},
    {name = "Grow", icon = "🌱", desc = "Crescer vegetação", color = Colors.TerrainGreen},
    {name = "Sea Level", icon = "🌊", desc = "Nível do mar", color = Colors.Water},
    {name = "Add", icon = "➕", desc = "Adicionar terreno", color = Colors.Green},
    {name = "Subtract", icon = "➖", desc = "Remover terreno", color = Colors.Red},
    {name = "Fill Region", icon = "⬛", desc = "Preencher região", color = Colors.Gold},
    {name = "Replace", icon = "🔄", desc = "Substituir material", color = Colors.Cyan},
}

local selectedToolButton = nil

for i, tool in ipairs(tools) do
    local btn = Instance.new("TextButton")
    btn.Name = tool.name
    btn.Size = UDim2.new(1, 0, 0, isMobile and 35 or 40)
    btn.BackgroundColor3 = Colors.Tertiary
    btn.Text = tool.icon .. (isMobile and "" or " " .. tool.name)
    btn.TextColor3 = Colors.Text
    btn.TextSize = isMobile and 14 or 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = isMobile and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.ZIndex = 23
    btn.LayoutOrder = i
    btn.Parent = toolsScroll
    CreateCorner(btn, 8)
    
    -- Indicador de cor
    local colorIndicator = Instance.new("Frame")
    colorIndicator.Size = UDim2.new(0, 4, 1, -8)
    colorIndicator.Position = UDim2.new(0, 4, 0, 4)
    colorIndicator.BackgroundColor3 = tool.color
    colorIndicator.BorderSizePixel = 0
    colorIndicator.ZIndex = 24
    colorIndicator.Parent = btn
    CreateCorner(colorIndicator, 2)
    
    btn.MouseButton1Click:Connect(function()
        TerrainData.CurrentTool = tool.name
        
        -- Atualizar visual
        if selectedToolButton then
            TweenService:Create(selectedToolButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Tertiary}):Play()
        end
        selectedToolButton = btn
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = tool.color}):Play()
        
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("🔧 Ferramenta", tool.name .. " selecionada\n" .. tool.desc, 2)
        end
    end)
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        if btn ~= selectedToolButton then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if btn ~= selectedToolButton then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Tertiary}):Play()
        end
    end)
end

-- Atualizar canvas size
toolsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    toolsScroll.CanvasSize = UDim2.new(0, 0, 0, toolsLayout.AbsoluteContentSize.Y + 10)
end)

-- Painel Central - Materiais
local materialsPanel = Instance.new("Frame")
materialsPanel.Name = "MaterialsPanel"
materialsPanel.Size = UDim2.new(0, isMobile and 160 or 300, 1, -180)
materialsPanel.Position = UDim2.new(0, isMobile and 95 or 200, 0, 85)
materialsPanel.BackgroundColor3 = Colors.Secondary
materialsPanel.BorderSizePixel = 0
materialsPanel.ZIndex = 21
materialsPanel.Parent = mainFrame
CreateCorner(materialsPanel, 12)

local materialsTitle = Instance.new("TextLabel")
materialsTitle.Size = UDim2.new(1, 0, 0, 30)
materialsTitle.BackgroundColor3 = Colors.Tertiary
materialsTitle.Text = "🎨 Materiais (4K Textures)"
materialsTitle.TextColor3 = Colors.Text
materialsTitle.TextSize = 11
materialsTitle.Font = Enum.Font.GothamBold
materialsTitle.ZIndex = 22
materialsTitle.Parent = materialsPanel
CreateCorner(materialsTitle, 12)

local materialsScroll = Instance.new("ScrollingFrame")
materialsScroll.Size = UDim2.new(1, -10, 1, -40)
materialsScroll.Position = UDim2.new(0, 5, 0, 35)
materialsScroll.BackgroundTransparency = 1
materialsScroll.ScrollBarThickness = 3
materialsScroll.ScrollBarImageColor3 = Colors.Purple
materialsScroll.ZIndex = 22
materialsScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
materialsScroll.Parent = materialsPanel

local materialsGrid = Instance.new("UIGridLayout")
materialsGrid.CellSize = UDim2.new(0, isMobile and 45 or 65, 0, isMobile and 45 or 65)
materialsGrid.CellPadding = UDim2.new(0, 5, 0, 5)
materialsGrid.SortOrder = Enum.SortOrder.LayoutOrder
materialsGrid.Parent = materialsScroll

local selectedMaterialButton = nil

for i, mat in ipairs(TerrainMaterials) do
    local btn = Instance.new("TextButton")
    btn.Name = mat.name
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.BackgroundColor3 = mat.color
    btn.Text = mat.icon
    btn.TextSize = isMobile and 18 or 22
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 23
    btn.LayoutOrder = i
    btn.Parent = materialsScroll
    CreateCorner(btn, 10)
    
    -- Label do nome
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 15)
    nameLabel.Position = UDim2.new(0, 0, 1, -15)
    nameLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    nameLabel.BackgroundTransparency = 0.5
    nameLabel.Text = mat.name
    nameLabel.TextColor3 = Colors.Text
    nameLabel.TextSize = 8
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.ZIndex = 24
    nameLabel.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        TerrainData.CurrentMaterial = mat.material
        
        if selectedMaterialButton then
            local prevStroke = selectedMaterialButton:FindFirstChild("SelectStroke")
            if prevStroke then prevStroke:Destroy() end
        end
        
        selectedMaterialButton = btn
        local stroke = Instance.new("UIStroke")
        stroke.Name = "SelectStroke"
        stroke.Color = Colors.Gold
        stroke.Thickness = 3
        stroke.Parent = btn
        
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("🎨 Material", mat.name .. " selecionado", 1.5)
        end
    end)
end

-- Atualizar canvas
materialsGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    materialsScroll.CanvasSize = UDim2.new(0, 0, 0, materialsGrid.AbsoluteContentSize.Y + 20)
end)

-- Painel Direito - Configurações
local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(0, isMobile and 80 or 230, 1, -180)
settingsPanel.Position = UDim2.new(1, isMobile and -90 or -240, 0, 85)
settingsPanel.BackgroundColor3 = Colors.Secondary
settingsPanel.BorderSizePixel = 0
settingsPanel.ZIndex = 21
settingsPanel.Parent = mainFrame
CreateCorner(settingsPanel, 12)

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 30)
settingsTitle.BackgroundColor3 = Colors.Tertiary
settingsTitle.Text = "⚙️ Configurações"
settingsTitle.TextColor3 = Colors.Text
settingsTitle.TextSize = 11
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.ZIndex = 22
settingsTitle.Parent = settingsPanel
CreateCorner(settingsTitle, 12)

-- Exportar variáveis
_G.TerrainMainFrame = mainFrame
_G.TerrainData = TerrainData
_G.TerrainColors = Colors
_G.TerrainMaterials = TerrainMaterials
_G.TerrainGui = TerrainGui

print("🌑 Mortal Terrain Editor - Parte 1 Carregada")

-- 🌑☠️ MORTAL DARKNESS TERRAIN EDITOR V1 ☠️🌑
-- Parte 2 - Configurações de Pincel e Sliders
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TerrainGui = playerGui:WaitForChild("MortalTerrainGUI")
local mainFrame = _G.TerrainMainFrame
local TerrainData = _G.TerrainData
local Colors = _G.TerrainColors

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

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

-- Encontrar painel de settings
local settingsPanel = mainFrame:FindFirstChild("SettingsPanel")
if not settingsPanel then
    warn("Settings panel não encontrado!")
    return
end

-- Container de configurações
local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Name = "SettingsScroll"
settingsScroll.Size = UDim2.new(1, -10, 1, -40)
settingsScroll.Position = UDim2.new(0, 5, 0, 35)
settingsScroll.BackgroundTransparency = 1
settingsScroll.ScrollBarThickness = 3
settingsScroll.ScrollBarImageColor3 = Colors.Purple
settingsScroll.ZIndex = 22
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 600)
settingsScroll.Parent = settingsPanel

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Padding = UDim.new(0, 8)
settingsLayout.Parent = settingsScroll

-- Função para criar Slider
local function CreateSlider(parent, name, minVal, maxVal, defaultVal, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, 0, 0, isMobile and 50 or 60)
    container.BackgroundColor3 = Colors.Tertiary
    container.BorderSizePixel = 0
    container.ZIndex = 23
    container.LayoutOrder = layoutOrder or 0
    container.Parent = parent
    CreateCorner(container, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 18)
    label.Position = UDim2.new(0, 5, 0, 3)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = isMobile and 9 or 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 24
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 40, 0, 18)
    valueLabel.Position = UDim2.new(1, -45, 0, 3)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Colors.Gold
    valueLabel.TextSize = isMobile and 9 or 11
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 24
    valueLabel.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(1, -16, 0, isMobile and 12 or 16)
    sliderBg.Position = UDim2.new(0, 8, 0, isMobile and 28 or 32)
    sliderBg.BackgroundColor3 = Colors.Background
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 24
    sliderBg.Parent = container
    CreateCorner(sliderBg, 8)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    local initialPercent = (defaultVal - minVal) / (maxVal - minVal)
    sliderFill.Size = UDim2.new(initialPercent, 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Purple
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 25
    sliderFill.Parent = sliderBg
    CreateCorner(sliderFill, 8)
    CreateGradient(sliderFill, Colors.AccentDark, Colors.Purple, 0)
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "SliderKnob"
    sliderKnob.Size = UDim2.new(0, isMobile and 16 or 20, 0, isMobile and 16 or 20)
    sliderKnob.Position = UDim2.new(initialPercent, isMobile and -8 or -10, 0.5, isMobile and -8 or -10)
    sliderKnob.BackgroundColor3 = Colors.Text
    sliderKnob.BorderSizePixel = 0
    sliderKnob.ZIndex = 26
    sliderKnob.Parent = sliderBg
    CreateCorner(sliderKnob, 10)
    
    -- Interação do slider
    local draggingSlider = false
    
    local function updateSlider(inputPos)
        local relativeX = inputPos.X - sliderBg.AbsolutePosition.X
        local percent = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
        local value = minVal + (maxVal - minVal) * percent
        
        -- Arredondar para 1 casa decimal
        value = math.floor(value * 10 + 0.5) / 10
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percent, isMobile and -8 or -10, 0.5, isMobile and -8 or -10)
        valueLabel.Text = tostring(value)
        
        if callback then
            callback(value)
        end
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateSlider(input.Position)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    
    return container
end

-- Função para criar Toggle
local function CreateToggle(parent, name, defaultState, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Name = name .. "Toggle"
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundColor3 = Colors.Tertiary
    container.BorderSizePixel = 0
    container.ZIndex = 23
    container.LayoutOrder = layoutOrder or 0
    container.Parent = parent
    CreateCorner(container, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = isMobile and 9 or 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 24
    label.Parent = container
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 45, 0, 22)
    toggleBg.Position = UDim2.new(1, -55, 0.5, -11)
    toggleBg.BackgroundColor3 = defaultState and Colors.Green or Colors.Background
    toggleBg.BorderSizePixel = 0
    toggleBg.ZIndex = 24
    toggleBg.Parent = container
    CreateCorner(toggleBg, 11)
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 18, 0, 18)
    toggleKnob.Position = defaultState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    toggleKnob.BackgroundColor3 = Colors.Text
    toggleKnob.BorderSizePixel = 0
    toggleKnob.ZIndex = 25
    toggleKnob.Parent = toggleBg
    CreateCorner(toggleKnob, 9)
    
    local state = defaultState
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 26
    toggleBtn.Parent = container
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Colors.Green or Colors.Background
        }):Play()
        
        TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        
        if callback then
            callback(state)
        end
    end)
    
    return container, function() return state end
end

-- Função para criar Dropdown
local function CreateDropdown(parent, name, options, defaultOption, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Name = name .. "Dropdown"
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundColor3 = Colors.Tertiary
    container.BorderSizePixel = 0
    container.ZIndex = 23
    container.LayoutOrder = layoutOrder or 0
    container.ClipsDescendants = false
    container.Parent = parent
    CreateCorner(container, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 3)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = isMobile and 9 or 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 24
    label.Parent = container
    
    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(1, -16, 0, 28)
    dropBtn.Position = UDim2.new(0, 8, 0, 26)
    dropBtn.BackgroundColor3 = Colors.Background
    dropBtn.Text = defaultOption .. " ▼"
    dropBtn.TextColor3 = Colors.Gold
    dropBtn.TextSize = isMobile and 10 or 12
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.BorderSizePixel = 0
    dropBtn.ZIndex = 24
    dropBtn.Parent = container
    CreateCorner(dropBtn, 6)
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Name = "DropdownList"
    dropdownList.Size = UDim2.new(1, -16, 0, #options * 28)
    dropdownList.Position = UDim2.new(0, 8, 1, 5)
    dropdownList.BackgroundColor3 = Colors.Secondary
    dropdownList.BorderSizePixel = 0
    dropdownList.ZIndex = 30
    dropdownList.Visible = false
    dropdownList.Parent = container
    CreateCorner(dropdownList, 8)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = dropdownList
    
    local currentOption = defaultOption
    
    for i, option in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 28)
        optBtn.BackgroundColor3 = option == currentOption and Colors.Purple or Colors.Tertiary
        optBtn.Text = option
        optBtn.TextColor3 = Colors.Text
        optBtn.TextSize = isMobile and 9 or 11
        optBtn.Font = Enum.Font.Gotham
        optBtn.BorderSizePixel = 0
        optBtn.ZIndex = 31
        optBtn.LayoutOrder = i
        optBtn.Parent = dropdownList
        
        optBtn.MouseButton1Click:Connect(function()
            currentOption = option
            dropBtn.Text = option .. " ▼"
            dropdownList.Visible = false
            
            -- Atualizar cores
            for _, child in ipairs(dropdownList:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = child.Text == option and Colors.Purple or Colors.Tertiary
                end
            end
            
            if callback then
                callback(option)
            end
        end)
    end
    
    dropBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    return container
end

-- Seção: Tamanho do Pincel
local brushSection = Instance.new("TextLabel")
brushSection.Size = UDim2.new(1, 0, 0, 25)
brushSection.BackgroundColor3 = Colors.AccentDark
brushSection.Text = "🖌️ Pincel"
brushSection.TextColor3 = Colors.Text
brushSection.TextSize = 11
brushSection.Font = Enum.Font.GothamBlack
brushSection.ZIndex = 23
brushSection.LayoutOrder = 1
brushSection.Parent = settingsScroll
CreateCorner(brushSection, 6)

-- Slider: Tamanho do Pincel
CreateSlider(settingsScroll, "Tamanho", 1, 50, TerrainData.BrushSize, function(value)
    TerrainData.BrushSize = value
end, 2)

-- Slider: Força do Pincel
CreateSlider(settingsScroll, "Força", 0.1, 1, TerrainData.BrushStrength, function(value)
    TerrainData.BrushStrength = value
end, 3)

-- Dropdown: Forma do Pincel
CreateDropdown(settingsScroll, "Forma", {"Circle", "Square", "Sphere"}, "Circle", function(option)
    TerrainData.BrushShape = option
end, 4)

-- Seção: Estilo de Terreno
local styleSection = Instance.new("TextLabel")
styleSection.Size = UDim2.new(1, 0, 0, 25)
styleSection.BackgroundColor3 = Colors.AccentDark
styleSection.Text = "🎨 Estilo"
styleSection.TextColor3 = Colors.Text
styleSection.TextSize = 11
styleSection.Font = Enum.Font.GothamBlack
styleSection.ZIndex = 23
styleSection.LayoutOrder = 5
styleSection.Parent = settingsScroll
CreateCorner(styleSection, 6)

-- Dropdown: Estilo do Terreno
CreateDropdown(settingsScroll, "Preset", {
    "Ultra Realistic",
    "Stylized",
    "Low Poly",
    "Fantasy",
    "Sci-Fi",
    "Desert",
    "Arctic",
    "Volcanic",
    "Tropical"
}, "Ultra Realistic", function(option)
    TerrainData.CurrentStyle = option
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🎨 Estilo", option .. " ativado!", 2)
    end
end, 6)

-- Seção: Física
local physicsSection = Instance.new("TextLabel")
physicsSection.Size = UDim2.new(1, 0, 0, 25)
physicsSection.BackgroundColor3 = Colors.AccentDark
physicsSection.Text = "⚡ Física"
physicsSection.TextColor3 = Colors.Text
physicsSection.TextSize = 11
physicsSection.Font = Enum.Font.GothamBlack
physicsSection.ZIndex = 23
physicsSection.LayoutOrder = 7
physicsSection.Parent = settingsScroll
CreateCorner(physicsSection, 6)

-- Toggle: Física Realista
CreateToggle(settingsScroll, "Física Realista", true, function(state)
    TerrainData.RealisticPhysics = state
end, 8)

-- Toggle: Vento
CreateToggle(settingsScroll, "Vento Global", false, function(state)
    TerrainData.WindEnabled = state
    if state then
        -- Criar vento
        local wind = Workspace:FindFirstChild("GlobalWind")
        if not wind then
            Workspace.GlobalWind = Vector3.new(5, 0, 2)
        end
    else
        Workspace.GlobalWind = Vector3.new(0, 0, 0)
    end
end, 9)

-- Toggle: Água Interativa
CreateToggle(settingsScroll, "Água Interativa", true, function(state)
    TerrainData.InteractiveWater = state
end, 10)

-- Slider: Nível da Água
CreateSlider(settingsScroll, "Nível da Água", -100, 200, 0, function(value)
    TerrainData.WaterLevel = value
end, 11)

-- Seção: Geração
local genSection = Instance.new("TextLabel")
genSection.Size = UDim2.new(1, 0, 0, 25)
genSection.BackgroundColor3 = Colors.AccentDark
genSection.Text = "🌍 Geração"
genSection.TextColor3 = Colors.Text
genSection.TextSize = 11
genSection.Font = Enum.Font.GothamBlack
genSection.ZIndex = 23
genSection.LayoutOrder = 12
genSection.Parent = settingsScroll
CreateCorner(genSection, 6)

-- Slider: Seed
CreateSlider(settingsScroll, "Seed", 1, 9999, math.random(1, 9999), function(value)
    TerrainData.Seed = math.floor(value)
end, 13)

-- Slider: Escala do Ruído
CreateSlider(settingsScroll, "Escala Ruído", 10, 500, 100, function(value)
    TerrainData.NoiseScale = value
end, 14)

-- Slider: Amplitude
CreateSlider(settingsScroll, "Amplitude", 10, 200, 50, function(value)
    TerrainData.Amplitude = value
end, 15)

-- Atualizar canvas size
settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    settingsScroll.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 20)
end)

-- Exportar
_G.TerrainSettingsScroll = settingsScroll

print("🌑 Mortal Terrain Editor - Parte 2 Carregada (Configurações)")

-- 🌑☠️ MORTAL DARKNESS TERRAIN EDITOR V1 ☠️🌑
-- Parte 3 - Sistema de Edição e Geração
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TerrainGui = playerGui:WaitForChild("MortalTerrainGUI")
local mainFrame = _G.TerrainMainFrame
local TerrainData = _G.TerrainData
local Colors = _G.TerrainColors

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local terrain = Workspace:WaitForChild("Terrain")

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

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE EDIÇÃO DE TERRENO
-- ═══════════════════════════════════════════════════════════════

local TerrainEditor = {}
TerrainEditor.IsEditing = false
TerrainEditor.BrushIndicator = nil
TerrainEditor.EditConnection = nil
TerrainEditor.UndoStack = {}
TerrainEditor.RedoStack = {}

-- Criar indicador de pincel
function TerrainEditor:CreateBrushIndicator()
    if self.BrushIndicator then
        self.BrushIndicator:Destroy()
    end
    
    local indicator = Instance.new("Part")
    indicator.Name = "TerrainBrushIndicator"
    indicator.Shape = Enum.PartType.Cylinder
    indicator.Size = Vector3.new(0.5, TerrainData.BrushSize * 2, TerrainData.BrushSize * 2)
    indicator.CFrame = CFrame.new(0, 1000, 0) * CFrame.Angles(0, 0, math.rad(90))
    indicator.Anchored = true
    indicator.CanCollide = false
    indicator.Transparency = 0.6
    indicator.Color = Colors.Purple
    indicator.Material = Enum.Material.Neon
    indicator.Parent = Workspace
    
    self.BrushIndicator = indicator
    return indicator
end

-- Atualizar tamanho do indicador
function TerrainEditor:UpdateBrushSize()
    if self.BrushIndicator then
        self.BrushIndicator.Size = Vector3.new(0.5, TerrainData.BrushSize * 2, TerrainData.BrushSize * 2)
    end
end

-- Obter posição do mouse no mundo
function TerrainEditor:GetMousePosition()
    local mouse = player:GetMouse()
    local camera = Workspace.CurrentCamera
    
    if isMobile then
        -- Para mobile, usar centro da tela ou último toque
        local screenPos = camera.ViewportSize / 2
        local ray = camera:ViewportPointToRay(screenPos.X, screenPos.Y)
        local raycast = Workspace:Raycast(ray.Origin, ray.Direction * 1000)
        
        if raycast then
            return raycast.Position
        end
    else
        local target = mouse.Target
        if target then
            return mouse.Hit.Position
        end
    end
    
    return nil
end

-- Função principal de edição
function TerrainEditor:ApplyBrush(position)
    if not position then return end
    
    local size = TerrainData.BrushSize
    local strength = TerrainData.BrushStrength
    local tool = TerrainData.CurrentTool
    local material = TerrainData.CurrentMaterial
    
    local region = Region3.new(
        position - Vector3.new(size, size, size),
        position + Vector3.new(size, size, size)
    )
    
    -- Expandir para resolução do terreno (4 studs)
    region = region:ExpandToGrid(4)
    
    if tool == "Raise" then
        -- Elevar terreno
        local materials, occupancy = terrain:ReadVoxels(region, 4)
        local sizeX, sizeY, sizeZ = materials.Size.X, materials.Size.Y, materials.Size.Z
        
        for x = 1, sizeX do
            for z = 1, sizeZ do
                for y = sizeY, 1, -1 do
                    local dist = math.sqrt((x - sizeX/2)^2 + (z - sizeZ/2)^2)
                    local falloff = math.max(0, 1 - dist / (sizeX/2))
                    
                    if y < sizeY * (0.5 + strength * falloff * 0.3) then
                        if materials[x][y][z] == Enum.Material.Air then
                            materials[x][y][z] = material
                            occupancy[x][y][z] = strength * falloff
                        end
                    end
                end
            end
        end
        
        terrain:WriteVoxels(region, 4, materials, occupancy)
        
    elseif tool == "Lower" then
        -- Abaixar terreno
        local materials, occupancy = terrain:ReadVoxels(region, 4)
        local sizeX, sizeY, sizeZ = materials.Size.X, materials.Size.Y, materials.Size.Z
        
        for x = 1, sizeX do
            for z = 1, sizeZ do
                for y = 1, sizeY do
                    local dist = math.sqrt((x - sizeX/2)^2 + (z - sizeZ/2)^2)
                    local falloff = math.max(0, 1 - dist / (sizeX/2))
                    
                    if y > sizeY * (0.5 - strength * falloff * 0.3) then
                        occupancy[x][y][z] = math.max(0, occupancy[x][y][z] - strength * falloff * 0.5)
                        if occupancy[x][y][z] <= 0 then
                            materials[x][y][z] = Enum.Material.Air
                        end
                    end
                end
            end
        end
        
        terrain:WriteVoxels(region, 4, materials, occupancy)
        
    elseif tool == "Flatten" then
        -- Nivelar terreno
        local targetY = position.Y
        terrain:FillBlock(CFrame.new(position), Vector3.new(size * 2, 4, size * 2), material)
        
    elseif tool == "Smooth" then
        -- Suavizar terreno usando erosão
        local materials, occupancy = terrain:ReadVoxels(region, 4)
        local sizeX, sizeY, sizeZ = materials.Size.X, materials.Size.Y, materials.Size.Z
        
        -- Aplicar blur simples
        local newOccupancy = table.clone(occupancy)
        
        for x = 2, sizeX - 1 do
            for y = 2, sizeY - 1 do
                for z = 2, sizeZ - 1 do
                    local sum = 0
                    local count = 0
                    
                    for dx = -1, 1 do
                        for dy = -1, 1 do
                            for dz = -1, 1 do
                                sum = sum + occupancy[x+dx][y+dy][z+dz]
                                count = count + 1
                            end
                        end
                    end
                    
                    newOccupancy[x][y][z] = sum / count
                end
            end
        end
        
        terrain:WriteVoxels(region, 4, materials, newOccupancy)
        
    elseif tool == "Paint" then
        -- Pintar material
        terrain:ReplaceMaterial(region, 4, Enum.Material.Grass, material)
        terrain:ReplaceMaterial(region, 4, Enum.Material.Sand, material)
        terrain:ReplaceMaterial(region, 4, Enum.Material.Rock, material)
        terrain:ReplaceMaterial(region, 4, Enum.Material.Ground, material)
        
    elseif tool == "Add" then
        -- Adicionar terreno esférico
        if TerrainData.BrushShape == "Sphere" then
            terrain:FillBall(position, size, material)
        elseif TerrainData.BrushShape == "Square" then
            terrain:FillBlock(CFrame.new(position), Vector3.new(size * 2, size * 2, size * 2), material)
        else
            terrain:FillCylinder(CFrame.new(position), size * 2, size, material)
        end
        
    elseif tool == "Subtract" then
        -- Remover terreno
        if TerrainData.BrushShape == "Sphere" then
            terrain:FillBall(position, size, Enum.Material.Air)
        elseif TerrainData.BrushShape == "Square" then
            terrain:FillBlock(CFrame.new(position), Vector3.new(size * 2, size * 2, size * 2), Enum.Material.Air)
        else
            terrain:FillCylinder(CFrame.new(position), size * 2, size, Enum.Material.Air)
        end
        
    elseif tool == "Sea Level" then
        -- Definir nível do mar
        local waterRegion = Region3.new(
            Vector3.new(position.X - 500, position.Y - 50, position.Z - 500),
            Vector3.new(position.X + 500, position.Y, position.Z + 500)
        ):ExpandToGrid(4)
        
        terrain:FillRegion(waterRegion, 4, Enum.Material.Water)
        
    elseif tool == "Erode" then
        -- Erosão natural
        local materials, occupancy = terrain:ReadVoxels(region, 4)
        local sizeX, sizeY, sizeZ = materials.Size.X, materials.Size.Y, materials.Size.Z
        
        for x = 1, sizeX do
            for z = 1, sizeZ do
                for y = sizeY, 1, -1 do
                    if materials[x][y][z] ~= Enum.Material.Air then
                        -- Simular erosão
                        local erosionChance = math.random() * strength
                        if erosionChance > 0.7 then
                            occupancy[x][y][z] = math.max(0, occupancy[x][y][z] - 0.2)
                            if occupancy[x][y][z] <= 0 then
                                materials[x][y][z] = Enum.Material.Air
                            end
                        end
                    end
                end
            end
        end
        
        terrain:WriteVoxels(region, 4, materials, occupancy)
        
    elseif tool == "Grow" then
        -- Crescer vegetação (mudar para LeafyGrass)
        terrain:ReplaceMaterial(region, 4, Enum.Material.Grass, Enum.Material.LeafyGrass)
    end
end

-- Iniciar edição
function TerrainEditor:StartEditing()
    self.IsEditing = true
    self:CreateBrushIndicator()
    
    -- Loop de atualização do indicador
    self.EditConnection = RunService.RenderStepped:Connect(function()
        local pos = self:GetMousePosition()
        if pos and self.BrushIndicator then
            self.BrushIndicator.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
        end
    end)
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🖌️ Modo Edição", "Clique/toque para editar o terreno!", 2)
    end
end

-- Parar edição
function TerrainEditor:StopEditing()
    self.IsEditing = false
    
    if self.BrushIndicator then
        self.BrushIndicator:Destroy()
        self.BrushIndicator = nil
    end
    
    if self.EditConnection then
        self.EditConnection:Disconnect()
        self.EditConnection = nil
    end
end

-- ═══════════════════════════════════════════════════════════════
-- GERADOR DE TERRENO PROCEDURAL
-- ═══════════════════════════════════════════════════════════════

local TerrainGenerator = {}

-- Função de ruído Perlin simplificada
function TerrainGenerator:Noise2D(x, z, seed, scale)
    seed = seed or 12345
    scale = scale or 100
    
    local noiseVal = math.noise(x / scale + seed, z / scale + seed)
    return noiseVal
end

-- Gerar terreno procedural
function TerrainGenerator:GenerateTerrain(options)
    options = options or {}
    
    local width = options.width or 200
    local depth = options.depth or 200
    local baseHeight = options.baseHeight or 20
    local amplitude = options.amplitude or TerrainData.Amplitude or 50
    local seed = options.seed or TerrainData.Seed or math.random(1, 9999)
    local scale = options.scale or TerrainData.NoiseScale or 100
    local style = options.style or TerrainData.CurrentStyle
    
    -- Limpar terreno anterior
    terrain:Clear()
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🌍 Gerando...", "Criando terreno " .. style .. "...\nAguarde...", 5)
    end
    
    -- Gerar terreno em chunks para não travar
    local chunkSize = 20
    local totalChunks = math.ceil(width / chunkSize) * math.ceil(depth / chunkSize)
    local currentChunk = 0
    
    for cx = -width/2, width/2, chunkSize do
        for cz = -depth/2, depth/2, chunkSize do
            currentChunk = currentChunk + 1
            
            local chunkData = {}
            
            for x = cx, math.min(cx + chunkSize, width/2) do
                for z = cz, math.min(cz + chunkSize, depth/2) do
                    -- Calcular altura usando múltiplas oitavas de ruído
                    local height = baseHeight
                    
                    -- Oitava 1 - Montanhas grandes
                    height = height + self:Noise2D(x, z, seed, scale) * amplitude
                    
                    -- Oitava 2 - Detalhes médios
                    height = height + self:Noise2D(x, z, seed + 1000, scale / 2) * (amplitude / 2)
                    
                    -- Oitava 3 - Detalhes pequenos
                    height = height + self:Noise2D(x, z, seed + 2000, scale / 4) * (amplitude / 4)
                    
                    height = math.max(4, height)
                    
                    -- Determinar material baseado na altura e estilo
                    local material = Enum.Material.Grass
                    
                    if style == "Ultra Realistic" or style == "Stylized" then
                        if height > baseHeight + amplitude * 0.7 then
                            material = Enum.Material.Snow
                        elseif height > baseHeight + amplitude * 0.5 then
                            material = Enum.Material.Rock
                        elseif height > baseHeight + amplitude * 0.2 then
                            material = Enum.Material.Grass
                        elseif height < baseHeight - amplitude * 0.3 then
                            material = Enum.Material.Sand
                        else
                            material = Enum.Material.Grass
                        end
                    elseif style == "Desert" then
                        if height > baseHeight + amplitude * 0.6 then
                            material = Enum.Material.Sandstone
                        else
                            material = Enum.Material.Sand
                        end
                    elseif style == "Arctic" then
                        if height > baseHeight + amplitude * 0.3 then
                            material = Enum.Material.Glacier
                        else
                            material = Enum.Material.Snow
                        end
                    elseif style == "Volcanic" then
                        if height > baseHeight + amplitude * 0.5 then
                            material = Enum.Material.CrackedLava
                        else
                            material = Enum.Material.Basalt
                        end
                    elseif style == "Tropical" then
                        if height > baseHeight + amplitude * 0.5 then
                            material = Enum.Material.Rock
                        elseif height < baseHeight - amplitude * 0.2 then
                            material = Enum.Material.Sand
                        else
                            material = Enum.Material.LeafyGrass
                        end
                    elseif style == "Fantasy" then
                        local colorNoise = self:Noise2D(x, z, seed + 5000, 30)
                        if colorNoise > 0.3 then
                            material = Enum.Material.Grass
                        elseif colorNoise > 0 then
                            material = Enum.Material.Slate
                        else
                            material = Enum.Material.Limestone
                        end
                    elseif style == "Sci-Fi" then
                        material = Enum.Material.Metal
                        if height < baseHeight then
                            material = Enum.Material.Concrete
                        end
                    elseif style == "Low Poly" then
                        -- Quantizar altura para efeito low poly
                        height = math.floor(height / 8) * 8
                        material = Enum.Material.SmoothPlastic
                    end
                    
                    -- Preencher coluna de terreno
                    for y = 0, height do
                        local currentMat = material
                        
                        -- Camadas subterrâneas
                        if y < height - 4 then
                            currentMat = Enum.Material.Rock
                        elseif y < height - 2 then
                            currentMat = Enum.Material.Ground
                        end
                        
                        table.insert(chunkData, {
                            pos = Vector3.new(x * 4, y * 4, z * 4),
                            mat = currentMat
                        })
                    end
                end
            end
            
            -- Aplicar chunk
            for _, data in ipairs(chunkData) do
                terrain:FillBlock(CFrame.new(data.pos), Vector3.new(4, 4, 4), data.mat)
            end
            
            -- Yield para não travar
            if currentChunk % 5 == 0 then
                task.wait()
            end
        end
    end
    
    -- Adicionar água se necessário
    if TerrainData.WaterLevel and TerrainData.WaterLevel > 0 then
        local waterRegion = Region3.new(
            Vector3.new(-width * 2, 0, -depth * 2),
            Vector3.new(width * 2, TerrainData.WaterLevel * 4, depth * 2)
        ):ExpandToGrid(4)
        
        terrain:FillRegion(waterRegion, 4, Enum.Material.Water)
    end
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("✅ Terreno Criado!", style .. " gerado com sucesso!\nSeed: " .. seed, 3)
    end
end

-- Gerar terreno flat
function TerrainGenerator:GenerateFlat(size, height, material)
    terrain:Clear()
    
    terrain:FillBlock(
        CFrame.new(0, height * 2, 0),
        Vector3.new(size, height * 4, size),
        material or Enum.Material.Grass
    )
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("✅ Terreno Plano", "Terreno flat gerado!", 2)
    end
end

-- Gerar ilha
function TerrainGenerator:GenerateIsland(radius, maxHeight)
    terrain:Clear()
    
    radius = radius or 100
    maxHeight = maxHeight or 40
    
    local seed = TerrainData.Seed or math.random(1, 9999)
    
    for x = -radius, radius do
        for z = -radius, radius do
            local dist = math.sqrt(x^2 + z^2)
            
            if dist <= radius then
                local falloff = 1 - (dist / radius)^2
                local noise = self:Noise2D(x, z, seed, 50)
                local height = falloff * maxHeight * (0.5 + noise * 0.5)
                
                height = math.max(2, height)
                
                local material = Enum.Material.Grass
                if height > maxHeight * 0.7 then
                    material = Enum.Material.Rock
                elseif dist > radius * 0.85 then
                    material = Enum.Material.Sand
                end
                
                for y = 0, height do
                    terrain:FillBlock(CFrame.new(x * 4, y * 4, z * 4), Vector3.new(4, 4, 4), material)
                end
            end
        end
        
        if x % 10 == 0 then task.wait() end
    end
    
    -- Água ao redor
    local waterRegion = Region3.new(
        Vector3.new(-radius * 4 - 200, -20, -radius * 4 - 200),
        Vector3.new(radius * 4 + 200, 8, radius * 4 + 200)
    ):ExpandToGrid(4)
    
    terrain:FillRegion(waterRegion, 4, Enum.Material.Water)
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🏝️ Ilha Criada!", "Ilha tropical gerada!", 3)
    end
end

-- Exportar sistemas
_G.TerrainEditor = TerrainEditor
_G.TerrainGenerator = TerrainGenerator

-- Input para edição
local editing = false
local mouse = player:GetMouse()

mouse.Button1Down:Connect(function()
    if TerrainEditor.IsEditing then
        editing = true
    end
end)

mouse.Button1Up:Connect(function()
    editing = false
end)

RunService.RenderStepped:Connect(function()
    if editing and TerrainEditor.IsEditing then
        local pos = TerrainEditor:GetMousePosition()
        if pos then
            TerrainEditor:ApplyBrush(pos)
        end
    end
end)

print("🌑 Mortal Terrain Editor - Parte 3 Carregada (Editor e Gerador)")

-- 🌑☠️ MORTAL DARKNESS TERRAIN EDITOR V1 ☠️🌑
-- Parte 4 - Painel de Geração Rápida + Sistema de Estilos Completo
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TerrainGui = playerGui:WaitForChild("MortalTerrainGUI")
local mainFrame = _G.TerrainMainFrame
local TerrainData = _G.TerrainData
local Colors = _G.TerrainColors
local TerrainGenerator = _G.TerrainGenerator

local terrain = Workspace:WaitForChild("Terrain")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

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

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA COMPLETO DE ESTILOS
-- ═══════════════════════════════════════════════════════════════

local StyleSystem = {}

StyleSystem.Styles = {
    ["Ultra Realistic"] = {
        icon = "🌍",
        description = "Terreno ultra realista com física e texturas 4K",
        materials = {
            high = Enum.Material.Snow,
            mid_high = Enum.Material.Rock,
            mid = Enum.Material.Grass,
            low = Enum.Material.Ground,
            water_edge = Enum.Material.Sand
        },
        atmosphere = {
            Density = 0.3,
            Offset = 0.1,
            Color = Color3.fromRGB(180, 200, 220),
            Decay = Color3.fromRGB(90, 100, 120),
            Glare = 0.5,
            Haze = 1
        },
        lighting = {
            Ambient = Color3.fromRGB(80, 90, 100),
            Brightness = 2,
            ColorShift_Bottom = Color3.fromRGB(50, 60, 80),
            ColorShift_Top = Color3.fromRGB(180, 200, 230),
            OutdoorAmbient = Color3.fromRGB(100, 110, 120),
            ClockTime = 14,
            GeographicLatitude = 40
        },
        wind = Vector3.new(5, 0, 3),
        waterColor = Color3.fromRGB(30, 100, 150),
        waterTransparency = 0.7
    },
    
    ["Medieval"] = {
        icon = "🏰",
        description = "Atmosfera medieval com castelos e florestas densas",
        materials = {
            high = Enum.Material.Rock,
            mid_high = Enum.Material.Slate,
            mid = Enum.Material.Grass,
            low = Enum.Material.Ground,
            water_edge = Enum.Material.Mud
        },
        atmosphere = {
            Density = 0.5,
            Offset = 0.2,
            Color = Color3.fromRGB(150, 140, 130),
            Decay = Color3.fromRGB(80, 70, 60),
            Glare = 0.2,
            Haze = 2
        },
        lighting = {
            Ambient = Color3.fromRGB(60, 55, 50),
            Brightness = 1.5,
            ColorShift_Bottom = Color3.fromRGB(40, 35, 30),
            ColorShift_Top = Color3.fromRGB(140, 130, 120),
            OutdoorAmbient = Color3.fromRGB(80, 75, 70),
            ClockTime = 16,
            GeographicLatitude = 50
        },
        wind = Vector3.new(3, 0, 2),
        waterColor = Color3.fromRGB(40, 60, 50),
        waterTransparency = 0.5
    },
    
    ["Anime/Stylized"] = {
        icon = "🎨",
        description = "Estilo anime colorido e vibrante",
        materials = {
            high = Enum.Material.SmoothPlastic,
            mid_high = Enum.Material.SmoothPlastic,
            mid = Enum.Material.SmoothPlastic,
            low = Enum.Material.SmoothPlastic,
            water_edge = Enum.Material.SmoothPlastic
        },
        atmosphere = {
            Density = 0.1,
            Offset = 0,
            Color = Color3.fromRGB(255, 200, 220),
            Decay = Color3.fromRGB(200, 150, 180),
            Glare = 1,
            Haze = 0.5
        },
        lighting = {
            Ambient = Color3.fromRGB(150, 140, 160),
            Brightness = 3,
            ColorShift_Bottom = Color3.fromRGB(180, 150, 200),
            ColorShift_Top = Color3.fromRGB(200, 220, 255),
            OutdoorAmbient = Color3.fromRGB(180, 170, 190),
            ClockTime = 12,
            GeographicLatitude = 30
        },
        wind = Vector3.new(2, 0, 1),
        waterColor = Color3.fromRGB(100, 180, 255),
        waterTransparency = 0.9,
        customColors = {
            high = Color3.fromRGB(255, 200, 220),
            mid = Color3.fromRGB(150, 255, 180),
            low = Color3.fromRGB(255, 230, 150)
        }
    },
    
    ["Sci-Fi"] = {
        icon = "🚀",
        description = "Ambiente futurista com tecnologia avançada",
        materials = {
            high = Enum.Material.Metal,
            mid_high = Enum.Material.DiamondPlate,
            mid = Enum.Material.Concrete,
            low = Enum.Material.Metal,
            water_edge = Enum.Material.Neon
        },
        atmosphere = {
            Density = 0.2,
            Offset = 0.3,
            Color = Color3.fromRGB(50, 100, 150),
            Decay = Color3.fromRGB(20, 40, 80),
            Glare = 2,
            Haze = 0
        },
        lighting = {
            Ambient = Color3.fromRGB(30, 50, 80),
            Brightness = 1,
            ColorShift_Bottom = Color3.fromRGB(0, 50, 100),
            ColorShift_Top = Color3.fromRGB(50, 100, 200),
            OutdoorAmbient = Color3.fromRGB(40, 60, 100),
            ClockTime = 0,
            GeographicLatitude = 0
        },
        wind = Vector3.new(0, 0, 0),
        waterColor = Color3.fromRGB(0, 200, 255),
        waterTransparency = 0.3
    },
    
    ["Fantasy"] = {
        icon = "🧙",
        description = "Mundo mágico com cores místicas",
        materials = {
            high = Enum.Material.Glacier,
            mid_high = Enum.Material.Slate,
            mid = Enum.Material.Grass,
            low = Enum.Material.Limestone,
            water_edge = Enum.Material.Sand
        },
        atmosphere = {
            Density = 0.4,
            Offset = 0.15,
            Color = Color3.fromRGB(180, 150, 220),
            Decay = Color3.fromRGB(100, 80, 150),
            Glare = 0.8,
            Haze = 1.5
        },
        lighting = {
            Ambient = Color3.fromRGB(100, 80, 130),
            Brightness = 2,
            ColorShift_Bottom = Color3.fromRGB(80, 50, 120),
            ColorShift_Top = Color3.fromRGB(180, 150, 220),
            OutdoorAmbient = Color3.fromRGB(120, 100, 150),
            ClockTime = 18,
            GeographicLatitude = 35
        },
        wind = Vector3.new(4, 1, 3),
        waterColor = Color3.fromRGB(100, 50, 200),
        waterTransparency = 0.6
    },
    
    ["Desert"] = {
        icon = "🏜️",
        description = "Deserto árido com dunas e oásis",
        materials = {
            high = Enum.Material.Sandstone,
            mid_high = Enum.Material.Sandstone,
            mid = Enum.Material.Sand,
            low = Enum.Material.Sand,
            water_edge = Enum.Material.Ground
        },
        atmosphere = {
            Density = 0.15,
            Offset = 0.4,
            Color = Color3.fromRGB(255, 220, 180),
            Decay = Color3.fromRGB(200, 150, 100),
            Glare = 3,
            Haze = 2
        },
        lighting = {
            Ambient = Color3.fromRGB(150, 130, 100),
            Brightness = 3.5,
            ColorShift_Bottom = Color3.fromRGB(200, 150, 100),
            ColorShift_Top = Color3.fromRGB(255, 230, 180),
            OutdoorAmbient = Color3.fromRGB(180, 160, 130),
            ClockTime = 13,
            GeographicLatitude = 25
        },
        wind = Vector3.new(8, 0, 5),
        waterColor = Color3.fromRGB(50, 150, 200),
        waterTransparency = 0.8
    },
    
    ["Arctic"] = {
        icon = "❄️",
        description = "Paisagem gelada com neve e gelo",
        materials = {
            high = Enum.Material.Glacier,
            mid_high = Enum.Material.Ice,
            mid = Enum.Material.Snow,
            low = Enum.Material.Snow,
            water_edge = Enum.Material.Ice
        },
        atmosphere = {
            Density = 0.6,
            Offset = 0.1,
            Color = Color3.fromRGB(220, 230, 255),
            Decay = Color3.fromRGB(180, 200, 230),
            Glare = 1.5,
            Haze = 3
        },
        lighting = {
            Ambient = Color3.fromRGB(180, 190, 210),
            Brightness = 2.5,
            ColorShift_Bottom = Color3.fromRGB(150, 170, 200),
            ColorShift_Top = Color3.fromRGB(220, 230, 255),
            OutdoorAmbient = Color3.fromRGB(190, 200, 220),
            ClockTime = 11,
            GeographicLatitude = 70
        },
        wind = Vector3.new(10, 2, 8),
        waterColor = Color3.fromRGB(150, 200, 255),
        waterTransparency = 0.4
    },
    
    ["Volcanic"] = {
        icon = "🌋",
        description = "Ambiente vulcânico com lava e cinzas",
        materials = {
            high = Enum.Material.CrackedLava,
            mid_high = Enum.Material.CrackedLava,
            mid = Enum.Material.Basalt,
            low = Enum.Material.Basalt,
            water_edge = Enum.Material.CrackedLava
        },
        atmosphere = {
            Density = 0.8,
            Offset = 0.3,
            Color = Color3.fromRGB(100, 50, 30),
            Decay = Color3.fromRGB(50, 20, 10),
            Glare = 0.3,
            Haze = 4
        },
        lighting = {
            Ambient = Color3.fromRGB(80, 40, 20),
            Brightness = 1,
            ColorShift_Bottom = Color3.fromRGB(150, 50, 0),
            ColorShift_Top = Color3.fromRGB(100, 40, 20),
            OutdoorAmbient = Color3.fromRGB(60, 30, 15),
            ClockTime = 20,
            GeographicLatitude = 20
        },
        wind = Vector3.new(3, 5, 2),
        waterColor = Color3.fromRGB(255, 100, 0),
        waterTransparency = 0.2,
        isLava = true
    },
    
    ["Tropical"] = {
        icon = "🌴",
        description = "Paraíso tropical com praias e palmeiras",
        materials = {
            high = Enum.Material.Rock,
            mid_high = Enum.Material.Grass,
            mid = Enum.Material.LeafyGrass,
            low = Enum.Material.LeafyGrass,
            water_edge = Enum.Material.Sand
        },
        atmosphere = {
            Density = 0.25,
            Offset = 0.05,
            Color = Color3.fromRGB(200, 230, 255),
            Decay = Color3.fromRGB(150, 200, 230),
            Glare = 1,
            Haze = 0.8
        },
        lighting = {
            Ambient = Color3.fromRGB(120, 140, 130),
            Brightness = 2.8,
            ColorShift_Bottom = Color3.fromRGB(100, 150, 130),
            ColorShift_Top = Color3.fromRGB(180, 220, 255),
            OutdoorAmbient = Color3.fromRGB(140, 160, 150),
            ClockTime = 15,
            GeographicLatitude = 10
        },
        wind = Vector3.new(6, 0, 4),
        waterColor = Color3.fromRGB(30, 180, 220),
        waterTransparency = 0.85
    },
    
    ["Cyberpunk"] = {
        icon = "🌃",
        description = "Cidade cyberpunk com neons e tecnologia",
        materials = {
            high = Enum.Material.Neon,
            mid_high = Enum.Material.Metal,
            mid = Enum.Material.Concrete,
            low = Enum.Material.Asphalt,
            water_edge = Enum.Material.Glass
        },
        atmosphere = {
            Density = 0.7,
            Offset = 0.4,
            Color = Color3.fromRGB(80, 20, 100),
            Decay = Color3.fromRGB(40, 10, 60),
            Glare = 0.5,
            Haze = 3
        },
        lighting = {
            Ambient = Color3.fromRGB(50, 20, 80),
            Brightness = 0.5,
            ColorShift_Bottom = Color3.fromRGB(100, 0, 150),
            ColorShift_Top = Color3.fromRGB(0, 150, 200),
            OutdoorAmbient = Color3.fromRGB(30, 10, 50),
            ClockTime = 22,
            GeographicLatitude = 40
        },
        wind = Vector3.new(1, 0, 1),
        waterColor = Color3.fromRGB(0, 255, 200),
        waterTransparency = 0.3
    },
    
    ["Horror"] = {
        icon = "💀",
        description = "Ambiente sombrio e aterrorizante",
        materials = {
            high = Enum.Material.Slate,
            mid_high = Enum.Material.Slate,
            mid = Enum.Material.Ground,
            low = Enum.Material.Mud,
            water_edge = Enum.Material.Mud
        },
        atmosphere = {
            Density = 0.9,
            Offset = 0.5,
            Color = Color3.fromRGB(30, 30, 40),
            Decay = Color3.fromRGB(10, 10, 15),
            Glare = 0,
            Haze = 5
        },
        lighting = {
            Ambient = Color3.fromRGB(20, 20, 25),
            Brightness = 0.3,
            ColorShift_Bottom = Color3.fromRGB(10, 10, 15),
            ColorShift_Top = Color3.fromRGB(40, 35, 50),
            OutdoorAmbient = Color3.fromRGB(15, 15, 20),
            ClockTime = 2,
            GeographicLatitude = 60
        },
        wind = Vector3.new(2, 1, 3),
        waterColor = Color3.fromRGB(20, 30, 25),
        waterTransparency = 0.2
    },
    
    ["Low Poly"] = {
        icon = "🔷",
        description = "Estilo low poly minimalista",
        materials = {
            high = Enum.Material.SmoothPlastic,
            mid_high = Enum.Material.SmoothPlastic,
            mid = Enum.Material.SmoothPlastic,
            low = Enum.Material.SmoothPlastic,
            water_edge = Enum.Material.SmoothPlastic
        },
        atmosphere = {
            Density = 0,
            Offset = 0,
            Color = Color3.fromRGB(200, 220, 255),
            Decay = Color3.fromRGB(180, 200, 230),
            Glare = 0,
            Haze = 0
        },
        lighting = {
            Ambient = Color3.fromRGB(150, 160, 180),
            Brightness = 2,
            ColorShift_Bottom = Color3.fromRGB(130, 140, 160),
            ColorShift_Top = Color3.fromRGB(200, 210, 230),
            OutdoorAmbient = Color3.fromRGB(170, 180, 200),
            ClockTime = 14,
            GeographicLatitude = 45
        },
        wind = Vector3.new(0, 0, 0),
        waterColor = Color3.fromRGB(80, 150, 255),
        waterTransparency = 0.7,
        quantizeHeight = true
    }
}

-- Aplicar estilo completo
function StyleSystem:ApplyStyle(styleName)
    local style = self.Styles[styleName]
    if not style then
        warn("Estilo não encontrado: " .. styleName)
        return
    end
    
    TerrainData.CurrentStyle = styleName
    TerrainData.CurrentStyleData = style
    
    -- Aplicar atmosfera
    local atmosphere = Lighting:FindFirstChild("Atmosphere")
    if not atmosphere then
        atmosphere = Instance.new("Atmosphere")
        atmosphere.Parent = Lighting
    end
    
    for prop, value in pairs(style.atmosphere) do
        atmosphere[prop] = value
    end
    
    -- Aplicar lighting
    for prop, value in pairs(style.lighting) do
        pcall(function()
            Lighting[prop] = value
        end)
    end
    
    -- Aplicar vento
    Workspace.GlobalWind = style.wind
    
    -- Configurar água
    terrain.WaterColor = style.waterColor
    terrain.WaterTransparency = style.waterTransparency
    
    -- Efeitos especiais baseados no estilo
    if styleName == "Cyberpunk" or styleName == "Sci-Fi" then
        local bloom = Lighting:FindFirstChild("Bloom") or Instance.new("BloomEffect")
        bloom.Name = "Bloom"
        bloom.Intensity = 1
        bloom.Size = 30
        bloom.Threshold = 0.8
        bloom.Parent = Lighting
    end
    
    if styleName == "Horror" then
        local colorCorrection = Lighting:FindFirstChild("ColorCorrection") or Instance.new("ColorCorrectionEffect")
        colorCorrection.Name = "ColorCorrection"
        colorCorrection.Saturation = -0.5
        colorCorrection.Contrast = 0.3
        colorCorrection.TintColor = Color3.fromRGB(200, 180, 200)
        colorCorrection.Parent = Lighting
    end
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification(
            style.icon .. " Estilo Aplicado",
            styleName .. "\n" .. style.description,
            3
        )
    end
    
    return style
end

-- Obter materiais do estilo atual
function StyleSystem:GetMaterialForHeight(normalizedHeight)
    local style = TerrainData.CurrentStyleData
    if not style then
        style = self.Styles["Ultra Realistic"]
    end
    
    if normalizedHeight > 0.8 then
        return style.materials.high
    elseif normalizedHeight > 0.6 then
        return style.materials.mid_high
    elseif normalizedHeight > 0.3 then
        return style.materials.mid
    elseif normalizedHeight > 0.1 then
        return style.materials.low
    else
        return style.materials.water_edge
    end
end

-- ═══════════════════════════════════════════════════════════════
-- PAINEL DE GERAÇÃO RÁPIDA
-- ═══════════════════════════════════════════════════════════════

local quickGenPanel = Instance.new("Frame")
quickGenPanel.Name = "QuickGenPanel"
quickGenPanel.Size = UDim2.new(1, -20, 0, 100)
quickGenPanel.Position = UDim2.new(0, 10, 1, -110)
quickGenPanel.BackgroundColor3 = Colors.Secondary
quickGenPanel.BorderSizePixel = 0
quickGenPanel.ZIndex = 21
quickGenPanel.Parent = mainFrame
CreateCorner(quickGenPanel, 12)

local quickGenTitle = Instance.new("TextLabel")
quickGenTitle.Size = UDim2.new(1, 0, 0, 25)
quickGenTitle.BackgroundColor3 = Colors.Tertiary
quickGenTitle.Text = "⚡ Geração Rápida"
quickGenTitle.TextColor3 = Colors.Gold
quickGenTitle.TextSize = 12
quickGenTitle.Font = Enum.Font.GothamBlack
quickGenTitle.ZIndex = 22
quickGenTitle.Parent = quickGenPanel
CreateCorner(quickGenTitle, 12)

local quickGenScroll = Instance.new("ScrollingFrame")
quickGenScroll.Size = UDim2.new(1, -10, 1, -30)
quickGenScroll.Position = UDim2.new(0, 5, 0, 28)
quickGenScroll.BackgroundTransparency = 1
quickGenScroll.ScrollBarThickness = 0
quickGenScroll.ZIndex = 22
quickGenScroll.ScrollingDirection = Enum.ScrollingDirection.X
quickGenScroll.CanvasSize = UDim2.new(0, 1200, 0, 0)
quickGenScroll.Parent = quickGenPanel

local quickGenLayout = Instance.new("UIListLayout")
quickGenLayout.FillDirection = Enum.FillDirection.Horizontal
quickGenLayout.SortOrder = Enum.SortOrder.LayoutOrder
quickGenLayout.Padding = UDim.new(0, 8)
quickGenLayout.VerticalAlignment = Enum.VerticalAlignment.Center
quickGenLayout.Parent = quickGenScroll

-- Presets de geração rápida
local quickPresets = {
    {name = "Flat", icon = "⬜", desc = "Terreno plano", action = function()
        TerrainGenerator:GenerateFlat(500, 10, TerrainData.CurrentMaterial)
        StyleSystem:ApplyStyle(TerrainData.CurrentStyle)
    end},
    {name = "Hills", icon = "🏔️", desc = "Colinas suaves", action = function()
        TerrainData.Amplitude = 30
        TerrainGenerator:GenerateTerrain({amplitude = 30, scale = 150})
        StyleSystem:ApplyStyle(TerrainData.CurrentStyle)
    end},
    {name = "Mountains", icon = "⛰️", desc = "Montanhas altas", action = function()
        TerrainData.Amplitude = 100
        TerrainGenerator:GenerateTerrain({amplitude = 100, scale = 80})
        StyleSystem:ApplyStyle(TerrainData.CurrentStyle)
    end},
    {name = "Island", icon = "🏝️", desc = "Ilha tropical", action = function()
        TerrainGenerator:GenerateIsland(80, 50)
        StyleSystem:ApplyStyle("Tropical")
    end},
    {name = "Canyon", icon = "🏜️", desc = "Canyon profundo", action = function()
        TerrainData.Amplitude = 8
        TerrainGenerator:GenerateTerrain({amplitude = 80, scale = 40})
        StyleSystem:ApplyStyle("Desert")
    end},
    {name = "Volcano", icon = "🌋", desc = "Vulcão ativo", action = function()
        TerrainGenerator:GenerateIsland(60, 80)
        StyleSystem:ApplyStyle("Volcanic")
    end},
    {name = "Arctic", icon = "❄️", desc = "Paisagem gelada", action = function()
        TerrainData.Amplitude = 40
        TerrainGenerator:GenerateTerrain({amplitude = 40, scale = 100})
        StyleSystem:ApplyStyle("Arctic")
    end},
    {name = "Fantasy", icon = "🧙", desc = "Mundo mágico", action = function()
        TerrainData.Amplitude = 60
        TerrainGenerator:GenerateTerrain({amplitude = 60, scale = 70})
        StyleSystem:ApplyStyle("Fantasy")
    end},
    {name = "Clear", icon = "🗑️", desc = "Limpar terreno", color = Colors.Red, action = function()
        terrain:Clear()
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("🗑️ Limpo", "Terreno removido!", 2)
        end
    end},
}

for i, preset in ipairs(quickPresets) do
    local btn = Instance.new("TextButton")
    btn.Name = preset.name
    btn.Size = UDim2.new(0, isMobile and 70 or 90, 0, 55)
    btn.BackgroundColor3 = preset.color or Colors.Tertiary
    btn.Text = preset.icon .. "\n" .. preset.name
    btn.TextColor3 = Colors.Text
    btn.TextSize = isMobile and 10 or 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 23
    btn.LayoutOrder = i
    btn.Parent = quickGenScroll
    CreateCorner(btn, 10)
    
    btn.MouseButton1Click:Connect(function()
        if preset.action then
            preset.action()
        end
    end)
    
    -- Hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Colors.Purple
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = preset.color or Colors.Tertiary
        }):Play()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- GRID DE ESTILOS
-- ═══════════════════════════════════════════════════════════════

local stylesPanel = Instance.new("Frame")
stylesPanel.Name = "StylesPanel"
stylesPanel.Size = UDim2.new(0, isMobile and 160 or 250, 0, isMobile and 200 or 280)
stylesPanel.Position = UDim2.new(0, isMobile and 260 or 510, 0, 85)
stylesPanel.BackgroundColor3 = Colors.Secondary
stylesPanel.BorderSizePixel = 0
stylesPanel.ZIndex = 21
stylesPanel.Visible = not isMobile
stylesPanel.Parent = mainFrame
CreateCorner(stylesPanel, 12)

local stylesTitle = Instance.new("TextLabel")
stylesTitle.Size = UDim2.new(1, 0, 0, 28)
stylesTitle.BackgroundColor3 = Colors.AccentDark
stylesTitle.Text = "🎨 Estilos de Mundo"
stylesTitle.TextColor3 = Colors.Gold
stylesTitle.TextSize = 11
stylesTitle.Font = Enum.Font.GothamBlack
stylesTitle.ZIndex = 22
stylesTitle.Parent = stylesPanel
CreateCorner(stylesTitle, 12)

local stylesScroll = Instance.new("ScrollingFrame")
stylesScroll.Size = UDim2.new(1, -10, 1, -35)
stylesScroll.Position = UDim2.new(0, 5, 0, 32)
stylesScroll.BackgroundTransparency = 1
stylesScroll.ScrollBarThickness = 3
stylesScroll.ScrollBarImageColor3 = Colors.Purple
stylesScroll.ZIndex = 22
stylesScroll.CanvasSize = UDim2.new(0, 0, 0, 500)
stylesScroll.Parent = stylesPanel

local stylesGrid = Instance.new("UIGridLayout")
stylesGrid.CellSize = UDim2.new(0, isMobile and 65 or 70, 0, isMobile and 50 or 55)
stylesGrid.CellPadding = UDim2.new(0, 5, 0, 5)
stylesGrid.SortOrder = Enum.SortOrder.LayoutOrder
stylesGrid.Parent = stylesScroll

local selectedStyleBtn = nil
local styleIndex = 0

for styleName, styleData in pairs(StyleSystem.Styles) do
    styleIndex = styleIndex + 1
    
    local btn = Instance.new("TextButton")
    btn.Name = styleName
    btn.Size = UDim2.new(0, 70, 0, 55)
    btn.BackgroundColor3 = Colors.Tertiary
    btn.Text = styleData.icon .. "\n" .. string.sub(styleName, 1, 8)
    btn.TextColor3 = Colors.Text
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.TextWrapped = true
    btn.BorderSizePixel = 0
    btn.ZIndex = 23
    btn.LayoutOrder = styleIndex
    btn.Parent = stylesScroll
    CreateCorner(btn, 8)
    
    btn.MouseButton1Click:Connect(function()
        StyleSystem:ApplyStyle(styleName)
        
        if selectedStyleBtn then
            local prevStroke = selectedStyleBtn:FindFirstChild("SelectStroke")
            if prevStroke then prevStroke:Destroy() end
        end
        
        selectedStyleBtn = btn
        local stroke = Instance.new("UIStroke")
        stroke.Name = "SelectStroke"
        stroke.Color = Colors.Gold
        stroke.Thickness = 2
        stroke.Parent = btn
    end)
end

-- Atualizar canvas
stylesGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    stylesScroll.CanvasSize = UDim2.new(0, 0, 0, stylesGrid.AbsoluteContentSize.Y + 10)
end)

-- Exportar
_G.StyleSystem = StyleSystem

print("🌑 Mortal Terrain Editor - Parte 4 Carregada (Estilos e Geração Rápida)")

-- 🌑☠️ MORTAL DARKNESS TERRAIN EDITOR V1 ☠️🌑
-- Parte 5 - Sistema de Água Realista, Atmosfera e Efeitos
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TerrainGui = playerGui:WaitForChild("MortalTerrainGUI")
local mainFrame = _G.TerrainMainFrame
local TerrainData = _G.TerrainData
local Colors = _G.TerrainColors
local StyleSystem = _G.StyleSystem

local terrain = Workspace:WaitForChild("Terrain")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE ÁGUA REALISTA
-- ═══════════════════════════════════════════════════════════════

local WaterSystem = {}
WaterSystem.WaterLevel = 0
WaterSystem.WaveEnabled = true
WaterSystem.WaveIntensity = 0.5
WaterSystem.SwimmingEnabled = true

-- Criar efeitos de onda
function WaterSystem:CreateWaveEffect()
    local waveFolder = Workspace:FindFirstChild("WaterWaves")
    if not waveFolder then
        waveFolder = Instance.new("Folder")
        waveFolder.Name = "WaterWaves"
        waveFolder.Parent = Workspace
    end
    
    return waveFolder
end

-- Simular ondas na água
function WaterSystem:StartWaveSimulation()
    if self.WaveConnection then
        self.WaveConnection:Disconnect()
    end
    
    local time = 0
    
    self.WaveConnection = RunService.Heartbeat:Connect(function(dt)
        if not self.WaveEnabled then return end
        
        time = time + dt
        
        -- Atualizar cor da água baseado no tempo
        local waveColor = Color3.new(
            terrain.WaterColor.R + math.sin(time) * 0.02,
            terrain.WaterColor.G + math.cos(time * 0.5) * 0.02,
            terrain.WaterColor.B + math.sin(time * 0.8) * 0.02
        )
        
        -- Não atualizar diretamente (pode causar lag)
    end)
end

-- Sistema de natação
function WaterSystem:SetupSwimming()
    if self.SwimConnection then
        self.SwimConnection:Disconnect()
    end
    
    self.SwimConnection = RunService.Heartbeat:Connect(function()
        if not self.SwimmingEnabled then return end
        
        local character = player.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if rootPart and humanoid then
            local waterLevel = self.WaterLevel
            local playerY = rootPart.Position.Y
            
            -- Verificar se está na água
            if playerY < waterLevel then
                -- Aplicar física de natação
                humanoid.WalkSpeed = 10 -- Mais lento na água
                
                -- Efeito de bolhas
                if math.random() > 0.95 then
                    local bubble = Instance.new("Part")
                    bubble.Shape = Enum.PartType.Ball
                    bubble.Size = Vector3.new(0.3, 0.3, 0.3)
                    bubble.Position = rootPart.Position + Vector3.new(math.random(-1, 1), -1, math.random(-1, 1))
                    bubble.Anchored = false
                    bubble.CanCollide = false
                    bubble.Transparency = 0.5
                    bubble.Color = Color3.new(1, 1, 1)
                    bubble.Material = Enum.Material.Glass
                    bubble.Parent = Workspace
                    
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(0, 5, 0)
                    bodyVelocity.MaxForce = Vector3.new(0, 1000, 0)
                    bodyVelocity.Parent = bubble
                    
                    Debris:AddItem(bubble, 2)
                end
            else
                humanoid.WalkSpeed = 16
            end
        end
    end)
end

-- Definir nível da água
function WaterSystem:SetWaterLevel(level)
    self.WaterLevel = level
    TerrainData.WaterLevel = level
    
    if level > 0 then
        -- Criar região de água
        local size = 1000
        local waterRegion = Region3.new(
            Vector3.new(-size, 0, -size),
            Vector3.new(size, level, size)
        ):ExpandToGrid(4)
        
        terrain:FillRegion(waterRegion, 4, Enum.Material.Water)
        
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("🌊 Nível da Água", "Definido para " .. level .. " studs", 2)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE ATMOSFERA
-- ═══════════════════════════════════════════════════════════════

local AtmosphereSystem = {}

-- Criar todos os efeitos de lighting
function AtmosphereSystem:SetupEffects()
    -- Atmosphere
    local atmosphere = Lighting:FindFirstChild("Atmosphere")
    if not atmosphere then
        atmosphere = Instance.new("Atmosphere")
        atmosphere.Parent = Lighting
    end
    
    -- Sky
    local sky = Lighting:FindFirstChild("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = Lighting
    end
    
    -- Bloom
    local bloom = Lighting:FindFirstChild("Bloom")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Name = "Bloom"
        bloom.Parent = Lighting
    end
    
    -- Color Correction
    local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
    if not colorCorrection then
        colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Name = "ColorCorrection"
        colorCorrection.Parent = Lighting
    end
    
    -- Sun Rays
    local sunRays = Lighting:FindFirstChild("SunRays")
    if not sunRays then
        sunRays = Instance.new("SunRaysEffect")
        sunRays.Name = "SunRays"
        sunRays.Parent = Lighting
    end
    
    -- Depth of Field
    local dof = Lighting:FindFirstChild("DepthOfField")
    if not dof then
        dof = Instance.new("DepthOfFieldEffect")
        dof.Name = "DepthOfField"
        dof.Parent = Lighting
    end
    
    return {
        Atmosphere = atmosphere,
        Sky = sky,
        Bloom = bloom,
        ColorCorrection = colorCorrection,
        SunRays = sunRays,
        DepthOfField = dof
    }
end

-- Presets de atmosfera
AtmosphereSystem.Presets = {
    ["Clear Day"] = {
        atmosphere = {Density = 0.2, Offset = 0.1, Color = Color3.fromRGB(200, 220, 255)},
        lighting = {Brightness = 2.5, ClockTime = 14, Ambient = Color3.fromRGB(150, 160, 180)},
        bloom = {Intensity = 0.5, Size = 24, Threshold = 0.9},
        sunRays = {Intensity = 0.1, Spread = 0.5}
    },
    ["Sunset"] = {
        atmosphere = {Density = 0.4, Offset = 0.2, Color = Color3.fromRGB(255, 180, 100)},
        lighting = {Brightness = 1.5, ClockTime = 18.5, Ambient = Color3.fromRGB(180, 120, 80)},
        bloom = {Intensity = 1, Size = 40, Threshold = 0.7},
        sunRays = {Intensity = 0.3, Spread = 1}
    },
    ["Night"] = {
        atmosphere = {Density = 0.5, Offset = 0.3, Color = Color3.fromRGB(30, 40, 80)},
        lighting = {Brightness = 0.2, ClockTime = 2, Ambient = Color3.fromRGB(20, 25, 50)},
        bloom = {Intensity = 0.3, Size = 20, Threshold = 0.95},
        sunRays = {Intensity = 0, Spread = 0}
    },
    ["Stormy"] = {
        atmosphere = {Density = 0.8, Offset = 0.4, Color = Color3.fromRGB(60, 70, 80)},
        lighting = {Brightness = 0.8, ClockTime = 15, Ambient = Color3.fromRGB(50, 55, 65)},
        bloom = {Intensity = 0.2, Size = 15, Threshold = 0.85},
        sunRays = {Intensity = 0, Spread = 0}
    },
    ["Foggy"] = {
        atmosphere = {Density = 0.9, Offset = 0.5, Color = Color3.fromRGB(200, 200, 210)},
        lighting = {Brightness = 1.2, ClockTime = 10, Ambient = Color3.fromRGB(150, 150, 160)},
        bloom = {Intensity = 0.8, Size = 50, Threshold = 0.6},
        sunRays = {Intensity = 0.05, Spread = 1}
    },
    ["Dawn"] = {
        atmosphere = {Density = 0.35, Offset = 0.15, Color = Color3.fromRGB(255, 200, 150)},
        lighting = {Brightness = 1.8, ClockTime = 6.5, Ambient = Color3.fromRGB(150, 130, 120)},
        bloom = {Intensity = 0.7, Size = 35, Threshold = 0.75},
        sunRays = {Intensity = 0.2, Spread = 0.8}
    }
}

-- Aplicar preset de atmosfera
function AtmosphereSystem:ApplyPreset(presetName)
    local preset = self.Presets[presetName]
    if not preset then return end
    
    local effects = self:SetupEffects()
    
    -- Aplicar atmosfera
    for prop, value in pairs(preset.atmosphere) do
        effects.Atmosphere[prop] = value
    end
    
    -- Aplicar lighting
    for prop, value in pairs(preset.lighting) do
        pcall(function()
            Lighting[prop] = value
        end)
    end
    
    -- Aplicar bloom
    for prop, value in pairs(preset.bloom) do
        effects.Bloom[prop] = value
    end
    
    -- Aplicar sun rays
    for prop, value in pairs(preset.sunRays) do
        effects.SunRays[prop] = value
    end
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🌤️ Atmosfera", presetName .. " aplicada!", 2)
    end
end

-- Ciclo dia/noite
function AtmosphereSystem:StartDayNightCycle(speed)
    if self.DayNightConnection then
        self.DayNightConnection:Disconnect()
    end
    
    speed = speed or 1 -- 1 = tempo real, 60 = 1 minuto = 1 hora
    
    self.DayNightConnection = RunService.Heartbeat:Connect(function(dt)
        local currentTime = Lighting.ClockTime
        currentTime = currentTime + (dt * speed / 60)
        
        if currentTime >= 24 then
            currentTime = 0
        end
        
        Lighting.ClockTime = currentTime
    end)
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🌅 Ciclo Dia/Noite", "Ativado! Velocidade: " .. speed .. "x", 2)
    end
end

function AtmosphereSystem:StopDayNightCycle()
    if self.DayNightConnection then
        self.DayNightConnection:Disconnect()
        self.DayNightConnection = nil
    end
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE VENTO E PARTÍCULAS
-- ═══════════════════════════════════════════════════════════════

local WindSystem = {}
WindSystem.Intensity = 5
WindSystem.Direction = Vector3.new(1, 0, 0.5)

function WindSystem:SetWind(intensity, direction)
    self.Intensity = intensity or 5
    self.Direction = direction or Vector3.new(1, 0, 0.5)
    
    Workspace.GlobalWind = self.Direction.Unit * self.Intensity
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("💨 Vento", "Intensidade: " .. self.Intensity, 2)
    end
end

-- Criar partículas de ambiente
function WindSystem:CreateAmbientParticles(particleType)
    local particleFolder = Workspace:FindFirstChild("AmbientParticles")
    if not particleFolder then
        particleFolder = Instance.new("Folder")
        particleFolder.Name = "AmbientParticles"
        particleFolder.Parent = Workspace
    end
    
    -- Limpar partículas anteriores
    particleFolder:ClearAllChildren()
    
    local emitter = Instance.new("Part")
    emitter.Name = "ParticleEmitter"
    emitter.Size = Vector3.new(500, 1, 500)
    emitter.Position = Vector3.new(0, 100, 0)
    emitter.Anchored = true
    emitter.CanCollide = false
    emitter.Transparency = 1
    emitter.Parent = particleFolder
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = emitter
    
    if particleType == "Rain" then
        particles.Texture = "rbxassetid://241876428"
        particles.Rate = 500
        particles.Lifetime = NumberRange.new(2, 3)
        particles.Speed = NumberRange.new(50, 80)
        particles.SpreadAngle = Vector2.new(10, 10)
        particles.EmissionDirection = Enum.NormalId.Bottom
        particles.Size = NumberSequence.new(0.1)
        particles.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
        particles.Transparency = NumberSequence.new(0.3)
        
    elseif particleType == "Snow" then
        particles.Texture = "rbxassetid://243098098"
        particles.Rate = 200
        particles.Lifetime = NumberRange.new(5, 8)
        particles.Speed = NumberRange.new(5, 15)
        particles.SpreadAngle = Vector2.new(30, 30)
        particles.EmissionDirection = Enum.NormalId.Bottom
        particles.Size = NumberSequence.new(0.2, 0.5)
        particles.Color = ColorSequence.new(Color3.new(1, 1, 1))
        particles.Transparency = NumberSequence.new(0.2)
        particles.RotSpeed = NumberRange.new(-30, 30)
        
    elseif particleType == "Leaves" then
        particles.Texture = "rbxassetid://1084981484"
        particles.Rate = 30
        particles.Lifetime = NumberRange.new(4, 7)
        particles.Speed = NumberRange.new(3, 8)
        particles.SpreadAngle = Vector2.new(60, 60)
        particles.Size = NumberSequence.new(0.3, 0.8)
        particles.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 180, 80)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 100, 50))
        })
        particles.RotSpeed = NumberRange.new(-60, 60)
        particles.Rotation = NumberRange.new(0, 360)
        
    elseif particleType == "Ash" then
        particles.Texture = "rbxassetid://243660364"
        particles.Rate = 100
        particles.Lifetime = NumberRange.new(3, 6)
        particles.Speed = NumberRange.new(2, 5)
        particles.SpreadAngle = Vector2.new(90, 90)
        particles.Size = NumberSequence.new(0.1, 0.3)
        particles.Color = ColorSequence.new(Color3.fromRGB(50, 50, 50))
        particles.Transparency = NumberSequence.new(0.4, 1)
        
    elseif particleType == "Fireflies" then
        particles.Texture = "rbxassetid://241876428"
        particles.Rate = 20
        particles.Lifetime = NumberRange.new(2, 4)
        particles.Speed = NumberRange.new(1, 3)
        particles.SpreadAngle = Vector2.new(180, 180)
        particles.Size = NumberSequence.new(0.1, 0.3, 0.1)
        particles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 100))
        particles.LightEmission = 1
        particles.LightInfluence = 0
    end
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("✨ Partículas", particleType .. " ativadas!", 2)
    end
    
    return particles
end

function WindSystem:ClearParticles()
    local particleFolder = Workspace:FindFirstChild("AmbientParticles")
    if particleFolder then
        particleFolder:ClearAllChildren()
    end
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE EFEITOS ESPECIAIS
-- ═══════════════════════════════════════════════════════════════

local EffectsSystem = {}

-- Criar raio
function EffectsSystem:CreateLightning(startPos, endPos)
    local lightning = Instance.new("Part")
    lightning.Name = "Lightning"
    lightning.Anchored = true
    lightning.CanCollide = false
    lightning.Material = Enum.Material.Neon
    lightning.Color = Color3.fromRGB(200, 200, 255)
    
    local distance = (endPos - startPos).Magnitude
    lightning.Size = Vector3.new(0.5, 0.5, distance)
    lightning.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -distance/2)
    lightning.Parent = Workspace
    
    -- Flash
    local originalBrightness = Lighting.Brightness
    Lighting.Brightness = 5
    
    task.delay(0.1, function()
        Lighting.Brightness = originalBrightness
        lightning:Destroy()
    end)
end

-- Criar explosão de terreno
function EffectsSystem:CreateTerrainExplosion(position, radius)
    -- Remover terreno
    terrain:FillBall(position, radius, Enum.Material.Air)
    
    -- Criar partículas de explosão
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = radius
    explosion.BlastPressure = 0 -- Só visual
    explosion.Parent = Workspace
    
    -- Criar destroços
    for i = 1, 20 do
        local debris = Instance.new("Part")
        debris.Size = Vector3.new(math.random(1, 3), math.random(1, 3), math.random(1, 3))
        debris.Position = position + Vector3.new(
            math.random(-radius, radius),
            math.random(0, radius),
            math.random(-radius, radius)
        )
        debris.Color = Color3.fromRGB(100, 80, 60)
        debris.Material = Enum.Material.Rock
        debris.Parent = Workspace
        
        local velocity = Instance.new("BodyVelocity")
        velocity.Velocity = Vector3.new(
            math.random(-30, 30),
            math.random(20, 50),
            math.random(-30, 30)
        )
        velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        velocity.Parent = debris
        
        Debris:AddItem(debris, 5)
        
        task.delay(0.1, function()
            velocity:Destroy()
        end)
    end
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("💥 Explosão", "Terreno destruído!", 2)
    end
end

-- Criar terremoto
function EffectsSystem:CreateEarthquake(intensity, duration)
    intensity = intensity or 5
    duration = duration or 3
    
    local camera = Workspace.CurrentCamera
    local originalCFrame = camera.CFrame
    local startTime = tick()
    
    local earthquakeConnection
    earthquakeConnection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        
        if elapsed >= duration then
            earthquakeConnection:Disconnect()
            return
        end
        
        local shake = Vector3.new(
            math.random(-100, 100) / 100 * intensity,
            math.random(-50, 50) / 100 * intensity,
            math.random(-100, 100) / 100 * intensity
        )
        
        camera.CFrame = camera.CFrame * CFrame.new(shake)
    end)
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🌍 Terremoto!", "Intensidade: " .. intensity, duration)
    end
end

-- Exportar sistemas
_G.WaterSystem = WaterSystem
_G.AtmosphereSystem = AtmosphereSystem
_G.WindSystem = WindSystem
_G.EffectsSystem = EffectsSystem

-- Inicializar sistemas
AtmosphereSystem:SetupEffects()
WaterSystem:SetupSwimming()
WaterSystem:StartWaveSimulation()

print("🌑 Mortal Terrain Editor - Parte 5 Carregada (Água, Atmosfera, Efeitos)")

-- 🌑☠️ MORTAL DARKNESS TERRAIN EDITOR V1 ☠️🌑
-- Parte 6 - Vegetação, Física e Export
-- Para Studio Lite + Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Selection = game:GetService("Selection")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TerrainGui = playerGui:WaitForChild("MortalTerrainGUI")
local mainFrame = _G.TerrainMainFrame
local TerrainData = _G.TerrainData
local Colors = _G.TerrainColors
local StyleSystem = _G.StyleSystem
local TerrainEditor = _G.TerrainEditor

local terrain = Workspace:WaitForChild("Terrain")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE VEGETAÇÃO
-- ═══════════════════════════════════════════════════════════════

local VegetationSystem = {}
VegetationSystem.PlacedObjects = {}

-- Templates de vegetação por estilo
VegetationSystem.Templates = {
    ["Ultra Realistic"] = {
        trees = {
            {name = "Oak", height = {15, 25}, trunkColor = Color3.fromRGB(80, 50, 30), leafColor = Color3.fromRGB(50, 120, 50)},
            {name = "Pine", height = {20, 35}, trunkColor = Color3.fromRGB(70, 45, 25), leafColor = Color3.fromRGB(30, 80, 40)},
            {name = "Birch", height = {12, 20}, trunkColor = Color3.fromRGB(220, 220, 210), leafColor = Color3.fromRGB(100, 180, 80)}
        },
        plants = {
            {name = "Bush", size = {2, 4}, color = Color3.fromRGB(40, 100, 40)},
            {name = "Flower", size = {0.5, 1}, color = Color3.fromRGB(255, 100, 150)},
            {name = "Grass", size = {0.3, 0.8}, color = Color3.fromRGB(80, 150, 60)}
        },
        rocks = {
            {name = "Boulder", size = {3, 8}, color = Color3.fromRGB(100, 100, 100)},
            {name = "Pebble", size = {0.5, 1.5}, color = Color3.fromRGB(120, 110, 100)}
        }
    },
    
    ["Tropical"] = {
        trees = {
            {name = "Palm", height = {15, 25}, trunkColor = Color3.fromRGB(120, 80, 50), leafColor = Color3.fromRGB(50, 150, 50)},
            {name = "Banana", height = {8, 12}, trunkColor = Color3.fromRGB(100, 130, 60), leafColor = Color3.fromRGB(80, 180, 60)}
        },
        plants = {
            {name = "Fern", size = {1, 3}, color = Color3.fromRGB(60, 140, 60)},
            {name = "Orchid", size = {0.3, 0.6}, color = Color3.fromRGB(255, 100, 200)}
        }
    },
    
    ["Desert"] = {
        trees = {
            {name = "Cactus", height = {5, 15}, trunkColor = Color3.fromRGB(80, 130, 70), leafColor = Color3.fromRGB(80, 130, 70)}
        },
        plants = {
            {name = "Tumbleweed", size = {1, 2}, color = Color3.fromRGB(180, 150, 100)},
            {name = "DesertFlower", size = {0.3, 0.5}, color = Color3.fromRGB(255, 200, 100)}
        },
        rocks = {
            {name = "Sandstone", size = {2, 6}, color = Color3.fromRGB(200, 170, 130)}
        }
    },
    
    ["Arctic"] = {
        trees = {
            {name = "FrozenPine", height = {10, 20}, trunkColor = Color3.fromRGB(60, 40, 30), leafColor = Color3.fromRGB(220, 240, 255)}
        },
        plants = {},
        rocks = {
            {name = "IceRock", size = {2, 8}, color = Color3.fromRGB(180, 220, 255)}
        }
    },
    
    ["Fantasy"] = {
        trees = {
            {name = "GlowTree", height = {15, 30}, trunkColor = Color3.fromRGB(80, 60, 100), leafColor = Color3.fromRGB(150, 100, 255)},
            {name = "CrystalTree", height = {10, 18}, trunkColor = Color3.fromRGB(100, 150, 200), leafColor = Color3.fromRGB(200, 150, 255)}
        },
        plants = {
            {name = "Mushroom", size = {1, 4}, color = Color3.fromRGB(255, 100, 100), glow = true},
            {name = "GlowFlower", size = {0.5, 1}, color = Color3.fromRGB(100, 255, 200), glow = true}
        }
    },
    
    ["Sci-Fi"] = {
        trees = {
            {name = "CrystalSpire", height = {10, 25}, trunkColor = Color3.fromRGB(0, 200, 255), leafColor = Color3.fromRGB(0, 150, 255), glow = true}
        },
        plants = {
            {name = "HoloPlant", size = {1, 2}, color = Color3.fromRGB(255, 0, 200), glow = true}
        }
    },
    
    ["Horror"] = {
        trees = {
            {name = "DeadTree", height = {10, 20}, trunkColor = Color3.fromRGB(40, 30, 25), leafColor = nil}
        },
        plants = {
            {name = "DeadBush", size = {1, 2}, color = Color3.fromRGB(60, 50, 40)}
        }
    }
}

-- Criar árvore procedural
function VegetationSystem:CreateTree(template, position)
    local treeFolder = Workspace:FindFirstChild("Vegetation")
    if not treeFolder then
        treeFolder = Instance.new("Folder")
        treeFolder.Name = "Vegetation"
        treeFolder.Parent = Workspace
    end
    
    local height = math.random(template.height[1], template.height[2])
    local trunkWidth = height / 10
    
    local tree = Instance.new("Model")
    tree.Name = template.name
    
    -- Tronco
    local trunk = Instance.new("Part")
    trunk.Name = "Trunk"
    trunk.Size = Vector3.new(trunkWidth, height * 0.6, trunkWidth)
    trunk.Position = position + Vector3.new(0, height * 0.3, 0)
    trunk.Anchored = true
    trunk.Color = template.trunkColor
    trunk.Material = Enum.Material.Wood
    trunk.Parent = tree
    
    -- Copa (se tiver folhas)
    if template.leafColor then
        local canopy = Instance.new("Part")
        canopy.Name = "Canopy"
        canopy.Shape = Enum.PartType.Ball
        canopy.Size = Vector3.new(height * 0.6, height * 0.5, height * 0.6)
        canopy.Position = position + Vector3.new(0, height * 0.75, 0)
        canopy.Anchored = true
        canopy.Color = template.leafColor
        canopy.Material = Enum.Material.Grass
        canopy.Parent = tree
        
        if template.glow then
            canopy.Material = Enum.Material.Neon
        end
    end
    
    tree.Parent = treeFolder
    tree.PrimaryPart = trunk
    
    table.insert(self.PlacedObjects, tree)
    return tree
end

-- Criar planta
function VegetationSystem:CreatePlant(template, position)
    local vegFolder = Workspace:FindFirstChild("Vegetation")
    if not vegFolder then
        vegFolder = Instance.new("Folder")
        vegFolder.Name = "Vegetation"
        vegFolder.Parent = Workspace
    end
    
    local size = math.random(template.size[1] * 10, template.size[2] * 10) / 10
    
    local plant = Instance.new("Part")
    plant.Name = template.name
    plant.Size = Vector3.new(size, size * 1.5, size)
    plant.Position = position + Vector3.new(0, size * 0.75, 0)
    plant.Anchored = true
    plant.Color = template.color
    plant.Material = template.glow and Enum.Material.Neon or Enum.Material.Grass
    plant.Parent = vegFolder
    
    table.insert(self.PlacedObjects, plant)
    return plant
end

-- Criar rocha
function VegetationSystem:CreateRock(template, position)
    local vegFolder = Workspace:FindFirstChild("Vegetation")
    if not vegFolder then
        vegFolder = Instance.new("Folder")
        vegFolder.Name = "Vegetation"
        vegFolder.Parent = Workspace
    end
    
    local size = math.random(template.size[1] * 10, template.size[2] * 10) / 10
    
    local rock = Instance.new("Part")
    rock.Name = template.name
    rock.Size = Vector3.new(size * 1.2, size, size)
    rock.Position = position + Vector3.new(0, size * 0.5, 0)
    rock.Anchored = true
    rock.Color = template.color
    rock.Material = Enum.Material.Rock
    rock.Parent = vegFolder
    
    -- Rotação aleatória
    rock.Orientation = Vector3.new(
        math.random(-15, 15),
        math.random(0, 360),
        math.random(-15, 15)
    )
    
    table.insert(self.PlacedObjects, rock)
    return rock
end

-- Espalhar vegetação automaticamente
function VegetationSystem:ScatterVegetation(options)
    options = options or {}
    
    local style = options.style or TerrainData.CurrentStyle or "Ultra Realistic"
    local area = options.area or 200
    local density = options.density or 0.1
    local treeCount = options.trees or 50
    local plantCount = options.plants or 100
    local rockCount = options.rocks or 30
    
    local templates = self.Templates[style] or self.Templates["Ultra Realistic"]
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🌿 Gerando Vegetação", "Estilo: " .. style, 3)
    end
    
    -- Criar árvores
    if templates.trees and #templates.trees > 0 then
        for i = 1, treeCount do
            local template = templates.trees[math.random(1, #templates.trees)]
            local x = math.random(-area, area)
            local z = math.random(-area, area)
            
            -- Raycast para encontrar o chão
            local ray = Ray.new(Vector3.new(x, 500, z), Vector3.new(0, -1000, 0))
            local hit, hitPos = Workspace:FindPartOnRay(ray, Workspace:FindFirstChild("Vegetation"))
            
            if hit and hit.Name == "Terrain" then
                self:CreateTree(template, hitPos)
            end
            
            if i % 10 == 0 then task.wait() end
        end
    end
    
    -- Criar plantas
    if templates.plants and #templates.plants > 0 then
        for i = 1, plantCount do
            local template = templates.plants[math.random(1, #templates.plants)]
            local x = math.random(-area, area)
            local z = math.random(-area, area)
            
            local ray = Ray.new(Vector3.new(x, 500, z), Vector3.new(0, -1000, 0))
            local hit, hitPos = Workspace:FindPartOnRay(ray, Workspace:FindFirstChild("Vegetation"))
            
            if hit and hit.Name == "Terrain" then
                self:CreatePlant(template, hitPos)
            end
            
            if i % 20 == 0 then task.wait() end
        end
    end
    
    -- Criar rochas
    if templates.rocks and #templates.rocks > 0 then
        for i = 1, rockCount do
            local template = templates.rocks[math.random(1, #templates.rocks)]
            local x = math.random(-area, area)
            local z = math.random(-area, area)
            
            local ray = Ray.new(Vector3.new(x, 500, z), Vector3.new(0, -1000, 0))
            local hit, hitPos = Workspace:FindPartOnRay(ray, Workspace:FindFirstChild("Vegetation"))
            
            if hit and hit.Name == "Terrain" then
                self:CreateRock(template, hitPos)
            end
        end
    end
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("✅ Vegetação Criada", "Árvores, plantas e rochas adicionadas!", 2)
    end
end

-- Limpar vegetação
function VegetationSystem:ClearVegetation()
    local vegFolder = Workspace:FindFirstChild("Vegetation")
    if vegFolder then
        vegFolder:ClearAllChildren()
    end
    self.PlacedObjects = {}
    
    if _G.ShowMortalNotification then
        _G.ShowMortalNotification("🗑️ Limpo", "Vegetação removida!", 2)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE FÍSICA DE INTERAÇÃO
-- ═══════════════════════════════════════════════════════════════

local PhysicsSystem = {}
PhysicsSystem.InteractiveObjects = {}
PhysicsSystem.DestructibleTerrain = true
PhysicsSystem.ExplosionDamage = true

-- Configurar física do terreno
function PhysicsSystem:SetupTerrainPhysics()
    -- Materiais e suas propriedades físicas
    self.MaterialProperties = {
        [Enum.Material.Grass] = {friction = 0.4, density = 1, walkSpeed = 16},
        [Enum.Material.Sand] = {friction = 0.6, density = 0.8, walkSpeed = 12},
        [Enum.Material.Rock] = {friction = 0.3, density = 2, walkSpeed = 16},
        [Enum.Material.Ice] = {friction = 0.05, density = 0.9, walkSpeed = 20},
        [Enum.Material.Snow] = {friction = 0.5, density = 0.5, walkSpeed = 10},
        [Enum.Material.Mud] = {friction = 0.8, density = 1.2, walkSpeed = 8},
        [Enum.Material.Water] = {friction = 0.1, density = 1, walkSpeed = 6},
        [Enum.Material.CrackedLava] = {friction = 0.4, density = 2, walkSpeed = 14, damage = 10},
        [Enum.Material.Asphalt] = {friction = 0.3, density = 1.5, walkSpeed = 18},
        [Enum.Material.Concrete] = {friction = 0.35, density = 1.8, walkSpeed = 17},
        [Enum.Material.LeafyGrass] = {friction = 0.45, density = 0.9, walkSpeed = 15}
    }
end

-- Detectar material sob o jogador e aplicar física
function PhysicsSystem:StartMaterialDetection()
    if self.MaterialConnection then
        self.MaterialConnection:Disconnect()
    end
    
    self.MaterialConnection = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if not rootPart or not humanoid then return end
        
        -- Raycast para baixo para detectar material
        local rayOrigin = rootPart.Position
        local rayDirection = Vector3.new(0, -10, 0)
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {character}
        
        local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if result and result.Instance then
            local material = result.Material
            local props = self.MaterialProperties[material]
            
            if props then
                -- Aplicar velocidade de caminhada
                humanoid.WalkSpeed = props.walkSpeed
                
                -- Aplicar dano se for lava
                if props.damage and props.damage > 0 then
                    humanoid:TakeDamage(props.damage * 0.1) -- Dano por frame
                end
            end
        end
    end)
end

-- Criar objeto destrutível
function PhysicsSystem:MakeDestructible(object, health)
    health = health or 100
    
    local destructData = {
        Object = object,
        MaxHealth = health,
        CurrentHealth = health
    }
    
    table.insert(self.InteractiveObjects, destructData)
    
    return destructData
end

-- Causar dano a terreno (explosão)
function PhysicsSystem:DamageTerrainAt(position, radius, power)
    if not self.DestructibleTerrain then return end
    
    radius = radius or 10
    power = power or 1
    
    -- Remover terreno
    terrain:FillBall(position, radius * power, Enum.Material.Air)
    
    -- Criar partículas de destroços
    local debrisCount = math.floor(radius * 2)
    
    for i = 1, debrisCount do
        local debris = Instance.new("Part")
        debris.Size = Vector3.new(
            math.random(1, 3),
            math.random(1, 3),
            math.random(1, 3)
        )
        debris.Position = position + Vector3.new(
            math.random(-radius, radius),
            math.random(0, radius),
            math.random(-radius, radius)
        )
        debris.Color = Color3.fromRGB(100, 80, 60)
        debris.Material = Enum.Material.Rock
        debris.Parent = Workspace
        
        -- Física
        debris.Velocity = Vector3.new(
            math.random(-50, 50) * power,
            math.random(30, 80) * power,
            math.random(-50, 50) * power
        )
        
        game:GetService("Debris"):AddItem(debris, 5)
    end
end

-- Sistema de pegadas
function PhysicsSystem:EnableFootprints()
    if self.FootprintConnection then
        self.FootprintConnection:Disconnect()
    end
    
    local lastFootprintTime = 0
    local footprintInterval = 0.5
    
    self.FootprintConnection = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then return end
        
        if humanoid.MoveDirection.Magnitude > 0 and tick() - lastFootprintTime > footprintInterval then
            lastFootprintTime = tick()
            
            -- Criar pegada
            local footprint = Instance.new("Part")
            footprint.Size = Vector3.new(0.8, 0.05, 1.2)
            footprint.Position = rootPart.Position - Vector3.new(0, 3, 0)
            footprint.Anchored = true
            footprint.CanCollide = false
            footprint.Transparency = 0.5
            footprint.Color = Color3.fromRGB(50, 40, 30)
            footprint.Material = Enum.Material.SmoothPlastic
            footprint.Parent = Workspace
            
            -- Orientar na direção do movimento
            footprint.CFrame = CFrame.new(footprint.Position, footprint.Position + humanoid.MoveDirection)
            
            -- Fade out
            TweenService:Create(footprint, TweenInfo.new(5), {
                Transparency = 1
            }):Play()
            
            game:GetService("Debris"):AddItem(footprint, 5)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE EXPORT
-- ═══════════════════════════════════════════════════════════════

local ExportSystem = {}

-- Gerar código do terreno
function ExportSystem:GenerateTerrainCode()
    local code = [[
-- 🌑☠️ MORTAL DARKNESS TERRAIN - Código Exportado ☠️🌑
-- Gerado automaticamente pelo Mortal Terrain Editor V1

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local terrain = Workspace.Terrain

-- Configurações do Terreno
local TerrainConfig = {
    Style = "]] .. (TerrainData.CurrentStyle or "Ultra Realistic") .. [[",
    Seed = ]] .. (TerrainData.Seed or math.random(1, 9999)) .. [[,
    WaterLevel = ]] .. (TerrainData.WaterLevel or 0) .. [[,
    Amplitude = ]] .. (TerrainData.Amplitude or 50) .. [[,
    NoiseScale = ]] .. (TerrainData.NoiseScale or 100) .. [[
}

-- Configurações de Lighting
local LightingConfig = {
    Brightness = ]] .. Lighting.Brightness .. [[,
    ClockTime = ]] .. Lighting.ClockTime .. [[,
    Ambient = Color3.fromRGB(]] .. math.floor(Lighting.Ambient.R * 255) .. [[, ]] .. math.floor(Lighting.Ambient.G * 255) .. [[, ]] .. math.floor(Lighting.Ambient.B * 255) .. [[),
    OutdoorAmbient = Color3.fromRGB(]] .. math.floor(Lighting.OutdoorAmbient.R * 255) .. [[, ]] .. math.floor(Lighting.OutdoorAmbient.G * 255) .. [[, ]] .. math.floor(Lighting.OutdoorAmbient.B * 255) .. [[)
}

-- Aplicar Lighting
for prop, value in pairs(LightingConfig) do
    pcall(function()
        Lighting[prop] = value
    end)
end

-- Configurar Atmosfera
local atmosphere = Lighting:FindFirstChild("Atmosphere") or Instance.new("Atmosphere")
atmosphere.Parent = Lighting
]]
    
    -- Adicionar configurações de atmosfera se existirem
    local atm = Lighting:FindFirstChild("Atmosphere")
    if atm then
        code = code .. [[

atmosphere.Density = ]] .. atm.Density .. [[
atmosphere.Offset = ]] .. atm.Offset .. [[
atmosphere.Color = Color3.fromRGB(]] .. math.floor(atm.Color.R * 255) .. [[, ]] .. math.floor(atm.Color.G * 255) .. [[, ]] .. math.floor(atm.Color.B * 255) .. [[)
atmosphere.Decay = Color3.fromRGB(]] .. math.floor(atm.Decay.R * 255) .. [[, ]] .. math.floor(atm.Decay.G * 255) .. [[, ]] .. math.floor(atm.Decay.B * 255) .. [[)
atmosphere.Glare = ]] .. atm.Glare .. [[
atmosphere.Haze = ]] .. atm.Haze .. [[
]]
    end
    
    -- Adicionar configurações de água
    code = code .. [[

-- Configurar Água
terrain.WaterColor = Color3.fromRGB(]] .. math.floor(terrain.WaterColor.R * 255) .. [[, ]] .. math.floor(terrain.WaterColor.G * 255) .. [[, ]] .. math.floor(terrain.WaterColor.B * 255) .. [[)
terrain.WaterTransparency = ]] .. terrain.WaterTransparency .. [[

-- Configurar Vento
Workspace.GlobalWind = Vector3.new(]] .. Workspace.GlobalWind.X .. [[, ]] .. Workspace.GlobalWind.Y .. [[, ]] .. Workspace.GlobalWind.Z .. [[)

print("🌑 Terreno carregado com sucesso!")
]]
    
    return code
end

-- Mostrar diálogo de export
function ExportSystem:ShowExportDialog()
    local exportFrame = Instance.new("Frame")
    exportFrame.Name = "ExportDialog"
    exportFrame.Size = UDim2.new(0, isMobile and 320 or 550, 0, isMobile and 420 or 500)
    exportFrame.Position = UDim2.new(0.5, isMobile and -160 or -275, 0.5, isMobile and -210 or -250)
    exportFrame.BackgroundColor3 = Colors.Background
    exportFrame.BorderSizePixel = 0
    exportFrame.ZIndex = 50
    exportFrame.Parent = TerrainGui
    CreateCorner(exportFrame, 16)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Gold
    stroke.Thickness = 2
    stroke.Parent = exportFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Colors.Secondary
    header.BorderSizePixel = 0
    header.ZIndex = 51
    header.Parent = exportFrame
    CreateCorner(header, 16)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "💾 EXPORTAR TERRENO"
    title.TextColor3 = Colors.Gold
    title.TextSize = 18
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 52
    title.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -17)
    closeBtn.BackgroundColor3 = Colors.Red
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Colors.Text
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 52
    closeBtn.Parent = header
    CreateCorner(closeBtn, 8)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(exportFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        exportFrame:Destroy()
    end)
    
    -- Descrição
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 40)
    desc.Position = UDim2.new(0, 10, 0, 50)
    desc.BackgroundTransparency = 1
    desc.Text = "Copie o código abaixo e cole em um Script para recriar o terreno e suas configurações."
    desc.TextColor3 = Colors.TextDark
    desc.TextSize = 12
    desc.Font = Enum.Font.Gotham
    desc.TextWrapped = true
    desc.ZIndex = 51
    desc.Parent = exportFrame
    
    -- Code box
    local codeScroll = Instance.new("ScrollingFrame")
    codeScroll.Size = UDim2.new(1, -20, 1, -150)
    codeScroll.Position = UDim2.new(0, 10, 0, 95)
    codeScroll.BackgroundColor3 = Colors.Tertiary
    codeScroll.BorderSizePixel = 0
    codeScroll.ScrollBarThickness = 4
    codeScroll.ScrollBarImageColor3 = Colors.Purple
    codeScroll.ZIndex = 51
    codeScroll.CanvasSize = UDim2.new(0, 0, 0, 2000)
    codeScroll.Parent = exportFrame
    CreateCorner(codeScroll, 8)
    
    local codeText = Instance.new("TextBox")
    codeText.Size = UDim2.new(1, -10, 0, 2000)
    codeText.Position = UDim2.new(0, 5, 0, 5)
    codeText.BackgroundTransparency = 1
    codeText.Text = self:GenerateTerrainCode()
    codeText.TextColor3 = Colors.Green
    codeText.TextSize = 10
    codeText.Font = Enum.Font.Code
    codeText.TextXAlignment = Enum.TextXAlignment.Left
    codeText.TextYAlignment = Enum.TextYAlignment.Top
    codeText.TextWrapped = true
    codeText.ClearTextOnFocus = false
    codeText.MultiLine = true
    codeText.ZIndex = 52
    codeText.Parent = codeScroll
    
    -- Botão Copiar
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.48, 0, 0, 40)
    copyBtn.Position = UDim2.new(0.01, 10, 1, -50)
    copyBtn.BackgroundColor3 = Colors.Green
    copyBtn.Text = "📋 COPIAR CÓDIGO"
    copyBtn.TextColor3 = Colors.Text
    copyBtn.TextSize = 14
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.BorderSizePixel = 0
    copyBtn.ZIndex = 51
    copyBtn.Parent = exportFrame
    CreateCorner(copyBtn, 10)
    
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(codeText.Text)
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("✅ Copiado!", "Código copiado para a área de transferência!", 2)
            end
        else
            codeText:CaptureFocus()
            if _G.ShowMortalNotification then
                _G.ShowMortalNotification("📋 Selecione", "Selecione e copie manualmente (Ctrl+C)", 3)
            end
        end
    end)
    
    -- Botão Salvar Vegetação
    local saveVegBtn = Instance.new("TextButton")
    saveVegBtn.Size = UDim2.new(0.48, 0, 0, 40)
    saveVegBtn.Position = UDim2.new(0.51, 0, 1, -50)
    saveVegBtn.BackgroundColor3 = Colors.Purple
    saveVegBtn.Text = "🌿 INCLUIR VEGETAÇÃO"
    saveVegBtn.TextColor3 = Colors.Text
    saveVegBtn.TextSize = 12
    saveVegBtn.Font = Enum.Font.GothamBold
    saveVegBtn.BorderSizePixel = 0
    saveVegBtn.ZIndex = 51
    saveVegBtn.Parent = exportFrame
    CreateCorner(saveVegBtn, 10)
    
    saveVegBtn.MouseButton1Click:Connect(function()
        local vegCode = self:GenerateVegetationCode()
        codeText.Text = codeText.Text .. "\n\n" .. vegCode
        
        if _G.ShowMortalNotification then
            _G.ShowMortalNotification("🌿 Adicionado", "Código de vegetação incluído!", 2)
        end
    end)
    
    -- Animação de entrada
    exportFrame.Size = UDim2.new(0, 0, 0, 0)
    exportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(exportFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, isMobile and 320 or 550, 0, isMobile and 420 or 500),
        Position = UDim2.new(0.5, isMobile and -160 or -275, 0.5, isMobile and -210 or -250)
    }):Play()
end

-- Gerar código de vegetação
function ExportSystem:GenerateVegetationCode()
    local vegFolder = Workspace:FindFirstChild("Vegetation")
    if not vegFolder then
        return "-- Nenhuma vegetação para exportar"
    end
    
    local code = [[
-- 🌿 VEGETAÇÃO EXPORTADA

local vegetation = Instance.new("Folder")
vegetation.Name = "Vegetation"
vegetation.Parent = Workspace

local vegData = {
]]
    
    local count = 0
    for _, obj in ipairs(vegFolder:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            count = count + 1
            if count > 200 then break end -- Limitar para não ficar muito grande
            
            local pos = obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position or obj.Position
            local color = obj:IsA("Part") and obj.Color or (obj:FindFirstChild("Trunk") and obj.Trunk.Color or Color3.new(1,1,1))
            
            code = code .. string.format(
                '    {name = "%s", pos = Vector3.new(%.1f, %.1f, %.1f), color = Color3.fromRGB(%d, %d, %d)},\n',
                obj.Name,
                pos.X, pos.Y, pos.Z,
                math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
            )
        end
    end
    
    code = code .. [[
}

for _, data in ipairs(vegData) do
    local part = Instance.new("Part")
    part.Name = data.name
    part.Position = data.pos
    part.Color = data.color
    part.Anchored = true
    part.Size = Vector3.new(3, 5, 3)
    part.Parent = vegetation
end

print("🌿 Vegetação carregada: " .. #vegData .. " objetos")
]]
    
    return code
end

-- ═══════════════════════════════════════════════════════════════
-- CONEXÃO DOS BOTÕES DO MENU
-- ═══════════════════════════════════════════════════════════════

-- Toggle do menu principal
local toggleBtn = TerrainGui:FindFirstChild("TerrainToggle")
local menuVisible = false

if toggleBtn then
    toggleBtn.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        
        if menuVisible then
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, isMobile and 350 or 950, 0, isMobile and 520 or 600),
                Position = UDim2.new(0.5, isMobile and -175 or -475, 0.5, isMobile and -260 or -300)
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
end

-- Adicionar botões extras no painel de ferramentas
local toolsPanel = mainFrame:FindFirstChild("ToolsPanel")
if toolsPanel then
    local toolsScroll = toolsPanel:FindFirstChildOfClass("ScrollingFrame")
    if toolsScroll then
        -- Botão de Vegetação
        local vegBtn = Instance.new("TextButton")
        vegBtn.Name = "Vegetation"
        vegBtn.Size = UDim2.new(1, 0, 0, isMobile and 35 or 40)
        vegBtn.BackgroundColor3 = Colors.TerrainGreen
        vegBtn.Text = "🌿" .. (isMobile and "" or " Vegetação")
        vegBtn.TextColor3 = Colors.Text
        vegBtn.TextSize = isMobile and 14 or 12
        vegBtn.Font = Enum.Font.GothamBold
        vegBtn.BorderSizePixel = 0
        vegBtn.ZIndex = 23
        vegBtn.LayoutOrder = 20
        vegBtn.Parent = toolsScroll
        CreateCorner(vegBtn, 8)
        
        vegBtn.MouseButton1Click:Connect(function()
            VegetationSystem:ScatterVegetation({
                style = TerrainData.CurrentStyle,
                trees = 30,
                plants = 60,
                rocks = 20
            })
        end)
        
        -- Botão Limpar Vegetação
        local clearVegBtn = Instance.new("TextButton")
        clearVegBtn.Name = "ClearVeg"
        clearVegBtn.Size = UDim2.new(1, 0, 0, isMobile and 35 or 40)
        clearVegBtn.BackgroundColor3 = Colors.Red
        clearVegBtn.Text = "🗑️" .. (isMobile and "" or " Limpar Veg")
        clearVegBtn.TextColor3 = Colors.Text
        clearVegBtn.TextSize = isMobile and 14 or 12
        clearVegBtn.Font = Enum.Font.GothamBold
        clearVegBtn.BorderSizePixel = 0
        clearVegBtn.ZIndex = 23
        clearVegBtn.LayoutOrder = 21
        clearVegBtn.Parent = toolsScroll
        CreateCorner(clearVegBtn, 8)
        
        clearVegBtn.MouseButton1Click:Connect(function()
            VegetationSystem:ClearVegetation()
        end)
        
        -- Botão Exportar
        local exportBtn = Instance.new("TextButton")
        exportBtn.Name = "Export"
        exportBtn.Size = UDim2.new(1, 0, 0, isMobile and 35 or 40)
        exportBtn.BackgroundColor3 = Colors.Gold
        exportBtn.Text = "💾" .. (isMobile and "" or " Exportar")
        exportBtn.TextColor3 = Colors.Background
        exportBtn.TextSize = isMobile and 14 or 12
        exportBtn.Font = Enum.Font.GothamBold
        exportBtn.BorderSizePixel = 0
        exportBtn.ZIndex = 23
        exportBtn.LayoutOrder = 22
        exportBtn.Parent = toolsScroll
        CreateCorner(exportBtn, 8)
        
        exportBtn.MouseButton1Click:Connect(function()
            ExportSystem:ShowExportDialog()
        end)
        
        -- Botão Editar Terreno
        local editBtn = Instance.new("TextButton")
        editBtn.Name = "EditMode"
        editBtn.Size = UDim2.new(1, 0, 0, isMobile and 35 or 40)
        editBtn.BackgroundColor3 = Colors.Blue
        editBtn.Text = "✏️" .. (isMobile and "" or " Modo Edição")
        editBtn.TextColor3 = Colors.Text
        editBtn.TextSize = isMobile and 14 or 12
        editBtn.Font = Enum.Font.GothamBold
        editBtn.BorderSizePixel = 0
        editBtn.ZIndex = 23
        editBtn.LayoutOrder = 23
        editBtn.Parent = toolsScroll
        CreateCorner(editBtn, 8)
        
        local editMode = false
        editBtn.MouseButton1Click:Connect(function()
            editMode = not editMode
            
            if editMode then
                TerrainEditor:StartEditing()
                editBtn.BackgroundColor3 = Colors.Green
                editBtn.Text = "✅" .. (isMobile and "" or " Editando...")
            else
                TerrainEditor:StopEditing()
                editBtn.BackgroundColor3 = Colors.Blue
                editBtn.Text = "✏️" .. (isMobile and "" or " Modo Edição")
            end
        end)
    end
end

-- Exportar sistemas
_G.VegetationSystem = VegetationSystem
_G.PhysicsSystem = PhysicsSystem
_G.ExportSystem = ExportSystem

-- Inicializar sistemas
PhysicsSystem:SetupTerrainPhysics()
PhysicsSystem:StartMaterialDetection()

-- Conectar ao menu principal de plugins (se existir)
if _G.MortalPluginsLoaded then
    _G.LoadMortalTerrainEditor = function()
        menuVisible = true
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, isMobile and 350 or 950, 0, isMobile and 520 or 600),
            Position = UDim2.new(0.5, isMobile and -175 or -475, 0.5, isMobile and -260 or -300)
        }):Play()
    end
end

-- Notificação de carregamento
task.wait(0.5)
if _G.ShowMortalNotification then
    _G.ShowMortalNotification(
        "👑☠️MORTAL DARKNESS TERRAIN EDITOR☠️👑",
        "Carregado com Sucesso!\n\nCrie mundos incríveis com qualidade AAA⚡",
        5
    )
end

print("═══════════════════════════════════════════════════════════")
print("🌑☠️ MORTAL DARKNESS TERRAIN EDITOR V1 - COMPLETO ☠️🌑")
print("═══════════════════════════════════════════════════════════")
print("✅ Interface carregada")
print("✅ Sistema de estilos (12 estilos)")
print("✅ Editor de terreno")
print("✅ Gerador procedural")
print("✅ Sistema de água")
print("✅ Sistema de atmosfera")
print("✅ Sistema de vento e partículas")
print("✅ Sistema de vegetação")
print("✅ Sistema de física")
print("✅ Sistema de export")
print("═══════════════════════════════════════════════════════════")
