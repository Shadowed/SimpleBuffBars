--[[ 
	Simple Buff Bars, Shadow from Mal'Ganis US
]]

local SimpleBB = select(2, ...)
SimpleBB = LibStub("AceAddon-3.0"):NewAddon(SimpleBB, "SimpleBB", "AceEvent-3.0")
local L = SimpleBB.L

local SML, MAINHAND_SLOT, OFFHAND_SLOT, MAINHAND_BUFF_INDEX, OFFHAND_BUFF_INDEX, TRACKING_INDEX
local playerUnit = "player"
local ENCHANT_ANCHOR = "tempEnchants"
local _G = getfenv(0)

local frame = CreateFrame("Frame")

function SimpleBB:OnInitialize()
	self.defaults = {
		profile = {
			locked = false,
			showTrack = true,
			showExample = false,
			showExtras = false,
			showTemp = true,
			autoFilter = false,
			filtersEnabled = {["Caster"] = false, ["Physical"] = false},
			groups = {},
			anchors = {
				enabled = true,
				tempColor = {r = 0.5, g = 0.0, b = 0.5},
				color = {r = 0.30, g = 0.50, b = 1.0},
				texture = "Minimalist",
				sortBy = "timeleft",
				iconPosition = "LEFT",
				height = 16,
				width = 200,
				maxRows = 100,
				scale = 1.0,
				alpha = 1.0,
				spacing = 0,
				colorByType = true,
				anchorSpacing = 20,
				anchorTo = "",
				showStack = true,
				font = "Friz Quadrata TT",
				fontSize = 12,
				passive = false,
				time = "hhmmss",
				stackFirst = false,
				position = { x = 600, y = 600 },
			},
		},
	}

	-- Setup defaults quickly for groups
	self.defaults.profile.groups.buffs = CopyTable(self.defaults.profile.anchors)
	self.defaults.profile.groups.buffs.name = L["Player buffs"]
	self.defaults.profile.groups.buffs.canFilter = true
	self.defaults.profile.groups.debuffs = CopyTable(self.defaults.profile.anchors)
	self.defaults.profile.groups.debuffs.name = L["Player debuffs"]
	self.defaults.profile.groups.tempEnchants = CopyTable(self.defaults.profile.anchors)
	self.defaults.profile.groups.tempEnchants.moveTo = "buffs"
	self.defaults.profile.groups.tempEnchants.name = L["Temporary enchants"]
	
	-- Initialize the DB
	self.db = LibStub:GetLibrary("AceDB-3.0"):New("SimpleBBDB", self.defaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "Reload")
	self.db.RegisterCallback(self, "OnProfileCopied", "Reload")
	self.db.RegisterCallback(self, "OnProfileReset", "Reload")

	self.revision = tonumber(string.match("$Revision$", "(%d+)") or 1)
	
	-- Annnd so we can grab texture things
	SML = LibStub:GetLibrary("LibSharedMedia-3.0")
	SML.RegisterCallback(self, "LibSharedMedia_Registered", "ResourceRegistered")
	
	-- Create the needed group tables
	self.auras = {}
	self.groups = {}
	
	self:UpdateGroups()
	
	-- Setup the SlotIDs for Mainhand/Offhands
	MAINHAND_SLOT = GetInventorySlotInfo("MainHandSlot")
	OFFHAND_SLOT = GetInventorySlotInfo("SecondaryHandSlot")
	
	-- Setup the anchor the enchants go into
	if( self.db.profile.groups.tempEnchants.moveTo ~= "" ) then
		ENCHANT_ANCHOR = self.db.profile.groups.tempEnchants.moveTo
	end
	
	-- Kill Blizzards buff frame
	BuffFrame:UnregisterEvent("UNIT_AURA")
	TemporaryEnchantFrame:Hide()
	BuffFrame:Hide()
	
	-- Delay updating buffs until PEW, this way scaling and such is set correctly
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

-- Show the vehicle buffs if the player is in one
function SimpleBB:CheckVehicleStatus()
	playerUnit = UnitHasVehicleUI("player") and "vehicle" or "player"
	self:UNIT_AURA(nil, playerUnit)
end

-- Update group tables and such
function SimpleBB:UpdateGroups()
	for key in pairs(self.db.profile.groups) do
		if( not self.groups[key] ) then
			self.groups[key] = self:CreateGroup(key)
			self.groups[key].rows = {}
			self.auras[key] = {}
		end
	end
