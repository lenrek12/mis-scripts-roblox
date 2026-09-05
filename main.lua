-- ==============================================
-- PANEL DE ASISTENCIA — VERSIÓN FINAL GARANTIZADA
-- Panel lleno · Círculo sigue al ratón · Todas las funciones
-- ==============================================

print("🔄 [1/10] INICIANDO SCRIPT...")

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

print("✅ [2/10] SERVICIOS CARGADOS")

-- ==============================================
-- VARIABLES GLOBALES
-- ==============================================
UiVisible = true
Minimized = false
AimEnabled = false
AimStrength = 5
AimPart = "Head"
CircleRadius = 150
FovEnabled = false
FovValue = 2
NoRecoilEnabled = false
EspEnabled = true
NightVision = false
MaxDistance = 10000
TraspasarParedes = false
Correr = false
Volar = false
VelocidadCorrer = 16
VelocidadVolar = 50
OriginalFOV = Camera.FieldOfView
OriginalBrightness = Lighting.Brightness
OriginalAmbient = Lighting.Ambient
OriginalOutdoorAmbient = Lighting.OutdoorAmbient
GravedadOriginal = 196.2
VelocidadCamino = 16

Teclas = {
    MostrarOcultar = nil,
    Aimbot = nil,
    Esp = nil,
    Zoom = nil,
}

ColorEsp = Color3.fromRGB(255, 40, 40)
ColorVida = Color3.fromRGB(40, 255, 40)
ColorDistancia = Color3.fromRGB(255, 220, 40)
ColorCirculo = Color3.fromRGB(0, 255, 0)

print("✅ [3/10] VARIABLES CARGADAS")

-- ==============================================
-- CÍRCULO DEL AIMBOT — GARANTIZADO
-- ==============================================
Circle = nil
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

function UpdateCircle()
    if not Circle then return end
    local succ, pos = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if succ and pos then
        Circle.Position = Vector2.new(pos.X, pos.Y)
        Circle.Visible = UiVisible
        Circle.Radius = CircleRadius
    end
end

print("✅ [4/10] CÍRCULO CREADO — DEBE APARECER EN PANTALLA")

-- ==============================================
-- CREAR INTERFAZ
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAsistencia"
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer.PlayerGui
end
pcall(function() ScreenGui.ResetOnSpawn = false end)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

print("✅ [5/10] INTERFAZ CREADA EN: " .. ScreenGui.Parent.Name)

-- MARCO PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MarcoPrincipal"
MainFrame.Size = UDim2.new(0, 340, 0, 620)
MainFrame.Position = UDim2.new(0.02, 0, 0.08, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.025, 0)

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

-- BOTONES MINIMIZAR / CERRAR
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
Instance.new("UICorner", BtnMin).CornerRadius = UDim.new(0, 5)

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

-- CONTENEDOR DESPLAZABLE
Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "ContenidoDesplazable"
Scroll.Size = UDim2.new(1, -10, 1, -48)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 7
Scroll.ScrollBarColor3 = Color3.fromRGB(100, 100, 100)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1300)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ClipsDescendants = true
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Scroll

print("✅ [6/10] ESTRUCTURA DEL PANEL CREADA")

-- ==============================================
-- FUNCIONES PARA CREAR BOTONES
-- ==============================================
BotonesEstado = {}
BotonesTeclas = {}
EsperandoTecla = nil

function NombreTecla(Tecla)
    if not Tecla then return "NO ASIGNADA" end
    return Tecla.Name:gsub("Enum.KeyCode.", "")
end

function CrearSeparador(Texto, Color)
    local Sep = Instance.new("TextLabel")
    Sep.Text = Texto
    Sep.Font = Enum.Font.GothamBold
    Sep.TextSize = 13
    Sep.TextColor3 = Color
    Sep.Size = UDim2.new(0.94, 0, 0, 28)
    Sep.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Sep.Parent = Scroll
    Instance.new("UICorner", Sep).CornerRadius = UDim.new(0, 6)
end

