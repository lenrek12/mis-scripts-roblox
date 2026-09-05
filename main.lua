-- =============================================================================
-- VERSIÓN SOLO DIBUJO — SIN BOTONES DE INTERFAZ
-- =============================================================================

print("")
print("╔════════════════════════════════════════════╗")
print("║  VERSIÓN SOLO DIBUJO — SIN INTERFAZ GUI   ║")
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
-- VARIABLES
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

OriginalFOV = Camera.FieldOfView
OriginalBrightness = Lighting.Brightness
OriginalAmbient = Lighting.Ambient
OriginalOutdoorAmbient = Lighting.OutdoorAmbient
GravedadOriginal = 196.2
VelocidadCorrerValor = 55
VelocidadVolarValor = 60

-- TECLAS POR DEFECTO
Teclas = {
    MostrarOcultar = Enum.KeyCode.RightShift,  -- ⇧ MAYÚSCULAS DERECHA
    Aimbot = Enum.KeyCode.Q,
    Esp = Enum.KeyCode.E,
    Zoom = Enum.KeyCode.R,
    Volar = Enum.KeyCode.V,
    Correr = Enum.KeyCode.C,
}

-- COLORES
ColorCirculo = Color3.fromRGB(0, 255, 0)
ColorOn = Color3.fromRGB(0, 255, 100)
ColorOff = Color3.fromRGB(255, 60, 60)
ColorTexto = Color3.fromRGB(255, 255, 255)
ColorEsp = Color3.fromRGB(255, 40, 40)

-- ==============================================
-- CÍRCULO DEL AIMBOT
-- ==============================================
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Thickness = 2.5
Circle.NumSides = 72
Circle.Transparency = 0.9
Circle.Radius = CircleRadius
Circle.Color = ColorCirculo
Circle.Filled = false

-- ==============================================
-- TEXTO DEL MENÚ DIBUJADO
-- ==============================================
local TextoMenu = Drawing.new("Text")
TextoMenu.Visible = true
TextoMenu.Size = 13
TextoMenu.Center = false
TextoMenu.Outline = true
TextoMenu.Font = 2

-- ==============================================
-- ACTUALIZAR CÍRCULO
-- ==============================================
local function ActualizarCirculo()
    local Pos = UserInputService:GetMouseLocation()
    Circle.Position = Vector2.new(Pos.X, Pos.Y)
    Circle.Visible = UiVisible
end

-- ==============================================
-- ACTUALIZAR TEXTO DEL MENÚ EN PANTALLA
-- ==============================================
local function ActualizarMenuTexto()
    if not UiVisible then
        TextoMenu.Visible = false
        return
    end

    local Lineas = {}
    table.insert(Lineas, "═══ PANEL DE ASISTENCIA ═══")
    table.insert(Lineas, "")
    table.insert(Lineas, "🎯 AIMBOT  [Q]: "..(AimEnabled and "✅ ACTIVADO" or "❌ DESACTIVADO"))
    table.insert(Lineas, "👁️ ESP     [E]: "..(EspEnabled and "✅ ACTIVADO" or "❌ DESACTIVADO"))
    table.insert(Lineas, "🔫 SIN REC:      "..(NoRecoilEnabled and "✅ ACTIVADO" or "❌ DESACTIVADO"))
    table.insert(Lineas, "🔍 ZOOM    [R]: "..(FovEnabled and "✅ ACTIVADO" or "❌ DESACTIVADO"))
    table.insert(Lineas, "🌙 NOCHE:        "..(NightVision and "✅ ACTIVADO" or "❌ DESACTIVADO"))
    table.insert(Lineas, "👻 PAREDES:      "..(TraspasarParedes and "✅ ACTIVADO" or "❌ DESACTIVADO"))
    table.insert(Lineas, "🏃 CORRER  [C]: "..(Correr and "✅ ACTIVADO" or "❌ DESACTIVADO"))
    table.insert(Lineas, "✈️ VOLAR   [V]: "..(Volar and "✅ ACTIVADO" or "❌ DESACTIVADO"))
    table.insert(Lineas, "")
    table.insert(Lineas, "═══ TECLAS ═══")
    table.insert(Lineas, "⇧ MAYÚSCULAS → MOSTRAR/OCULTAR")
    table.insert(Lineas, "🖱️ BOTÓN DERECHO → APUNTAR (Aimbot ON)")
    table.insert(Lineas, "✈️ WASD + ESPACIO → VOLAR")

    TextoMenu.Text = table.concat(Lineas, "\n")
    TextoMenu.Position = Vector2.new(15, 15)
    TextoMenu.Color = ColorTexto
    TextoMenu.Visible = true
end

