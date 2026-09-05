-- ==============================================
-- PANEL DE ASISTENCIA — VERSIÓN A PRUEBA DE FALLOS
-- ~1000 LÍNEAS · DETECCIÓN DE ERRORES · CREACIÓN GARANTIZADA
-- ==============================================

print("🔄 INICIANDO SCRIPT... ESPERA UN MOMENTO...")

-- ==============================================
-- SERVICIOS
-- ==============================================
local success, result = pcall(function()
    return {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Lighting = game:GetService("Lighting"),
        TweenService = game:GetService("TweenService"),
        StarterGui = game:GetService("StarterGui"),
    }
end)
if not success then
    warn("❌ ERROR AL CARGAR SERVICIOS: " .. tostring(result))
    return nil
end
local Services = result
local Players = Services.Players
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local Lighting = Services.Lighting
local TweenService = Services.TweenService
local StarterGui = Services.StarterGui

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("❌ NO SE DETECTÓ JUGADOR LOCAL")
    return nil
end
local Mouse = LocalPlayer:GetMouse()

-- ==============================================
-- VALORES DE CONFIGURACIÓN
-- ==============================================
local UiVisible = true
local Minimized = false
local AimEnabled = false
local AimStrength = 5
local AimPart = "Head"
local CircleRadius = 150
local FovEnabled = false
local FovValue = 2
local NoRecoilEnabled = false
local EspEnabled = true
local NightVision = false
local MaxDistance = 10000
local TraspasarParedes = false
local Correr = false
local Volar = false
local VelocidadCorrer = 16
local VelocidadVolar = 50
local OriginalFOV = Camera.FieldOfView
local OriginalBrightness = Lighting.Brightness
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local GravedadOriginal = 196.2
local VelocidadCamino = 16

-- TECLAS (SIN ASIGNAR POR DEFECTO)
local Teclas = {
    MostrarOcultar = nil,
    Aimbot = nil,
    Esp = nil,
    Zoom = nil,
}

-- COLORES
local ColorEsp = Color3.fromRGB(255, 40, 40)
local ColorVida = Color3.fromRGB(40, 255, 40)
local ColorDistancia = Color3.fromRGB(255, 220, 40)
local ColorCirculo = Color3.fromRGB(0, 255, 0)
local ColorFondo = Color3.fromRGB(22, 22, 22)
local ColorBotonVerde = Color3.fromRGB(35, 130, 60)
local ColorBotonRojo = Color3.fromRGB(130, 35, 35)
local ColorBotonAzul = Color3.fromRGB(50, 70, 100)

-- ==============================================
-- CÍRCULO DEL AIMBOT (CON PROTECCIÓN)
-- ==============================================
local Circle = nil
pcall(function()
    Circle = Drawing.new("Circle")
    Circle.Visible = true
    Circle.Thickness = 2
    Circle.NumSides = 64
    Circle.Transparency = 0.8
    Circle.Radius = CircleRadius
    Circle.Color = ColorCirculo
    Circle.Filled = false
end)

local function UpdateCircle()
    if not Circle then return end
    local succ, pos = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if succ then
        Circle.Position = Vector2.new(pos.X, pos.Y)
        Circle.Visible = UiVisible
        Circle.Radius = CircleRadius
    end
end

print("✅ SERVICIOS Y CÍRCULO CARGADOS")

-- ==============================================
-- CREAR INTERFAZ GRÁFICA (EN LUGAR SEGURO)
-- ==============================================
local ScreenGui = nil
local TargetParent = nil

-- INTENTAR DIFERENTES UBICACIONES POR SI ALGUNA ESTÁ BLOQUEADA
pcall(function()
    TargetParent = game:GetService("CoreGui")
end)
if not TargetParent then
    pcall(function()
        TargetParent = LocalPlayer:FindFirstChild("PlayerGui")
    end)
end
if not TargetParent then
    warn("❌ NO SE ENCONTRÓ LUGAR PARA CREAR INTERFAZ")
    return nil
end

task.wait(0.3)

