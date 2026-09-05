-- ==============================================
-- PANEL DE ASISTENCIA — VERSIÓN A PRUEBA DE FALLOS
-- TODOS LOS BOTONES CREADOS A MANO, SIN FUNCIONES
-- ==============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- VALORES
local UiVisible = true
local AimEnabled = false
local AimStrength = 5
local CircleRadius = 150
local FovEnabled = false
local FovValue = 1
local NoRecoilEnabled = false
local EspEnabled = true
local NightVision = false
local OriginalFOV = Camera.FieldOfView
local OriginalBrightness = Lighting.Brightness

-- CÍRCULO QUE SIGE AL RATÓN
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Transparency = 0.7
Circle.Radius = CircleRadius
Circle.Color = Color3.fromRGB(0, 255, 0)

-- ACTUALIZAR CÍRCULO
local function UpdateCircle()
    local Pos = UserInputService:GetMouseLocation()
    Circle.Position = Vector2.new(Pos.X, Pos.Y)
    Circle.Visible = UiVisible
end

-- ==============================================
-- CREAR INTERFAZ
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- MARCO PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 480)
MainFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.02, 0)

-- BARRA SUPERIOR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Text = "PANEL DE ASISTENCIA"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Parent = TitleBar

-- CONTENEDOR DESPLAZABLE
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 42)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Scroll

-- ==============================================
-- BOTONES CREADOS UNO POR UNO — SIN FUNCIONES
-- ==============================================

-- BOTÓN AIMBOT
local BtnAim = Instance.new("TextButton")
BtnAim.Name = "BtnAim"
BtnAim.Text = "ACTIVAR AIMBOT: OFF"
BtnAim.Font = Enum.Font.Gotham
BtnAim.TextSize = 12
BtnAim.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAim.Size = UDim2.new(0.92, 0, 0, 40)
BtnAim.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
BtnAim.Parent = Scroll
Instance.new("UICorner", BtnAim).CornerRadius = UDim.new(0, 6)

BtnAim.MouseButton1Click:Connect(function()
    AimEnabled = not AimEnabled
    BtnAim.Text = AimEnabled and "ACTIVAR AIMBOT: ON" or "ACTIVAR AIMBOT: OFF"
    BtnAim.BackgroundColor3 = AimEnabled and Color3.fromRGB(40, 150, 60) or Color3.fromRGB(150, 40, 40)
end)

-- BOTÓN SIN RETROCESO
local BtnRecoil = Instance.new("TextButton")
BtnRecoil.Name = "BtnRecoil"
BtnRecoil.Text = "SIN RETROCESO: OFF"
BtnRecoil.Font = Enum.Font.Gotham
BtnRecoil.TextSize = 12
BtnRecoil.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnRecoil.Size = UDim2.new(0.92, 0, 0, 40)
BtnRecoil.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
BtnRecoil.Parent = Scroll
Instance.new("UICorner", BtnRecoil).CornerRadius = UDim.new(0, 6)

BtnRecoil.MouseButton1Click:Connect(function()
    NoRecoilEnabled = not NoRecoilEnabled
    BtnRecoil.Text = NoRecoilEnabled and "SIN RETROCESO: ON" or "SIN RETROCESO: OFF"
    BtnRecoil.BackgroundColor3 = NoRecoilEnabled and Color3.fromRGB(40, 150, 60) or Color3.fromRGB(150, 40, 40)
end)

-- BOTÓN ESP
local BtnEsp = Instance.new("TextButton")
BtnEsp.Name = "BtnEsp"
BtnEsp.Text = "VER JUGADORES: ON"
BtnEsp.Font = Enum.Font.Gotham
BtnEsp.TextSize = 12
BtnEsp.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnEsp.Size = UDim2.new(0.92, 0, 0, 40)
BtnEsp.BackgroundColor3 = Color3.fromRGB(40, 150, 60)
BtnEsp.Parent = Scroll
Instance.new("UICorner", BtnEsp).CornerRadius = UDim.new(0, 6)

BtnEsp.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    BtnEsp.Text = EspEnabled and "VER JUGADORES: ON" or "VER JUGADORES: OFF"
    BtnEsp.BackgroundColor3 = EspEnabled and Color3.fromRGB(40, 150, 60) or Color3.fromRGB(150, 40, 40)
end)

-- BOTÓN ZOOM
local BtnZoom = Instance.new("TextButton")
BtnZoom.Name = "BtnZoom"
BtnZoom.Text = "ACTIVAR ZOOM: OFF"
BtnZoom.Font = Enum.Font.Gotham
BtnZoom.TextSize = 12
BtnZoom.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnZoom.Size = UDim2.new(0.92, 0, 0, 40)
BtnZoom.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
BtnZoom.Parent = Scroll
Instance.new("UICorner", BtnZoom).CornerRadius = UDim.new(0, 6)

BtnZoom.MouseButton1Click:Connect(function()
    FovEnabled = not FovEnabled
    BtnZoom.Text = FovEnabled and "ACTIVAR ZOOM: ON" or "ACTIVAR ZOOM: OFF"
    BtnZoom.BackgroundColor3 = FovEnabled and Color3.fromRGB(40, 150, 60) or Color3.fromRGB(150, 40, 40)
    Camera.FieldOfView = FovEnabled and OriginalFOV / 2 or OriginalFOV
end)

