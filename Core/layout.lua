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

local Highlight = function(self)
    self.Highlight = self:CreateTexture(nil, 'HIGHLIGHT')
	self.Highlight:SetAllPoints(self)
	self.Highlight:SetBlendMode('ADD')
	self.Highlight:SetTexture(cfg.highlightBorder)
	self.Highlight:SetVertexColor(1, 1, 1, 0.25)
end

local ChangedTarget = function(self)
    if UnitIsUnit('target', self.unit) then
        self.Highlight:Show()
    else
        self.Highlight:Hide()
    end
end

local FocusTarget = function(self)
    if UnitIsUnit('focus', self.unit) then
        self.FocusHighlight:Show()
    else
        self.FocusHighlight:Hide()
    end
end

--[[local RaidSizeSwitcher = function(self)

	if InCombatLockdown() then return end

	local difficulty = GetRaidDifficultyID()
	if difficulty == 3 or difficulty == 5 then -- 10 player
		raidgrp1:SetAttribute("showRaid", true)
		raidgrp2:SetAttribute("showRaid", true)
		raidgrp3:SetAttribute("showRaid", false)
		raidgrp4:SetAttribute("showRaid", false)
		raidgrp5:SetAttribute("showRaid", false)

		raidgrp1:SetScale(1)
		raidgrp2:SetScale(1)
		raidgrp3:SetScale(1)
		raidgrp4:SetScale(1)
		raidgrp5:SetScale(1)

	elseif difficulty == 4 or difficulty == 6  or difficulty == 7 then -- 25 player
		raidgrp1:SetAttribute("showRaid", true)
		raidgrp2:SetAttribute("showRaid", true)
		raidgrp3:SetAttribute("showRaid", true)
		raidgrp4:SetAttribute("showRaid", true)
		raidgrp5:SetAttribute("showRaid", true)

		raidgrp1:SetScale(0.9)
		raidgrp2:SetScale(0.9)
		raidgrp3:SetScale(0.9)
		raidgrp4:SetScale(0.9)
		raidgrp5:SetScale(0.9)
	end
end]]

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local FormatTime = function(s)
    if s >= day then
        return format("%dd", floor(s/day + 0.5))
    elseif s >= hour then
        return format("%dh", floor(s/hour + 0.5))
    elseif s >= minute then
        return format("%dm", floor(s/minute + 0.5))
    end

    return format("%d", fmod(s, minute))
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
			health:SetStatusBarColor(0,0,0,0.6)
		elseif(ghost) then
			health:SetStatusBarColor(1,1,1,0.3)
		elseif(dead) then
			health:SetStatusBarColor(1,0,0,0.8)
		end
	else
		health:SetValue(min)
		if(unit == 'vehicle') then
			health:SetStatusBarColor(22/255, 106/255, 44/255)
		end
	end



end


local PostUpdateIcon = function(self, unit, icon, index, offset)
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
		    icon.glow:SetBackdropBorderColor(r,g,b,1)
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

local PostAltUpdate = function(self, min, cur, max)
    local per = math.floor((cur/max)*100)
	if per < 30 then
		self:SetStatusBarColor(0, 1, 0)
	elseif per < 60 then
		self:SetStatusBarColor(1, 1, 0)
	else
		self:SetStatusBarColor(1, 0, 0)
	end
end

local UpdateComboPoint = function(self, event, unit)
	if(unit == 'pet') then return end
	local cpoints = self.CPoints
	local cp
	if (UnitHasVehicleUI("player") or UnitHasVehicleUI("vehicle")) then
		cp = GetComboPoints('vehicle', 'target')
	else
		cp = GetComboPoints('player', 'target')
	end

	for i=1, 5 do
		if(i <= cp) then
			cpoints[i]:SetAlpha(1)
		else
			cpoints[i]:SetAlpha(0.2)
		end
	end

	if UnitExists("target") and UnitCanAttack("player", "target") and (not UnitIsDead("target")) then
		for i=1, 5 do
			cpoints:Show()
		end

	else
		for i=1, 5 do
			cpoints:Hide()
		end

	end
end

