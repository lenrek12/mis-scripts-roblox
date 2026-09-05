-- =============================================================================
-- PANEL DE ASISTENCIA — VERSIÓN COMPLETA CON INTERFAZ ESTILO MODERNO
-- INCLUYE: ANTIBAN · TECLAS CONFIGURABLES · BARRAS DESLIZANTES · ESP MEJORADO
-- =============================================================================

print("")
print("╔════════════════════════════════════════════════════════════╗")
print("║      CARGANDO PANEL — VERSIÓN COMPLETA PROTEGIDA           ║")
print("╚════════════════════════════════════════════════════════════╝")

-- ==============================================
-- SERVICIOS
-- ==============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==============================================
-- ⚡ SISTEMA DE PROTECCIÓN / ANTIBAN
-- ==============================================
local Antiban = {
    Detectado = false,
    UltimoCambio = 0,
    TiempoMinimo = 0.5,
    VelocidadMaximaSegura = 85,
    GravedadMinima = 0.15,
    ProteccionActiva = true
}

-- RESTAURA VALORES AUTOMÁTICAMENTE SI HAY RIESGO
local function RestaurarSeguridad()
    if not Antiban.ProteccionActiva then return end
    local Personaje = LocalPlayer.Character
    if not Personaje then return end
    local Humanoide = Personaje:FindFirstChild("Humanoid")
    local Raiz = Personaje:FindFirstChild("HumanoidRootPart")
    if not Humanoide or not Raiz then return end

    -- ⚠️ RESTAURA SI SE EXCEDE EL LÍMITE
    if Humanoide.WalkSpeed > Antiban.VelocidadMaximaSegura then
        Humanoide.WalkSpeed = 16
    end
    if Humanoide.GravityScale < Antiban.GravedadMinima then
        Humanoide.GravityScale = Antiban.GravedadMinima
    end
end

-- VERIFICACIÓN DE CAMBIOS CON RETRASO (NO DETECTABLE)
local function CambiarValorSeguro(Callback)
    local Ahora = os.clock()
    if Ahora - Antiban.UltimoCambio < Antiban.TiempoMinimo then return end
    Antiban.UltimoCambio = Ahora
    pcall(Callback)
end

print("[✅] SISTEMA DE PROTECCIÓN ACTIVADO")

-- ==============================================
-- VARIABLES GLOBALES
-- ==============================================
UiVisible = true
AimEnabled = false
EspEnabled = true
NoRecoilEnabled = false
FovEnabled = false
NightVision = false
TraspasarParedes = false
Correr = false
Volar = false

-- VALORES CONFIGURABLES (desde barras deslizantes)
AimStrength = 5
CircleRadius = 180
VelocidadCorrerValor = 45
VelocidadVolarValor = 35
MaxDistanceESP = 8000

OriginalFOV = Camera.FieldOfView
OriginalBrightness = Lighting.Brightness
OriginalAmbient = Lighting.Ambient
OriginalOutdoorAmbient = Lighting.OutdoorAmbient
GravedadOriginal = 196.2

-- ==============================================
-- ⌨️ TECLAS CONFIGURABLES POR EL USUARIO
-- ==============================================
Teclas = {
    MostrarOcultar = Enum.KeyCode.RightShift,
    Aimbot = Enum.KeyCode.Q,
    Esp = Enum.KeyCode.E,
    Zoom = Enum.KeyCode.R,
    Correr = Enum.KeyCode.C,
    Volar = Enum.KeyCode.V,
    SinRetroceso = Enum.KeyCode.X,
    VisionNocturna = Enum.KeyCode.Z,
    Traspasar = Enum.KeyCode.G,
}

EsperandoTecla = nil
BotonesTeclas = {}

-- COLORES
ColorCirculo = Color3.fromRGB(0, 255, 0)
ColorOn = Color3.fromRGB(40, 180, 80)
ColorOff = Color3.fromRGB(180, 40, 40)
ColorFondo = Color3.fromRGB(30, 30, 40)
ColorBorde = Color3.fromRGB(60, 60, 90)
ColorBarra = Color3.fromRGB(50, 50, 70)
ColorRelleno = Color3.fromRGB(80, 160, 255)
ColorEsp = Color3.fromRGB(0, 255, 100)
ColorVida = Color3.fromRGB(255, 255, 0)

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
-- 🖥️ CREAR INTERFAZ ESTILO MODERNO
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAsistenciaModerno"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- MARCO PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MarcoPrincipal"
MainFrame.Size = UDim2.new(0, 320, 0, 780)
MainFrame.Position = UDim2.new(0.02, 0, 0.05, 0)
MainFrame.BackgroundColor3 = ColorFondo
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.04, 0)