function CrearBotonToggle(Nombre, Clave, Callback)
    BotonesEstado[Clave] = BotonesEstado[Clave] or false
    local Btn = Instance.new("TextButton")
    Btn.Name = "Btn_"..Clave
    Btn.Text = Nombre..": "..(BotonesEstado[Clave] and "ON" or "OFF")
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Size = UDim2.new(0.94,0,0,44)
    Btn.BackgroundColor3 = BotonesEstado[Clave] and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
    Btn.Parent = Scroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)

    Btn.MouseButton1Click:Connect(function()
        BotonesEstado[Clave] = not BotonesEstado[Clave]
        Btn.Text = Nombre..": "..(BotonesEstado[Clave] and "ON" or "OFF")
        Btn.BackgroundColor3 = BotonesEstado[Clave] and Color3.fromRGB(35,130,60) or Color3.fromRGB(130,35,35)
        if Callback then Callback(BotonesEstado[Clave]) end
    end)
end

function CrearBotonTeclaConfig(Nombre, Clave)
    local Btn = Instance.new("TextButton")
    Btn.Name = "Tecla_"..Clave
    Btn.Text = Nombre..": ["..NombreTecla(Teclas[Clave]).."]"
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Size = UDim2.new(0.94,0,0,40)
    Btn.BackgroundColor3 = Color3.fromRGB(50,70,100)
    Btn.Parent = Scroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)
    BotonesTeclas[Clave] = Btn

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "⌘ PRESIONA TECLA..."
        Btn.BackgroundColor3 = Color3.fromRGB(100,60,60)
        EsperandoTecla = Clave
    end)
end

function CrearBarraDeslizante(Nombre, Variable, Min, Max, ValorInicial)
    if _G[Variable]==nil then _G[Variable]=ValorInicial end
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.94,0,0,54)
    Cont.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Cont.Parent = Scroll
    Instance.new("UICorner", Cont).CornerRadius = UDim.new(0,6)

    local Etiqueta = Instance.new("TextLabel")
    Etiqueta.Text = Nombre..": "..math.floor(_G[Variable])
    Etiqueta.Font = Enum.Font.Gotham
    Etiqueta.TextSize = 11
    Etiqueta.TextColor3 = Color3.fromRGB(255,255,255)
    Etiqueta.Size = UDim2.new(1,-10,0,20)
    Etiqueta.Position = UDim2.new(0,5,0,4)
    Etiqueta.BackgroundTransparency = 1
    Etiqueta.TextXAlignment = Enum.TextXAlignment.Left
    Etiqueta.Parent = Cont

    local Fondo = Instance.new("Frame")
    Fondo.Size = UDim2.new(1,-10,0,16)
    Fondo.Position = UDim2.new(0,5,0,34)
    Fondo.BackgroundColor3 = Color3.fromRGB(80,80,80)
    Fondo.Parent = Cont
    Instance.new("UICorner", Fondo).CornerRadius = UDim.new(1,0)

    local Relleno = Instance.new("Frame")
    Relleno.Size = UDim2.new((_G[Variable]-Min)/(Max-Min),0,1,0)
    Relleno.BackgroundColor3 = Color3.fromRGB(80,180,255)
    Relleno.Parent = Fondo
    Instance.new("UICorner", Relleno).CornerRadius = UDim.new(1,0)

    local Arrastrando=false
    Fondo.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then Arrastrando=true end end)
    UserInputService.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then Arrastrando=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if Arrastrando and i.UserInputType==Enum.UserInputType.MouseMovement then
            local Prog=math.clamp((i.Position.X-Fondo.AbsolutePosition.X)/Fondo.AbsoluteSize.X,0,1)
            _G[Variable]=math.floor(Min+Prog*(Max-Min))
            Etiqueta.Text=Nombre..": ".._G[Variable]
            Relleno.Size=UDim2.new(Prog,0,1,0)
        end
    end)
end

print("✅ [7/10] FUNCIONES DE BOTONES LISTAS")

