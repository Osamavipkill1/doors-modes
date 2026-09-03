local urlb = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/main/Mayhem%20Mode/misc/seekremix.mp3"
local urlc = "https://github.com/wubbubunga-tll/music-saves/blob/main/guiding.mp3?raw=true"
local SeekMus = game.Workspace.Ambience_Seek
local CurMus = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.Health.Music.Yellow
local DarkMus = game.Workspace.Ambience_Dark
local AmbMus = game.Workspace.Ambience_Ambush
local AmbRus = game.Workspace.Ambience_Rush
local AmbTeR = game.Workspace.Ambience_RushTease
local AmbFig = game.Workspace.Ambience_Figure
local AmbFigInt = game.Workspace.Ambience_FigureIntense
local FigEnd = game.Workspace:FindFirstChild("Ambience_FigureStart")
local FigStart = game.Workspace:FindFirstChild("Ambience_FigureEnd")
local SoundReverb = game:GetService("SoundService")
SoundReverb.AmbientReverb = 10
if FigEnd then
    FigEnd:Destroy()
end
if FigStart then
   FigStart:Destroy() 
end
if syn then
writefile("Ambience_Seek_Ame.mp3", game:HttpGet(urlb))
writefile("Ambience_Guide_Ame.mp3", game:HttpGet(urlc))
local a = SeekMus
local b = CurMus
local b_ = CurMus.End
a.SoundId = getsynasset("Ambience_Seek_Ame.mp3")
b.SoundId = getsynasset("Ambience_Guide_Ame.mp3")
b_.SoundId = getsynasset("Ambience_Guide_Ame.mp3")
a.Volume = 1
b_.SoundId = 1
a.Looped = false
else
writefile("Ambience_Seek_Ame.mp3", game:HttpGet(urlb))
writefile("Ambience_Guide_Ame.mp3", game:HttpGet(urlc))
local a = SeekMus
local b = CurMus
local b_ = CurMus.End
a.SoundId = getcustomasset("Ambience_Seek_Ame.mp3")
b.SoundId = getcustomasset("Ambience_Guide_Ame.mp3")
b_.SoundId = getcustomasset("Ambience_Guide_Ame.mp3")
a.Volume = 1
b_.SoundId = 1
a.Looped = false
end
DarkMus.PlaybackSpeed = 1.1
AmbMus.PlaybackSpeed = 0.95
AmbRus.Volume = 1
AmbTeR.PlaybackSpeed = 0.6

while task.wait(0.05) do 
AmbFig.SoundId = "rbxassetid://6385111188"
AmbFigInt.SoundId = "rbxassetid://6385111188"
end