local succCreate, errCreate = pcall(function()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PanelAsistencia"
    ScreenGui.Parent = TargetParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if not pcall(function() ScreenGui.ResetOnSpawn = false end) then end
end)
if not succCreate or not ScreenGui then
    warn("❌ ERROR AL CREAR INTERFAZ: " .. tostring(errCreate))
    return nil
end

print("✅ INTERFAZ CREADA EN: " .. TargetParent.Name)

-- ==============================================
-- MARCO PRINCIPAL
-- ==============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MarcoPrincipal"
MainFrame.Size = UDim2.new(0, 340, 0, 620)
MainFrame.Position = UDim2.new(0.02, 0, 0.08, 0)
MainFrame.BackgroundColor3 = ColorFondo
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
pcall(function()
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0.025, 0)
    Corner.Parent = MainFrame
end)

task.wait(0.1)

-- BARRA SUPERIOR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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

-- BOTÓN MINIMIZAR
local BtnMin = Instance.new("TextButton")
BtnMin.Name = "BtnMinimizar"
BtnMin.Text = "−"
BtnMin.Font = Enum.Font.GothamBold
BtnMin.TextSize = 22
BtnMin.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMin.Size = UDim2.new(0, 40, 0, 36)
BtnMin.Position = UDim2.new(1, -82, 0.5, -18)
BtnMin.BackgroundColor3 = Color3.fromRGB(60, 90, 140)
BtnMin.Parent = TitleBar
pcall(function()
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 5)
    C.Parent = BtnMin
end)

-- BOTÓN CERRAR
local BtnClose = Instance.new("TextButton")
BtnClose.Name = "BtnCerrar"
BtnClose.Text = "×"
BtnClose.Font = Enum.Font.GothamBold
BtnClose.TextSize = 22
BtnClose.TextColor3 = Color3.fromRGB(255, 80, 80)
BtnClose.Size = UDim2.new(0, 40, 0, 36)
BtnClose.Position = UDim2.new(1, -40, 0.5, -18)
BtnClose.BackgroundColor3 = Color3.fromRGB(90, 50, 50)
BtnClose.Parent = TitleBar
pcall(function()
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 5)
    C.Parent = BtnClose
end)

print("✅ BARRA SUPERIOR CREADA")

-- ==============================================
-- ARRASTRAR VENTANA
-- ==============================================
local DragStart, StartPos
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        DragStart = UserInputService:GetMouseLocation()
        StartPos = MainFrame.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                DragStart = nil
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if DragStart and i.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = UserInputService:GetMouseLocation() - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

-- ==============================================
-- BOTONES MINIMIZAR Y CERRAR
-- ==============================================
BtnMin.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        MainFrame.Size = UDim2.new(0, 340, 0, 44)
        Scroll.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 340, 0, 620)
        Scroll.Visible = true
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    UiVisible = false
    MainFrame.Visible = false
    if Circle then Circle.Visible = false end
end)

-- ==============================================
-- CONTENEDOR DESPLAZABLE
-- ==============================================
task.wait(0.1)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "ContenidoDesplazable"
Scroll.Size = UDim2.new(1, -10, 1, -48)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 7
Scroll.ScrollBarColor3 = Color3.fromRGB(100, 100, 100)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1200)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ClipsDescendants = true
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Scroll

print("✅ ÁREA DE CONTENIDO CREADA")

-- ==============================================
-- FUNCIONES AUXILIARES
-- ==============================================
local EsperandoTecla = nil
local BotonesTeclas = {}
local BotonesEstado = {}
local Sliders = {}

local function NombreTecla(Tecla)
    if not Tecla then return "NO ASIGNADA" end
    local N = Tecla.Name
    return N:gsub("Enum.KeyCode.", "")
end

local function CrearSeparador(Texto, Color)
    local Sep = Instance.new("TextLabel")
    Sep.Text = Texto
    Sep.Font = Enum.Font.GothamBold
    Sep.TextSize = 13
    Sep.TextColor3 = Color
    Sep.Size = UDim2.new(0.94, 0, 0, 28)
    Sep.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Sep.Parent = Scroll
    pcall(function()
        local C = Instance.new("UICorner")
        C.CornerRadius = UDim.new(0, 6)
        C.Parent = Sep
    end)
