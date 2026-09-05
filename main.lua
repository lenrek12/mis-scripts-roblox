-- =============================================================================
-- ✅ PANEL EN EL CENTRO AL INICIAR
-- ✅ PODER MOVERLO A CUALQUIER LUGAR
-- ✅ BOTÓN MINIMIZAR / RESTAURAR
-- ✅ BOTÓN MOSTRAR / OCULTAR DESDE EL PANEL
-- ✅ Volar / Correr / Noclip reparados
-- ✅ ESP solo vivos, se limpia al morir
-- ✅ Barras de velocidad configurables
-- =============================================================================

print("")
print("==========================================")
print("   CARGANDO PANEL EN EL CENTRO...")
print("==========================================")

-- ==============================================
-- SERVICIOS
-- ==============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==============================================
-- ANTIBAN
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
-- VARIABLES
-- ==============================================
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
-- TECLAS DE EMERGENCIA (si ocultas todo)
-- ==============================================
Teclas = {
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
ColorBotones = Color3.fromRGB(50, 50, 80)

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
-- 🖥️ CREAR INTERFAZ — EN EL CENTRO AL INICIAR
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAsistencia"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ASIGNAR PADRE
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- TAMAÑO DE PANTALLA
local Pantalla = workspace.CurrentCamera.ViewportResolution
local AnchoPanel, AltoPanel = 290, 610

-- ✅ MARCO PRINCIPAL — CENTRADO
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MarcoPrincipal"
MainFrame.Size = UDim2.new(0, AnchoPanel, 0, AltoPanel)
MainFrame.Position = UDim2.new(0.5, -AnchoPanel/2, 0.5, -AltoPanel/2) -- CENTRO
MainFrame.BackgroundColor3 = ColorFondo
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.04, 0)

-- ✅ BARRA SUPERIOR (para arrastrar)
local Barra = Instance.new("Frame")
Barra.Size = UDim2.new(1, 0, 0, 45)
Barra.BackgroundColor3 = ColorBorde
Barra.Parent = MainFrame
Instance.new("UICorner", Barra).CornerRadius = UDim.new(0.04, 0)

local Titulo = Instance.new("TextLabel")
Titulo.Text = "⚙️ PANEL DE ASISTENCIA"
Titulo.Font = Enum.Font.GothamBold
Titulo.TextSize = 14
Titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
Titulo.Size = UDim2.new(1, -100, 1, 0)
Titulo.Position = UDim2.new(0, 10, 0, 0)
Titulo.BackgroundTransparency = 1
Titulo.TextXAlignment = Enum.TextXAlignment.Left
Titulo.Parent = Barra

-- ✅ BOTONES DE BARRA: MINIMIZAR Y OCULTAR
local BotonMinimizar = Instance.new("TextButton")
BotonMinimizar.Text = "−"
BotonMinimizar.Font = Enum.Font.GothamBold
BotonMinimizar.TextSize = 18
BotonMinimizar.TextColor3 = Color3.fromRGB(255, 255, 255)
BotonMinimizar.Size = UDim2.new(0, 32, 1, -10)
BotonMinimizar.Position = UDim2.new(1, -70, 0, 5)
BotonMinimizar.BackgroundColor3 = ColorBotones
BotonMinimizar.Parent = Barra
Instance.new("UICorner", BotonMinimizar).CornerRadius = UDim.new(0.5, 0)

local BotonOcultar = Instance.new("TextButton")
BotonOcultar.Text = "✕"
BotonOcultar.Font = Enum.Font.GothamBold
BotonOcultar.TextSize = 15
BotonOcultar.TextColor3 = Color3.fromRGB(255, 255, 255)
BotonOcultar.Size = UDim2.new(0, 32, 1, -10)
BotonOcultar.Position = UDim2.new(1, -38, 0, 5)
BotonOcultar.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
BotonOcultar.Parent = Barra
Instance.new("UICorner", BotonOcultar).CornerRadius = UDim.new(0.5, 0)

-- ✅ BOTÓN MOSTRAR (aparece al ocultar todo)
local BotonMostrar = Instance.new("TextButton")
BotonMostrar.Text = "⚙️"
BotonMostrar.Font = Enum.Font.GothamBold
BotonMostrar.TextSize = 18
BotonMostrar.TextColor3 = Color3.fromRGB(255, 255, 255)
BotonMostrar.Size = UDim2.new(0, 50, 0, 50)
BotonMostrar.Position = UDim2.new(0.02, 0, 0.5, -25)
BotonMostrar.BackgroundColor3 = ColorBorde
BotonMostrar.Visible = false
BotonMostrar.Parent = ScreenGui
Instance.new("UICorner", BotonMostrar).CornerRadius = UDim.new(0.5, 0)

