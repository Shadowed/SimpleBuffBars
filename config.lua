if( not SimpleBB ) then return end

local Config = SimpleBB:NewModule("Config")
local L = SimpleBBLocals

local SML, registered, options, config, dialog

local globalSettings = {}

function Config:OnInitialize()
	config = LibStub("AceConfig-3.0")
	dialog = LibStub("AceConfigDialog-3.0")
	
	-- Fill our global settings with the defaults
	for k, v in pairs(SimpleBB.defaults.profile.groups.buffs) do
		if( type(v) == "table" ) then
			globalSettings[k] = CopyTable(v)
		else
			globalSettings[k] = v
		end
	end

	-- Buff examples for making configuration easier
	SimpleBB.example = {
		["buffs"] = {
			enabled = true, type = "test", buffIndex = 0,
			buffType = "Magic", name = "Buff of test",
			icon = "Interface\\Icons\\Spell_Frost_WizardMark",
			stack = 3, rank = 3,
			timeLeft = 534, startSeconds = 800,
			endTime = GetTime() + 543,
		},
		["debuffs"] = {
			enabled = true, type = "test", buffIndex = -1,
			buffType = "none", name = "Debuff of pain",
			icon = "Interface\\Icons\\Spell_Nature_RemoveCurse",
			stack = 2, rank = 5,
			timeLeft = 253, startSeconds = 400,
			endTime = GetTime() + 253,
		},
	}

	-- Register bar textures
	SML = LibStub:GetLibrary("LibSharedMedia-3.0")
	SML:Register(SML.MediaType.STATUSBAR, "BantoBar",   "Interface\\Addons\\SimpleBuffBars\\images\\banto")
	SML:Register(SML.MediaType.STATUSBAR, "Smooth",     "Interface\\Addons\\SimpleBuffBars\\images\\smooth")
	SML:Register(SML.MediaType.STATUSBAR, "Perl",       "Interface\\Addons\\SimpleBuffBars\\images\\perl")
	SML:Register(SML.MediaType.STATUSBAR, "Glaze",      "Interface\\Addons\\SimpleBuffBars\\images\\glaze")
	SML:Register(SML.MediaType.STATUSBAR, "Charcoal",   "Interface\\Addons\\SimpleBuffBars\\images\\Charcoal")
	SML:Register(SML.MediaType.STATUSBAR, "Otravi",     "Interface\\Addons\\SimpleBuffBars\\images\\otravi")
	SML:Register(SML.MediaType.STATUSBAR, "Striped",    "Interface\\Addons\\SimpleBuffBars\\images\\striped")
	SML:Register(SML.MediaType.STATUSBAR, "LiteStep",   "Interface\\Addons\\SimpleBuffBars\\images\\LiteStep")
	SML:Register(SML.MediaType.STATUSBAR, "Minimalist", "Interface\\Addons\\SimpleBuffBars\\images\\Minimalist")
end

-- GUI
local function setGlobal(arg1, arg2, arg3, value)
	for name in pairs(SimpleBB.db.profile.groups) do
		SimpleBB.db.profile[arg1][name][arg3] = value
		globalSettings[arg3] = value
	end
	
	SimpleBB:Reload()
end


local function set(info, value)
	local arg1, arg2, arg3 = string.split(".", info.arg)
	
	if( arg2 == "global" ) then
		setGlobal(arg1, arg2, arg3, value)
		return
	elseif( arg2 and arg3 ) then
		SimpleBB.db.profile[arg1][arg2][arg3] = value
	elseif( arg2 ) then
		SimpleBB.db.profile[arg1][arg2] = value
	else
		SimpleBB.db.profile[arg1] = value
	end
	
	SimpleBB:Reload()
end

local function get(info)
	local arg1, arg2, arg3 = string.split(".", info.arg)
	
	if( arg2 == "global" ) then
		return globalSettings[arg3]
	elseif( arg2 and arg3 ) then
		return SimpleBB.db.profile[arg1][arg2][arg3]
	elseif( arg2 ) then
		return SimpleBB.db.profile[arg1][arg2]
	else
		return SimpleBB.db.profile[arg1]
	end
end

local function setNumber(info, value)
	set(info, tonumber(value))
end

local function setColor(info, r, g, b)
	set(info, {r = r, g = g, b = b})
end

local function getColor(info)
	local value = get(info)
	if( type(value) == "table" ) then
		return value.r, value.g, value.b
	end
	
	return value
end

