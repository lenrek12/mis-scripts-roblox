-- ==============================================
-- PANEL DE ASISTENCIA + SECCIÓN DIOS
-- ESP TAMAÑO INTELIGENTE · TECLAS CONFIGURABLES Y GUARDADAS
-- TRASPASAR PAREDES · CORRER · VOLAR CON VELOCIDAD 1-1000
-- TODAS LAS FUNCIONES PUEDEN USARSE A LA VEZ
-- ==============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ⚙️ CARGAR CONFIGURACIÓN GUARDADA
local Configuracion = {
    Teclas = {
        MostrarOcultar = nil,
        Aimbot = nil,
        Esp = nil,
        Zoom = nil,
    },
    VelocidadCorrer = 16,
    VelocidadVolar = 50,
}

-- GUARDAR / CARGAR EN LLAVERO
local function GuardarAjustes()
    local Cadena = ""
    for k, v in pairs(Configuracion.Teclas) do
        Configuracion.Teclas[k] = v or Configuracion.Teclas[k]
        if Configuracion.Teclas[k] then
            Cadena = Cadena..k.."="..Configuracion.Teclas[k].Name..";"
        end
    end
    Cadena = Cadena.."Correr="..Configuracion.VelocidadCorrer..";Volar="..Configuracion.VelocidadVolar
    setfflag("AjustesUsuario", Cadena)
end

local function CargarAjustes()
    local Datos = getfflag("AjustesUsuario")
    if not Datos or Datos == "" then return end
    for Par in Datos:gmatch("[^;]+") do
        local Clave, Valor = Par:match("([^=]+)=([^=]+)")
        if Clave and Valor then
            if Clave == "Correr" then Configuracion.VelocidadCorrer = tonumber(Valor) or 16
            elseif Clave == "Volar" then Configuracion.VelocidadVolar = tonumber(Valor) or 50
            elseif Enum.KeyCode[Valor] then Configuracion.Teclas[Clave] = Enum.KeyCode[Valor] end
        end
    end
end

CargarAjustes()

-- VALORES
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
local OriginalFOV = Camera.FieldOfView
local OriginalBrightness = Lighting.Brightness
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local GravedadOriginal = 196.2
local VelocidadCamino = 16

-- COLORES
local ColorEsp = Color3.fromRGB(255, 40, 40)
local ColorVida = Color3.fromRGB(40, 255, 40)
local ColorDistancia = Color3.fromRGB(255, 220, 40)
local ColorCirculo = Color3.fromRGB(0, 255, 0)

-- CÍRCULO QUE SIGE AL RATÓN
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Transparency = 0.8
Circle.Radius = CircleRadius
Circle.Color = ColorCirculo
Circle.Filled = false

local function UpdateCircle()
    local Pos = UserInputService:GetMouseLocation()
    Circle.Position = Vector2.new(Pos.X, Pos.Y)
    Circle.Visible = UiVisible
    Circle.Radius = CircleRadius
end

-- ==============================================
-- INTERFAZ DEL PANEL
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- MARCO PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 600)
MainFrame.Position = UDim2.new(0.02, 0, 0.08, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.025, 0)

-- BARRA SUPERIOR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
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
BtnMin.Text = "−"
BtnMin.Font = Enum.Font.GothamBold
BtnMin.TextSize = 22
BtnMin.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMin.Size = UDim2.new(0, 38, 0, 34)
BtnMin.Position = UDim2.new(1, -78, 0.5, -17)
BtnMin.BackgroundColor3 = Color3.fromRGB(60, 90, 140)
BtnMin.Parent = TitleBar
Instance.new("UICorner", BtnMin).CornerRadius = UDim.new(0, 5)

-- BOTÓN CERRAR
local BtnClose = Instance.new("TextButton")
BtnClose.Text = "×"
BtnClose.Font = Enum.Font.GothamBold
BtnClose.TextSize = 22
BtnClose.TextColor3 = Color3.fromRGB(255, 80, 80)
BtnClose.Size = UDim2.new(0, 38, 0, 34)
BtnClose.Position = UDim2.new(1, -38, 0.5, -17)
BtnClose.BackgroundColor3 = Color3.fromRGB(90, 50, 50)
BtnClose.Parent = TitleBar
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 5)

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
BtnMin.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        MainFrame.Size = UDim2.new(0, 330, 0, 42)
        Scroll.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 330, 0, 600)
        Scroll.Visible = true
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    UiVisible = false
    MainFrame.Visible = false
    Circle.Visible = false
