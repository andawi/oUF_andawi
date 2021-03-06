-- raid layout
local name, ns = ...
local cfg = ns.cfg
local _, class = UnitClass('player')

local raidgrp1, raidgrp2, raidgrp3, raidgrp4, raidgrp5


local backdrop = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = 1, left = 1, bottom = 1, right = 1},
}

local backdrop_1px = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local OnEnter = function(self)
    UnitFrame_OnEnter(self)
    self.Highlight:Show()
  ns:arrow(self, self.unit)
end

local OnLeave = function(self)
    UnitFrame_OnLeave(self)
    if not UnitIsUnit('target', self.unit) then self.Highlight:Hide() end
	if(self.freebarrow and self.freebarrow:IsShown()) and ns.arrowmouseover or (ns.arrowmouseoveralways and not self.OoR)then
				self.freebarrow:Hide()
			end
end

local range = {
        insideAlpha = 1,
        outsideAlpha = .25,
    }

	ns.RangeArrowScale = 0.7
	ns.arrowmouseover = true
	ns.arrowmouseoveralways = false

local Highlight = function(self)
    self.Highlight = self:CreateTexture(nil, 'HIGHLIGHT')
	self.Highlight:SetAllPoints(self)
	self.Highlight:SetBlendMode('ADD')
	self.Highlight:SetTexture(cfg.highlightBorder)
	self.Highlight:SetVertexColor(1, 1, 1, 0.05)
end

local ChangedTarget = function(self)
    if UnitIsUnit('target', self.unit) then
        self.Highlight:Show()
    else
        self.Highlight:Hide()
    end
end


local RaidSizeSwitcher = function(self)

	if InCombatLockdown() then return end


	local difficulty = GetRaidDifficultyID()
	if difficulty == 3 or difficulty == 5 then -- 10 player
		raidgrp1:SetAttribute("showRaid", true)
		raidgrp2:SetAttribute("showRaid", true)
		raidgrp3:SetAttribute("showRaid", false)
		raidgrp4:SetAttribute("showRaid", false)
		raidgrp5:SetAttribute("showRaid", false)

	elseif difficulty == 4 or difficulty == 6  or difficulty == 7 then -- 25 player
		raidgrp1:SetAttribute("showRaid", true)
		raidgrp2:SetAttribute("showRaid", true)
		raidgrp3:SetAttribute("showRaid", true)
		raidgrp4:SetAttribute("showRaid", true)
		raidgrp5:SetAttribute("showRaid", true)

	elseif difficulty == 16 then -- mythic
		raidgrp1:SetAttribute("showRaid", true)
		raidgrp2:SetAttribute("showRaid", true)
		raidgrp3:SetAttribute("showRaid", true)
		raidgrp4:SetAttribute("showRaid", true)
		raidgrp5:SetAttribute("showRaid", false)
		raidgrp6:SetAttribute("showRaid", false)
		raidgrp7:SetAttribute("showRaid", false)
		raidgrp8:SetAttribute("showRaid", false)

	elseif difficulty == 17 then -- LFR
		raidgrp1:SetAttribute("showRaid", true)
		raidgrp2:SetAttribute("showRaid", true)
		raidgrp3:SetAttribute("showRaid", true)
		raidgrp4:SetAttribute("showRaid", true)
		raidgrp5:SetAttribute("showRaid", true)


	else
		raidgrp1:SetAttribute("showRaid", true)
		raidgrp2:SetAttribute("showRaid", true)
		raidgrp3:SetAttribute("showRaid", true)
		raidgrp4:SetAttribute("showRaid", true)
		raidgrp5:SetAttribute("showRaid", true)


	end
end