local AWIcon = function(AWatch, icon, spellID, name, self)			--AuraWatch

	if icon.Class then
		local classcolor = RAID_CLASS_COLORS[icon.Class]
		local r,g,b = classcolor.r,classcolor.g,classcolor.b
		--print(icon.Class)
		--print(r, g, b)
	end

	icon:SetBackdrop(backdrop_1px)

	if spellID == 6788 then
		icon:SetBackdropColor(1,0,0,0.75)
	else
		icon:SetBackdropColor(0,0,0,0.85)
	end

	icon.cd:SetReverse(true)

end

local CustomDebuffFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster)

	if not cfg.debuffFilter[name] then
		return true		-- true = visible
	end

end

local createAuraWatch = function(self, unit)
	if cfg.showAuraWatch then

		local auras = CreateFrame("Frame", nil, self)
		auras:SetAllPoints(self.Health)
		auras.onlyShowPresent = true
		auras.icons = {}
		auras.hideCooldown = true			-- org. AuraWatch cd frame will overlap each other - thus create own frame for this
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

				icon.hideCooldown = true		-- org. AuraWatch cd frame will overlap each other - thus create own frame for this

				local cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
				cd:SetAllPoints(icon)
				cd:SetFrameLevel(i)
				icon.cd = cd

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

--**************
-- add modified version of Rainrider's 'RainHealPrediction' (incl. absorbs + changed from status bars to textures)
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
	maxOverflow = 1.25
	}
end




--**************


local Setfocus = function(self)
	local ModKey = 'Shift'
    local MouseButton = 1
    local key = ModKey .. '-type' .. (MouseButton or '')
	if(self.unit == 'focus') then
	    self:SetAttribute(key, 'macro')
		self:SetAttribute('macrotext', '/clearfocus')
	else
		self:SetAttribute(key, 'focus')
    end
end

local Portraits = function(self)
    self.Portrait = CreateFrame("PlayerModel", nil, self)
	self.Portrait:SetAllPoints(self.Health)
	self.Portrait:SetAlpha(0.2)
	self.Portrait:SetFrameLevel(self.Health:GetFrameLevel())
end

local Shared = function(self, unit)

    self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)

    self.framebd = framebd(self, self)		--extra Frame Backdrop...

    local h = createStatusbar(self, cfg.texture, nil, nil, nil, cfg.Color.Health.r, cfg.Color.Health.g, cfg.Color.Health.b, 1)
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
		hbg:SetVertexColor(.5, .5, .5, .25)
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
	Setfocus(self)

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

	self.WeakenedSoulHighlight = cfg.WeakenedSoulHighlight
	
	self:SetScale(cfg.scale)
end