local textures = {}
function Config:GetTextures()
	for k in pairs(textures) do textures[k] = nil end

	for _, name in pairs(SML:List(SML.MediaType.STATUSBAR)) do
		textures[name] = name
	end
	
	return textures
end

local fonts = {}
function Config:GetFonts()
	for k in pairs(fonts) do fonts[k] = nil end

	for _, name in pairs(SML:List(SML.MediaType.FONT)) do
		fonts[name] = name
	end
	
	return fonts
end

local function createAnchorOptions(group)
	return {
		desc = {
			order = 0,
			name = string.format(L["Anchor configuration for %ss."], group),
			type = "description",
		},
		general = {
			order = 1,
			type = "group",
			inline = true,
			name = L["General"],
			args = {
				growUp = {
					order = 0,
					type = "toggle",
					name = L["Grow display up"],
					desc = L["Instead of adding everything from top to bottom, timers will be shown from bottom to top."],
					arg = string.format("groups.%s.growUp", group),
					width = "full",
				},
				timeless = {
					order = 1,
					type = "toggle",
					name = L["Fill timeless buffs"],
					desc = L["Buffs without a duration will have the status bar shown as filled in, instead of empty."],
					arg = string.format("groups.%s.fillTimeless", group),
				},
				passive = {
					order = 2,
					type = "toggle",
					name = L["Hide passive buffs"],
					arg = string.format("groups.%s.passive", group),
				},
				sep = {
					order = 3,
					name = "",
					type = "description",
				},
				scale = {
					order = 4,
					type = "range",
					name = L["Display scale"],
					desc = L["How big the actual timers should be."],
					min = 0, max = 2, step = 0.01,
					arg = string.format("groups.%s.scale", group),
				},
				alpha = {
					order = 5,
					type = "range",
					name = L["Display alpha"],
					min = 0, max = 1, step = 0.1,
					arg = string.format("groups.%s.alpha", group),
				},
				sep = {
					order = 6,
					name = "",
					type = "description",
				},
				--[[
				maxRows = {
					order = 6,
					type = "range",
					name = L["Max timers"],
					desc = L["Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed."],
					min = 1, max = 100, step = 1,
					arg = string.format("groups.%s.maxRows", group),
				},
				]]
				sorting = {
					order = 7,
					type = "select",
					name = L["Buff sorting"],
					desc = L["Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added."],
					values = {["timeleft"] = L["Time left"], ["index"] = L["Order gained"]},
					arg = string.format("groups.%s.sortBy", group),
				},
				icon = {
					order = 8,
					type = "select",
					name = L["Icon position"],
					values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
					arg = string.format("groups.%s.iconPosition", group),
				},
				spacing = {
					order = 9,
					type = "range",
					name = L["Row spacing"],
					desc = L["How far apart each timer bar should be."],
					min = -20, max = 20, step = 1,
					arg = string.format("groups.%s.spacing", group),
				},
			}
		},
		anchor = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Anchor"],
			args = {
				size = {
					order = 1,
					type = "range",
					name = L["Spacing"],
					desc = L["How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none."],
					min = 0, max = 50, step = 1,
					set = setNumber,
					arg = string.format("groups.%s.anchorSpacing", group),
				},
				to = {
					order = 2,
					type = "select",
					name = L["Anchor to"],
					desc = string.format(L["Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap."], group),
					values = {[""] = L["None"], ["buffs"] = L["Buffs"], ["debuffs"] = L["Debuffs"]},
					arg = string.format("groups.%s.anchorTo", group),
				},
			},
		},
		bar = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Bars"],
			args = {
				width = {
					order = 1,
					type = "range",
					name = L["Width"],
					min = 50, max = 300, step = 1,
					set = setNumber,
					arg = string.format("groups.%s.width", group),
				},
				height = {
					order = 2,
					type = "range",
					name = L["Height"],
					min = 1, max = 30, step = 1,
					set = setNumber,
					arg = string.format("groups.%s.height", group),
				},
				sep = {
					order = 3,
					name = "",
					type = "description",
				},
				texture = {
					order = 4,
					type = "select",
					name = L["Texture"],
					dialogControl = "LSM30_Statusbar",
					values = "GetTextures",
					arg = string.format("groups.%s.texture", group),
				},
				color = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Colors"],
					args = {
						colorType = {
							order = 1,
							type = "toggle",
							name = L["Color by type"],
							desc = L["Sets the bar color to the buff type, if it's a buff light blue, temporary weapon enchants purple, debuffs will be colored by magic type, or red if none."],
							arg = string.format("groups.%s.colorByType", group),
						},
						sep = {
							order = 2,
							name = "",
							type = "description",
							width = "full",
						},
						baseColor = {
							order = 3,
							type = "color",
							name = L["Color"],
							desc = L["Bar color and background color, if color by type is enabled then this only applies to buffs and tracking."],
							set = setColor,
							get = getColor,
							arg = string.format("groups.%s.color", group),
						},
						tempColor = {
							order = 4,
							type = "color",
							name = L["Temporary enchant colors"],
							desc = L["Bar and background color for temporary weapon enchants, only used if color by type is enabled."],
							set = setColor,
							get = getColor,
							arg = string.format("groups.%s.tempColor", group),
						},
					},
				},
			},
		},
		text = {
			order = 8,
			type = "group",
			inline = true,
			name = L["Text"],
			args = {
				size = {
					order = 1,
					type = "range",
					name = L["Size"],
					min = 1, max = 20, step = 1,
					set = setNumber,
					arg = string.format("groups.%s.fontSize", group),
				},
				name = {
					order = 2,
					type = "select",
					name = L["Font"],
					dialogControl = "LSM30_Font",
					values = "GetFonts",
					arg = string.format("groups.%s.font", group),
				},
				display = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Display"],
					args = {
						stack = {
							order = 1,
							type = "toggle",
							name = L["Show stack size"],
							arg = string.format("groups.%s.showStack", group),
						},
						rank = {
							order = 2,
							type = "toggle",
							name = L["Show spell rank"],
							arg = string.format("groups.%s.showRank", group),
						},
					},
				},
			},
		},
	}
