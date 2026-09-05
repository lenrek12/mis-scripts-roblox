-- ==============================================
-- PANEL DE ASISTENCIA — VERSIÓN COMPLETA AMPLIADA
-- Círculo sigue al ratón + TODAS las opciones visibles + Barra de desplazamiento
-- Compatible con TODOS los juegos de Roblox
-- ==============================================

-- ══════════════════════════════════════════════
-- CONFIGURACIÓN PRINCIPAL
-- ══════════════════════════════════════════════
local Config = {
    -- AIMBOT
    AimEnabled = false,
    AimPart = "Head",
    AimStrength = 5,
    AimKey = Enum.UserInputType.MouseButton2,
    CircleRadius = 160,
    CircleColor = Color3.fromRGB(0, 255, 0),
    CircleTransparency = 0.7,

    -- FOV / CÁMARA
    FovEnabled = false,
    FovValue = 1,
    MinFOV = 1,
    MaxFOV = 10,

    -- COMBATE
    NoRecoilEnabled = false,
    RapidFireEnabled = false,
    SilentAimEnabled = false,

    -- ESP / VISIÓN
    EspEnabled = true,
    EspBox = true,
    EspName = true,
    EspHealth = true,
    EspDistance = true,
    EspTracer = true,
    EspColor = Color3.fromRGB(255, 0, 0),
    EspMaxDistance = 1000,

    -- ENTORNO
    NightVisionEnabled = false,
    FullBrightEnabled = false,
    RemoveFogEnabled = false,

    -- VELOCIDAD / SALTO
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,

    -- TECLAS DE CONTROL
    ToggleUiKey = Enum.KeyCode.Insert,
    ToggleAimbotKey = Enum.KeyCode.A,
    ToggleEspKey = Enum.KeyCode.E,
    ToggleFovKey = Enum.KeyCode.V,
    ToggleNoRecoilKey = Enum.KeyCode.R,
}

-- ══════════════════════════════════════════════
-- SERVICIOS Y VARIABLES GLOBALES
-- ══════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- VALORES ORIGINALES PARA RESTAURAR
local OriginalFOV = Camera.FieldOfView
local OriginalBrightness = Lighting.Brightness
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local OriginalFogEnd = Lighting.FogEnd
local OriginalFogColor = Lighting.FogColor
local OriginalSpeed = 16
local OriginalJumpPower = 50

local UiVisible = true
local EspDrawings = {}
local LastMousePos = Vector2.new(0, 0)

-- ══════════════════════════════════════════════
-- CÍRCULO DE MIRA — SIGUE AL RATÓN
-- ══════════════════════════════════════════════
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Transparency = Config.CircleTransparency
Circle.Radius = Config.CircleRadius
Circle.Color = Config.CircleColor
Circle.Filled = false

-- ACTUALIZAR POSICIÓN DEL CÍRCULO = POSICIÓN DEL RATÓN
local function UpdateCirclePosition()
    local MousePos = UserInputService:GetMouseLocation()
    LastMousePos = MousePos
    Circle.Position = Vector2.new(MousePos.X, MousePos.Y)
    Circle.Radius = Config.CircleRadius
    Circle.Color = Config.CircleColor
    Circle.Visible = UiVisible
end

-- ══════════════════════════════════════════════
-- FUNCIONES AUXILIARES
-- ══════════════════════════════════════════════
local function IsValidPlayer(Player)
    return Player and Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0
end

local function GetMouseWorldPosition()
    local MousePos = UserInputService:GetMouseLocation()
    local UnitRay = Camera:ViewportPointToRay(MousePos.X, MousePos.Y)
    local WorldPos = Camera.CFrame.Position + UnitRay.Direction * 500
    return WorldPos
end

-- ══════════════════════════════════════════════
-- SISTEMA DE APUNTADO — BUSCA EN TORNO AL CURSOR
-- ══════════════════════════════════════════════
local function GetClosestEnemy()
    local MousePos = UserInputService:GetMouseLocation()
    local Center = Vector2.new(MousePos.X, MousePos.Y)
    local BestTarget = nil
    local BestDistance = Config.CircleRadius

    for _, Player in ipairs(Players:GetPlayers()) do
        if IsValidPlayer(Player) then
            local AimPart = Player.Character:FindFirstChild(Config.AimPart) or Player.Character.Head
            if AimPart then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(AimPart.Position)
                if OnScreen then
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Center).Magnitude
                    if Distance < BestDistance then
                        BestDistance = Distance
                        BestTarget = AimPart
                    end
                end
            end
        end
    end
    return BestTarget