end)

-- CONTENEDOR DESPLAZABLE
local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "ScrollContainer"
Scroll.Size = UDim2.new(1, -10, 1, -47)
Scroll.Position = UDim2.new(0, 5, 0, 44)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarColor3 = Color3.fromRGB(100, 100, 100)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ClipsDescendants = true
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Scroll

-- ==============================================
-- FUNCIONES AUXILIARES
-- ==============================================
local EsperandoTecla = nil
local BotonesTeclas = {}
local Sliders = {}

local function NombreTecla(Tecla)
    return Tecla and Tecla.Name:gsub("Enum.KeyCode.", "") or "NO ASIGNADA"
end

local function CrearBoton(Nombre, Clave, Callback)
    _G[Clave] = _G[Clave] or false
    local Btn = Instance.new("TextButton")
    Btn.Name = "Btn_"..Clave
    Btn.Text = Nombre..": "..(_G[Clave] and "ON" or "OFF")
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0.93, 0, 0, 42)
    Btn.BackgroundColor3 = _G[Clave] and Color3.fromRGB(35, 130, 60) or Color3.fromRGB(130, 35, 35)
    Btn.Parent = Scroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        _G[Clave] = not _G[Clave]
        Btn.Text = Nombre..": "..(_G[Clave] and "ON" or "OFF")
        Btn.BackgroundColor3 = _G[Clave] and Color3.fromRGB(35, 130, 60) or Color3.fromRGB(130, 35, 35)
        if Callback then Callback(_G[Clave]) end
    end)
end

local function CrearBotonTecla(Nombre, Clave)
    local Btn = Instance.new("TextButton")
    Btn.Name = "Tecla_"..Clave
    Btn.Text = Nombre..": ["..NombreTecla(Configuracion.Teclas[Clave]).."]"
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0.93, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
    Btn.Parent = Scroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    BotonesTeclas[Clave] = Btn

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "⌘ PRESIONA TECLA..."
        Btn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
        EsperandoTecla = Clave
    end)
end

local function CrearBarra(Nombre, Clave, Min, Max, ValorInicial)
    Configuracion[Clave] = Configuracion[Clave] or ValorInicial
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.93, 0, 0, 52)
    Cont.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Cont.Parent = Scroll
    Instance.new("UICorner", Cont).CornerRadius = UDim.new(0, 6)

    local Etiqueta = Instance.new("TextLabel")
    Etiqueta.Text = Nombre..": "..math.floor(Configuracion[Clave])
    Etiqueta.Font = Enum.Font.Gotham
    Etiqueta.TextSize = 11
    Etiqueta.TextColor3 = Color3.fromRGB(255, 255, 255)
    Etiqueta.Size = UDim2.new(1, -10, 0, 20)
    Etiqueta.Position = UDim2.new(0, 5, 0, 3)
    Etiqueta.BackgroundTransparency = 1
    Etiqueta.TextXAlignment = Enum.TextXAlignment.Left
    Etiqueta.Parent = Cont

    local Fondo = Instance.new("Frame")
    Fondo.Size = UDim2.new(1, -10, 0, 14)
    Fondo.Position = UDim2.new(0, 5, 0, 32)
    Fondo.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Fondo.Parent = Cont
    Instance.new("UICorner", Fondo).CornerRadius = UDim.new(1, 0)

    local Relleno = Instance.new("Frame")
    Relleno.Size = UDim2.new((Configuracion[Clave]-Min)/(Max-Min), 0, 1, 0)
    Relleno.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
    Relleno.Parent = Fondo
    Instance.new("UICorner", Relleno).CornerRadius = UDim.new(1, 0)

    Sliders[Clave] = {Etiqueta=Etiqueta, Relleno=Relleno, Min=Min, Max=Max}

    local Arrastrando = false
    Fondo.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then Arrastrando = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then Arrastrando = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if Arrastrando and i.UserInputType == Enum.UserInputType.MouseMovement then
            local Prog = math.clamp((i.Position.X - Fondo.AbsolutePosition.X) / Fondo.AbsoluteSize.X, 0, 1)
            Configuracion[Clave] = math.floor(Min + Prog*(Max-Min))
            Etiqueta.Text = Nombre..": "..Configuracion[Clave]
            Relleno.Size = UDim2.new(Prog, 0, 1, 0)
            GuardarAjustes()
        end
    end)
