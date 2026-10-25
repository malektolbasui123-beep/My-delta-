local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedBtn = Instance.new("TextButton")
local FlyBtn = Instance.new("TextButton")
local JumpBtn = Instance.new("TextButton")
local ResetBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "MatrixGui"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 340)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "1010010101 MATRIX 1010010101"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextSize = 16
Title.Font = Enum.Font.Code

local function designButton(btn, text, yPos)
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.TextSize = 14
    btn.Font = Enum.Font.Code
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0, 255, 0)
end

designButton(SpeedBtn, "🟢 SPEED KHARAQ (100)", 60)
designButton(FlyBtn, "🟢 FLY (اضغط للطيران)", 120)
designButton(JumpBtn, "🟢 INFINITE JUMP (تفعيل)", 180)
designButton(ResetBtn, "🔴 RESET TO NORMAL", 260)
ResetBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
ResetBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)

SpeedBtn.MouseButton1Click:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

local flying = false
local flySpeed = 45
FlyBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    flying = not flying
    if flying then
        FlyBtn.Text = "🔴 FLYING (شغال الآن)"
        local bv = Instance.new("BodyVelocity")
        bv.Name = "DeltaFly"
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        task.spawn(function()
            while flying and root and root.Parent do
                local camera = workspace.CurrentCamera
                bv.velocity = camera.CFrame.LookVector * flySpeed
                task.wait(0.05)
            end
            if bv then bv:Destroy() end
        end)
    else
        FlyBtn.Text = "🟢 FLY (اضغط للطيران)"
        if root:FindFirstChild("DeltaFly") then root.DeltaFly:Destroy() end
    end
end)

local infJump = false
JumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    if infJump then
        JumpBtn.Text = "🔴 INF JUMP (شغال)"
    else
        JumpBtn.Text = "🟢 INFINITE JUMP (تفعيل)"
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

ResetBtn.MouseButton1Click:Connect(function()
    flying = false
    infJump = false
    FlyBtn.Text = "🟢 FLY (اضغط للطيران)"
    JumpBtn.Text = "🟢 INFINITE JUMP (تفعيل)"
    local char = game.Players.LocalPlayer.Character
    if char then
        if char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end
        if char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("DeltaFly") then
            char.HumanoidRootPart.DeltaFly:Destroy()
        end
    end
end)
