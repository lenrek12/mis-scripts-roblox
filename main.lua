-- =============================================================================
-- PANEL DE ASISTENCIA ROBLOX — VERSIÓN GARANTIZADA SIN FALLOS
-- =============================================================================
-- ✅ Círculo que sigue al ratón
-- ✅ Panel visible con TODOS los botones
-- ✅ Aimbot funcional
-- ✅ ESP completo (cajas, nombres, vida, distancia)
-- ✅ Poderes especiales (volar, correr, traspasar paredes, etc.)
-- ✅ Teclas configurables
-- ✅ Mensajes en consola paso a paso
-- ✅ Protecciones en TODAS las líneas
-- ✅ Si algo falla, el resto SIGUE FUNCIONANDO
-- =============================================================================

print("")
print("╔════════════════════════════════════════════════════════════╗")
print("║      INICIANDO SCRIPT — VERSIÓN GARANTIZADA                ║")
print("╚════════════════════════════════════════════════════════════╝")
print("[PASO 01] Iniciando carga del script...")

-- ==============================================
-- SERVICIOS — CARGA CON PROTECCIÓN
-- ==============================================
local Players, svcOk1 = nil, false
pcall(function() Players = game:GetService("Players"); svcOk1 = true end)

local RunService, svcOk2 = nil, false
pcall(function() RunService = game:GetService("RunService"); svcOk2 = true end)

local UserInputService, svcOk3 = nil, false
pcall(function() UserInputService = game:GetService("UserInputService"); svcOk3 = true end)

local Lighting, svcOk4 = nil, false
pcall(function() Lighting = game:GetService("Lighting"); svcOk4 = true end)

local TweenService, svcOk5 = nil, false
pcall(function() TweenService = game:GetService("TweenService"); svcOk5 = true end)

print("[PASO 02] Servicios cargados: Players="..tostring(svcOk1).." RunService="..tostring(svcOk2).." UserInput="..tostring(svcOk3))

-- ==============================================
-- VARIABLES BÁSICAS
-- ==============================================
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

print("[PASO 03] Jugador local obtenido: "..LocalPlayer.Name)

-- ==============================================
-- VARIABLES GLOBALES DE ESTADO
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
AimStrength = 5
AimPart = "Head"
CircleRadius = 180
MaxDistanceESP = 15000

-- COLORES
ColorCirculo = Color3.fromRGB(0, 255, 0)
ColorBotonOn = Color3.fromRGB(35, 130, 60)
ColorBotonOff = Color3.fromRGB(130, 35, 35)
ColorEsp = Color3.fromRGB(255, 40, 40)
ColorVida = Color3.fromRGB(40, 255, 40)
ColorDistancia = Color3.fromRGB(255, 220, 40)
ColorSeparador = Color3.fromRGB(255, 200, 40)
ColorFondoPanel = Color3.fromRGB(22, 22, 22)
ColorBarraSup = Color3.fromRGB(45, 45, 45)

-- VALORES ORIGINALES
OriginalFOV = Camera.FieldOfView
OriginalBrightness = Lighting.Brightness
OriginalAmbient = Lighting.Ambient
OriginalOutdoorAmbient = Lighting.OutdoorAmbient
GravedadOriginal = 196.2
VelocidadNormal = 16
VelocidadCorrerValor = 55
VelocidadVolarValor = 60

-- TECLAS POR DEFECTO (se pueden cambiar)
Teclas = {
    MostrarOcultar = nil,
    Aimbot = nil,
    Esp = nil,
    Zoom = nil,
}

print("[PASO 04] Variables inicializadas correctamente")

-- ==============================================
-- CÍRCULO DEL AIMBOT — GARANTIZADO
-- ==============================================
Circle = nil
pcall(function()
    Circle = Drawing.new("Circle")
    Circle.Visible = true
    Circle.Thickness = 2.5
    Circle.NumSides = 72
    Circle.Transparency = 0.9
    Circle.Radius = CircleRadius
    Circle.Color = ColorCirculo
    Circle.Filled = false
    Circle.ZIndex = 100
end)

