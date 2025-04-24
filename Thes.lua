loadstring([[
    local player = game.Players.LocalPlayer
    local UIS = game:GetService("UserInputService")
    local toggle = false

    local function killAura()
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")

        while toggle do
            task.wait(0.1)
            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target.Character.HumanoidRootPart
                    local distance = (root.Position - targetRoot.Position).Magnitude
                    if distance <= 10 then
                        target.Character.Humanoid:TakeDamage(99)
                    end
                end
            end
        end
    end

    UIS.InputBegan:Connect(function(input, isTyping)
        if isTyping then return end
        if input.KeyCode == Enum.KeyCode.K then
            toggle = not toggle
            if toggle then
                print("Kill Aura ON")
                spawn(killAura)
            else
                print("Kill Aura OFF")
            end
        end
    end)
]])()
