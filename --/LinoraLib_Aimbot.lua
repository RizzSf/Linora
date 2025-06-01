local WarnTxt = [[
     LinoraLib
====================|
Linora:AimbotLib
Version: v1
More function?
    Join Discord!
Discordlink in
    clipboard   
====================|
Enjoy Library
]]
warn(WarnTxt)
setclipboard("discord.gg/5neymGmCf6")

local function LinoraAimbot_Start()

    local Settings = getgenv().LinoraAimbot
    if not Settings then return warn("LinoraAimbot settings not found") end

    local Fovs = Settings.Fov["Fov Size"] or 40
    local MaxD = Settings["Max Distance"] or 400
    local Fcolor = Settings.Fov["Fov Color"] or Color3.fromRGB(245, 245, 245)
    local Tra = Settings.Fov["Fov Thickness"] or 2
    local teamCheck = Settings["Team Check"] or false
    local fovEnabled = Settings["Enabled"] or false

    local function Notify(Date)
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = Date.Title or "Notify",
            Text = Date.Text or "Notify Contents",
            Duration = Date.Duration or 5
        })
    end

    local maxTransparency = 0.1
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Cam = workspace.CurrentCamera

    local FOVring = Drawing.new("Circle")
    FOVring.Visible = false 
    FOVring.Thickness = Tra
    FOVring.Color = Fcolor
    FOVring.Filled = false
    FOVring.Radius = Fovs
    FOVring.Position = Cam.ViewportSize / 2

    local function updateDrawings()
        FOVring.Position = Cam.ViewportSize / 2
        FOVring.Visible = true
    end

    local function lookAt(target)
        local lookVector = (target - Cam.CFrame.Position).unit
        Cam.CFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
    end

    local function calculateTransparency(distance)
        return (1 - (distance / Fovs)) * maxTransparency
    end

    local function isPlayerAlive(player)
        local character = player.Character
        return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0
    end

    local function getClosestPlayerInFOV(trg_part)
        local nearest = nil
        local last = math.huge
        local playerMousePos = Cam.ViewportSize / 2
        local localPlayer = Players.LocalPlayer

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and (not teamCheck or player.Team ~= localPlayer.Team) then
                if isPlayerAlive(player) then
                    local part = player.Character and player.Character:FindFirstChild(trg_part)
                    if part then
                        local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                        local distance = (Vector2.new(ePos.X, ePos.Y) - playerMousePos).Magnitude

                        if distance < last and isVisible and distance < Fovs and distance < MaxD then
                            last = distance
                            nearest = player
                        end
                    end
                end
            end
        end

        return nearest
    end

    RunService.RenderStepped:Connect(function()
        if fovEnabled then
            updateDrawings()
            local closest = getClosestPlayerInFOV("Head")
            if closest and closest.Character:FindFirstChild("Head") then
                lookAt(closest.Character.Head.Position)
                local ePos = Cam:WorldToViewportPoint(closest.Character.Head.Position)
                local distance = (Vector2.new(ePos.X, ePos.Y) - (Cam.ViewportSize / 2)).Magnitude
                FOVring.Transparency = calculateTransparency(distance)
            else
                FOVring.Transparency = maxTransparency
            end
        else
            FOVring.Visible = false
        end
    end)

    Notify({
        Title = "Linora Aimbot Library",
        Text = "Free and Open Source Library",
        Duration = 5
    })
end

LinoraAimbot_Start()
