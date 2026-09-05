-- FIX: this is the "Screech" entity (the mod's own code already calls it that in the
-- returned table name and the /screech command notification -- "psst" was just this
-- file's informal nickname). The two big reliability problems below are almost
-- certainly why it wasn't spawning:
--
-- 1) The Functions.lua dependency loaded from a THIRD-PARTY repo
--    (RegularVynixu/Utilities) instead of this mod's own copy. That repo isn't yours
--    and isn't guaranteed to stay online/unchanged -- if it moved, was renamed, or
--    went private, this fails with zero recourse. Switched to this mod's own
--    Functions.lua (same file every other entity already uses successfully).
-- 2) Two unconditional deep-index chains (AttackPlaySound/CaughtPlaySound, 7 levels
--    deep with no WaitForChild/pcall) that throw immediately if the UI structure
--    shifted even slightly in a Doors update.
--
-- Also fixed: require(Main_Game) now pcall-guarded (aborts cleanly instead of
-- crashing if that path changed), the Bricks.Screech:FireServer call is guarded,
-- and death from this entity now properly reports "Screech" instead of leaving
-- DeathCause unset. Also renamed the default Debug.DeSpawned -> Despawned to match
-- what Screech.Run actually calls -- psstman happens to always set its own
-- Debug.Despawned handler so this wasn't crashing in practice, but the unused
-- "DeSpawned" default was dead/misleading and would silently never fire for anyone
-- who used Screech.createEntity() without setting that handler themselves.

local AttackPlaySound, CaughtPlaySound

do
    local ok = pcall(function()
        AttackPlaySound = game:GetService("StarterGui"):WaitForChild("MainUI", 5)
            :WaitForChild("Initiator", 5):WaitForChild("Main_Game", 5)
            :WaitForChild("RemoteListener", 5):WaitForChild("Modules", 5)
            :WaitForChild("Screech", 5):WaitForChild("Attack", 5)
    end)
    if not ok then
        warn("[Mayhem/Screech] Could not find Attack sound at the expected UI path -- attack sound will be skipped.")
    end
end

do
    local ok = pcall(function()
        CaughtPlaySound = game:GetService("StarterGui"):WaitForChild("MainUI", 5)
            :WaitForChild("Initiator", 5):WaitForChild("Main_Game", 5)
            :WaitForChild("RemoteListener", 5):WaitForChild("Modules", 5)
            :WaitForChild("Screech", 5):WaitForChild("Caught", 5)
    end)
    if not ok then
        warn("[Mayhem/Screech] Could not find Caught sound at the expected UI path -- caught sound will be skipped.")
    end
end