local auraIcon = function(auras, button)
    local c = button.count
    c:ClearAllPoints()
    c:SetFontObject(nil)
    c:SetFont(cfg.aura_font, cfg.aura_fontsize, cfg.aura_fontflag)
    c:SetTextColor(.8, .8, .8)
    auras.disableCooldown = cfg.disableCooldown
	button.cd:SetReverse(true)  	--inverse cooldown spiral
	button.cd.noCooldownCount = true	--prevent OmniCC from showing CD counter in this button
    button.icon:SetTexCoord(.1, .9, .1, .9)
	if cfg.border then
        auras.showDebuffType = true
        button.overlay:SetTexture(cfg.buttonTex)
        button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
        button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
        button.overlay:SetTexCoord(0, 1, 0.02, 1)
        button.overlay.Hide = function(self) self:SetVertexColor(0.33, 0.59, 0.33) end
		c:SetPoint("BOTTOMRIGHT")
		button.bg = framebd(button, button)
	else
        button.overlay:Hide()
		auras.showDebuffType = true
		button.overlay:SetTexture(nil)
		c:SetPoint("BOTTOMRIGHT", 3, -1)
        button:SetBackdrop(backdrop_1px)
	    button:SetBackdropColor(0, 0, 0, 1)
        button.glow = CreateFrame("Frame", nil, button)
        button.glow:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
        button.glow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)
        button.glow:SetFrameLevel(button:GetFrameLevel()-1)
        button.glow:SetBackdrop({bgFile = "", edgeFile = "Interface\\AddOns\\Media\\glowTex",
        edgeSize = 5,insets = {left = 3,right = 3,top = 3,bottom = 3,},})
	end

end


local PostUpdateHealth = function (health, unit, min, max)

	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)

	if disconnnected or dead or ghost then
		health:SetValue(max)

		if(disconnnected) then
			health:SetStatusBarColor(0.8,0.8,0.8,0.8)
		elseif(ghost) then
			health:SetStatusBarColor(1,1,1,0.3)
		elseif(dead) then
			health:SetValue(0)
			--health:SetStatusBarColor(1,0,0,0.2)
		end
	else
		health:SetValue(min)
		if(unit == 'vehicle') then
			health:SetStatusBarColor(22/255, 106/255, 44/255)
		end
	end



end



local PostUpdateIcon = function(icons, unit, icon, index, offset)
	local name, _, _, _, dtype, duration, expirationTime, unitCaster = UnitAura(unit, index, icon.filter)

	local texture = icon.icon
	if icon.isPlayer or UnitIsFriend('player', unit) or not icon.isDebuff then
		texture:SetDesaturated(false)
	else
		texture:SetDesaturated(true)
	end


	if not cfg.border then
		if icon.isDebuff then
		    local r,g,b = icon.overlay:GetVertexColor()
		    icon.glow:SetBackdropBorderColor(r,g,b,0.75)
	    else
		    icon.glow:SetBackdropBorderColor(0,0,0,1)
	    end
    end

    icon.duration = duration
    icon.expires = expirationTime


end

local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, _, _, _, caster = ...
    local isPlayer

    if (caster == 'player' or caster == 'vechicle') then
        isPlayer = true
    end

    if((icons.onlyShowPlayer and isPlayer) or (not icons.onlyShowPlayer and name)) then
        icon.isPlayer = isPlayer
        icon.owner = caster
        return true
    end
end


local CustomDebuffFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster)

	if not cfg.debuffFilter[name] then
		return true		-- true = visible
	end

end

----------------------------------------------------------------------------------------
--	AuraWatch
----------------------------------------------------------------------------------------
local AWIcon = function(AWatch, icon, spellID, name, self)			--AuraWatch

	if icon.Class then
		local classcolor = RAID_CLASS_COLORS[icon.Class]
		local r,g,b = classcolor.r,classcolor.g,classcolor.b
		--print(icon.Class)
		--print(r, g, b)
	end

	icon:SetBackdrop(backdrop_1px)

	if spellID == 6788 then 		--weakened soul
		icon:SetBackdropColor(1,0,0,0.85)
	else
		icon:SetBackdropColor(0,0,0,0.85)
	end

	icon.cd:SetReverse(true)

end

