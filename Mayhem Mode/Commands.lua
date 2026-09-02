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
    loadstring(game:HttpGet("https://gist.githubusercontent.com/wubbubunga-tll/4577981974e05867fdb9e646a552aeba/raw/bb77666b1e693d24ac741af90068d38f1032a886/psstman.lua"))()
end
function stalker()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Stalker.lua"))()
end
function obsession()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Obsession.lua"))()
end
function sus()
    local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Source.lua"))()


-- Create entity
local entityTable = Spawner.createEntity({
    CustomName = "Amogus", -- Custom name of your entity
    Model = "https://github.com/wubbubunga-tll/MayhemMode/blob/main/Amogus.rbxm?raw=true", -- Can be GitHub file or rbxassetid
    Speed = 100, -- Percentage, 100 = default Rush speed
    DelayTime = 2, -- Time before starting cycles (seconds)
    HeightOffset = 0,
    CanKill = true,
    KillRange = 50,
    BackwardsMovement = false,
    BreakLights = true,
    FlickerLights = {
        true, -- Enabled/Disabled
        1, -- Time (seconds)
    },
    Cycles = {
        Min = 10000,
        Max = 20000,
        WaitTime = 0,
    },
    CamShake = {
        true, -- Enabled/Disabled
        {3.5, 20, 0.1, 1}, -- Shake values (don't change if you don't know)
        100, -- Shake start distance (from Entity to you)
    },
    Jumpscare = {
        true, -- Enabled/Disabled
        {
            Image1 = "rbxassetid://6696296215", -- Image1 url
            Image2 = "rbxassetid://9260510303", -- Image2 url
            Shake = true,
            Sound1 = {
                10483790459, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Sound2 = {
                10483837590, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Flashing = {
                false, -- Enabled/Disabled
                Color3.fromRGB(255, 255, 255), -- Color
            },
            Tease = {
                true, -- Enabled/Disabled
                Min = 1,
                Max = 3,
            },
        },
    },
    CustomDialog = {"STOP POSTING ABOUT AMONG US!", "I'M TIRED OF SEEING IT!", "My friends on TikTok send me memes, on Discord its memes.", "I was in a server, right, and ALL the channels are just Among Us stuff.", "Ding Ding Ding Ding Ding Ding Ding DiDiDing!"}, -- Custom death message
    Color = "Yellow"
})

-- Run the created entity
Spawner.runEntity(entityTable)
end
function kill()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end
coroutine.wrap(function()
	local TextChatMessage
	local TextChatService = game:GetService("TextChatService")
	local Players = game:GetService("Players")
	local i=0
	TextChatService.OnIncomingMessage = function(message, TextChatMessage)
	    
		local props = Instance.new("TextChatMessageProperties")
		if message.TextSource then
			msg = string.lower(message.Text)
			local player = Players:GetPlayerByUserId(message.TextSource.UserId)
			if player == game.Players.LocalPlayer then
				i=i+1
				if i==2 then
					i=0
					return props
				end
			end
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
			if message.TextSource.UserId == 3834105284 -- my main
			or message.TextSource.UserId == 4108168847 -- my alt
			or message.TextSource.UserId == 65600305 -- jen
			then
				-- add commands here
				if msg == '/print-test' then
					coroutine.wrap(printtest)()
				end
				if msg == '/blackout' then
					coroutine.wrap(blackout)()
				end
				if msg == '/sus' then
					coroutine.wrap(sus)()
				end
				if msg == '/stalker' then
					coroutine.wrap(stalker)()
				end
				if msg == '/screech' then
					coroutine.wrap(screech)()
				end
				if msg == '/threat' then
					coroutine.wrap(threat)()
				end
				if msg == '/obsession' then
					coroutine.wrap(obsession)()
				end
				if msg == '/twister' then
					coroutine.wrap(twister)()
				end
				if msg == '/fog' then
					coroutine.wrap(fog)()
				end
				if msg == '/rush' then
					coroutine.wrap(mrush)()
				end
				if msg == '/ambush' then
					coroutine.wrap(mbush)()
				end
				if msg == '/eyes' then
					coroutine.wrap(meyes)()
				end
				if msg == '/kill' then
					coroutine.wrap(kill)()
				end
		    end
		    return props	
		end
    end
end)()
