local _, ns = ...
local cfg = ns.cfg
local oUF = ns.oUF or oUF

if not cfg.WeakenedSoulHighlight then return end

local playerClass = select(2, UnitClass("player"))


local function CheckWeakenedDebuff(unit)
	if not UnitCanAssist("player", unit) then return nil end
	
	local i = 1
	while true do
		local name = UnitAura(unit, i, "HARMFUL")
		if not name then break end
		if name == "Weakened Soul" then return true end
		i = i + 1
	end
end

local function CheckSpec(self, event)
	--[[local spec = GetSpecialization()
	if playerClass == "DRUID" then
		if (spec == 4) then
			dispellist.Magic = true
		else
			dispellist.Magic = false
		end
	elseif playerClass == "MONK" then
		if (spec == 2) then
			dispellist.Magic = true
		else
			dispellist.Magic = false
		end
	elseif playerClass == "PALADIN" then
		if (spec == 1) then
			dispellist.Magic = true
		else
			dispellist.Magic = false
		end
	elseif playerClass == "SHAMAN" then
		if (spec == 3) then
			dispellist.Magic = true
		else
			dispellist.Magic = false
		end
	elseif playerClass == "PRIEST" then
		if (spec == 3) then
			dispellist.Disease = false
			dispellist.Magic = false
			
		else
			dispellist.Disease = true
			dispellist.Magic = true
		end
	end]]
end

local function Update(object, event, unit)
	
	if object.unit ~= unit  then return end
	local role = UnitGroupRolesAssigned(unit)
<<<<<<< HEAD
	if role ~= "TANK" then 
=======
	local s = UnitThreatSituation(object.unit)
	
	if role ~= "TANK" or s <= 1 then 
>>>>>>> origin/master
		object.Health.colorSmooth = true
		object.Health.colorClass = false
		return 
	end
<<<<<<< HEAD
	
=======
		
>>>>>>> origin/master
	local r, g, b, t
	
	local check  = CheckWeakenedDebuff(unit)
	if check or UnitAura(unit, "Power Word: Shield") then 		-- no need to check if PW:S is still activethen		-- set healtbar color to class color if Weakened Soul Debuff is *NOT* available
		object.Health.colorSmooth = true
		object.Health.colorClass = false
	else
		object.Health.colorSmooth = false
		object.Health.colorClass = true
	end
	
	-- force color update on aura change
	local r, g, b, t
	if(object.Health.colorSmooth) then
	
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		r, g, b = oUF.ColorGradient(min, max, unpack(object.Health.smoothGradient or oUF.colors.smooth))
	elseif (object.Health.colorClass and UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = oUF.colors.class[class]
		
	end
	
	if(t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	if(b) then
		object.Health:SetStatusBarColor(r, g, b, 0.9)

		local bg = object.Health.bg
		if(bg) then local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end
	
	
end

local function Enable(object)
	-- if we're not highlighting this unit return
	if not object.DebuffHighlightBackdrop and not object.DebuffHighlightBackdropBorder and not object.DebuffHighlight then
		return
	end
	-- if we're filtering highlights and we're not of the dispelling type, return
	--[[if object.DebuffHighlightFilter and not CanDispel[playerClass] then
		return
	end]]
	
	-- make sure aura scanning is active for this object
	object:RegisterEvent("UNIT_AURA", Update)
<<<<<<< HEAD
=======
	object:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', Update)
	object:RegisterEvent('UNIT_THREAT_LIST_UPDATE', Update)
>>>>>>> origin/master
	object:RegisterEvent("PLAYER_ENTERING_WORLD", CheckSpec)
	object:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)

	return true
end

local function Disable(object)
	if object.DebuffHighlightBackdrop or object.DebuffHighlightBackdropBorder or object.DebuffHighlight then
		object:UnregisterEvent("UNIT_AURA", Update)
<<<<<<< HEAD
=======
		object:UnregisterEvent('UNIT_THREAT_SITUATION_UPDATE', Update)
		object:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', Update)
>>>>>>> origin/master
		object:UnregisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	end
end

oUF:AddElement('WeakenedSoulHighlight', Update, Enable, Disable)

for i, frame in ipairs(oUF.objects) do Enable(frame) end