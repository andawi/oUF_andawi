 local addon, ns = ...
 local cfg = CreateFrame("Frame")

  -----------------------------
  -- Media
  -----------------------------

local textures = "Interface\\AddOns\\oUF_andawi\\media\\textures\\"
local fonts = "Interface\\AddOns\\oUF_andawi\\media\\fonts\\"


cfg.texture = textures.."texture"
cfg.texMinimalist = "Interface\\AddOns\\SharedMedia\\Statusbar\\Minimalist"
cfg.buttonTex = textures.."gloss"
cfg.raidIcons = textures.."raidicons"
cfg.arrow = textures.."Arrow"
cfg.highlightBorder = textures..'highlightBorder'

cfg.font, cfg.fontsize, cfg.shadowoffsetX, cfg.shadowoffsetY, cfg.fontflag = fonts.."pixel10.ttf", 10, 0, 0,  "Outlinemonochrome" -- "" for none THINOUTLINE Outlinemonochrome
cfg.font_Pixel8 = fonts.."Pixel8.ttf"
cfg.font_Pixel13 = fonts.."pixel13.ttf"
cfg.fontB = fonts.."ROADWAY.ttf"
cfg.symbol = fonts.."symbol.ttf"
cfg.squares = fonts.."squares.ttf"



  -----------------------------
  -- Unit Frames
  -----------------------------

cfg.scale = 1
cfg.fontsize = 10 * 1/cfg.scale


-- raid == party frames
cfg.raid = true

cfg.raidScale = 1 --0.85
cfg.pixelFontSize = 8 * 1/cfg.raidScale


--player, target, focus
cfg.width = 200
cfg.health_height = 20
cfg.power_height = 1
cfg.specific_power_height = 3
-- raid / party
cfg.raid_width = 100
cfg.raid_health_height = 36
cfg.raid_power_height = 1

--pet, targettarget, focustarget
cfg.pet_width = 90
cfg.pet_height = 15

cfg.disableRaidFrameManager = false
cfg.portraits = false
cfg.healcomm = true
cfg.specific_power = true

cfg.AltPowerBar = true
cfg.AltPowerBar_pos = {'CENTER', UIParent, 0, -295}
cfg.AltPowerBar_Width = 250
cfg.AltPowerBar_Height = 12

-- Unit Frames Positions

 cfg.unit_positions = {
             Player = { x= -300, y= 20},
             Target = { x=	300, y= 20},
       Targettarget = { x=  120, y=  -80},
              Focus = { x= 450, y=  -120},  
        Focustarget = { x=    0, y=  -65},
                Pet = { x=	  -100, y=  -100},
               Raid = { x=	 0, y=  -110},
}

  -----------------------------
  -- Auras
  -----------------------------

cfg.auras = true  -- disable all auras
cfg.border = false
cfg.onlyShowPlayer = true -- only show player debuffs on target
cfg.disableCooldown = false -- hide Cooldown Spiral
cfg.aura_font, cfg.aura_fontsize, cfg.aura_fontflag = fonts.."pixel.ttf", 8, "Outlinemonochrome"
cfg.player_debuffs_num = 18
cfg.target_debuffs_num = 18
cfg.target_buffs_num = 20

  -----------------------------
  -- Plugins
  -----------------------------

cfg.Smooth = true
cfg.DruidMana = true

--DebuffHighlight
cfg.DebuffHighlight = true
cfg.DebuffHighlightFilter = true

cfg.WeakenedSoulHighlight = true

--AuraWatch
cfg.showAuraWatch = true
cfg.onlyShowPresent = true
cfg.anyUnit = true

-- cluster heal
cfg.clusterheal = true