local UnitSpecific = {
    player = function(self, ...)
        Shared(self, ...)


		--oUF_Fader plugin
		self.FadeCasting = true
		self.FadeCombat = true
		self.FadeTarget = true
		self.FadeHealth = true
		self.FadePower = false
		self.FadeHover = true
		self.FadeSmooth = 0.25
		self.FadeMinAlpha = 0
		self.FadeMaxAlpha = 1.0
		--end



		self:SetSize(cfg.width, cfg.health_height+cfg.power_height+1)
		self.Health:SetHeight(cfg.health_height)
		self.Power:SetHeight(cfg.power_height)
		self.unit = "player"

		if cfg.portraits then Portraits(self) end

	    if cfg.healcomm then Healcomm(self) end

		local name = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint("TOPLEFT", self.Health, 0, 6)
        name:SetJustifyH"LEFT"

		if cfg.class_colorbars then
		    self:Tag(name, '[oUF_andawi:lvl] [long:name]')
		else
		    self:Tag(name, '[oUF_andawi:lvl] [oUF_andawi:color][long:name]')
		end

		--[[local htext = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint("RIGHT", self.Health, -2, -13)
		htext.frequentUpdates = .1
        self:Tag(htext, '[oUF_andawi:hp][oUF_andawi:pp]')
		]]
		self.RaidIcon:SetSize(23, 23)
	    self.RaidIcon:SetPoint("TOP", self.Health, 0, 11)


		if cfg.auras then
            local d = CreateFrame("Frame", nil, self)
			d.size = 24
			d.spacing = 4
		    d.num = cfg.target_debuffs_num
            d:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 1, 8)
			d:SetSize(cfg.width, d.size)
            d.initialAnchor = "TOPRIGHT"
            d["growth-x"] = "LEFT"
			d["growth-y"] = "UP"
            d.onlyShowPlayer = false
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            d.CustomFilter = CustomFilter
            self.Debuffs = d
        end

		local ct = self.Health:CreateTexture(nil, 'OVERLAY')
        ct:SetSize(20, 20)
        ct:SetPoint('CENTER', self.Health)
        self.Combat = ct

		local r = fs(self.Health, "OVERLAY", cfg.symbol, 15, "OUTLINE", 1, 1, 1)
	    r:SetPoint("BOTTOMLEFT", 0, -10)
	    r:SetText("|cff5F9BFFR|r")
	    self.Resting = r

		--[[local PvP = self.Health:CreateTexture(nil, 'OVERLAY')
        PvP:SetSize(28, 28)
        PvP:SetPoint('BOTTOMLEFT', self.Health, 'TOPRIGHT', -15, -20)
        self.PvP = PvP]]

        if cfg.specific_power then
		    if (class == "PALADIN" or class == "MONK") then
                local c
                if class == "PALADIN" then
	                local numMax = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
					c = numMax
                elseif class == "MONK" then
	                local numMax = UnitPowerMax("player", SPELL_POWER_LIGHT_FORCE)
					c = numMax
                end

                local b = CreateFrame("Frame", nil, self)
				b:SetFrameStrata("LOW")
                b:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
                b:SetSize(cfg.width, cfg.specific_power_height)
				b.bd = framebd(b, b)

                local i = c
                for index = 1, c do
                    b[i] = createStatusbar(b, cfg.texture, nil, cfg.specific_power_height, (cfg.width+1)/c-1, 1, 1, 1, 1)

				    if i == c then
                        b[i]:SetPoint("RIGHT", b)
                    else
                        b[i]:SetPoint("RIGHT", b[i+1], "LEFT", -1, 0)
                    end

                    if class == "PALADIN" then
                        local color = self.colors.power["HOLY_POWER"]
                        b[i]:SetStatusBarColor(color[1], color[2], color[3])
				    elseif class == "MONK" then
				        local color = self.colors.power["LIGHT_FORCE"]
                        b[i]:SetStatusBarColor(color[1], color[2], color[3])
                    end

                    b[i].bg = b[i]:CreateTexture(nil, "BACKGROUND")
                    b[i].bg:SetAllPoints(b[i])
                    b[i].bg:SetTexture(cfg.texture)
                    b[i].bg.multiplier = .2

                    i=i-1
                end

            end

			if class == "PRIEST" then
			    sob = CreateFrame("Frame", self:GetName().."_ShadowOrbsBar", self)
				sob:SetFrameStrata("LOW")
			    sob:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
			    sob:SetSize(cfg.width, cfg.specific_power_height)
			    sob.bd = framebd(sob, sob)

			    for i = 1, 3 do
				    sob[i] = createStatusbar(sob, cfg.texture, nil, cfg.specific_power_height, (cfg.width+1)/3-1, 0.70, 0.32, 0.75, 1)
				    if i == 1 then
					    sob[i]:SetPoint("LEFT", sob, "LEFT")
				    else
					    sob[i]:SetPoint("LEFT", sob[i-1], "RIGHT", 1, 0)
				    end

				    sob[i].bg = sob[i]:CreateTexture(nil, "BORDER")
                    sob[i].bg:SetAllPoints(sob[i])
                    sob[i].bg:SetTexture(cfg.texture)
                    sob[i].bg.multiplier = .2

				   self.ShadowOrbsBar = sob
			    end
		    end

            if class == "DRUID" then
                local ebar = CreateFrame("Frame", nil, self)
				ebar:SetFrameStrata("LOW")
                ebar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
                ebar:SetSize(cfg.width, cfg.specific_power_height)
				ebar.bd = framebd(ebar, ebar)

                local lbar = createStatusbar(ebar, cfg.texture, nil, cfg.specific_power_height, cfg.width, 0, .4, 1, 1)
                lbar:SetPoint("LEFT", ebar, "LEFT")
                ebar.LunarBar = lbar

                local sbar = createStatusbar(ebar, cfg.texture, nil, cfg.specific_power_height, cfg.width, 1, .6, 0, 1)
                sbar:SetPoint("LEFT", lbar:GetStatusBarTexture(), "RIGHT")
                ebar.SolarBar = sbar

                ebar.Spark = sbar:CreateTexture(nil, "OVERLAY")
                ebar.Spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
                ebar.Spark:SetBlendMode("ADD")
                ebar.Spark:SetAlpha(0.5)
                ebar.Spark:SetHeight(26)
                ebar.Spark:SetPoint("LEFT", sbar:GetStatusBarTexture(), "LEFT", -15, 0)

				ebar.Text = fs(ebar.SolarBar, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 0.8, 0.8, 0.8)
                ebar.Text:SetPoint("CENTER", ebar)
                self:Tag(ebar.Text, "[oUF_andawi:EclipseDirection]")

				self.EclipseBar = ebar
            end

		end

		if class == "DRUID" and cfg.DruidMana then
		    local color = self.colors.power["MANA"]
		    local DruidMana = createStatusbar(self, cfg.texture, nil, cfg.specific_power_height, cfg.width, color[1], color[2], color[3], 1)
			DruidMana:SetFrameStrata("LOW")
            DruidMana:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
		    DruidMana.bd = framebd(DruidMana, DruidMana)

            local bg = DruidMana:CreateTexture(nil, 'BACKGROUND')
            bg:SetAllPoints(DruidMana)
            bg.multiplier = 0.2

            self.DruidMana = DruidMana
            self.DruidMana.bg = bg
		end

		if cfg.AltPowerBar then
	       local altp = createStatusbar(self, cfg.texture, nil, cfg.AltPowerBar_Height, cfg.AltPowerBar_Width, 1, 1, 1, 1)
           altp:SetPoint(unpack(cfg.AltPowerBar_pos))
           altp.bg = altp:CreateTexture(nil, 'BORDER')
           altp.bg:SetAllPoints(altp)
           altp.bg:SetTexture(cfg.texture)
           altp.bg:SetVertexColor(1, 0, 0, 0.2)
           altp.bd = framebd(altp, altp)
           altp.Text = fs(altp, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 0.8, 0.8, 0.8)
           altp.Text:SetPoint("CENTER")
           self:Tag(altp.Text, "[oUF_andawi:altpower]")
           altp.PostUpdate = PostAltUpdate
           self.AltPowerBar = altp
	    end
    end,