end

-- BAR MANAGEMENT
local function OnShow(self)
	local config = SimpleBB.db.profile.groups[self.name]
	
	-- Set the active anchor to the default one
	config.activeAnchor = config.anchorTo
	-- If debuffs are anchored to temp enchants, temp enchants to buffs
	-- We try and position debuffs, but temp enchants aren't visible, will automatically anchor the debuffs to buffs
	-- This also has the benefit of if buffs aren't shown, it'll automatically anchor debuffs where buffs are instead of temp enchants
	if( config.anchorTo ~= "" and not SimpleBB.groups[config.anchorTo]:IsVisible() and SimpleBB.db.profile.groups[config.anchorTo].anchorTo ~= "" ) then
		config.activeAnchor = SimpleBB.db.profile.groups[config.anchorTo].anchorTo
	end
	
	-- Check if we need to anchor it to something else
	if( config.activeAnchor ~= self.name and SimpleBB.groups[config.activeAnchor] ) then
		-- We're anchored to something else, and that anchor is visible
		if( SimpleBB.groups[config.activeAnchor]:IsVisible() ) then
			self:ClearAllPoints()
			if( SimpleBB.db.profile.groups[config.activeAnchor].growUp ) then
				self:SetPoint("TOPLEFT", SimpleBB.groups[config.activeAnchor].container, "TOPLEFT", 0, config.anchorSpacing)
			else
				self:SetPoint("TOPLEFT", SimpleBB.groups[config.activeAnchor].container, "BOTTOMLEFT", 0, -config.anchorSpacing)
			end

			self:SetMovable(false)
		else
			local scale = self:GetEffectiveScale()
			local position = SimpleBB.db.profile.groups[config.activeAnchor].position
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", position.x / scale, position.y / scale)
			self:SetMovable(true)
		end
		
	elseif( config.position ) then
		local scale = self:GetEffectiveScale()
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", config.position.x / scale, config.position.y / scale)
		self:SetMovable(true)
	else
		self:ClearAllPoints()
		self:SetPoint("CENTER", UIParent, "CENTER")
		self:SetMovable(true)
	end

	-- Check if something is anchored to us, if it is then we need to reposition them
	for name, data in pairs(SimpleBB.db.profile.groups) do
		if( data.anchorTo == self.name and self.name ~= name ) then
			OnShow(SimpleBB.groups[name])
		end
	end
end

-- Check if something is anchored to us, if it is then we need to reposition them
local function OnHide(self)
	for name, data in pairs(SimpleBB.db.profile.groups) do
		if( data.activeAnchor == self.name and SimpleBB.groups[name]:IsVisible() ) then
			OnShow(SimpleBB.groups[name])
		end
	end
end

local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 0.80,
		insets = {left = 1, right = 1, top = 1, bottom = 1}}

function SimpleBB:CreateGroup(name)
	-- Set defaults
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetMovable(true)
	frame:Hide()
	
	frame:SetScript("OnHide", OnHide)
	frame:SetScript("OnShow", OnShow)
	frame.name = name
	
	-- This is wrapped around all the bars so we can have things "linked" together
	frame.container = CreateFrame("Frame", nil, frame)
	return frame
end

-- Updates the actual positioning of things
local function updateBar(id, row, display, config)
	local texture = SML:Fetch(SML.MediaType.STATUSBAR, config.texture)
	row:SetWidth(config.width)
	row:SetHeight(config.height)
	row:SetStatusBarTexture(texture)
	row:Hide()
	
	row.bg:SetStatusBarTexture(texture)
	
	if( config.iconPosition == "LEFT" or config.iconPosition == "RIGHT" ) then
		row.icon:SetPoint("TOPLEFT", row, "TOP" .. config.iconPosition, display.iconPad, 0)
		row.icon:SetHeight(config.height)
		row.icon:SetWidth(config.height)
		row.icon:Show()
	else
		row.icon:Hide()
	end
	
	local font = SML:Fetch(SML.MediaType.FONT, config.font)
	if( not font ) then
		font = SML:Fetch(SML.MediaType.FONt, "Friz Quadrata TT") or (GameFontNormal:GetFont())
	end
	
	row.timer:SetFont(font, config.fontSize)
	row.timer:SetShadowOffset(1, -1)
	row.timer:SetShadowColor(0, 0, 0, 1)
	row.timer:SetHeight(config.height)
	
	row.text:SetFont(font, config.fontSize)
	row.text:SetShadowOffset(1, -1)
	row.text:SetShadowColor(0, 0, 0, 1)
	row.text:SetHeight(config.height)
	row.text:SetWidth(config.width - 40)
	
	row:ClearAllPoints()
	
	-- Position
	if( id > 1 ) then
		if( not config.growUp ) then
			row:SetPoint("TOPLEFT", display.rows[id - 1], "BOTTOMLEFT", 0, -config.spacing)
		else
			row:SetPoint("TOPLEFT", display.rows[id - 1], "TOPLEFT", 0, config.height + config.spacing)
		end
	elseif( config.growUp ) then
		row:SetPoint("BOTTOMLEFT", display, "TOPLEFT", display.barOffset, 0)
	else
		row:SetPoint("TOPLEFT", display, "BOTTOMLEFT", display.barOffset, 0)
	end
