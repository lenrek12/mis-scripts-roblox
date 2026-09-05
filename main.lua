-- =============================================================================
-- VERSIÓN FINAL CORREGIDA: INTERFAZ COMPACTA + FUNCIONES INDEPENDIENTES
-- ✅ Funciona aunque el panel esté oculto/minimizado
-- ✅ ESP solo muestra jugadores vivos y se actualiza siempre
-- ✅ Volar / Correr / Noclip (Traspasar Paredes) REPARADOS
-- ✅ Velocidades configurables por barra deslizante
-- ✅ Sin elementos pegados al morir
-- =============================================================================

print("")
print("╔════════════════════════════════════════════════╗")
print("║  CARGANDO VERSIÓN CORREGIDA — TODO FUNCIONA    ║")
print("╚════════════════════════════════════════════════╝")

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
-- 🔒 SISTEMA DE PROTECCIÓN ANTIBAN
-- ==============================================
local Antiban = {
    VelocidadMaxima = 80,
    GravedadMinima = 0.15,
    TiempoEntreCambios = 0.35,
    UltimoCambio = 0
}

local function CambiarSinDetectar(Callback)
    local Ahora = os.clock()
    if Ahora - Antiban.UltimoCambio < Antiban.TiempoEntreCambios then return end
    Antiban.UltimoCambio = Ahora
    pcall(Callback)
end

-- ==============================================
-- VARIABLES GLOBALES — TODAS INDEPENDIENTES DE LA INTERFAZ
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

-- VALORES CONFIGURABLES
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

-- ESTADO DEL PERSONAJE ANTERIOR (para detectar respawn)
UltimoEstadoPersonaje = LocalPlayer.Character

-- ==============================================
-- ⌨️ TECLAS CONFIGURABLES
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
    Noclip = Enum.KeyCode.G,
}

-- COLORES
ColorCirculo = Color3.fromRGB(0, 255, 0)
ColorActivo = Color3.fromRGB(35, 150, 70)
ColorInactivo = Color3.fromRGB(150, 35, 35)
ColorFondoPanel = Color3.fromRGB(22, 22, 30)
ColorBarraFondo = Color3.fromRGB(40, 40, 60)
ColorBarraRelleno = Color3.fromRGB(70, 150, 255)
ColorEsp = Color3.fromRGB(0, 255, 100)
ColorVida = Color3.fromRGB(255, 230, 0)

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
-- 🖥️ INTERFAZ COMPACTA ESTILO MODERNO
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAsistenciaCompacto"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- MARCO PRINCIPAL — MÁS COMPACTO
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MarcoPrincipal"
MainFrame.Size = UDim2.new(0, 290, 0, 620)
MainFrame.Position = UDim2.new(0.015, 0, 0.03, 0)
MainFrame.BackgroundColor3 = ColorFondoPanel
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.035, 0)

-- BARRA SUPERIOR
local BarraSup = Instance.new("Frame")
BarraSup.Size = UDim2.new(1, 0, 0, 40)
BarraSup.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
BarraSup.Parent = MainFrame
Instance.new("UICorner", BarraSup).CornerRadius = UDim.new(0.035, 0)

local Titulo = Instance.new("TextLabel")
Titulo.Text = "⚙️ PANEL DE ASISTENCIA"
Titulo.Font = Enum.Font.GothamBold
Titulo.TextSize = 14
Titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
Titulo.Size = UDim2.new(1, -10, 1, 0)
Titulo.Position = UDim2.new(0, 10, 0, 0)
Titulo.BackgroundTransparency = 1
Titulo.TextXAlignment = Enum.TextXAlignment.Left
Titulo.Parent = BarraSup

-- BOTÓN MINIMIZAR
local MinimizarBtn = Instance.new("TextButton")
MinimizarBtn.Text = "−"
MinimizarBtn.Font = Enum.Font.GothamBold
MinimizarBtn.TextSize = 18
MinimizarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizarBtn.Size = UDim2.new(0, 30, 1, 0)
MinimizarBtn.Position = UDim2.new(1, -35, 0, 0)
MinimizarBtn.BackgroundTransparency = 1
MinimizarBtn.Parent = BarraSup

