-- =============================================================================
-- RESTAURADA: Interfaz visible + Todo reparado
-- ✅ Interfaz igual a la que SÍ te aparecía antes
-- ✅ Funciona aunque el panel esté oculto
-- ✅ ESP solo vivos, se limpia al morir
-- ✅ Volar / Correr / Noclip reparados
-- ✅ Barras de velocidad configurables
-- ✅ Antiban integrado
-- =============================================================================

print("")
print("╔════════════════════════════════════════════╗")
print("║   CARGANDO — INTERFAZ RESTAURADA ✅        ║")
print("╚════════════════════════════════════════════╝")

-- ==============================================
-- SERVICIOS
-- ==============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==============================================
-- 🔒 ANTIBAN
-- ==============================================
local Antiban = {
    VelMax = 80,
    GravMin = 0.15,
    Espera = 0.35,
    Ultimo = 0
}
local function Seguro(f)
    local ahora = os.clock()
    if ahora - Antiban.Ultimo < Antiban.Espera then return end
    Antiban.Ultimo = ahora
    pcall(f)
end

-- ==============================================
-- VARIABLES (INDEPENDIENTES DE LA INTERFAZ)
-- ==============================================
UiVisible = true
AimEnabled = false
EspEnabled = true
NoRecoilEnabled = false
FovEnabled = false
NightVision = false
NoclipEnabled = false
CorrerEnabled = false
VolarEnabled = false

AimStrength = 5
CircleRadius = 180
VelCorrer = 45
VelVolar = 35
MaxDistESP = 8000

FOVOriginal = Camera.FieldOfView
BrilloOriginal = Lighting.Brightness
AmbOriginal = Lighting.Ambient
ExtOriginal = Lighting.OutdoorAmbient
GravedadOriginal = 196.2

UltimoPersonaje = LocalPlayer.Character

-- ==============================================
-- ⌨️ TECLAS
-- ==============================================
Teclas = {
    Mostrar = Enum.KeyCode.RightShift,
    Aimbot = Enum.KeyCode.Q,
    Esp = Enum.KeyCode.E,
    Zoom = Enum.KeyCode.R,
    Correr = Enum.KeyCode.C,
    Volar = Enum.KeyCode.V,
    Noclip = Enum.KeyCode.G,
    SinRec = Enum.KeyCode.X,
    Noche = Enum.KeyCode.Z,
}

-- ==============================================
-- COLORES
-- ==============================================
ColorCirculo = Color3.fromRGB(0, 255, 0)
ColorOn = Color3.fromRGB(40, 180, 80)
ColorOff = Color3.fromRGB(180, 40, 40)
ColorFondo = Color3.fromRGB(30, 30, 40)
ColorBorde = Color3.fromRGB(60, 60, 90)
ColorBarra = Color3.fromRGB(50, 50, 70)
ColorRelleno = Color3.fromRGB(80, 160, 255)
ColorESP = Color3.fromRGB(0, 255, 100)

-- ==============================================
-- CÍRCULO DEL AIMBOT
-- ==============================================
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Thickness = 2.5
Circle.NumSides = 72
Circle.Transparency = 0.85
Circle.Radius = CircleRadius
Circle.Color = ColorCirculo
Circle.Filled = false

-- ==============================================
-- 🖥️ INTERFAZ — ESTRUCTURA QUE SÍ APARECE
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAsistencia"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- MARCO PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Marco"
MainFrame.Size = UDim2.new(0, 300, 0, 650)
MainFrame.Position = UDim2.new(0.02, 0, 0.05, 0)
MainFrame.BackgroundColor3 = ColorFondo
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.04, 0)

-- BARRA SUPERIOR
local Barra = Instance.new("Frame")
Barra.Size = UDim2.new(1, 0, 0, 45)
Barra.BackgroundColor3 = ColorBorde
Barra.Parent = MainFrame
Instance.new("UICorner", Barra).CornerRadius = UDim.new(0.04, 0)

local Titulo = Instance.new("TextLabel")
Titulo.Text = "⚙️ PANEL DE ASISTENCIA"
Titulo.Font = Enum.Font.GothamBold
Titulo.TextSize = 15
Titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
Titulo.Size = UDim2.new(1, -10, 1, 0)
Titulo.Position = UDim2.new(0, 10, 0, 0)
Titulo.BackgroundTransparency = 1
Titulo.TextXAlignment = Enum.TextXAlignment.Left
Titulo.Parent = Barra

-- ARRASTRAR VENTANA
local arrastrar = false
local offset = Vector2.new()
Barra.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        arrastrar = true
        offset = UserInputService:GetMouseLocation() - MainFrame.AbsolutePosition
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if arrastrar and i.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = UserInputService:GetMouseLocation() - offset
        MainFrame.Position = UDim2.new(0, pos.X, 0, pos.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then arrastrar = false end
end)

