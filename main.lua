-- ==============================================
-- VERSIÓN SIMPLIFICADA AL MÁXIMO
-- Panel + TODOS los botones visibles desde el inicio
-- ==============================================

print("[1] INICIANDO...")

-- SERVICIOS DIRECTOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

print("[2] SERVICIOS CARGADOS")

-- VARIABLES
UiVisible = true
AimEnabled = false
EspEnabled = true
NoRecoilEnabled = false
FovEnabled = false
NightVision = false
TraspasarParedes = false
Correr = false
Volar = false
AimStrength = 5
CircleRadius = 150
OriginalFOV = Camera.FieldOfView
OriginalBrightness = Lighting.Brightness
OriginalAmbient = Lighting.Ambient
OriginalOutdoorAmbient = Lighting.OutdoorAmbient
GravedadOriginal = 196.2

ColorCirculo = Color3.fromRGB(0,255,0)
ColorEsp = Color3.fromRGB(255,40,40)
ColorVida = Color3.fromRGB(40,255,40)

print("[3] VARIABLES LISTAS")

-- CÍRCULO
Circle = nil
pcall(function()
    Circle = Drawing.new("Circle")
    Circle.Visible = true
    Circle.Thickness = 2
    Circle.NumSides = 64
    Circle.Radius = CircleRadius
    Circle.Color = ColorCirculo
end)
print("[4] CÍRCULO CREADO")

-- INTERFAZ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAsistencia"
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end
pcall(function() ScreenGui.ResetOnSpawn = false end)
print("[5] INTERFAZ EN: " .. ScreenGui.Parent.Name)

-- MARCO PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MarcoPrincipal"
MainFrame.Size = UDim2.new(0, 320, 0, 800)
MainFrame.Position = UDim2.new(0.01,0,0.05,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.03,0)
print("[6] MARCO PRINCIPAL CREADO")

-- BARRA SUPERIOR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,40)
TitleBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Text = "PANEL DE ASISTENCIA"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextColor3 = Color3.fromRGB(255,255,255)
TitleText.Size = UDim2.new(1,-10,1,0)
TitleText.Position = UDim2.new(0,10,0,0)
TitleText.BackgroundTransparency = 1
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar
print("[7] BARRA SUPERIOR LISTA")

-- ARRASTRAR
local DragStart, StartPos
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        DragStart = UserInputService:GetMouseLocation()
        StartPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if DragStart and i.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = UserInputService:GetMouseLocation() - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset+Delta.X, StartPos.Y.Scale, StartPos.Y.Offset+Delta.Y)
    end
end)

-- ==============================================
-- CREAR BOTONES UNO POR UNO — DIRECTAMENTE
-- ==============================================

local Y = 50

-- FUNCIÓN SIMPLE PARA CREAR BOTÓN
local function CrearBoton(Texto, PosY, ColorFondo)
    local Btn = Instance.new("TextButton")
    Btn.Name = "Boton_"..PosY
    Btn.Text = Texto
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Size = UDim2.new(0.92,0,0,40)
    Btn.Position = UDim2.new(0.04,0,0,PosY)
    Btn.BackgroundColor3 = ColorFondo
    Btn.Parent = MainFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)
    return Btn
end

-- SEPARADOR
local function Separador(Texto, PosY)
    local Sep = Instance.new("TextLabel")
    Sep.Text = Texto
    Sep.Font = Enum.Font.GothamBold
    Sep.TextSize = 12
    Sep.TextColor3 = Color3.fromRGB(255,200,40)
    Sep.Size = UDim2.new(0.92,0,0,24)
    Sep.Position = UDim2.new(0.04,0,0,PosY)
    Sep.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Sep.Parent = MainFrame
    Instance.new("UICorner", Sep).CornerRadius = UDim.new(0,6)
    return Sep
end

-- ==============================================
-- BOTONES CREADOS UNO POR UNO
-- ==============================================

Y = Y + 0
Separador("HABILIDADES", Y); Y = Y + 28

Y = Y + 2
local BtnAimbot = CrearBoton("🎯 AIMBOT: OFF", Y, Color3.fromRGB(130,35,35))
Y = Y + 42

Y = Y + 2
local BtnEsp = CrearBoton("👁️ ESP: ON", Y, Color3.fromRGB(35,130,60))
Y = Y + 42

Y = Y + 2
local BtnNoRecoil = CrearBoton("🔫 SIN RETROCESO: OFF", Y, Color3.fromRGB(130,35,35))
Y = Y + 42