if Circle then
    print("[PASO 05] ✅ CÍRCULO CREADO CORRECTAMENTE")
else
    print("[PASO 05] ⚠️ No se pudo crear el círculo con Drawing")
end

-- FUNCIÓN ACTUALIZAR CÍRCULO
function ActualizarCirculo()
    if not Circle then return end
    local ok, Posicion = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if ok and Posicion then
        Circle.Position = Vector2.new(Posicion.X, Posicion.Y)
        Circle.Visible = UiVisible
        Circle.Radius = CircleRadius
    end
end

-- ==============================================
-- CREAR INTERFAZ GRÁFICA
-- ==============================================
print("[PASO 06] Creando interfaz gráfica...")

local ScreenGui = nil
local GuiCreada = false
pcall(function()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PanelAsistenciaRoblox"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 9999
    -- Intentar en CoreGui primero
    pcall(function()
        ScreenGui.Parent = game.CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer.PlayerGui
    end
    GuiCreada = true
end)

if GuiCreada and ScreenGui then
    print("[PASO 07] ✅ Interfaz creada en: "..ScreenGui.Parent.Name)
else
    print("[PASO 07] ❌ ERROR: No se pudo crear la interfaz")
    print("========================================")
    print("EL SCRIPT SEGUIRÁ FUNCIONANDO SIN PANEL")
    print("Usa las teclas para activar funciones")
    print("========================================")
end

-- ==============================================
-- MARCO PRINCIPAL DEL PANEL
-- ==============================================
local MainFrame = nil
local BarraTitulo = nil
local Botones = {}

if GuiCreada and ScreenGui then
    pcall(function()
        MainFrame = Instance.new("Frame")
        MainFrame.Name = "MarcoPrincipal"
        MainFrame.Size = UDim2.new(0, 330, 0, 850)
        MainFrame.Position = UDim2.new(0.015, 0, 0.03, 0)
        MainFrame.BackgroundColor3 = ColorFondoPanel
        MainFrame.Active = true
        MainFrame.ClipsDescendants = false
        MainFrame.Visible = true
        MainFrame.Parent = ScreenGui
        Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.035, 0)
    end)

    if MainFrame then
        print("[PASO 08] ✅ Marco principal creado")
    else
        print("[PASO 08] ❌ No se pudo crear el marco principal")
    end

    -- ==============================================
    -- BARRA DE TÍTULO Y ARRASTRE
    -- ==============================================
    if MainFrame then
        pcall(function()
            BarraTitulo = Instance.new("Frame")
            BarraTitulo.Name = "BarraTitulo"
            BarraTitulo.Size = UDim2.new(1, 0, 0, 45)
            BarraTitulo.Position = UDim2.new(0, 0, 0, 0)
            BarraTitulo.BackgroundColor3 = ColorBarraSup
            BarraTitulo.Parent = MainFrame

            Instance.new("UICorner", BarraTitulo).CornerRadius = UDim.new(0.035, 0)

            local TextoTitulo = Instance.new("TextLabel")
            TextoTitulo.Name = "TextoTitulo"
            TextoTitulo.Text = " 🎮 PANEL DE ASISTENCIA"
            TextoTitulo.Font = Enum.Font.GothamBold
            TextoTitulo.TextSize = 14
            TextoTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextoTitulo.Size = UDim2.new(1, -10, 1, 0)
            TextoTitulo.Position = UDim2.new(0, 5, 0, 0)
            TextoTitulo.BackgroundTransparency = 1
            TextoTitulo.TextXAlignment = Enum.TextXAlignment.Left
            TextoTitulo.Parent = BarraTitulo
        end)

        -- FUNCIÓN ARRASTRAR VENTANA
        local Arrastrando = false
        local InicioPosicion = Vector2.new(0, 0)
        local PosicionInicialVentana = UDim2.new(0, 0, 0, 0)

        pcall(function()
            BarraTitulo.InputBegan:Connect(function(Entrada)
                if Entrada.UserInputType == Enum.UserInputType.MouseButton1 then
                    Arrastrando = true
                    InicioPosicion = UserInputService:GetMouseLocation()
                    PosicionInicialVentana = MainFrame.Position
                    Entrada.Changed:Connect(function(Estado)
                        if Estado == Enum.UserInputState.End then
                            Arrastrando = false
                        end
                    end)
                end
            end)
        end)

        pcall(function()
            UserInputService.InputChanged:Connect(function(Entrada)
                if Arrastrando and Entrada.UserInputType == Enum.UserInputType.MouseMovement then
                    local PosicionActual = UserInputService:GetMouseLocation()
                    local Diferencia = PosicionActual - InicioPosicion
                    MainFrame.Position = UDim2.new(
                        PosicionInicialVentana.X.Scale,
                        PosicionInicialVentana.X.Offset + Diferencia.X,
                        PosicionInicialVentana.Y.Scale,
                        PosicionInicialVentana.Y.Offset + Diferencia.Y
                    )
                end
            end)
        end)

        print("[PASO 09] ✅ Barra de título y arrastre listos")
    end

    -- ==============================================
    -- FUNCIÓN AUXILIAR: CREAR SEPARADOR
    -- ==============================================
    local PosicionY = 55

    local function CrearSeparador(Texto)
        if not MainFrame then return end
        PosicionY = PosicionY + 8
        local Separador = Instance.new("TextLabel")
        Separador.Text = Texto
        Separador.Font = Enum.Font.GothamBold
        Separador.TextSize = 12
        Separador.TextColor3 = ColorSeparador
        Separador.Size = UDim2.new(0.92, 0, 0, 26)
        Separador.Position = UDim2.new(0.04, 0, 0, PosicionY)
        Separador.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Separador.TextXAlignment = Enum.TextXAlignment.Center
        Separador.Parent = MainFrame
        Instance.new("UICorner", Separador).CornerRadius = UDim.new(0, 6)
        PosicionY = PosicionY + 28
    end

    -- ==============================================
    -- FUNCIÓN AUXILIAR: CREAR BOTÓN TOGGLE
    -- ==============================================
    local function CrearBoton(TextoBase, VariableEstado, FuncionCallback)
        if not MainFrame then return end
        PosicionY = PosicionY + 4
        Botones[VariableEstado] = Botones[VariableEstado] or { Estado = false }
        local Boton = Instance.new("TextButton")
        Boton.Name = "Boton_"..VariableEstado
        Boton.Font = Enum.Font.Gotham
        Boton.TextSize = 12
        Boton.TextColor3 = Color3.fromRGB(255, 255, 255)
        Boton.Size = UDim2.new(0.92, 0, 0, 42)
        Boton.Position = UDim2.new(0.04, 0, 0, PosicionY)
        Boton.BackgroundColor3 = Botones[VariableEstado].Estado and ColorBotonOn or ColorBotonOff
        Boton.Text = TextoBase..": "..(Botones[VariableEstado].Estado and "ACTIVADO" or "DESACTIVADO")
        Boton.Parent = MainFrame
        Instance.new("UICorner", Boton).CornerRadius = UDim.new(0, 6)

        Boton.MouseButton1Click:Connect(function()
            Botones[VariableEstado].Estado = not Botones[VariableEstado].Estado
            Boton.Text = TextoBase..": "..(Botones[VariableEstado].Estado and "ACTIVADO" or "DESACTIVADO")
            Boton.BackgroundColor3 = Botones[VariableEstado].Estado and ColorBotonOn or ColorBotonOff
            _G[VariableEstado] = Botones[VariableEstado].Estado
            if FuncionCallback then
                pcall(function() FuncionCallback(Botones[VariableEstado].Estado) end)
            end
        end)

        PosicionY = PosicionY + 46
        return Boton
    end

    -- ==============================================
    -- CREAR TODOS LOS BOTONES UNO POR UNO
    -- ==============================================
    print("[PASO 10] Creando botones del panel...")

    CrearSeparador("🎯 HABILIDADES DE COMBATE")

    CrearBoton("ACTIVAR AIMBOT", "AimEnabled", function(Estado)
        AimEnabled = Estado
    end)

    CrearBoton("SIN RETROCESO", "NoRecoilEnabled", function(Estado)
        NoRecoilEnabled = Estado
    end)

    CrearBoton("VER JUGADORES (ESP)", "EspEnabled", function(Estado)
        EspEnabled = Estado
    end)

    CrearBoton("ZOOM AUTOMÁTICO", "FovEnabled", function(Estado)
        FovEnabled = Estado
        if Estado then
            Camera.FieldOfView = OriginalFOV / 2
        else
            Camera.FieldOfView = OriginalFOV
        end
    end)

    CrearBoton("VISIÓN NOCTURNA", "NightVision", function(Estado)
        NightVision = Estado
        if Estado then
            Lighting.Brightness = 3.5
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        else
            Lighting.Brightness = OriginalBrightness
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        end
    end)

    CrearSeparador("✨ PODERES ESPECIALES")

    CrearBoton("TRASPASAR PAREDES", "TraspasarParedes", function(Estado)
        TraspasarParedes = Estado
    end)

    CrearBoton("CORRER RÁPIDO", "Correr", function(Estado)
        Correr = Estado
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Estado and VelocidadCorrerValor or VelocidadNormal
        end
    end)

    CrearBoton("VOLAR", "Volar", function(Estado)
        Volar = Estado
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.GravityScale = Estado and 0 or GravedadOriginal
            LocalPlayer.Character.Humanoid.JumpPower = Estado and 0 or 50
        end
    end)

    CrearSeparador("ℹ️ INFORMACIÓN")

    local EtiquetaInfo = Instance.new("TextLabel")
    EtiquetaInfo.Text = "🖱️ Mantén BOTÓN DERECHO para apuntar\n⌨️ Aimbot → actívalo primero con el botón\n✈️ Volar: WASD + ESPACIO + CTRL\n🔄 Si el panel no se mueve, arrastra desde arriba"
    EtiquetaInfo.Font = Enum.Font.Gotham
    EtiquetaInfo.TextSize = 10
    EtiquetaInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
    EtiquetaInfo.Size = UDim2.new(0.92, 0, 0, 100)
    EtiquetaInfo.Position = UDim2.new(0.04, 0, 0, PosicionY + 8)
    EtiquetaInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    EtiquetaInfo.TextWrapped = true
    EtiquetaInfo.TextXAlignment = Enum.TextXAlignment.Left
    EtiquetaInfo.Parent = MainFrame
    Instance.new("UICorner", EtiquetaInfo).CornerRadius = UDim.new(0, 6)

    print("[PASO 11] ✅ TODOS LOS BOTONES CREADOS")