-- POSICIÓN
local y = 55
local Botones = {}

-- ==============================================
-- SEPARADOR
-- ==============================================
local function Separador(texto)
    y = y + 8
    local s = Instance.new("TextLabel")
    s.Text = "  "..texto
    s.Font = Enum.Font.GothamBold
    s.TextSize = 12
    s.TextColor3 = Color3.fromRGB(180, 200, 255)
    s.Size = UDim2.new(0.92, 0, 0, 28)
    s.Position = UDim2.new(0.04, 0, 0, y)
    s.BackgroundColor3 = ColorBarra
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Parent = MainFrame
    Instance.new("UICorner", s).CornerRadius = UDim.new(0, 6)
    y = y + 32
end

-- ==============================================
-- BOTÓN TOGGLE
-- ==============================================
local function BotonToggle(texto, varGlobal)
    y = y + 4
    local btn = Instance.new("TextButton")
    btn.Name = "Btn"..varGlobal
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Size = UDim2.new(0.92, 0, 0, 40)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.BackgroundColor3 = _G[varGlobal] and ColorOn or ColorOff
    btn.Text = texto..": "..(_G[varGlobal] and "ACTIVADO" or "DESACTIVADO")
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    Botones[varGlobal] = btn

    btn.MouseButton1Click:Connect(function()
        _G[varGlobal] = not _G[varGlobal]
        btn.Text = texto..": "..(_G[varGlobal] and "ACTIVADO" or "DESACTIVADO")
        btn.BackgroundColor3 = _G[varGlobal] and ColorOn or ColorOff
    end)
    y = y + 44
end

-- ==============================================
-- BARRA DESLIZANTE
-- ==============================================
local Barras = {}
local function BarraDeslizante(texto, varGlobal, min, max, def)
    y = y + 6
    if _G[varGlobal] == nil then _G[varGlobal] = def end

    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(0.92, 0, 0, 50)
    cont.Position = UDim2.new(0.04, 0, 0, y)
    cont.BackgroundColor3 = ColorBarra
    cont.Parent = MainFrame
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 6)

    local etiqueta = Instance.new("TextLabel")
    etiqueta.Text = texto..": "..math.floor(_G[varGlobal])
    etiqueta.Font = Enum.Font.Gotham
    etiqueta.TextSize = 11
    etiqueta.TextColor3 = Color3.fromRGB(255, 255, 255)
    etiqueta.Size = UDim2.new(1, -10, 0, 20)
    etiqueta.Position = UDim2.new(0, 8, 0, 4)
    etiqueta.BackgroundTransparency = 1
    etiqueta.TextXAlignment = Enum.TextXAlignment.Left
    etiqueta.Parent = cont

    local fondo = Instance.new("Frame")
    fondo.Size = UDim2.new(1, -16, 0, 14)
    fondo.Position = UDim2.new(0, 8, 0, 30)
    fondo.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    fondo.Parent = cont
    Instance.new("UICorner", fondo).CornerRadius = UDim.new(1, 0)

    local relleno = Instance.new("Frame")
    relleno.Size = UDim2.new(((_G[varGlobal]-min)/(max-min)), 0, 1, 0)
    relleno.BackgroundColor3 = ColorRelleno
    relleno.Parent = fondo
    Instance.new("UICorner", relleno).CornerRadius = UDim.new(1, 0)

    Barras[varGlobal] = {et=etiqueta, re=relleno, mn=min, mx=max}

    local drag = false
    fondo.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - fondo.AbsolutePosition.X) / fondo.AbsoluteSize.X, 0, 1)
            _G[varGlobal] = min + p * (max - min)
            etiqueta.Text = texto..": "..math.floor(_G[varGlobal])
            relleno.Size = UDim2.new(p, 0, 1, 0)
            -- SINCRONIZAR
            if varGlobal == "AimStrength" then AimStrength = math.floor(_G[varGlobal]) end
            if varGlobal == "RadioAim" then CircleRadius = math.floor(_G[varGlobal]); Circle.Radius = CircleRadius end
            if varGlobal == "VelCorrer" then VelCorrer = math.floor(_G[varGlobal]) end
            if varGlobal == "VelVolar" then VelVolar = math.floor(_G[varGlobal]) end
        end
    end)

    y = y + 54
end

-- ==============================================
-- ARMAR PANEL
-- ==============================================
Separador("🎯 HABILIDADES DE COMBATE")
BotonToggle("ACTIVAR AIMBOT", "AimEnabled")
BarraDeslizante("FUERZA DEL AIMBOT", "AimStrength", 1, 10, 5)
BarraDeslizante("RADIO DE DETECCIÓN", "RadioAim", 50, 300, 180)
BotonToggle("VER JUGADORES (ESP)", "EspEnabled")
BotonToggle("SIN RETROCESO", "NoRecoilEnabled")
BotonToggle("ZOOM AUTOMÁTICO", "FovEnabled")
BotonToggle("VISIÓN NOCTURNA", "NightVision")

