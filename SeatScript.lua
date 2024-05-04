local realseat = script:WaitForChild("RealSeat").Value
local CD = script.Parent
local seatFilled = false

local players = game:GetService("Players")

script.Parent.MouseClick:Connect(function(player)
    if seatFilled then return end
    realseat.Disabled = false
    realseat:Sit(player.Character:WaitForChild("Humanoid"))
end)

realseat:GetPropertyChangedSignal("Occupant"):Connect(function()
    if realseat.Occupant then
        seatFilled = true
        CD.MaxActivationDistance = 0
        script.Parent.Parent.Parent.FillColour.Value = Color3.fromRGB(245, 30, 0)
    else
        seatFilled = false
        CD.MaxActivationDistance = 10
        script.Parent.Parent.Parent.FillColour.Value = Color3.fromRGB(2, 255, 0)
    end
end)

game["Run Service"].Heartbeat:Connect(function()
    if not realseat.Occupant then
        if realseat.Disabled == false then
            realseat.Disabled = true
        end
    end
end)
