local TweenService = game:GetService("TweenService")
local NSSConfig = require(script.Parent.Parent.Parent.BUS_CONFIG).NSSConfig

if not NSSConfig.NSSEnabled then
    script.Disabled = true
    return
end

local mode = NSSConfig.ReadMethod

local detectmode = NSSConfig.DetectionMethod

local capitalize = NSSConfig.OnlyCapitals

local clear = NSSConfig.RemoveNSOnStop

local display = script.Parent.SRSystem.Screen

if not script.Parent.SRSystem.Screen:FindFirstChild("ScrollingTester") then
    local scrollingtester = display.SurfaceGui:Clone()
    scrollingtester.Parent = display
    scrollingtester.Name = "ScrollingTester"
    scrollingtester.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    scrollingtester.Face = Enum.NormalId.Bottom
end

local testDisplaylabel = script.Parent.SRSystem.Screen.ScrollingTester.TextLabel

local locale = require(script.Parent.Parent.Parent.BUS_CONFIG).General.locale

local NS = nil

local SR = false

local function Clicked()
    if not SR then
        script.Parent.SoundSystem.SpeakerANN.StopRequested:Play()
    end
    script.Parent.SRSystem.Cord.FillColour.Value = Color3.fromRGB(231, 45, 11)
    SR = true
    script.Parent.SRSystem.Cord.ClickDetector.MaxActivationDistance = 0
    script.Parent.Values.RDoor:GetPropertyChangedSignal("Value"):Once(function()
        SR = false
        script.Parent.SRSystem.Cord.ClickDetector.MaxActivationDistance = 32
        script.Parent.SRSystem.Cord.FillColour.Value = Color3.fromRGB(32, 236, 22)
    end)
    script.Parent.Values.FDoor:GetPropertyChangedSignal("Value"):Once(function()
        script.Parent.SRSystem.Cord.ClickDetector.MaxActivationDistance = 32
        script.Parent.SRSystem.Cord.FillColour.Value = Color3.fromRGB(32, 236, 22)
    end)
    script.Parent.Values.RDoorUnlocked:GetPropertyChangedSignal("Value"):Once(function()
        script.Parent.SRSystem.Cord.ClickDetector.MaxActivationDistance = 32
        script.Parent.SRSystem.Cord.FillColour.Value = Color3.fromRGB(32, 236, 22)
    end)
end

script.Parent.SRSystem.TouchPart.ClickDetector.MouseClick:Connect(Clicked)
script.Parent.SRSystem.TouchPart2.ClickDetector.MouseClick:Connect(Clicked)
script.Parent.SRSystem.Cord.ClickDetector.MouseClick:Connect(Clicked)

if detectmode == "Wheel" then
    script.Parent.Parent.Wheels.FR.Touched:Connect(function(part)
        if mode == "Attribute" then
            if (part:GetAttribute("NSSBlock")) and (part:GetAttribute("NextStop") ~= nil) then
                if capitalize then
                    NS = string.upper(part:GetAttribute("NextStop"))
                else
                    NS = part:GetAttribute("NextStop")
                end
            end
        elseif mode == "PhysicalValue" then
            if (part:FindFirstChild("NSSBlock")) and (part:FindFirstChild("NextStop")) then
                if capitalize then
                    NS = string.upper(part:FindFirstChild("NextStop").Value)
                else
                    NS = part:FindFirstChild("NextStop").Value
                end
            end
        end
    end)
elseif detectmode == "DetectPart" then
    script.Parent.NSSDetect.Touched:Connect(function(part)
        if mode == "Attribute" then
            if (part:GetAttribute("NSSBlock")) and (part:GetAttribute("NextStop") ~= nil) then
                if capitalize then
                    NS = string.upper(part:GetAttribute("NextStop"))
                else
                    NS = part:GetAttribute("NextStop")
                end
                if part:FindFirstChild("Announcement") then
                    part:FindFirstChild("Announcement"):Play()
                end
            end
        elseif mode == "PhysicalValue" then
            if (part:FindFirstChild("NSSBlock")) and (part:FindFirstChild("NextStop")) then
                if capitalize then
                    NS = string.upper(part:FindFirstChild("NextStop").Value)
                else
                    NS = part:FindFirstChild("NextStop").Value
                end
                if part:FindFirstChild("Announcement") then
                    part:FindFirstChild("Announcement"):Play()
                end
            end
        end
    end)
end

script.Parent.Values.RDoorUnlocked:GetPropertyChangedSignal("Value"):Connect(function()
    if script.Parent.Values.RDoorUnlocked.Value then
        if clear then
            NS = nil
        end
        SR = false
    end
end)

script.Parent.Values.RDoor:GetPropertyChangedSignal("Value"):Connect(function()
    if script.Parent.Values.RDoor.Value then
        if clear then
            NS = nil
        end
        SR = false
    end
end)

while task.wait(2) do
    if script.Parent.SRSystem.Started.Value then
        if SR then
            display.SurfaceGui.TextLabel.Text = "STOP REQUESTED"
            task.wait(2)
        end
        if NS then
            testDisplaylabel.Size = UDim2.new(0, 200, 0, 22)
            testDisplaylabel.Text = ""
            task.wait(0.2)
            testDisplaylabel.Text = NS
            if not testDisplaylabel.TextFits then
                display.SurfaceGui.TextLabel.Text = ""
                display.SurfaceGui.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                repeat
                    testDisplaylabel.Size = UDim2.new(0, testDisplaylabel.Size.X.Offset + 5, 0,
                        testDisplaylabel.Size.Y.Offset)
                until testDisplaylabel.TextFits

                testDisplaylabel.Size = UDim2.new(0, testDisplaylabel.Size.X.Offset * 1.3, 0,
                    testDisplaylabel.Size.Y.Offset)

                task.wait(0.2)

                display.SurfaceGui.TextLabel.Size = testDisplaylabel.Size
                display.SurfaceGui.TextLabel.Position = UDim2.new(1, 0, 0, 0)
                display.SurfaceGui.TextLabel.Text = NS
                local t = TweenService:Create(display.SurfaceGui.TextLabel,
                    TweenInfo.new(6 * string.len(NS) / string.len("Oakridge-41st Avenue @ Bay 5"),
                        Enum.EasingStyle.Linear),
                    { Position = UDim2.new(0, -display.SurfaceGui.TextLabel.AbsoluteSize.X, 0, 0) })
                t:Play()
                t.Completed:Wait()
                task.wait(0.2)

                testDisplaylabel.Size = UDim2.new(0, 200, 0, 22)
                testDisplaylabel.Text = ""

                display.SurfaceGui.TextLabel.Text = ""
                display.SurfaceGui.TextLabel.TextXAlignment = Enum.TextXAlignment.Center
                display.SurfaceGui.TextLabel.Size = UDim2.new(0, 170, 0, display.SurfaceGui.TextLabel.Size.Y.Offset)
                display.SurfaceGui.TextLabel.Position = UDim2.new(0, 0, 0, 0)
            else
                display.SurfaceGui.TextLabel.TextXAlignment = Enum.TextXAlignment.Center
                display.SurfaceGui.TextLabel.Position = UDim2.new(0, 0, 0, 0)
                display.SurfaceGui.TextLabel.Text = NS
                task.wait(2)
            end
        end
        display.SurfaceGui.TextLabel.Text = string.sub(game.Lighting.TimeOfDay, 1, 5)
        task.wait(2)
        display.SurfaceGui.TextLabel.Text = DateTime.now():FormatLocalTime("LL", locale)
    end
end