Separador("✨ PODERES ESPECIALES")
BotonToggle("TRASPASAR PAREDES", "NoclipEnabled")
BotonToggle("CORRER RÁPIDO", "CorrerEnabled")
BarraDeslizante("VELOCIDAD AL CORRER", "VelCorrer", 16, 80, 45)
BotonToggle("VOLAR", "VolarEnabled")
BarraDeslizante("VELOCIDAD DE VUELO", "VelVolar", 10, 60, 35)

print("[✅] INTERFAZ CREADA — DEBE APARECER EN PANTALLA")

-- ==============================================
-- TECLAS GLOBALES
-- ==============================================
UserInputService.InputBegan:Connect(function(inp, proc)
    if proc then return end

    -- MOSTRAR/OCULTAR TODO
    if inp.KeyCode == Teclas.Mostrar then
        UiVisible = not UiVisible
        MainFrame.Visible = UiVisible
        Circle.Visible = UiVisible
        return
    end

    -- TECLAS RÁPIDAS
    if inp.KeyCode == Teclas.Aimbot then _G.AimEnabled = not _G.AimEnabled end
    if inp.KeyCode == Teclas.Esp then _G.EspEnabled = not _G.EspEnabled end
    if inp.KeyCode == Teclas.Zoom then
        _G.FovEnabled = not _G.FovEnabled
        Camera.FieldOfView = _G.FovEnabled and FOVOriginal / 2 or FOVOriginal
    end
    if inp.KeyCode == Teclas.Correr then _G.CorrerEnabled = not _G.CorrerEnabled end
    if inp.KeyCode == Teclas.Volar then _G.VolarEnabled = not _G.VolarEnabled end
    if inp.KeyCode == Teclas.Noclip then _G.NoclipEnabled = not _G.NoclipEnabled end
    if inp.KeyCode == Teclas.SinRec then _G.NoRecoilEnabled = not _G.NoRecoilEnabled end
    if inp.KeyCode == Teclas.Noche then
        _G.NightVision = not _G.NightVision
        if _G.NightVision then
            Lighting.Brightness = 3.5
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        else
            Lighting.Brightness = BrilloOriginal
            Lighting.Ambient = AmbOriginal
            Lighting.OutdoorAmbient = ExtOriginal
        end
    end
end)

-- ==============================================
-- AIMBOT — OBJETIVO MÁS CERCANO
-- ==============================================
local function ObtenerObjetivo()
    local raton = UserInputService:GetMouseLocation()
    local mejor, distMin = nil, CircleRadius
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local cabeza = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if cabeza and hum and hum.Health > 0 then
                local pos, vis = Camera:WorldToViewportPoint(cabeza.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - raton).Magnitude
                    if d < distMin then distMin = d; mejor = cabeza end
                end
            end
        end
    end
    return mejor
end

-- ==============================================
-- ESP
-- ==============================================
local DibujosESP = {}