-- ==============================================
-- DETECTAR TECLAS PRESIONADAS
-- ==============================================
UserInputService.InputBegan:Connect(function(Entrada, Procesado)
    if Procesado then return end

    -- MOSTRAR/OCULTAR TODO
    if Teclas.MostrarOcultar and Entrada.KeyCode == Teclas.MostrarOcultar then
        UiVisible = not UiVisible
        Circle.Visible = UiVisible
        return
    end

    if not UiVisible then return end

    -- TECLAS DE ACTIVACIÓN
    if Teclas.Aimbot and Entrada.KeyCode == Teclas.Aimbot then
        AimEnabled = not AimEnabled
    end
    if Teclas.Esp and Entrada.KeyCode == Teclas.Esp then
        EspEnabled = not EspEnabled
    end
    if Teclas.Zoom and Entrada.KeyCode == Teclas.Zoom then
        FovEnabled = not FovEnabled
        Camera.FieldOfView = FovEnabled and OriginalFOV / 2 or OriginalFOV
    end
    if Entrada.KeyCode == Enum.KeyCode.X then
        NoRecoilEnabled = not NoRecoilEnabled
    end
    if Entrada.KeyCode == Enum.KeyCode.Z then
        NightVision = not NightVision
        if NightVision then
            Lighting.Brightness = 3.5
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        else
            Lighting.Brightness = OriginalBrightness
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        end
    end
    if Entrada.KeyCode == Enum.KeyCode.G then
        TraspasarParedes = not TraspasarParedes
    end
    if Teclas.Correr and Entrada.KeyCode == Teclas.Correr then
        Correr = not Correr
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Correr and VelocidadCorrerValor or 16
        end
    end
    if Teclas.Volar and Entrada.KeyCode == Teclas.Volar then
        Volar = not Volar
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.GravityScale = Volar and 0 or GravedadOriginal
        end
    end
end)

-- ==============================================
-- OBTENER JUGADOR MÁS CERCANO
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
                    if D < Menor then
                        Menor = D
                        Mejor = Cabeza
                    end
                end
            end
        end
    end
    return Mejor
end

-- ==============================================
-- ESP
-- ==============================================
local DibujosESP = {}

-- ==============================================
-- BUCLE PRINCIPAL
-- ==============================================
RunService.RenderStepped:Connect(function()
    ActualizarCirculo()
    ActualizarMenuTexto()

    if not UiVisible then
        for _,J in pairs(DibujosESP) do
            for _,D in pairs(J) do pcall(function() D.Visible = false end) end
        end
        return
    end

    -- AIMBOT
    if AimEnabled and UserInputService:IsMouseButtonDown(Enum.UserInputType.MouseButton2) then
        local Obj = ObtenerObjetivo()
        if Obj then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Obj.Position), AimStrength/10)
        end
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
        LocalPlayer.Character.Humanoid.WalkSpeed = VelocidadCorrerValor
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
            R.Velocity = R.CFrame:VectorToWorldSpace(Dir * (VelocidadVolarValor/10))
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
        if Dist > MaxDistanceESP then Visible = false end
        if not Vis then
            if DibujosESP[P] then for _,D in pairs(DibujosESP[P]) do pcall(function() D.Visible = false end) end end
            continue
        end

        if not DibujosESP[P] then
            DibujosESP[P] = {
                Caja = Drawing.new("Square"),
                Nombre = Drawing.new("Text"),
                Vida = Drawing.new("Text")
            }
            DibujosESP[P].Caja.Thickness = 2
            DibujosESP[P].Caja.Color = ColorEsp
            DibujosESP[P].Caja.Filled = false
            DibujosESP[P].Nombre.Size = 11
            DibujosESP[P].Nombre.Center = true
            DibujosESP[P].Nombre.Color = ColorEsp
            DibujosESP[P].Vida.Size = 10
            DibujosESP[P].Vida.Center = true
            DibujosESP[P].Vida.Color = Color3.fromRGB(40,255,40)
        end

        local D = DibujosESP[P]
        local Arriba = Camera:WorldToViewportPoint(R.Position + Vector3.new(0,2.5,0))
        local Abajo = Camera:WorldToViewportPoint(R.Position + Vector3.new(0,-0.3,0))
        local Alt = Abajo.Y - Arriba.Y
        local Anc = Alt * 0.4
        local X = Pos.X
        local Yp = Pos.Y

        D.Caja.Visible = true
        D.Caja.Position = Vector2.new(X - Anc/2, Yp - Alt/2)
        D.Caja.Size = Vector2.new(Anc, Alt)

        D.Nombre.Visible = true
        D.Nombre.Text = P.Name
        D.Nombre.Position = Vector2.new(X, Yp - Alt/2 - 14)

        D.Vida.Visible = true
        D.Vida.Text = math.floor(C.Humanoid.Health).." HP"
        D.Vida.Position = Vector2.new(X, Yp + Alt/2 + 6)
    end
end)

print("✅ ========================================")
print("✅ SCRIPT CARGADO — VERSIÓN SOLO DIBUJO")
print("✅ ========================================")
print("✅ DEBES VER:")
print("✅ 🟢 CÍRCULO VERDE → sigue al ratón")
print("✅ 📋 TEXTO EN LA ESQUINA SUPERIOR IZQUIERDA")
print("✅ ========================================")
print("⌨️ TECLAS:")
print("   Q → Aimbot | E → ESP | R → Zoom")
print("   C → Correr | V → Volar")
print("   X → Sin Retroceso | Z → Visión Nocturna | G → Traspasar")
print("   MAYÚSCULAS DERECHA → Mostrar/Ocultar todo")
print("   BOTÓN DERECHO → Apuntar (con Aimbot activado)")
print("✅ ========================================")