-- ==============================================
-- DETECCIÓN DE TECLAS
-- ==============================================
UserInputService.InputBegan:Connect(function(Entrada, Procesado)
    if Procesado then return end
    if EsperandoTecla then
        if Entrada.KeyCode~=Enum.KeyCode.Unknown and Entrada.KeyCode~=Enum.KeyCode.Mouse1 and Entrada.KeyCode~=Enum.KeyCode.Mouse2 then
            Teclas[EsperandoTecla]=Entrada.KeyCode
            if BotonesTeclas[EsperandoTecla] then
                BotonesTeclas[EsperandoTecla].Text=BotonesTeclas[EsperandoTecla].Text:gsub("%[.-%]","["..NombreTecla(Entrada.KeyCode).."]")
                BotonesTeclas[EsperandoTecla].BackgroundColor3=Color3.fromRGB(50,70,100)
            end
            EsperandoTecla=nil
        end
        return
    end
    if UiVisible then
        if Teclas.MostrarOcultar and Entrada.KeyCode==Teclas.MostrarOcultar then
            UiVisible=not UiVisible
            MainFrame.Visible=UiVisible or Minimized
            if Circle then Circle.Visible=UiVisible end
            if not UiVisible then Minimized=false end
        end
        if Teclas.Aimbot and Entrada.KeyCode==Teclas.Aimbot then BotonesEstado.AimEnabled=not BotonesEstado.AimEnabled end
        if Teclas.Esp and Entrada.KeyCode==Teclas.Esp then BotonesEstado.EspEnabled=not BotonesEstado.EspEnabled end
        if Teclas.Zoom and Entrada.KeyCode==Teclas.Zoom then
            BotonesEstado.FovEnabled=not BotonesEstado.FovEnabled
            Camera.FieldOfView=BotonesEstado.FovEnabled and OriginalFOV/FovValue or OriginalFOV
        end
    end
end)

-- ==============================================
-- CREAR TODO EL PANEL AHORA
-- ==============================================
CrearSeparador("⚙️ HABILIDADES PRINCIPALES", Color3.fromRGB(255,200,40))
CrearBotonToggle("🎯 ACTIVAR AIMBOT", "AimEnabled")
CrearBotonToggle("🔫 SIN RETROCESO", "NoRecoilEnabled")
CrearBotonToggle("👁️ VER JUGADORES (ESP)", "EspEnabled")
CrearBotonToggle("🔍 ACTIVAR ZOOM", "FovEnabled", function(On)
    Camera.FieldOfView=On and OriginalFOV/FovValue or OriginalFOV
end)
CrearBotonToggle("🌙 VISIÓN NOCTURNA", "NightVision", function(On)
    if On then Lighting.Brightness=3.5 Lighting.Ambient=Color3.fromRGB(200,200,200) Lighting.OutdoorAmbient=Color3.fromRGB(200,200,200)
    else Lighting.Brightness=OriginalBrightness Lighting.Ambient=OriginalAmbient Lighting.OutdoorAmbient=OriginalOutdoorAmbient end
end)

CrearSeparador("✨ SECCIÓN DIOS — PODERES", Color3.fromRGB(255,80,255))
CrearBotonToggle("👻 TRASPASAR PAREDES", "TraspasarParedes", function(On) TraspasarParedes=On end)
CrearBotonToggle("🏃 CORRER RÁPIDO", "Correr", function(On)
    Correr=On
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed=On and (_G.VelocidadCorrer or 16) or VelocidadCamino
    end
end)
CrearBarraDeslizante("⚡ VELOCIDAD AL CORRER", "VelocidadCorrer",1,1000,16)
CrearBotonToggle("✈️ VOLAR", "Volar", function(On)
    Volar=On
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.GravityScale=On and 0 or GravedadOriginal
        LocalPlayer.Character.Humanoid.JumpPower=On and 0 or 50
    end
end)
CrearBarraDeslizante("🚀 VELOCIDAD DE VUELO", "VelocidadVolar",1,1000,50)

CrearSeparador("⌘ TECLAS CONFIGURABLES", Color3.fromRGB(100,180,255))
CrearBotonTeclaConfig("Mostrar/Ocultar Panel", "MostrarOcultar")
CrearBotonTeclaConfig("Activar Aimbot", "Aimbot")
CrearBotonTeclaConfig("Activar ESP", "Esp")
CrearBotonTeclaConfig("Activar Zoom", "Zoom")

local Info=Instance.new("TextLabel")
Info.Text="📌 INSTRUCCIONES:\n─────────────────────\n🖱️ Botón DERECHO = Apuntar\n✈️ Volar: WASD+ESPACIO+CTRL\n─────────────────────\nPulsa los botones AZULES para asignar teclas\n─────────────────────\nCírculo VERDE = Zona de apuntado\nCaja ROJA = Jugadores cercanos"
Info.Font=Enum.Font.Gotham
Info.TextSize=10
Info.TextColor3=Color3.fromRGB(160,160,160)
Info.Size=UDim2.new(0.94,0,0,110)
Info.BackgroundColor3=Color3.fromRGB(30,30,30)
Info.TextWrapped=true
Info.TextXAlignment=Enum.TextXAlignment.Left
Info.Parent=Scroll
Instance.new("UICorner",Info).CornerRadius=UDim.new(0,6)