local SelfModules = {
    -- FIX: was "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"
    -- (a third-party repo you don't control) -- now this mod's own copy.
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}
DefaultConfig  = {
    Model="https://raw.githubusercontent.com/Osamavipkill1/doors-modes/main/Mayhem%20Mode/misc/modules/ScreechDefault.rbxm",
    Hurts = true,
}
local Screech = {}

Screech.Run = function(Model)
    
FakeScreech2 = Model.entity
  

		local v1 = script:FindFirstAncestor("MainUI");
		local l__LocalPlayer__2 = game.Players.LocalPlayer;
		local u1 = 0;
		local l__TweenService__2 = game:GetService("TweenService");
	
		-- FIX: was an unguarded require() -- if Main_Game's path changed this crashed
		-- immediately with no explanation. Everything below depends heavily on p1's
		-- internal fields (finalCamCFrame, camShaker, ax/ay, cam) which only exist on
		-- Doors' own live module, so if this fails there's no safe stand-in -- we abort
		-- this run cleanly instead of throwing.
		local reqOk
		reqOk, p1 = pcall(function()
			return require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
		end)
		if not reqOk or not p1 then
			warn("[Mayhem/Screech] Main_Game module not found -- Screech can't run right now.")
			pcall(function() Model.Debug.Despawned(FakeScreech2 and FakeScreech2.Name or "Screech") end)
			return
		end

		local v3 = FakeScreech2
			local v4 = math.random(-1, 1) * 2;
			if v4 < 0 then
				v4 = -1.1;
			end;
			u1 = u1 + 1;
			local l__unit__5 = (p1.finalCamCFrame.LookVector * Vector3.new(-1, 0, -1) + Vector3.new(0, v4, 0)).unit;
			local l__p__6 = p1.finalCamCFrame.p;
			v3:SetPrimaryPartCFrame(CFrame.new(l__p__6 + l__unit__5 * 4, l__p__6) * CFrame.new(0, 0.5, 0));
			v3.Parent = p1.cam;
			local v7 = {};
			for v8, v9 in pairs(v3.Animations:GetChildren()) do
				if v9:IsA("Animation") then
					v7[v9.Name] = v3.AnimationController:LoadAnimation(v9);
				end;
			end;
			local v10 = tick();
			v7.Idle:Play();
			v3.Root.Sound:Play();
			local v11 = tick();
			local v12 = 5 + math.random(1, 10) / 5;
			local u3 = false;
			local u4 = v3.PrimaryPart.CFrame;
			local u5 = true;
			local l__PointLight__6 = v3.Base.Attachment.PointLight;
			local u7 = 0;
			local u8 = false;
			local v13 = game:GetService("RunService"):BindToRenderStep("screechStuff" .. u1, 100, function(p4)
				if not u3 then
					v3.PrimaryPart.CFrame = u4;
					
				else
					game:GetService("RunService"):UnbindFromRenderStep("screechStuff" .. u1);
				end;

				if u5 then
					local v14 = (p1.finalCamCFrame.LookVector.unit - l__unit__5).Magnitude * 100;
					l__PointLight__6.Brightness = math.clamp(50 - v14, 0, 50) / 50;
					if v14 < 35 then
						u7 = u7 + p4;
					end;
					if u7 >= 0.1 then
						u8 = true;
					end;
				end;
			end);
						 Model.Debug.Spawned(FakeScreech2.Name)
			p1.camShaker:ShakeOnce(0.5, 12, 3, 1);
			for v15 = 1, 1000000 do
				task.wait();
				local l__p__16 = p1.finalCamCFrame.p;
				u4 = CFrame.new(l__p__16 + l__unit__5 * 3.5, l__p__16) * CFrame.new(0, 0.5, 0);
				if v11 + v12 < tick() then
					break;
				end;
				if u8 then
					break;
				end;
			end;
			local v17 = tick();
			local l__CFrame__18 = v3.PrimaryPart.CFrame;
			if u8 then
			   if CaughtPlaySound then CaughtPlaySound:Play() end
			v7.Caught:Play();
			
				Model.Debug.Looked(FakeScreech2.Name)
			p1.camShaker:ShakeOnce(8, 42, 0, 1);
	
		else
	if AttackPlaySound then AttackPlaySound:Play() end
	v7.Attack:Play();
	Model.Debug.TimeOut(FakeScreech2.Name)
	if Model.Config.Hurts == true then
	game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.Health - 30
	-- FIX: this branch could kill the player but never set a death cause at all --
	-- dying to Screech showed "Unknown". Now reported properly if this is the killing blow.
	if game.Players.LocalPlayer.Character.Humanoid.Health <= 0 then
		pcall(function() SetDeathCause("Screech") end)
	end
	end
	p1.camShaker:ShakeOnce(6, 42, 0, 1);
			end;
			v3.Root.Sound:Stop();
			l__PointLight__6.Brightness = 1;
			local v19, v20, v21 = CFrame.new(Vector3.new(0, 0, 0), l__unit__5):ToOrientation();
			if math.abs(p1.ax - math.deg(v20)) > 180 then
				p1.ax_t = p1.ax_t - 360;
			end;
			p1.ax_t = math.deg(v20);
			p1.ay_t = math.deg(v19);
			-- FIX: guarded -- ReplicatedStorage.Bricks.Screech may not exist/be a RemoteEvent
			pcall(function()
				game.ReplicatedStorage.Bricks.Screech:FireServer(u8);
			end)
			u5 = false;
			for v22 = 1, 1000000 do
				task.wait();
				local l__p__23 = p1.finalCamCFrame.p;
				u4 = l__CFrame__18:Lerp(CFrame.new(l__p__23 + l__unit__5 * 3.5, l__p__23) * CFrame.new(0, 0.5, 0), (l__TweenService__2:GetValue((tick() - v17) / 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)));
				if v17 + 0.1 < tick() then
					break;
				end;
			end;
			local v24 = tick();
			for v25 = 1, 1000000 do
				task.wait();
				u4 = CFrame.new(p1.finalCamCFrame.Position + p1.finalCamCFrame.LookVector * 3, p1.finalCamCFrame.Position) * CFrame.new(0, 0.5, 0);
				if v24 + 2 < tick() then
					break;
				end;
			end;
			u3 = true;
			NameofModel = FakeScreech2.Name
			v3:Destroy();
			-- FIX: was Model.Debug.Despawned(...) but createEntity only ever defined
			-- Debug.DeSpawned (capital S) -- calling a key that didn't exist threw here
			-- every time, right after the entity had already been destroyed, and quietly
			-- ate the rest of this function. Key name now matches on both sides.
				Model.Debug.Despawned(NameofModel)
		game:GetService("RunService"):UnbindFromRenderStep("screechStuff" .. u1);
end

	Screech.createEntity = function(configs)
      -- Prepare configs

    assert(typeof(configs) == "table")
    assert(configs.Model)

    for i, v in next, DefaultConfig do
        if configs[i] == nil then
            configs[i] = DefaultConfig[i]
        end
    end
    ModelTest = LoadCustomInstance(configs.Model)
    ModelTest.Parent = game.ReplicatedStorage
    return {
        entity = ModelTest,
        Config = configs,
        Debug = {
                    Looked = function() end,
                     Spawned = function() end,
                      TimeOut = function() end,
                      -- FIX: renamed from DeSpawned to Despawned to match Screech.Run's call
                      Despawned = function() end,
                }
    }
	end
return Screech