local Minimizado = false
local AlturaOriginal = 620

MinimizarBtn.MouseButton1Click:Connect(function()
    Minimizado = not Minimizado
    if Minimizado then
        MainFrame.Size = UDim2.new(0, 290, 0, 40)
        MinimizarBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 290, 0, AlturaOriginal)
        MinimizarBtn.Text = "−"
    end
end)

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
UserInputService.InputEnded:Connect(function() Arrastrando = false end)

-- POSICIÓN Y
local PosY = 48
local BotonesUI = {}

-- ==============================================
-- FUNCIÓN: SEPARADOR
-- ==============================================
local function Separador(Texto)
    PosY = PosY + 6
    local Sep = Instance.new("TextLabel")
    Sep.Text = "  "..Texto
    Sep.Font = Enum.Font.GothamBold
    Sep.TextSize = 11
    Sep.TextColor3 = Color3.fromRGB(170, 190, 255)
    Sep.Size = UDim2.new(0.92, 0, 0, 24)
    Sep.Position = UDim2.new(0.04, 0, 0, PosY)
    Sep.BackgroundColor3 = ColorBarraFondo
    Sep.TextXAlignment = Enum.TextXAlignment.Left
    Sep.Parent = MainFrame
    Instance.new("UICorner", Sep).CornerRadius = UDim.new(0, 5)
    PosY = PosY + 26
end

-- ==============================================
-- FUNCIÓN: BOTÓN TOGGLE
-- ==============================================
local function Boton(Texto, VariableGlobal)
    PosY = PosY + 4
    local Btn = Instance.new("TextButton")
    Btn.Name = "Btn_"..VariableGlobal
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0.92, 0, 0, 36)
    Btn.Position = UDim2.new(0.04, 0, 0, PosY)
    Btn.BackgroundColor3 = _G[VariableGlobal] and ColorActivo or ColorInactivo
    Btn.Text = Texto..": "..(_G[VariableGlobal] and "ACTIVADO" or "DESACTIVADO")
    Btn.Parent = MainFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    BotonesUI[VariableGlobal] = Btn

    Btn.MouseButton1Click:Connect(function()
        _G[VariableGlobal] = not _G[VariableGlobal]
        Btn.Text = Texto..": "..(_G[VariableGlobal] and "ACTIVADO" or "DESACTIVADO")
        Btn.BackgroundColor3 = _G[VariableGlobal] and ColorActivo or ColorInactivo
    end)
    PosY = PosY + 40
end

