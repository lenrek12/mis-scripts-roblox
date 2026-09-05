-- ==============================================
-- SCRIPT DE ASISTENCIA PARA DESARROLLO (TU USO EXCLUSIVO)
-- DISEÑADO PARA MINIMIZAR DETECCIÓN Y RIESGO DE BANEO
-- ==============================================

-- ⚙️ CONFIGURACIÓN PRINCIPAL
local Config = {
    -- AIMBOT
    AimEnabled = false,
    AimPart = "Head", -- Opciones: "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"
    AimStrength = 7,   -- 1 = suave, 10 = muy pegado
    AimKey = Enum.UserInputType.MouseButton2, -- Botón derecho para apuntar

    -- CÍRCULO VISUAL
    CircleRadius = 150,
    CircleColor = Color3.fromRGB(0, 255, 0),
    CircleTransparency = 0.7,

    -- FOV (Cámara)
    FovEnabled = false,
    FovValue = 1, -- 1 = normal, 10 = muy alejada
    FovKey = Enum.KeyCode.V,

    -- NO RECOIL
    NoRecoilEnabled = false,

    -- ESP
    EspEnabled = true,
    EspColor = Color3.fromRGB(255, 0, 0),
    ShowHealth = true,
    ShowName = true,
    ShowDistance = true,

    -- VISIÓN NOCTURNA
    NightVisionEnabled = false,

    -- TECLAS DE CONTROL
    ToggleUiKey = Enum.KeyCode.Insert,
    ToggleAimKey = Enum.KeyCode.A,
    ToggleEspKey = Enum.KeyCode.E,
}

-- ESTADO INTERNO
local UiVisible = true
local OriginalFOV = 70
local OriginalBrightness = nil
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==============================================
-- INTERFAZ GRÁFICA
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevAssistantUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.02, 0)
UICorner.Parent = MainFrame

-- TÍTULO Y BOTONES DE CONTROL
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Text = "PANEL DE ASISTENCIA"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseBtn.Parent = TitleBar

-- FUNCIÓN ARRASTRAR VENTANA
local DragStart, StartPos
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        DragStart = UserInputService:GetMouseLocation()
        StartPos = MainFrame.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then DragStart = nil end end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if DragStart and i.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = UserInputService:GetMouseLocation() - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

-- MINIMIZAR / CERRAR
local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    MainFrame.Size = Minimized and UDim2.new(0, 320, 0, 35) or UDim2.new(0, 320, 0, 480)
end)
CloseBtn.MouseButton1Click:Connect(function()
    UiVisible = false
    MainFrame.Visible = false
end)

-- CONTENIDO DE PESTAÑAS
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -16, 1, -45)
ScrollContainer.Position = UDim2.new(0, 8, 0, 40)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = ScrollContainer

-- ==============================================
-- FUNCIÓN PARA CREAR ELEMENTOS DE INTERFAZ
-- ==============================================
local function CreateSection(name)
    local Section = Instance.new("TextLabel")
    Section.Text = "▶ " .. name
    Section.Font = Enum.Font.GothamBold
    Section.TextSize = 13
    Section.TextColor3 = Color3.fromRGB(80, 180, 255)
    Section.Size = UDim2.new(1, 0, 0, 24)
    Section.BackgroundTransparency = 1
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = ScrollContainer
end

local function CreateToggle(name, configKey, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 32)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Container.Parent = ScrollContainer

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Size = UDim2.new(0.75, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Parent = Container

    local Btn = Instance.new("TextButton")
    Btn.Text = Config[configKey] and "ON" or "OFF"
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0, 60, 0, 26)
    Btn.Position = UDim2.new(1, -70, 0.5, -13)
    Btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
    Btn.Parent = Container

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        Btn.Text = Config[configKey] and "ON" or "OFF"
        Btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
        if callback then callback(Config[configKey]) end
    end)
end

local function CreateSlider(name, configKey, min, max, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 46)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Container.Parent = ScrollContainer

    local Label = Instance.new("TextLabel")
    Label.Text = name .. ": " .. Config[configKey]
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 2)
    Label.Parent = Container

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, -20, 0, 8)
    SliderBg.Position = UDim2.new(0, 10, 0, 30)
    SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBg.Parent = Container

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
    Fill.Parent = SliderBg

    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local function Update(val)
        Config[configKey] = math.clamp(math.floor(val + 0.5), min, max)
        Label.Text = name .. ": " .. Config[configKey]
        Fill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0)
        if callback then callback(Config[configKey]) end
    end

    local Dragging = false
    SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = (i.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
            Update(min + pos * (max - min))
        end
    end)
end