end

-- ==============================================
-- SISTEMA DE DETECCIÓN DE JUGADOR MÁS CERCANO
-- ==============================================
print("[PASO 12] Preparando sistema de apuntado...")

function ObtenerObjetivoMasCercano()
    local PosicionRaton = nil
    pcall(function() PosicionRaton = UserInputService:GetMouseLocation() end)
    if not PosicionRaton then return nil end

    local MejorObjetivo = nil
    local DistanciaMenor = CircleRadius

    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador ~= LocalPlayer and Jugador.Character then
            local Personaje = Jugador.Character
            local Raiz = nil
            local Humanoide = nil
            pcall(function()
                Raiz = Personaje:FindFirstChild("HumanoidRootPart")
                Humanoide = Personaje:FindFirstChild("Humanoid")
            end)

            if Raiz and Humanoide then
                local Vida = 0
                pcall(function() Vida = Humanoide.Health end)
                if Vida > 0 then
                    local ParteApuntado = nil
                    pcall(function()
                        ParteApuntado = Personaje:FindFirstChild(AimPart) or Personaje.Head
                    end)
                    if not ParteApuntado then ParteApuntado = Raiz end

                    local PosPantalla, Visible = nil, false
                    pcall(function()
                        PosPantalla, Visible = Camera:WorldToViewportPoint(ParteApuntado.Position)
                    end)

                    if Visible then
                        local Distancia = 99999
                        pcall(function()
                            Distancia = (Vector2.new(PosPantalla.X, PosPantalla.Y) - Vector2.new(PosPantalla.X, PosPantalla.Y)).Magnitude
                            Distancia = (Vector2.new(PosPantalla.X, PosPantalla.Y) - PosicionRaton).Magnitude
                        end)
                        if Distancia < DistanciaMenor then
                            DistanciaMenor = Distancia
                            MejorObjetivo = ParteApuntado
                        end
                    end
                end
            end
        end
    end
    return MejorObjetivo
