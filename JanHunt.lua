DotMessageFrame = CreateFrame("Frame")
DotMessageFrame:SetFrameStrata("BACKGROUND")
DotMessageFrame:SetWidth(100)
DotMessageFrame:SetHeight(50)
DotMessageFrame:SetPoint("CENTER",0,-100)

DotMessageFrame.text = DotMessageFrame:CreateFontString(nil, "ARTWORK")
DotMessageFrame.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
DotMessageFrame.text:SetPoint("CENTER",0,0)

actionBlockEndTime = nil;  -- if im spell clicking abilty, ignore clicks after spell was casted

local lastSerpentCastTime = nil;
local serpentText = "0"; 
local isInCombat = false;

DotMessageFrame:SetScript("OnUpdate", function()
  -- only check for updates every .2 seconds
  if not isInCombat then return end
  if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + .2 end

  if lastSerpentCastTime ~= nil then 
    local diff = GetTime()- lastSerpentCastTime
    local duration = 17
    if diff > duration then 
      serpentText = ""
      lastSerpentCastTime = nil
    else 
      serpentText = "Serpent "..string.format("%.0f",duration - diff) 
    end
  end;

  DotMessageFrame.text:SetText(serpentText) 
end);

SerpentCast = function() 
  lastSerpentCastTime = GetTime()
end;


DotMessageFrame:Hide();
DotMessageFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
DotMessageFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
-- DotMessageFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
DotMessageFrame:SetScript("OnEvent", function() 
	if event == "PLAYER_REGEN_DISABLED" then
		DotMessageFrame:Show()
    isInCombat = true
		-- UIErrorsFrame:AddMessage("DotMessageFrame |cffffffaa INFIGHT")
  elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
		DotMessageFrame:Hide()
    isInCombat = false
		-- UIErrorsFrame:AddMessage("DotMessageFrame |cffffffaa OUTFIGHT")
  end
end);




BuffMessageFrame = CreateFrame("Frame")
BuffMessageFrame:SetFrameStrata("BACKGROUND")
BuffMessageFrame:SetWidth(100)
BuffMessageFrame:SetHeight(50)
BuffMessageFrame:SetPoint("CENTER",0,-120)

BuffMessageFrame.text = BuffMessageFrame:CreateFontString(nil, "ARTWORK")
BuffMessageFrame.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
BuffMessageFrame.text:SetPoint("CENTER",0,0)

BuffMessageFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
BuffMessageFrame:SetScript("OnEvent", function() 
  if event == "PLAYER_AURAS_CHANGED" then
    CheckBuffs()
  end
end);

CheckBuffs = function () 
  local i = 1
  local hawkFound = false
  local auraFound = false
  while UnitBuff("player",i) do
    if UnitBuff("player",i)=="Interface\\Icons\\Spell_Nature_RavenForm" then
      hawkFound = true
    elseif UnitBuff("player",i)=="Interface\\Icons\\Ability_TrueShot" then
      auraFound = true
    else end 
    i=i+1 
  end 

  local hawkText = not hawkFound and "hawk missing" or "";
  local auraText = not auraFound and "aura missing" or "";

  BuffMessageFrame.text:SetText(hawkText.." "..auraText)

end;
CheckBuffs()


message("JanHunt loaded")