end

local function loadOptions()
	options = {}
	options.type = "group"
	options.name = "Simple Buff Bars"
	
	options.args = {}
	options.args.general = {
		type = "group",
		order = 1,
		name = L["General"],
		get = get,
		set = set,
		handler = Config,
		args = {
			enabled = {
				order = 0,
				type = "toggle",
				name = L["Lock frames"],
				desc = L["Prevents the frames from being dragged with ALT + Drag."],
				width = "full",
				arg = "locked",
			},
			example = {
				order = 1,
				type = "toggle",
				name = L["Show examples"],
				desc = L["Shows an example buff/debuff for configuration."],
				width = "full",
				arg = "showExample",
			},
			temps = {
				order = 2,
				type = "toggle",
				name = L["Show temporary weapon enchants"],
				desc = L["Shows your current temporary weapon enchants as a buff."],
				width = "full",
				arg = "showTemp",
			},
			tracking = {
				order = 3,
				type = "toggle",
				name = L["Show tracking"],
				desc = L["Shows your current tracking as a buff, can change trackings through this as well."],
				width = "full",
				arg = "showTrack",
			},
			global = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Global options"],
				args = {},
			},
		},
	}
	
	-- Setup global options
	options.args.general.args.global.args = createAnchorOptions("global")
	
	local globalOptions = options.args.general.args.global.args
	globalOptions.desc.name = L["Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings."]
	globalOptions.anchor.args.to = nil
	globalOptions.general.args.passive = nil
	
	
	-- Buff configuration
	options.args.buffs = {
		order = 2,
		type = "group",
		name = L["Player buffs"],
		get = get,
		set = set,
		handler = Config,
		args = createAnchorOptions("buffs"),
	}

	-- Debuff configuration
	options.args.debuffs = {
		order = 3,
		type = "group",
		name = L["Player debuffs"],
		get = get,
		set = set,
		handler = Config,
		args = createAnchorOptions("debuffs"),
	}
	
	options.args.debuffs.args.bar.args.color.args.tempColor = nil

	-- DB Profiles
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(SimpleBB.db)
	options.args.profile.order = 4
end

-- Slash commands
SLASH_SIMPLEBB1 = "/simplebb"
SLASH_SIMPLEBB2 = "/sbb"
SlashCmdList["SIMPLEBB"] = function(msg)
	if( not registered ) then
		if( not options ) then
			loadOptions()
		end

		config:RegisterOptionsTable("SimpleBB", options)
		dialog:SetDefaultSize("SimpleBB", 650, 525)
		registered = true
	end

	dialog:Open("SimpleBB")

	--if( msg == "ui" ) then
	--else
	--	DEFAULT_CHAT_FRAME:AddMessage(L["Simple Buff Bars slash commands"])
	--	DEFAULT_CHAT_FRAME:AddMessage(L[" - ui - Opens the configuration."])
	--end
end