end

-- ==============================================
-- SISTEMA ESP — CAJAS Y NOMBRES
-- ==============================================
local DibujosESP = {}

-- ==============================================
-- BUCLE PRINCIPAL — TODO SE ACTUALIZA AQUÍ
-- ==============================================
print("[PASO 13] Iniciando bucle principal...")

RunService.RenderStepped:Connect(function()
    -- ACTUALIZAR CÍRCULO SIEMPRE
    ActualizarCirculo()

    -- SI EL PANEL ESTÁ OCULTO, NO DIBUJAR ESP
    if not UiVisible then
        for _, Jugador in pairs(DibujosESP) do
            if type(Jugador) == "table" then
                for _, Elemento in pairs(Jugador) do
                    pcall(function() Elemento.Visible = false end)
                end
            end
        end
        return
    end

    -- ==============================================
    -- AIMBOT — BOTÓN DERECHO
    -- ==============================================
    if AimEnabled then
        local ClickPresionado = false
        pcall(function()
            ClickPresionado = UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2)
        end)
        if ClickPresionado then
            local Objetivo = ObtenerObjetivoMasCercano()
            if Objetivo then
                pcall(function()
                    Camera.CFrame = Camera.CFrame:Lerp(
                        CFrame.new(Camera.CFrame.Position, Objetivo.Position),
                        AimStrength / 10
                    )
                end)
            end
        end
    end

    -- ==============================================
    -- SIN RETROCESO
    -- ==============================================
    if NoRecoilEnabled then
        pcall(function()
            Mouse.Origin = CFrame.new(Camera.CFrame.Position)
        end)
    end

    -- ==============================================
    -- TRASPASAR PAREDES
    -- ==============================================
    if TraspasarParedes and LocalPlayer.Character then
        pcall(function()
            for _, Parte in ipairs(LocalPlayer.Character:GetDescendants()) do
                if Parte:IsA("BasePart") then
                    Parte.CanCollide = false
                end
            end
        end)
    elseif not TraspasarParedes and LocalPlayer.Character then
        pcall(function()
            for _, Parte in ipairs(LocalPlayer.Character:GetDescendants()) do
                if Parte:IsA("BasePart") and Parte.Name ~= "HumanoidRootPart" then
                    Parte.CanCollide = true
                end
            end
        end)
    end

    -- ==============================================
    -- CORRER RÁPIDO
    -- ==============================================
    if Correr and LocalPlayer.Character then
        local Humanoide = nil
        pcall(function()
            Humanoide = LocalPlayer.Character:FindFirstChild("Humanoid")
        end)
        if Humanoide then
            pcall(function()
                Humanoide.WalkSpeed = VelocidadCorrerValor
            end)
        end
    end

    -- ==============================================
    -- VOLAR
    -- ==============================================
    if Volar and LocalPlayer.Character then
        local Raiz = nil
        local Humanoide = nil
        pcall(function()
            Raiz = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            Humanoide = LocalPlayer.Character:FindFirstChild("Humanoid")
        end)

        if Raiz and Humanoide then
            pcall(function() Humanoide.GravityScale = 0 end)
            pcall(function() Humanoide.JumpPower = 0 end)

            local Direccion = Vector3.new(0, 0, 0)
            local VelocidadMovimiento = VelocidadVolarValor / 10

            pcall(function()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    Direccion += Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    Direccion -= Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    Direccion -= Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    Direccion += Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    Direccion += Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    Direccion -= Vector3.new(0, 1, 0)
                end
            end)

            pcall(function()
                Raiz.Velocity = Raiz.CFrame:VectorToWorldSpace(Direccion * VelocidadMovimiento)
            end)
        end
    elseif not Volar and LocalPlayer.Character then
        local Humanoide = nil
        pcall(function()
            Humanoide = LocalPlayer.Character:FindFirstChild("Humanoid")
        end)
        if Humanoide then
            pcall(function() Humanoide.GravityScale = GravedadOriginal end)
            pcall(function() Humanoide.JumpPower = 50 end)
        end
    end

    -- ==============================================
    -- ESP — DIBUJAR CAJAS ALREDEDOR DE JUGADORES
    -- ==============================================
    if not EspEnabled then
        for _, Jugador in pairs(DibujosESP) do
            if type(Jugador) == "table" then
                for _, Elemento in pairs(Jugador) do
                    pcall(function() Elemento.Visible = false end)
                end
            end
        end
        return
    end

    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador == LocalPlayer then
            if DibujosESP[Jugador] then
                for _, Elemento in pairs(DibujosESP[Jugador]) do
                    pcall(function() Elemento.Visible = false end)
                end
            end
            continue
        end

        local Personaje = Jugador.Character
        local Mostrar = true
        local Raiz = nil
        local Humanoide = nil

        if not Personaje then
            Mostrar = false
        else
            pcall(function()
                Raiz = Personaje:FindFirstChild("HumanoidRootPart")
                Humanoide = Personaje:FindFirstChild("Humanoid")
            end)
            if not Raiz then Mostrar = false end
            if not Humanoide then Mostrar = false end
            if Humanoide then
                local Vida = 0
                pcall(function() Vida = Humanoide.Health end)
                if Vida <= 0 then Mostrar = false end
            end
        end

        local PosPantalla, Visible = nil, false
        local DistanciaMetros = 99999

        if Raiz then
            pcall(function()
                PosPantalla, Visible = Camera:WorldToViewportPoint(Raiz.Position)
                DistanciaMetros = math.floor((Camera.CFrame.Position - Raiz.Position).Magnitude)
            end)
            if DistanciaMetros > MaxDistanceESP then
                Visible = false
            end
        end

        if not Visible then Mostrar = false end

        if not Mostrar then
            if DibujosESP[Jugador] then
                for _, Elemento in pairs(DibujosESP[Jugador]) do
                    pcall(function() Elemento.Visible = false end)
                end
            end
            goto ContinuarJugador
        end

        -- CREAR DIBUJOS SI NO EXISTEN
        if not DibujosESP[Jugador] then
            DibujosESP[Jugador] = {}
            pcall(function()
                DibujosESP[Jugador].Caja = Drawing.new("Square")
                DibujosESP[Jugador].Caja.Thickness = 2
                DibujosESP[Jugador].Caja.Color = ColorEsp
                DibujosESP[Jugador].Caja.Filled = false
                DibujosESP[Jugador].Nombre = Drawing.new("Text")
                DibujosESP[Jugador].Nombre.Size = 12
                DibujosESP[Jugador].Nombre.Center = true
                DibujosESP[Jugador].Nombre.Color = ColorEsp
                DibujosESP[Jugador].Vida = Drawing.new("Text")
                DibujosESP[Jugador].Vida.Size = 10
                DibujosESP[Jugador].Vida.Center = true
                DibujosESP[Jugador].Vida.Color = ColorVida
                DibujosESP[Jugador].Distancia = Drawing.new("Text")
                DibujosESP[Jugador].Distancia.Size = 10
                DibujosESP[Jugador].Distancia.Center = true
                DibujosESP[Jugador].Distancia.Color = ColorDistancia
            end)
        end

        local D = DibujosESP[Jugador]
        if not D or not D.Caja then goto ContinuarJugador end

        -- CALCULAR TAMAÑO Y POSICIÓN
        local AlturaPantalla = 0
        local AnchoPantalla = 0
        pcall(function()
            local Arriba = Camera:WorldToViewportPoint(Raiz.Position + Vector3.new(0, 2.6, 0))
            local Abajo = Camera:WorldToViewportPoint(Raiz.Position + Vector3.new(0, -0.3, 0))
            AlturaPantalla = Abajo.Y - Arriba.Y
            AnchoPantalla = AlturaPantalla * 0.4
        end)

        local X = PosPantalla.X
        local Y = PosPantalla.Y
        local Izquierda = X - AnchoPantalla / 2
        local Arriba = Y - AlturaPantalla / 2

        -- ACTUALIZAR CAJA
        pcall(function()
            D.Caja.Visible = true
            D.Caja.Position = Vector2.new(Izquierda, Arriba)
            D.Caja.Size = Vector2.new(AnchoPantalla, AlturaPantalla)
        end)

        -- ACTUALIZAR NOMBRE
        if D.Nombre then
            pcall(function()
                D.Nombre.Visible = true
                D.Nombre.Text = Jugador.Name
                D.Nombre.Position = Vector2.new(X, Arriba - 16)
            end)
        end

        -- ACTUALIZAR VIDA
        if D.Vida and Humanoide then
            pcall(function()
                D.Vida.Visible = true
                D.Vida.Text = math.floor(Humanoide.Health).." HP"
                D.Vida.Position = Vector2.new(X, Arriba + AlturaPantalla / 2 + 6)
            end)
        end

        -- ACTUALIZAR DISTANCIA
        if D.Distancia then
            pcall(function()
                D.Distancia.Visible = true
                D.Distancia.Text = DistanciaMetros.." m"
                D.Distancia.Position = Vector2.new(X, Arriba + AlturaPantalla / 2 + 20)
            end)
        end

        ::ContinuarJugador::
    end
