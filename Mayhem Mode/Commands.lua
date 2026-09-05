function printtest()
    print("message")
end
function blackout()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Blackout.lua"))()
end
function threat()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Threat.lua"))()
end
function mrush()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/pastebin1"))()
end
function mbush()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/pastebin2"))()
end
function meyes()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Manic%20Eyes.lua"))()
end
function twister()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Twister.lua"))()
end
function fog()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Fog.lua"))()
end
function screech()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/psstman"))()
end
function stalker()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Stalker.lua"))()
end
function obsession()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Obsession.lua"))()
end
function noseekeyes()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Seek%20Eyes.lua"))()
end
function bleed()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Bleed.lua"))()
end
function kill()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end

coroutine.wrap(function()
	local TextChatMessage
	local TextChatService = game:GetService("TextChatService")
	local Players = game:GetService("Players")
	local ProcessedCommandIds = {}

-- Command notification system (stacking, reuses the death-notif GUI from Mayhem.lua if it's already up)
local CmdPlayer = game.Players.LocalPlayer
local CmdPlayerGui = CmdPlayer:WaitForChild("PlayerGui")
local CmdTween = game:GetService("TweenService")

local NotifGui = CmdPlayerGui:FindFirstChild("MayhemDeathNotifs")
local NotifContainer

if NotifGui then
    NotifContainer = NotifGui:FindFirstChild("Container")
else
    NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "MayhemDeathNotifs"
    NotifGui.ResetOnSpawn = false
    NotifGui.IgnoreGuiInset = true
    NotifGui.DisplayOrder = 999
    NotifGui.Parent = CmdPlayerGui

    NotifContainer = Instance.new("Frame")
    NotifContainer.Name = "Container"
    NotifContainer.AnchorPoint = Vector2.new(0, 1)
    NotifContainer.Position = UDim2.new(0, 20, 1, -20)
    NotifContainer.Size = UDim2.new(0, 300, 1, -40)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Parent = NotifGui

    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    NotifLayout.Padding = UDim.new(0, 8)
    NotifLayout.Parent = NotifContainer
end

local CmdNotifCount = 0

-- text: full notification text to show, e.g. "Spawning Stalker"
function CommandNotify(text)
    CmdNotifCount = CmdNotifCount + 1
    local order = 1000 + CmdNotifCount -- keep command notifs stacking after any death notifs

    local Notif = Instance.new("Frame")
    Notif.Name = "Notif"
    Notif.LayoutOrder = order
    Notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Notif.BackgroundTransparency = 1
    Notif.BorderSizePixel = 0
    Notif.Size = UDim2.new(1, 0, 0, 40)
    Notif.ClipsDescendants = true
    Notif.Parent = NotifContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Notif

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(150, 0, 0)
    Stroke.Thickness = 1
    Stroke.Transparency = 1
    Stroke.Parent = Notif

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -16, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTransparency = 1
    Label.Text = tostring(text)
    Label.Parent = Notif

    local fadeIn = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    CmdTween:Create(Notif, fadeIn, {BackgroundTransparency = 0.15}):Play()
    CmdTween:Create(Stroke, fadeIn, {Transparency = 0}):Play()
    CmdTween:Create(Label, fadeIn, {TextTransparency = 0}):Play()

    task.delay(4, function()
        if not Notif or not Notif.Parent then return end
        local fadeOut = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local fadeOutTween = CmdTween:Create(Notif, fadeOut, {BackgroundTransparency = 1})
        CmdTween:Create(Stroke, fadeOut, {Transparency = 1}):Play()
        CmdTween:Create(Label, fadeOut, {TextTransparency = 1}):Play()
        fadeOutTween:Play()
        fadeOutTween.Completed:Wait()
        if Notif then
            Notif:Destroy()
        end
    end)
end
	TextChatService.OnIncomingMessage = function(message, TextChatMessage)
	    
		local props = Instance.new("TextChatMessageProperties")
		if message.TextSource then
			msg = string.lower(message.Text)
			local player = Players:GetPlayerByUserId(message.TextSource.UserId)
-- 3834105284
			if message.TextSource.UserId == 8530425102 then
                props.PrefixText = "<font color='#ee8fff'>[Creator]</font> " .. message.PrefixText
			end
            if message.TextSource.UserId == 709625285 then
			    props.PrefixText = "<font color='#8B0000'>[Linxy]</font> " .. message.PrefixText
            end
            if message.TextSource.UserId == 763763610 then
			    props.PrefixText = "<font color='#26142a'>[Oof]</font> " .. message.PrefixText
            end
-- 65600305
		    if message.TextSource.UserId == 3249877473 then
			    props.PrefixText = "<font color='#000000'>[NIGGER]</font> " .. message.PrefixText
			end
		    if message.TextSource.UserId == 8000493169 then
			    props.PrefixText = "<font color='#000000'>[NIGGA]</font> " .. message.PrefixText
			end
			if message.TextSource.UserId == 11145097487 then
			    props.PrefixText = "<font color='#000000'>[NIGGER]</font> " .. message.PrefixText
			end
			if message.TextSource.UserId == 3834105284 -- my main
			or message.TextSource.UserId == 4108168847 -- my alt
			or message.TextSource.UserId == 65600305 -- jen
			or message.TextSource.UserId == 8530425102
			or message.TextSource.UserId == 3249877473
			or message.TextSource.UserId == 8000493169
			or message.TextSource.UserId == 11145097487
			then
				if ProcessedCommandIds[message.MessageId] then
					return props
				end
				ProcessedCommandIds[message.MessageId] = true
				task.delay(10, function()
					ProcessedCommandIds[message.MessageId] = nil
				end)

				-- add commands here
				if msg == '/print-test' then
					coroutine.wrap(printtest)()
				end
				if msg == '/blackout' then
					CommandNotify("Spawning Blackout")
					coroutine.wrap(blackout)()
				end
				if msg == '/stalker' then
					CommandNotify("Spawning Stalker")
					coroutine.wrap(stalker)()
				end
				if msg == '/screech' then
					CommandNotify("Spawning Screech")
					coroutine.wrap(screech)()
				end
				if msg == '/threat' then
					CommandNotify("Spawning Threat")
					coroutine.wrap(threat)()
				end
				if msg == '/obsession' then
					CommandNotify("Spawning Obsession")
					coroutine.wrap(obsession)()
				end
				if msg == '/twister' then
					CommandNotify("Spawning Twister")
					coroutine.wrap(twister)()
				end
				if msg == '/fog' then
					CommandNotify("Spawning Fog")
					coroutine.wrap(fog)()
				end
				if msg == '/rush' then
					CommandNotify("Spawning Rush")
					coroutine.wrap(mrush)()
				end
				if msg == '/ambush' then
					CommandNotify("Spawning Ambush")
					coroutine.wrap(mbush)()
				end
				if msg == '/bleed' then
					CommandNotify("Spawning Bleed")
					coroutine.wrap(bleed)()
				end
				if msg == '/eyes' then
					CommandNotify("Spawning Manic Eyes")
					coroutine.wrap(meyes)()
				end
				if msg == '/kill' then
					coroutine.wrap(kill)()
				end
				if msg == '/noseekeyes' then
					coroutine.wrap(noseekeyes)()
				end
		    end
		    return props	
		end
    end
end)()