end

-- Reload everything in positioning and such
function SimpleBB:ReloadBars()
	for name, config in pairs(self.db.profile.groups) do
		local display = self.groups[name]
		display:SetWidth(config.width + config.height)
		display:SetHeight(config.height)
		display:SetScale(config.scale)
		display:SetAlpha(config.alpha)
						
		OnShow(display)

		if( config.iconPosition == "LEFT" ) then
			display.iconPad = -config.height
			display.barOffset = config.height
		else
			display.iconPad = 0
			display.barOffset = 0
		end
		
		-- Update bars
		for id, row in pairs(display.rows) do
			updateBar(id, row, display, config)
		end
		
		self:UpdateDisplay(name)
	end
end

-- Bar scripts
local function OnDragStart(self)
	if( not SimpleBB.db.profile.locked ) then
		local parent = self:GetParent()
		if( parent:IsMovable() ) then
			parent:StartMoving()
			parent.isMoving = true
		end
	end
end

local function OnDragStop(self)
	local parent = self:GetParent()
	if( parent.isMoving ) then
		parent:StopMovingOrSizing()
		parent.isMoving = nil

		local scale = parent:GetEffectiveScale()
		SimpleBB.db.profile.groups[parent.name].position = { x = parent:GetLeft() * scale, y = parent:GetTop() * scale }
	end
end

local function OnClick(self, mouseButton)
	if( mouseButton ~= "RightButton" or self.data.unit ~= "player" ) then
		return
	end
	
	if( self.type == "aura" ) then
		CancelUnitBuff("player", self.data.buffIndex, self.data.filter)
	elseif( self.type == "tempEnchants" ) then
		CancelItemTempEnchantment(self.data.slotID - 15)
	elseif( self.type == "tracking" ) then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, 0, -5)
	end
end

local function OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	if( self.type == "aura" ) then
		GameTooltip:SetUnitAura(self.data.unit, self.data.buffIndex, self.data.filter)
	elseif( self.type == "tempEnchants" ) then
		GameTooltip:SetInventoryItem("player", self.data.slotID)
	elseif( self.type == "tracking" ) then
		GameTooltip:SetTracking()
	end
end

local function OnLeave(self)
	GameTooltip:Hide()
end