-- TARGET LAYOUT

    target = function(self, ...)

		Shared(self, ...)

		self:SetSize(cfg.width, cfg.health_height+cfg.power_height+1)
		self.Health:SetHeight(cfg.health_height)
		self.Power:SetHeight(cfg.power_height)
		self.unit = "target"

		if cfg.portraits then Portraits(self) end

		local name = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint("TOPLEFT", self.Health, 0, 6)
        name:SetJustifyH"LEFT"

		if cfg.class_colorbars then
		    self:Tag(name, '[oUF_andawi:lvl] [long:name]')
		else
		    self:Tag(name, '[oUF_andawi:lvl] [oUF_andawi:color][long:name]')
		end

		local htext = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint("BOTTOMRIGHT", self.Health, -2, -15)
		htext.frequentUpdates = .1
        self:Tag(htext, '[oUF_andawi:hp][oUF_andawi:pp]')

		self.RaidIcon:SetSize(23, 23)
	    self.RaidIcon:SetPoint("TOP", self.Health, 0, 11)

		if cfg.auras then
            local b = CreateFrame("Frame", nil, self)
			b.size = 24
			b.spacing = 4
		    b.num = cfg.target_buffs_num
            b:SetSize(b.size*4+b.spacing*3, b.size)
		    b:SetPoint("TOPLEFT", self, "TOPRIGHT", 50, 25)
            b.initialAnchor = "TOPLEFT"
            b["growth-y"] = "DOWN"
            b.PostCreateIcon = auraIcon
            b.PostUpdateIcon = PostUpdateIcon
            self.Buffs = b

            local d = CreateFrame("Frame", nil, self)
			d.size = 24
			d.spacing = 4
		    d.num = cfg.target_debuffs_num
            d:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 1, 8)
			d:SetSize(cfg.width, d.size)
            d.initialAnchor = "TOPRIGHT"
            d["growth-x"] = "LEFT"
			d["growth-y"] = "UP"
            d.onlyShowPlayer = cfg.onlyShowPlayer
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            d.CustomFilter = CustomFilter
            self.Debuffs = d
        end

		if cfg.specific_power then
		    if class == "DRUID" or class == "ROGUE" then
		        local cp = CreateFrame("Frame", nil, self)
		        local c = 5
		        local color = self.colors.class[class]
                cp:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
                cp:SetSize(cfg.width, cfg.specific_power_height)
			    cp.bd = framebd(cp, cp)
		        local i = c
                for index = 1, c do
                    cp[i] = createStatusbar(cp, cfg.texture, nil, cfg.specific_power_height, (cfg.width+1)/c-1, color[1], color[2], color[3], 1)

                    if i == c then
                        cp[i]:SetPoint("RIGHT", cp)
                    else
                        cp[i]:SetPoint("RIGHT", cp[i+1], "LEFT", -1, 0)
                    end

                    cp[i].bg = cp[i]:CreateTexture(nil, "BACKGROUND")
                    cp[i].bg:SetAllPoints(cp[i])
                    cp[i].bg:SetTexture(cfg.texture)
                    cp[i].bg.multiplier = .2

                    i=i-1
                end

		        self.CPoints = cp
		        self.CPoints.Override = UpdateComboPoint
			end
		end

		local q = fs(self.Health, "OVERLAY", cfg.font, 22, cfg.fontflag, 1, 1, 1)
	    q:SetPoint('TOP', self.Health,'RIGHT', -5, -7)
	    q:SetText("|cff8AFF30!|r")
	    self.QuestIcon = q

        local ph = self.Health:CreateTexture(nil, 'OVERLAY')
        ph:SetSize(24, 24)
        ph:SetPoint('CENTER', self.Health, 'BOTTOMLEFT', 3, -3)
        self.PhaseIcon = ph

		--[[local PvP = self.Health:CreateTexture(nil, 'OVERLAY')
        PvP:SetSize(28, 28)
        PvP:SetPoint('BOTTOMLEFT', self.Health, 'TOPRIGHT', -15, -20)
        self.PvP = PvP]]

    -- Clarity of Will
    self.AuraStatusCoW = fs(self.Health, "OVERLAY", cfg.font_Pixel8, cfg.pixelFontSize, cfg.fontflag, 1, 1, 1)
    self.AuraStatusCoW:ClearAllPoints()
    self.AuraStatusCoW:SetPoint("BOTTOMRIGHT", -10, 1)
    self.AuraStatusCoW.frequentUpdates = 0.1
    self.AuraStatusCoW:SetAlpha(.6)
    self:Tag(self.AuraStatusCoW, "[oUF_andawi:CoW]")

    end,

    focus = function(self, ...)
        Shared(self, ...)

		self:SetSize(cfg.width, cfg.health_height+cfg.power_height+1)
		self.Health:SetHeight(cfg.health_height)
		self.Power:SetHeight(cfg.power_height)
		self.unit = "focus"

		if cfg.healcomm then Healcomm(self) end

		local name = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint("LEFT", self.Health, 4, 0)
        name:SetJustifyH"LEFT"
		if cfg.class_colorbars then
		    self:Tag(name, '[oUF_andawi:lvl] [long:name]')
		else
		    self:Tag(name, '[oUF_andawi:lvl] [oUF_andawi:color][long:name]')
		end

		local htext = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint("RIGHT", self.Health, -2, 5)
		htext.frequentUpdates = .1
        self:Tag(htext, '[oUF_andawi:hp][oUF_andawi:pp]')

		self.RaidIcon:SetSize(23, 23)
	    self.RaidIcon:SetPoint("TOP", self.Health, 0, 11)

      -- Clarity of Will
      self.AuraStatusCoW = fs(self.Health, "OVERLAY", cfg.font_Pixel8, cfg.pixelFontSize, cfg.fontflag, 1, 1, 1)
      self.AuraStatusCoW:ClearAllPoints()
      self.AuraStatusCoW:SetPoint("BOTTOMRIGHT", -10, 1)
      self.AuraStatusCoW.frequentUpdates = 0.1
      self.AuraStatusCoW:SetAlpha(.6)
      self:Tag(self.AuraStatusCoW, "[oUF_andawi:CoW]")


      if cfg.auras then
        local b = CreateFrame("Frame", nil, self)
        b.size = 24
        b.spacing = 4
        b.num = cfg.target_buffs_num
        b:SetSize(b.size*4+b.spacing*3, b.size)
        b:SetPoint("TOPLEFT", self, "TOPRIGHT", 50, 25)
        b.initialAnchor = "TOPLEFT"
        b["growth-y"] = "DOWN"
        b.PostCreateIcon = auraIcon
        b.PostUpdateIcon = PostUpdateIcon
        b.onlyShowPlayer = true
        self.Buffs = b

        local d = CreateFrame("Frame", nil, self)
        d.size = 24
        d.spacing = 4
        d.num = cfg.target_debuffs_num
        d:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 1, 8)
        d:SetSize(cfg.width, d.size)
        d.initialAnchor = "TOPRIGHT"
        d["growth-x"] = "LEFT"
        d["growth-y"] = "UP"
        d.onlyShowPlayer = cfg.onlyShowPlayer
        d.PostCreateIcon = auraIcon
        d.PostUpdateIcon = PostUpdateIcon
        d.CustomFilter = CustomFilter
        self.Debuffs = d
      end
    end,

    pet = function(self, ...)
        Shared(self, ...)

		self:SetSize(cfg.pet_width, cfg.pet_height)

		local name = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint("CENTER", self.Health)
		if cfg.class_colorbars then
		    self:Tag(name, '[short:name]')
		else
		    self:Tag(name, '[oUF_andawi:color][short:name]')
		end

		self.RaidIcon:SetSize(20, 20)
	    self.RaidIcon:SetPoint("TOP", self.Health, 0, 10)

        if cfg.auras then
            local d = CreateFrame("Frame", nil, self)
			d.size = 24
			d.spacing = 4
			d.num = 3
            d:SetSize(d.num*d.size+d.spacing*(d.num-1), d.size)
            d:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 0)
            d.initialAnchor = "TOPRIGHT"
			d["growth-x"] = "LEFT"
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            self.Debuffs = d
        end
    end,

    targettarget = function(self, ...)
	    Shared(self, ...)

	    self:SetSize(cfg.pet_width, cfg.pet_height)

		local name = fs(self.Health, "OVERLAY", cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint("CENTER", self.Health)
		if cfg.class_colorbars then
		    self:Tag(name, '[short:name]')
		else
		    self:Tag(name, '[oUF_andawi:color][short:name]')
		end

		self.RaidIcon:SetSize(20, 20)
	    self.RaidIcon:SetPoint("TOP", self.Health, 0, 10)

		if cfg.healcomm then  AddHealPredictionBar(self) end

--[[
        if cfg.auras then
            local d = CreateFrame("Frame", nil, self)
			d.size = 24
			d.spacing = 4
			d.num = 3
            d:SetSize(d.num*d.size+d.spacing*(d.num-1), d.size)
            d:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 0)
            d.initialAnchor = "TOPLEFT"
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            self.Debuffs = d
        end
]]
    end
}

