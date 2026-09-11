local urlb = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/main/Mayhem%20Mode/misc/audio/seekremix.mp3"
local urlc = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/main/Mayhem%20Mode/misc/audio/guiding.mp3"
local SeekMus = game.Workspace.Ambience_Seek
local CurMus = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.Health.Music.Yellow
local DarkMus = game.Workspace.Ambience_Dark
local AmbMus = game.Workspace.Ambience_Ambush
local AmbRus = game.Workspace.Ambience_Rush
local AmbTeR = game.Workspace.Ambience_RushTease
local AmbFig = game.Workspace.Ambience_Figure
local AmbFigInt = game.Workspace.Ambience_FigureIntense
local FigStart = game.Workspace:FindFirstChild("Ambience_FigureStart")
local FigEnd = game.Workspace:FindFirstChild("Ambience_FigureEnd")
local SoundReverb = game:GetService("SoundService")
SoundReverb.AmbientReverb = 10
if FigStart then
    FigStart:Destroy()
end
if FigEnd then
   FigEnd:Destroy() 
end

writefile("Ambience_Seek_Ame.mp3", game:HttpGet(urlb))
writefile("Ambience_Guide_Ame.mp3", game:HttpGet(urlc))

local getAssetFn = syn and getsynasset or getcustomasset
local a = SeekMus
local b = CurMus
local b_ = CurMus.End
a.SoundId = getAssetFn("Ambience_Seek_Ame.mp3")
b.SoundId = getAssetFn("Ambience_Guide_Ame.mp3")
b_.SoundId = getAssetFn("Ambience_Guide_Ame.mp3")
a.Volume = 1
a.Looped = false

DarkMus.PlaybackSpeed = 1.1
AmbMus.PlaybackSpeed = 0.95
AmbRus.Volume = 1
AmbTeR.PlaybackSpeed = 0.6

-- The one-time SoundId swap above only applies once, at load time. If the chase
-- hasn't started yet, that's fine -- but if Doors' own script resets Ambience_Seek's
-- SoundId (or just calls :Play() on whatever it already had) each time a NEW chase
-- begins, our swap gets silently overwritten the next time Seek actually starts.
-- This re-asserts our custom track and force-plays it right as each chase begins,
-- instead of relying on the swap sticking from a single load-time write.
task.spawn(function()
    local seekMusicId = getAssetFn("Ambience_Seek_Ame.mp3")
    local wasSeekActive = false
    while true do
        task.wait(0.2)
        local seekActiveNow = game.Workspace:FindFirstChild("SeekMoving", true) ~= nil
        if seekActiveNow and not wasSeekActive then
            pcall(function()
                SeekMus.SoundId = seekMusicId
                SeekMus.Volume = 1
                SeekMus:Play()
            end)
        end
        wasSeekActive = seekActiveNow
    end
end)

while task.wait(0.05) do 
AmbFig.SoundId = "rbxassetid://6385111188"
AmbFigInt.SoundId = "rbxassetid://6385111188"
end
