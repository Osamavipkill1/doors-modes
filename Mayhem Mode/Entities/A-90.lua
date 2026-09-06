-- Decompiled with the Synapse X Luau decompiler.
local A90 = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Initiator["Main_Game"].RemoteListener.Modules.A90
local l__TweenService__1 = game:GetService("TweenService");
local l__LocalPlayer__2 = game.Players.LocalPlayer;
local u1 = A90:FindFirstAncestor("MainUI");
function e(p1, p2)
	if p1.dead then
		return;
	end;
	local l__Jumpscare_A90__3 = u1.Jumpscare.Jumpscare_A90
	l__Jumpscare_A90__3.BackgroundTransparency = 1;
	l__Jumpscare_A90__3.Face.Visible = true;
	l__Jumpscare_A90__3.FaceAngry.Visible = false;
	l__Jumpscare_A90__3.Static.Visible = true;
	l__Jumpscare_A90__3.Static2.Visible = true;
	l__Jumpscare_A90__3.Static.ImageTransparency = 1;
	l__Jumpscare_A90__3.Static2.ImageTransparency = 1;
	game.SoundService.Main.Volume = 0;
	l__Jumpscare_A90__3.Face.ImageColor3 = Color3.new(0, 0, 0);
	l__Jumpscare_A90__3.Face.Position = UDim2.new(math.random(10, 90) / 100, 0, math.random(10, 90) / 100, 0);
	l__Jumpscare_A90__3.Visible = true;
	A90.Spawn.SoundGroup = nil;
	A90.Hit.SoundGroup = nil;
	A90.Spawn:Play();
	task.wait(0.03333333333333333);
	l__Jumpscare_A90__3.Face.ImageColor3 = Color3.new(1, 1, 1);
	task.wait(0.48);
	l__Jumpscare_A90__3.BackgroundTransparency = 0;
	l__Jumpscare_A90__3.Face.Position = UDim2.new(0.5, 0, 0.49, 0);
	task.wait(0.03333333333333333);
	l__Jumpscare_A90__3.StopIcon.Visible = true;
	l__Jumpscare_A90__3.BackgroundColor3 = Color3.new(0, 0, 0);
	l__Jumpscare_A90__3.BackgroundTransparency = 1;
	l__Jumpscare_A90__3.Static.ImageTransparency = 0.8;
	l__Jumpscare_A90__3.Static2.ImageTransparency = 0.8;
	local u2 = true;
	local u3 = false;
	local l__LookVector__4 = p1.cam.CFrame.LookVector;
	task.delay(0.4, function()
		l__Jumpscare_A90__3.StopIcon.Visible = false;
		while u2 do
			task.wait(0.03333333333333333);
			l__Jumpscare_A90__3.Static.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0);
			l__Jumpscare_A90__3.Static.Rotation = math.random(0, 1) * 180;
			l__Jumpscare_A90__3.Static2.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0);
			l__Jumpscare_A90__3.Static2.Rotation = math.random(0, 1) * 180;
			l__Jumpscare_A90__3.Face.Position = UDim2.new(0.5, 0, 0.49, math.random(-1, 1));
			l__Jumpscare_A90__3.FaceAngry.Position = UDim2.new(0.5 + math.random(-100, 100) / 50000, 0, 0.49 + math.random(-100, 100) / 30000, math.random(-1, 1));
			local v4 = math.random(0, 1);
			l__Jumpscare_A90__3.FaceAngry.ImageColor3 = Color3.new(1, v4, v4);
			if not u3 then
				if (l__LookVector__4 - p1.cam.CFrame.LookVector).Magnitude > 0.4 then
					print("LOOKED TOO FAR AWAY");
					u3 = true;
				end;
				if p1.hum.MoveDirection.Magnitude > 0.4 then
					print("KEPT MOVING");
					u3 = true;
				end;
			end;		
		end;
	end);
	task.wait(0.5);
	l__Jumpscare_A90__3.BackgroundColor3 = Color3.new(0, 0, 0);
	l__Jumpscare_A90__3.BackgroundTransparency = 0;
	l__Jumpscare_A90__3.Static.ImageTransparency = 0;
	l__Jumpscare_A90__3.Static2.ImageTransparency = 0.5;
	task.wait(0.03333333333333333);
	l__Jumpscare_A90__3.Face.ImageColor3 = Color3.new(1, 0, 0);
	task.wait(0.03333333333333333);
	l__Jumpscare_A90__3.Visible = false;
	task.wait(0.08);
	if u3 then
		l__Jumpscare_A90__3.Visible = true;
		A90.Hit:Play();
		task.wait(0.03333333333333333);
		l__Jumpscare_A90__3.Face.ImageColor3 = Color3.new(1, 1, 1);
		task.wait(0.03333333333333333);
		l__Jumpscare_A90__3.BackgroundTransparency = 0;
		l__Jumpscare_A90__3.Static.ImageTransparency = 0;
		l__Jumpscare_A90__3.Static2.ImageTransparency = 0.5;
		task.wait(0.06666666666666667);
		l__Jumpscare_A90__3.FaceAngry.ImageColor3 = Color3.new(1, 0, 0);
		l__Jumpscare_A90__3.FaceAngry.Visible = true;
		task.wait(0.06666666666666667);
		l__Jumpscare_A90__3.FaceAngry.ImageColor3 = Color3.new(1, 1, 1);
		l__Jumpscare_A90__3.Face.Visible = false;
		l__Jumpscare_A90__3.FaceAngry.Size = UDim2.new(0.8, 0, 0.8, 0);
		task.wait(0.75);
		game.ReplicatedStorage.EntityInfo.A90:FireServer(u3);
		local Players = game:GetService("Players")
        local Plr = Players.LocalPlayer
        local ReSt = game:GetService("ReplicatedStorage")
        ReSt.GameStats["Player_".. Plr.Name].Total.DeathCause.Value = "H-10"
        local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "That one is very similar to A-90.", "It spawns after Door 10 in The Hotel, so...", "Maybe you could call it H-10?", "Anyways, I hope you don't mind trying again. It would be helpful."} -- death message
        local color = "Yellow"
        firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
        function calcHp(val)
            val = val - 90
            if val <= 0 then
               val = 0
            end
            return val
        end
        Plr.Character.Humanoid.Health = calcHp(Plr.Character.Humanoid.Health)
		task.wait(0.1);
		l__Jumpscare_A90__3.FaceAngry.Visible = false;
		l__Jumpscare_A90__3.BackgroundColor3 = Color3.new(1, 1, 1);
		l__Jumpscare_A90__3.Static.ImageTransparency = 1;
		l__Jumpscare_A90__3.Static2.ImageTransparency = 1;
		task.wait(0.06666666666666667);
		l__Jumpscare_A90__3.BackgroundColor3 = Color3.new(1, 0, 0);
		task.wait(0.06666666666666667);
		l__Jumpscare_A90__3.BackgroundColor3 = Color3.new(0, 0, 0);
		task.wait(0.06666666666666667);
	else
		A90.Spawn:Stop();
		l__Jumpscare_A90__3.BackgroundTransparency = 1;
		game.ReplicatedStorage.EntityInfo.A90:FireServer(false);
	end;
	u2 = false;
	game.SoundService.Main.Volume = 1;
	l__Jumpscare_A90__3.Visible = false;
end;
e(require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game),
workspace.CurrentRooms[game.Players.LocalPlayer:GetAttribute("CurrentRoom")])