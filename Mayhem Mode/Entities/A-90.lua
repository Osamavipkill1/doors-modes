-- Decompiled with the Synapse X Luau decompiler.
local ok90, A90 = pcall(function()
    return game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainUI", 5)
        :WaitForChild("Initiator", 5):WaitForChild("Main_Game", 5)
        :WaitForChild("RemoteListener", 5):WaitForChild("Modules", 5):WaitForChild("A90", 5)
end)

local l__TweenService__1 = game:GetService("TweenService");
local l__LocalPlayer__2 = game.Players.LocalPlayer;
local u1 = ok90 and A90 and A90:FindFirstAncestor("MainUI")

function RunA90Jumpscare(p1)
	if not ok90 or not u1 then
		warn("[Mayhem/H-10] Could not find the vanilla A90 jumpscare UI -- using a fallback flash instead.")
		FallbackA90Jumpscare()
		return
	end
	if p1 and p1.dead then
		return;
	end;
	local jOk, l__Jumpscare_A90__3 = pcall(function()
		return u1.Jumpscare.Jumpscare_A90
	end)
	if not jOk or not l__Jumpscare_A90__3 then
		warn("[Mayhem/H-10] Jumpscare_A90 UI elements not found -- using a fallback flash instead.")
		FallbackA90Jumpscare()
		return
	end
	l__Jumpscare_A90__3.Visible = true;
	l__Jumpscare_A90__3.Face.ImageTransparency = 0;
	l__Jumpscare_A90__3.Face.Image = "rbxassetid://8865601671";
	l__Jumpscare_A90__3.Static.ImageTransparency = 0;
	l__Jumpscare_A90__3.Static2.ImageTransparency = 1;
	l__Jumpscare_A90__3.StopIcon.ImageTransparency = 1;
	-- Grace period: the image is up but nothing is tracked yet, so it no longer matters
	-- whether the player was mid-turn or mid-step the instant it appeared. The baseline
	-- below is captured fresh after this wait, not at the moment the image showed up.
	task.wait(0.8);
	l__Jumpscare_A90__3.StopIcon.ImageTransparency = 0;
	local l__LookVector__4 = p1.cam.CFrame.LookVector;
	local u2 = false;
	local u3 = false;
	local v5 = game:GetService("RunService").RenderStepped:Connect(function()
		if (l__LookVector__4 - p1.cam.CFrame.LookVector).Magnitude > 0.4 then
			u3 = true;
		end;
		if p1.hum.MoveDirection.Magnitude > 0.4 then
			u3 = true;
		end;
	end);
	task.wait(0.4);
	l__TweenService__1:Create(l__Jumpscare_A90__3.Static, TweenInfo.new(0.2), {ImageTransparency = 1}):Play();
	l__TweenService__1:Create(l__Jumpscare_A90__3.Static2, TweenInfo.new(0.2), {ImageTransparency = 0}):Play();
	task.wait(0.2);
	v5:Disconnect();
	pcall(function()
		game.ReplicatedStorage.EntityInfo.A90:FireServer(u3);
	end)
	if u3 then
		l__Jumpscare_A90__3.Face.Image = "rbxassetid://8865604562";
		local hitSndOk, hitSndErr = pcall(function()
			game:GetService("SoundService").Hit:Play();
		end)
		if not hitSndOk then
			warn("[Mayhem/H-10] Hit sound failed: " .. tostring(hitSndErr))
		end
		pcall(function() SetDeathCause("H-10") end)
		local Plr = game.Players.LocalPlayer
		local hum = Plr.Character and Plr.Character:FindFirstChild("Humanoid")
		if hum then
			hum.Health = math.max(hum.Health - 90, 0)
		end
		local hintOk, hintErr = pcall(function()
			game.ReplicatedStorage.EntityInfo.DeathHint:FireServer({"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the flash.", "It wants you to freeze completely, so...", "Maybe you could call it H-10?", "Anyways, I hope you don't mind trying again. It would be helpful."}, "Yellow")
		end)
		if not hintOk then
			warn("[Mayhem/H-10] DeathHint firesignal failed: " .. tostring(hintErr))
		end
		task.wait(0.5);
	else
		pcall(function()
			game:GetService("SoundService").Stopped:Play();
		end)
	end;
	task.wait(0.3);
	l__Jumpscare_A90__3.Visible = false;
end

-- Fallback: if the vanilla jumpscare UI can't be found (renamed/moved in an update),
-- run the same "freeze or get hurt" mechanic with a simple custom flash instead of
-- trying to fake the exact vanilla static/glitch animation.
function FallbackA90Jumpscare()
	local Plr = game.Players.LocalPlayer
	local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or Plr:WaitForChild("PlayerGui")
	local Camera = workspace.CurrentCamera
	local Char = Plr.Character
	local hum = Char and Char:FindFirstChild("Humanoid")
	if not hum then return end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "A90FallbackGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 100

	local Frame = Instance.new("Frame")
	Frame.Parent = ScreenGui
	Frame.BackgroundColor3 = Color3.new(1, 1, 1)
	Frame.BackgroundTransparency = 0.15
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BorderSizePixel = 0
	ScreenGui.Parent = guiParent

	-- Same grace period as the vanilla-UI path: nothing is tracked until 0.8s after
	-- the flash shows up, and the baseline is captured fresh at that point.
	task.wait(0.8)
	local startLook = Camera.CFrame.LookVector
	local moved = false
	local conn
	conn = game:GetService("RunService").RenderStepped:Connect(function()
		if (startLook - Camera.CFrame.LookVector).Magnitude > 0.4 then
			moved = true
		end
		if hum.MoveDirection.Magnitude > 0.4 then
			moved = true
		end
	end)

	task.wait(0.6)
	if conn then conn:Disconnect() end
	pcall(function() ScreenGui:Destroy() end)

	if moved then
		pcall(function() SetDeathCause("H-10") end)
		hum.Health = math.max(hum.Health - 90, 0)
		local hintOk, hintErr = pcall(function()
			game.ReplicatedStorage.EntityInfo.DeathHint:FireServer({"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the flash.", "It wants you to freeze completely, so...", "Maybe you could call it H-10?", "Anyways, I hope you don't mind trying again. It would be helpful."}, "Yellow")
		end)
		if not hintOk then
			warn("[Mayhem/H-10] DeathHint firesignal failed: " .. tostring(hintErr))
		end
	end
end

local reqOk, MainGameModule = pcall(function()
	return require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
end)
if reqOk and MainGameModule then
	RunA90Jumpscare(MainGameModule)
else
	warn("[Mayhem/H-10] Main_Game module not found -- using a fallback flash instead.")
	FallbackA90Jumpscare()
end