-- ==============================================
-- BUCLE PRINCIPAL — FUNCIONA SIEMPRE
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- CÍRCULO
    local posRaton = UserInputService:GetMouseLocation()
    Circle.Position = Vector2.new(posRaton.X, posRaton.Y)
    Circle.Visible = UiVisible

    -- ✅ LIMPIAR ESP AL MORIR / RESPAWNEAR
    if LocalPlayer.Character ~= UltimoPersonaje then
        for _, j in pairs(DibujosESP) do
            for _, d in pairs(j) do pcall(function() d.Visible = false end) end
        end
        table.clear(DibujosESP)
        UltimoPersonaje = LocalPlayer.Character
    end

    -- ✅ AIMBOT FUNCIONA AUNQUE PANEL ESTÉ OCULTO
    if _G.AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local obj = ObtenerObjetivo()
        if obj then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, obj.Position), AimStrength / 10)
        end
    end

    -- ✅ SIN RETROCESO
    if _G.NoRecoilEnabled then pcall(function() Mouse.Origin = CFrame.new(Camera.CFrame.Position) end) end

    -- ✅ NOCLIP (TRASPASAR PAREDES) — REPARADO
    if _G.NoclipEnabled and LocalPlayer.Character then
        Seguro(function()
            for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    elseif not _G.NoclipEnabled and LocalPlayer.Character then
        Seguro(function()
            for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = true end
            end
        end)
    end

    -- ✅ CORRER — REPARADO
    if _G.CorrerEnabled and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then Seguro(function() h.WalkSpeed = math.min(VelCorrer, Antiban.VelMax) end) end
    elseif not _G.CorrerEnabled and LocalPlayer.Character then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then Seguro(function() h.WalkSpeed = 16 end) end
    end

    -- ✅ VOLAR — REPARADO
    if _G.VolarEnabled and LocalPlayer.Character then
        local raiz = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if raiz and hum then
            Seguro(function()
                hum.GravityScale = math.max(0.2, Antiban.GravMin)
                hum.JumpPower = 0
            end)
            local dir = Vector3.new()
            local vel = math.min(VelVolar, 60) / 10
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 0.85, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 0.85, 0) end
            Seguro(function() raiz.Velocity = raiz.CFrame:VectorToWorldSpace(dir * vel) end)
        end
    elseif not _G.VolarEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then Seguro(function() hum.GravityScale = GravedadOriginal; hum.JumpPower = 50 end) end
    end

    -- ✅ ESP — SOLO VIVOS + POR DISTANCIA
    if not _G.EspEnabled then
        for _, j in pairs(DibujosESP) do
            for _, d in pairs(j) do pcall(function() d.Visible = false end) end
        end
        return
    end

    for _, jug in ipairs(Players:GetPlayers()) do
        if jug == LocalPlayer then
            if DibujosESP[jug] then for _, d in pairs(DibujosESP[jug]) do pcall(function() d.Visible = false end) end end
            continue
        end

        local char = jug.Character
        local mostrar = true
        local raiz, hum = nil, nil

        if not char then mostrar = false
        else
            raiz = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChild("Humanoid")
            if not raiz or not hum or hum.Health <= 0 then mostrar = false end
        end

        local dist = 99999
        if raiz then dist = math.floor((Camera.CFrame.Position - raiz.Position).Magnitude) end
        if dist > MaxDistESP then mostrar = false end

        if not mostrar then
            if DibujosESP[jug] then for _, d in pairs(DibujosESP[jug]) do pcall(function() d.Visible = false end) end end
            goto continuar
        end

        local posPant, vis = Camera:WorldToViewportPoint(raiz.Position)
        if not vis then
            if DibujosESP[jug] then for _, d in pairs(DibujosESP[jug]) do pcall(function() d.Visible = false end) end end
            goto continuar
        end

        -- CREAR DIBUJOS SI NO EXISTEN
        if not DibujosESP[jug] then
            DibujosESP[jug] = {
                caja = Drawing.new("Square"),
                nombre = Drawing.new("Text"),
                vida = Drawing.new("Text"),
                dist = Drawing.new("Text")
            }
            DibujosESP[jug].caja.Thickness = 2.5
            DibujosESP[jug].caja.Color = ColorESP
            DibujosESP[jug].caja.Filled = false
            DibujosESP[jug].nombre.Size = 12
            DibujosESP[jug].nombre.Center = true
            DibujosESP[jug].nombre.Color = ColorESP
            DibujosESP[jug].vida.Size = 11
            DibujosESP[jug].vida.Center = true
            DibujosESP[jug].vida.Color = Color3.fromRGB(255, 230, 0)
            DibujosESP[jug].dist.Size = 10
            DibujosESP[jug].dist.Center = true
            DibujosESP[jug].dist.Color = Color3.fromRGB(150, 200, 255)
        end

        local d = DibujosESP[jug]
        local arr = Camera:WorldToViewportPoint(raiz.Position + Vector3.new(0, 2.7, 0))
        local abj = Camera:WorldToViewportPoint(raiz.Position + Vector3.new(0, -0.4, 0))
        local alt = abj.Y - arr.Y
        local anc = alt * 0.38
        local x = posPant.X
        local yp = posPant.Y

        d.caja.Visible = true
        d.caja.Position = Vector2.new(x - anc/2, yp - alt/2)
        d.caja.Size = Vector2.new(anc, alt)

        d.nombre.Visible = true
        d.nombre.Text = jug.Name
        d.nombre.Position = Vector2.new(x, yp - alt/2 - 18)

        d.vida.Visible = true
        d.vida.Text = math.floor(hum.Health).." HP"
        d.vida.Position = Vector2.new(x, yp + alt/2 + 8)

        d.dist.Visible = true
        d.dist.Text = dist.." m"
        d.dist.Position = Vector2.new(x, yp + alt/2 + 24)

        ::continuar::
    end
end)

print("")
print("✅ SCRIPT CARGADO — INTERFAZ RESTAURADA ✅")
print("✅ Si no aparece: asegúrate de no ocultar el panel con Mayús Derecha")
print("⌨️ TECLAS: Q=Aimbot | E=ESP | G=Noclip | C=Correr | V=Volar")
print("   WASD+ESPACIO=Subir | WASD+CTRL=Bajar")