local function CreateDropdown(name, configKey, options, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 32)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Container.Parent = ScrollContainer

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Parent = Container

    local Btn = Instance.new("TextButton")
    local currentIndex = table.find(options, Config[configKey]) or 1
    Btn.Text = options[currentIndex]
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0, 130, 0, 26)
    Btn.Position = UDim2.new(1, -140, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
    Btn.Parent = Container
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        Config[configKey] = options[currentIndex]
        Btn.Text = options[currentIndex]
        if callback then callback(options[currentIndex]) end
    end)
end

-- ==============================================
-- CREAR TODAS LAS OPCIONES EN LA INTERFAZ
-- ==============================================
task.wait(0.1)

CreateSection("🎯 AIMBOT")
CreateToggle("Activar Aimbot", "AimEnabled")
CreateDropdown("Parte del cuerpo", "AimPart", {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"})
CreateSlider("Fuerza de sujeción", "AimStrength", 1, 10)
CreateSlider("Tamaño del círculo", "CircleRadius", 50, 300)
CreateSlider("Color círculo (R)", "CircleColorR", 0, 255, function(v) Config.CircleColor = Color3.fromRGB(v, Config.CircleColor.G * 255, Config.CircleColor.B * 255) end)
CreateSlider("Color círculo (G)", "CircleColorG", 0, 255, function(v) Config.CircleColor = Color3.fromRGB(Config.CircleColor.R * 255, v, Config.CircleColor.B * 255) end)
CreateSlider("Color círculo (B)", "CircleColorB", 0, 255, function(v) Config.CircleColor = Color3.fromRGB(Config.CircleColor.R * 255, Config.CircleColor.G * 255, v) end)

CreateSection("🔭 FOV / CÁMARA")
CreateToggle("Activar Zoom / FOV", "FovEnabled", function(state)
    if state then
        OriginalFOV = Camera.FieldOfView
        Camera.FieldOfView = OriginalFOV / Config.FovValue
    else
        Camera.FieldOfView = OriginalFOV
    end
end)
CreateSlider("Acercamiento de cámara", "FovValue", 1, 10, function(val)
    if Config.FovEnabled then
        Camera.FieldOfView = OriginalFOV / val
    end
end)

CreateSection("🔫 COMBATE")
CreateToggle("Sin Retroceso", "NoRecoilEnabled")

CreateSection("👁️ ESP (VISIÓN DE JUGADORES)")
CreateToggle("Mostrar ESP", "EspEnabled")
CreateSlider("Color ESP (R)", "EspColorR", 0, 255, function(v) Config.EspColor = Color3.fromRGB(v, Config.EspColor.G * 255, Config.EspColor.B * 255) end)
CreateSlider("Color ESP (G)", "EspColorG", 0, 255, function(v) Config.EspColor = Color3.fromRGB(Config.EspColor.R * 255, v, Config.EspColor.B * 255) end)
CreateSlider("Color ESP (B)", "EspColorB", 0, 255, function(v) Config.EspColor = Color3.fromRGB(Config.EspColor.R * 255, Config.EspColor.G * 255, v) end)

CreateSection("🌙 ENTORNO")
CreateToggle("Visión Nocturna", "NightVisionEnabled", function(state)
        local Lighting = game:GetService("Lighting")
        if state then
            OriginalBrightness = Lighting.Brightness
            Lighting.Brightness = 3
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        elseif OriginalBrightness then
            Lighting.Brightness = OriginalBrightness
            Lighting.Ambient = Color3.fromRGB(60, 60, 60)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end)

CreateSection("⌘ TECLAS RÁPIDAS")
-- Teclas explicadas en pantalla
local KeyLabel = Instance.new("TextLabel")
KeyLabel.Text = "Mostrar/Ocultar Panel: INSERTAR | Aimbot: A | ESP: E | Zoom: V"
KeyLabel.Font = Enum.Font.Gotham
KeyLabel.TextSize = 11
KeyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
KeyLabel.Size = UDim2.new(1, 0, 0, 60)
KeyLabel.BackgroundTransparency = 1
KeyLabel.TextWrapped = true
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.TextYAlignment = Enum.TextYAlignment.Top
KeyLabel.Parent = ScrollContainer

-- ==============================================
-- DIBUJAR CÍRCULO DE ASISTENCIA
-- ==============================================
local Circle = Drawing.new("Circle")
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Transparency = Config.CircleTransparency
Circle.Visible = true

-- ==============================================
-- SISTEMA DE ASISTENCIA DE MIRA
-- ==============================================
local function GetClosestPlayerInCircle()
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local Radius = Config.CircleRadius
    local Closest, Dist = nil, Radius

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            local Part = Player.Character:FindFirstChild(Config.AimPart) or Player.Character.Head
            local Pos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
            if OnScreen then
                local DistFromCenter = (Vector2.new(Pos.X, Pos.Y) - Center).Magnitude
                if DistFromCenter < Dist then
                    Dist = DistFromCenter
                    Closest = Part
                end
            end
        end
    end
    return Closest
end

-- ==============================================
-- SISTEMA ESP (CAJA + VIDA + NOMBRE + DISTANCIA)
-- ==============================================
local ESP_Drawings = {}

local function UpdateESP()
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        local Char = Player.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") or not Char.Humanoid then
            if ESP_Drawings[Player] then
                for _, d in ipairs(ESP_Drawings[Player]) do d:Destroy() end
                ESP_Drawings[Player] = nil
            end
            continue
        end

        local HRP = Char.HumanoidRootPart
        local Hum = Char.Humanoid
        local Pos, OnScreen = Camera:WorldToViewportPoint(Vector3.new(HRP.Position.X, HRP.Position.Y, HRP.Position.Z))
        local Dist = (Camera.CFrame.Position - HRP.Position).Magnitude

        if not ESP_Drawings[Player] then
            ESP_Drawings[Player] = {
                Box = Drawing.new("Square"),
                Health = Drawing.new("Text"),
                Name = Drawing.new("Text"),
                DistText = Drawing.new("Text"),
            }
            for _, d in pairs(ESP_Drawings[Player]) do
                d.Center = true
            end
            ESP_Drawings[Player].Box.Thickness = 2
            ESP_Drawings[Player].Health.Size = 11
            ESP_Drawings[Player].Name.Size = 11
            ESP_Drawings[Player].DistText.Size = 10
        end

        local D = ESP_Drawings[Player]
        local Height = (Camera:WorldToViewportPoint(Vector3.new(HRP.Position.X, HRP.Position.Y + 2.5, HRP.Position.Z)) - Camera:WorldToViewportPoint(Vector3.new(HRP.Position.X, HRP.Position.Y - 1, HRP.Position.Z))).Y
        local Width = Height * 0.5

        local Visible = Config.EspEnabled and OnScreen and Hum.Health > 0
        D.Box.Visible = Visible
        D.Health.Visible = Visible
        D.Name.Visible = Visible
        D.DistText.Visible = Visible

        if Visible then
            D.Box.Color = Config.EspColor
            D.Box.Position = Vector2.new(Pos.X - Width/2, Pos.Y - Height/2)
            D.Box.Size = Vector2.new(Width, Height)

            D.Name.Text = Player.Name
            D.Name.Position = Vector2.new(Pos.X, Pos.Y - Height/2 - 14)
            D.Name.Color = Config.EspColor

            D.Health.Text = "❤ " .. math.floor(Hum.Health)
            D.Health.Position = Vector2.new(Pos.X, Pos.Y + Height/2 + 2)
            D.Health.Color = Color3.fromRGB(255, math.floor(255 * Hum.Health / Hum.MaxHealth), 40)

            D.DistText.Text = math.floor(Dist) .. "m"
            D.DistText.Position = Vector2.new(Pos.X + Width/2 + 6, Pos.Y)
            D.DistText.Color = Config.EspColor
        end
    end
end

-- ==============================================
-- BUCLE PRINCIPAL DE RENDERING
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- Actualizar círculo
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Circle.Radius = Config.CircleRadius
    Circle.Color = Config.CircleColor
    Circle.Visible = true

    -- Asistencia de mira
    if Config.AimEnabled and UserInputService:IsMouseButtonDown(Config.AimKey) then
        local Target = GetClosestPlayerInCircle()
        if Target then
            local CF = CFrame.new(Camera.CFrame.Position, Target.Position)
            local Strength = Config.AimStrength / 10
            Camera.CFrame = Camera.CFrame:Lerp(CF, Strength)
        end
    end

    -- Sin retroceso
    if Config.NoRecoilEnabled then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, (Camera.CFrame * CFrame.Angles(math.rad(Mouse.Origin.Y), 0, 0)).Position)
    end

    -- ESP
    UpdateESP()
end)

-- ==============================================
-- TECLAS RÁPIDAS
-- ==============================================
UserInputService.InputBegan:Connect(function(Input, Gpe)
    if Gpe then return end

    -- Mostrar/Ocultar panel
    if Input.KeyCode == Enum.KeyCode.Insert then
        UiVisible = not UiVisible
        MainFrame.Visible = UiVisible
    end

    -- Alternar Aimbot
    if Input.KeyCode == Enum.KeyCode.A then
        Config.AimEnabled = not Config.AimEnabled
    end

    -- Alternar ESP
    if Input.KeyCode == Enum.KeyCode.E then
        Config.EspEnabled = not Config.EspEnabled
    end

    -- Alternar FOV
    if Input.KeyCode == Enum.KeyCode.V then
        Config.FovEnabled = not Config.FovEnabled
        if Config.FovEnabled then
            OriginalFOV = Camera.FieldOfView
            Camera.FieldOfView = OriginalFOV / Config.FovValue
        else
            Camera.FieldOfView = OriginalFOV
        end
    end
end)

print("✅ SCRIPT CARGADO CORRECTAMENTE")