-- ✅ LÓGICA MINIMIZAR / RESTAURAR
local Minimizado = false
local AlturaCompleta = AltoPanel
BotonMinimizar.MouseButton1Click:Connect(function()
    Minimizado = not Minimizado
    if Minimizado then
        MainFrame.Size = UDim2.new(0, AnchoPanel, 0, 45)
        BotonMinimizar.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, AnchoPanel, 0, AlturaCompleta)
        BotonMinimizar.Text = "−"
    end
end)

-- ✅ LÓGICA OCULTAR / MOSTRAR
BotonOcultar.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    BotonMostrar.Visible = true
end)
BotonMostrar.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    BotonMostrar.Visible = false
end)

-- ✅ MOVER EL PANEL ARRASTRANDO LA BARRA
local Arrastrando = false
local Offset = Vector2.new()

Barra.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        Arrastrando = true
        Offset = UserInputService:GetMouseLocation() - MainFrame.AbsolutePosition
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if Arrastrando and i.UserInputType == Enum.UserInputType.MouseMovement then
        local Pos = UserInputService:GetMouseLocation() - Offset
        -- Limitar para que no se salga de la pantalla
        local X = math.clamp(Pos.X, 0, Pantalla.X - AnchoPanel)
        local Y = math.clamp(Pos.Y, 0, Pantalla.Y - 45)
        MainFrame.Position = UDim2.new(0, X, 0, Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then Arrastrando = false end
end)

-- ✅ POSICIÓN DE CONTENIDO
local y = 55
local BotonesUI = {}

-- ==============================================
-- SEPARADOR
-- ==============================================
local function Separador(texto)
    y = y + 6
    local s = Instance.new("TextLabel")
    s.Text = "  "..texto
    s.Font = Enum.Font.GothamBold
    s.TextSize = 11
    s.TextColor3 = Color3.fromRGB(180, 200, 255)
    s.Size = UDim2.new(0.92, 0, 0, 24)
    s.Position = UDim2.new(0.04, 0, 0, y)
    s.BackgroundColor3 = ColorBarra
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Parent = MainFrame
    Instance.new("UICorner", s).CornerRadius = UDim.new(0, 5)
    y = y + 28
end

-- ==============================================
-- BOTÓN TOGGLE
-- ==============================================
local function BotonToggle(texto, variableTabla, nombreVar)
    y = y + 4
    variableTabla[nombreVar] = variableTabla[nombreVar] or false

    local btn = Instance.new("TextButton")
    btn.Name = "Btn_"..nombreVar
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Size = UDim2.new(0.92, 0, 0, 36)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.BackgroundColor3 = variableTabla[nombreVar] and ColorOn or ColorOff
    btn.Text = texto..": "..(variableTabla[nombreVar] and "ACTIVADO" or "DESACTIVADO")
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    BotonesUI[nombreVar] = btn

    btn.MouseButton1Click:Connect(function()
        variableTabla[nombreVar] = not variableTabla[nombreVar]
        btn.Text = texto..": "..(variableTabla[nombreVar] and "ACTIVADO" or "DESACTIVADO")
        btn.BackgroundColor3 = variableTabla[nombreVar] and ColorOn or ColorOff
    end)
    y = y + 40
end

-- ==============================================
-- BARRA DESLIZANTE
-- ==============================================
local BarrasUI = {}
local function BarraDeslizante(texto, variableTabla, nombreVar, min, max, def)
    y = y + 4
    if variableTabla[nombreVar] == nil then variableTabla[nombreVar] = def end

    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(0.92, 0, 0, 46)
    cont.Position = UDim2.new(0.04, 0, 0, y)
    cont.BackgroundColor3 = ColorBarra
    cont.Parent = MainFrame
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 5)

    local etiqueta = Instance.new("TextLabel")
    etiqueta.Text = texto..": "..math.floor(variableTabla[nombreVar])
    etiqueta.Font = Enum.Font.Gotham
    etiqueta.TextSize = 10
    etiqueta.TextColor3 = Color3.fromRGB(230, 230, 230)
    etiqueta.Size = UDim2.new(1, -10, 0, 18)
    etiqueta.Position = UDim2.new(0, 8, 0, 4)
    etiqueta.BackgroundTransparency = 1
    etiqueta.TextXAlignment = Enum.TextXAlignment.Left
    etiqueta.Parent = cont

    local fondo = Instance.new("Frame")
    fondo.Size = UDim2.new(1, -16, 0, 12)
    fondo.Position = UDim2.new(0, 8, 0, 28)
    fondo.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    fondo.Parent = cont
    Instance.new("UICorner", fondo).CornerRadius = UDim.new(1, 0)

    local prog = (variableTabla[nombreVar] - min) / (max - min)
    local relleno = Instance.new("Frame")
    relleno.Size = UDim2.new(prog, 0, 1, 0)
    relleno.BackgroundColor3 = ColorRelleno
    relleno.Parent = fondo
    Instance.new("UICorner", relleno).CornerRadius = UDim.new(1, 0)

    BarrasUI[nombreVar] = {et=etiqueta, re=relleno, mn=min, mx=max}

    local drag = false
    fondo.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - fondo.AbsolutePosition.X) / fondo.AbsoluteSize.X, 0, 1)
            variableTabla[nombreVar] = min + p * (max - min)
            etiqueta.Text = texto..": "..math.floor(variableTabla[nombreVar])
            relleno.Size = UDim2.new(p, 0, 1, 0)
            -- SINCRONIZAR
            if nombreVar == "AimStrength" then AimStrength = math.floor(variableTabla[nombreVar]) end
            if nombreVar == "RadioAim" then CircleRadius = math.floor(variableTabla[nombreVar]); Circle.Radius = CircleRadius end
            if nombreVar == "VelCorrer" then VelCorrer = math.floor(variableTabla[nombreVar]) end
            if nombreVar == "VelVolar" then VelVolar = math.floor(variableTabla[nombreVar]) end
        end
    end)

    y = y + 50
