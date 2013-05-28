
----------------------------------------------------------------------------------------
--    Template functions (by ShestakUI)
----------------------------------------------------------------------------------------

--PixelPerfect stuff
--768 / string.match(GetCVar("gxResolution"), "%d+x(%d+)") / GetCVar("uiScale")
local mult = GetCVar("uiScale")



local function CreateOverlay(f)
  if f.overlay then return end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER", f)
	overlay:SetPoint("TOPLEFT", 2, -2)
	overlay:SetPoint("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(C.media.blank)
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
			edgeFile = C.media.blank, edgeSize = mult,
			insets = {left = mult, right = mult, top = mult, bottom = mult}
		})
		border:SetBackdropBorderColor(unpack(C.media.backdrop_color))
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", "$parentOuterBorder", f)
		border:SetPoint("TOPLEFT", -mult, mult)
		border:SetPoint("BOTTOMRIGHT", mult, -mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = C.media.blank, edgeSize = mult,
			insets = {left = mult, right = mult, top = mult, bottom = mult}
		})
		border:SetBackdropBorderColor(unpack(C.media.backdrop_color))
		f.oborder = border
	end
end

local function GetTemplate(t)
	if t == "ClassColor" then
		local c = T.oUF_colors.class[T.class]
		borderr, borderg, borderb, bordera = c[1], c[2], c[3], c[4]
		backdropr, backdropg, backdropb, backdropa = unpack(C.media.backdrop_color)
	else
		borderr, borderg, borderb, bordera = unpack(C.media.border_color)
		backdropr, backdropg, backdropb, backdropa = unpack(C.media.backdrop_color)
	end
end

local function SetTemplate(f, t)
	GetTemplate(t)

	f:SetBackdrop({
		bgFile = C.media.blank, edgeFile = C.media.blank, edgeSize = mult,
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult}
	})

	if t == "Transparent" then
		backdropa = C.media.overlay_color[4]
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	else
		backdropa = C.media.backdrop_color[4]
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
		bgFile = C.media.blank, edgeFile = C.media.blank, edgeSize = mult,
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult}
	})

	if t == "Transparent" then
		backdropa = C.media.overlay_color[4]
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	elseif t == "Invisible" then
		backdropa = 0
		bordera = 0
	else
		backdropa = C.media.backdrop_color[4]
	end

	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end