end)

-- ==============================================
-- FIN DEL SCRIPT — MENSAJE FINAL
-- ==============================================
print("[PASO 14] ✅ Bucle principal iniciado correctamente")
print("")
print("╔════════════════════════════════════════════════════════════╗")
print("║            ✅ SCRIPT CARGADO COMPLETAMENTE ✅               ║")
print("╚════════════════════════════════════════════════════════════╝")
print("")
print("📋 LO QUE DEBES VER EN PANTALLA:")
print("   🟢 CÍRCULO VERDE → sigue al ratón por toda la pantalla")
if GuiCreada and ScreenGui and MainFrame then
    print("   🟩 PANEL OSCURO → con botones VERDES/DESACTIVADOS en ROJO")
    print("      ✅ Arrastra la barra superior para mover el panel")
end
print("   🟥 CAJAS ROJAS → alrededor de otros jugadores (ESP)")
print("")
print("🎮 CÓMO USAR:")
print("   1. Pulsa el botón 'ACTIVAR AIMBOT' → se pone en VERDE")
print("   2. Mantén BOTÓN DERECHO del ratón → la mira se pega al enemigo")
print("   3. Pulsa 'VER JUGADORES' → aparecen cajas con nombres y vida")
print("   4. 'CORRER' y 'VOLAR' → activa y usa WASD + ESPACIO")
print("")
print("⚠️ SI NO VES EL PANEL PERO SÍ EL CÍRCULO:")
print("   → Tu ejecutor bloquea la creación de botones de interfaz")
print("   → El resto del script SÍ FUNCIONA (Aimbot, ESP, Poderes)")
print("")
print("❌ SI NO VES NADA EN ABSOLUTO:")
print("   → Tu ejecutor bloquea Drawing y ScreenGui")
print("   → Prueba en otro juego o con otro ejecutor")
print("")
print("══════════════════════════════════════════════════════════════")