Y = Y + 2
local BtnZoom = CrearBoton("🔍 ZOOM: OFF", Y, Color3.fromRGB(130,35,35))
Y = Y + 42

Y = Y + 2
local BtnNoche = CrearBoton("🌙 VISIÓN NOCTURNA: OFF", Y, Color3.fromRGB(130,35,35))
Y = Y + 42

Y = Y + 5
Separador("PODERES ESPECIALES", Y); Y = Y + 28

Y = Y + 2
local BtnParedes = CrearBoton("👻 TRASPASAR PAREDES: OFF", Y, Color3.fromRGB(130,35,35))
Y = Y + 42

Y = Y + 2
local BtnCorrer = CrearBoton("🏃 CORRER RÁPIDO: OFF", Y, Color3.fromRGB(130,35,35))
Y = Y + 42

Y = Y + 2
local BtnVolar = CrearBoton("✈️ VOLAR: OFF", Y, Color3.fromRGB(130,35,35))
Y = Y + 42

print("[8] TODOS LOS BOTONES CREADOS")

-- ==============================================
-- FUNCIONES DE LOS BOTONES
-- ==============================================

BtnAimbot.MouseButton1Click:Connect(function()
    AimEnabled = not AimEnabled
    BtnAimbot.Text = AimEnabled and "🎯 AIMBOT: ON" or "🎯 AIMBOT: OFF"
    BtnAimbot.BackgroundColor3 = AimEnabled and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
end)

BtnEsp.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    BtnEsp.Text = EspEnabled and "👁️ ESP: ON" or "👁️ ESP: OFF"
    BtnEsp.BackgroundColor3 = EspEnabled and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
end)

BtnNoRecoil.MouseButton1Click:Connect(function()
    NoRecoilEnabled = not NoRecoilEnabled
    BtnNoRecoil.Text = NoRecoilEnabled and "🔫 SIN RETROCESO: ON" or "🔫 SIN RETROCESO: OFF"
    BtnNoRecoil.BackgroundColor3 = NoRecoilEnabled and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
end)

BtnZoom.MouseButton1Click:Connect(function()
    FovEnabled = not FovEnabled
    BtnZoom.Text = FovEnabled and "🔍 ZOOM: ON" or "🔍 ZOOM: OFF"
    BtnZoom.BackgroundColor3 = FovEnabled and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
    Camera.FieldOfView = FovEnabled and OriginalFOV/2 or OriginalFOV
end)

BtnNoche.MouseButton1Click:Connect(function()
    NightVision = not NightVision
    BtnNoche.Text = NightVision and "🌙 VISIÓN NOCTURNA: ON" or "🌙 VISIÓN NOCTURNA: OFF"
    BtnNoche.BackgroundColor3 = NightVision and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
    if NightVision then
        Lighting.Brightness = 3.5
        Lighting.Ambient = Color3.fromRGB(200,200,200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200,200,200)
    else
        Lighting.Brightness = OriginalBrightness
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient
    end
end)

BtnParedes.MouseButton1Click:Connect(function()
    TraspasarParedes = not TraspasarParedes
    BtnParedes.Text = TraspasarParedes and "👻 TRASPASAR PAREDES: ON" or "👻 TRASPASAR PAREDES: OFF"
    BtnParedes.BackgroundColor3 = TraspasarParedes and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
end)

BtnCorrer.MouseButton1Click:Connect(function()
    Correr = not Correr
    BtnCorrer.Text = Correr and "🏃 CORRER RÁPIDO: ON" or "🏃 CORRER RÁPIDO: OFF"
    BtnCorrer.BackgroundColor3 = Correr and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Correr and 50 or 16
    end
end)

BtnVolar.MouseButton1Click:Connect(function()
    Volar = not Volar
    BtnVolar.Text = Volar and "✈️ VOLAR: ON" or "✈️ VOLAR: OFF"
    BtnVolar.BackgroundColor3 = Volar and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.GravityScale = Volar and 0 or GravedadOriginal
    end
end)

print("[9] TODAS LAS FUNCIONES CONECTADAS")

-- ==============================================
-- SISTEMA DE AIMBOT
-- ==============================================
function ObtenerObjetivo()
    local MousePos = UserInputService:GetMouseLocation()
    local Mejor, Menor = nil, CircleRadius
    for _,P in ipairs(Players:GetPlayers()) do
        if P ~= LocalPlayer and P.Character then
            local R = P.Character:FindFirstChild("HumanoidRootPart")
            local H = P.Character:FindFirstChild("Humanoid")
            if R and H and H.Health > 0 then
                local Cabeza = P.Character.Head
                local Pos, Vis = Camera:WorldToViewportPoint(Cabeza.Position)
                if Vis then
                    local D = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(MousePos.X, MousePos.Y)).Magnitude
                    if D < Menor then Menor = D Mejor = Cabeza end
                end
            end
        end
    end
    return Mejor