local createAuraWatch = function(self, unit)
	if cfg.showAuraWatch then

		local auras = CreateFrame("Frame", nil, self.Health)
		auras:SetAllPoints(self.Health)
		auras.onlyShowPresent = true
		auras.icons = {}
		auras.customIcons = true		-- org. AuraWatch cd frame will overlap each other - thus create own frame for this
		auras:SetFrameStrata('HIGH')

		for i, v in pairs(cfg.spellIDs) do

			if (v[7] == class) or (v[7] == 'GENERIC') then
				local icon = CreateFrame("Frame", nil, auras)
				icon.spellID = v[1]
				icon:SetSize(v[2], v[2])
				icon:SetFrameLevel(i)

				if v[3] then
					icon:SetPoint('CENTER', self, 'LEFT', v[3], v[4])
				else
					icon:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", -7 * i, 0)
				end

				icon.anyUnit = v[5]

				local name, _, image = GetSpellInfo(v[1])
				local tex = icon:CreateTexture(nil, "ARTWORK")
				tex:SetTexCoord(.07, .93, .07, .93)

				tex:SetAllPoints(icon)
				tex:SetTexture(image)

				icon.icon = tex

				if v[6] then icon.icon:SetAlpha(v[6]) end

				local cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
				cd:SetAllPoints(icon)
				--cd:SetFrameLevel(i)
				icon.cd = cd

				local count = fs(icon, "OVERLAY", cfg.font_Pixel13, 13, "THINOUTLINE", 1, 1, 1)
				count:SetPoint("CENTER", icon, "BOTTOMRIGHT", -2,5)
				icon.count = count

				if v[8] then icon.Class = v[8] end

				auras.icons[v[1]] = icon
			end

			auras.PostCreateIcon = AWIcon

		end
		self.AuraWatch = auras
	end
end


local RaidIcon = function(self)
	ricon = self.Health:CreateTexture(nil, "OVERLAY")
	ricon:SetTexture(cfg.raidIcons)
	self.RaidIcon = ricon
end

local Resurrect = function(self)
    res = CreateFrame('Frame', nil, self)
	res:SetSize(15, 15)
	res:SetPoint('CENTER', self)
	res:SetFrameStrata'HIGH'
    res:SetBackdrop(backdrop_1px)
    res:SetBackdropColor(.2, .6, 1)
    res.icon = res:CreateTexture(nil, 'OVERLAY')
	res.icon:SetTexture[[Interface\Icons\Spell_Holy_Resurrection]]
	res.icon:SetTexCoord(.1, .9, .1, .9)
    res.icon:SetAllPoints(res)
	self.ResurrectIcon = res
end

local PhanxResurrect = function(self)
	self.ResInfo = self.Health:CreateFontString(nil, "OVERLAY")
	self.ResInfo:SetPoint("CENTER")
end

local Healcomm = function(self)

	local mhpb = createStatusbar(self.Health, cfg.texture, nil, nil, self:GetWidth(), 0.33, 0.59, 0.33, 0.75)
	mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, -1)
	mhpb:SetHeight(self.Health:GetHeight()*0.5)
	mhpb:SetStatusBarColor(0, 1, 0, 0.33)

	local ohpb = createStatusbar(self.Health, cfg.texture, nil, nil, self:GetWidth(), 0.33, 0.59, 0.33, 0.75)
	ohpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 1)
	ohpb:SetHeight(self.Health:GetHeight()*0.5)
	ohpb:SetStatusBarColor(0, 1, 0, 0.25)

	self.HealPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1.25,
	}

	self.MyHealBar = mhpb
	self.OtherHealBar = ohpb

end

----------------------------------------------------------------------------------------
--	Sodified version of Rainrider's 'RainHealPrediction' (incl. absorbs + changed from status bars to textures)
----------------------------------------------------------------------------------------

local AddHealPredictionBar = function(self)
	local health = self.Health

	local absorb = health:CreateTexture(nil, "OVERLAY")
	absorb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT', 0, -1)
	absorb:SetVertexColor(0.41,	0.80, 0.94, 0.33)

	local mhpb = health:CreateTexture(nil, "OVERLAY")
	mhpb:SetTexture(cfg.texture)
	mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, -1)
	--mhpb:SetHeight(self.Health:GetHeight()*1.5)
	mhpb:SetVertexColor(0, 1, 0, 0.33)

	local ohpb = health:CreateTexture(nil, "OVERLAY")
	ohpb:SetTexture(cfg.texture)
	ohpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 1)
	--ohpb:SetHeight(self.Health:GetHeight()*0.5)
	ohpb:SetVertexColor(0, 1, 0, 0.33)

	local overAbsorb = health:CreateTexture(nil, "OVERLAY")

	self.RainHealPrediction = {
	myBar = mhpb,
	otherBar = ohpb,
	--absorbBar = absorb,
	--overAbsorbGlow = overAbsorb,
	maxOverflow = 1.33
	}
end

----------------------------------------------------------------------------------------
--	Raid Frames Layout
----------------------------------------------------------------------------------------