-- Grab a bar to use
function SimpleBB:CreateBar(parent)
	-- Create the actual bar
	local frame = CreateFrame("StatusBar", nil, parent)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", OnDragStart)
	frame:SetScript("OnDragStop", OnDragStop)
	frame:SetScript("OnMouseUp", OnClick)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:Hide()
	
	frame.bg = CreateFrame("StatusBar", nil, frame)
	frame.bg:SetMinMaxValues(0, 1)
	frame.bg:SetValue(1)
	frame.bg:SetAllPoints(frame)
	frame.bg:SetFrameLevel(0)
		
	-- Create icon
	frame.icon = frame:CreateTexture(nil, "ARTWORK")
	
	-- Icon border
	frame.iconBorder = frame:CreateTexture(nil, "OVERLAY")
	frame.iconBorder:SetPoint("TOPLEFT", frame.icon)
	frame.iconBorder:SetPoint("BOTTOMRIGHT", frame.icon)
	frame.iconBorder:Hide()
	
	-- Timer text
	frame.timer = frame:CreateFontString(nil, "OVERLAY")
	frame.timer:SetJustifyH("RIGHT")
	frame.timer:SetJustifyV("CENTER")
	frame.timer:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, 0)
	
	-- Display Text
	frame.text = frame:CreateFontString(nil, "OVERLAY")
	frame.text:SetJustifyH("LEFT")
	frame.text:SetJustifyV("CENTER")
	frame.text:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, 0)
	
	table.insert(parent.rows, frame)
	
	-- Update positioning
	updateBar(#(parent.rows), frame, parent, self.db.profile.groups[parent.name])
end

local formatTime = {
	["hhmmss"] = function(text, timeLeft)
		local hours, minutes, seconds = 0, 0, 0
		if( timeLeft >= 3600 ) then
			hours = floor(timeLeft / 3600)
			timeLeft = mod(timeLeft, 3600)
		end

		if( timeLeft >= 60 ) then
			minutes = floor(timeLeft / 60)
			timeLeft = mod(timeLeft, 60)
		end

		seconds = timeLeft > 0 and timeLeft or 0

		if( hours > 0 ) then
			text:SetFormattedText("%d:%02d:%02d", hours, minutes, seconds)
		else
			text:SetFormattedText("%02d:%02d", minutes > 0 and minutes or 0, seconds)
		end
	end,
	["blizzard"] = function(text, timeLeft)
		local hours, minutes, seconds = 0, 0, 0
		if( timeLeft >= 3600 ) then
			hours = floor(timeLeft / 3600)
			timeLeft = mod(timeLeft, 3600)
		end

		if( timeLeft >= 60 ) then
			minutes = floor(timeLeft / 60)
			timeLeft = mod(timeLeft, 60)
		end

		if( hours > 0 ) then
			text:SetFormattedText("%dh%dm", hours, minutes)
		elseif( minutes > 0 ) then
			text:SetFormattedText("%dm", minutes)
		else
			text:SetFormattedText("%ds", timeLeft > 0 and timeLeft or 0)
		end
	end,
}

-- Update visuals
local function OnUpdate(self)
	-- Time left
	local time = GetTime()
	self.secondsLeft = self.secondsLeft - (time - self.lastUpdate)
	self.lastUpdate = time
	
	self:SetValue(self.secondsLeft)
	
	formatTime[self.timeOption](self.timer, self.secondsLeft)
end

-- Update a single row
local buffTypes = {
	buff = {r = 0.30, g = 0.50, b = 1.0},
}

-- Setup a temporary table we can toss everything into
local tempRows = {}

local function updateRow(row, config, data)
	-- Set name/rank
	if( data.rank and data.stack and data.stack > 1 and config.showRank and config.showStack ) then
		if( not config.stackFirst ) then
			row.text:SetFormattedText("%s %s (%s)", data.name, data.rank, data.stack)
		else
			row.text:SetFormattedText("[%s] %s %s", data.stack, data.name, data.rank)
		end
	elseif( data.rank and config.showRank ) then
		row.text:SetFormattedText("%s %s", data.name, data.rank)
	elseif( data.stack and data.stack > 1 and config.showStack ) then
		if( not config.stackFirst ) then
			row.text:SetFormattedText("%s (%s)", data.name, data.stack)
		else
			row.text:SetFormattedText("[%s] %s", data.stack, data.name)
		end
	else
		row.text:SetText(data.name)
	end
		
	-- Set icon
	row.icon:SetWidth(config.height)
	row.icon:SetHeight(config.height)
	row.icon:SetTexture(data.icon)
	row.icon:Show()
	
	local color
	if( data.filter == "HARMFUL" ) then
		color = not config.colorByType and config.color or DebuffTypeColor[data.buffType] or DebuffTypeColor.none
		
		row.iconBorder:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		row.iconBorder:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
		row.iconBorder:SetVertexColor(color.r, color.g, color.b)
		row.iconBorder:Show()
	elseif( data.type == "tempEnchants" ) then
		color = config.tempColor
		row.iconBorder:SetTexCoord(0, 0, 0, 0)
		row.iconBorder:SetTexture("Interface\\Buttons\\UI-TempEnchant-Border")
		row.iconBorder:Show()
	elseif( data.type == "tracking" and data.trackingType ~= "spell" ) then
		color = buffTypes.buff

		row.iconBorder:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		row.iconBorder:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
		row.iconBorder:SetVertexColor(0.81, 0.81, 0.81)
		row.iconBorder:Show()
	elseif( config.colorByType ) then
		color = buffTypes.buff
		row.iconBorder:Hide()
	else
		color = config.color
		row.iconBorder:Hide()
	end
	
	-- Color bar by the debuff type
	if( color ) then
		row:SetStatusBarColor(color.r, color.g, color.b, 0.80)
		row.bg:SetStatusBarColor(color.r, color.g, color.b, 0.30)
	end

	-- Setup for sorting
	local time = GetTime()
	row.enabled = true
	row.type = data.type
	row.data = data
	row.timeOption = config.time
		
	-- Don't use an on update if it has no timer
	if( not data.untilCancelled ) then
		row.endTime = data.endTime or 0
		row.secondsLeft = row.endTime - time
		row.lastUpdate = time
		row.barWidth = config.width

		row:SetMinMaxValues(0, data.startSeconds)
		row:SetScript("OnUpdate", OnUpdate)
		row.timer:SetHeight(config.height)
		row.timer:Show()
		
		-- Do an initial timer update, this way we can get a valid timer text width
		OnUpdate(row)
		row.text:SetWidth(config.width - row.timer:GetWidth() - 5)
	else
		row:SetScript("OnUpdate", nil)
		row:SetMinMaxValues(0, 1)
		row:SetValue(config.fillTimeless and 1 or 0)
		row.text:SetWidth(config.width)
		row.timer:Hide()
	end
end

-- This is fairly ugly, I'm not exactly sure how I want to clean it up yet.
-- I think I'll go with some sort of single index I can sort by, and manipulate that based on setting
-- In fact, maybe I should turn this into a loadstring so I don't have to repeat the code, that also means
-- I don't have to load the functions when you probably won't need them 
local sorting = {
	["timeleft"] = function(a, b)
		if( not b or not a.enabled ) then
			return false
		elseif( not b.enabled ) then
			return true
		end
		
		if( a.type == "tracking" ) then
			return true
		elseif( b.type == "tracking" ) then
			return false
		end
		
		if( a.untilCancelled and b.untilCancelled ) then
			return a.name < b.name
		elseif( a.untilCancelled ) then
			return true
		elseif( b.untilCancelled ) then
			return false
		end

		if( a.type == "tempEnchants" and b.type == "tempEnchants" ) then
			return a.slotID < b.slotID
		elseif( a.type == "tempEnchants" ) then
			return true
		elseif( b.type == "tempEnchants" ) then
			return false
		end
		
		return a.endTime > b.endTime

	end,
	["index"] = function(a, b)
		if( not b or not a.enabled ) then
			return false
		elseif( not b.enabled ) then
			return true
		end
		
		if( a.type == "tracking" ) then
			return true
		elseif( b.type == "tracking" ) then
			return false
		end
		
		if( a.type == "tempEnchants" and b.type == "tempEnchants" ) then
			return a.slotID < b.slotID
		elseif( a.type == "tempEnchants" ) then
			return true
		elseif( b.type == "tempEnchants" ) then
			return false
		end
		
		return a.buffIndex < b.buffIndex
	end,
}

-- Update display for the passed time
function SimpleBB:UpdateDisplay(displayID)
	local display = self.groups[displayID]
	local buffs = self.auras[displayID]
	local config = self.db.profile.groups[displayID]

	-- Anchor disabled
	if( not self.db.profile.groups[displayID].enabled ) then
		display:Hide()
		
		for _, row in pairs(display.rows) do
			row:Hide()
		end
		return
	end

	-- Clear table
	for i=#(tempRows), 1, -1 do
		table.remove(tempRows, i)
	end
	
	-- Create auras
	for id, data in pairs(self.auras[displayID]) do
		if( data.enabled ) then
			table.insert(tempRows, data)
		end
	end

	-- Nothing to show
	if( #(tempRows) == 0 ) then
		display:Hide()
		return
	elseif( #(tempRows) > #(display.rows) ) then
		for id in pairs(tempRows) do
			if( not display.rows[id] ) then
				self:CreateBar(display)
			end
		end
	end

	display:Show()

	table.sort(tempRows, sorting[config.sortBy])
	
	-- Position
	local lastRow = 0
	for id, row in pairs(display.rows) do
		local buff = tempRows[id]
		if( buff and buff.enabled and id <= config.maxRows ) then
			updateRow(row, config, buff)
			lastRow = id
			row:Show()
		else
			row:Hide()
		end
	end
	
	-- Setup the container frame to wrap around it, so we can position other groups to it (if needed)
	if( display.rows[1] and display.rows[1]:IsVisible() ) then
		display.container:ClearAllPoints()
		
		-- When grow up, it goes from # -> 1, when not it's 1 -> #
		local firstRow = 1
		if( config.growUp ) then
			firstRow = lastRow
			lastRow = 1
		end
		
		-- Update frame size based on rows used
		if( config.iconPosition == "LEFT" ) then
			display.container:SetPoint("TOPLEFT", display.rows[firstRow].icon)
			display.container:SetPoint("BOTTOMRIGHT", display.rows[lastRow])
		elseif( config.iconPosition == "RIGHT" ) then
			display.container:SetPoint("TOPLEFT", display.rows[firstRow])
			display.container:SetPoint("BOTTOMRIGHT", display.rows[lastRow].icon)
		else
			display.container:SetPoint("TOPLEFT", display.rows[firstRow])
			display.container:SetPoint("BOTTOMRIGHT", display.rows[lastRow])
		end
	end
end

-- Update auras
function SimpleBB:UpdateAuras(group, unit, filter)
	for _, data in pairs(self.auras[group]) do if( not data.ignore ) then data.enabled = nil data.untilCancelled = nil data.type = nil end end
		
	local config = self.db.profile.groups[group]
	local time = GetTime()
	local buffID = 1
	-- We reserve the first three indexes for special buffs
	local tableID = 4
	
	while( true ) do
		local name, rank, texture, count, debuffType, duration, endTime, caster, isStealable = UnitAura(unit, buffID, filter)
		if( not name ) then break end
		
		-- Check if it's filtered
		if( ( not config.playerOnly or config.playerOnly and caster == "player" ) and ( not config.passive or config.passive and duration > 0 and endTime > 0 ) and ( not config.canFilter or not self.modules.Filters:IsFiltered(name) ) ) then			local buff = self.auras[group][tableID]
			if( not buff ) then
				self.auras[group][tableID] = {}
				buff = self.auras[group][tableID]
			end
			
			buff.enabled = true
			buff.type = "aura"
			buff.unit = unit
			buff.buffIndex = buffID
			buff.untilCancelled = duration == 0 and endTime == 0
			buff.icon = texture
			buff.buffType = debuffType
			buff.stack = count or 0
			buff.filter = filter
			buff.startSeconds = duration
			buff.endTime = endTime
			buff.name = name
			buff.rank = tonumber(string.match(rank, "(%d+)"))

			-- Grab the next table index now
			tableID = tableID + 1
		end

		buffID = buffID + 1
	end
end

-- Update player buff/debuffs
function SimpleBB:UNIT_AURA(event, unit)
	if( unit ~= playerUnit ) then
		return
	end
	
	self:UpdateAuras("buffs", unit, "HELPFUL")
	self:UpdateDisplay("buffs")

	self:UpdateAuras("debuffs", unit, "HARMFUL")
	self:UpdateDisplay("debuffs")
end

-- Find an unused index that we can hijack
function SimpleBB:FindAvailableIndex(key, type)
	local foundIndex
	local lastIndex = 0
	for index, buff in pairs(self.auras[key]) do
		if( buff.ignore ) then
			lastIndex = index
		end
		
		if( not buff.enabled and buff.type == type ) then
			foundIndex = index
			break
		end
	end
	
	-- None was created yet, so will make our own
	if( not foundIndex ) then
		lastIndex = lastIndex + 1
		self.auras[key][lastIndex] = {}
		
		return lastIndex
	end
	
	-- Return a created one
	return foundIndex
end

-- Update the players current tracked thing
function SimpleBB:UpdateTracking()
	if( not self.db.profile.showTrack ) then
		return
	end
	
	-- This prevents us from needing to search for our table every single time
	TRACKING_INDEX = TRACKING_INDEX or self:FindAvailableIndex("buffs", "tracking")
			
	-- Reset it to default in case we don't find anything
	local buff = self.auras.buffs[TRACKING_INDEX]
	buff.enabled = true
	buff.ignore = true
	buff.type = "tracking"
	buff.unit = "player"
	buff.name = L["None"]
	buff.icon = GetTrackingTexture()
	buff.trackingType = nil
	buff.untilCancelled = true
	
	-- Search for active track
	for i=1, GetNumTrackingTypes() do
		local name, icon, active, type = GetTrackingInfo(i)
		if( active ) then
			buff.name = name
			buff.icon = icon
			buff.trackingType = type
		end
	end
	
	self:UpdateDisplay("buffs")
end

function SimpleBB:PLAYER_ENTERING_WORLD()
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "CheckVehicleStatus")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "CheckVehicleStatus")
	self:RegisterEvent("MINIMAP_UPDATE_TRACKING", "UpdateTracking")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	-- Fixes Track Humanoids not being changed correctly
	if( select(2, UnitClass("player")) == "DRUID" ) then
		self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", "UpdateTracking")
	end
	
	-- Update visuals
	self:ReloadBars()
	
	-- Show temp buffs? Show our timer frame then
	if( self.db.profile.showTemp ) then
		frame:Show()
	else
		frame:Hide()
	end
	
	-- Update buffs
	self:CheckVehicleStatus()
	self:UNIT_AURA(nil, playerUnit)
	self:UpdateTracking()
end

-- Parse out name/rank from a temp weapon buff
function SimpleBB:ParseName(slotID)
	if( not self.tooltip ) then
		self.tooltip = CreateFrame("GameTooltip", "SimpleBBTooltip", UIParent, "GameTooltipTemplate")
		self.tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end
	
	self.tooltip:SetInventoryItem("player", slotID)
	
	for i=1, self.tooltip:NumLines() do
		local text = _G["SimpleBBTooltipTextLeft" .. i]:GetText()
		local name = string.match(text, "^(.+) %(%d+[^%)]+%)$")
		if( name ) then
			-- Strip any remaining brackets for things such as fishing which shows +100 Fishing as well
			name = string.gsub(name, " %(%d+[^%)]+%)", "")
			
			local tName, rank = string.match(name, "^(.*)(%w*)$")
			if( tName and rank ) then
				name = tName
			end
			
			return name, rank
		end
	end
	
	return nil, nil
end
-- Update temp weapon enchants
local function updateTemporaryEnchant(buff, slotID, tempData, hasEnchant, timeLeft, charges)
	-- If there's less than a 750 millisecond differences in the times, we don't need to bother updating.
	-- Any sort of enchant takes more than 0.750 seconds to cast so it's impossible for the user to have two
	-- temporary enchants with that little difference, as totems don't really give pulsing auras anymore.
	if( tempData.has and ( timeLeft < tempData.time and ( tempData.time - timeLeft ) < 750 ) and charges == tempData.charges ) then return false end
	if( timeLeft > tempData.time or not tempData.has ) then
		tempData.startTime = GetTime()
	end
	
	tempData.has = hasEnchant
	tempData.time = timeLeft
	tempData.charges = charges

	local name, rank = SimpleBB:ParseName(slotID)
	if( not name ) then
		buff.enabled = false
		return false
	end
	
	buff.enabled = true
	buff.ignore = true
	buff.type = "tempEnchants"
	buff.slotID = slotID
	buff.unit = "player"
	buff.name = name
	buff.rank = rank

	buff.timeLeft = timeLeft / 1000
	buff.endTime = GetTime() + buff.timeLeft
	buff.startSeconds = buff.endTime - tempData.startTime

	buff.icon = GetInventoryItemTexture("player", slotID)
	buff.stack = charges or 0
	
	return true
end

-- Update temp weapons
local timeElapsed = 0
local mainHand, offHand = {time = 0}, {time = 0}
frame:SetScript("OnUpdate", function(self, elapsed)
	timeElapsed = timeElapsed + elapsed
	if( timeElapsed < 0.50 ) then return end
	timeElapsed = timeElapsed - 0.50
	self = SimpleBB

	local hasMain, mainTimeLeft, mainCharges, hasOff, offTimeLeft, offCharges = GetWeaponEnchantInfo()
	local offUpdated, mainUpdated
	
	-- Update main hand if it's changed
	if( hasMain ) then
		MAINHAND_BUFF_INDEX = MAINHAND_BUFF_INDEX or self:FindAvailableIndex(ENCHANT_ANCHOR, "tempEnchants")
		mainUpdated = updateTemporaryEnchant(self.auras[ENCHANT_ANCHOR][MAINHAND_BUFF_INDEX], MAINHAND_SLOT, mainHand, hasMain, mainTimeLeft, mainCharges)
		mainHand.time = mainTimeLeft or 0
	elseif( mainHand.has ) then
		MAINHAND_BUFF_INDEX = MAINHAND_BUFF_INDEX or self:FindAvailableIndex(ENCHANT_ANCHOR, "tempEnchants")
		self.auras[ENCHANT_ANCHOR][MAINHAND_BUFF_INDEX].enabled = false
		mainHand.charges = -1
		mainUpdated = true
	end
	
	mainHand.has = hasMain

	-- Update off hand if it's changed
	if( hasOff ) then
		OFFHAND_BUFF_INDEX = OFFHAND_BUFF_INDEX or self:FindAvailableIndex(ENCHANT_ANCHOR, "tempEnchants")
		offUpdated = updateTemporaryEnchant(self.auras[ENCHANT_ANCHOR][OFFHAND_BUFF_INDEX], OFFHAND_SLOT, offHand, hasOff, offTimeLeft, offCharges)
	elseif( offHand.has ) then
		OFFHAND_BUFF_INDEX = OFFHAND_BUFF_INDEX or self:FindAvailableIndex(ENCHANT_ANCHOR, "tempEnchants")
		self.auras[ENCHANT_ANCHOR][OFFHAND_BUFF_INDEX].enabled = false
		offHand.charges = -1
		offUpdated = true
	end
	
	offHand.has = hasOff
	
	-- Update if needed
	if( mainUpdated or offUpdated ) then
		self:UpdateDisplay(ENCHANT_ANCHOR)
	end
end)

-- If we want a texture that was registered later after we loaded, reload the bars so it uses the correct one
function SimpleBB:ResourceRegistered(event, mediaType, key)
	if( mediaType == SML.MediaType.STATUSBAR or mediaType == SML.MediaType.FONT ) then
		for name, config in pairs(self.db.profile.groups) do
			if( config.texture == key or config.font == key ) then
				self:ReloadBars()
				return
			end
		end
	end
end

function SimpleBB:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Simple Buff Bars|r: " .. msg)
end

-- Configuration changed, update bars
local examplesShown
function SimpleBB:Reload()
	-- Example buffs
	if( self.db.profile.showExample and not examplesShown ) then
		examplesShown = true
		
		for key, group in pairs(self.db.profile.groups) do
			if( group.enabled ) then
				local index = self:FindAvailableIndex(key, "example")
				local buff = self.auras[key][index]
				
				buff.enabled = true
				buff.ignore = true
				buff.type = "example"
				buff.name = group.name
				buff.icon = "Interface\\Icons\\Spell_Nature_RemoveCurse"
				buff.stack = 3
				buff.rank = 2
				buff.timeLeft = 635
				buff.startSeconds = 700
				buff.endTime = GetTime() + buff.timeLeft
			end
		end
	-- Disable example buffs
	elseif( not self.db.profile.showExample and examplesShown ) then
		examplesShown = nil
		
		for key, group in pairs(self.db.profile.groups) do
			for _, buff in pairs(self.auras[key]) do
				if( buff.type == "example" ) then
					buff.enabled = false
				end
			end
		end
	end

	-- Hide the tracking info
	if( not self.db.profile.showTrack and TRACKING_INDEX ) then
		self.auras.buffs[TRACKING_INDEX].enabled = false
	end
	
	-- Force it to find the temp enchant indexes again in case it moved anchors
	if( MAINHAND_BUFF_INDEX ) then
		self.auras[ENCHANT_ANCHOR][MAINHAND_BUFF_INDEX].enabled = false
		self.auras[ENCHANT_ANCHOR][MAINHAND_BUFF_INDEX].ignore = false

		MAINHAND_BUFF_INDEX = nil
	end
	
	if( OFFHAND_BUFF_INDEX ) then
		self.auras[ENCHANT_ANCHOR][OFFHAND_BUFF_INDEX].enabled = false
		self.auras[ENCHANT_ANCHOR][OFFHAND_BUFF_INDEX].ignore = false

		OFFHAND_BUFF_INDEX = nil
	end
	
	-- Update temporary enchants
	if( not self.db.profile.showTemp ) then
		frame:Hide()
	else
		frame:Show()
		
		mainHand = {time = 0}
		offHand = {time = 0}
	end

	-- Check if we should swap the enchant anchor to something else
	if( self.db.profile.groups.tempEnchants.moveTo ~= "" ) then
		ENCHANT_ANCHOR = self.db.profile.groups.tempEnchants.moveTo
	else
		ENCHANT_ANCHOR = "tempEnchants"
	end
	
	-- Full bar update
	self:ReloadBars()
	self.modules.Filters:Reload()
	self.modules.Extras:Reload()
	self:UNIT_AURA(nil, playerUnit)
	self:UpdateTracking()
	self:UpdateDisplay("tempEnchants")
end