end

-- ESP
DibujosESP = {}

-- ==============================================
-- BUCLE PRINCIPAL
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- CÍRCULO SIGUE AL RATÓN
    if Circle then
        local Pos = UserInputService:GetMouseLocation()
        Circle.Position = Vector2.new(Pos.X, Pos.Y)
        Circle.Visible = UiVisible
    end

    if not UiVisible then return end

    -- AIMBOT
    if AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local Obj = ObtenerObjetivo()
        if Obj then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Obj.Position), AimStrength/10) end
    end

    -- SIN RETROCESO
    if NoRecoilEnabled then pcall(function() Mouse.Origin = CFrame.new(Camera.CFrame.Position) end) end

    -- TRASPASAR PAREDES
    if TraspasarParedes and LocalPlayer.Character then
        pcall(function()
            for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    elseif not TraspasarParedes and LocalPlayer.Character then
        pcall(function()
            for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = true end
            end
        end)
    end

    -- CORRER
    if Correr and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end

    -- VOLAR
    if Volar and LocalPlayer.Character then
        local R = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local H = LocalPlayer.Character:FindFirstChild("Humanoid")
        if R and H then
            H.GravityScale = 0
            local Dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Dir -= Vector3.new(0,1,0) end
            R.Velocity = R.CFrame:VectorToWorldSpace(Dir * 5)
        end
    end

    -- ESP
    if not EspEnabled then
        for _,J in pairs(DibujosESP) do
            for _,D in pairs(J) do pcall(function() D.Visible = false end) end
        end
        return
    end

    for _,P in ipairs(Players:GetPlayers()) do
        if P == LocalPlayer then
            if DibujosESP[P] then
                for _,D in pairs(DibujosESP[P]) do pcall(function() D.Visible = false end) end
            end
            continue
        end
        local C = P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") or not C:FindFirstChild("Humanoid") or C.Humanoid.Health <= 0 then
            if DibujosESP[P] then
                for _,D in pairs(DibujosESP[P]) do pcall(function() D.Visible = false end) end
            end
            continue
        end
        local R = C.HumanoidRootPart
        local Pos, Vis = Camera:WorldToViewportPoint(R.Position)
        if not Vis then
            if DibujosESP[P] then
                for _,D in pairs(DibujosESP[P]) do pcall(function() D.Visible = false end) end
            end
            continue
        end

        if not DibujosESP[P] then
            DibujosESP[P] = {}
            pcall(function()
                DibujosESP[P].Caja = Drawing.new("Square")
                DibujosESP[P].Caja.Thickness = 1.5
                DibujosESP[P].Caja.Color = ColorEsp
                DibujosESP[P].Nombre = Drawing.new("Text")
                DibujosESP[P].Nombre.Size = 11
                DibujosESP[P].Nombre.Center = true
            end)
        end

        local D = DibujosESP[P]
        if not D or not D.Caja then continue end

        local Alt = (Camera:WorldToViewportPoint(R.Position + Vector3.new(0,2.5,0)) - Camera:WorldToViewportPoint(R.Position + Vector3.new(0,-0.2,0))).Y
        local Anc = Alt * 0.4
        local X = Pos.X
        local Yp = Pos.Y
        D.Caja.Visible = true
        D.Caja.Position = Vector2.new(X - Anc/2, Yp - Alt/2)
        D.Caja.Size = Vector2.new(Anc, Alt)
        D.Caja.Filled = false

        if D.Nombre then
            D.Nombre.Visible = true
            D.Nombre.Text = P.Name
            D.Nombre.Color = ColorEsp
            D.Nombre.Position = Vector2.new(X, Yp - Alt/2 - 14)
        end
    end
end)

print("[10] ========================================")
print("[10] ✅ TODO CARGADO COMPLETAMENTE")
print("[10] ✅ DEBES VER:")
print("[10] ✅ PANEL OSCURO CON BOTONES")
print("[10] ✅ CÍRCULO VERDE EN EL CENTRO")
print("[10] ========================================")
print("[10] SI NO VES NADA → MIRA LA CONSOLA")
print("[10] DIME HASTA QUÉ NÚMERO LLEGA EN CONSOLA")
print("[10] ========================================")
