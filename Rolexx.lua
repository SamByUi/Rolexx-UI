local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local screenGui = script.Parent.Parent

local floatingWindow = screenGui:WaitForChild("FloatingWindow")
local mainUI = script.Parent
local bySamLabel = mainUI:WaitForChild("BySamLabel")
local closeButton = mainUI:WaitForChild("CloseButton")

mainUI.Visible = false
mainUI.ImageTransparency = 1
local isMainUIOpen = false
local UIS = game:GetService("UserInputService")
local dragging = false
local dragInput, dragStart, startPos

local function dragify(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput then
            dragInput = input
        end
    end)
end

dragify(floatingWindow)
local function showMainUI()
    local fadeOutTween = TweenService:Create(floatingWindow, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    fadeOutTween:Play()

    fadeOutTween.Completed:Connect(function()
        floatingWindow.Visible = false
        mainUI.Visible = true
        mainUI.ImageTransparency = 1
        local fadeInTween = TweenService:Create(mainUI, TweenInfo.new(0.5), {ImageTransparency = 0})
        fadeInTween:Play()
        isMainUIOpen = true
    end)
end
local function hideMainUI()
    local fadeOutTween = TweenService:Create(mainUI, TweenInfo.new(0.5), {ImageTransparency = 1})
    fadeOutTween:Play()

    fadeOutTween.Completed:Connect(function()
        mainUI.Visible = false
        floatingWindow.Visible = true
        local fadeInTween = TweenService:Create(floatingWindow, TweenInfo.new(0.5), {BackgroundTransparency = 0})
        fadeInTween:Play()
        isMainUIOpen = false
    end)
end
floatingWindow.MouseButton1Click:Connect(function()
    if not isMainUIOpen then
        showMainUI()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if isMainUIOpen then
        hideMainUI()
    end
end)