UnitSpecific.focustarget = UnitSpecific.pet

oUF:RegisterStyle("oUF_andawi", Shared)

for unit,layout in next, UnitSpecific do
    oUF:RegisterStyle('andawi - ' .. unit:gsub("^%l", string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
    if(UnitSpecific[unit]) then
        self:SetActiveStyle('andawi - ' .. unit:gsub("^%l", string.upper))
    elseif(UnitSpecific[unit:match('[^%d]+')]) then
        self:SetActiveStyle('andawi - ' .. unit:match('[^%d]+'):gsub("^%l", string.upper))
    else
        self:SetActiveStyle'andawi'
    end

    local object = self:Spawn(unit)
    object:SetPoint(...)
    return object
end



oUF:Factory(function(self)

    spawnHelper(self, "player", "CENTER", cfg.unit_positions.Player.x, cfg.unit_positions.Player.y)
    spawnHelper(self, "target", "CENTER", cfg.unit_positions.Target.x, cfg.unit_positions.Target.y)
    spawnHelper(self, "targettarget", "RIGHT", "oUF_andawiTarget", cfg.unit_positions.Targettarget.x, cfg.unit_positions.Targettarget.y)
    spawnHelper(self, "focus", "CENTER", cfg.unit_positions.Focus.x, cfg.unit_positions.Focus.y)
    --spawnHelper(self, "focustarget", "LEFT", "oUF_andawiFocus", cfg.unit_positions.Focustarget.x, cfg.unit_positions.Focustarget.y)
    spawnHelper(self, "pet", "LEFT", "oUF_andawiPlayer", cfg.unit_positions.Pet.x, cfg.unit_positions.Pet.y)
print ('spawn done')

end)