print("✅ [8/10] TODOS LOS BOTONES CREADOS")

-- ==============================================
-- SISTEMA DE APUNTADO
-- ==============================================
function ObtenerObjetivoMasCercano()
    local MousePos=UserInputService:GetMouseLocation()
    local MejorObjetivo,MenorDist=nil,CircleRadius
    for _,Jugador in ipairs(Players:GetPlayers()) do
        if Jugador~=LocalPlayer and Jugador.Character then
            local Car=Jugador.Character
            local Raiz=Car:FindFirstChild("HumanoidRootPart")
            local Hum=Car:FindFirstChild("Humanoid")
            if Raiz and Hum and Hum.Health>0 then
                local Apuntar=Car:FindFirstChild(AimPart) or Car.Head
                local Pantalla,Visible=Camera:WorldToViewportPoint(Apuntar.Position)
                if Visible then
                    local Dist=(Vector2.new(Pantalla.X,Pantalla.Y)-Vector2.new(MousePos.X,MousePos.Y)).Magnitude
                    if Dist<MenorDist then MenorDist=Dist MejorObjetivo=Apuntar end
                end
            end
        end
    end
    return MejorObjetivo
end

-- ==============================================
-- ESP
-- ==============================================
DibujosESP={}

-- ==============================================
-- BUCLE PRINCIPAL — TODO FUNCIONA AQUÍ
-- ==============================================
RunService.RenderStepped:Connect(function()
    UpdateCircle() -- ✅ EL CÍRCULO SE ACTUALIZA AQUÍ SIEMPRE

    if not UiVisible then
        for _,J in pairs(DibujosESP) do for _,D in pairs(J) do pcall(function() D.Visible=false end) end end
        return
    end

    -- AIMBOT
    if BotonesEstado.AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local Obj=ObtenerObjetivoMasCercano()
        if Obj then Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position,Obj.Position),AimStrength/10) end
    end

    -- SIN RETROCESO
    if BotonesEstado.NoRecoilEnabled then pcall(function() Mouse.Origin=CFrame.new(Camera.CFrame.Position) end) end

    -- TRASPASAR PAREDES
    if TraspasarParedes and LocalPlayer.Character then
        pcall(function() for _,P in ipairs(LocalPlayer.Character:GetDescendants()) do if P:IsA("BasePart") then P.CanCollide=false end end end)
    elseif not TraspasarParedes and LocalPlayer.Character then
        pcall(function() for _,P in ipairs(LocalPlayer.Character:GetDescendants()) do if P:IsA("BasePart") and P.Name~="HumanoidRootPart" then P.CanCollide=true end end end)
    end

    -- CORRER
    if Correr and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed=_G.VelocidadCorrer or 16
    elseif not Correr and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed=VelocidadCamino
    end

    -- VOLAR
    if Volar and LocalPlayer.Character then
        local Raiz=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Hum=LocalPlayer.Character:FindFirstChild("Humanoid")
        if Raiz and Hum then
            Hum.GravityScale=0 Hum.JumpPower=0
            local Vel=(_G.VelocidadVolar or 50)/10
            local Dir=Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir+=Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir-=Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Dir-=Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Dir+=Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Dir+=Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Dir-=Vector3.new(0,1,0) end
            Raiz.Velocity=Raiz.CFrame:VectorToWorldSpace(Dir*Vel)
        end
    elseif not Volar and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.GravityScale=GravedadOriginal
        LocalPlayer.Character.Humanoid.JumpPower=50
    end

    -- ESP
    if not BotonesEstado.EspEnabled then
        for _,J in pairs(DibujosESP) do for _,D in pairs(J) do pcall(function() D.Visible=false end) end end
        return
    end

    for _,Jugador in ipairs(Players:GetPlayers()) do
        if Jugador==LocalPlayer then if DibujosESP[Jugador] then for _,D in pairs(DibujosESP[Jugador]) do pcall(function() D.Visible=false end) end end goto continue end
        local Car=Jugador.Character
        local Mostrar=true
        if not Car then Mostrar=false
        elseif not Car:FindFirstChild("HumanoidRootPart") then Mostrar=false
        elseif not Car:FindFirstChild("Humanoid") then Mostrar=false
        elseif Car.Humanoid.Health<=0 then Mostrar=false end
        local Raiz=Car and Car:FindFirstChild("HumanoidRootPart")
        local Hum=Car and Car:FindFirstChild("Humanoid")
        local Pantalla,Visible,DistMetros
        if Raiz then
            Pantalla,Visible=Camera:WorldToViewportPoint(Raiz.Position)
            DistMetros=math.floor((Camera.CFrame.Position-Raiz.Position).Magnitude)
            if DistMetros>MaxDistance then Visible=false end
        end
        if not Visible then Mostrar=false end
        if not Mostrar then if DibujosESP[Jugador] then for _,D in pairs(DibujosESP[Jugador]) do pcall(function() D.Visible=false end) end end goto continue end

        if not DibujosESP[Jugador] then
            DibujosESP[Jugador]={}
            pcall(function()
                DibujosESP[Jugador].Caja=Drawing.new("Square")
                DibujosESP[Jugador].Caja.Thickness=1.5
                DibujosESP[Jugador].Caja.Color=ColorEsp
                DibujosESP[Jugador].Nombre=Drawing.new("Text")
                DibujosESP[Jugador].Nombre.Size=11
                DibujosESP[Jugador].Nombre.Center=true
                DibujosESP[Jugador].BarraVidaFondo=Drawing.new("Square")
                DibujosESP[Jugador].BarraVida=Drawing.new("Square")
                DibujosESP[Jugador].TextoVida=Drawing.new("Text")
                DibujosESP[Jugador].TextoVida.Size=9
                DibujosESP[Jugador].TextoVida.Center=true
                DibujosESP[Jugador].Distancia=Drawing.new("Text")
                DibujosESP[Jugador].Distancia.Size=10
                DibujosESP[Jugador].Distancia.Center=true
            end)
        end

        local D=DibujosESP[Jugador] if not D or not D.Caja then goto continue end
        local Escala=math.clamp(180/DistMetros,0.15,1.2)
        local Altura=(Camera:WorldToViewportPoint(Vector3.new(0,2.7,0)+Raiz.Position)-Camera:WorldToViewportPoint(Vector3.new(0,-0.3,0)+Raiz.Position)).Y
        Altura=Altura*Escala local Ancho=Altura*0.4
        local X=Pantalla.X local Y=Pantalla.Y
        local Izq=X-Ancho/2 local Arr=Y-Altura/2
        local VidaPct=Hum.Health/Hum.MaxHealth

        D.Caja.Visible=true D.Caja.Position=Vector2.new(Izq,Arr) D.Caja.Size=Vector2.new(Ancho,Altura) D.Caja.Filled=false
        if D.Nombre then D.Nombre.Visible=true D.Nombre.Text=Jugador.Name D.Nombre.Color=ColorEsp D.Nombre.Position=Vector2.new(X,Arr-16) end
        if D.BarraVidaFondo and D.BarraVida then
            D.BarraVidaFondo.Visible=true D.BarraVidaFondo.Position=Vector2.new(Izq-2,Arr-8) D.BarraVidaFondo.Size=Vector2.new(Ancho+4,6) D.BarraVidaFondo.Color=Color3.fromRGB(60,60,60) D.BarraVidaFondo.Filled=true
            D.BarraVida.Visible=true D.BarraVida.Position=Vector2.new(Izq-2,Arr-8) D.BarraVida.Size=Vector2.new((Ancho+4)*VidaPct,6) D.BarraVida.Color=ColorVida D.BarraVida.Filled=true
        end
        if D.TextoVida then D.TextoVida.Visible=true D.TextoVida.Text=math.floor(Hum.Health).." HP" D.TextoVida.Color=ColorVida D.TextoVida.Position=Vector2.new(X,Arr-6) end
        if D.Distancia then D.Distancia.Visible=true D.Distancia.Text=DistMetros.." m" D.Distancia.Color=ColorDistancia D.Distancia.Position=Vector2.new(X,Arr+Altura/2+8) end

        ::continue::
    end
end)

print("✅ [9/10] BUCLE PRINCIPAL INICIADO")
print("✅ [10/10] SCRIPT CARGADO COMPLETAMENTE")
print("========================================")
print("🟢 DEBE APARECER:")
print("   - Panel con todos los botones")
print("   - Círculo VERDE que sigue al ratón")
print("   - Cajas ROJAS alrededor de jugadores")
print("========================================")
print("📌 USO:")
print("   1. Asigna teclas pulsando botones AZULES")
print("   2. Activa AIMBOT → mantén BOTÓN DERECHO para apuntar")
print("========================================")
