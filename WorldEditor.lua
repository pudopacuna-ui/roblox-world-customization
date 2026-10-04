local Lt,Pl,RS,UIS=game:GetService("Lighting"),game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService")
local lp,env=Pl.LocalPlayer,getgenv and getgenv()or _G
if env.WorldEditor and env.WorldEditor.Destroy then pcall(env.WorldEditor.Destroy)end
local ok,R=pcall(function()return loadstring(game:HttpGet("https://sirius.menu/gen2"))()end)
if not ok or not R then warn("[WorldEditor] Rayfield Gen2 failed to load: "..tostring(R))return end
local V3,CF,PI=Vector3.new,CFrame.new,math.pi
local function K(r,g,b)return Color3.fromRGB(r,g,b)end
local function copy(t)if type(t)~="table"then return t end local o={}for k,v in pairs(t)do o[k]=copy(v)end return o end
local function merge(d,s)for k,v in pairs(s)do if type(v)=="table"then d[k]=d[k]or{}merge(d[k],v)else d[k]=v end end end
local LP={"ClockTime","Brightness","Ambient","OutdoorAmbient","ColorShift_Top","ColorShift_Bottom","ExposureCompensation","GlobalShadows","FogColor","FogStart","FogEnd"}
local ORIG={}for _,p in ipairs(LP)do ORIG[p]=Lt[p]end
local a0=Lt:FindFirstChildOfClass("Atmosphere")
local fog=Lt.FogEnd<90000
local DEF={
Lighting={ClockTime=Lt.ClockTime,CycleSpeed=0,Brightness=math.clamp(Lt.Brightness,0,10),Ambient=Lt.Ambient,OutdoorAmbient=Lt.OutdoorAmbient,ColorShift_Top=Lt.ColorShift_Top,ColorShift_Bottom=Lt.ColorShift_Bottom,ExposureCompensation=math.clamp(Lt.ExposureCompensation,-3,3),GlobalShadows=Lt.GlobalShadows,FogOn=fog,FogColor=Lt.FogColor,FogStart=math.clamp(Lt.FogStart,0,2000),FogEnd=fog and math.clamp(Lt.FogEnd,50,5000)or 1000},
Atmosphere={Enabled=true,Density=a0 and a0.Density or 0,Offset=a0 and a0.Offset or 0.25,Color=a0 and a0.Color or K(199,170,107),Decay=a0 and a0.Decay or K(92,60,13),Glare=a0 and math.clamp(a0.Glare,0,10)or 0,Haze=a0 and math.clamp(a0.Haze,0,10)or 0},
Post={Enabled=true,Brightness=0,Contrast=0,Saturation=0,TintColor=K(255,255,255),Bloom=0,BloomSize=24,BloomThreshold=1,SunRays=0,Blur=0},
Weather={Type="None",Intensity=1,Wind=0,WindAngle=0,Lightning=true},
Sky={Enabled=false,Bk="",Dn="",Ft="",Lf="",Rt="",Up="",StarCount=3000,SunSize=21,MoonSize=11,CelestialBodies=true,Rotation=0},
Character={Highlight=false,Fill=K(255,0,255),Outline=K(255,255,255),FillTransparency=0.6,Rainbow=false,Material="",UseColor=false,BodyColor=K(255,255,255),BodyTransparency=0,Trail=false,Aura=false,HatY=0,HatZ=0}}
local CFG=copy(DEF)
CFG.Hat={Color=K(255,105,180),Accent=K(255,255,255),Transparency=0.15,Material="SmoothPlastic",Neon=false,Rainbow=false,Highlight=false,Scale=1}
CFG.Armor={Main=K(40,47,66),Trim=K(150,170,200),Glow=K(90,210,255),Cloth=K(20,40,100),Fur=K(205,210,220),Transparency=0,Material="Metal",Highlight=false,GlowLight=1.2,CloakSway=1}
local PRE={
Day={Lighting={ClockTime=14,Brightness=3,Ambient=K(110,110,110),OutdoorAmbient=K(150,150,150)},Atmosphere={Density=0.3,Color=K(199,170,107),Decay=K(92,60,13)},Post={Bloom=0.4,SunRays=0.1}},
Sunset={Lighting={ClockTime=17.7,Brightness=2,Ambient=K(110,70,90),OutdoorAmbient=K(200,110,90),ColorShift_Top=K(255,140,80)},Atmosphere={Color=K(255,150,110),Decay=K(255,80,60),Density=0.4,Haze=2,Glare=0.6},Post={TintColor=K(255,225,205),Saturation=0.2,Contrast=0.1,Bloom=0.8,SunRays=0.25}},
Night={Lighting={ClockTime=0,Brightness=0.5,Ambient=K(25,30,60),OutdoorAmbient=K(40,50,100),ExposureCompensation=0.2},Atmosphere={Color=K(40,50,90),Decay=K(10,10,30),Density=0.35,Haze=1},Post={TintColor=K(200,215,255),Saturation=0.1,Bloom=0.9}},
Vaporwave={Lighting={ClockTime=19,Brightness=2,Ambient=K(120,50,160),OutdoorAmbient=K(255,80,200),ColorShift_Top=K(255,0,170),ColorShift_Bottom=K(0,220,255)},Atmosphere={Color=K(255,120,220),Decay=K(120,40,255),Density=0.45,Haze=3,Glare=1},Post={TintColor=K(255,220,255),Saturation=0.5,Contrast=0.15,Bloom=1.4,BloomSize=40,SunRays=0.3}},
Snow={Lighting={ClockTime=12,Brightness=2,Ambient=K(140,150,170),OutdoorAmbient=K(190,200,220),FogOn=true,FogColor=K(225,230,240),FogStart=20,FogEnd=450},Atmosphere={Color=K(235,240,250),Decay=K(200,210,230),Density=0.5,Haze=2},Post={Saturation=-0.2,TintColor=K(230,240,255)},Weather={Type="Snow"}},
Storm={Lighting={ClockTime=15,Brightness=1,Ambient=K(50,55,65),OutdoorAmbient=K(70,75,90),FogOn=true,FogColor=K(70,75,85),FogStart=0,FogEnd=350},Atmosphere={Color=K(80,85,95),Decay=K(40,45,55),Density=0.55,Haze=3},Post={Saturation=-0.3,Contrast=0.15,TintColor=K(200,210,225),SunRays=0},Weather={Type="Storm",Wind=8,WindAngle=40}},
Bloodmoon={Lighting={ClockTime=0,Brightness=0.8,Ambient=K(60,10,15),OutdoorAmbient=K(110,20,25),ColorShift_Top=K(200,20,20),ExposureCompensation=0.1},Atmosphere={Color=K(150,25,25),Decay=K(60,5,5),Density=0.4,Haze=2.5},Post={TintColor=K(255,200,200),Saturation=0.3,Contrast=0.2,Bloom=1},Weather={Type="Ash"}},
Mist={Lighting={ClockTime=7,Brightness=1.5,Ambient=K(120,125,130),OutdoorAmbient=K(150,155,160),FogOn=true,FogColor=K(170,175,180),FogStart=10,FogEnd=220},Atmosphere={Color=K(190,195,200),Decay=K(170,175,180),Density=0.6,Haze=4},Post={Saturation=-0.35,Contrast=0.1,Bloom=0.2}}}
local dead,vis,chr,ui=false,false,false,nil
local function nt(a,b)if ui then pcall(function()ui:Notify({title=a,content=b})end)end end
local stash={}
local function stashC(cl)for _,o in ipairs(Lt:GetChildren())do if o:IsA(cl)and not o:GetAttribute("WE")then stash[#stash+1]=o;o.Parent=nil end end end
local function unstash(cl)for i=#stash,1,-1 do local o=stash[i]if o:IsA(cl)then o.Parent=Lt;table.remove(stash,i)end end end
local function fx(cl,n)local o=Lt:FindFirstChild(n)if not o then o=Instance.new(cl);o.Name=n;o:SetAttribute("WE",true);o.Parent=Lt end return o end
local flash,flashing,touched=0,false,{}
local function lstep(dt)
local L=CFG.Lighting
if L.CycleSpeed~=0 then L.ClockTime=(L.ClockTime+dt*L.CycleSpeed)%24 end
local t={}for _,p in ipairs(LP)do t[p]=L[p]end
t.FogStart=L.FogOn and L.FogStart or 0
t.FogEnd=L.FogOn and L.FogEnd or 100000
for _,p in ipairs(LP)do local v=t[p]if v~=ORIG[p]then touched[p]=true;Lt[p]=v elseif touched[p]then touched[p]=nil;Lt[p]=v end end
if flash>0 then flash=flash-dt;flashing=true;Lt.ExposureCompensation=t.ExposureCompensation+1.6 elseif flashing then flashing=false;Lt.ExposureCompensation=t.ExposureCompensation end
end
local function applyVis()
if not vis then return end
local S=CFG.Sky
if S.Enabled then
stashC("Sky");local sk=fx("Sky","WE_Sky")
for p,v in pairs({SkyboxBk=S.Bk,SkyboxDn=S.Dn,SkyboxFt=S.Ft,SkyboxLf=S.Lf,SkyboxRt=S.Rt,SkyboxUp=S.Up})do if v~=""and sk[p]~=v then sk[p]=v end end
sk.StarCount,sk.SunAngularSize,sk.MoonAngularSize=S.StarCount,S.SunSize,S.MoonSize
sk.CelestialBodiesShown=S.CelestialBodies;sk.SkyboxOrientation=V3(0,S.Rotation,0)
else local o=Lt:FindFirstChild("WE_Sky")if o then o:Destroy()end;unstash("Sky")end
local A=CFG.Atmosphere
stashC("Atmosphere");local at=fx("Atmosphere","WE_Atmo")
at.Density=A.Enabled and A.Density or 0
at.Offset,at.Color,at.Decay,at.Glare,at.Haze=A.Offset,A.Color,A.Decay,A.Glare,A.Haze
local P=CFG.Post
local cc=fx("ColorCorrectionEffect","WE_CC");cc.Enabled=P.Enabled
cc.Brightness,cc.Contrast,cc.Saturation,cc.TintColor=P.Brightness,P.Contrast,P.Saturation,P.TintColor
local bl=fx("BloomEffect","WE_Bloom");bl.Enabled=P.Enabled
bl.Intensity,bl.Size,bl.Threshold=P.Bloom,P.BloomSize,P.BloomThreshold
local sr=fx("SunRaysEffect","WE_Rays");sr.Enabled=P.Enabled
sr.Intensity,sr.Spread=P.SunRays,0.5
local bu=fx("BlurEffect","WE_Blur");bu.Size=P.Blur;bu.Enabled=P.Enabled and P.Blur>0
end
local function enVis()vis=true;applyVis()end
local WL={None="off",Rain="Rain",Storm="Storm",Snow="Snow",Ash="Ash",Embers="Embers"}
local NS,NR,CS,V2=NumberSequence.new,NumberRange.new,ColorSequence.new,Vector2.new
local OR,NID=Enum.ParticleOrientation,Enum.NormalId
local rain={CS(K(170,190,230)),NS(0.2),NS(0.45),NR(0.5,0.7),NR(90,110),V2(3,3),NR(0),800,0.1,6,45,NID.Bottom,OR.VelocityParallel}
local WD={
Snow={CS(K(255,255,255)),NS(0.35),NS(0.15),NR(6,8),NR(5,9),V2(25,25),NR(-60,60),350,0.3,1,45,NID.Bottom,OR.FacingCamera},
Ash={CS(K(140,135,135)),NS(0.3),NS(0.3),NR(8,10),NR(2,4),V2(40,40),NR(-30,30),200,0,1,45,NID.Bottom,OR.FacingCamera},
Embers={CS(K(255,150,40),K(255,60,10)),NS(0.35,0),NS(0),NR(4,6),NR(6,10),V2(30,30),NR(0),150,1,1,-4,NID.Top,OR.FacingCamera},
Rain=rain,Storm={rain[1],rain[2],rain[3],rain[4],rain[5],rain[6],rain[7],1500,rain[9],rain[10],rain[11],rain[12],rain[13]}}
local wp,we,wy,wt,wtag,ptag=nil,nil,45,{},nil,nil
local function wsync()
local k=CFG.Weather.Type
for n,t in pairs(wt)do pcall(function()t:Set(n==k,true)end)end
if wtag then pcall(function()if k=="None"then wtag:Set({text="Weather: off",color=K(110,110,130)})else wtag:Set({text="Weather: "..WL[k],color=K(70,190,110)})end end)end
end
local function wupd()
local W=CFG.Weather
if W.Type=="None"then if wp then wp:Destroy();wp,we=nil,nil end;wsync();return end
if not wp then
wp=Instance.new("Part");wp.Name="WE_Weather"
wp.Anchored,wp.CanCollide,wp.CanQuery,wp.CanTouch=true,false,false,false
wp.Transparency=1;wp.Size=V3(90,1,90);wp.Parent=workspace
we=Instance.new("ParticleEmitter");we.Texture="rbxasset://textures/particles/sparkles_main.dds";we.Parent=wp
end
local d,e=WD[W.Type],we
e.Color,e.Size,e.Transparency,e.Lifetime,e.Speed,e.SpreadAngle,e.RotSpeed=d[1],d[2],d[3],d[4],d[5],d[6],d[7]
e.Rate=d[8]*W.Intensity;e.LightEmission=d[9];wy=d[11];e.EmissionDirection=d[12];e.Orientation=d[13]
local an,pw=math.rad(W.WindAngle),W.Wind*d[10]
e.Acceleration=V3(math.cos(an)*pw,0,math.sin(an)*pw)
wsync()
end
local orig=setmetatable({},{__mode="k"})
local function applyChar()
if not chr then return end
local ch=lp.Character if not ch then return end
local C=CFG.Character
local root=ch:FindFirstChild("HumanoidRootPart")
local hl=ch:FindFirstChild("WE_HL")
if C.Highlight then
if not hl then hl=Instance.new("Highlight");hl.Name="WE_HL";hl.Parent=ch end
hl.FillColor,hl.OutlineColor,hl.FillTransparency=C.Fill,C.Outline,C.FillTransparency
elseif hl then hl:Destroy()end
for _,p in ipairs(ch:GetDescendants())do
if p:IsA("BasePart")and p~=root then
if not orig[p]then orig[p]={p.Color,p.Material,p.Transparency}end
local o=orig[p]
if o[3]<0.99 then
p.Material=C.Material~=""and Enum.Material[C.Material]or o[2]
p.Color=C.UseColor and C.BodyColor or o[1]
p.Transparency=o[3]+(1-o[3])*C.BodyTransparency
end end end
if root then
local tr=root:FindFirstChild("WE_Trail")
if C.Trail then
if not tr then
local a=Instance.new("Attachment");a.Name="WE_A0";a.Position=V3(0,1,0);a.Parent=root
local b=Instance.new("Attachment");b.Name="WE_A1";b.Position=V3(0,-1,0);b.Parent=root
tr=Instance.new("Trail");tr.Name="WE_Trail";tr.Attachment0,tr.Attachment1=a,b
tr.Lifetime,tr.LightEmission=0.6,1;tr.Transparency=NS(0.1,1);tr.Parent=root
end
tr.Color=CS(C.Fill)
elseif tr then tr:Destroy()for _,n in ipairs({"WE_A0","WE_A1"})do local o=root:FindFirstChild(n)if o then o:Destroy()end end end
local au=root:FindFirstChild("WE_Aura")
if C.Aura then
if not au then
au=Instance.new("ParticleEmitter");au.Name="WE_Aura";au.Texture="rbxasset://textures/particles/sparkles_main.dds"
au.Rate,au.Lifetime,au.Speed=40,NR(1,1.6),NR(1,3);au.SpreadAngle=V2(180,180)
au.Size=NS(0.5,0);au.LightEmission=1;au.Parent=root
end
au.Color=CS(C.Fill)
elseif au then au:Destroy()end
end
end
local function enChr()chr=true;applyChar()end
local function builder(sp)
local S={meta={}}local chain
local function put(t)t.chain=chain;sp[#sp+1]=t end
local function add(sh,sz,cf,role,ex)put({shape=sh,size=sz,cf=cf,role=role or"main",light=ex and ex.light,spin=ex and ex.spin,bob=ex and ex.bob})end
function S.chain(c,r)chain=c and{c=c,r=r}or nil end
function S.cyl(d,h,cf,role,ex)add(Enum.PartType.Cylinder,V3(h,d,d),cf*CFrame.Angles(0,0,PI/2),role,ex)end
function S.ball(d,cf,role,ex)add(Enum.PartType.Ball,V3(d,d,d),cf,role,ex)end
function S.block(sz,cf,role,ex)add(Enum.PartType.Block,sz,cf,role,ex)end
function S.tri(a,b,c,role)
local ab,ac,bc=b-a,c-a,c-b
local x,y,z=ab:Dot(ab),ac:Dot(ac),bc:Dot(bc)
if x>y and x>z then c,a=a,c elseif y>z and y>x then a,b=b,a end
ab,ac,bc=b-a,c-a,c-b
local n=ac:Cross(ab)
if n.Magnitude<1e-6 or bc.Magnitude<1e-6 then return end
local right=n.Unit;local up=bc:Cross(right).Unit;local back=bc.Unit
local h=math.abs(ab:Dot(up))
if h<1e-4 then return end
local z1,z2=math.abs(ab:Dot(back)),math.abs(ac:Dot(back))
if z1>1e-4 then put({wedge=true,size=V3(0.05,h,z1),role=role or"main",cf=CFrame.fromMatrix((a+b)/2,right,up,back)})end
if z2>1e-4 then put({wedge=true,size=V3(0.05,h,z2),role=role or"main",cf=CFrame.fromMatrix((a+c)/2,-right,up,-back)})end
end
function S.quad(a,b,c,d,role)S.tri(a,b,c,role);S.tri(a,c,d,role)end
function S.frustum(r1,r2,h,cf,role,n)
n=n or 6;local lo,hi={},{}
for i=0,n-1 do local a=i/n*PI*2;lo[i]=cf*V3(math.cos(a)*r1,0,math.sin(a)*r1);hi[i]=cf*V3(math.cos(a)*r2,h,math.sin(a)*r2)end
for i=0,n-1 do local j=(i+1)%n;S.quad(lo[i],lo[j],hi[j],hi[i],role)end
end
function S.cone(r,h,cf,role,n,rim)
n=n or 32;local apex=cf*V3(0,h,0)
local function ring(f)local rr,y=r*(1-f),h*f;local p={}for i=0,n-1 do local a=i/n*PI*2;p[i]=cf*V3(math.cos(a)*rr,y,math.sin(a)*rr)end return p end
local base=ring(0);local top=rim and ring(rim.frac)or base
for i=0,n-1 do local j=(i+1)%n
S.tri(apex,top[i],top[j],role)
if rim then S.tri(base[i],base[j],top[i],rim.role);S.tri(base[j],top[j],top[i],rim.role)end end
end
return S
end
local hatsW,hatsP,armW,armP,selH,selA,armRoot,gconn={},{},{},{},{},{}
local rmHat,syncHats,hatLook,hatOff,rebuildHats,rmArm,syncArmor,armLook,clearArm
local HATS,HNAMES={},{}
local function defH(n,f)HATS[n]=f;HNAMES[#HNAMES+1]=n end
defH("Chinahat",function(S,T)
S.cone(1.65,0.9,CF(0,T-0.08,0),"main",32,{role="accent",frac=0.07})
S.ball(0.2,CF(0,T+0.84,0),"accent")end)
defH("Wizard Hat",function(S,T)
S.cyl(3.0,0.12,CF(0,T+0.03,0),"main")
S.cone(0.85,2.4,CF(0,T+0.09,0),"main",32)
S.cyl(1.78,0.24,CF(0,T+0.21,0),"accent")end)
defH("Halo",function(S,T)
for i=0,25 do local a=i/26*PI*2
S.block(V3(0.2,0.1,0.27),CF(math.cos(a)*0.95,T+0.95,math.sin(a)*0.95)*CFrame.Angles(0,-a,0),"glow",{bob=0.05})end end)
defH("Crown",function(S,T)
S.cyl(1.5,0.35,CF(0,T+0.1,0),"main")
for i=0,7 do local a=i/8*PI*2;local x,z=math.cos(a)*0.62,math.sin(a)*0.62
S.block(V3(0.2,0.45,0.2),CF(x,T+0.5,z),"main");S.ball(0.22,CF(x,T+0.78,z),"glow")end
S.ball(0.26,CF(0,T+0.1,-0.76),"glow")end)
defH("Top Hat",function(S,T)
S.cyl(2.1,0.1,CF(0,T+0.02,0),"main")
S.cyl(1.5,1.0,CF(0,T+0.5,0),"main")
S.cyl(1.54,0.22,CF(0,T+0.18,0),"accent")end)
defH("Horns",function(S,T)
for _,s in ipairs({1,-1})do S.cone(0.2,0.9,CF(s*0.32,T-0.03,0)*CFrame.Angles(0,0,-s*0.4),"main",16)end end)
defH("Cat Ears",function(S,T)
for _,s in ipairs({1,-1})do
local g=CF(s*0.34,T-0.05,0)*CFrame.Angles(0,0,-s*0.3)
S.cone(0.3,0.62,g,"main",18);S.cone(0.17,0.46,g*CF(0,0,-0.13),"accent",14)end end)
defH("Propeller Cap",function(S,T)
S.ball(1.15,CF(0,T,0),"main")
S.block(V3(0.95,0.08,0.55),CF(0,T-0.02,-0.72),"accent")
S.cyl(0.1,0.22,CF(0,T+0.62,0),"accent")
S.ball(0.16,CF(0,T+0.58,0),"accent")
S.block(V3(1.9,0.05,0.24),CF(0,T+0.75,0),"accent",{spin=14})
S.block(V3(1.9,0.05,0.24),CF(0,T+0.75,0)*CFrame.Angles(0,PI/2,0),"accent",{spin=14})end)
local APC,ANAMES={},{}
local function defA(n,att,b)APC[n]={name=n,attach=att,build=b};ANAMES[#ANAMES+1]=n end
defA("Lich King Helm",function()return{"Head"}end,function(S,c)
local w,h=math.min(c.hx,c.hz),c.hy
local r=w*1.12
S.cyl(r*2,h*2.1,CF(0,0,0),"main")
S.cone(r*0.98,h*0.9,CF(0,h*1.05,0),"main",16)
S.cyl(r*2.12,h*0.14,CF(0,h*1.02,0),"trim")
S.cyl(r*2.08,h*0.12,CF(0,-h,0),"trim")
S.block(V3(r*1.9,h*0.22,0.07),CF(0,h*0.5,-r),"trim")
S.block(V3(r*0.26,h*1.05,0.08),CF(0,-h*0.05,-r-0.01),"trim")
S.block(V3(r*1.5,h*0.12,0.05),CF(0,h*0.18,-r-0.02),"glow")
S.block(V3(r*1.3,h*0.55,0.07),CF(0,-h*0.62,-r),"main")
S.block(V3(r*0.9,h*0.05,0.04),CF(0,-h*0.62,-r-0.03),"glow")
S.ball(h*0.3,CF(0,h*0.78,-r-0.02),"glow",{light=true})
for _,a in ipairs({0,0.7,-0.7,1.4,-1.4,2.1,-2.1})do
S.cone(r*0.14,h*(1.9-0.42*math.abs(a)),CF(math.sin(a)*r*0.86,h,math.cos(a)*r*0.86)*CFrame.Angles(0,a,0)*CFrame.Angles(0.3,0,0),"trim",5)end
for _,s in ipairs({1,-1})do
local g=CF(s*r*0.95,h*0.55,r*0.1)*CFrame.Angles(0.25,0,-s)
S.frustum(r*0.28,r*0.2,h*0.9,g,"main",5)
local g2=g*CF(0,h*0.9,0)*CFrame.Angles(0,0,s*0.8)
S.frustum(r*0.2,r*0.1,h*0.9,g2,"main",5)
S.cone(r*0.1,h*0.8,g2*CF(0,h*0.9,0)*CFrame.Angles(0,0,s*0.35),"trim",5)end
end)
defA("Pauldrons",function(r)return r=="R15"and{"RightUpperArm","LeftUpperArm"}or{"Right Arm","Left Arm"}end,function(S,c,x)
local s,t,aw=x.s,c.hy,c.hx*2
for i=0,2 do S.block(V3(aw*(1.5-0.26*i),0.1,aw*(1.4-0.24*i)),CF(s*(aw*0.24-0.03*i),t+0.05+0.15*i,0)*CFrame.Angles(0,0,-s*(0.4-0.06*i)),i==1 and"trim"or"main")end
S.cone(aw*0.13,aw*0.9,CF(s*aw*0.22,t+0.34,0)*CFrame.Angles(0,0,-s*0.3),"main",5)
for _,z in ipairs({-1,1})do S.cone(aw*0.09,aw*0.55,CF(s*aw*0.95,t-0.2,z*aw*0.32)*CFrame.Angles(0,0,-s*1.3),"trim",4)end
S.ball(aw*0.2,CF(s*aw*0.22,t+0.38,0),"glow")
S.block(V3(0.04,0.04,aw*1.2),CF(s*aw*0.9,t-0.21,0)*CFrame.Angles(0,0,-s*0.4),"glow")
end)
defA("Chestplate",function(r)return r=="R15"and{"UpperTorso"}or{"Torso"}end,function(S,c)
local X,Y,Z=c.hx,c.hy,c.hz
for _,s in ipairs({1,-1})do
S.block(V3(X*0.94,Y*0.7,0.12),CF(s*X*0.48,Y*0.3,-Z-0.07)*CFrame.Angles(0,-s*0.2,0),"main")
S.block(V3(X*0.86,0.04,0.04),CF(s*X*0.5,Y*0.64,-Z-0.12),"glow")end
S.block(V3(0.14,Y*1.2,0.14),CF(0,Y*0.2,-Z-0.14)*CFrame.Angles(0,PI/4,0),"trim")
S.ball(0.26,CF(0,Y*0.42,-Z-0.2),"glow",{light=true})
S.cyl(0.48,0.06,CF(0,Y*0.42,-Z-0.16)*CFrame.Angles(PI/2,0,0),"trim")
for i=0,2 do S.block(V3(X*(1.6-0.2*i),Y*0.26,0.09),CF(0,-Y*0.2-i*Y*0.29,-Z-0.05)*CFrame.Angles(-0.1,0,0),i==1 and"trim"or"main")end
S.cyl(1.5,0.2,CF(0,Y+0.02,0),"trim")
S.cyl(1.38,0.2,CF(0,Y+0.12,0),"main")
S.block(V3(X*1.9,Y*1.5,0.1),CF(0,Y*0.08,Z+0.06),"main")
S.block(V3(0.1,Y*1.5,0.1),CF(0,Y*0.08,Z+0.12)*CFrame.Angles(0,PI/4,0),"trim")
end)
defA("Belt",function(r)return r=="R15"and{"LowerTorso"}or{"Torso"}end,function(S,c,x)
local X,Z=c.hx,c.hz
local y=(x.rig=="R6")and(-c.hy+0.3)or 0
S.block(V3(X*2.06,0.26,Z*2.2),CF(0,y,0),"main")
S.block(V3(X*2.1,0.04,Z*2.26),CF(0,y+0.15,0),"trim")
S.block(V3(X*2.1,0.04,Z*2.26),CF(0,y-0.15,0),"trim")
S.ball(0.36,CF(0,y,-Z-0.1),"trim")
S.block(V3(0.08,0.06,0.04),CF(0,y,-Z-0.28),"glow")
for _,s in ipairs({1,-1})do
S.block(V3(X*0.5,X*0.8,0.08),CF(s*X*0.55,y-0.5,-Z-0.07)*CFrame.Angles(-0.06,-s*0.3,0),"main")
S.cone(0.12,0.6,CF(s*(X+0.06),y,0)*CFrame.Angles(0,0,-s*1.2),"trim",4)end
S.block(V3(X*0.6,X*0.9,0.08),CF(0,y-0.55,-Z-0.1)*CFrame.Angles(-0.08,0,0),"main")
S.block(V3(X*1.4,X*0.85,0.08),CF(0,y-0.5,Z+0.1),"main")
end)
defA("Bracers",function(r)return r=="R15"and{"RightLowerArm","LeftLowerArm","RightHand","LeftHand"}or{"Right Arm","Left Arm"}end,function(S,c,x)
local s,aw=x.s,c.hx*2
if x.name:find("Hand")then
S.block(V3(aw*1.12,0.22,aw*1.12),CF(0,c.hy*0.4,0),"main")
for _,d in ipairs({-0.28,0,0.28})do S.cone(0.07,0.3,CF(d*aw,0,-aw*0.5)*CFrame.Angles(-PI/2+0.25,0,0),"trim",4)end
return
end
local yc=(x.rig=="R6")and(-c.hy*0.5-0.02)or 0
local L=(x.rig=="R6")and 0.92 or c.hy*2*0.86
S.cyl(aw*1.2,L,CF(0,yc,0),"main")
S.cyl(aw*1.28,0.08,CF(0,yc+L/2-0.04,0),"trim")
S.cyl(aw*1.28,0.08,CF(0,yc-L/2+0.04,0),"trim")
S.cyl(aw*1.24,0.04,CF(0,yc,0),"glow")
S.tri(V3(s*aw*0.6,yc+L*0.5,0),V3(s*aw*0.6,yc-L*0.35,0),V3(s*aw*1.25,yc-L*0.65,0),"trim")
S.cone(0.12,0.45,CF(s*aw*0.3,yc+L/2,aw*0.4)*CFrame.Angles(PI/2-0.2,0,-s*0.4),"main",4)
end)
defA("Legs",function(r)return r=="R15"and{"RightUpperLeg","LeftUpperLeg","RightLowerLeg","LeftLowerLeg"}or{"Right Leg","Left Leg"}end,function(S,c,x)
local aw=c.hx*2
local rd=aw*0.6
local function th(y,h)
S.cyl(aw*1.2,h,CF(0,y,0),"main")
S.block(V3(aw*0.5,h*0.88,0.07),CF(0,y,-rd-0.03),"trim")
S.cyl(aw*1.28,0.08,CF(0,y+h/2-0.04,0),"trim")
end
local function sh(y,h,k)
S.cyl(aw*1.18,h,CF(0,y,0),"main")
S.block(V3(0.12,h*0.86,0.12),CF(0,y,-rd-0.02)*CFrame.Angles(0,PI/4,0),"trim")
S.cyl(aw*1.26,0.08,CF(0,y-h/2+0.04,0),"trim")
S.cone(aw*0.18,aw*0.55,CF(0,k,-rd)*CFrame.Angles(-PI/2+0.4,0,0),"main",4)
end
if x.rig=="R6"then th(0.52,0.9);sh(-0.52,0.9,-0.02)
elseif x.name:find("Upper")then th(0,c.hy*2*0.9)
else sh(0,c.hy*2*0.92,c.hy*0.85)end
end)
defA("Boots",function(r)return r=="R15"and{"RightFoot","LeftFoot"}or{"Right Leg","Left Leg"}end,function(S,c,x)
local aw=c.hx*2
local y=(x.rig=="R6")and(-c.hy+0.26)or 0
S.block(V3(aw*1.14,0.46,aw*1.4),CF(0,y,-aw*0.1),"main")
S.block(V3(aw,0.26,aw*0.45),CF(0,y-0.02,-aw*0.78)*CFrame.Angles(-0.25,0,0),"trim")
S.cone(0.1,0.5,CF(0,y-0.02,-aw)*CFrame.Angles(-PI/2+0.15,0,0),"trim",4)
S.block(V3(aw*1.16,0.04,0.04),CF(0,y+0.1,-aw*0.8),"glow")
end)
defA("Cloak",function(r)return r=="R15"and{"UpperTorso"}or{"Torso"}end,function(S,c)
local X,Y,Z=c.hx,c.hy,c.hz
local cols,rows=7,7
local rh=(Y*2+1.7)/rows
local wt,wb=X*2+0.1,X*2+1.1
local xs={}
for i=1,cols do xs[i]=(i-(cols+1)/2)*(wt/cols)end
for i=1,cols do
for r=1,rows do
S.chain(i,r)
local w=(wt+(wb-wt)*(r-1)/(rows-1))/cols
if r==1 then S.block(V3(w*1.04,rh*1.05,0.16),CF(0,-rh/2,0),"fur")
else S.block(V3(w*1.04,rh*1.05,0.06),CF(0,-rh/2,(i%2)*0.01),"cloth")end
end
S.chain(i,rows)
local w=wb/cols
local l1,l2=0.45+0.2*math.sin(i*2.3),0.45+0.2*math.sin(i*3.7+1)
S.tri(V3(-w*0.52,-rh*1.02,0),V3(0,-rh*1.02,0),V3(-w*0.26,-rh-l1,0),"cloth")
S.tri(V3(0,-rh*1.02,0),V3(w*0.52,-rh*1.02,0),V3(w*0.26,-rh-l2,0),"cloth")
end
S.chain(nil)
local cl={base=CF(0,Y-0.1,Z+0.2),cols=cols,rows=rows,rowH=rh,xs=xs,aX={},aZ={},chain={}}
for i=1,cols do cl.chain[i]={}end
for r=1,rows do cl.aX[r],cl.aZ[r]=0,0 end
S.meta.cloak=cl
end)
local APRE={
["Lich King"]={Main=K(40,47,66),Trim=K(150,170,200),Glow=K(90,210,255),Cloth=K(20,40,100),Fur=K(205,210,220)},
["Blood Knight"]={Main=K(55,15,20),Trim=K(210,170,70),Glow=K(255,70,50),Cloth=K(110,15,20),Fur=K(230,225,215)},
["Fel"]={Main=K(30,40,30),Trim=K(120,150,110),Glow=K(110,255,90),Cloth=K(25,60,35),Fur=K(190,200,180)},
["Silver Hand"]={Main=K(205,210,222),Trim=K(235,190,70),Glow=K(255,230,140),Cloth=K(30,70,160),Fur=K(240,240,245)}}
local APN={"Lich King","Blood Knight","Fel","Silver Hand"}
local function kill(e)if e.conn then e.conn:Disconnect()end pcall(function()e.model:Destroy()end)end
local function spawn(sp,att,sc)
local m=Instance.new("Model");m.Name="WE_Gear"
local en={model=m,parts={},anim={},base=CF()}
for _,s in ipairs(sp)do
local p=Instance.new(s.wedge and"WedgePart"or"Part")
if s.shape then p.Shape=s.shape end
p.Size=V3(math.max(s.size.X*sc,0.05),math.max(s.size.Y*sc,0.05),math.max(s.size.Z*sc,0.05))
p.Name="WE_GearPart"
p.TopSurface,p.BottomSurface=Enum.SurfaceType.Smooth,Enum.SurfaceType.Smooth
p.CanCollide,p.CanQuery,p.CanTouch,p.Massless=false,false,false,true
p.CastShadow=false
local cf=CF(s.cf.Position*sc)*s.cf.Rotation
local w=Instance.new("Weld");w.Part0,w.Part1,w.C0=att,p,cf;w.Parent=p
local r={part=p,weld=w,cf=cf,role=s.role,spin=s.spin,bob=s.bob and s.bob*sc,chain=s.chain}
if s.light then local l=Instance.new("PointLight");l.Range,l.Brightness,l.Shadows=9,1,false;l.Parent=p;r.light=l end
p.Parent=m;en.parts[#en.parts+1]=r
if r.spin or r.bob or r.chain then en.anim[#en.anim+1]=r end
end
return en
end
function rmHat(k)local e=hatsW[k];hatsW[k]=nil;if e then kill(e)end end
function hatLook()
local H,Ch=CFG.Hat,CFG.Character
local main,acc=H.Color,H.Accent
if H.Rainbow then local t=tick();main=Color3.fromHSV((t%4)/4,1,1);acc=Color3.fromHSV(((t+2)%4)/4,1,1)end
local mat=Enum.Material[H.Material]
for _,hat in pairs(hatsW)do
for _,e in ipairs(hat.parts)do
local p=e.part
if p.Parent then
local col=(e.role=="main")and main or acc
local m=(e.role=="glow"or H.Neon)and Enum.Material.Neon or mat
if p.Color~=col then p.Color=col end
if p.Material~=m then p.Material=m end
if p.Transparency~=H.Transparency then p.Transparency=H.Transparency end
end end
local hl=hat.model:FindFirstChild("WE_HatHL")
if H.Highlight then
if not hl then hl=Instance.new("Highlight");hl.Name="WE_HatHL";hl.Adornee=hat.model;hl.Parent=hat.model end
hl.FillColor,hl.OutlineColor,hl.FillTransparency=Ch.Fill,Ch.Outline,Ch.FillTransparency
elseif hl then hl:Destroy()end
end
end
function hatOff()
local b=CF(0,CFG.Character.HatY,-CFG.Character.HatZ)
for _,hat in pairs(hatsW)do
hat.base=b
for _,e in ipairs(hat.parts)do if e.weld.Parent and not(e.spin or e.bob)then e.weld.C0=b*e.cf end end
end
end
local function hatTick()
local t=tick()
for _,hat in pairs(hatsW)do
for _,e in ipairs(hat.anim)do
if e.weld.Parent then
if e.spin then e.weld.C0=hat.base*CF(e.cf.Position)*CFrame.Angles(0,t*e.spin,0)*e.cf.Rotation
elseif e.bob then e.weld.C0=hat.base*CF(0,math.sin(t*2.2)*e.bob,0)*e.cf end
end end end
if CFG.Hat.Rainbow then hatLook()end
end
local function cloakStep(e,dt,t,root)
local cl,A=e.cloak,CFG.Armor
local vf,vx,vy=0,0,0
if root and e.attach.Parent then
local rel=e.attach.CFrame:VectorToObjectSpace(root.AssemblyLinearVelocity)
vf,vx,vy=-rel.Z,rel.X,rel.Y
end
vf,vx,vy=math.clamp(vf,-40,40),math.clamp(vx,-40,40),math.clamp(vy,-80,80)
local sw=A.CloakSway
local tx=-math.clamp(vf*0.045+math.max(-vy,0)*0.012,-0.15,1.15)*sw
local tz=-vx*0.02*sw
local n,aX,aZ=cl.rows,cl.aX,cl.aZ
for r=1,n do
local k=math.min(1,dt*(16-r*1.3))
local fl=math.sin(t*2.1+r*0.8)*0.035*sw*(0.4+r/n)
aX[r]=aX[r]+(tx*(r/n)+fl-aX[r])*k
aZ[r]=aZ[r]+(tz*(r/n)-aZ[r])*k
end
for ci=1,cl.cols do
local cf=CF(cl.xs[ci],0,0)
local flare=(ci-(cl.cols+1)/2)*0.022
local row=cl.chain[ci]
for r=1,n do
local px=r>1 and aX[r-1]or 0
local pz=r>1 and aZ[r-1]or 0
cf=cf*CFrame.Angles(aX[r]-px,0,aZ[r]-pz+flare)
row[r]=cf
cf=cf*CF(0,-cl.rowH,0)
end
end
for _,rec in ipairs(e.anim)do
local ch=rec.chain
if ch and rec.weld.Parent then rec.weld.C0=cl.base*cl.chain[ch.c][ch.r]*rec.cf end
end
end
local function ensure()
if gconn then return end
gconn=RS.RenderStepped:Connect(function(dt)
local ah,aa=next(hatsW)~=nil,next(armW)~=nil
if not ah and not aa then gconn:Disconnect();gconn=nil;return end
if ah then hatTick()end
if aa then
local t=tick()
local ch=lp.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
for _,e in pairs(armW)do if e.cloak then cloakStep(e,dt,t,root)end end
end
end)
end
local function addHat(k)
if hatsW[k]or hatsP[k]then return end
local fn=HATS[k]if not fn then return end
hatsP[k]=true
task.spawn(function()
local ch=lp.Character
local hd=ch and ch:WaitForChild("Head",5)
hatsP[k]=nil
if dead then return end
if not hd or hatsW[k]then if not hd then nt("Hats","No head found - re-equip after respawn.")end return end
local sp={}
local S=builder(sp)
local sc=CFG.Hat.Scale*math.min(hd.Size.X,hd.Size.Z)
fn(S,hd.Size.Y/2/sc)
local en=spawn(sp,hd,sc)
en.model.Name="WE_Hat";en.model.Parent=workspace
en.conn=hd.Destroying:Connect(function()if hatsW[k]==en then rmHat(k)else kill(en)end end)
hatsW[k]=en
hatOff();hatLook();ensure()
end)
end
function syncHats()
local want={}
for _,n in ipairs(selH)do if HATS[n]then want[n]=true end end
for k,e in pairs(hatsW)do if not want[k]or not e.model.Parent then rmHat(k)end end
for k in pairs(want)do addHat(k)end
end
local rbT=0
function rebuildHats()
rbT=rbT+1
local mine=rbT
task.delay(0.3,function()
if mine~=rbT or dead then return end
for k in pairs(hatsW)do rmHat(k)end
syncHats()
end)
end
local function rigOf(ch)return ch:FindFirstChild("UpperTorso")and"R15"or"R6"end
local function getRoot()
if not(armRoot and armRoot.Parent)then armRoot=Instance.new("Model");armRoot.Name="WE_Armor";armRoot.Parent=workspace end
return armRoot
end
function rmArm(k)local e=armW[k];armW[k]=nil;if e then kill(e)end end
function clearArm()
for k in pairs(armW)do rmArm(k)end
if armRoot then armRoot:Destroy();armRoot=nil end
end
function armLook()
local A,Ch=CFG.Armor,CFG.Character
local pal={main=A.Main,trim=A.Trim,glow=A.Glow,cloth=A.Cloth,fur=A.Fur}
local mat=Enum.Material[A.Material]
for _,e in pairs(armW)do
for _,r in ipairs(e.parts)do
local p=r.part
if p.Parent then
local role=r.role
local col=pal[role]or A.Main
local m=mat
if role=="glow"then m=Enum.Material.Neon elseif role=="cloth"or role=="fur"then m=Enum.Material.SmoothPlastic end
local tr=(role=="glow")and math.min(A.Transparency,0.6)or A.Transparency
if p.Color~=col then p.Color=col end
if p.Material~=m then p.Material=m end
if p.Transparency~=tr then p.Transparency=tr end
end
if r.light then r.light.Color=A.Glow;r.light.Brightness=A.GlowLight end
end end
if armRoot and armRoot.Parent then
local hl=armRoot:FindFirstChild("WE_ArmorHL")
if A.Highlight then
if not hl then hl=Instance.new("Highlight");hl.Name="WE_ArmorHL";hl.Adornee=armRoot;hl.Parent=armRoot end
hl.FillColor,hl.OutlineColor,hl.FillTransparency=Ch.Fill,Ch.Outline,Ch.FillTransparency
elseif hl then hl:Destroy()end
end
end
local function addArm(k,pc,pn)
if armW[k]or armP[k]then return end
armP[k]=true
task.spawn(function()
local ch=lp.Character
local pt=ch and ch:WaitForChild(pn,5)
armP[k]=nil
if dead or not pt or armW[k]then return end
local sp={}
local S=builder(sp)
local z=pt.Size
local m=pt:FindFirstChildOfClass("SpecialMesh")
local ms=m and m.Scale or V3(1,1,1)
pc.build(S,{hx=z.X/2*ms.X,hy=z.Y/2*ms.Y,hz=z.Z/2*ms.Z},{s=pn:find("Left")and -1 or 1,rig=rigOf(ch),name=pn})
local en=spawn(sp,pt,1)
en.attach,en.cloak=pt,S.meta.cloak
en.model.Name="WE_Armor_"..pc.name;en.model.Parent=getRoot()
en.conn=pt.Destroying:Connect(function()if armW[k]==en then rmArm(k)else kill(en)end end)
armW[k]=en
if en.cloak then cloakStep(en,1,tick(),ch:FindFirstChild("HumanoidRootPart"))end
armLook();ensure()
end)
end
function syncArmor()
local want={}
local ch=lp.Character
if ch then
local rig=rigOf(ch)
for _,pn in ipairs(selA)do
local pc=APC[pn]
if pc then for _,part in ipairs(pc.attach(rig))do want[pn.."|"..part]={pc,part}end end
end
end
for k,e in pairs(armW)do if not want[k]or not e.model.Parent then rmArm(k)end end
for k,v in pairs(want)do addArm(k,v[1],v[2])end
if next(armW)==nil and next(armP)==nil and armRoot then armRoot:Destroy();armRoot=nil end
end
local function clearAll()
for k in pairs(hatsW)do rmHat(k)end
clearArm()
table.clear(hatsP);table.clear(armP)
end
ui=R:CreateWindow({name="World Editor",subtitle="client-side visuals",theme="amethyst",sidebarLayout=true,configuration={autoSave=true,autoLoad=true,fileName="WorldEditor",customFolder="WorldEditor"}})
wtag=ui:CreateTag({text="Weather: off",color=K(110,110,130)})
ptag=ui:CreateTag({text="Preset: -",color=K(120,100,200)})
local ctl={}
local function trk(h,t,k,mn,mx)ctl[#ctl+1]={h=h,t=t,k=k,mn=mn,mx=mx}end
local function refresh()
for _,c in ipairs(ctl)do
local v=c.t[c.k]
if c.mn then v=math.clamp(v,c.mn,c.mx)end
pcall(function()c.h:Set(v,true)end)
end
wsync()
end
local function sl(tab,name,pre,t,k,mn,mx,inc,suf,cb)
trk(tab:CreateSlider({name=name,flag=pre.."_"..k,range={mn,mx},increment=inc,value=math.clamp(t[k],mn,mx),suffix=suf,callback=function(v)t[k]=v;if cb then cb()end end}),t,k,mn,mx)
end
local function tg(tab,name,pre,t,k,cb)
trk(tab:CreateToggle({name=name,flag=pre.."_"..k,value=t[k]and true or false,callback=function(v)t[k]=v;if cb then cb()end end}),t,k)
end
local function cp(tab,name,pre,t,k,cb)
trk(tab:CreateColorPicker({name=name,flag=pre.."_"..k,color=t[k],callback=function(c)t[k]=c;if cb then cb()end end}),t,k)
end
local function build(n,pre,t,items)
local tab=ui:CreateTab({name=n})
for _,i in ipairs(items)do
if i[2]=="s"then sl(tab,i[3],pre,t,i[1],i[4],i[5],i[6],i[7],i[8])
elseif i[2]=="t"then tg(tab,i[3],pre,t,i[1],i[4])
elseif i[2]=="c"then cp(tab,i[3],pre,t,i[1],i[4])
else i[3](tab)end
end
return tab
end
local function refreshAll()applyVis();wupd();applyChar()end
local function applyPreset(n)
local p=PRE[n]if not p then return end
for _,c in ipairs({"Lighting","Atmosphere","Post","Weather"})do
local t=CFG[c]
for k in pairs(t)do t[k]=nil end
merge(t,copy(DEF[c]))
end
merge(CFG,copy(p))
vis=true;refreshAll();refresh()
pcall(function()ptag:Set({text="Preset: "..n,color=K(120,100,200)})end)
end
local function first(v)if type(v)=="table"then return v[1]end return v end
do
local t=ui:CreateTab({name="Presets"})
local g=t:CreateGroup()
for _,n in ipairs({"Day","Sunset","Night","Vaporwave","Snow","Storm","Bloodmoon","Mist"})do g:CreateButton({name=n,callback=function()applyPreset(n)end})end
t:CreateButton({name="Hide menu (RightShift)",callback=function()ui:Hide()end})
t:CreateButton({name="Disable all and restore",callback=function()env.WorldEditor.Destroy()end})
end
build("Lighting","Light",CFG.Lighting,{
{"ClockTime","s","Time",0,24,0.05},{"CycleSpeed","s","Day cycle speed",0,5,0.05},
{"Ambient","c","Ambient"},{"OutdoorAmbient","c","Outdoor Ambient"},{"ColorShift_Top","c","Shift Top"},{"ColorShift_Bottom","c","Shift Bottom"},
{"Brightness","s","Brightness",0,10,0.05},{"ExposureCompensation","s","Exposure",-3,3,0.05},{"GlobalShadows","t","Shadows"},
{"FogOn","t","Fog"},{"FogColor","c","Fog color"},{"FogStart","s","Fog start",0,2000,5},{"FogEnd","s","Fog end",50,5000,10}})
do
local S=CFG.Sky
local ins={}
local function sid(x)x=tostring(x):gsub("%s","")if x==""then return""end if tonumber(x)then return"rbxassetid://"..x end return x end
build("Sky","Sky",S,{
{"Enabled","t","Custom skybox",enVis},
{"","x",function(t)
t:CreateInput({name="One ID for all sides",placeholder="quick test",forgetState=true,flag="Sky_All",callback=function(x)
local id=sid(x)if id==""then return end
for _,k in ipairs({"Bk","Dn","Ft","Lf","Rt","Up"})do S[k]=id;if ins[k]then pcall(function()ins[k]:Set(id,true)end)end end
enVis()end})
for _,f in ipairs({{"Bk","Back"},{"Ft","Front"},{"Lf","Left"},{"Rt","Right"},{"Up","Up"},{"Dn","Down"}})do
ins[f[1]]=t:CreateInput({name=f[2],placeholder="Image ID",flag="Sky_"..f[1],value=S[f[1]],callback=function(x)S[f[1]]=sid(x);enVis()end})end
end},
{"StarCount","s","Stars",0,5000,50,nil,enVis},{"SunSize","s","Sun size",0,60,1,nil,enVis},{"MoonSize","s","Moon size",0,60,1,nil,enVis},
{"Rotation","s","Skybox rotation",0,360,1,"°",enVis},{"CelestialBodies","t","Sun and moon",enVis}})
end
build("Atmosphere","Atmo",CFG.Atmosphere,{
{"Enabled","t","Enabled",enVis},{"Density","s","Density",0,1,0.01,nil,enVis},{"Offset","s","Offset",0,1,0.01,nil,enVis},
{"Color","c","Color",enVis},{"Decay","c","Decay",enVis},{"Glare","s","Glare",0,10,0.05,nil,enVis},{"Haze","s","Haze",0,10,0.05,nil,enVis}})
build("Post FX","Post",CFG.Post,{
{"Enabled","t","Enabled",enVis},{"Saturation","s","Saturation",-1,2,0.01,nil,enVis},{"Contrast","s","Contrast",-1,1,0.01,nil,enVis},
{"Brightness","s","Brightness",-1,1,0.01,nil,enVis},{"TintColor","c","Tint",enVis},
{"Bloom","s","Bloom",0,5,0.05,nil,enVis},{"BloomSize","s","Bloom size",0,56,1,nil,enVis},{"BloomThreshold","s","Bloom threshold",0,4,0.05,nil,enVis},
{"SunRays","s","Sun rays",0,1,0.01,nil,enVis},{"Blur","s","Blur",0,30,0.5,nil,enVis}})
do
local W=CFG.Weather
build("Weather","Weather",W,{
{"","x",function(t)
local g=t:CreateGroup()
for _,w in ipairs({{"Rain","Rain"},{"Storm","Thunderstorm"},{"Snow","Snow"},{"Ash","Ash"},{"Embers","Embers"}})do
wt[w[1]]=g:CreateToggle({name=w[2],flag="Weather_"..w[1],value=W.Type==w[1],callback=function(on)
if on then W.Type=w[1]elseif W.Type==w[1]then W.Type="None"end
wupd()end})end
end},
{"Intensity","s","Intensity",0.1,3,0.05,nil,wupd},{"Wind","s","Wind",0,30,0.5,nil,wupd},
{"WindAngle","s","Wind direction",0,360,5,"°",wupd},{"Lightning","t","Lightning"}})
end
do
local C=CFG.Character
build("Character","Char",C,{
{"Highlight","t","Highlight",enChr},{"Rainbow","t","Rainbow",enChr},{"Fill","c","Fill color",enChr},{"Outline","c","Outline",enChr},
{"FillTransparency","s","Fill transparency",0,1,0.01,nil,enChr},
{"UseColor","t","Recolor body",enChr},{"BodyColor","c","Body color",enChr},{"BodyTransparency","s","Body transparency",0,1,0.01,nil,enChr},
{"","x",function(t)t:CreateDropdown({name="Material",flag="Char_Material",options={"Default","Neon","Glass","ForceField","Metal","Ice","Marble"},value="Default",callback=function(v)
v=first(v);C.Material=(v==nil or v=="Default")and""or v;enChr()end})end},
{"Trail","t","Trail",enChr},{"Aura","t","Aura",enChr}})
end
do
local H,hatDD=CFG.Hat,nil
build("Hats","Hat",H,{
{"","x",function(t)
hatDD=t:CreateDropdown({name="Worn hats",flag="Hats_Script",multiSelect=true,options=HNAMES,value={},placeholder="nothing equipped",callback=function(v)
if type(v)=="string"then v={v}end
selH=v or{};syncHats()end})
end},
{"Color","c","Main color",hatLook},{"Accent","c","Accent color",hatLook},{"Rainbow","t","Rainbow",hatLook},{"Neon","t","Neon",hatLook},
{"Highlight","t","Highlight",hatLook},{"Transparency","s","Transparency",0,0.95,0.01,nil,hatLook},
{"","x",function(t)t:CreateDropdown({name="Material",flag="Hat_Material",options={"SmoothPlastic","Plastic","Metal","Glass","Fabric","Marble","Ice"},value="SmoothPlastic",callback=function(v)
H.Material=first(v)or"SmoothPlastic";hatLook()end})end},
{"Scale","s","Size",0.4,3,0.05,"x",rebuildHats},
{"","x",function(t)
sl(t,"Higher / lower","Char",CFG.Character,"HatY",-2,2,0.05,nil,hatOff)
sl(t,"Forward / back","Char",CFG.Character,"HatZ",-2,2,0.05,nil,hatOff)
t:CreateButton({name="Remove all hats",callback=function()pcall(function()hatDD:Set({})end);selH={};syncHats()end})
end}})
end
do
local A,armDD=CFG.Armor,nil
build("Armor","Armor",A,{
{"","x",function(t)
armDD=t:CreateDropdown({name="Worn armor",flag="Armor_Pieces",multiSelect=true,options=ANAMES,value={},placeholder="nothing equipped",callback=function(v)
if type(v)=="string"then v={v}end
selA=v or{};syncArmor()end})
t:CreateButton({name="Equip full set",callback=function()
selA={}for _,n in ipairs(ANAMES)do selA[#selA+1]=n end
pcall(function()armDD:Set(selA)end);syncArmor()end})
t:CreateButton({name="Remove all armor",callback=function()pcall(function()armDD:Set({})end);selA={};syncArmor()end})
local g=t:CreateGroup()
for _,n in ipairs(APN)do g:CreateButton({name=n,callback=function()for k,v in pairs(APRE[n])do A[k]=v end;refresh();armLook()end})end
end},
{"Main","c","Main (steel)",armLook},{"Trim","c","Trim",armLook},{"Glow","c","Glow",armLook},{"Cloth","c","Cloak cloth",armLook},{"Fur","c","Cloak collar",armLook},
{"Transparency","s","Transparency",0,0.9,0.01,nil,armLook},{"GlowLight","s","Glow light",0,5,0.05,nil,armLook},{"Highlight","t","Highlight",armLook},
{"","x",function(t)t:CreateDropdown({name="Metal",flag="Armor_Material",options={"Metal","DiamondPlate","CorrodedMetal","Slate","Granite","Marble","SmoothPlastic","Ice"},value="Metal",callback=function(v)
A.Material=first(v)or"Metal";armLook()end})end},
{"CloakSway","s","Cloak sway",0,2.5,0.05}})
end
do
local t=ui:CreateTab({name="Configs"})
local nm,sel,ld="",nil,nil
local function list()local o,l=pcall(function()return ui:ListConfigs()end)if o and ld then pcall(function()ld:Refresh(l or{})end)end end
t:CreateInput({name="Config name",placeholder="e.g. night_vibe",forgetState=true,flag="Cfg_Name",callback=function(x)nm=(tostring(x):gsub("[^%w_%- ]",""))end})
t:CreateButton({name="Save",callback=function()
if nm==""then nt("Config","Type a name first.")return end
local o=ui:Save(nm)
nt("Config",o and("Saved: "..nm)or"Save failed (needs writefile).")
list()end})
local o,l=pcall(function()return ui:ListConfigs()end)
ld=t:CreateDropdown({name="Saved configs",flag="Cfg_List",forgetState=true,options=o and l or{},placeholder="none",callback=function(v)sel=first(v)end})
t:CreateButton({name="Load selected",callback=function()
if not sel then nt("Config","Pick a config first.")return end
local o=ui:Load(sel)
vis,chr=true,true
applyVis();applyChar();wupd();syncHats();syncArmor();armLook();hatLook()
nt("Config",o and("Loaded: "..sel)or"Load failed.")end})
t:CreateButton({name="Delete selected",callback=function()
if not sel then nt("Config","Pick a config first.")return end
local o=ui:DeleteConfig(sel)
nt("Config",o and("Deleted: "..sel)or"Delete failed.")
sel=nil;list()end})
t:CreateButton({name="Refresh list",callback=list})
end
local lt,st=0,0
RS:BindToRenderStep("WE_Loop",Enum.RenderPriority.Last.Value,function(dt)
lstep(dt)
local cam=workspace.CurrentCamera
if wp and cam then wp.CFrame=CFrame.new(cam.CFrame.Position+V3(0,wy,0))end
if CFG.Weather.Type=="Storm"and CFG.Weather.Lightning then
lt=lt-dt
if lt<=0 then flash=0.12;lt=math.random(40,120)/10 end
end
if CFG.Character.Rainbow and chr then
local col=Color3.fromHSV(tick()%4/4,1,1)
CFG.Character.Fill,CFG.Character.Outline=col,col
local ch=lp.Character
local hl=ch and ch:FindFirstChild("WE_HL")
if hl then hl.FillColor,hl.OutlineColor=col,col end
local ah=armRoot and armRoot:FindFirstChild("WE_ArmorHL")
if ah then ah.FillColor,ah.OutlineColor=col,col end
for _,hat in pairs(hatsW)do local hh=hat.model:FindFirstChild("WE_HatHL")if hh then hh.FillColor,hh.OutlineColor=col,col end end
end
st=st+dt
if st>=1 then st=0;applyVis();applyChar()end
end)
local cAdd=lp.CharacterAdded:Connect(function()
clearAll()
task.wait(1.5)
if dead then return end
applyChar();syncHats();syncArmor()
end)
local cIn=UIS.InputBegan:Connect(function(i,p)
if not p and i.KeyCode==Enum.KeyCode.RightShift then pcall(function()ui:ToggleHide()end)end
end)
env.WorldEditor={Config=CFG,Window=ui,Preset=applyPreset,
Apply=function()vis,chr=true,true;refreshAll()end,
Destroy=function()
dead=true
pcall(function()RS:UnbindFromRenderStep("WE_Loop")end)
cAdd:Disconnect();cIn:Disconnect()
if gconn then gconn:Disconnect();gconn=nil end
for _,p in ipairs(LP)do Lt[p]=ORIG[p]end
for _,n in ipairs({"WE_Sky","WE_Atmo","WE_CC","WE_Bloom","WE_Rays","WE_Blur"})do local o=Lt:FindFirstChild(n)if o then o:Destroy()end end
unstash("Sky");unstash("Atmosphere")
if wp then wp:Destroy()end
clearAll()
local ch=lp.Character
if ch then
local hl=ch:FindFirstChild("WE_HL")if hl then hl:Destroy()end
for p,o in pairs(orig)do if p.Parent then p.Color,p.Material,p.Transparency=o[1],o[2],o[3]end end
local root=ch:FindFirstChild("HumanoidRootPart")
if root then for _,n in ipairs({"WE_Trail","WE_A0","WE_A1","WE_Aura"})do local o=root:FindFirstChild(n)if o then o:Destroy()end end end
end
pcall(function()ui:Unload()end)
env.WorldEditor=nil
end}
task.defer(function()
local ch=false
for _,c in ipairs({"Atmosphere","Post","Sky"})do for k,v in pairs(CFG[c])do if v~=DEF[c][k]then ch=true end end end
for k,v in pairs(CFG.Character)do if v~=DEF.Character[k]then chr=true end end
if ch then vis=true end
refreshAll();wsync();syncHats();syncArmor()
nt("World Editor ready","Menu: RightShift. Configs tab saves your setup.")
end)
