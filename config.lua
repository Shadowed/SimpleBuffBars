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
-- Setting group options
local function setGroupOption(info, value)
	local cat = info[1]
	local key = info[#(info)]
	if( cat == "general" ) then
		globalSettings[key] = value
		
		for _, group in pairs(SimpleBB.db.profile.groups) do
			group[key] = value
		end
		
		SimpleBB:Reload()
		return
	end
	
	SimpleBB.db.profile.groups[cat][key] = value
	SimpleBB:Reload()
end

local function getGroupOption(info)
	local cat = info[1]
	local key = info[#(info)]
	if( cat == "general" ) then
		return globalSettings[key]
	end
	
	return SimpleBB.db.profile.groups[cat][key]
end

local function setGroupColor(info, r, g, b)
	setGroupOption(info, {r = r, g = g, b = b})
end

local function getGroupColor(info)
	local value = getGroupOption(info)
	return value.r, value.g, value.b
end

-- Setting single options
local function set(info, value)
	SimpleBB.db.profile[info[#(info)]] = value
	SimpleBB:Reload()
end

local function get(info)
	return SimpleBB.db.profile[info[#(info)]]
end

local function setMulti(info, key, state)
	SimpleBB.db.profile[info[#(info)]][key] = state
	SimpleBB:Reload()
end

local function getMulti(info, key)
	return SimpleBB.db.profile[info[#(info)]][key]
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

local groupList = {}
function Config:GetGroupList(info)
	for k in pairs(groupList) do groupList[k] = nil end
	
	groupList[""] = L["None"]
	
	for key, group in pairs(SimpleBB.db.profile.groups) do
		if( key ~= info[1] ) then
			groupList[key] = group.name
		end
	end
	
	return groupList
end

local timeDisplay = {["hhmmss"] = L["HH:MM:SS"], ["blizzard"] = L["Blizzard default"]}
function Config:CreateAnchorSettings(group, name)
	return {
		desc = {
			order = 0,
			name = string.format(L["%s anchor configuration."], name),
			type = "description",
		},
		general = {
			order = 1,
			type = "group",
			inline = true,
			name = L["General"],
			args = {
				enabled = {
					order = 0,
					type = "toggle",
					name = L["Enable group"],
					desc = L["Enable showing this group, if it's disabled then no timers will appear inside."],
				},
				growUp = {
					order = 0.50,
					type = "toggle",
					name = L["Grow display up"],
					desc = L["Instead of adding everything from top to bottom, timers will be shown from bottom to top."],
				},
				fillTimeless = {
					order = 1,
					type = "toggle",
					name = L["Fill timeless buffs"],
					desc = L["Buffs without a duration will have the status bar shown as filled in, instead of empty."],
				},
				passive = {
					order = 2,
					type = "toggle",
					name = L["Hide passive buffs"],
				},
				playerOnly = {
					order = 3,
					type = "toggle",
					name = L["Hide buffs you didn't cast"],
					hidden = function(info) if( info[1] ~= "buffs" and info[1] ~= "debuffs" and info[1] ~= "tempEnchants" and info[2] ~= "global" ) then return false else return true end end,
					width = "full",
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
					min = 0.01, max = 2, step = 0.01, isPercent = true,
				},
				alpha = {
					order = 5,
					type = "range",
					name = L["Display alpha"],
					min = 0, max = 1, step = 0.01,
				},
				spacing = {
					order = 6,
					type = "range",
					name = L["Row spacing"],
					desc = L["How far apart each timer bar should be."],
					min = -20, max = 20, step = 1,
					width = "full",
				},
				sortBy = {
					order = 7,
					type = "select",
					name = L["Buff sorting"],
					desc = L["Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added."],
					values = {["timeleft"] = L["Time left"], ["index"] = L["Order gained"]},
				},
				iconPosition = {
					order = 8,
					type = "select",
					name = L["Icon position"],
					values = {["HIDE"] = L["Hide"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
				},
			}
		},
		anchor = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Anchor"],
			args = {
			 	anchorSpacing = {
					order = 1,
					type = "range",
					name = L["Spacing"],
					desc = L["How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none."],
					min = -100, max = 100, step = 1,
				},
				anchorTo = {
					order = 2,
					type = "select",
					name = L["Anchor to"],
					desc = string.format(L["Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap."], group),
					values = "GetGroupList",
				},
			},
		},
		tempEnchant = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Temporary enchants"],
			hidden = function(info) if( info[1] ~= "tempEnchants" ) then return true end end,
			args = {
				moveTo = {
					order = 2,
					type = "select",
					name = L["Move to"],
					desc = L["Allows you to move the temporary weapon enchants into another anchor."],
					values = {[""] = L["None"], ["buffs"] = L["Buffs"], ["debuffs"] = L["Debuffs"]},
				},
				tempColor = {
					order = 4,
					type = "color",
					name = L["Temporary enchant colors"],
					desc = L["Bar and background color for temporary weapon enchants, only used if color by type is enabled."],
					set = setGroupColor,
					get = getGroupColor,
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
				},
				height = {
					order = 2,
					type = "range",
					name = L["Height"],
					min = 1, max = 30, step = 1,
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
				},
				color = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Colors"],
					args = {
						colorbyType = {
							order = 1,
							type = "toggle",
							name = L["Color by type"],
							desc = L["Sets the bar color to the buff type, if it's a buff light blue, temporary weapon enchants purple, debuffs will be colored by magic type, or red if none."],
						},
						color = {
							order = 3,
							type = "color",
							name = L["Color"],
							desc = L["Bar color and background color, if color by type is enabled then this only applies to buffs and tracking."],
							set = setGroupColor,
							get = getGroupColor,
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
				fontSize = {
					order = 1,
					type = "range",
					name = L["Size"],
					min = 1, max = 20, step = 1,
					set = setNumber,
				},
				font = {
					order = 2,
					type = "select",
					name = L["Font"],
					dialogControl = "LSM30_Font",
					values = "GetFonts",
				},
				display = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Display"],
					args = {
						showStack = {
							order = 1,
							type = "toggle",
							name = L["Show stack size"],
							width = "full",
						},
						stackFirst = {
							order = 2,
							type = "toggle",
							name = L["Show stack first"],
						},
						showRank = {
							order = 3,
							type = "toggle",
							name = L["Show spell rank"],
						},
						time = {
							order = 4,
							type = "select",
							name = L["Time display"],
							values = timeDisplay,
						},
					},
				},
			},
		},
	}
end

local order = 1
function Config:CreateGroupConfig(key, name)
	order = order + 1
	return {
		order = order,
		type = "group",
		name = name,
		get = getGroupOption,
		set = setGroupOption,
		handler = Config,
		args = Config:CreateAnchorSettings(key, name),
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
			locked = {
				order = 0,
				type = "toggle",
				name = L["Lock frames"],
				desc = L["Prevents the frames from being dragged with ALT + Drag."],
			},
			showExtras = {
				order = 0.50,
				type = "toggle",
				name = L["Enable extra units"],
				desc = L["Allows you to configure and show buff bars for target, focus and pet units.\nDisabling this will reset the anchor configuration for those three units."],
			},
			showExample = {
				order = 1,
				type = "toggle",
				name = L["Show examples"],
				desc = L["Shows an example buff/debuff for configuration."],
			},
			showTrack = {
				order = 2,
				type = "toggle",
				name = L["Show tracking"],
				desc = L["Shows your current tracking as a buff, can change trackings through this as well."],
			},
			showTemp = {
				order = 3,
				type = "toggle",
				name = L["Show temporary weapon enchants"],
				desc = L["Shows your current temporary weapon enchants as a buff."],
				width = "full",
			},
			filters = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Filtering"],
				args = {
					desc = {
						order = 0,
						name = L["Allows you to reduce the amount of buffs that are shown by using different filters to hide things that are not relevant to your current talents.\n\nThis will filter things that are not directly related to the filter type, the Physical filter will hide things like Flametongue Totem, or Divine Spirit, while the Caster filter will hide Windfury Totem or Battle Shout."],
						type = "description",
					},
					autoFilter = {
						order = 1,
						type = "toggle",
						name = L["Auto filter"],
						desc = L["Automatically enables the physical or caster filters based on talents and class."],
						width = "full",
					},
					filtersEnabled = {
						order = 2,
						name = L["Filters"],
						type = "multiselect",
						disabled = function() return SimpleBB.db.profile.autoFilter end,
						values = SimpleBB.modules.Filters:GetList(),
						set = setMulti,
						get = getMulti,
					},
				},
			},
			global = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Global options"],
				get = getGroupOption,
				set = setGroupOption,
				args = {},
			},
		},
	}
	
	-- Setup global options
	options.args.general.args.global.args = Config:CreateAnchorSettings("global", "")
	
	local globalOptions = options.args.general.args.global.args
	globalOptions.desc.name = L["Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings.\n\nNOTE! Not all options are available, things like anchoring or hiding passive buffs are only available in the anchors own configuration."]
	globalOptions.anchor.args.to = nil
	globalOptions.general.args.passive = nil
	globalOptions.general.args.enabled.width = "full"
	
	-- Create anchor configuration, first sort it so they all end up nice and lined up.
	local groups = {}
	for key, group in pairs(SimpleBB.db.profile.groups) do
		table.insert(groups, key)
	end
	
	table.sort(groups, function(a, b)
		return a > b
	end)
	
	for _, key in pairs(groups) do
		options.args[key] = Config:CreateGroupConfig(key, SimpleBB.db.profile.groups[key].name)
	end
	
	-- DB Profiles
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(SimpleBB.db)
	options.args.profile.order = 99999
	
	-- Lets modules access the configuration
	Config.options = options
	
	-- Module status
	for _, module in pairs(SimpleBB.modules) do
		if( module.CreateConfiguration ) then
			module:CreateConfiguration()
		end
	end
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
end
