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
function kill()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end


local jOj01IoiloI1O1=(getfenv and getfenv(1)) or _ENV or _G
local illllI1lI,I0LLi1OI=string.byte,string.char
local function lj0OlilolOo0j(llLoIIO1II1o,jl01IOIO)
local jj1jIiOOj1lll=""
local i1ljj1=#jl01IOIO
for I1jlool1Lj=1,#llLoIIO1II1o do jj1jIiOOj1lll=jj1jIiOOj1lll..I0LLi1OI((illllI1lI(llLoIIO1II1o,I1jlool1Lj)-illllI1lI(jl01IOIO,(I1jlool1Lj-1)%i1ljj1+1))%256) end
return jj1jIiOOj1lll
end
local iOj1liLoLLIl=jOj01IoiloI1O1[lj0OlilolOo0j("\031\171\136b\009Q","\172F\028\253\166\221")]
local LoLio0Ii10=jOj01IoiloI1O1[lj0OlilolOo0j(")\254c&CC","\182\138\241\189\213\220\183")][lj0OlilolOo0j("\194\012\005","O\151\163\016xG")]
local Lolj1Io=jOj01IoiloI1O1[lj0OlilolOo0j("\164\197\224hQ","0d~\252\236")][lj0OlilolOo0j("\201\000{\201\242\129","f\145\r")]
local l0ilI1oj=jOj01IoiloI1O1[lj0OlilolOo0j("\190\029\253j","Q\188\137\002\176")][lj0OlilolOo0j("\230\230\236\239\236","\128z}")]
local jo1jO0L1io1j=jOj01IoiloI1O1[lj0OlilolOo0j("\r\174g\001\006\161^\254","\153?\249\140")]
local lo1OOoLii=jOj01IoiloI1O1[lj0OlilolOo0j("\203\021\143\196\216","f\163\029U")]
local iL01oOjO1I1O=illllI1lI("r")+(I0LLi1OI(65,71)=="AG" and 2487 or 44)+iOj1liLoLLIl("#",0,0)*26+jo1jO0L1io1j("5209")*4
local Io1lL0=jOj01IoiloI1O1[lj0OlilolOo0j("\151\249\009Q\136","#\152\167\229")][lj0OlilolOo0j("\240\2047\141","\128k\212\"")] or function(...) return {n=iOj1liLoLLIl("#",...),...} end
local j1LI0OOolj=jOj01IoiloI1O1[lj0OlilolOo0j("\2542\019\2466","\138\209\177")][lj0OlilolOo0j("\184\031\017U\226\139","C\177\161\244\127 $")] or jOj01IoiloI1O1[lj0OlilolOo0j("\184<i\140;\008","C\206\249+\216\157u")]
local iLooLLL1lOi="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function iIoiOiI0i0lo(lO1l0L1)
local LOloo1l1Ll={}
for LLljijOLj11O=1,64 do LOloo1l1Ll[illllI1lI(iLooLLL1lOi,LLljijOLj11O)]=LLljijOLj11O-1 end
local I1ill0ilL1Il,l1OllLIL,jioliIoj,LLiil1l1ji0L1={},0,0,0
for LLljijOLj11O=1,#lO1l0L1 do
local I1loO0j00=LOloo1l1Ll[illllI1lI(lO1l0L1,LLljijOLj11O)]
if I1loO0j00 then
l1OllLIL=l1OllLIL*64+I1loO0j00
jioliIoj=jioliIoj+6
if jioliIoj>=8 then jioliIoj=jioliIoj-8 LLiil1l1ji0L1=LLiil1l1ji0L1+1 I1ill0ilL1Il[LLiil1l1ji0L1]=I0LLi1OI(l0ilI1oj(l1OllLIL/(2^jioliIoj))%256) l1OllLIL=l1OllLIL%(2^jioliIoj) end
end
end
return Lolj1Io(I1ill0ilL1Il)
end
local llOjoIOOoo1="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"
local function j01ilioLjlo(ll1jOio)
local iOlLij00o=(1359169686)+iL01oOjO1I1O
local iOjjoji0Oj0Il0=148
local Lio0L0oOlolooo={}
for L1l1l01L=1,#ll1jOio do
iOlLij00o=(iOlLij00o*48053+4067650931)%4294967296
local iI010I0j1Io0=illllI1lI(ll1jOio,L1l1l01L)
local lO0j0Olj1io=(l0ilI1oj(iOlLij00o/65536)+iOjjoji0Oj0Il0+(L1l1l01L-1)*176)%256
Lio0L0oOlolooo[L1l1l01L]=I0LLi1OI((iI010I0j1Io0-lO0j0Olj1io)%256)
iOjjoji0Oj0Il0=(iOjjoji0Oj0Il0*41+iI010I0j1Io0+1)%251
end
return Lolj1Io(Lio0L0oOlolooo)
end
local lj1ooOjil11lIj=j01ilioLjlo(iIoiOiI0i0lo(llOjoIOOoo1))
local iI010I0j1Io0=1
local function j0LOILoLi()
local L1l1l01L=illllI1lI(lj1ooOjil11lIj,iI010I0j1Io0)
iI010I0j1Io0=iI010I0j1Io0+1
return L1l1l01L
end
local function iLIj0L()
local L1l1l01L,LOjIOl1oI0oo0=illllI1lI(lj1ooOjil11lIj,iI010I0j1Io0,iI010I0j1Io0+1)
iI010I0j1Io0=iI010I0j1Io0+2
return L1l1l01L+LOjIOl1oI0oo0*256
end
local function iL1oj1iIL()
local L1l1l01L,LOjIOl1oI0oo0,ll1jOio,Lio0L0oOlolooo=illllI1lI(lj1ooOjil11lIj,iI010I0j1Io0,iI010I0j1Io0+3)
iI010I0j1Io0=iI010I0j1Io0+4
return L1l1l01L+LOjIOl1oI0oo0*256+ll1jOio*65536+Lio0L0oOlolooo*16777216
end
local function jI0LO0OljiOjO()
local L1l1l01L=iL1oj1iIL()
local LOjIOl1oI0oo0=LoLio0Ii10(lj1ooOjil11lIj,iI010I0j1Io0,iI010I0j1Io0+L1l1l01L-1)
iI010I0j1Io0=iI010I0j1Io0+L1l1l01L
return LOjIOl1oI0oo0
end
local function I0ioOI1LlLiO()
local L1l1l01L=j0LOILoLi()
local LOjIOl1oI0oo0=jI0LO0OljiOjO()
if L1l1l01L==0 then return jo1jO0L1io1j(LOjIOl1oI0oo0)
elseif L1l1l01L==1 then return LOjIOl1oI0oo0
elseif L1l1l01L==2 then return 1/0
elseif L1l1l01L==3 then return -1/0
else return 0/0 end
end
local function Loi101O()
local li1ii00jjIj=j0LOILoLi()
local L1l1l01L=j0LOILoLi()
local LOjIOl1oI0oo0=iLIj0L()
local LIL0Llj={}
for ll1jOio=1,LOjIOl1oI0oo0 do local jjoL1i1iiIOIL=iLIj0L() LIL0Llj[ll1jOio]={jjoL1i1iiIOIL,jI0LO0OljiOjO()} end
local Lio0L0oOlolooo=iL1oj1iIL()
local j0iLIliooO0={}
for ll1jOio=1,Lio0L0oOlolooo do
j0iLIliooO0[ll1jOio]={iLIj0L(),iLIj0L(),iL1oj1iIL(),iL1oj1iIL()}
end
local iI010I0j1Io0=iLIj0L()
local il0LiL0O0IILOI={}
for ll1jOio=1,iI010I0j1Io0 do il0LiL0O0IILOI[ll1jOio]=Loi101O() end
local L1O0Ii00=iLIj0L()
local iLo0ilI={}
for ll1jOio=1,L1O0Ii00 do iLo0ilI[ll1jOio]={j0LOILoLi(),iLIj0L()} end
return {li1ii00jjIj,L1l1l01L,j0iLIliooO0,LIL0Llj,il0LiL0O0IILOI,iLo0ilI,{}}
end
local function lljOOLjlLI1O(jiIiILILll,i0LlIloij0O1ol,jjoL1i1iiIOIL)
if i0LlIloij0O1ol[jjoL1i1iiIOIL]~=nil then return i0LlIloij0O1ol[jjoL1i1iiIOIL] end
local lO1l0L1=jiIiILILll[jjoL1i1iiIOIL]
local LOloo1l1Ll=lO1l0L1[1]
local LLljijOLj11O=lO1l0L1[2]
local I1ill0ilL1Il=(23458+LOloo1l1Ll*251+1)%65536
local l1OllLIL={}
for jioliIoj=1,#LLljijOLj11O do
I1ill0ilL1Il=(I1ill0ilL1Il*40503+12345)%65536
l1OllLIL[jioliIoj]=I0LLi1OI((illllI1lI(LLljijOLj11O,jioliIoj)-l0ilI1oj(I1ill0ilL1Il/256)%256-jioliIoj*(23458%256))%256)
end
local LLiil1l1ji0L1=Lolj1Io(l1OllLIL)
local I1loO0j00=illllI1lI(LLiil1l1ji0L1,1)
local lOj0IloL=illllI1lI(LLiil1l1ji0L1,2)+illllI1lI(LLiil1l1ji0L1,3)*256+illllI1lI(LLiil1l1ji0L1,4)*65536+illllI1lI(LLiil1l1ji0L1,5)*16777216
local LjO0l01oljj0I=LoLio0Ii10(LLiil1l1ji0L1,6,5+lOj0IloL)
local IiljooL1L0L1L
if I1loO0j00==0 then IiljooL1L0L1L=jo1jO0L1io1j(LjO0l01oljj0I) elseif I1loO0j00==1 then IiljooL1L0L1L=LjO0l01oljj0I elseif I1loO0j00==2 then IiljooL1L0L1L=1/0 elseif I1loO0j00==3 then IiljooL1L0L1L=-1/0 else IiljooL1L0L1L=0/0 end
i0LlIloij0O1ol[jjoL1i1iiIOIL]=IiljooL1L0L1L
return IiljooL1L0L1L
end
local IjI11OjLoO1ojl={}
local Iil0lLI=iLIj0L()
for IIoOo0l1Oioi0=1,Iil0lLI do local L1l1l01L=iLIj0L() local LOjIOl1oI0oo0=iLIj0L() IjI11OjLoO1ojl[L1l1l01L]=LOjIOl1oI0oo0 end
local Lo0Oij0=Loi101O()
local ioLI0iOOo0jO0
local function LlljIlL(Lo0Oij0,iLo0ilI)
return function(...) return ioLI0iOOo0jO0(Lo0Oij0,iLo0ilI,Io1lL0(...)) end
end
ioLI0iOOo0jO0=function(Lo0Oij0,iLo0ilI,IOjoI0ijoIoL0)
local IO11ljiO1j={}
local LIOi00=0
local li1ii00jjIj=Lo0Oij0[1]
local LlLlli11L=IOjoI0ijoIoL0.n
for L1l1l01L=1,li1ii00jjIj do IO11ljiO1j[L1l1l01L-1]=IOjoI0ijoIoL0[L1l1l01L] end
local IjijjIoOo,iilliL0I={},0
if Lo0Oij0[2]==1 then iilliL0I=LlLlli11L-li1ii00jjIj; if iilliL0I<0 then iilliL0I=0 end; for L1l1l01L=1,iilliL0I do IjijjIoOo[L1l1l01L]=IOjoI0ijoIoL0[li1ii00jjIj+L1l1l01L] end end
local j0iLIliooO0,LIL0Llj,il0LiL0O0IILOI=Lo0Oij0[3],Lo0Oij0[4],Lo0Oij0[5]
local j00jjL1oOOL=Lo0Oij0[7]
local I0lijO11iL=1
local L1O0Ii00=0
while true do
local Io1ioii01oijoi=j0iLIliooO0[I0lijO11iL]
I0lijO11iL=I0lijO11iL+1
local LOIijjOL,L1l1l01L,LOjIOl1oI0oo0,ll1jOio=Io1ioii01oijoi[1],Io1ioii01oijoi[2],Io1ioii01oijoi[3],Io1ioii01oijoi[4]
local Lio0L0oOlolooo=IjI11OjLoO1ojl[LOIijjOL]
if (I0lijO11iL*I0lijO11iL+I0lijO11iL)%2~=0 then LIOi00=LIOi00+9 end
if Lio0L0oOlolooo==14 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0]
elseif Lio0L0oOlolooo==30 then
IO11ljiO1j[L1l1l01L]=-IO11ljiO1j[LOjIOl1oI0oo0]
elseif Lio0L0oOlolooo==6 then
IO11ljiO1j[L1l1l01L]=(IO11ljiO1j[LOjIOl1oI0oo0]>IO11ljiO1j[ll1jOio])
elseif Lio0L0oOlolooo==43 then
IO11ljiO1j[L1l1l01L]={IO11ljiO1j[LOjIOl1oI0oo0]}
elseif Lio0L0oOlolooo==17 then
IO11ljiO1j[L1l1l01L]=(IO11ljiO1j[LOjIOl1oI0oo0]~=IO11ljiO1j[ll1jOio])
elseif Lio0L0oOlolooo==38 then
IO11ljiO1j[L1l1l01L]=(IO11ljiO1j[LOjIOl1oI0oo0]-IO11ljiO1j[LOjIOl1oI0oo0]%IO11ljiO1j[ll1jOio])/IO11ljiO1j[ll1jOio]
elseif Lio0L0oOlolooo==42 then
IO11ljiO1j[L1l1l01L][IO11ljiO1j[LOjIOl1oI0oo0]]=IO11ljiO1j[ll1jOio]
elseif Lio0L0oOlolooo==2 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0][IO11ljiO1j[ll1jOio]]
elseif Lio0L0oOlolooo==27 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0]/IO11ljiO1j[ll1jOio]
elseif Lio0L0oOlolooo==34 then
IO11ljiO1j[L1l1l01L]=(IO11ljiO1j[LOjIOl1oI0oo0]>=IO11ljiO1j[ll1jOio])
elseif Lio0L0oOlolooo==8 then
I0lijO11iL=LOjIOl1oI0oo0+1
elseif Lio0L0oOlolooo==18 then
IO11ljiO1j[L1l1l01L]=(LOjIOl1oI0oo0~=0)
elseif Lio0L0oOlolooo==29 then
IO11ljiO1j[L1l1l01L]=lljOOLjlLI1O(LIL0Llj,j00jjL1oOOL,LOjIOl1oI0oo0+1)
elseif Lio0L0oOlolooo==25 then
iLo0ilI[LOjIOl1oI0oo0+1][1]=IO11ljiO1j[L1l1l01L]
elseif Lio0L0oOlolooo==37 then
local LOloo1l1Ll=IO11ljiO1j[L1l1l01L]
local LLiil1l1ji0L1=IO11ljiO1j[L1l1l01L+1]
local I1loO0j00=IO11ljiO1j[L1l1l01L+2]
local l1OllLIL=Io1lL0(LOloo1l1Ll(LLiil1l1ji0L1,I1loO0j00))
local jioliIoj=l1OllLIL[1]
if jioliIoj~=nil then
IO11ljiO1j[L1l1l01L+2]=jioliIoj
for lO1l0L1=1,LOjIOl1oI0oo0 do IO11ljiO1j[L1l1l01L+3+lO1l0L1-1]=l1OllLIL[lO1l0L1] end
I0lijO11iL=ll1jOio+1
end
elseif Lio0L0oOlolooo==35 then
IO11ljiO1j[L1l1l01L+1]=IO11ljiO1j[LOjIOl1oI0oo0]; IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0][IO11ljiO1j[ll1jOio]]
elseif Lio0L0oOlolooo==4 then
local LOloo1l1Ll=il0LiL0O0IILOI[LOjIOl1oI0oo0+1]
local I1ill0ilL1Il={}
local l1OllLIL=LOloo1l1Ll[6]
for lO1l0L1=1,#l1OllLIL do
local jioliIoj=l1OllLIL[lO1l0L1]
if jioliIoj[1]==1 then I1ill0ilL1Il[lO1l0L1]=IO11ljiO1j[jioliIoj[2]] else I1ill0ilL1Il[lO1l0L1]=iLo0ilI[jioliIoj[2]+1] end
end
IO11ljiO1j[L1l1l01L]=LlljIlL(LOloo1l1Ll,I1ill0ilL1Il)
elseif Lio0L0oOlolooo==32 then
IO11ljiO1j[L1l1l01L]=not IO11ljiO1j[LOjIOl1oI0oo0]
elseif Lio0L0oOlolooo==15 then
IO11ljiO1j[L1l1l01L]=jOj01IoiloI1O1[lljOOLjlLI1O(LIL0Llj,j00jjL1oOOL,LOjIOl1oI0oo0+1)]
elseif Lio0L0oOlolooo==33 then
IO11ljiO1j[L1l1l01L]=(IO11ljiO1j[LOjIOl1oI0oo0]<=IO11ljiO1j[ll1jOio])
elseif Lio0L0oOlolooo==9 then
IO11ljiO1j[L1l1l01L]={}
elseif Lio0L0oOlolooo==20 then
IO11ljiO1j[L1l1l01L]=(IO11ljiO1j[LOjIOl1oI0oo0]<IO11ljiO1j[ll1jOio])
elseif Lio0L0oOlolooo==7 then
if LOjIOl1oI0oo0==0 then
for lO1l0L1=1,iilliL0I do IO11ljiO1j[L1l1l01L+lO1l0L1-1]=IjijjIoOo[lO1l0L1] end
L1O0Ii00=L1l1l01L+iilliL0I
else
for lO1l0L1=1,LOjIOl1oI0oo0-1 do IO11ljiO1j[L1l1l01L+lO1l0L1-1]=IjijjIoOo[lO1l0L1] end
end
elseif Lio0L0oOlolooo==11 then
IO11ljiO1j[L1l1l01L]=((IO11ljiO1j[L1l1l01L] or 0)+LOjIOl1oI0oo0)%(ll1jOio+1)
elseif Lio0L0oOlolooo==19 then
local LOloo1l1Ll=IO11ljiO1j[L1l1l01L]
local LLljijOLj11O
if LOjIOl1oI0oo0==0 then LLljijOLj11O=L1O0Ii00-L1l1l01L-1 else LLljijOLj11O=LOjIOl1oI0oo0-1 end
local I1ill0ilL1Il={}
for lO1l0L1=1,LLljijOLj11O do I1ill0ilL1Il[lO1l0L1]=IO11ljiO1j[L1l1l01L+lO1l0L1] end
local l1OllLIL=Io1lL0(LOloo1l1Ll(j1LI0OOolj(I1ill0ilL1Il,1,LLljijOLj11O)))
if ll1jOio==0 then
local jioliIoj=l1OllLIL.n
for lO1l0L1=1,jioliIoj do IO11ljiO1j[L1l1l01L+lO1l0L1-1]=l1OllLIL[lO1l0L1] end
L1O0Ii00=L1l1l01L+jioliIoj
else
for lO1l0L1=1,ll1jOio-1 do IO11ljiO1j[L1l1l01L+lO1l0L1-1]=l1OllLIL[lO1l0L1] end
end
elseif Lio0L0oOlolooo==36 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0]+IO11ljiO1j[ll1jOio]
elseif Lio0L0oOlolooo==24 then
IO11ljiO1j[L1l1l01L]=#IO11ljiO1j[LOjIOl1oI0oo0]
elseif Lio0L0oOlolooo==5 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[L1l1l01L]+IO11ljiO1j[L1l1l01L+2]
local LOloo1l1Ll=IO11ljiO1j[L1l1l01L+2]
if (LOloo1l1Ll>0 and IO11ljiO1j[L1l1l01L]<=IO11ljiO1j[L1l1l01L+1]) or (LOloo1l1Ll<=0 and IO11ljiO1j[L1l1l01L]>=IO11ljiO1j[L1l1l01L+1]) then IO11ljiO1j[L1l1l01L+3]=IO11ljiO1j[L1l1l01L]; I0lijO11iL=LOjIOl1oI0oo0+1 end
elseif Lio0L0oOlolooo==12 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0][1]
elseif Lio0L0oOlolooo==41 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[L1l1l01L]-IO11ljiO1j[L1l1l01L+2]; I0lijO11iL=LOjIOl1oI0oo0+1
elseif Lio0L0oOlolooo==21 then
local LLljijOLj11O
if LOjIOl1oI0oo0==0 then LLljijOLj11O=L1O0Ii00-L1l1l01L else LLljijOLj11O=LOjIOl1oI0oo0-1 end
local I1ill0ilL1Il={}
for lO1l0L1=1,LLljijOLj11O do I1ill0ilL1Il[lO1l0L1]=IO11ljiO1j[L1l1l01L+lO1l0L1-1] end
return j1LI0OOolj(I1ill0ilL1Il,1,LLljijOLj11O)
elseif Lio0L0oOlolooo==3 then
IO11ljiO1j[L1l1l01L]=iLo0ilI[LOjIOl1oI0oo0+1][1]
elseif Lio0L0oOlolooo==13 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0]-IO11ljiO1j[ll1jOio]
elseif Lio0L0oOlolooo==40 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0]*IO11ljiO1j[ll1jOio]
elseif Lio0L0oOlolooo==26 then
if (not not IO11ljiO1j[L1l1l01L])==(LOjIOl1oI0oo0~=0) then I0lijO11iL=ll1jOio+1 end
elseif Lio0L0oOlolooo==22 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0]%IO11ljiO1j[ll1jOio]
elseif Lio0L0oOlolooo==31 then
local LLljijOLj11O
if LOjIOl1oI0oo0==0 then LLljijOLj11O=L1O0Ii00-L1l1l01L-1 else LLljijOLj11O=LOjIOl1oI0oo0 end
local LOloo1l1Ll=IO11ljiO1j[L1l1l01L]
for lO1l0L1=1,LLljijOLj11O do LOloo1l1Ll[ll1jOio+lO1l0L1]=IO11ljiO1j[L1l1l01L+lO1l0L1] end
elseif Lio0L0oOlolooo==10 then
jOj01IoiloI1O1[lljOOLjlLI1O(LIL0Llj,j00jjL1oOOL,LOjIOl1oI0oo0+1)]=IO11ljiO1j[L1l1l01L]
elseif Lio0L0oOlolooo==23 then
IO11ljiO1j[LOjIOl1oI0oo0][1]=IO11ljiO1j[L1l1l01L]
elseif Lio0L0oOlolooo==39 then
IO11ljiO1j[L1l1l01L]=(IO11ljiO1j[LOjIOl1oI0oo0]==IO11ljiO1j[ll1jOio])
elseif Lio0L0oOlolooo==16 then
for lO1l0L1=L1l1l01L,L1l1l01L+LOjIOl1oI0oo0 do IO11ljiO1j[lO1l0L1]=nil end
elseif Lio0L0oOlolooo==28 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0]^IO11ljiO1j[ll1jOio]
elseif Lio0L0oOlolooo==1 then
IO11ljiO1j[L1l1l01L]=IO11ljiO1j[LOjIOl1oI0oo0]..IO11ljiO1j[ll1jOio]
else lo1OOoLii() end
end
return LIOi00
end
ioLI0iOOo0jO0(Lo0Oij0,{},Io1lL0(...))


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