local raid_heal = function(self, unit)

    self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)

    self.framebd = framebd(self, self)		--extra Frame Backdrop...

    local h = createStatusbar(self, cfg.texMinimalist, nil, nil, nil, cfg.Color.Health.r, cfg.Color.Health.g, cfg.Color.Health.b, 1)
    h:SetPoint"TOP"
	h:SetPoint"LEFT"
	h:SetPoint"RIGHT"
	
	local hbg = h:CreateTexture(nil, "BACKGROUND")
    hbg:SetAllPoints(h)
    hbg:SetTexture(cfg.texture)

    h.frequentUpdates = true

	if cfg.class_colorbars then
        h.colorClass = true
        h.colorReaction = true
		hbg.multiplier = .2
	else
		hbg:SetVertexColor(.8, .8, .8, .15)
    end

	if cfg.Smooth then h.Smooth = true end
	
			
	h.bg = hbg
    self.Health = h

	h.PostUpdate = PostUpdateHealth

		oUF.colors.smooth = {1, 0, 0, 0.75, 0, 0, 0.3, 0.3, 0.3}
		self.Health.colorSmooth = true

    if not (unit == "targettarget" or unit == "pet" or unit == "focustarget") then
        local p = createStatusbar(self, cfg.texture, nil, nil, nil, 1, 1, 1, 1)
		p:SetPoint"LEFT"
		p:SetPoint"RIGHT"
        p:SetPoint("BOTTOM", h, 0, -(cfg.power_height+1))

        p.frequentUpdates = true

	    if cfg.Smooth then p.Smooth = true end

        local pbg = p:CreateTexture(nil, "BACKGROUND")
        pbg:SetAllPoints(p)
        pbg:SetTexture(cfg.texture)
        pbg.multiplier = .2

		if cfg.class_colorbars then
            p.colorPower = true
        else
            p.colorClass = true
        end

        p.bg = pbg
        self.Power = p
    end

	local l = h:CreateTexture(nil, "OVERLAY")
	if (unit == "raid") then
	    l:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", -1, -4)
        l:SetSize(10, 10)
	else
	    l:SetPoint("BOTTOMLEFT", h, "TOPLEFT", -2, -4)
        l:SetSize(16, 16)
	end
    self.Leader = l

    local ml = h:CreateTexture(nil, 'OVERLAY')
	    ml:SetPoint("LEFT", l, "RIGHT")
	if (unit == "raid") then
        ml:SetSize(10, 10)
    else
	    ml:SetSize(14, 14)
	end
    self.MasterLooter = ml

	local a = h:CreateTexture(nil, "OVERLAY")
	if (unit == "raid") then
	    a:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, -4)
        a:SetSize(10, 10)
	else
	    a:SetPoint("BOTTOMLEFT", h, "TOPLEFT", -2, -4)
        a:SetSize(16, 16)
	end

	local rc = h:CreateTexture(nil, "OVERLAY")
	rc:SetSize(14, 14)
	if (unit == "raid") then
	    rc:SetPoint("CENTER", self)
	else
        rc:SetPoint("CENTER", h)
	end
	self.ReadyCheck = rc

	RaidIcon(self)
	Highlight(self)

-- Arrows
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetAllPoints(self)
	frame:SetFrameStrata("HIGH")
	frame:SetScale(ns.RangeArrowScale)

	frame.arrow = frame:CreateTexture(nil, "OVERLAY")
	frame.arrow:SetTexture(cfg.arrow)
	frame.arrow:SetPoint("CENTER", frame, "CENTER", 0, -10)
	frame.arrow:SetSize(24, 24)

	self.freebarrow = frame
	self.freebarrow:Hide()

	self.freebRange = range