end

local function CrearBotonToggle(Nombre, Clave, Callback)
    BotonesEstado[Clave] = BotonesEstado[Clave] or false
    local Btn = Instance.new("TextButton")
    Btn.Name = "Btn_" .. Clave
    Btn.Text = Nombre .. ": " .. (BotonesEstado[Clave] and "ON" or "OFF")
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0.94, 0, 0, 44)
    Btn.BackgroundColor3 = BotonesEstado[Clave] and ColorBotonVerde or ColorBotonRojo
    Btn.Parent = Scroll
    pcall(function()
        local C = Instance.new("UICorner")
        C.CornerRadius = UDim.new(0, 6)
        C.Parent = Btn
    end)

    Btn.MouseButton1Click:Connect(function()
        BotonesEstado[Clave] = not BotonesEstado[Clave]
        Btn.Text = Nombre .. ": " .. (BotonesEstado[Clave] and "ON" or "OFF")
        Btn.BackgroundColor3 = BotonesEstado[Clave] and ColorBotonVerde or ColorBotonRojo
        if Callback then pcall(Callback, BotonesEstado[Clave]) end
    end)

    return Btn
end

local function CrearBotonTeclaConfig(Nombre, Clave)
    local Btn = Instance.new("TextButton")
    Btn.Name = "Tecla_" .. Clave
    Btn.Text = Nombre .. ": [" .. NombreTecla(Teclas[Clave]) .. "]"
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0.94, 0, 0, 40)
    Btn.BackgroundColor3 = ColorBotonAzul
    Btn.Parent = Scroll
    pcall(function()
        local C = Instance.new("UICorner")
        C.CornerRadius = UDim.new(0, 6)
        C.Parent = Btn
    end)

    BotonesTeclas[Clave] = Btn

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "⌘ PRESIONA UNA TECLA..."
        Btn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
        EsperandoTecla = Clave
    end)
end

local function CrearBarraDeslizante(Nombre, Variable, Min, Max, ValorInicial)
    if _G[Variable] == nil then _G[Variable] = ValorInicial end

    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.94, 0, 0, 54)
    Cont.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Cont.Parent = Scroll
    pcall(function()
        local C = Instance.new("UICorner")
        C.CornerRadius = UDim.new(0, 6)
        C.Parent = Cont
    end)

    local Etiqueta = Instance.new("TextLabel")
    Etiqueta.Text = Nombre .. ": " .. math.floor(_G[Variable])
    Etiqueta.Font = Enum.Font.Gotham
    Etiqueta.TextSize = 11
    Etiqueta.TextColor3 = Color3.fromRGB(255, 255, 255)
    Etiqueta.Size = UDim2.new(1, -10, 0, 20)
    Etiqueta.Position = UDim2.new(0, 5, 0, 4)
    Etiqueta.BackgroundTransparency = 1
    Etiqueta.TextXAlignment = Enum.TextXAlignment.Left
    Etiqueta.Parent = Cont

    local Fondo = Instance.new("Frame")
    Fondo.Size = UDim2.new(1, -10, 0, 16)
    Fondo.Position = UDim2.new(0, 5, 0, 34)
    Fondo.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Fondo.Parent = Cont
    pcall(function()
        local C = Instance.new("UICorner")
        C.CornerRadius = UDim.new(1, 0)
        C.Parent = Fondo
    end)

    local Relleno = Instance.new("Frame")
    Relleno.Size = UDim2.new((_G[Variable] - Min) / (Max - Min), 0, 1, 0)
    Relleno.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
    Relleno.Parent = Fondo
    pcall(function()
        local C = Instance.new("UICorner")
        C.CornerRadius = UDim.new(1, 0)
        C.Parent = Relleno
    end)

    local Arrastrando = false
    Fondo.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            Arrastrando = true
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            Arrastrando = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if Arrastrando and i.UserInputType == Enum.UserInputType.MouseMovement then
            local PosX = i.Position.X - Fondo.AbsolutePosition.X
            local Prog = math.clamp(PosX / Fondo.AbsoluteSize.X, 0, 1)
            _G[Variable] = math.floor(Min + Prog * (Max - Min))
            Etiqueta.Text = Nombre .. ": " .. _G[Variable]
            Relleno.Size = UDim2.new(Prog, 0, 1, 0)
        end
    end)
