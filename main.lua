-- ==============================================
-- PANEL DE ASISTENCIA - VERSIÓN CORREGIDA
-- Orden completo + Círculo visible + Todas las secciones
-- ==============================================

-- ⚙️ CONFIGURACIÓN INICIAL
local Config = {
    -- AIMBOT
    AimEnabled = false,
    AimPart = "Head",
    AimStrength = 4,
    CircleRadius = 150,
    CircleColor = Color3.fromRGB(0, 255, 0),
    CircleTransparency = 0.7,

    -- FOV / CÁMARA
    FovEnabled = false,
    FovValue = 1,

    -- COMBATE
    NoRecoilEnabled = false,

    -- ESP
    EspEnabled = true,
    EspColor = Color3.fromRGB(255, 0, 0),

    -- VISIÓN NOCTURNA
    NightVisionEnabled = false,

    -- TECLAS
    ToggleUiKey = Enum.KeyCode.Insert,
    AimKey = Enum.UserInputType.MouseButton2,
}

-- SERVICIOS Y VARIABLES GLOBALES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local OriginalFOV = Camera.FieldOfView
local OriginalLighting = {Brightness=game:GetService("Lighting").Brightness, Ambient=game:GetService("Lighting").Ambient, OutdoorAmbient=game:GetService("Lighting").OutdoorAmbient}
local UiVisible = true

-- ==============================================
-- CREAR CÍRCULO DE MIRA (VISIBLE DESDE EL INICIO)
-- ==============================================
local Circle = Drawing.new("Circle")
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Transparency = Config.CircleTransparency
Circle.Visible = true
Circle.Radius = Config.CircleRadius

-- ==============================================
-- INTERFAZ GRÁFICA
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevAssistantUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 520)
MainFrame.Position = UDim2.new(0.02, 0, 0.08, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.02, 0)

-- BARRA DE TÍTULO Y BOTONES
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Text = "PANEL DE ASISTENCIA"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Size = UDim2.new(0, 32, 1, 0)
MinBtn.Position = UDim2.new(1, -64, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Size = UDim2.new(0, 32, 1, 0)
CloseBtn.Position = UDim2.new(1, -32, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
    MainFrame.Size = Minimized and UDim2.new(0, 340, 0, 38) or UDim2.new(0, 340, 0, 520)
    ScrollContainer.Visible = not Minimized
end)
CloseBtn.MouseButton1Click:Connect(function()
    UiVisible = false
    MainFrame.Visible = false
    Circle.Visible = false
end)

-- CONTENEDOR DESPLAZABLE
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -16, 1, -45)
ScrollContainer.Position = UDim2.new(0, 8, 0, 40)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.ScrollBarThickness = 5
ScrollContainer.ScrollBarColor3 = Color3.fromRGB(80, 80, 80)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 950)
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollContainer.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.Parent = ScrollContainer

-- ==============================================
-- FUNCIONES PARA CREAR ELEMENTOS
-- ==============================================
local function CreateSection(name)
    local Sec = Instance.new("TextLabel")
    Sec.Text = "═ " .. name .. " ═"
    Sec.Font = Enum.Font.GothamBold
    Sec.TextSize = 13
    Sec.TextColor3 = Color3.fromRGB(80, 180, 255)
    Sec.Size = UDim2.new(1, 0, 0, 28)
    Sec.BackgroundTransparency = 1
    Sec.TextXAlignment = Enum.TextXAlignment.Center
    Sec.Parent = ScrollContainer
end

local function CreateToggle(name, configKey, callback)
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(1, 0, 0, 34)
    Cont.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Cont.Parent = ScrollContainer

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = name
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    Lbl.Size = UDim2.new(0.65, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Cont

    local Btn = Instance.new("TextButton")
    Btn.Text = Config[configKey] and "ACTIVO" or "INACTIVO"
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0, 90, 0, 26)
    Btn.Position = UDim2.new(1, -102, 0.5, -13)
    Btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
    Btn.Parent = Cont
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        Btn.Text = Config[configKey] and "ACTIVO" or "INACTIVO"
        Btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
        if callback then callback(Config[configKey]) end
    end)
end