end

-- ══════════════════════════════════════════════
-- CREAR INTERFAZ GRÁFICA
-- ══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AssistPanelUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- MARCO PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 520)
MainFrame.Position = UDim2.new(0.015, 0, 0.08, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.025, 0)

-- BARRA DE TÍTULO
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0.025, 0)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Text = "PANEL DE ASISTENCIA"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Size = UDim2.new(1, -90, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- BOTONES MINIMIZAR Y CERRAR
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Text = "−"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 22
MinimizeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
MinimizeButton.Size = UDim2.new(0, 38, 0, 34)
MinimizeButton.Position = UDim2.new(1, -76, 0.5, -17)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
MinimizeButton.AutoLocalize = false
MinimizeButton.Parent = TitleBar
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 5)

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.TextColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Size = UDim2.new(0, 38, 0, 34)
CloseButton.Position = UDim2.new(1, -38, 0.5, -17)
CloseButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
CloseButton.AutoLocalize = false
CloseButton.Parent = TitleBar
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 5)

-- SISTEMA DE ARRASTRE DE VENTANA
local DragActive = false
local DragStartPos = Vector2.new(0, 0)
local FrameStartPos = UDim2.new(0, 0, 0, 0)

TitleBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        DragActive = true
        DragStartPos = UserInputService:GetMouseLocation()
        FrameStartPos = MainFrame.Position
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                DragActive = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if DragActive and Input.UserInputType == Enum.UserInputType.MouseMovement then
        local CurrentMousePos = UserInputService:GetMouseLocation()
        local Delta = CurrentMousePos - DragStartPos
        MainFrame.Position = UDim2.new(
            FrameStartPos.X.Scale,
            FrameStartPos.X.Offset + Delta.X,
            FrameStartPos.Y.Scale,
            FrameStartPos.Y.Offset + Delta.Y
        )
    end
end)

-- FUNCIONES DE MINIMIZAR Y CERRAR
local IsMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame.Size = UDim2.new(0, 340, 0, 42)
        ScrollContainer.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 340, 0, 520)
        ScrollContainer.Visible = true
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    UiVisible = false
    MainFrame.Visible = false
    Circle.Visible = false
end)

-- CONTENEDOR DESPLAZABLE — GARANTIZA QUE TODO SE VEA
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Size = UDim2.new(1, -12, 1, -48)
ScrollContainer.Position = UDim2.new(0, 6, 0, 44)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.ScrollBarThickness = 7
ScrollContainer.ScrollBarColor3 = Color3.fromRGB(90, 90, 90)
ScrollContainer.ScrollBarInset = Enum.ScrollBarInset.Always
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 1400)
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollContainer.ClipsDescendants = true
ScrollContainer.Parent = MainFrame

-- DISPOSICIÓN AUTOMÁTICA DE ELEMENTOS
local ListLayout = Instance.new("UIListLayout")
ListLayout.Name = "ListLayout"
ListLayout.Padding = UDim.new(0, 8)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ListLayout.FillDirection = Enum.FillDirection.Vertical
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollContainer

-- ══════════════════════════════════════════════
-- FUNCIONES DE CREACIÓN DE ELEMENTOS DEL PANEL
-- ══════════════════════════════════════════════
local function AddSpacer()
    local Spacer = Instance.new("Frame")
    Spacer.Name = "Spacer"
    Spacer.Size = UDim2.new(0.96, 0, 0, 6)
    Spacer.BackgroundTransparency = 1
    Spacer.Parent = ScrollContainer
end

