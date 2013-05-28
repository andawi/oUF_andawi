----------------------------------------------------------------------------------------
--    Template functions (by ShestakUI)
----------------------------------------------------------------------------------------

local name, ns = ...
local cfg = ns.cfg
local _, class = UnitClass('player')

local oUF = ns.oUF

cfg.media.blank = 			"Interface\AddOns\ShestakUI\Media\Textures\White.tga"			-- Texture for borders
cfg.media.backdrop_color = 		{0, 0, 0, 1}													-- Color for borders backdrop
cfg.media.border_color = 		{0.37, 0.3, 0.3, 1}												-- Color for borders
cfg.media.overlay_color =		{0, 0, 0, 0.7}
cfg.chat.height =			112

local backdropr, backdropg, backdropb, backdropa = unpack(cfg.media.backdrop_color)
local borderr, borderg, borderb, bordera = unpack(cfg.media.border_color)


--PixelPerfect stuff
--768 / string.match(GetCVar("gxResolution"), "%d+x(%d+)") / GetCVar("uiScale")
local mult = GetCVar("uiScale")



local function CreateOverlay(f)
  if f.overlay then return end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER", f)
	overlay:SetPoint("TOPLEFT", 2, -2)
	overlay:SetPoint("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(cfg.media.blank)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", "$parentInnerBorder", f)
		border:SetPoint("TOPLEFT", mult, -mult)
		border:SetPoint("BOTTOMRIGHT", -mult, mult)
		border:SetBackdrop({
			edgeFile = cfg.media.blank, edgeSize = mult,
			insets = {left = mult, right = mult, top = mult, bottom = mult}
		})
		border:SetBackdropBorderColor(unpack(cfg.media.backdrop_color))
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", "$parentOuterBorder", f)
		border:SetPoint("TOPLEFT", -mult, mult)
		border:SetPoint("BOTTOMRIGHT", mult, -mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = cfg.media.blank, edgeSize = mult,
			insets = {left = mult, right = mult, top = mult, bottom = mult}
		})
		border:SetBackdropBorderColor(unpack(cfg.media.backdrop_color))
		f.oborder = border
	end
end

local function GetTemplate(t)
	if t == "ClassColor" then
		local c = oUF_colors.class[class]
		borderr, borderg, borderb, bordera = c[1], c[2], c[3], c[4]
		backdropr, backdropg, backdropb, backdropa = unpack(cfg.media.backdrop_color)
	else
		borderr, borderg, borderb, bordera = unpack(cfg.media.border_color)
		backdropr, backdropg, backdropb, backdropa = unpack(cfg.media.backdrop_color)
	end
end

local function SetTemplate(f, t)
	GetTemplate(t)

	f:SetBackdrop({
		bgFile = cfg.media.blank, edgeFile = cfg.media.blank, edgeSize = mult,
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult}
	})

	if t == "Transparent" then
		backdropa = cfg.media.overlay_color[4]
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	else
		backdropa = cfg.media.backdrop_color[4]
	end

	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end


local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	GetTemplate(t)

	f:SetWidth(w)
	f:SetHeight(h)
	f:SetFrameLevel(1)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = cfg.media.blank, edgeFile = cfg.media.blank, edgeSize = mult,
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult}
	})

	if t == "Transparent" then
		backdropa = cfg.media.overlay_color[4]
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	elseif t == "Invisible" then
		backdropa = 0
		bordera = 0
	else
		backdropa = cfg.media.backdrop_color[4]
	end

	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end


----------------------------------------------------------------------------------------
-- Player line
----------------------------------------------------------------------------------------
local HorizontalPlayerLine = CreateFrame("Frame", "HorizontalPlayerLine", oUF_Player)
HorizontalPlayerLine:CreatePanel("ClassColor", 228, 1, "TOPLEFT", "oUF_Player", "BOTTOMLEFT", -5, -5)

local VerticalPlayerLine = CreateFrame("Frame", "VerticalPlayerLine", oUF_Player)
VerticalPlayerLine:CreatePanel("ClassColor", 1, 98, "RIGHT", HorizontalPlayerLine, "LEFT", 0, 13)

----------------------------------------------------------------------------------------
-- Target line
----------------------------------------------------------------------------------------
local HorizontalTargetLine = CreateFrame("Frame", "HorizontalTargetLine", oUF_Target)
HorizontalTargetLine:CreatePanel("ClassColor", 228, 1, "TOPRIGHT", "oUF_Target", "BOTTOMRIGHT", 5, -5)
HorizontalTargetLine:RegisterEvent("PLAYER_TARGET_CHANGED")
HorizontalTargetLine:SetScript("OnEvent", function(self)
local _, class = UnitClass("target")
local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
if color then
self:SetBackdropBorderColor(color.r, color.g, color.b)
else
self:SetBackdropBorderColor(unpack(C.media.border_color))
end
end)

local VerticalTargetLine = CreateFrame("Frame", "VerticalTargetLine", oUF_Target)
VerticalTargetLine:CreatePanel("ClassColor", 1, 98, "LEFT", HorizontalTargetLine, "RIGHT", 0, 13)
VerticalTargetLine:RegisterEvent("PLAYER_TARGET_CHANGED")
VerticalTargetLine:SetScript("OnEvent", function(self)
local _, class = UnitClass("target")
local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
if color then
self:SetBackdropBorderColor(color.r, color.g, color.b)
else
self:SetBackdropBorderColor(unpack(C.media.border_color))
end
end)

----------------------------------------------------------------------------------------
-- Bottom line
----------------------------------------------------------------------------------------
local bottompanel = CreateFrame("Frame", "BottomPanel", UIParent)
bottompanel:CreatePanel("ClassColor", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 20)
bottompanel:SetPoint("LEFT", UIParent, "LEFT", 21, 0)
bottompanel:SetPoint("RIGHT", UIParent, "RIGHT", -21, 0)

----------------------------------------------------------------------------------------
-- Left line
----------------------------------------------------------------------------------------
local leftpanel = CreateFrame("Frame", "LeftPanel", UIParent)
leftpanel:CreatePanel("ClassColor", 1, cfg.chat.height - 2, "BOTTOMLEFT", bottompanel, "LEFT", 0, 0)