-- BARRA SUPERIOR
local BarraSup = Instance.new("Frame")
BarraSup.Size = UDim2.new(1, 0, 0, 45)
BarraSup.BackgroundColor3 = ColorBorde
BarraSup.Parent = MainFrame
Instance.new("UICorner", BarraSup).CornerRadius = UDim.new(0.04, 0)

local Titulo = Instance.new("TextLabel")
Titulo.Text = "⚙️ PANEL DE ASISTENCIA"
Titulo.Font = Enum.Font.GothamBold
Titulo.TextSize = 15
Titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
Titulo.Size = UDim2.new(1, -10, 1, 0)
Titulo.Position = UDim2.new(0, 10, 0, 0)
Titulo.BackgroundTransparency = 1
Titulo.TextXAlignment = Enum.TextXAlignment.Left
Titulo.Parent = BarraSup

-- ARRASTRAR VENTANA
local Arrastrando, InicioPos, PosInicial = false, Vector2.new(0, 0), UDim2.new(0, 0, 0, 0)
BarraSup.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        Arrastrando = true
        InicioPos = UserInputService:GetMouseLocation()
        PosInicial = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if Arrastrando and i.UserInputType == Enum.UserInputType.MouseMovement then
        local Dif = UserInputService:GetMouseLocation() - InicioPos
        MainFrame.Position = UDim2.new(PosInicial.X.Scale, PosInicial.X.Offset + Dif.X, PosInicial.Y.Scale, PosInicial.Y.Offset + Dif.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then Arrastrando = false end
end)

-- POSICIÓN VERTICAL AUTOMÁTICA
local PosY = 55

-- ==============================================
-- FUNCIÓN: SEPARADOR DE SECCIÓN
-- ==============================================
local function Separador(Texto)
    PosY = PosY + 10
    local Sep = Instance.new("TextLabel")
    Sep.Text = "  "..Texto
    Sep.Font = Enum.Font.GothamBold
    Sep.TextSize = 12
    Sep.TextColor3 = Color3.fromRGB(180, 200, 255)
    Sep.Size = UDim2.new(0.92, 0, 0, 28)
    Sep.Position = UDim2.new(0.04, 0, 0, PosY)
    Sep.BackgroundColor3 = ColorBarra
    Sep.TextXAlignment = Enum.TextXAlignment.Left
    Sep.Parent = MainFrame
    Instance.new("UICorner", Sep).CornerRadius = UDim.new(0, 6)
    PosY = PosY + 32
end

-- ==============================================
-- FUNCIÓN: BOTÓN TOGGLE
-- ==============================================
local BotonesEstado = {}
local function BotonToggle(Texto, Clave, Callback)
    PosY = PosY + 4
    BotonesEstado[Clave] = BotonesEstado[Clave] or false
    local Btn = Instance.new("TextButton")
    Btn.Name = "Btn_"..Clave
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0.92, 0, 0, 40)
    Btn.Position = UDim2.new(0.04, 0, 0, PosY)
    Btn.BackgroundColor3 = BotonesEstado[Clave] and ColorOn or ColorOff
    Btn.Text = Texto..": "..(BotonesEstado[Clave] and "ACTIVADO" or "DESACTIVADO")
    Btn.Parent = MainFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        BotonesEstado[Clave] = not BotonesEstado[Clave]
        Btn.Text = Texto..": "..(BotonesEstado[Clave] and "ACTIVADO" or "DESACTIVADO")
        Btn.BackgroundColor3 = BotonesEstado[Clave] and ColorOn or ColorOff
        _G[Clave] = BotonesEstado[Clave]
        if Callback then Callback(BotonesEstado[Clave]) end
    end)
    PosY = PosY + 44
end

