-- ==============================================
-- VERSIÓN SIMPLE Y GARANTIZADA
-- Panel visible + Círculo al ratón + Aimbot + ESP
-- ==============================================

-- CONFIGURACIÓN
local Config = {
    AimEnabled = false,
    AimPart = "Head",
    AimStrength = 5,
    CircleRadius = 150,
    FovEnabled = false,
    FovValue = 1,
    NoRecoilEnabled = false,
    EspEnabled = true,
    NightVision = false,
}

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local OriginalFOV = Camera.FieldOfView
local OriginalBrightness = Lighting.Brightness
local UiVisible = true

-- CÍRCULO QUE SIGUE AL RATÓN
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Transparency = 0.7
Circle.Radius = Config.CircleRadius
Circle.Color = Color3.fromRGB(0, 255, 0)

-- ACTUALIZAR POSICIÓN DEL CÍRCULO
local function UpdateCircle()
    local Pos = UserInputService:GetMouseLocation()
    Circle.Position = Vector2.new(Pos.X, Pos.Y)
    Circle.Visible = UiVisible
end

-- INTERFAZ GRÁFICA SIMPLE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 450)
MainFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.02, 0)

-- TÍTULO
local Title = Instance.new("TextLabel")
Title.Text = "PANEL DE ASISTENCIA"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0.02, 0)

-- CONTENEDOR DESPLAZABLE
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -40)
Scroll.Position = UDim2.new(0, 5, 0, 38)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 5
Scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Scroll

-- FUNCIÓN PARA CREAR BOTONES
local function AddButton(Texto, Clave, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Text = Texto .. ": " .. (Config[Clave] and "ON" or "OFF")
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Btn.Parent = Scroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        Config[Clave] = not Config[Clave]
        Btn.Text = Texto .. ": " .. (Config[Clave] and "ON" or "OFF")
        Btn.BackgroundColor3 = Config[Clave] and Color3.fromRGB(40, 150, 60) or Color3.fromRGB(150, 40, 40)
        if Callback then Callback(Config[Clave]) end
    end)
end

local function AddSlider(Texto, Clave, Min, Max)
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(0.9, 0, 0, 45)
    Cont.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Cont.Parent = Scroll
    Instance.new("UICorner", Cont).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = Texto .. ": " .. Config[Clave]
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 11
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.Size = UDim2.new(1, -10, 0, 18)
    Lbl.Position = UDim2.new(0, 5, 0, 3)
    Lbl.BackgroundTransparency = 1
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Cont

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, -10, 0, 10)
    Bg.Position = UDim2.new(0, 5, 0, 30)
    Bg.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    Bg.Parent = Cont
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Config[Clave]-Min)/(Max-Min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
    Fill.Parent = Bg
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Drag = false
    Bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Drag = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Drag = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if Drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = (i.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X
            Config[Clave] = math.clamp(math.floor(Min + p*(Max-Min)+0.5), Min, Max)
            Lbl.Text = Texto .. ": " .. Config[Clave]
            Fill.Size = UDim2.new((Config[Clave]-Min)/(Max-Min), 0, 1, 0)
        end
    end)
end

-- CREAR TODOS LOS BOTONES — DE FORMA GARANTIZADA
task.wait(0.3)
AddButton("ACTIVAR AIMBOT", "AimEnabled")
AddSlider("FUERZA DE SUJECIÓN", "AimStrength", 1, 10)
AddSlider("TAMAÑO DEL CÍRCULO", "CircleRadius", 50, 300)
AddButton("ACTIVAR ZOOM", "FovEnabled", function(On)
    Camera.FieldOfView = On and OriginalFOV/Config.FovValue or OriginalFOV
end)
AddSlider("ACERCAMIENTO", "FovValue", 1, 10, function()
    if Config.FovEnabled then Camera.FieldOfView = OriginalFOV/Config.FovValue end
end)
AddButton("SIN RETROCESO", "NoRecoilEnabled")
AddButton("VER JUGADORES", "EspEnabled")
AddButton("VISIÓN NOCTURNA", "NightVision", function(On)
    Lighting.Brightness = On and 3.5 or OriginalBrightness
    Lighting.Ambient = On and Color3.fromRGB(200,200,200) or Color3.fromRGB(67,84,104)
end)

-- SISTEMA DE APUNTADO
local function GetTarget()
    local MousePos = UserInputService:GetMouseLocation()
    local Best, MinD = nil, Config.CircleRadius
    for _, P in ipairs(Players:GetPlayers()) do
        if P~=LocalPlayer and P.Character and P.Character:FindFirstChild("HumanoidRootPart") and P.Character.Humanoid.Health>0 then
            local Part = P.Character:FindFirstChild(Config.AimPart) or P.Character.Head
            local Pos, Ok = Camera:WorldToViewportPoint(Part.Position)
            if Ok then
                local D = (Vector2.new(Pos.X,Pos.Y)-Vector2.new(MousePos.X,MousePos.Y)).Magnitude
                if D<MinD then MinD=D; Best=Part end
            end
        end
    end
    return Best
end

-- ESP
local ESP = {}

-- BUCLE PRINCIPAL
RunService.RenderStepped:Connect(function()
    UpdateCircle()

    -- AIMBOT
    if Config.AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local T = GetTarget()
        if T then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Position), Config.AimStrength/10) end
    end

    -- SIN RETROCESO
    if Config.NoRecoilEnabled then Mouse.Origin = CFrame.new(Camera.CFrame.Position) end

    -- DIBUJAR JUGADORES
    for _, P in ipairs(Players:GetPlayers()) do
        if P==LocalPlayer then if ESP[P] then for _,d in ipairs(ESP[P]) do d.Visible=false end end continue end
        local C=P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") or not C.Humanoid then
            if ESP[P] then for _,d in ipairs(ESP[P]) do d.Visible=false end end
            continue
        end
        local R=C.HumanoidRootPart
        local H=C.Humanoid
        local Pos, Ok = Camera:WorldToViewportPoint(R.Position)
        if not ESP[P] then ESP[P]={Box=Drawing.new("Square"),Txt=Drawing.new("Text")} end
        local D=ESP[P]
        local Ht=(Camera:WorldToViewportPoint(Vector3.new(0,2.5,0)+R.Position)-Camera:WorldToViewportPoint(Vector3.new(0,-0.5,0)+R.Position)).Y
        local W=Ht*0.4
        local Show=Config.EspEnabled and Ok and H.Health>0 and UiVisible
        D.Box.Visible=Show; D.Txt.Visible=Show
        if Show then
            D.Box.Color=Color3.fromRGB(255,0,0)
            D.Box.Position=Vector2.new(Pos.X-W/2,Pos.Y-Ht/2)
            D.Box.Size=Vector2.new(W,Ht)
            D.Txt.Text=P.Name.." | "..math.floor(H.Health).."HP"
            D.Txt.Color=Color3.fromRGB(255,0,0)
            D.Txt.Size=11
            D.Txt.Center=true
            D.Txt.Position=Vector2.new(Pos.X,Pos.Y-Ht/2-14)
        end
    end
end)

-- TECLAS RÁPIDAS
UserInputService.InputBegan:Connect(function(I, Proc)
    if Proc then return end
    if I.KeyCode==Enum.KeyCode.Insert then UiVisible=not UiVisible; MainFrame.Visible=UiVisible; Circle.Visible=UiVisible end
end)

print("✅ SCRIPT CARGADO — BOTONES VISIBLES")