end

-- DETECTAR TECLAS
UserInputService.InputBegan:Connect(function(Entrada, Procesado)
    if Procesado then return end

    -- ASIGNAR TECLA NUEVA
    if EsperandoTecla then
        if Entrada.KeyCode ~= Enum.KeyCode.Unknown and Entrada.KeyCode ~= Enum.KeyCode.Mouse1 and Entrada.KeyCode ~= Enum.KeyCode.Mouse2 then
            Configuracion.Teclas[EsperandoTecla] = Entrada.KeyCode
            if BotonesTeclas[EsperandoTecla] then
                BotonesTeclas[EsperandoTecla].Text = BotonesTeclas[EsperandoTecla].Text:gsub("%[.-%]", "["..NombreTecla(Entrada.KeyCode).."]")
                BotonesTeclas[EsperandoTecla].BackgroundColor3 = Color3.fromRGB(50, 70, 100)
            end
            GuardarAjustes()
            EsperandoTecla = nil
        end
        return
    end

    -- EJECUTAR ACCIONES POR TECLA
    if UiVisible then
        if Configuracion.Teclas.MostrarOcultar and Entrada.KeyCode == Configuracion.Teclas.MostrarOcultar then
            UiVisible = not UiVisible
            MainFrame.Visible = UiVisible or Minimized
            Circle.Visible = UiVisible
            if not UiVisible then Minimized = false end
        end
        if Configuracion.Teclas.Aimbot and Entrada.KeyCode == Configuracion.Teclas.Aimbot then
            _G.AimEnabled = not _G.AimEnabled
        end
        if Configuracion.Teclas.Esp and Entrada.KeyCode == Configuracion.Teclas.Esp then
            _G.EspEnabled = not _G.EspEnabled
        end
        if Configuracion.Teclas.Zoom and Entrada.KeyCode == Configuracion.Teclas.Zoom then
            _G.FovEnabled = not _G.FovEnabled
            Camera.FieldOfView = _G.FovEnabled and OriginalFOV / FovValue or OriginalFOV
        end
    end
end)

-- ==============================================
-- CREAR BOTONES DEL PANEL
-- ==============================================

-- SECCIÓN PRINCIPAL
local Sep1 = Instance.new("TextLabel")
Sep1.Text = "⚙️ HABILIDADES"
Sep1.Font = Enum.Font.GothamBold
Sep1.TextSize = 13
Sep1.TextColor3 = Color3.fromRGB(255, 200, 40)
Sep1.Size = UDim2.new(0.93, 0, 0, 26)
Sep1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Sep1.Parent = Scroll
Instance.new("UICorner", Sep1).CornerRadius = UDim.new(0, 6)