cfg.spellIDs = {

	--SPELL ID, size, X-POS, Y-POS, anyUnit, ALPHA, Class

	{6788, 		14, 10, 9, true, 1, 'PRIEST'},				-- Weakened Soul (lowest frame level)
	{17, 		12, 10, 9, true, 1, 'PRIEST'},				-- Power Word: Shield
	{33076, 	12, 27, 9, false, 1, 'PRIEST'},			-- Prayer of Mending
	{139, 		12, 43, 9, false, 1, 'PRIEST'}, 			-- Renew
-- obsolete	{77613, 	12, 59, 11, false, 1, 'PRIEST'},			-- Grace



	--POS1 (18, 0) - personal Defensive CDs #1
	{498, 		24, 15, 0, true, 0.9, 'GENERIC'},  			-- Divine Protection (40%; 1min CD)
	{871, 		24, 15, 0, true, 0.9, 'GENERIC'}, 			-- Shield Wall (40%; 5min)
	{61336, 	24, 15, 0, true, 0.9, 'GENERIC'},			-- Survival Instincts (50%; 3min)
	{19263, 	24, 15, 0, true, 0.9, 'GENERIC'},			-- Deterrence (100% deflect; 30% AoE; 2min)
	{45438, 	24, 15, 0, true, 0.9, 'GENERIC'},			-- Iceblock (100%; 5min)
	{108271, 	24, 15, 0, true, 0.9, 'GENERIC'},			-- Astral Shift (Shaman 40%, 2min CD)
	{48792, 	24, 15, 0, true, 0.9, 'GENERIC'},			-- Icebound Fortitude (20%; 3min)
	{110913, 	24, 15, 0, true, 0.9, 'GENERIC'},			-- Dark Bargain (Warlock 100%; 3min)
	{31224, 	24, 15, 0, true, 0.9, 'GENERIC'},			-- Cloak of Shadows (100%, 1min)
	{122783, 	24, 15, 0, true, 0.9, 'GENERIC'},    		-- Diffuse Magic (Monk, 90%; 90sec)
	{47585, 	24, 15, 0, true, 0.9, 'GENERIC'}, 			-- Dispersion (Shadow, 90%; 2min)
	--{139,		24,	18,	0,	true,	0.9,	'GENERIC'},		-- debug#1



	--POS2 - personal Defensive CDs #2
	{86659, 	24, 25, 0, true, 0.9, 'GENERIC'},			-- Guardian of Ancient Kings (50%; 3min; PROT)
	--{106922, 	24, 25, 0, true, 0.9, 'GENERIC'},			-- Might of Ursoc (+30% HP; 3min CD)
	{48707,		24, 25, 0, true, 0.9, 'GENERIC'}, 			-- Anti-magic Shell
	{115203,	24, 25, 0, true, 0.9, 'GENERIC'}, 			-- Fortifying Brew (20%; 3min)
	{118038,	24, 25, 0, true, 0.9, 'GENERIC'}, 			-- Die by the Sword (Warrior 20%; 2min)
	--{41635,		24,	30,	0,	true,	0.9,	'GENERIC'},		-- debug#2

	--POS3 - personal Defensive CDs #3
	{31850,		24, 35, 0, true, 0.95, 'GENERIC'},			-- Ardent Defender (20%; 3min CD; lifesaver)
	{642, 		24, 35, 0, true, 0.95, 'GENERIC'}, 			-- Divine Shield (100%; 5min)
	{22812, 	24, 35, 0, true, 0.95, 'GENERIC'},			-- Barkskin (20%; 1min)
	{55233, 	24, 35, 0, true, 0.95, 'GENERIC'}, 			-- Vampiric Blood
	{104773, 	24, 35, 0, true, 0.95, 'GENERIC'},			-- Unending Resolve (Warlock 40%; 3min)
	{30823, 	24,	35, 0, true, 0.95, 'GENERIC'},			-- Shamanistic Rage (Elemental, Enhancement 30%; 1min CD)
	{1966, 		24,	35, 0, true, 0.95, 'GENERIC'},			-- Feint (AoE 50%; 65% w/ Glyph - no CD)
	{115176, 	24,	35, 0, true, 0.95, 'GENERIC'},			-- Zen Meditaion (90% group saver; 3min)
	{12975, 	24, 35, 0, true, 0.95, 'GENERIC'},			-- Last Stand (+30% HP; 3min CD)


	--POS4 - raid wide CDs #4
	{31821,		24, 45, 0, true, 0.95, 'GENERIC'},			-- Devotion Aura (20%; 3min; magic)
	{114030,	24,	45,	0,	true,	0.95, 'GENERIC'},		-- Vigilance

	--POS5
	{740, 		24, 55, 0, true, 0.95, 'GENERIC'},			-- Tranquility
	{6940, 		24, 55, 0, true, 0.95, 'GENERIC'},			-- Hand of Sacrifice

	--POS6
	{97462, 	24, 65, 0, true, 0.95, 'GENERIC'},			-- Rallying Cry
	{114039, 	24, 65, 0, true, 0.95, 'GENERIC'},			-- Hand of Purity

	--POS7
	{81782,		24, 75, 0, true, 0.95, 'GENERIC'},			-- Power Word Barrier
	{102342, 	24, 75, 0, true, 0.95, 'GENERIC'},			-- Ironbark (20%; 2min; RESTO)

	--POS8
	{1022, 		24, 85, 0, true, 0.95, 'GENERIC'},			-- Hand of Protection


	--POSZ (122, 0) - last pos
	{33206, 	24, 95, 0, true, 0.95, 'GENERIC'},			-- Pain Suppress
	{47788, 	24, 95, 0, true, 0.95, 'GENERIC'},			-- Guardian Spirit


	-- Mana CDs @ Mana Bar
--	{64901,   	16, 100, -16, true, 0.95, 'GENERIC'},		-- Hymn of Hope
--	{29166,		16, 100, -16, true, 0.95, 'GENERIC'},		-- Innervate



	-- active Mitigation
	--{132404,	14, 53, -8, true, 0.95, 'GENERIC'},			-- Shield Block
	--{132402,	14, 40, -8, true, 0.95, 'GENERIC'},			-- Savage Defense




	--[[ minor CDs
	{112048,	14, 40, -8, true, 0.95, 'GENERIC'},			-- Shield Barrier


	{114052,	14,	40, -8, true, 0.95, 'GENERIC'},			-- Ascendance (Resto Shaman Heal CD)
	{33891,		14, 40, -8, true, 0.95, 'GENERIC'},			-- Tree Form (Resto Druid)
	{31884,		14, 40, -8, true, 0.95, 'GENERIC'},			-- Avenging Wrath (Pala Heal CD)

	{81700,		14, 40, -8, true, 0.95, 'GENERIC'},			-- Archangel
	{109964,	12, 53, -8, true, 0.95, 'GENERIC', 'PRIEST'},			-- Spirit Shell
	]]







--[[
	DRUID = {
	{94447, {0.2, 0.8, 0.2}},			    -- Lifebloom
	{8936, {0.8, 0.4, 0}, "TOPLEFT"},			-- Regrowth
	{102342, {0.38, 0.22, 0.1}},		    -- Ironbark
	{48438, {0.4, 0.8, 0.2}, "BOTTOMLEFT"},	-- Wild Growth
	{774, {0.8, 0.4, 0.8},"TOPRIGHT"},		-- Rejuvenation
	},
	MONK = {
	{119611, {0.2, 0.7, 0.7}},			-- Renewing Mist
	{124682, {0.4, 0.8, 0.2}},			-- Enveloping Mist
	{124081, {0.7, 0.4, 0}},			-- Zen Sphere
	{116849, {0.81, 0.85, 0.1}},		-- Life Cocoon
	},
	PALADIN = {
	{20925, {0.9, 0.9, 0.1}},	            -- Sacred Shield
	{6940, {0.89, 0.1, 0.1}, "BOTTOMLEFT"}, -- Hand of Sacrifice
	{114039, {0.4, 0.6, 0.8}, "BOTTOMLEFT"},-- Hand of Purity
	{1022, {0.2, 0.2, 1}, "BOTTOMLEFT"},	-- Hand of Protection
	{1038, {0.93, 0.75, 0}, "BOTTOMLEFT"},  -- Hand of Salvation
	{1044, {0.89, 0.45, 0}, "BOTTOMLEFT"},  -- Hand of Freedom
	{114163, {0.9, 0.6, 0.4}, "RIGHT"},	    -- Eternal Flame
	{53563, {0.7, 0.3, 0.7}, "TOPRIGHT"},   -- Beacon of Light
	},



	SHAMAN = {
	{974, {0.2, 0.7, 0.2}},				  -- Earth Shield
	{61295, {0.7, 0.3, 0.7}, "TOPRIGHT"}, -- Riptide
	{51945, {0.7, 0.4, 0}, "TOPLEFT"},	  -- Earthliving
	},
	DEATHKNIGHT = {
	{49016, {0.89, 0.89, 0.1}},			-- Unholy Frenzy
	},
	HUNTER = {
	{34477, {0.2, 0.2, 1}},				-- Misdirection
	},
	MAGE = {
	{111264, {0.2, 0.2, 1}},			-- Ice Ward
	},
	ROGUE = {
	{57933, {0.89, 0.1, 0.1}},			-- Tricks of the Trade
	},
	WARLOCK = {
	{20707, {0.7, 0.32, 0.75}},			-- Soulstone
	},
	WARRIOR = {
	{114030, {0.2, 0.2, 1}},			  -- Vigilance
	{3411, {0.89, 0.1, 0.1}, "TOPRIGHT"}, -- Intervene
	},
	]]
 }


 cfg.debuffFilter = {		--Debuff Filter (Blacklist)

		-- Class
		['Weakened Soul'] = true,


		--Misc
		['Tricked or Treated'] = true,
		['Upset Tummy'] = true,
		['Deserter'] = true,
		['Vault of Archavon Closure Warning'] = true,
		['Dungeon Cooldown'] = true,
		['Dungeon Deserter'] = true,
		['Flight Orders'] = true,
		['Sample Satisfaction'] = true,
		['Totem of Wrath'] = true,
		['Void-Touched'] = true,
		['Recently Mass Resurrected'] = true,
		['Master Adventurer Award'] = true,
		['Awesome!'] = true,
		['Griefer'] = true,
		['Eck Residue'] = true,
		['Weakened Heart'] = true,
		['Vivianne Defeated'] = true,


		--World Events
		['Mistletoe'] = true,

		--Death Knight
		['Perdition'] = true,

		-- Mage
		['Arcane Blast'] = true,
		['Hypothermia'] = true,

		--Shaman
		['Sated'] = true,

		--Mage
		['Temporal Displacement'] = true,
		['Arcane Charge'] = true,

		--Pala
		['Forbearance'] = true,
		['Ardent Defender'] = true,

		--Rogue
		['Cheated Death'] = true,


		--Warlock
		['Demonic Gateway'] = true,


		--ToC
		['Light Essence'] = true,
		['Dark Essence'] = true,
		['Leeching Swarm'] = true,
		['Permafrost'] = true,

		['Powering Up'] = true,

		--ICC
		['Chill of the Throne'] = true,
		['Green Blight Residue'] =true,

			--Saurfang
			['Scent of Blood'] = true,

			-- Festergut
			['Blighted Spores'] = true,
			--['Inoculated'] = true,
			['Orange Blight Residue'] = true,

			-- Sindragosa
			['Frost Aura'] = true,
			--['Mystic Buffet'] = true,
			['Chilled to the Bone'] = true,
			-- LK hc
			['Harvest Soul'] = true,


		--T13
		['Degradation'] = true,
		['Transporter Malfunction'] = true,


		--T16
		['Froststrom Strike'] = true,
		['Ancient Miasma'] = true,

	}

  -----------------------------
  -- colors
  -----------------------------

cfg.class_colorbars = false

  cfg.Color = {
       Health = {r =  0.3,	g =  0.3, 	b =  0.3},
  }

  
  
  -----------------------------
  -- handover
  -----------------------------

ns.cfg = cfg