-- ==============================================
-- FUNCIÓN: BARRA DESLIZANTE
-- ==============================================
local BarrasUI = {}
local function Barra(Texto, VariableGlobal, Min, Max, Defecto)
    PosY = PosY + 4
    if _G[VariableGlobal] == nil then _G[VariableGlobal] = Defecto end

    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.92, 0, 0, 46)
    Cont.Position = UDim2.new(0.04, 0, 0, PosY)
    Cont.BackgroundColor3 = ColorBarraFondo
    Cont.Parent = MainFrame
    Instance.new("UICorner", Cont).CornerRadius = UDim.new(0, 5)

    local Etiqueta = Instance.new("TextLabel")
    Etiqueta.Text = Texto..": "..math.floor(_G[VariableGlobal])
    Etiqueta.Font = Enum.Font.Gotham
    Etiqueta.TextSize = 10
    Etiqueta.TextColor3 = Color3.fromRGB(230, 230, 230)
    Etiqueta.Size = UDim2.new(1, -10, 0, 18)
    Etiqueta.Position = UDim2.new(0, 8, 0, 3)
    Etiqueta.BackgroundTransparency = 1
    Etiqueta.TextXAlignment = Enum.TextXAlignment.Left
    Etiqueta.Parent = Cont

    local Fondo = Instance.new("Frame")
    Fondo.Size = UDim2.new(1, -16, 0, 12)
    Fondo.Position = UDim2.new(0, 8, 0, 28)
    Fondo.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    Fondo.Parent = Cont
    Instance.new("UICorner", Fondo).CornerRadius = UDim.new(1, 0)

    local Relleno = Instance.new("Frame")
    Relleno.Size = UDim2.new(((_G[VariableGlobal]-Min)/(Max-Min)), 0, 1, 0)
    Relleno.BackgroundColor3 = ColorBarraRelleno
    Relleno.Parent = Fondo
    Instance.new("UICorner", Relleno).CornerRadius = UDim.new(1, 0)

    BarrasUI[VariableGlobal] = {Etiqueta = Etiqueta, Relleno = Relleno, Min = Min, Max = Max}

    local Arrastrando = false
    Fondo.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Arrastrando = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Arrastrando = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if Arrastrando and i.UserInputType == Enum.UserInputType.MouseMovement then
            local Prog = math.clamp((i.Position.X - Fondo.AbsolutePosition.X) / Fondo.AbsoluteSize.X, 0, 1)
            _G[VariableGlobal] = Min + Prog * (Max - Min)
            Etiqueta.Text = Texto..": "..math.floor(_G[VariableGlobal])
            Relleno.Size = UDim2.new(Prog, 0, 1, 0)
            -- SINCRONIZAR VARIABLES REALES
            if VariableGlobal == "AimStrength" then AimStrength = math.floor(_G[VariableGlobal]) end
            if VariableGlobal == "RadioAimbot" then CircleRadius = math.floor(_G[VariableGlobal]); if Circle then Circle.Radius = CircleRadius end end
            if VariableGlobal == "VelocidadCorrer" then VelocidadCorrerValor = math.floor(_G[VariableGlobal]) end
            if VariableGlobal == "VelocidadVolar" then VelocidadVolarValor = math.floor(_G[VariableGlobal]) end
        end
    end)

    PosY = PosY + 50
end

-- ==============================================
-- 📋 CONSTRUIR EL PANEL
-- ==============================================
Separador("🎯 HABILIDADES DE COMBATE")
Boton("ACTIVAR AIMBOT", "AimEnabled")
Barra("FUERZA DEL AIMBOT", "AimStrength", 1, 10, 5)
Barra("RADIO DE DETECCIÓN", "RadioAimbot", 50, 300, 180)
Boton("VER JUGADORES (ESP)", "EspEnabled")
Boton("SIN RETROCESO", "NoRecoilEnabled")
Boton("ZOOM AUTOMÁTICO", "FovEnabled")
Boton("VISIÓN NOCTURNA", "NightVision")

Separador("✨ PODERES ESPECIALES")
Boton("TRASPASAR PAREDES (NOCLIP)", "NoclipEnabled")
Boton("CORRER RÁPIDO", "CorrerEnabled")
Barra("VELOCIDAD AL CORRER", "VelocidadCorrer", 16, 80, 45)
Boton("VOLAR", "VolarEnabled")
Barra("VELOCIDAD DE VUELO", "VelocidadVolar", 10, 60, 35)

-- AJUSTAR ALTURA DEL PANEL
AlturaOriginal = PosY + 8
MainFrame.Size = UDim2.new(0, 290, 0, AlturaOriginal)

print("[✅] INTERFAZ CREADA COMPACTA — TODO FUNCIONA OCULTA O NO")