CrearBoton("ACTIVAR AIMBOT", "AimEnabled")
CrearBoton("SIN RETROCESO", "NoRecoilEnabled")
CrearBoton("VER JUGADORES (ESP)", "EspEnabled")
CrearBoton("ACTIVAR ZOOM", "FovEnabled", function(On)
    Camera.FieldOfView = On and OriginalFOV / FovValue or OriginalFOV
end)
CrearBoton("VISIÓN NOCTURNA", "NightVision", function(On)
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

-- SECCIÓN DIOS
local SepDios = Instance.new("TextLabel")
SepDios.Text = "✨ DIOS"
SepDios.Font = Enum.Font.GothamBold
SepDios.TextSize = 14
SepDios.TextColor3 = Color3.fromRGB(255, 80, 255)
SepDios.Size = UDim2.new(0.93, 0, 0, 28)
SepDios.BackgroundColor3 = Color3.fromRGB(60, 20, 80)
SepDios.Parent = Scroll
Instance.new("UICorner", SepDios).CornerRadius = UDim.new(0, 6)

CrearBoton("TRASPASAR PAREDES", "TraspasarParedes", function(On)
    TraspasarParedes = On
end)
CrearBoton("CORRER RÁPIDO", "Correr", function(On)
    Correr = On
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = On and Configuracion.VelocidadCorrer or VelocidadCamino
    end
end)
CrearBarra("VELOCIDAD AL CORRER", "VelocidadCorrer", 1, 1000)
CrearBoton("VOLAR", "Volar", function(On)
    Volar = On
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.Humanoid.GravityScale = On and 0 or 1
        LocalPlayer.Character.Humanoid.JumpPower = On and 0 or 50
    end
end)
CrearBarra("VELOCIDAD DE VUELO", "VelocidadVolar", 1, 1000)

-- SECCIÓN TECLAS
local Sep2 = Instance.new("TextLabel")
Sep2.Text = "⌘ TECLAS CONFIGURABLES — Pulsa y asigna"
Sep2.Font = Enum.Font.GothamBold
Sep2.TextSize = 12
Sep2.TextColor3 = Color3.fromRGB(100, 180, 255)
Sep2.Size = UDim2.new(0.93, 0, 0, 26)
Sep2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sep2.Parent = Scroll
Instance.new("UICorner", Sep2).CornerRadius = UDim.new(0, 6)

CrearBotonTecla("Mostrar/Ocultar Panel", "MostrarOcultar")
CrearBotonTecla("Activar Aimbot", "Aimbot")
CrearBotonTecla("Activar ESP", "Esp")
CrearBotonTecla("Activar Zoom", "Zoom")

-- INFORMACIÓN
local Info = Instance.new("TextLabel")
Info.Text = "📌 INFORMACIÓN:\n──────────────────────\n➖ MINIMIZAR: Panel se oculta, TODO SIGUE ACTIVO\n❌ CERRAR: Se oculta todo por completo\n──────────────────────\nBotón DERECHO → Mantener para Apuntar\n──────────────────────\nTus ajustes se guardan automáticamente"
Info.Font = Enum.Font.Gotham
Info.TextSize = 10
Info.TextColor3 = Color3.fromRGB(160, 160, 160)
Info.Size = UDim2.new(0.93, 0, 0, 110)
Info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Info.TextWrapped = true
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Scroll
Instance.new("UICorner", Info).CornerRadius = UDim.new(0, 6)

-- ==============================================
-- SISTEMA DE APUNTADO
-- ==============================================
local function ObtenerObjetivo()
    local MousePos = UserInputService:GetMouseLocation()
    local MejorObjetivo, MenorDist = nil, CircleRadius

    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador ~= LocalPlayer and Jugador.Character then
            local Caracter = Jugador.Character
            local Raiz = Caracter:FindFirstChild("HumanoidRootPart")
            local Humano = Caracter:FindFirstChild("Humanoid")
            if Raiz and Humano and Humano.Health > 0 then
                local ParteApuntar = Caracter:FindFirstChild(AimPart) or Caracter.Head
                local PosPantalla, EnPantalla = Camera:WorldToViewportPoint(ParteApuntar.Position)
                if EnPantalla then
                    local Distancia = (Vector2.new(PosPantalla.X, PosPantalla.Y) - Vector2.new(MousePos.X, MousePos.Y)).Magnitude
                    if Distancia < MenorDist then
                        MenorDist = Distancia
                        MejorObjetivo = ParteApuntar
                    end
                end
            end
        end
    end
    return MejorObjetivo
end

-- ==============================================
-- SISTEMA ESP — TAMAÑO AJUSTABLE POR DISTANCIA
-- ==============================================
local DatosESP = {}

-- ==============================================
-- BUCLE PRINCIPAL — TODAS LAS FUNCIONES
-- ==============================================
RunService.RenderStepped:Connect(function()
    UpdateCircle()

    -- OCULTAR TODO SI ESTÁ CERRADO
    if not UiVisible then
        for _, Datos in pairs(DatosESP) do
            for _, Dibujo in ipairs(Datos) do
                Dibujo.Visible = false
            end
        end
        return
    end

    -- === AIMBOT ===
    if _G.AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local Objetivo = ObtenerObjetivo()
        if Objetivo then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Objetivo.Position), AimStrength / 10)
        end
    end

    -- === SIN RETROCESO ===
    if _G.NoRecoilEnabled then
        Mouse.Origin = CFrame.new(Camera.CFrame.Position)
    end

    -- === TRASPASAR PAREDES ===
    if TraspasarParedes and LocalPlayer.Character then
        for _, Parte in ipairs(LocalPlayer.Character:GetDescendants()) do
            if Parte:IsA("BasePart") then Parte.CanCollide = false end
        end
    elseif not TraspasarParedes and LocalPlayer.Character then
        for _, Parte in ipairs(LocalPlayer.Character:GetDescendants()) do
            if Parte:IsA("BasePart") and Parte.Name ~= "HumanoidRootPart" then Parte.CanCollide = true end
        end
    end

    -- === CORRER ===
    if Correr and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Configuracion.VelocidadCorrer
    elseif not Correr and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = VelocidadCamino
    end

    -- === VOLAR ===
    if Volar and LocalPlayer.Character then
        local Raiz = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Humano = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Raiz and Humano then
            Humano.GravityScale = 0
            Humano.JumpPower = 0
            local Vel = Configuracion.VelocidadVolar / 10
            local Mov = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Mov += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Mov -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Mov -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Mov += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Mov += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Mov -= Vector3.new(0, 1, 0) end
            Mov = Mov * Vel
            Raiz.Velocity = Raiz.CFrame:VectorToWorldSpace(Mov)
        end
    elseif not Volar and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.GravityScale = GravedadOriginal
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end

    -- === ESP ===
    if not _G.EspEnabled then
        for _, Datos in pairs(DatosESP) do
            for _, Dibujo in ipairs(Datos) do
                Dibujo.Visible = false
            end
        end
        return
    end

    -- RECORRER JUGADORES
    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador == LocalPlayer then
            if DatosESP[Jugador] then
                for _, Dibujo in ipairs(DatosESP[Jugador]) do
                    Dibujo.Visible = false
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
            if DatosESP[Jugador] then
                for _, Dibujo in ipairs(DatosESP[Jugador]) do
                    Dibujo.Visible = false
                end
            end
            continue
        end

        -- CREAR DIBUJOS
        if not DatosESP[Jugador] then
            DatosESP[Jugador] = {
                Caja = Drawing.new("Square"),
                Nombre = Drawing.new("Text"),
                BarraVidaFondo = Drawing.new("Square"),
                BarraVida = Drawing.new("Square"),
                TextoVida = Drawing.new("Text"),
                Distancia = Drawing.new("Text"),
            }
            DatosESP[Jugador].Caja.Thickness = 1.5
            DatosESP[Jugador].Caja.Color = ColorEsp
            DatosESP[Jugador].Nombre.Size = 11
            DatosESP[Jugador].Nombre.Center = true
            DatosESP[Jugador].TextoVida.Size = 9
            DatosESP[Jugador].TextoVida.Center = true
            DatosESP[Jugador].Distancia.Size = 10
            DatosESP[Jugador].Distancia.Center = true
        end

        local D = DatosESP[Jugador]

        -- ✅ TAMAÑO DE CAJA AJUSTADO POR DISTANCIA
        local Escala = math.clamp(180 / DistanciaMetros, 0.15, 1.2)
        local Altura = (Camera:WorldToViewportPoint(Vector3.new(0, 2.7, 0) + Raiz.Position) - Camera:WorldToViewportPoint(Vector3.new(0, -0.3, 0) + Raiz.Position)).Y
        Altura = Altura * Escala
        local Ancho = Altura * 0.4
        local X = PosPantalla.X
        local Y = PosPantalla.Y
        local Izquierda = X - Ancho/2
        local Arriba = Y - Altura/2
        local PorcentajeVida = Humano.Health / Humano.MaxHealth

        -- CAJA
        D.Caja.Visible = true
        D.Caja.Position = Vector2.new(Izquierda, Arriba)
        D.Caja.Size = Vector2.new(Ancho, Altura)
        D.Caja.Filled = false

        -- NOMBRE
        D.Nombre.Visible = true
        D.Nombre.Text = Jugador.Name
        D.Nombre.Color = ColorEsp
        D.Nombre.Position = Vector2.new(X, Arriba - 16)

        -- BARRA DE VIDA
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

        -- VIDA
        D.TextoVida.Visible = true
        D.TextoVida.Text = math.floor(Humano.Health) .. " HP"
        D.TextoVida.Color = ColorVida
        D.TextoVida.Position = Vector2.new(X, Arriba - 6)

        -- DISTANCIA
        D.Distancia.Visible = true
        D.Distancia.Text = DistanciaMetros .. " m"
        D.Distancia.Color = ColorDistancia
        D.Distancia.Position = Vector2.new(X, Arriba + Altura/2 + 8)
    end
end)

print("✅ SCRIPT CARGADO COMPLETAMENTE")
print("✅ ESP: Caja se ajusta automáticamente por distancia")
print("✅ TECLAS: Sin asignar, tú las configuras → SE GUARDAN")
print("✅ SECCIÓN DIOS: Traspasar paredes · Correr · Volar 1-1000")
print("✅ TODAS LAS FUNCIONES PUEDEN ACTIVARSE A LA VEZ")