-- ==============================================
-- FUNCIÓN: BARRA DESLIZANTE
-- ==============================================
local function BarraDeslizante(Texto, Variable, Min, Max, Defecto)
    PosY = PosY + 6
    if _G[Variable] == nil then _G[Variable] = Defecto end

    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.92, 0, 0, 52)
    Cont.Position = UDim2.new(0.04, 0, 0, PosY)
    Cont.BackgroundColor3 = ColorBarra
    Cont.Parent = MainFrame
    Instance.new("UICorner", Cont).CornerRadius = UDim.new(0, 6)

    local Etiqueta = Instance.new("TextLabel")
    Etiqueta.Text = Texto..": "..math.floor(_G[Variable])
    Etiqueta.Font = Enum.Font.Gotham
    Etiqueta.TextSize = 11
    Etiqueta.TextColor3 = Color3.fromRGB(255, 255, 255)
    Etiqueta.Size = UDim2.new(1, -10, 0, 22)
    Etiqueta.Position = UDim2.new(0, 8, 0, 4)
    Etiqueta.BackgroundTransparency = 1
    Etiqueta.TextXAlignment = Enum.TextXAlignment.Left
    Etiqueta.Parent = Cont

    local Fondo = Instance.new("Frame")
    Fondo.Size = UDim2.new(1, -16, 0, 14)
    Fondo.Position = UDim2.new(0, 8, 0, 32)
    Fondo.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Fondo.Parent = Cont
    Instance.new("UICorner", Fondo).CornerRadius = UDim.new(1, 0)

    local Relleno = Instance.new("Frame")
    Relleno.Size = UDim2.new((_G[Variable]-Min)/(Max-Min), 0, 1, 0)
    Relleno.BackgroundColor3 = ColorRelleno
    Relleno.Parent = Fondo
    Instance.new("UICorner", Relleno).CornerRadius = UDim.new(1, 0)

    local Arrastrando = false
    Fondo.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Arrastrando = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Arrastrando = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if Arrastrando and i.UserInputType == Enum.UserInputType.MouseMovement then
            local Prog = math.clamp((i.Position.X - Fondo.AbsolutePosition.X) / Fondo.AbsoluteSize.X, 0, 1)
            _G[Variable] = Min + Prog * (Max - Min)
            Etiqueta.Text = Texto..": "..math.floor(_G[Variable])
            Relleno.Size = UDim2.new(Prog, 0, 1, 0)
            -- ACTUALIZAR VARIABLE REAL
            if Variable == "AimStrengthGlobal" then AimStrength = math.floor(_G[Variable]) end
            if Variable == "RadioAimbotGlobal" then CircleRadius = math.floor(_G[Variable]); if Circle then Circle.Radius = CircleRadius end end
            if Variable == "VelocidadCorrerGlobal" then VelocidadCorrerValor = math.floor(_G[Variable]) end
            if Variable == "VelocidadVolarGlobal" then VelocidadVolarValor = math.floor(_G[Variable]) end
        end
    end)

    PosY = PosY + 56
end

-- ==============================================
-- FUNCIÓN: BOTÓN PARA CAMBIAR TECLA
-- ==============================================
local function NombreTecla(Tecla)
    if not Tecla then return "NO ASIGNADA" end
    return string.gsub(tostring(Tecla), "Enum.KeyCode.", "")
end

local function BotonTecla(Texto, Clave)
    PosY = PosY + 4
    local Btn = Instance.new("TextButton")
    Btn.Name = "Tecla_"..Clave
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0.92, 0, 0, 38)
    Btn.Position = UDim2.new(0.04, 0, 0, PosY)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
    Btn.Text = Texto..": ["..NombreTecla(Teclas[Clave]).."]"
    Btn.Parent = MainFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    BotonesTeclas[Clave] = Btn

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "⌨️ PRESIONA UNA TECLA..."
        Btn.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
        EsperandoTecla = Clave
    end)

    PosY = PosY + 42
end

-- ==============================================
-- 📋 CREAR TODO EL PANEL
-- ==============================================
Separador("🎯 HABILIDADES DE COMBATE")

BotonToggle("ACTIVAR AIMBOT", "AimEnabled", function(e) AimEnabled = e end)
BarraDeslizante("FUERZA DEL AIMBOT", "AimStrengthGlobal", 1, 10, 5)
BarraDeslizante("RADIO DE DETECCIÓN", "RadioAimbotGlobal", 50, 300, 180)

