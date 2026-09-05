-- ==============================================
-- CÍRCULO SIGA AL CURSOR + TODAS LAS OPCIONES VISIBLES
-- ==============================================

-- ⚙️ CONFIGURACIÓN
local Config = {
    AimEnabled = false,
    AimPart = "Head",
    AimStrength = 5,
    CircleRadius = 160,
    CircleColor = Color3.fromRGB(0, 255, 0),
    FovEnabled = false,
    FovValue = 1,
    NoRecoilEnabled = false,
    EspEnabled = true,
    EspColor = Color3.fromRGB(255, 0, 0),
    NightVisionEnabled = false,
}

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local OriginalFOV = Camera.FieldOfView
local OriginalBrightness = Lighting.Brightness
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local UiVisible = true

-- ==============================================
-- CÍRCULO — SIGUE AL CURSOR DEL RATÓN
-- ==============================================
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Transparency = 0.7
Circle.Radius = Config.CircleRadius
Circle.Color = Config.CircleColor

-- ACTUALIZAR POSICIÓN DEL CÍRCULO = POSICIÓN DEL RATÓN
local function UpdateCircle()
    local MousePos = UserInputService:GetMouseLocation()
    Circle.Position = Vector2.new(MousePos.X, MousePos.Y)
end

-- ==============================================
-- INTERFAZ GRÁFICA
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AssistPanel"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.02, 0)

-- BARRA SUPERIOR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Text = "PANEL DE ASISTENCIA"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Size = UDim2.new(0, 36, 0, 32)
MinBtn.Position = UDim2.new(1, -76, 0.5, -16)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Size = UDim2.new(0, 36, 0, 32)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- ARRASTRAR VENTANA
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
    if Minimized then
        MainFrame.Size = UDim2.new(0, 320, 0, 40)
        ScrollContainer.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 320, 0, 500)
        ScrollContainer.Visible = true
    end
end)
CloseBtn.MouseButton1Click:Connect(function()
    UiVisible = false
    MainFrame.Visible = false
    Circle.Visible = false
end)

-- CONTENEDOR DESPLAZABLE
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Size = UDim2.new(1, -10, 1, -45)
ScrollContainer.Position = UDim2.new(0, 5, 0, 42)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.ScrollBarThickness = 6
ScrollContainer.ScrollBarColor3 = Color3.fromRGB(100, 100, 100)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 1100)
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollContainer.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = ScrollContainer

-- ==============================================
-- FUNCIONES PARA CREAR ELEMENTOS
-- ==============================================
local function AddSpacer()
    local S = Instance.new("Frame")
    S.Size = UDim2.new(1, 0, 0, 4)
    S.BackgroundTransparency = 1
    S.Parent = ScrollContainer
end

local function CreateSection(title)
    AddSpacer()
    local Sec = Instance.new("TextLabel")
    Sec.Text = "▸ " .. title .. " ◂"
    Sec.Font = Enum.Font.GothamBold
    Sec.TextSize = 14
    Sec.TextColor3 = Color3.fromRGB(100, 200, 255)
    Sec.Size = UDim2.new(0.95, 0, 0, 26)
    Sec.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Sec.Parent = ScrollContainer
    Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 6)
end

local function CreateToggle(name, configKey, callback)
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.95, 0, 0, 36)
    Cont.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Cont.Parent = ScrollContainer
    Instance.new("UICorner", Cont).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = name
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    Lbl.Size = UDim2.new(0.65, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Cont

    local Btn = Instance.new("TextButton")
    Btn.Name = "ToggleBtn_" .. configKey
    Btn.Text = Config[configKey] and "ON" or "OFF"
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0, 70, 0, 26)
    Btn.Position = UDim2.new(1, -82, 0.5, -13)
    Btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
    Btn.Parent = Cont
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        Btn.Text = Config[configKey] and "ON" or "OFF"
        Btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
        if callback then callback(Config[configKey]) end
    end)
end

local function CreateSlider(name, configKey, min, max, callback)
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.95, 0, 0, 50)
    Cont.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Cont.Parent = ScrollContainer
    Instance.new("UICorner", Cont).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = name .. ": " .. Config[configKey]
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    Lbl.Size = UDim2.new(1, -16, 0, 20)
    Lbl.Position = UDim2.new(0, 8, 0, 4)
    Lbl.BackgroundTransparency = 1
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Cont

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, -16, 0, 12)
    Bg.Position = UDim2.new(0, 8, 0, 32)
    Bg.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Bg.Parent = Cont
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
    Fill.Parent = Bg
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local function Update(val)
        Config[configKey] = math.clamp(math.floor(val + 0.5), min, max)
        Lbl.Text = name .. ": " .. Config[configKey]
        Fill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0)
        if callback then callback(Config[configKey]) end
    end

    local Dragging = false
    Bg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = (i.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X
            Update(min + p * (max - min))
        end
    end)