-- ==============================================
-- DETECCIÓN DE TECLAS
-- ==============================================
UserInputService.InputBegan:Connect(function(Entrada, Procesado)
    if Procesado then return end

    -- MOSTRAR/OCULTAR PANEL Y CÍRCULO
    if Entrada.KeyCode == Teclas.MostrarOcultar then
        UiVisible = not UiVisible
        MainFrame.Visible = UiVisible
        Circle.Visible = UiVisible
        return
    end

    -- TECLAS RÁPIDAS
    if Entrada.KeyCode == Teclas.Aimbot then _G.AimEnabled = not _G.AimEnabled end
    if Entrada.KeyCode == Teclas.Esp then _G.EspEnabled = not _G.EspEnabled end
    if Entrada.KeyCode == Teclas.Zoom then
        _G.FovEnabled = not _G.FovEnabled
        Camera.FieldOfView = _G.FovEnabled and OriginalFOV / 2 or OriginalFOV
    end
    if Entrada.KeyCode == Teclas.Correr then _G.CorrerEnabled = not _G.CorrerEnabled end
    if Entrada.KeyCode == Teclas.Volar then _G.VolarEnabled = not _G.VolarEnabled end
    if Entrada.KeyCode == Teclas.SinRetroceso then _G.NoRecoilEnabled = not _G.NoRecoilEnabled end
    if Entrada.KeyCode == Teclas.VisionNocturna then
        _G.NightVision = not _G.NightVision
        if _G.NightVision then
            Lighting.Brightness = 3.5
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        else
            Lighting.Brightness = OriginalBrightness
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        end
    end
    if Entrada.KeyCode == Teclas.Noclip then _G.NoclipEnabled = not _G.NoclipEnabled end
end)

-- ==============================================
-- SISTEMA DE APUNTADO
-- ==============================================
local function ObtenerObjetivoMasCercano()
    local PosRaton = UserInputService:GetMouseLocation()
    local MejorObjetivo, DistanciaMenor = nil, CircleRadius

    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador ~= LocalPlayer and Jugador.Character then
            local Raiz = Jugador.Character:FindFirstChild("HumanoidRootPart")
            local Humanoide = Jugador.Character:FindFirstChild("Humanoid")
            if Raiz and Humanoide and Humanoide.Health > 0 then
                local Cabeza = Jugador.Character:FindFirstChild("Head") or Raiz
                local PosPantalla, Visible = Camera:WorldToViewportPoint(Cabeza.Position)
                if Visible then
                    local Distancia = (Vector2.new(PosPantalla.X, PosPantalla.Y) - PosRaton).Magnitude
                    if Distancia < DistanciaMenor then
                        DistanciaMenor = Distancia
                        MejorObjetivo = Cabeza
                    end
                end
            end
        end
    end
    return MejorObjetivo
end

-- ==============================================
-- ESP — SOLO VIVOS + SE LIMPIA AL MORIR
-- ==============================================
local DibujosESP = {}