local function CreateSlider(name, configKey, min, max, callback)
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(1, 0, 0, 48)
    Cont.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Cont.Parent = ScrollContainer

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = name .. ": " .. Config[configKey]
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    Lbl.Size = UDim2.new(1, -12, 0, 20)
    Lbl.Position = UDim2.new(0, 12, 0, 4)
    Lbl.BackgroundTransparency = 1
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Cont

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, -24, 0, 10)
    Bg.Position = UDim2.new(0, 12, 0, 32)
    Bg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Bg.Parent = Cont
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Config[configKey]-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
    Fill.Parent = Bg
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local function Update(val)
        Config[configKey] = math.clamp(math.floor(val+0.5), min, max)
        Lbl.Text = name .. ": " .. Config[configKey]
        Fill.Size = UDim2.new((Config[configKey]-min)/(max-min), 0, 1, 0)
        if callback then callback(Config[configKey]) end
    end

    local Dragging = false
    Bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = (i.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X
            Update(min + p * (max-min))
        end
    end)
end

local function CreateDropdown(name, configKey, options)
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(1, 0, 0, 34)
    Cont.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Cont.Parent = ScrollContainer

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = name
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
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
    Btn.Size = UDim2.new(0, 130, 0, 26)
    Btn.Position = UDim2.new(1, -142, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
    Btn.Parent = Cont
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        Config[configKey] = options[idx]
        Btn.Text = options[idx]
    end)
end

-- ==============================================
-- CREAR TODAS LAS SECCIONES EN ORDEN
-- ==============================================
task.wait(0.1)