--DebuffHighlight
	self.DebuffHighlight = cfg.DebuffHighlight
	self.DebuffHighlightFilter = cfg.DebuffHighlightFilter

	self.Health:ClearAllPoints()
		self.Power:ClearAllPoints()

		self.Health:SetHeight(cfg.raid_health_height)
		self.Power:SetHeight(cfg.raid_power_height)

		self.Power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 1, 0)
		self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 0)

		self.Health:SetPoint('BOTTOMLEFT', self.Power, 1, cfg.raid_power_height+1)
		self.Health:SetPoint('BOTTOMRIGHT', self.Power, -1, cfg.raid_power_height+1)
		self.Health:SetHeight(cfg.raid_health_height/2)

		oUF.colors.smooth = {1, 0, 0, 0.75, 0, 0, 0.3, 0.3, 0.3}
		self.Health.colorSmooth = true
		self.Health.colorDisconnected = true

		self.DebuffHighlight = self.Health:CreateTexture(nil, 'OVERLAY')
		self.DebuffHighlight:SetAllPoints(self.Health)
		self.DebuffHighlight:SetTexture(cfg.highlightBorder)
		self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
		self.DebuffHighlight:SetBlendMode('ADD')
		self.DebuffHighlightAlpha = 1


		if class == "PRIEST" then

		-- Divine Aegis Shield Value
		--[[
			self.AuraStatusDA = fs(self.Health, "OVERLAY", cfg.font_Pixel8, cfg.pixelFontSize, cfg.fontflag, 1, 1, 1)
			self.AuraStatusDA:ClearAllPoints()
			self.AuraStatusDA:SetPoint("TOPRIGHT",-12, -2)
			self.AuraStatusDA.frequentUpdates = 0.1
			self.AuraStatusDA:SetAlpha(.6)
			self:Tag(self.AuraStatusDA, "[oUF_andawi:DA]")
		]]

		-- Spirit Shell Shield Value
			self.AuraStatusSS = fs(self.Health, "OVERLAY", cfg.font_Pixel8, cfg.pixelFontSize, cfg.fontflag, 1, 1, 1)
			self.AuraStatusSS:ClearAllPoints()
			self.AuraStatusSS:SetPoint("TOPRIGHT",-10, 0)
			self.AuraStatusSS.frequentUpdates = 0.1
			self.AuraStatusSS:SetAlpha(.6)
			self:Tag(self.AuraStatusSS, "[oUF_andawi:SS]")


		-- Clarity of Will
			self.AuraStatusCoW = fs(self.Health, "OVERLAY", cfg.font_Pixel8, cfg.pixelFontSize, cfg.fontflag, 1, 1, 1)
			self.AuraStatusCoW:ClearAllPoints()
			self.AuraStatusCoW:SetPoint("BOTTOMRIGHT", -10, 1)
			self.AuraStatusCoW.frequentUpdates = 0.1
			self.AuraStatusCoW:SetAlpha(.6)
			self:Tag(self.AuraStatusCoW, "[oUF_andawi:CoW]")

		-- Power Word Fortitude Indicator
			self.AuraStatusPWF = self.Health:CreateFontString(nil, "OVERLAY")
			self.AuraStatusPWF:SetPoint("BOTTOMRIGHT", -0, 1)
			self.AuraStatusPWF:SetJustifyH("RIGHT")
			self.AuraStatusPWF:SetFont(cfg.squares, 10, "OUTLINE")
			self:Tag(self.AuraStatusPWF, "[oUF_andawi:fort]")
			
			
			
			
		end

--debug
		local name = fs(self.Health, "OVERLAY", cfg.font_Pixel8, cfg.pixelFontSize)
		name:SetPoint("TOPLEFT", self.Health, 3, -3)
	    name:SetJustifyH"LEFT"
		name:SetShadowColor(0, 0, 0)
		name:SetShadowOffset(1, -1)
		if cfg.class_colorbars then
	        self:Tag(name, '[veryshort:name]')
		else
		    self:Tag(name, '[oUF_andawi:color][veryshort:name]')
		end
		name:SetAlpha(0.8)

        local htext = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint("RIGHT", self.Health, 0, -8)
		--htext.frequentUpdates = true
        self:Tag(htext, '[oUF_andawi:info]')

		local lfd = fs(self.Health, "OVERLAY", cfg.symbol, 8, "", 1, 1, 1)
		lfd:SetPoint("TOPLEFT", 30, -4)
	    self:Tag(lfd, '[oUF_andawi:LFD]')

		self.RaidIcon:SetSize(20, 20)
	    self.RaidIcon:SetPoint("TOP", self.Health, 2, 7)

		if cfg.healcomm then  AddHealPredictionBar(self) end

		--Resurrect(self)
		PhanxResurrect(self)
		createAuraWatch(self)

		local debuffs = CreateFrame("Frame", nil, self)
			debuffs:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 4, 3)
			debuffs:SetFrameStrata('HIGH')
			debuffs.initialAnchor = "RIGHT"
			debuffs["growth-x"] = "LEFT"
			debuffs:SetHeight(18)
			debuffs:SetWidth(5 * 20)
			debuffs.num = 5
			debuffs.spacing = 1
			debuffs.size = 18
			debuffs.CustomFilter = CustomDebuffFilter
			debuffs.PostCreateIcon = auraIcon
            debuffs.PostUpdateIcon = PostUpdateIcon
		self.Debuffs = debuffs

		local tborder = CreateFrame("Frame", nil, self)
        tborder:SetPoint("TOPLEFT", self, "TOPLEFT")
        tborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
        tborder:SetBackdrop(backdrop_1px)
        tborder:SetBackdropColor(.8, .8, .8, 1)
        tborder:SetFrameLevel(1)
        tborder:Hide()
        self.TargetBorder = tborder

		local fborder = CreateFrame("Frame", nil, self)
        fborder:SetPoint("TOPLEFT", self, "TOPLEFT")
        fborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
        fborder:SetBackdrop(backdrop_1px)
        fborder:SetBackdropColor(.6, .8, 0, 1)
        fborder:SetFrameLevel(1)
        fborder:Hide()
        self.FocusHighlight = fborder

		
	self.WeakenedSoulHighlight = cfg.WeakenedSoulHighlight
		
		
	self:RegisterEvent('GROUP_ROSTER_UPDATE', RaidSizeSwitcher)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	--debug
	--		self:RegisterEvent('PLAYER_TARGET_CHANGED', RaidSizeSwitcher)
	--
	self:RegisterEvent('RAID_ROSTER_UPDATE', ChangedTarget)


	self:SetScale(cfg.raidScale)