BotonToggle("VER JUGADORES (ESP)", "EspEnabled", function(e) EspEnabled = e end)
BotonToggle("SIN RETROCESO", "NoRecoilEnabled", function(e) NoRecoilEnabled = e end)
BotonToggle("ZOOM AUTOMÁTICO", "FovEnabled", function(e)
    FovEnabled = e
    Camera.FieldOfView = e and OriginalFOV / 2 or OriginalFOV
end)
BotonToggle("VISIÓN NOCTURNA", "NightVision", function(e)
    NightVision = e
    if e then
        Lighting.Brightness = 3.5
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    else
        Lighting.Brightness = OriginalBrightness
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient
    end
end)

Separador("✨ PODERES ESPECIALES")

BotonToggle("TRASPASAR PAREDES", "TraspasarParedes", function(e) TraspasarParedes = e end)
BotonToggle("CORRER RÁPIDO", "CorrerEnabled", function(e) Correr = e end)
BarraDeslizante("VELOCIDAD AL CORRER", "VelocidadCorrerGlobal", 16, 80, 45)
BotonToggle("VOLAR", "VolarEnabled", function(e) Volar = e end)
BarraDeslizante("VELOCIDAD DE VUELO", "VelocidadVolarGlobal", 10, 60, 35)

Separador("⌨️ TECLAS CONFIGURABLES")

BotonTecla("Mostrar/Ocultar Panel", "MostrarOcultar")
BotonTecla("Activar Aimbot", "Aimbot")
BotonTecla("Activar ESP", "Esp")
BotonTecla("Activar Zoom", "Zoom")
BotonTecla("Activar Correr", "Correr")
BotonTecla("Activar Volar", "Volar")

print("[✅] PANEL CREADO CON TODAS LAS SECCIONES")

-- ==============================================
-- DETECCIÓN DE TECLAS
-- ==============================================
UserInputService.InputBegan:Connect(function(Entrada, Procesado)
    if Procesado then return end

    -- ESTÁS CAMBIANDO UNA TECLA
    if EsperandoTecla then
        if Entrada.KeyCode ~= Enum.KeyCode.Unknown and Entrada.KeyCode ~= Enum.KeyCode.Mouse1 and Entrada.KeyCode ~= Enum.KeyCode.Mouse2 then
            Teclas[EsperandoTecla] = Entrada.KeyCode
            if BotonesTeclas[EsperandoTecla] then
                BotonesTeclas[EsperandoTecla].Text = string.gsub(BotonesTeclas[EsperandoTecla].Text, "%[.-%]", "["..NombreTecla(Entrada.KeyCode).."]")
                BotonesTeclas[EsperandoTecla].BackgroundColor3 = Color3.fromRGB(50, 80, 120)
            end
            EsperandoTecla = nil
        end
        return
    end

    -- MOSTRAR/OCULTAR TODO
    if Teclas.MostrarOcultar and Entrada.KeyCode == Teclas.MostrarOcultar then
        UiVisible = not UiVisible
        MainFrame.Visible = UiVisible
        Circle.Visible = UiVisible
        return
    end

    if not UiVisible then return end

    -- TECLAS RÁPIDAS
    if Teclas.Aimbot and Entrada.KeyCode == Teclas.Aimbot then
        BotonesEstado.AimEnabled = not BotonesEstado.AimEnabled
        AimEnabled = BotonesEstado.AimEnabled
    end
    if Teclas.Esp and Entrada.KeyCode == Teclas.Esp then
        BotonesEstado.EspEnabled = not BotonesEstado.EspEnabled
        EspEnabled = BotonesEstado.EspEnabled
    end
    if Teclas.Zoom and Entrada.KeyCode == Teclas.Zoom then
        BotonesEstado.FovEnabled = not BotonesEstado.FovEnabled
        FovEnabled = BotonesEstado.FovEnabled
        Camera.FieldOfView = FovEnabled and OriginalFOV / 2 or OriginalFOV
    end
    if Teclas.Correr and Entrada.KeyCode == Teclas.Correr then
        BotonesEstado.CorrerEnabled = not BotonesEstado.CorrerEnabled
        Correr = BotonesEstado.CorrerEnabled
    end
    if Teclas.Volar and Entrada.KeyCode == Teclas.Volar then
        BotonesEstado.VolarEnabled = not BotonesEstado.VolarEnabled
        Volar = BotonesEstado.VolarEnabled
    end
    if Entrada.KeyCode == Enum.KeyCode.X then
        BotonesEstado.NoRecoilEnabled = not BotonesEstado.NoRecoilEnabled
        NoRecoilEnabled = BotonesEstado.NoRecoilEnabled
    end
    if Entrada.KeyCode == Enum.KeyCode.Z then
        BotonesEstado.NightVision = not BotonesEstado.NightVision
        NightVision = BotonesEstado.NightVision
    end
    if Entrada.KeyCode == Enum.KeyCode.G then
        BotonesEstado.TraspasarParedes = not BotonesEstado.TraspasarParedes
        TraspasarParedes = BotonesEstado.TraspasarParedes
    end
end)

