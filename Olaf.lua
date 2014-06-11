if GetMyHero().charName ~= "Olaf" then return end

local version = 0.01
local pVersion = "0.01"
local AUTOUPDATE = true
local SCRIPT_NAME = "Olaf"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local SOURCELIB_URL = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"
local SOURCELIB_PATH = LIB_PATH.."SourceLib.lua"

if FileExist(SOURCELIB_PATH) then
	require("SourceLib")
else
	DOWNLOADING_SOURCELIB = true
	DownloadFile(SOURCELIB_URL, SOURCELIB_PATH, function() print("Required libraries downloaded successfully, please reload") end)
end

if DOWNLOADING_SOURCELIB then print("Downloading required libraries, please wait...") return end

if AUTOUPDATE then
	SourceUpdater(SCRIPT_NAME, version, "raw.github.com", "/leobogkoda/MyBoL/master/"..SCRIPT_NAME..".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/leobogkoda/MyBoL/master/"..SCRIPT_NAME..".version"):CheckUpdate()
end

local RequireI = Require("SourceLib")
	RequireI:Add("vPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
	RequireI:Add("SOW", "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
	RequireI:Check()

if RequireI.downloadNeeded == true then return end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Ranges = { [_Q] = 1000, [_E] = 325, [_W] = 200 }
local Widths = {[_Q] = 30}
local Delays = {[_Q] = 0.25}
local Speeds = {[_Q] = 1600}

function OnLoad()

  VP = VPrediction(true)
  STS = SimpleTS(STS_LESS_CAST_PHYSICAL)
  SOWi = SOW(VP, STS)
   
  PrintChat("Olaf by iGOD")
  Menu = scriptConfig("Olaf", "Olaf")
  
  Menu:addSubMenu("Target Selector", "STS")
  STS:AddToMenu(Menu.STS)
  
  Menu:addSubMenu("Orbwalk", "Orbwalk")
  SOWi:LoadToMenu(Menu.Orbwalk)
  SOWi:RegisterAfterAttackCallback(AfterAttack)
  
  Menu:addSubMenu("Carry Me", "OlafCombo")
  Menu.OlafCombo:addParam("useQ", "Use Q in Carry Mode", SCRIPT_PARAM_ONOFF, true)
  Menu.OlafCombo:addParam("useE", "Use E in Carry Mode", SCRIPT_PARAM_ONOFF, true)
  Menu.OlafCombo:addParam("CarryMe", "Carry Me!", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  
  
  Menu:addParam("ksE", "Kill steal with E", SCRIPT_PARAM_ONOFF, true)
  Menu:addParam("lasthit", "Lasthit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
  Menu:addParam("laneclear", "Laneclear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))

  Menu.OlafCombo:permaShow("CarryMe")
  Menu:permaShow("lasthit")
  Menu:permaShow("laneclear")
  
  enemyMinions = minionManager(MINION_ENEMY, 700, myHero)
  
end

function _CarryMe()
  
  local target = STS:GetTarget(Ranges[_Q])
  

  if Menu.OlafCombo.useQ and target ~= nil then
    if myHero:CanUseSpell(_Q) == READY and ValidTarget(target, Ranges[_Q]) then
    local CastPosition = VP:GetLineCastPosition(target, Delays[_Q], Widths[_Q], Ranges[_Q], Speeds[_Q], myHero, true)
	  CastSpell(_Q, CastPosition.x, CastPosition.z)
	end
  end
  
  if Menu.OlafCombo.useE and target ~= nil then
    if  myHero:CanUseSpell(_E) == READY and ValidTarget(target, Ranges[_E]) then
    CastSpell(_E, target)
	end
  end
  
  if target ~= nil then
    if GetDistance(target) <= Ranges[_W] and myHero:CanUseSpell(_W) == READY and ValidTarget(target, Ranges[_W]) then
    CastSpell(_W)
    end
  end  
end

function _KillStealE()

  
  for i, target in pairs(GetEnemyHeroes()) do
			local eDmg = getDmg("E",target,myHero)
			if target.health <= eDmg and GetDistance(target) <= Ranges[_E] and myHero:CanUseSpell(_E) == READY and ValidTarget(target,Ranges[_E]) then
				CastSpell(_E, target) 
			end
  end

end

function _LaneClear()



end

function OnTick()

  if myHero.dead then return end

  
  if Menu.OlafCombo.CarryMe then
    _CarryMe()
  end
  

 
 if Menu.ksE then
   _KillStealE()
 end

end

function OnDraw()

 DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0xC2743C)

end