end

-- ==============================================
-- ARMAR EL PANEL
-- ==============================================
Separador("🎯 HABILIDADES DE COMBATE")
BotonToggle("ACTIVAR AIMBOT", _G, "AimEnabled")
BarraDeslizante("FUERZA DEL AIMBOT", _G, "AimStrength", 1, 10, 5)
BarraDeslizante("RADIO DE DETECCIÓN", _G, "RadioAim", 50, 300, 180)
BotonToggle("VER JUGADORES (ESP)", _G, "EspEnabled")
BotonToggle("SIN RETROCESO", _G, "NoRecoilEnabled")
BotonToggle("ZOOM AUTOMÁTICO", _G, "FovEnabled")
BotonToggle("VISIÓN NOCTURNA", _G, "NightVision")

Separador("✨ PODERES ESPECIALES")
BotonToggle("TRASPASAR PAREDES", _G, "NoclipEnabled")
BotonToggle("CORRER RÁPIDO", _G, "CorrerEnabled")
BarraDeslizante("VELOCIDAD AL CORRER", _G, "VelCorrer", 16, 80, 45)
BotonToggle("VOLAR", _G, "VolarEnabled")
BarraDeslizante("VELOCIDAD DE VUELO", _G, "VelVolar", 10, 60, 35)

-- AJUSTAR TAMAÑO FINAL
AlturaCompleta = y + 10
MainFrame.Size = UDim2.new(0, AnchoPanel, 0, AlturaCompleta)

print("[✅] PANEL CREADO EN EL CENTRO DE LA PANTALLA")
print("[✅] Arrastra la barra superior para moverlo")
print("[✅] Botón − = Minimizar / Botón ✕ = Ocultar")

-- ==============================================
-- TECLAS DE EMERGENCIA SI OCULTAS TODO
-- ==============================================
UserInputService.InputBegan:Connect(function(inp, proc)
    if proc then return end

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
-- AIMBOT
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

    -- LIMPIAR ESP AL MORIR
    if LocalPlayer.Character ~= UltimoPersonaje then
        for _, j in pairs(DibujosESP) do
            for _, d in pairs(j) do pcall(function() d.Visible = false end) end
        end
        table.clear(DibujosESP)
        UltimoPersonaje = LocalPlayer.Character
    end

    -- AIMBOT
    if _G.AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local obj = ObtenerObjetivo()
        if obj then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, obj.Position), AimStrength / 10)
        end
    end

    -- SIN RETROCESO
    if _G.NoRecoilEnabled then pcall(function() Mouse.Origin = CFrame.new(Camera.CFrame.Position) end) end

    -- NOCLIP
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

    -- CORRER
    if _G.CorrerEnabled and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then Seguro(function() h.WalkSpeed = math.min(VelCorrer, Antiban.VelMax) end) end
    elseif not _G.CorrerEnabled and LocalPlayer.Character then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then Seguro(function() h.WalkSpeed = 16 end) end
    end

    -- VOLAR
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

    -- ESP — SOLO VIVOS
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
print("✅ PANEL LISTO — APARECE EN EL CENTRO")
print("🔘 Botón − = Minimizar / Restaurar")
print("🔘 Botón ✕ = Ocultar todo (aparece botón ⚙️)")
print("🖱️ Arrastra la barra azul para mover el panel")
print("⌨️ Teclas de emergencia: Q=Aimbot E=ESP G=Noclip C=Correr V=Volar")