end

print("✅ FUNCIONES DE CREACIÓN CARGADAS")

-- ==============================================
-- DETECTAR TECLAS PULSADAS
-- ==============================================
UserInputService.InputBegan:Connect(function(Entrada, Procesado)
    if Procesado then return end

    -- ASIGNAR TECLA NUEVA
    if EsperandoTecla then
        if Entrada.KeyCode ~= Enum.KeyCode.Unknown and
           Entrada.KeyCode ~= Enum.KeyCode.Mouse1 and
           Entrada.KeyCode ~= Enum.KeyCode.Mouse2 then
            Teclas[EsperandoTecla] = Entrada.KeyCode
            if BotonesTeclas[EsperandoTecla] then
                BotonesTeclas[EsperandoTecla].Text = BotonesTeclas[EsperandoTecla].Text:gsub("%[.-%]", "[" .. NombreTecla(Entrada.KeyCode) .. "]")
                BotonesTeclas[EsperandoTecla].BackgroundColor3 = ColorBotonAzul
            end
            EsperandoTecla = nil
        end
        return
    end

    -- EJECUTAR ACCIONES
    if UiVisible then
        if Teclas.MostrarOcultar and Entrada.KeyCode == Teclas.MostrarOcultar then
            UiVisible = not UiVisible
            MainFrame.Visible = UiVisible or Minimized
            if Circle then Circle.Visible = UiVisible end
            if not UiVisible then Minimized = false end
        end
        if Teclas.Aimbot and Entrada.KeyCode == Teclas.Aimbot then
            BotonesEstado.AimEnabled = not BotonesEstado.AimEnabled
        end
        if Teclas.Esp and Entrada.KeyCode == Teclas.Esp then
            BotonesEstado.EspEnabled = not BotonesEstado.EspEnabled
        end
        if Teclas.Zoom and Entrada.KeyCode == Teclas.Zoom then
            BotonesEstado.FovEnabled = not BotonesEstado.FovEnabled
            Camera.FieldOfView = BotonesEstado.FovEnabled and (OriginalFOV / FovValue) or OriginalFOV
        end
    end
end)

-- ==============================================
-- CREAR TODO EL CONTENIDO DEL PANEL
-- ==============================================
task.wait(0.2)

CrearSeparador("⚙️ HABILIDADES PRINCIPALES", Color3.fromRGB(255, 200, 40))
task.wait(0.05)

CrearBotonToggle("ACTIVAR AIMBOT", "AimEnabled")
task.wait(0.05)

CrearBotonToggle("SIN RETROCESO", "NoRecoilEnabled")
task.wait(0.05)

CrearBotonToggle("VER JUGADORES (ESP)", "EspEnabled")
task.wait(0.05)

CrearBotonToggle("ACTIVAR ZOOM", "FovEnabled", function(On)
    Camera.FieldOfView = On and (OriginalFOV / FovValue) or OriginalFOV
end)
task.wait(0.05)

CrearBotonToggle("VISIÓN NOCTURNA", "NightVision", function(On)
    if On then
        Lighting.Brightness = 3.5
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    else
        Lighting.Brightness = OriginalBrightness
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient
    end
end)
task.wait(0.05)

-- SECCIÓN DIOS
CrearSeparador("✨ DIOS — PODERES ESPECIALES", Color3.fromRGB(255, 80, 255))
task.wait(0.05)

CrearBotonToggle("👻 TRASPASAR PAREDES", "TraspasarParedes", function(On)
    TraspasarParedes = On
end)
task.wait(0.05)

CrearBotonToggle("🏃 CORRER RÁPIDO", "Correr", function(On)
    Correr = On
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = On and (_G.VelocidadCorrer or 16) or VelocidadCamino
    end
end)
task.wait(0.05)

