loadstring([[
-- إعداد الواجهة
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, 0, 0.5, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.Text = "تشغيل Kill Aura"
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0.5, 0)
status.Position = UDim2.new(0, 0, 0.5, 0)
status.Text = "الحالة: متوقفة"
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 255, 255)

-- المتغيرات
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local active = false

-- تثبيت اللاعب
spawn(function()
    while true do
        pcall(function()
            local humanoid = lp.Character:WaitForChild("Humanoid")
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
        wait(1)
    end
end)

-- وظيفة إيجاد أقرب عدو
function getClosestEnemy()
    local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local closest = nil
    local minDist = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (myHRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < 30 and dist < minDist then
                minDist = dist
                closest = plr
            end
        end
    end
    return closest
end

-- الهجوم التلقائي
local auraLoop
button.MouseButton1Click:Connect(function()
    active = not active
    if active then
        button.Text = "إيقاف Kill Aura"
        status.Text = "الحالة: شغّال"

        auraLoop = RunService.RenderStepped:Connect(function()
            pcall(function()
                local target = getClosestEnemy()
                if target then
                    local args = {
                        [1] = "M1",
                        [2] = target.Character.HumanoidRootPart.Position
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SkillRemote"):FireServer(unpack(args))
                end
            end)
        end)
    else
        button.Text = "تشغيل Kill Aura"
        status.Text = "الحالة: متوقفة"
        if auraLoop then auraLoop:Disconnect() end
    end
end)
]])()