local function CreateSectionHeader(TitleText)
    AddSpacer()
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "Section_" .. TitleText
    SectionFrame.Size = UDim2.new(0.96, 0, 0, 30)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    SectionFrame.Parent = ScrollContainer
    Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 6)

    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Text = "▸ " .. string.upper(TitleText) .. " ◂"
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 13
    SectionLabel.TextColor3 = Color3.fromRGB(110, 200, 255)
    SectionLabel.Size = UDim2.new(1, -16, 1, 0)
    SectionLabel.Position = UDim2.new(0, 8, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Center
    SectionLabel.Parent = SectionFrame
end

local function CreateToggle(LabelText, ConfigKey, OnChangeCallback)
    local Container = Instance.new("Frame")
    Container.Name = "Toggle_" .. ConfigKey
    Container.Size = UDim2.new(0.96, 0, 0, 38)
    Container.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    Container.Parent = ScrollContainer
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Text = LabelText
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(235, 235, 235)
    Label.Size = UDim2.new(0.68, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Button = Instance.new("TextButton")
    Button.Name = "Btn_" .. ConfigKey
    Button.Text = Config[ConfigKey] and "ACTIVO" or "INACTIVO"
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 11
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Size = UDim2.new(0, 85, 0, 28)
    Button.Position = UDim2.new(1, -97, 0.5, -14)
    Button.BackgroundColor3 = Config[ConfigKey] and Color3.fromRGB(45, 170, 70) or Color3.fromRGB(170, 50, 50)
    Button.AutoLocalize = false
    Button.Parent = Container
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)

    Button.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        Button.Text = Config[ConfigKey] and "ACTIVO" or "INACTIVO"
        Button.BackgroundColor3 = Config[ConfigKey] and Color3.fromRGB(45, 170, 70) or Color3.fromRGB(170, 50, 50)
        if OnChangeCallback then
            task.spawn(OnChangeCallback, Config[ConfigKey])
        end
    end)
end

local function CreateSlider(LabelText, ConfigKey, MinValue, MaxValue, OnChangeCallback)
    local Container = Instance.new("Frame")
    Container.Name = "Slider_" .. ConfigKey
    Container.Size = UDim2.new(0.96, 0, 0, 54)
    Container.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    Container.Parent = ScrollContainer
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Text = LabelText .. ": " .. Config[ConfigKey]
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(235, 235, 235)
    Label.Size = UDim2.new(1, -16, 0, 20)
    Label.Position = UDim2.new(0, 8, 0, 4)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local BackgroundBar = Instance.new("Frame")
    BackgroundBar.Size = UDim2.new(1, -16, 0, 14)
    BackgroundBar.Position = UDim2.new(0, 8, 0, 34)
    BackgroundBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    BackgroundBar.Parent = Container
    Instance.new("UICorner", BackgroundBar).CornerRadius = UDim.new(1, 0)

    local FillBar = Instance.new("Frame")
    FillBar.Name = "FillBar"
    FillBar.Size = UDim2.new((Config[ConfigKey] - MinValue) / (MaxValue - MinValue), 0, 1, 0)
    FillBar.BackgroundColor3 = Color3.fromRGB(80, 185, 255)
    FillBar.Parent = BackgroundBar
    Instance.new("UICorner", FillBar).CornerRadius = UDim.new(1, 0)

    local function UpdateValue(NewValue)
        Config[ConfigKey] = math.clamp(math.floor(NewValue + 0.5), MinValue, MaxValue)
        Label.Text = LabelText .. ": " .. Config[ConfigKey]
        FillBar.Size = UDim2.new((Config[ConfigKey] - MinValue) / (MaxValue - MinValue), 0, 1, 0)
        if OnChangeCallback then
            task.spawn(OnChangeCallback, Config[ConfigKey])
        end
    end

    local IsDragging = false
    BackgroundBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDragging = true
            local RelativePos = (Input.Position.X - BackgroundBar.AbsolutePosition.X) / BackgroundBar.AbsoluteSize.X
            UpdateValue(MinValue + RelativePos * (MaxValue - MinValue))
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if IsDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local RelativePos = (Input.Position.X - BackgroundBar.AbsolutePosition.X) / BackgroundBar.AbsoluteSize.X
            UpdateValue(MinValue + RelativePos * (MaxValue - MinValue))
        end
    end)
end

local function CreateDropdown(LabelText, ConfigKey, OptionsList)
    local Container = Instance.new("Frame")
    Container.Name = "Dropdown_" .. ConfigKey
    Container.Size = UDim2.new(0.96, 0, 0, 38)
    Container.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    Container.Parent = ScrollContainer
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Text = LabelText
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(235, 235, 235)
    Label.Size = UDim2.new(0.55, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Button = Instance.new("TextButton")
    local CurrentIndex = table.find(OptionsList, Config[ConfigKey]) or 1
    Button.Text = OptionsList[CurrentIndex]
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 11
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Size = UDim2.new(0, 130, 0, 28)
    Button.Position = UDim2.new(1, -142, 0.5, -14)
    Button.BackgroundColor3 = Color3.fromRGB(55, 90, 140)
    Button.AutoLocalize = false
    Button.Parent = Container
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)

    Button.MouseButton1Click:Connect(function()
        CurrentIndex = CurrentIndex % #OptionsList + 1
        Config[ConfigKey] = OptionsList[CurrentIndex]
        Button.Text = OptionsList[CurrentIndex]
    end)