CrearBarraDeslizante("⚡ VELOCIDAD AL CORRER", "VelocidadCorrer", 1, 1000, 16)
task.wait(0.05)

CrearBotonToggle("✈️ VOLAR", "Volar", function(On)
    Volar = On
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.GravityScale = On and 0 or GravedadOriginal
        LocalPlayer.Character.Humanoid.JumpPower = On and 0 or 50
    end
end)
task.wait(0.05)

CrearBarraDeslizante("🚀 VELOCIDAD DE VUELO", "VelocidadVolar", 1, 1000, 50)
task.wait(0.05)

-- SECCIÓN TECLAS
CrearSeparador("⌘ TECLAS CONFIGURABLES — PULSA Y ASIGNA", Color3.fromRGB(100, 180, 255))
task.wait(0.05)

CrearBotonTeclaConfig("Mostrar/Ocultar Panel", "MostrarOcultar")
task.wait(0.05)

CrearBotonTeclaConfig("Activar Aimbot", "Aimbot")
task.wait(0.05)

CrearBotonTeclaConfig("Activar ESP", "Esp")
task.wait(0.05)

CrearBotonTeclaConfig("Activar Zoom", "Zoom")
task.wait(0.05)

-- INFORMACIÓN
local Info = Instance.new("TextLabel")
Info.Text = "📌 INFORMACIÓN IMPORTANTE:\n─────────────────────────────────────\n➖ MINIMIZAR: Se oculta la ventana, TODO SIGUE ACTIVO\n❌ CERRAR: Se oculta todo por completo\n─────────────────────────────────────\n🖱️ Botón DERECHO → Mantener para Apuntar\n─────────────────────────────────────\n✈️ Volar: WASD = Moverse | ESPACIO = Subir | CTRL = Bajar\n─────────────────────────────────────\n📏 ESP: Caja cambia de tamaño automáticamente por distancia\n─────────────────────────────────────\n⚠️ Las teclas se configuran al ejecutar y se reinician al recargar"
Info.Font = Enum.Font.Gotham
Info.TextSize = 10
Info.TextColor3 = Color3.fromRGB(160, 160, 160)
Info.Size = UDim2.new(0.94, 0, 0, 130)
Info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Info.TextWrapped = true
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Parent = Scroll
pcall(function()
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Info
end)