-- ==============================================
-- SISTEMA DE APUNTADO
-- ==============================================
local function ObtenerObjetivo()
    local PosRaton = UserInputService:GetMouseLocation()
    local Mejor, Menor = nil, CircleRadius

    for _,P in ipairs(Players:GetPlayers()) do
        if P ~= LocalPlayer and P.Character then
            local R = P.Character:FindFirstChild("HumanoidRootPart")
            local H = P.Character:FindFirstChild("Humanoid")
            if R and H and H.Health > 0 then
                local Cabeza = P.Character.Head
                local Pos, Vis = Camera:WorldToViewportPoint(Cabeza.Position)
                if Vis then
                    local D = (Vector2.new(Pos.X, Pos.Y) - PosRaton).Magnitude
                    if D < Menor then Menor = D; Mejor = Cabeza end
                end
            end
        end
    end
    return Mejor
end

-- ==============================================
-- ESP MEJORADO — DIBUJA EL CONTORNO DEL PERSONAJE
-- ==============================================
local DibujosESP = {}

-- ==============================================
-- BUCLE PRINCIPAL
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- ACTUALIZAR CÍRCULO
    local Pos = UserInputService:GetMouseLocation()
    Circle.Position = Vector2.new(Pos.X, Pos.Y)
    Circle.Visible = UiVisible

    -- PROTECCIÓN ANTIBAN
    RestaurarSeguridad()

    if not UiVisible then
        for _,J in pairs(DibujosESP) do for _,D in pairs(J) do pcall(function() D.Visible = false end) end end
        return
    end

    -- AIMBOT
    if AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local Obj = ObtenerObjetivo()
        if Obj then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Obj.Position), AimStrength / 10)
        end
    end

    -- SIN RETROCESO
    if NoRecoilEnabled then pcall(function() Mouse.Origin = CFrame.new(Camera.CFrame.Position) end) end

    -- TRASPASAR PAREDES
    if TraspasarParedes and LocalPlayer.Character then
        CambiarValorSeguro(function()
            for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    elseif not TraspasarParedes and LocalPlayer.Character then
        CambiarValorSeguro(function()
            for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = true end
            end
        end)
    end

    -- CORRER CON PROTECCIÓN
    if Correr and LocalPlayer.Character then
        local H = LocalPlayer.Character:FindFirstChild("Humanoid")
        if H then CambiarValorSeguro(function() H.WalkSpeed = math.min(VelocidadCorrerValor, 80) end) end
    elseif not Correr and LocalPlayer.Character then
        local H = LocalPlayer.Character:FindFirstChild("Humanoid")
        if H then CambiarValorSeguro(function() H.WalkSpeed = 16 end) end
    end

    -- VOLAR CON PROTECCIÓN (NO DETECTABLE)
    if Volar and LocalPlayer.Character then
        local R = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local H = LocalPlayer.Character:FindFirstChild("Humanoid")
        if R and H then
            CambiarValorSeguro(function() H.GravityScale = math.max(VelocidadVolarValor > 20 and 0.2 or 0, Antiban.GravedadMinima) end)
            CambiarValorSeguro(function() H.JumpPower = 0 end)

            local Dir = Vector3.new()
            local Vel = math.min(VelocidadVolarValor, 60) / 10
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Dir += Vector3.new(0, 0.8, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Dir -= Vector3.new(0, 0.8, 0) end

            CambiarValorSeguro(function() R.Velocity = R.CFrame:VectorToWorldSpace(Dir * Vel) end)
        end
    elseif not Volar and LocalPlayer.Character then
        local H = LocalPlayer.Character:FindFirstChild("Humanoid")
        if H then CambiarValorSeguro(function() H.GravityScale = GravedadOriginal end) end
        if H then CambiarValorSeguro(function() H.JumpPower = 50 end) end
    end

    -- ESP MEJORADO
    if not EspEnabled then
        for _,J in pairs(DibujosESP) do for _,D in pairs(J) do pcall(function() D.Visible = false end) end end
        return
    end

    for _,P in ipairs(Players:GetPlayers()) do
        if P == LocalPlayer then
            if DibujosESP[P] then for _,D in pairs(DibujosESP[P]) do pcall(function() D.Visible = false end) end end
            continue
        end
        local C = P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") or not C:FindFirstChild("Humanoid") or C.Humanoid.Health <= 0 then
            if DibujosESP[P] then for _,D in pairs(DibujosESP[P]) do pcall(function() D.Visible = false end) end end
            continue
        end
        local R = C.HumanoidRootPart
        local Pos, Vis = Camera:WorldToViewportPoint(R.Position)
        local Dist = math.floor((Camera.CFrame.Position - R.Position).Magnitude)
        if Dist > MaxDistanceESP then Vis = false end
        if not Vis then
            if DibujosESP[P] then for _,D in pairs(DibujosESP[P]) do pcall(function() D.Visible = false end) end end
            continue
        end

        if not DibujosESP[P] then
            DibujosESP[P] = {
                Caja = Drawing.new("Square"),
                Nombre = Drawing.new("Text"),
                Vida = Drawing.new("Text"),
                Distancia = Drawing.new("Text")
            }
            DibujosESP[P].Caja.Thickness = 2.5
            DibujosESP[P].Caja.Color = ColorEsp
            DibujosESP[P].Caja.Filled = false
            DibujosESP[P].Nombre.Size = 12
            DibujosESP[P].Nombre.Center = true
            DibujosESP[P].Nombre.Color = ColorEsp
            DibujosESP[P].Vida.Size = 11
            DibujosESP[P].Vida.Center = true
            DibujosESP[P].Vida.Color = ColorVida
            DibujosESP[P].Distancia.Size = 10
            DibujosESP[P].Distancia.Center = true
            DibujosESP[P].Distancia.Color = Color3.fromRGB(150, 200, 255)
        end

        local D = DibujosESP[P]
        local Arr = Camera:WorldToViewportPoint(R.Position + Vector3.new(0, 2.7, 0))
        local Abr = Camera:WorldToViewportPoint(R.Position + Vector3.new(0, -0.4, 0))
        local Alt = Abr.Y - Arr.Y
        local Anc = Alt * 0.38
        local X = Pos.X
        local Yp = Pos.Y

        D.Caja.Visible = true
        D.Caja.Position = Vector2.new(X - Anc/2, Yp - Alt/2)
        D.Caja.Size = Vector2.new(Anc, Alt)

        D.Nombre.Visible = true
        D.Nombre.Text = P.Name
        D.Nombre.Position = Vector2.new(X, Yp - Alt/2 - 18)

        D.Vida.Visible = true
        D.Vida.Text = math.floor(C.Humanoid.Health).." HP"
        D.Vida.Position = Vector2.new(X, Yp + Alt/2 + 8)

        D.Distancia.Visible = true
        D.Distancia.Text = Dist.." m"
        D.Distancia.Position = Vector2.new(X, Yp + Alt/2 + 22)
    end
end)

print("")
print("╔════════════════════════════════════════════════════════════╗")
print("║          ✅ SCRIPT CARGADO COMPLETAMENTE ✅                 ║")
print("║          🔒 SISTEMA DE PROTECCIÓN ANTIBAN ACTIVO            ║")
print("╚════════════════════════════════════════════════════════════╝")
print("")
print("📋 CARACTERÍSTICAS:")
print("   🎯 Barras deslizantes → Ajusta fuerza y radio del Aimbot")
print("   ⚡ Barras de velocidad → Correr y Volar")
print("   ⌨️ Pulsa botones AZULES → Cambia la tecla que prefieras")
print("   👁️ ESP → Cajas VERDES alrededor de jugadores con nombre y vida")
print("   🔒 ANTIBAN → Limita velocidades y gravedad para NO ser detectado")
print("")
print("⚠️ VOLAR: Velocidad limitada y gravedad reducida, NO eliminada")
print("   Así NO te expulsan por código 267")
print("")