end



oUF:RegisterStyle("andawi - raid heal", raid_heal)
oUF:Factory(function(self)


    if cfg.disableRaidFrameManager then
	    CompactRaidFrameManager:UnregisterAllEvents()
        CompactRaidFrameManager:HookScript("OnShow", function(s) s:Hide() end)
        CompactRaidFrameManager:Hide()

        CompactRaidFrameContainer:UnregisterAllEvents()
        CompactRaidFrameContainer:HookScript("OnShow", function(s) s:Hide() end)
        CompactRaidFrameContainer:Hide()
    end

	if cfg.raid then

		self:SetActiveStyle'andawi - raid heal'

		raidgrp1 = oUF:SpawnHeader(nil, nil, "raid,party,solo",
		'oUF-initialConfigFunction', ([[self:SetWidth(%d) self:SetHeight(%d)]]):format(cfg.raid_width, cfg.raid_health_height+cfg.raid_power_height+1),
		'showPlayer', true,
		'showSolo', true,
		'showParty', false,
		'showRaid', true,
		'point', "LEFT",
		'xoffset', 5,
		'groupFilter', 1,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'MAINTANK,TANK,DAMAGER,NONE,HEALER',
		'sortMethod', 'NAME',
		'maxColumns', 1,
		'unitsPerColumn', 5)


		raidgrp2 = oUF:SpawnHeader(nil, nil, "raid",
		'oUF-initialConfigFunction', ([[self:SetWidth(%d) self:SetHeight(%d)]]):format(cfg.raid_width, cfg.raid_health_height+cfg.raid_power_height+1),
		'showPlayer', true,
		'showSolo', false,
		'showParty', false,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -15,
		'point', "LEFT",
		'groupFilter', 2,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'MAINTANK,TANK,DAMAGER,NONE,HEALER',
		'sortMethod', 'NAME',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "TOP")

		raidgrp3 = oUF:SpawnHeader(nil, nil, "raid",
		'oUF-initialConfigFunction', ([[self:SetWidth(%d) self:SetHeight(%d)]]):format(cfg.raid_width, cfg.raid_health_height+cfg.raid_power_height+1),
		'showPlayer', true,
		'showSolo', false,
		'showParty', false,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -15,
		'point', "LEFT",
		'groupFilter', 3,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'MAINTANK,TANK,DAMAGER,NONE,HEALER',
		'sortMethod', 'NAME',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "TOP")

		raidgrp4 = oUF:SpawnHeader(nil, nil, "raid",
		'oUF-initialConfigFunction', ([[self:SetWidth(%d) self:SetHeight(%d)]]):format(cfg.raid_width, cfg.raid_health_height+cfg.raid_power_height+1),
		'showPlayer', true,
		'showSolo', false,
		'showParty', false,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -15,
		'point', "LEFT",
		'groupFilter', 4,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'MAINTANK,TANK,DAMAGER,NONE,HEALER',
		'sortMethod', 'NAME',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "TOP")

		raidgrp5 = oUF:SpawnHeader(nil, nil, "raid",
		'oUF-initialConfigFunction', ([[self:SetWidth(%d) self:SetHeight(%d)]]):format(cfg.raid_width, cfg.raid_health_height+cfg.raid_power_height+1),
		'showPlayer', true,
		'showSolo', false,
		'showParty', false,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -15,
		'point', "LEFT",
		'groupFilter', 5,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'MAINTANK,TANK,DAMAGER,NONE,HEALER',
		'sortMethod', 'NAME',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "TOP")


		raidgrp6 = oUF:SpawnHeader(nil, nil, "raid",
		'oUF-initialConfigFunction', ([[self:SetWidth(%d) self:SetHeight(%d)]]):format(cfg.raid_width, cfg.raid_health_height+cfg.raid_power_height+1),
		'showPlayer', true,
		'showSolo', false,
		'showParty', false,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -15,
		'point', "LEFT",
		'groupFilter', 6,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'MAINTANK,TANK,DAMAGER,NONE,HEALER',
		'sortMethod', 'NAME',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "TOP")

		raidgrp7 = oUF:SpawnHeader(nil, nil, "raid",
		'oUF-initialConfigFunction', ([[self:SetWidth(%d) self:SetHeight(%d)]]):format(cfg.raid_width, cfg.raid_health_height+cfg.raid_power_height+1),
		'showPlayer', true,
		'showSolo', false,
		'showParty', false,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -15,
		'point', "LEFT",
		'groupFilter', 7,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'MAINTANK,TANK,DAMAGER,NONE,HEALER',
		'sortMethod', 'NAME',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "TOP")

		raidgrp8 = oUF:SpawnHeader(nil, nil, "raid",
		'oUF-initialConfigFunction', ([[self:SetWidth(%d) self:SetHeight(%d)]]):format(cfg.raid_width, cfg.raid_health_height+cfg.raid_power_height+1),
		'showPlayer', true,
		'showSolo', false,
		'showParty', false,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -15,
		'point', "LEFT",
		'groupFilter', 8,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'MAINTANK,TANK,DAMAGER,NONE,HEALER',
		'sortMethod', 'NAME',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "TOP")


		--else
		raidgrp1:SetPoint("CENTER", UIParent, "CENTER", cfg.unit_positions.Raid.x, cfg.unit_positions.Raid.y)
		raidgrp2:SetPoint('TOP', raidgrp1, 'BOTTOM', 0, -5)
		raidgrp3:SetPoint('TOP', raidgrp2, 'BOTTOM', 0, -5)
		raidgrp4:SetPoint('TOP', raidgrp3, 'BOTTOM', 0, -5)
		raidgrp5:SetPoint('TOP', raidgrp4, 'BOTTOM', 0, -5)
		raidgrp6:SetPoint('TOP', raidgrp5, 'BOTTOM', 0, -5)
		raidgrp7:SetPoint('TOP', raidgrp6, 'BOTTOM', 0, -5)
		raidgrp8:SetPoint('TOP', raidgrp7, 'BOTTOM', 0, -5)
	end
end)


local WatchDog = CreateFrame("Frame")
WatchDog:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
WatchDog:RegisterEvent('PLAYER_REGEN_DISABLED')
WatchDog:RegisterEvent('PLAYER_REGEN_ENABLED')
--WatchDog:RegisterEvent('GROUP_ROSTER_UPDATE')
--WatchDog:RegisterEvent("ADDON_LOADED")

WatchDog:SetScript("OnEvent", function(self, event)

	--print("WatchDog")
	if event=='ACTIVE_TALENT_GROUP_CHANGED' then
		local id, name, description, icon, background, role = GetSpecializationInfo(GetSpecialization())
		if role == 'HEALER' then
			print('oUF RAIDFRAMES enabled --> reload UI')
			--cfg.disableRaidFrameManager = true
			cfg.raid = true
		else
			print('oUF RAIDFRAMES disabled --> reload UI')
			--cfg.disableRaidFrameManager = false
			cfg.raid = false
		end
	elseif event=='GROUP_ROSTER_UPDATE' then
		print('WatchDog GROUP_ROSTER_UPDATE')

	end
end)
