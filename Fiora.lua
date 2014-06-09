if GetMyHero().charName ~= "Fiora" then return end

local version = 0.01
local pVersion = "0.01"
local AUTOUPDATE = true
local SCRIPT_NAME = "Fiora"

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
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local SpellRange = {[_Q] = 600, [_R] = 400, [_E] = 400}
local NextQ = 0

function OnLoad()
   
  VP = VPrediction(true)
  STS = SimpleTS(STS_LESS_CAST_PHYSICAL)
  SOWi = SOW(VP, STS)
   
  PrintChat("Feeora by iGOD")
  FioraMenu = scriptConfig("Fiora", "Fiora")
  
  FioraMenu:addSubMenu("Target Selector", "STS")
  STS:AddToMenu(FioraMenu.STS)
  
  FioraMenu:addSubMenu("Orbwalk", "Orbwalk")
  SOWi:LoadToMenu(FioraMenu.Orbwalk)
  SOWi:RegisterAfterAttackCallback(AfterAttack)
  
  FioraMenu:addParam("QKS", "Kill steal with Q", SCRIPT_PARAM_ONOFF, true)
  FioraMenu:addParam("QDelay", "2nd Q Delay (ms)", SCRIPT_PARAM_SLICE, 0, 0, 4000)
  
  FioraMenu:addParam("AutoParry", "Auto Parry", SCRIPT_PARAM_ONOFF, true)
  FioraMenu:addParam("AutoR", "Auto Ultimate", SCRIPT_PARAM_ONOFF, true)
  FioraMenu:addParam("CarryMe", "Carry Me!", SCRIPT_PARAM_ONKEYDOWN, false, 32)

end

function _CarryMe()
  
  -- Wow much combo
  local target = STS:GetTarget(SpellRange[_Q])
  
  
    if myHero:CanUseSpell(_Q) == READY and  target ~= nil then
          if GetDistance(target) <= SpellRange[_Q] and GetTickCount() > NextQ  then
	          CastSpell(_Q, target)
		      NextQ = GetTickCount() + FioraMenu.QDelay
		  end
	end
	  
	if myHero:CanUseSpell(_E) == READY and ValidTarget(target, SpellRange[_E]) and target ~= nil then
	      CastSpell(_E)
	end

end

function _AutoUltimate()

  local target = STS:GetTarget(SpellRange[_R])
  local rDamage = 0
  
  if myHero:CanUseSpell(_R) == READY and target ~= nil then
      if ValidTarget(target, SpellRange[_R]) then
	      rDamage = getDmg("R",target,myHero) * 2
		  if rDamage > target.health then
		    CastSpell(_R, target)
		  end
	  end
  end

end

function _QKillSteal()

  local target = STS:GetTarget(SpellRange[_Q])
  local qDamage = 0
  
  if myHero:CanUseSpell(_Q) == READY and ValidTarget(target, SpellRange[_Q]) then
      qDamage = getDmg("Q",target,myHero)
	  if qDamage > target.health then
	      CastSpell(_Q, target)
	  end
  end
  
end


function OnTick()

  if FioraMenu.CarryMe then
      _CarryMe()
  end
  
  if FioraMenu.AutoR then
      _AutoUltimate()
  end
  
  if FioraMenu.QKS then
      _QKillSteal()
  end 
   
end