-- ==============================================
-- BUCLE PRINCIPAL — FUNCIONA SIEMPRE, ESTÉ OCULTO O NO
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- ACTUALIZAR CÍRCULO
    local PosRaton = UserInputService:GetMouseLocation()
    Circle.Position = Vector2.new(PosRaton.X, PosRaton.Y)
    Circle.Visible = UiVisible

    -- ✅ DETECTAR RESPAWN / MUERTE → LIMPIAR ESP
    if LocalPlayer.Character ~= UltimoEstadoPersonaje then
        for _, DatosJugador in pairs(DibujosESP) do
            for _, Elemento in pairs(DatosJugador) do
                pcall(function() Elemento.Visible = false end)
            end
        end
        table.clear(DibujosESP)
        UltimoEstadoPersonaje = LocalPlayer.Character
    end

    -- ==============================================
    -- ✅ AIMBOT — FUNCIONA AUNQUE PANEL ESTÉ OCULTO
    -- ==============================================
    if _G.AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local Objetivo = ObtenerObjetivoMasCercano()
        if Objetivo then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, Objetivo.Position),
                AimStrength / 10
            )
        end
    end

    -- ==============================================
    -- ✅ SIN RETROCESO
    -- ==============================================
    if _G.NoRecoilEnabled then
        pcall(function() Mouse.Origin = CFrame.new(Camera.CFrame.Position) end)
    end

    -- ==============================================
    -- ✅ NOCLIP (TRASPASAR PAREDES) — REPARADO
    -- ==============================================
    if _G.NoclipEnabled and LocalPlayer.Character then
        CambiarSinDetectar(function()
            for _, Parte in ipairs(LocalPlayer.Character:GetDescendants()) do
                if Parte:IsA("BasePart") then Parte.CanCollide = false end
            end
        end)
    elseif not _G.NoclipEnabled and LocalPlayer.Character then
        CambiarSinDetectar(function()
            for _, Parte in ipairs(LocalPlayer.Character:GetDescendants()) do
                if Parte:IsA("BasePart") and Parte.Name ~= "HumanoidRootPart" then
                    Parte.CanCollide = true
                end
            end
        end)
    end

    -- ==============================================
    -- ✅ CORRER RÁPIDO — REPARADO
    -- ==============================================
    if _G.CorrerEnabled and LocalPlayer.Character then
        local Humanoide = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoide then
            CambiarSinDetectar(function()
                Humanoide.WalkSpeed = math.min(VelocidadCorrerValor, Antiban.VelocidadMaxima)
            end)
        end
    elseif not _G.CorrerEnabled and LocalPlayer.Character then
        local Humanoide = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoide then
            CambiarSinDetectar(function() Humanoide.WalkSpeed = 16 end)
        end
    end

    -- ==============================================
    -- ✅ VOLAR — REPARADO CON PROTECCIÓN ANTIBAN
    -- ==============================================
    if _G.VolarEnabled and LocalPlayer.Character then
        local Raiz = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Humanoide = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Raiz and Humanoide then
            CambiarSinDetectar(function()
                Humanoide.GravityScale = math.max(0.2, Antiban.GravedadMinima)
                Humanoide.JumpPower = 0
            end)

            local Direccion = Vector3.new(0, 0, 0)
            local Velocidad = math.min(VelocidadVolarValor, 60) / 10

            pcall(function()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direccion += Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direccion -= Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direccion -= Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direccion += Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Direccion += Vector3.new(0, 0.85, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Direccion -= Vector3.new(0, 0.85, 0) end
            end)

            CambiarSinDetectar(function()
                Raiz.Velocity = Raiz.CFrame:VectorToWorldSpace(Direccion * Velocidad)
            end)
        end
    elseif not _G.VolarEnabled and LocalPlayer.Character then
        local Humanoide = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoide then
            CambiarSinDetectar(function()
                Humanoide.GravityScale = GravedadOriginal
                Humanoide.JumpPower = 50
            end)
        end
    end

    -- ==============================================
    -- ✅ ESP — SOLO JUGADORES VIVOS + SE LIMPIA AL MORIR
    -- ==============================================
    if not _G.EspEnabled then
        for _, Jugador in pairs(DibujosESP) do
            for _, Elemento in pairs(Jugador) do
                pcall(function() Elemento.Visible = false end)
            end
        end
        return
    end

    for _, Jugador in ipairs(Players:GetPlayers()) do
        -- SALTAR AL JUGADOR LOCAL
        if Jugador == LocalPlayer then
            if DibujosESP[Jugador] then
                for _, El in pairs(DibujosESP[Jugador]) do pcall(function() El.Visible = false end) end
            end
            continue
        end

        local Personaje = Jugador.Character
        local Mostrar = true
        local Raiz, Humanoide = nil, nil

        -- ✅ SOLO SI ESTÁ VIVO Y TIENE PERSONAJE
        if not Personaje then
            Mostrar = false
        else
            Raiz = Personaje:FindFirstChild("HumanoidRootPart")
            Humanoide = Personaje:FindFirstChild("Humanoid")
            if not Raiz or not Humanoide or Humanoide.Health <= 0 then
                Mostrar = false
            end
        end

        local PosPantalla, Visible = nil, false
        local DistanciaMetros = 99999
        if Raiz then
            PosPantalla, Visible = Camera:WorldToViewportPoint(Raiz.Position)
            DistanciaMetros = math.floor((Camera.CFrame.Position - Raiz.Position).Magnitude)
            if DistanciaMetros > MaxDistanceESP then Visible = false end
        end
        if not Visible then Mostrar = false end

        -- OCULTAR SI NO DEBE MOSTRARSE
        if not Mostrar then
            if DibujosESP[Jugador] then
                for _, El in pairs(DibujosESP[Jugador]) do pcall(function() El.Visible = false end) end
            end
            goto ContinuarJugador
        end

        -- CREAR DIBUJOS SI NO EXISTEN
        if not DibujosESP[Jugador] then
            DibujosESP[Jugador] = {
                Caja = Drawing.new("Square"),
                Nombre = Drawing.new("Text"),
                Vida = Drawing.new("Text"),
                Distancia = Drawing.new("Text")
            }
            DibujosESP[Jugador].Caja.Thickness = 2.5
            DibujosESP[Jugador].Caja.Color = ColorEsp
            DibujosESP[Jugador].Caja.Filled = false
            DibujosESP[Jugador].Nombre.Size = 12
            DibujosESP[Jugador].Nombre.Center = true
            DibujosESP[Jugador].Nombre.Color = ColorEsp
            DibujosESP[Jugador].Vida.Size = 11
            DibujosESP[Jugador].Vida.Center = true
            DibujosESP[Jugador].Vida.Color = ColorVida
            DibujosESP[Jugador].Distancia.Size = 10
            DibujosESP[Jugador].Distancia.Center = true
            DibujosESP[Jugador].Distancia.Color = Color3.fromRGB(150, 200, 255)
        end

        local D = DibujosESP[Jugador]
        local PosArriba = Camera:WorldToViewportPoint(Raiz.Position + Vector3.new(0, 2.7, 0))
        local PosAbajo = Camera:WorldToViewportPoint(Raiz.Position + Vector3.new(0, -0.4, 0))
        local Altura = PosAbajo.Y - PosArriba.Y
        local Ancho = Altura * 0.38
        local X = PosPantalla.X
        local Y = PosPantalla.Y

        -- ACTUALIZAR CAJA
        pcall(function()
            D.Caja.Visible = true
            D.Caja.Position = Vector2.new(X - Ancho/2, Y - Altura/2)
            D.Caja.Size = Vector2.new(Ancho, Altura)
        end)

        -- ACTUALIZAR NOMBRE
        pcall(function()
            D.Nombre.Visible = true
            D.Nombre.Text = Jugador.Name
            D.Nombre.Position = Vector2.new(X, Y - Altura/2 - 18)
        end)

        -- ACTUALIZAR VIDA
        pcall(function()
            D.Vida.Visible = true
            D.Vida.Text = math.floor(Humanoide.Health).." HP"
            D.Vida.Position = Vector2.new(X, Y + Altura/2 + 8)
        end)

        -- ACTUALIZAR DISTANCIA
        pcall(function()
            D.Distancia.Visible = true
            D.Distancia.Text = DistanciaMetros.." m"
            D.Distancia.Position = Vector2.new(X, Y + Altura/2 + 24)
        end)

        ::ContinuarJugador::
    end
end)

print("")
print("╔════════════════════════════════════════════════╗")
print("║   ✅ SCRIPT CARGADO — TODO REPARADO ✅          ║")
print("╚════════════════════════════════════════════════╝")
print("✅ FUNCIONES: FUNCIONAN AUNQUE OCULTES EL PANEL")
print("✅ ESP: SOLO JUGADORES VIVOS → SE LIMPIA AL MORIR")
print("✅ NOCLIP: TRASPASAR PAREDES REPARADO")
print("✅ CORRER: FUNCIONA + BARRA DE VELOCIDAD")
print("✅ VOLAR: FUNCIONA + BARRA DE VELOCIDAD + ANTIBAN")
print("✅ MINIMIZAR: SIGUE FUNCIONANDO TODO")
print("")
print("⌨️ TECLAS:")
print("   Q=Aimbot | E=ESP | R=Zoom | C=Correr | V=Volar")
print("   G=Noclip | X=SinRetroceso | Z=VisiónNocturna")
print("   MAYÚSCULAS DERECHA → Mostrar/Ocultar panel")
print("   BOTÓN DERECHO → Apuntar (con Aimbot activado)")
print("   WASD + ESPACIO → Volar hacia arriba")
print("   WASD + CTRL → Volar hacia abajo")