-- BOTÓN VISIÓN NOCTURNA
local BtnNight = Instance.new("TextButton")
BtnNight.Name = "BtnNight"
BtnNight.Text = "VISIÓN NOCTURNA: OFF"
BtnNight.Font = Enum.Font.Gotham
BtnNight.TextSize = 12
BtnNight.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnNight.Size = UDim2.new(0.92, 0, 0, 40)
BtnNight.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
BtnNight.Parent = Scroll
Instance.new("UICorner", BtnNight).CornerRadius = UDim.new(0, 6)

BtnNight.MouseButton1Click:Connect(function()
    NightVision = not NightVision
    BtnNight.Text = NightVision and "VISIÓN NOCTURNA: ON" or "VISIÓN NOCTURNA: OFF"
    BtnNight.BackgroundColor3 = NightVision and Color3.fromRGB(40, 150, 60) or Color3.fromRGB(150, 40, 40)
    if NightVision then
        Lighting.Brightness = 3.5
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    else
        Lighting.Brightness = OriginalBrightness
        Lighting.Ambient = Color3.fromRGB(67, 84, 104)
    end
end)

-- TEXTO DE TECLAS
local Info = Instance.new("TextLabel")
Info.Text = "TECLAS:\nINSERT → Mostrar/Ocultar\nBotón DERECHO → Apuntar"
Info.Font = Enum.Font.Gotham
Info.TextSize = 11
Info.TextColor3 = Color3.fromRGB(180, 180, 180)
Info.Size = UDim2.new(0.92, 0, 0, 60)
Info.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Info.TextWrapped = true
Info.Parent = Scroll
Instance.new("UICorner", Info).CornerRadius = UDim.new(0, 6)

-- ==============================================
-- SISTEMA DE APUNTADO
-- ==============================================
local function GetTarget()
    local MousePos = UserInputService:GetMouseLocation()
    local Best, MinD = nil, CircleRadius
    for _, P in ipairs(Players:GetPlayers()) do
        if P ~= LocalPlayer and P.Character and P.Character:FindFirstChild("HumanoidRootPart") and P.Character.Humanoid.Health > 0 then
            local Part = P.Character.Head
            local Pos, Ok = Camera:WorldToViewportPoint(Part.Position)
            if Ok then
                local D = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(MousePos.X, MousePos.Y)).Magnitude
                if D < MinD then MinD = D; Best = Part end
            end
        end
    end
    return Best
end

-- ESP
local ESP = {}

-- ==============================================
-- BUCLE PRINCIPAL
-- ==============================================
RunService.RenderStepped:Connect(function()
    UpdateCircle()

    -- AIMBOT
    if AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local T = GetTarget()
        if T then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Position), AimStrength / 10)
        end
    end

    -- SIN RETROCESO
    if NoRecoilEnabled then
        Mouse.Origin = CFrame.new(Camera.CFrame.Position)
    end

    -- DIBUJAR JUGADORES
    for _, P in ipairs(Players:GetPlayers()) do
        if P == LocalPlayer then
            if ESP[P] then for _, d in ipairs(ESP[P]) do d.Visible = false end end
            continue
        end
        local C = P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") or not C.Humanoid then
            if ESP[P] then for _, d in ipairs(ESP[P]) do d.Visible = false end end
            continue
        end
        local R = C.HumanoidRootPart
        local H = C.Humanoid
        local Pos, Ok = Camera:WorldToViewportPoint(R.Position)
        if not ESP[P] then
            ESP[P] = { Box = Drawing.new("Square"), Txt = Drawing.new("Text") }
            ESP[P].Box.Thickness = 2
            ESP[P].Txt.Size = 11
        end
        local D = ESP[P]
        local Ht = (Camera:WorldToViewportPoint(Vector3.new(0, 2.5, 0) + R.Position) - Camera:WorldToViewportPoint(Vector3.new(0, -0.5, 0) + R.Position)).Y
        local W = Ht * 0.4
        local Show = EspEnabled and Ok and H.Health > 0 and UiVisible
        D.Box.Visible = Show
        D.Txt.Visible = Show
        if Show then
            D.Box.Color = Color3.fromRGB(255, 0, 0)
            D.Box.Position = Vector2.new(Pos.X - W/2, Pos.Y - Ht/2)
            D.Box.Size = Vector2.new(W, Ht)
            D.Txt.Text = P.Name .. " | " .. math.floor(H.Health) .. "HP"
            D.Txt.Color = Color3.fromRGB(255, 0, 0)
            D.Txt.Center = true
            D.Txt.Position = Vector2.new(Pos.X, Pos.Y - Ht/2 - 14)
        end
    end
end)

-- TECLA INSERT PARA MOSTRAR/OCULTAR
UserInputService.InputBegan:Connect(function(I, Proc)
    if Proc then return end
    if I.KeyCode == Enum.KeyCode.Insert then
        UiVisible = not UiVisible
        MainFrame.Visible = UiVisible
        Circle.Visible = UiVisible
    end
end)

print("✅ SCRIPT CARGADO — BOTONES VISIBLES")
print("✅ Si no ves los botones, baja con la barra")
