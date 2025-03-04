-- Local Lib para ESP (Roblox)

local ESP = {}

ESP.Enabled = true
ESP.FOVRadius = 200
ESP.TeamColor = Color3.fromRGB(0, 0, 255)
ESP.EnemyColor = Color3.fromRGB(255, 0, 0)
ESP.ToggleKey = Enum.KeyCode.V

local function createESP(part, text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = part
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = true
    
    label.Parent = billboard
    billboard.Parent = part
end

local function drawFOVIndicator()
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = true
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Transparency = 0.5
    fovCircle.Thickness = 2
    fovCircle.Radius = ESP.FOVRadius
    
    game:GetService("RunService").RenderStepped:Connect(function()
        fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    end)
end

function ESP:Toggle()
    self.Enabled = not self.Enabled
    print(self.Enabled and "ESP Ativado" or "ESP Desativado")
end

function ESP:Init()
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local rootPart = character:WaitForChild("HumanoidRootPart")
            
            while ESP.Enabled do
                local localPlayer = game.Players.LocalPlayer
                if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (localPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                    
                    local espColor = player.Team == localPlayer.Team and ESP.TeamColor or ESP.EnemyColor
                    
                    if onScreen and distance <= ESP.FOVRadius then
                        createESP(rootPart, player.Name, espColor)
                    elseif not onScreen then
                        local arrow = Drawing.new("Triangle")
                        arrow.Visible = true
                        arrow.Color = espColor
                        arrow.Thickness = 2
                        arrow.Transparency = 1
                        
                        arrow.PointA = Vector2.new(screenPoint.X, screenPoint.Y)
                        arrow.PointB = Vector2.new(screenPoint.X - 10, screenPoint.Y + 20)
                        arrow.PointC = Vector2.new(screenPoint.X + 10, screenPoint.Y + 20)
                    end
                end
                wait(0.1)
            end
        end)
    end)
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == ESP.ToggleKey then
            ESP:Toggle()
        end
    end)

    drawFOVIndicator()
end

return ESP

-- Para usar a lib localmente:
-- local ESP = require(script.ESP)
-- ESP:Init()

-- Me avise se quiser ajustar algo ou melhorar mais ainda! 🚀