end

local function CreateDropdown(name, configKey, options)
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.95, 0, 0, 36)
    Cont.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Cont.Parent = ScrollContainer
    Instance.new("UICorner", Cont).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = name
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    Lbl.Size = UDim2.new(0.55, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Cont

    local Btn = Instance.new("TextButton")
    local idx = table.find(options, Config[configKey]) or 1
    Btn.Text = options[idx]
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0, 110, 0, 26)
    Btn.Position = UDim2.new(1, -122, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 90, 130)
    Btn.Parent = Cont
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        Config[configKey] = options[idx]
        Btn.Text = options[idx]
    end)
end

-- ==============================================
-- GENERAR TODAS LAS OPCIONES
-- ==============================================
task.wait(0.2)

-- 🎯 AIMBOT
CreateSection("🎯 AIMBOT")
CreateToggle("Activar Aimbot", "AimEnabled")
CreateDropdown("Apuntar a", "AimPart", {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"})
CreateSlider("Fuerza de sujeción", "AimStrength", 1, 10)
CreateSlider("Tamaño del círculo", "CircleRadius", 50, 300)

-- 🔭 FOV / CÁMARA
CreateSection("🔭 FOV / CÁMARA")
CreateToggle("Activar Zoom", "FovEnabled", function(state)
    if state then Camera.FieldOfView = OriginalFOV / Config.FovValue
    else Camera.FieldOfView = OriginalFOV end
end)
CreateSlider("Acercamiento", "FovValue", 1, 10, function(val)
    if Config.FovEnabled then Camera.FieldOfView = OriginalFOV / val end
end)

-- 🔫 COMBATE
CreateSection("🔫 COMBATE")
CreateToggle("Sin Retroceso", "NoRecoilEnabled")

-- 👁️ ESP
CreateSection("👁️ ESP - VISIÓN DE JUGADORES")
CreateToggle("Mostrar ESP", "EspEnabled")

-- 🌙 ENTORNO
CreateSection("🌙 ENTORNO")
CreateToggle("Visión Nocturna", "NightVisionEnabled", function(state)
    if state then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    else
        Lighting.Brightness = OriginalBrightness
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient
    end
end)

-- ⌘ TECLAS
CreateSection("⌘ TECLAS RÁPIDAS")
local KeyInfo = Instance.new("TextLabel")
KeyInfo.Text = "INSERT → Mostrar/Ocultar Panel\nA → Aimbot ON/OFF | E → ESP ON/OFF | V → Zoom ON/OFF\nBotón DERECHO → Apuntar"
KeyInfo.Font = Enum.Font.Gotham
KeyInfo.TextSize = 11
KeyInfo.TextColor3 = Color3.fromRGB(160, 160, 160)
KeyInfo.Size = UDim2.new(0.95, 0, 0, 65)
KeyInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInfo.TextXAlignment = Enum.TextXAlignment.Left
KeyInfo.TextYAlignment = Enum.TextYAlignment.Top
KeyInfo.TextWrapped = true
KeyInfo.Parent = ScrollContainer
Instance.new("UICorner", KeyInfo).CornerRadius = UDim.new(0, 6)

-- ==============================================
-- SISTEMA DE APUNTADO — DESDE EL CÍRCULO (CURSOR)
-- ==============================================
local function GetClosestTarget()
    -- EL CÍRCULO ESTÁ EN EL CURSOR → BUSCA EN TORNO A LA POSICIÓN DEL RATÓN
    local MousePos = UserInputService:GetMouseLocation()
    local Center = Vector2.new(MousePos.X, MousePos.Y)
    local BestTarget, MinDistance = nil, Config.CircleRadius

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") then
            local Humanoid = Player.Character.Humanoid
            if Humanoid.Health > 0 then
                local AimPart = Player.Character:FindFirstChild(Config.AimPart) or Player.Character.Head
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(AimPart.Position)
                if OnScreen then
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Center).Magnitude
                    if Distance < MinDistance then
                        MinDistance = Distance
                        BestTarget = AimPart
                    end
                end
            end
        end
    end
    return BestTarget
end

-- ==============================================
-- SISTEMA ESP
-- ==============================================
local ESP_Drawings = {}

-- ==============================================
-- BUCLE PRINCIPAL
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- ✅ EL CÍRCULO SIGUE AL RATÓN
    UpdateCircle()
    Circle.Radius = Config.CircleRadius
    Circle.Visible = UiVisible

    -- ✅ ASISTENCIA DE MIRA DESDE EL CURSOR
    if Config.AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local Target = GetClosestTarget()
        if Target then
            local AimSmoothness = Config.AimStrength / 10
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Position), AimSmoothness)
        end
    end

    -- SIN RETROCESO
    if Config.NoRecoilEnabled then
        Mouse.Origin = CFrame.new(Camera.CFrame.Position)
    end

    -- DIBUJAR ESP
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player == LocalPlayer then
            if ESP_Drawings[Player] then
                for _, DrawingObj in ipairs(ESP_Drawings[Player]) do DrawingObj.Visible = false end
            end
            continue
        end

        local Character = Player.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") or not Character:FindFirstChild("Humanoid") then
            if ESP_Drawings[Player] then
                for _, DrawingObj in ipairs(ESP_Drawings[Player]) do DrawingObj.Visible = false end
            end
            continue
        end

        local RootPart = Character.HumanoidRootPart
        local Humanoid = Character.Humanoid
        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
        local Distance = math.floor((Camera.CFrame.Position - RootPart.Position).Magnitude)

        if not ESP_Drawings[Player] then
            ESP_Drawings[Player] = {
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                Health = Drawing.new("Text"),
                Distance = Drawing.new("Text"),
            }
            for _, D in ipairs(ESP_Drawings[Player]) do
                D.Center = true
            end
            ESP_Drawings[Player].Box.Thickness = 2
            ESP_Drawings[Player].Name.Size = 11
            ESP_Drawings[Player].Health.Size = 11
            ESP_Drawings[Player].Distance.Size = 10
        end

        local D = ESP_Drawings[Player]
        local BoxHeight = (Camera:WorldToViewportPoint(Vector3.new(0, 2.6, 0) + RootPart.Position) - Camera:WorldToViewportPoint(Vector3.new(0, -0.8, 0) + RootPart.Position)).Y
        local BoxWidth = BoxHeight * 0.45

        local ShouldShow = Config.EspEnabled and OnScreen and Humanoid.Health > 0 and UiVisible
        D.Box.Visible = ShouldShow
        D.Name.Visible = ShouldShow
        D.Health.Visible = ShouldShow
        D.Distance.Visible = ShouldShow

        if ShouldShow then
            D.Box.Color = Config.EspColor
            D.Box.Position = Vector2.new(ScreenPos.X - BoxWidth/2, ScreenPos.Y - BoxHeight/2)
            D.Box.Size = Vector2.new(BoxWidth, BoxHeight)

            D.Name.Text = Player.Name
            D.Name.Color = Config.EspColor
            D.Name.Position = Vector2.new(ScreenPos.X, ScreenPos.Y - BoxHeight/2 - 14)

            D.Health.Text = "❤ " .. math.floor(Humanoid.Health)
            D.Health.Color = Color3.fromRGB(255, math.floor(255 * (Humanoid.Health / Humanoid.MaxHealth)), 40)
            D.Health.Position = Vector2.new(ScreenPos.X, ScreenPos.Y + BoxHeight/2 + 4)

            D.Distance.Text = Distance .. " m"
            D.Distance.Color = Config.EspColor
            D.Distance.Position = Vector2.new(ScreenPos.X + BoxWidth/2 + 8, ScreenPos.Y)
        end
    end
end)

-- ==============================================
-- TECLAS RÁPIDAS
-- ==============================================
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end

    -- Mostrar/Ocultar panel
    if Input.KeyCode == Enum.KeyCode.Insert then
        UiVisible = not UiVisible
        MainFrame.Visible = UiVisible
        Circle.Visible = UiVisible
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
            Camera.FieldOfView = OriginalFOV / Config.FovValue
        else
            Camera.FieldOfView = OriginalFOV
        end
    end
end)

print("✅ SCRIPT CARGADO — CÍRCULO SIGA AL CURSOR + TODAS LAS OPCIONES")
