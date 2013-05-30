----------------------------------------------------------------------------------------
--    Panel / Template functions (by ShestakUI)
----------------------------------------------------------------------------------------

local name, ns = ...
local cfg = ns.cfg
local _, class = UnitClass('player')

local oUF = oUF

cfg.blank = 			"Interface\\AddOns\\ShestakUI\\Media\\Textures\\White.tga"			-- Texture for borders
cfg.backdrop_color = 		{0, 0, 0, 1}													-- Color for borders backdrop
cfg.border_color = 		{0.37, 0.3, 0.3, 1}												-- Color for borders
cfg.height =			100

local backdropr, backdropg, backdropb, backdropa = unpack(cfg.backdrop_color)
local borderr, borderg, borderb, bordera = unpack(cfg.border_color)

local function GetTemplate(t)
	if t == "ClassColor" then
		local c = oUF.colors.class[class]
		borderr, borderg, borderb = c[1], c[2], c[3]
		
		backdropr, backdropg, backdropb, backdropa = unpack(cfg.backdrop_color)
	else
		borderr, borderg, borderb, bordera = unpack(cfg.border_color)
		backdropr, backdropg, backdropb, backdropa = unpack(cfg.backdrop_color)
	end
end

local CreatePanel = function (parent, t, w, h, a1, p, a2, x, y)
	
	local f = CreateFrame("Frame")
	GetTemplate(t)

	f:SetWidth(w)
	f:SetHeight(h)
	f:SetFrameLevel(1)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = cfg.blank, edgeFile = cfg.blank, edgeSize = 1,
		insets = {left = -1, right = -1, top = -1, bottom = -1}
	})

	backdropa = cfg.backdrop_color[4]

	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	print(backdropr)
	f:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
	print(borderr)
	return f
end


----------------------------------------------------------------------------------------
-- Player line
----------------------------------------------------------------------------------------
local HorizontalPlayerLine = CreatePanel(UIParent, "ClassColor", 228, 1, "TOPLEFT", UIParent, "CENTER", -430, -22)
local VerticalPlayerLine = CreatePanel(HorizontalPlayerLine, "ClassColor", 1, 98, "RIGHT", HorizontalPlayerLine, "LEFT", 0, 13)

----------------------------------------------------------------------------------------
-- Target line
----------------------------------------------------------------------------------------
local HorizontalTargetLine = CreatePanel(UIParent, "ClassColor", 228, 1, "TOPRIGHT", UIParent, "CENTER", 430, -22)
HorizontalTargetLine:RegisterEvent("PLAYER_TARGET_CHANGED")
HorizontalTargetLine:Hide()
HorizontalTargetLine:SetScript("OnEvent", function(self)

if UnitExists('target') then 
	HorizontalTargetLine:Show()
	local _, class = UnitClass("target")
	local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
	if color then
	self:SetBackdropBorderColor(color.r, color.g, color.b)
	else
	self:SetBackdropBorderColor(unpack(cfg.border_color))
	end
else
	HorizontalTargetLine:Hide()
end
end)

local VerticalTargetLine = CreatePanel(HorizontalTargetLine, "ClassColor", 1, 98, "LEFT", HorizontalTargetLine, "RIGHT", 0, 13)
VerticalTargetLine:RegisterEvent("PLAYER_TARGET_CHANGED")
VerticalTargetLine:Hide()
VerticalTargetLine:SetScript("OnEvent", function(self)

if UnitExists('target') then 
	VerticalTargetLine:Show()
	local _, class = UnitClass("target")
	local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
	if color then
	self:SetBackdropBorderColor(color.r, color.g, color.b)
	else
	self:SetBackdropBorderColor(unpack(cfg.border_color))
	end
else
	VerticalTargetLine:Hide()
end
end)

----------------------------------------------------------------------------------------
-- UI Bottom line
----------------------------------------------------------------------------------------
local bottompanel = CreatePanel(UIParent, "ClassColor", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 12)
bottompanel:SetPoint("LEFT", UIParent, "LEFT", 12, 0)
bottompanel:SetPoint("RIGHT", UIParent, "RIGHT", -12, 0)

----------------------------------------------------------------------------------------
-- UI Left line
----------------------------------------------------------------------------------------
local leftpanel = CreatePanel(bottompanel, "ClassColor", 1, cfg.height - 2, "BOTTOMLEFT", bottompanel, "LEFT", 0, 0)