end

local function CreateInfoBox(InfoText)
    AddSpacer()
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(0.96, 0, 0, 80)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    InfoFrame.Parent = ScrollContainer
    Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 6)

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Text = InfoText
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 11
    InfoLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
    InfoLabel.Size = UDim2.new(1, -16, 1, 0)
    InfoLabel.Position = UDim2.new(0, 8, 0, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
    InfoLabel.TextWrapped = true
    InfoLabel.Parent = InfoFrame
end

-- ══════════════════════════════════════════════
-- GENERAR TODAS LAS SECCIONES Y OPCIONES
-- ══════════════════════════════════════════════
task.wait(0.3)

-- 🎯 AIMBOT
CreateSectionHeader("AIMBOT")
CreateToggle("Activar Aimbot", "AimEnabled")
CreateDropdown("Apuntar a parte del cuerpo", "AimPart", {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"})
CreateSlider("Fuerza de sujeción al apuntar", "AimStrength", 1, 10)
CreateSlider("Tamaño del círculo de detección", "CircleRadius", 40, 320)

-- 🔭 FOV / CÁMARA
CreateSectionHeader("FOV Y ZOOM DE CÁMARA")
CreateToggle("Activar acercamiento de cámara", "FovEnabled", function(IsActive)
    if IsActive then
        Camera.FieldOfView = OriginalFOV / Config.FovValue
    else
        Camera.FieldOfView = OriginalFOV
    end
end)
CreateSlider("Nivel de acercamiento", "FovValue", 1, 10, function(Value)
    if Config.FovEnabled then
        Camera.FieldOfView = OriginalFOV / Value
    end
end)

-- 🔫 COMBATE
CreateSectionHeader("COMBATE Y DISPARO")
CreateToggle("Eliminar retroceso al disparar", "NoRecoilEnabled")
CreateToggle("Disparo rápido", "RapidFireEnabled")
CreateToggle("Apuntado silencioso", "SilentAimEnabled")

-- 👁️ ESP / VISIÓN DE JUGADORES
CreateSectionHeader("ESP - VISIÓN DE ENEMIGOS")
CreateToggle("Mostrar información de jugadores", "EspEnabled")
CreateToggle("Mostrar recuadro alrededor", "EspBox")
CreateToggle("Mostrar nombre del jugador", "EspName")
CreateToggle("Mostrar barra de vida", "EspHealth")
CreateToggle("Mostrar distancia", "EspDistance")
CreateToggle("Línea trazadora desde tu posición", "EspTracer")

-- 🌙 ENTORNO Y VISIBILIDAD
CreateSectionHeader("ENTORNO Y VISIBILIDAD")
CreateToggle("Visión nocturna (iluminar zona oscura)", "NightVisionEnabled", function(IsActive)
    if IsActive then
        Lighting.Brightness = 3.5
        Lighting.Ambient = Color3.fromRGB(210, 210, 210)
        Lighting.OutdoorAmbient = Color3.fromRGB(210, 210, 210)
    else
        Lighting.Brightness = OriginalBrightness
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient
    end
end)
CreateToggle("Brillo máximo en todo el mapa", "FullBrightEnabled", function(IsActive)
    if IsActive then
        Lighting.Brightness = 4
        Lighting.ClockTime = 14
        Lighting.GeographicLatitude = 0
    else
        Lighting.Brightness = OriginalBrightness
    end
end)
CreateToggle("Eliminar niebla del mapa", "RemoveFogEnabled", function(IsActive)
    if IsActive then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = OriginalFogEnd
    end
end)

-- ⚡ MOVIMIENTO
CreateSectionHeader("MOVIMIENTO Y VELOCIDAD")
CreateToggle("Activar velocidad personalizada", "SpeedEnabled")
CreateSlider("Velocidad de movimiento", "SpeedValue", 10, 120)
CreateToggle("Activar altura de salto personalizada", "JumpPowerEnabled")
CreateSlider("Fuerza de salto", "JumpPowerValue", 20, 200)

-- ⌘ TECLAS DE CONTROL
CreateSectionHeader("TECLAS RÁPIDAS")
CreateInfoBox([[
INSERT → Mostrar / Ocultar todo el panel
Tecla A → Encender / Apagar Aimbot
Tecla E → Encender / Apagar visión de jugadores
Tecla V → Encender / Apagar acercamiento de cámara
Tecla R → Encender / Apagar sin retroceso
Botón DERECHO del ratón → Mantener presionado para apuntar automáticamente

El círculo verde sigue tu ratón y busca enemigos dentro de él.]])

-- ══════════════════════════════════════════════
-- APLICAR CAMBIOS DE MOVIMIENTO
-- ══════════════════════════════════════════════
local function ApplyMovementSettings()
    if not LocalPlayer.Character then return end
    local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if Humanoid then
        if Config.SpeedEnabled then
            Humanoid.WalkSpeed = Config.SpeedValue
        else
            Humanoid.WalkSpeed = OriginalSpeed
        end
        if Config.JumpPowerEnabled then
            Humanoid.JumpPower = Config.JumpPowerValue
            Humanoid.JumpHeight = Config.JumpPowerValue / 2
        else
            Humanoid.JumpPower = OriginalJumpPower
            Humanoid.JumpHeight = 7.2
        end
    end
end

-- ══════════════════════════════════════════════
-- SISTEMA DE DIBUJO ESP
-- ══════════════════════════════════════════════
local function DrawESP()
    for _, Player in ipairs(Players:GetPlayers()) do
        if not IsValidPlayer(Player) then
            if EspDrawings[Player] then
                for _, DrawingObj in ipairs(EspDrawings[Player]) do
                    DrawingObj.Visible = false
                end
            end
            continue
        end

        local Character = Player.Character
        local RootPart = Character.HumanoidRootPart
        local Humanoid = Character.Humanoid
        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
        local DistanceToPlayer = math.floor((Camera.CFrame.Position - RootPart.Position).Magnitude)

        -- Limitar distancia máxima
        if DistanceToPlayer > Config.EspMaxDistance then
            if EspDrawings[Player] then
                for _, DrawingObj in ipairs(EspDrawings[Player]) do
                    DrawingObj.Visible = false
                end
            end
            continue
        end

        -- Crear dibujos si no existen
        if not EspDrawings[Player] then
            EspDrawings[Player] = {
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                HealthBarBg = Drawing.new("Square"),
                HealthBar = Drawing.new("Square"),
                HealthText = Drawing.new("Text"),
                Distance = Drawing.new("Text"),
                Tracer = Drawing.new("Line"),
            }
            for _, D in ipairs(EspDrawings[Player]) do
                D.Center = true
            end
            EspDrawings[Player].Box.Thickness = 2
            EspDrawings[Player].Name.Size = 12
            EspDrawings[Player].HealthText.Size = 10
            EspDrawings[Player].Distance.Size = 10
            EspDrawings[Player].Tracer.Thickness = 1
        end

        local Draw = EspDrawings[Player]
        local BoxHeight = (Camera:WorldToViewportPoint(Vector3.new(0, 2.7, 0) + RootPart.Position) - Camera:WorldToViewportPoint(Vector3.new(0, -0.6, 0) + RootPart.Position)).Y
        local BoxWidth = BoxHeight * 0.4

        local ShouldShow = Config.EspEnabled and OnScreen and UiVisible

        -- Recuadro
        Draw.Box.Visible = Config.EspBox and ShouldShow
        Draw.Box.Color = Config.EspColor
        Draw.Box.Position = Vector2.new(ScreenPos.X - BoxWidth/2, ScreenPos.Y - BoxHeight/2)
        Draw.Box.Size = Vector2.new(BoxWidth, BoxHeight)

        -- Nombre
        Draw.Name.Visible = Config.EspName and ShouldShow
        Draw.Name.Text = Player.Name
        Draw.Name.Color = Config.EspColor
        Draw.Name.Position = Vector2.new(ScreenPos.X, ScreenPos.Y - BoxHeight/2 - 16)

        -- Barra de vida
        local HealthPercent = Humanoid.Health / Humanoid.MaxHealth
        Draw.HealthBarBg.Visible = Config.EspHealth and ShouldShow
        Draw.HealthBarBg.Color = Color3.fromRGB(60, 60, 60)
        Draw.HealthBarBg.Position = Vector2.new(ScreenPos.X - BoxWidth/2 - 8, ScreenPos.Y - BoxHeight/2)
        Draw.HealthBarBg.Size = Vector2.new(5, BoxHeight)

        Draw.HealthBar.Visible = Config.EspHealth and ShouldShow
        Draw.HealthBar.Color = Color3.fromRGB(255, math.floor(255 * HealthPercent), 40)
        Draw.HealthBar.Position = Vector2.new(ScreenPos.X - BoxWidth/2 - 8, ScreenPos.Y - BoxHeight/2)
        Draw.HealthBar.Size = Vector2.new(5, BoxHeight * HealthPercent)

        Draw.HealthText.Visible = Config.EspHealth and ShouldShow
        Draw.HealthText.Text = math.floor(Humanoid.Health) .. " HP"
        Draw.HealthText.Color = Color3.fromRGB(255, math.floor(255 * HealthPercent), 40)
        Draw.HealthText.Position = Vector2.new(ScreenPos.X, ScreenPos.Y + BoxHeight/2 + 4)

        -- Distancia
        Draw.Distance.Visible = Config.EspDistance and ShouldShow
        Draw.Distance.Text = DistanceToPlayer .. " m"
        Draw.Distance.Color = Config.EspColor
        Draw.Distance.Position = Vector2.new(ScreenPos.X + BoxWidth/2 + 10, ScreenPos.Y)

        -- Línea trazadora
        Draw.Tracer.Visible = Config.EspTracer and ShouldShow
        Draw.Tracer.Color = Config.EspColor
        Draw.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        Draw.Tracer.To = Vector2.new(ScreenPos.X, ScreenPos.Y + BoxHeight/2)
    end
end

-- ══════════════════════════════════════════════
-- BUCLE PRINCIPAL DE EJECUCIÓN
-- ══════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    -- ACTUALIZAR CÍRCULO EN POSICIÓN DEL RATÓN
    UpdateCirclePosition()

    -- APLICAR VELOCIDAD Y SALTO
    ApplyMovementSettings()

    -- SISTEMA DE APUNTADO AUTOMÁTICO
    if Config.AimEnabled and UserInputService:IsMouseButtonDown(Config.AimKey) then
        local TargetPart = GetClosestEnemy()
        if TargetPart then
            local Smoothness = Config.AimStrength / 10
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPart.Position), Smoothness)
        end
    end

    -- ELIMINAR RETROCESO
    if Config.NoRecoilEnabled then
        Mouse.Origin = CFrame.new(Camera.CFrame.Position)
    end

    -- DIBUJAR ESP ENEMIGOS
    DrawESP()
end)