-- 🎯 AIMBOT
CreateSection("🎯 AIMBOT")
CreateToggle("Activar Aimbot", "AimEnabled")
CreateDropdown("Parte del cuerpo", "AimPart", {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"})
CreateSlider("Fuerza de sujeción", "AimStrength", 1, 10)
CreateSlider("Tamaño del círculo", "CircleRadius", 50, 300)

-- 🔭 FOV / CÁMARA
CreateSection("🔭 FOV / CÁMARA")
CreateToggle("Activar Zoom / FOV", "FovEnabled", function(state)
    if state then Camera.FieldOfView = OriginalFOV / Config.FovValue
    else Camera.FieldOfView = OriginalFOV end
end)
CreateSlider("Acercamiento de cámara", "FovValue", 1, 10, function(val)
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
    local L = game:GetService("Lighting")
    if state then
        L.Brightness = 3
        L.Ambient = Color3.fromRGB(200, 200, 200)
        L.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    else
        L.Brightness = OriginalLighting.Brightness
        L.Ambient = OriginalLighting.Ambient
        L.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    end
end)

-- ⌘ TECLAS RÁPIDAS
CreateSection("⌘ TECLAS RÁPIDAS")
local KeyInfo = Instance.new("TextLabel")
KeyInfo.Text = "INSERT → Mostrar/Ocultar Panel\nA → Activar Aimbot | E → Alternar ESP | V → Alternar Zoom\nBotón Derecho → Apuntar"
KeyInfo.Font = Enum.Font.Gotham
KeyInfo.TextSize = 11
KeyInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
KeyInfo.Size = UDim2.new(1, -24, 0, 60)
KeyInfo.Position = UDim2.new(0, 12, 0, 0)
KeyInfo.BackgroundTransparency = 1
KeyInfo.TextXAlignment = Enum.TextXAlignment.Left
KeyInfo.TextYAlignment = Enum.TextYAlignment.Top
KeyInfo.TextWrapped = true
KeyInfo.Parent = ScrollContainer

-- ==============================================
-- SISTEMA DE ASISTENCIA DE MIRA
-- ==============================================
local function GetClosestTarget()
    local Center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local Best, MinDist = nil, Config.CircleRadius
    for _, P in ipairs(Players:GetPlayers()) do
        if P~=LocalPlayer and P.Character and P.Character:FindFirstChild("HumanoidRootPart") and P.Character:FindFirstChild("Humanoid") and P.Character.Humanoid.Health>0 then
            local Part = P.Character:FindFirstChild(Config.AimPart) or P.Character.Head
            local Pos, OnScr = Camera:WorldToViewportPoint(Part.Position)
            if OnScr then
                local D = (Vector2.new(Pos.X, Pos.Y)-Center).Magnitude
                if D<MinDist then MinDist=D; Best=Part end
            end
        end
    end
    return Best
end

-- ==============================================
-- SISTEMA ESP
-- ==============================================
local ESP = {}
RunService.RenderStepped:Connect(function()
    -- Actualizar círculo
    Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    Circle.Radius = Config.CircleRadius
    Circle.Color = Config.CircleColor
    Circle.Visible = UiVisible

    -- Aimbot
    if Config.AimEnabled and UserInputService:IsMouseButtonDown(Config.AimKey) then
        local T = GetClosestTarget()
        if T then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Position), Config.AimStrength/10) end
    end

    -- Sin retroceso
    if Config.NoRecoilEnabled then Mouse.Origin = CFrame.new(Camera.CFrame.Position) end

    -- ESP
    for _,P in ipairs(Players:GetPlayers()) do
        if P==LocalPlayer then if ESP[P] then for _,d in ipairs(ESP[P]) do d.Visible=false end end continue end
        local C=P.Character; if not C or not C:FindFirstChild("HumanoidRootPart") or not C.Humanoid then if ESP[P] then for _,d in ipairs(ESP[P]) do d.Visible=false end end continue end
        local RP=C.HumanoidRootPart; local H=C.Humanoid
        local Pos,OnScr=Camera:WorldToViewportPoint(RP.Position)
        local Dist=(Camera.CFrame.Position-RP.Position).Magnitude
        if not ESP[P] then ESP[P]={Box=Drawing.new("Square"),Name=Drawing.new("Text"),Health=Drawing.new("Text"),Dist=Drawing.new("Text")} end
        local E=ESP[P]
        local Ht=(Camera:WorldToViewportPoint(Vector3.new(0,2.5,0)+RP.Position)-Camera:WorldToViewportPoint(Vector3.new(0,-1,0)+RP.Position)).Y
        local Wd=Ht*0.5
        local V=Config.EspEnabled and OnScr and H.Health>0 and UiVisible
        E.Box.Visible=V; E.Name.Visible=V; E.Health.Visible=V; E.Dist.Visible=V
        if V then
            E.Box.Color=Config.EspColor; E.Box.Thickness=2
            E.Box.Position=Vector2.new(Pos.X-Wd/2,Pos.Y-Ht/2); E.Box.Size=Vector2.new(Wd,Ht)
            E.Name.Text=P.Name; E.Name.Color=Config.EspColor; E.Name.Size=11; E.Name.Center=true; E.Name.Position=Vector2.new(Pos.X,Pos.Y-Ht/2-14)
            E.Health.Text="❤"..math.floor(H.Health); E.Health.Size=11; E.Health.Center=true; E.Health.Position=Vector2.new(Pos.X,Pos.Y+Ht/2+2)
            E.Health.Color=Color3.fromRGB(255,math.floor(255*(H.Health/H.MaxHealth)),40)
            E.Dist.Text=math.floor(Dist).."m"; E.Dist.Color=Config.EspColor; E.Dist.Size=10; E.Dist.Center=true; E.Dist.Position=Vector2.new(Pos.X+Wd/2+8,Pos.Y)
        end
    end
end)

-- ==============================================
-- TECLAS RÁPIDAS
-- ==============================================
UserInputService.InputBegan:Connect(function(I,G)
    if G then return end
    if I.KeyCode==Enum.KeyCode.Insert then
        UiVisible=not UiVisible; MainFrame.Visible=UiVisible; Circle.Visible=UiVisible
    end
    if I.KeyCode==Enum.KeyCode.A then Config.AimEnabled=not Config.AimEnabled end
    if I.KeyCode==Enum.KeyCode.E then Config.EspEnabled=not Config.EspEnabled end
    if I.KeyCode==Enum.KeyCode.V then
        Config.FovEnabled=not Config.FovEnabled
        Camera.FieldOfView=Config.FovEnabled and OriginalFOV/Config.FovValue or OriginalFOV
    end
end)

print("✅ SCRIPT CARGADO — Círculo activo y todas las secciones visibles")