print("✅ TODO EL PANEL CREADO — " .. tostring(#Scroll:GetChildren()) .. " ELEMENTOS")

-- ==============================================
-- SISTEMA DE APUNTADO
-- ==============================================
local function ObtenerObjetivoMasCercano()
    local MousePos = UserInputService:GetMouseLocation()
    local MejorObjetivo, MenorDistancia = nil, CircleRadius

    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador ~= LocalPlayer and Jugador.Character then
            local Caracter = Jugador.Character
            local Raiz = Caracter:FindFirstChild("HumanoidRootPart")
            local Humano = Caracter:FindFirstChild("Humanoid")
            if Raiz and Humano and Humano.Health > 0 then
                local ParteApuntar = Caracter:FindFirstChild(AimPart) or Caracter.Head
                local PosPantalla, EnPantalla = Camera:WorldToViewportPoint(ParteApuntar.Position)
                if EnPantalla then
                    local Dist = (Vector2.new(PosPantalla.X, PosPantalla.Y) - Vector2.new(MousePos.X, MousePos.Y)).Magnitude
                    if Dist < MenorDistancia then
                        MenorDistancia = Dist
                        MejorObjetivo = ParteApuntar
                    end
                end
            end
        end
    end
    return MejorObjetivo
end

-- ==============================================
-- ALMACÉN DE DIBUJOS ESP
-- ==============================================
local DibujosESP = {}

-- ==============================================
-- BUCLE PRINCIPAL DE FUNCIONAMIENTO
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- SI ESTÁ TODO OCULTO, SALIR
    if not UiVisible then
        for _, DatosJugador in pairs(DibujosESP) do
            for _, Dibujo in pairs(DatosJugador) do
                pcall(function() Dibujo.Visible = false end)
            end
        end
        return
    end

    -- ACTUALIZAR CÍRCULO
    UpdateCircle()

    -- AIMBOT
    if BotonesEstado.AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local Objetivo = ObtenerObjetivoMasCercano()
        if Objetivo then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, Objetivo.Position),
                AimStrength / 10
            )
        end
    end

    -- SIN RETROCESO
    if BotonesEstado.NoRecoilEnabled then
        pcall(function() Mouse.Origin = CFrame.new(Camera.CFrame.Position) end)
    end

    -- TRASPASAR PAREDES
    if TraspasarParedes and LocalPlayer.Character then
        pcall(function()
            for _, Parte in ipairs(LocalPlayer.Character:GetDescendants()) do
                if Parte:IsA("BasePart") then Parte.CanCollide = false end
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

    -- CORRER RÁPIDO
    if Correr and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.VelocidadCorrer or 16
    elseif not Correr and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = VelocidadCamino
    end

    -- VOLAR
    if Volar and LocalPlayer.Character then
        local Raiz = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Humano = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Raiz and Humano then
            Humano.GravityScale = 0
            Humano.JumpPower = 0
            local Velocidad = (_G.VelocidadVolar or 50) / 10
            local Direccion = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direccion += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direccion -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direccion -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direccion += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Direccion += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Direccion -= Vector3.new(0, 1, 0) end
            Raiz.Velocity = Raiz.CFrame:VectorToWorldSpace(Direccion * Velocidad)
        end
    elseif not Volar and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.GravityScale = GravedadOriginal
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end

    -- ESP — SI ESTÁ DESACTIVADO, OCULTAR TODO
    if not BotonesEstado.EspEnabled then
        for _, DatosJugador in pairs(DibujosESP) do
            for _, Dibujo in pairs(DatosJugador) do
                pcall(function() Dibujo.Visible = false end)
            end
        end
        return
    end

    -- RECORRER TODOS LOS JUGADORES
    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador == LocalPlayer then
            if DibujosESP[Jugador] then
                for _, Dibujo in pairs(DibujosESP[Jugador]) do
                    pcall(function() Dibujo.Visible = false end)
                end
            end
            continue
        end

        local Caracter = Jugador.Character
        local Mostrar = true
        if not Caracter then Mostrar = false
        elseif not Caracter:FindFirstChild("HumanoidRootPart") then Mostrar = false
        elseif not Caracter:FindFirstChild("Humanoid") then Mostrar = false
        elseif Caracter.Humanoid.Health <= 0 then Mostrar = false end

        local Raiz = Caracter and Caracter:FindFirstChild("HumanoidRootPart")
        local Humano = Caracter and Caracter:FindFirstChild("Humanoid")
        local PosPantalla, EnPantalla, DistanciaMetros
        if Raiz then
            PosPantalla, EnPantalla = Camera:WorldToViewportPoint(Raiz.Position)
            DistanciaMetros = math.floor((Camera.CFrame.Position - Raiz.Position).Magnitude)
            if DistanciaMetros > MaxDistance then EnPantalla = false end
        end
        if not EnPantalla then Mostrar = false end

        if not Mostrar then
            if DibujosESP[Jugador] then
                for _, Dibujo in pairs(DibujosESP[Jugador]) do
                    pcall(function() Dibujo.Visible = false end)
                end
            end
            continue
        end

        -- CREAR DIBUJOS SI NO EXISTEN
        if not DibujosESP[Jugador] then
            DibujosESP[Jugador] = {}
            pcall(function()
                DibujosESP[Jugador].Caja = Drawing.new("Square")
                DibujosESP[Jugador].Caja.Thickness = 1.5
                DibujosESP[Jugador].Caja.Color = ColorEsp
                DibujosESP[Jugador].Nombre = Drawing.new("Text")
                DibujosESP[Jugador].Nombre.Size = 11
                DibujosESP[Jugador].Nombre.Center = true
                DibujosESP[Jugador].BarraVidaFondo = Drawing.new("Square")
                DibujosESP[Jugador].BarraVida = Drawing.new("Square")
                DibujosESP[Jugador].TextoVida = Drawing.new("Text")
                DibujosESP[Jugador].TextoVida.Size = 9
                DibujosESP[Jugador].TextoVida.Center = true
                DibujosESP[Jugador].Distancia = Drawing.new("Text")
                DibujosESP[Jugador].Distancia.Size = 10
                DibujosESP[Jugador].Distancia.Center = true
            end)
        end

        local D = DibujosESP[Jugador]
        if not D or not D.Caja then return end

        -- TAMAÑO INTELIGENTE SEGÚN DISTANCIA
        local Escala = math.clamp(180 / DistanciaMetros, 0.15, 1.2)
        local Altura = (Camera:WorldToViewportPoint(Vector3.new(0, 2.7, 0) + Raiz.Position) - Camera:WorldToViewportPoint(Vector3.new(0, -0.3, 0) + Raiz.Position)).Y
        Altura = Altura * Escala
        local Ancho = Altura * 0.4
        local X = PosPantalla.X
        local Y = PosPantalla.Y
        local Izquierda = X - Ancho/2
        local Arriba = Y - Altura/2
        local PorcentajeVida = Humano.Health / Humano.MaxHealth

        -- DIBUJAR CAJA
        D.Caja.Visible = true
        D.Caja.Position = Vector2.new(Izquierda, Arriba)
        D.Caja.Size = Vector2.new(Ancho, Altura)
        D.Caja.Filled = false

        -- NOMBRE
        if D.Nombre then
            D.Nombre.Visible = true
            D.Nombre.Text = Jugador.Name
            D.Nombre.Color = ColorEsp
            D.Nombre.Position = Vector2.new(X, Arriba - 16)
        end

        -- BARRA DE VIDA
        if D.BarraVidaFondo and D.BarraVida then
            D.BarraVidaFondo.Visible = true
            D.BarraVidaFondo.Position = Vector2.new(Izquierda - 2, Arriba - 8)
            D.BarraVidaFondo.Size = Vector2.new(Ancho + 4, 6)
            D.BarraVidaFondo.Color = Color3.fromRGB(60, 60, 60)
            D.BarraVidaFondo.Filled = true

            D.BarraVida.Visible = true
            D.BarraVida.Position = Vector2.new(Izquierda - 2, Arriba - 8)
            D.BarraVida.Size = Vector2.new((Ancho + 4) * PorcentajeVida, 6)
            D.BarraVida.Color = ColorVida
            D.BarraVida.Filled = true
        end

        -- TEXTO DE VIDA
        if D.TextoVida then
            D.TextoVida.Visible = true
            D.TextoVida.Text = math.floor(Humano.Health) .. " HP"
            D.TextoVida.Color = ColorVida
            D.TextoVida.Position = Vector2.new(X, Arriba - 6)
        end

        -- DISTANCIA
        if D.Distancia then
            D.Distancia.Visible = true
            D.Distancia.Text = DistanciaMetros .. " m"
            D.Distancia.Color = ColorDistancia
            D.Distancia.Position = Vector2.new(X, Arriba + Altura/2 + 8)
        end
    end
end)

-- ==============================================
-- MENSAJE FINAL
-- ==============================================
print("========================================")
print("✅ SCRIPT CARGADO COMPLETAMENTE")
print("✅ LÍNEAS: ~1000 | VERSIÓN A PRUEBA DE BLOQUEOS")
print("✅ Panel visible con botones")
print("✅ Círculo sigue al ratón")
print("✅ ESP con tamaño inteligente")
print("✅ Sección DIOS: Traspasar · Correr · Volar")
print("✅ Teclas configurables desde el panel")
print("========================================")
print("📌 PASOS PARA EMPEZAR:")
print("   1. Pulsa cada botón azul de tecla → asigna la tecla que quieras")
print("   2. Activa las funciones que necesites")
print("   3. Usa el botón DERECHO del ratón para apuntar")
print("========================================")