-- ══════════════════════════════════════════════
-- DETECTAR CAMBIO DE PERSONAJE
-- ══════════════════════════════════════════════
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    ApplyMovementSettings()
end)

-- ══════════════════════════════════════════════
-- TECLAS RÁPIDAS GLOBALES
-- ══════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end

    -- Mostrar / Ocultar panel completo
    if Input.KeyCode == Config.ToggleUiKey then
        UiVisible = not UiVisible
        MainFrame.Visible = UiVisible
        Circle.Visible = UiVisible
    end

    -- Alternar Aimbot
    if Input.KeyCode == Config.ToggleAimbotKey then
        Config.AimEnabled = not Config.AimEnabled
    end

    -- Alternar ESP
    if Input.KeyCode == Config.ToggleEspKey then
        Config.EspEnabled = not Config.EspEnabled
    end

    -- Alternar FOV / Zoom
    if Input.KeyCode == Config.ToggleFovKey then
        Config.FovEnabled = not Config.FovEnabled
        if Config.FovEnabled then
            Camera.FieldOfView = OriginalFOV / Config.FovValue
        else
            Camera.FieldOfView = OriginalFOV
        end
    end

    -- Alternar Sin Retroceso
    if Input.KeyCode == Config.ToggleNoRecoilKey then
        Config.NoRecoilEnabled = not Config.NoRecoilEnabled
    end
end)

-- ══════════════════════════════════════════════
-- MENSAJE DE CONFIRMACIÓN
-- ══════════════════════════════════════════════
print("==========================================")
print("✅ PANEL DE ASISTENCIA CARGADO CORRECTAMENTE")
print("✅ Círculo sigue al ratón")
print("✅ Barra de desplazamiento activada")
print("✅ Todas las opciones generadas")
print("✅ Compatible con todos los juegos de Roblox")
print("==========================================")
