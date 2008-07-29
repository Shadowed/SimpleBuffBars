--[[ 
	Simple Buff Bars, Mayen/Amarand (Horde) from Icecrown (US) PvE
]]

SimpleBB = LibStub("AceAddon-3.0"):NewAddon("SimpleBB", "AceEvent-3.0", "AceBucket-3.0")

local L = SimpleBBLocals

local SML, MAINHAND_SLOT, OFFHAND_SLOT

function SimpleBB:OnInitialize()
	self.defaults = {
		profile = {
			locked = false,
			showTrack = true,
			showTemp = true,
			showExample = false,
			
			groups = {
				buffs = {
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
				},
				debuffs = {
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
					showStack = true,
					anchorTo = "buffs",
					anchorSpacing = 10,
					
					font = "Friz Quadrata TT",
					fontSize = 12,
				},
			},
		},
	}

	self.db = LibStub:GetLibrary("AceDB-3.0"):New("SimpleBBDB", self.defaults)

	self.revision = tonumber(string.match("$Revision: 811 $", "(%d+)") or 1)
	
	SML = LibStub:GetLibrary("LibSharedMedia-3.0")
	SML.RegisterCallback(self, "LibSharedMedia_Registered", "TextureRegistered")
		
	-- Player buff/debuff rows
	self.buffs = {}
	self.debuffs = {}
	self.activeTrack = {untilCanceled = true, type = "tracking"}
	self.tempBuffs = {[1] = {}, [2] = {}}
	
	self.groups = {}
	for name in pairs(self.db.profile.groups) do
		self.groups[name] = self:CreateGroup(name)
		self.groups[name].rows = {}
	end
	
	-- Setup the SlotIDs for Mainhand/Offhands
	MAINHAND_SLOT = GetInventorySlotInfo("MainHandSlot")
	OFFHAND_SLOT = GetInventorySlotInfo("SecondaryHandSlot")
	
	-- Kill Blizzards buff frame
	BuffFrame:UnregisterEvent("PLAYER_AURAS_CHANGED")
	TemporaryEnchantFrame:Hide()
	BuffFrame:Hide()
	
	-- Force a buff check, and update the bar display
	self:RegisterEvent("PLAYER_ENTERING_WORLD", function(self)
		self = SimpleBB
		self:UnregisterEvent("PLAYER_ENTEIRNG_WORLD")
		self:RegisterEvent("PLAYER_AURAS_CHANGED")
		self:RegisterBucketEvent("UNIT_PORTRAIT_UPDATE", 0.25, "UpdateWeapons")
		self:RegisterBucketEvent("UNIT_INVENTORY_CHANGED", 0.25, "UpdateWeapons")
		self:RegisterEvent("MINIMAP_UPDATE_TRACKING", "UpdateTracking")

		self:ReloadBars()

		self:PLAYER_AURAS_CHANGED()
		self:UpdateWeapons()
		self:UpdateTracking()
	end)
end

-- If we want a texture that was registered later after we loaded, reload the bars so it uses the correct one
function SimpleBB:TextureRegistered(event, mediaType, key)
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
function SimpleBB:Reload()
	if( not self.db.profile.showTrack ) then
		self.activeTrack.name = nil
	end
	
	if( not self.db.profile.showTemp ) then
		self.tempBuffs[1].enabled = nil
		self.tempBuffs[2].enabled = nil
	end
	
	self:ReloadBars()

	self:PLAYER_AURAS_CHANGED()
	self:UpdateWeapons()
	self:UpdateTracking()
	
	self:UpdateDisplay("buffs")
	self:UpdateDisplay("debuffs")
end

-- BAR MANAGEMENT
local function OnShow(self)
	local config = SimpleBB.db.profile.groups[self.name]
	if( config.anchorTo and config.anchorTo ~= self.name and SimpleBB.groups[config.anchorTo] ) then
		local spacing = config.anchorSpacing
		if( SimpleBB.db.profile.groups[config.anchorTo].growUp ) then
			spacing = config.anchorSpacing
		end
		
		self:SetPoint("TOPLEFT", SimpleBB.groups[config.anchorTo].container, "BOTTOMLEFT", 0, spacing)
		self:SetMovable(false)
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
end

local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 0.80,
		insets = {left = 1, right = 1, top = 1, bottom = 1}}

function SimpleBB:CreateGroup(name)
	-- Set defaults
	local frame = CreateFrame("Frame")
	frame:SetMovable(true)
	frame:SetScript("OnShow", OnShow)
	frame:Hide()
	frame.name = name
	
	-- This is wrapped around all the bars so we can have things "linked" together
	frame.container = CreateFrame("Frame", nil, frame)
	
	return frame
end

-- Updates the actual positioning of things
local function updateBar(row, group, config)
	local texture = SML:Fetch(SML.MediaType.STATUSBAR, config.texture)
	row:SetWidth(config.width)
	row:SetHeight(config.height)
	row:SetStatusBarTexture(texture)
	row:Hide()
	
	row.bg:SetStatusBarTexture(texture)
	
	if( not config.colorByType ) then
		row:SetStatusBarColor(config.color.r, config.color.g, config.color.b, 0.80)
		row.bg:SetStatusBarColor(config.color.r, config.color.g, config.color.b, 0.30)
	end
	
	row.icon:SetPoint("TOPLEFT", row, "TOP" .. config.iconPosition, group.iconPad, 0)
	row.icon:SetHeight(config.height)
	row.icon:SetWidth(config.height)
	
	local font = SML:Fetch(SML.MediaType.FONT, config.font)
	row.timer:SetFont(font, config.fontSize)
	row.timer:SetShadowOffset(1, -1)
	row.timer:SetShadowColor(0, 0, 0, 1)
	row.timer:SetHeight(config.height)
	
	row.text:SetFont(font, config.fontSize)
	row.text:SetShadowOffset(1, -1)
	row.text:SetShadowColor(0, 0, 0, 1)
	row.text:SetHeight(config.height)
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
		for _, row in pairs(display.rows) do
			updateBar(row, display, config)
		end
	end
end

-- Bar scripts
local function OnDragStart(self)
	if( IsAltKeyDown() and not SimpleBB.db.profile.locked ) then
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
		
		if( parent.queueUpdate ) then
			parent.queueUpdate = nil
			
			SimpleBB:UpdateDisplay("buffs")
			SimpleBB:UpdateDisplay("debuffs")
		end
	end
end

local function OnClick(self, mouseButton)
	if( mouseButton ~= "RightButton" ) then
		return
	end
	
	if( self.type == "buffs" or self.type == "debuffs" ) then
		CancelPlayerBuff(self.data.buffIndex)
	elseif( self.type == "tempBuffs" ) then
		CancelItemTempEnchantment(self.data.slotID - 15)
	elseif( self.type == "tracking" ) then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, 0, -5)
	end
end

local function OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	if( self.type == "buffs" or self.type == "debuffs" ) then
		GameTooltip:SetPlayerBuff(self.data.buffIndex)
	elseif( self.type == "tempBuffs" ) then
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
	
	-- Update positioning
	updateBar(frame, parent, self.db.profile.groups[parent.name])
	
	return frame
end

-- Update visuals
local function OnUpdate(self)
	--Once WoTLK hits, will switch to using this system.
	--local time = GetTime()
	--self.secondsLeft = self.secondsLeft - (time - self.lastUpdate)
	--self.lastUpdate = time
	
	if( self.type == "buffs" or self.type == "debuffs" ) then
		self.secondsLeft = GetPlayerBuffTimeLeft(self.data.buffIndex)
	elseif( self.type == "tempBuff" and self.data.slotID == 17 ) then
		self.secondsLeft = (select(4, GetWeaponEnchantInfo()) or 0) / 1000
	elseif( self.type == "tempBuff" and self.data.slotID == 16 ) then
		self.secondsLeft = (select(2, GetWeaponEnchantInfo()) or 0) / 1000
	end
	
	-- Timer text, need to see if this can be optimized a bit later
	--[[
	local hour = floor(self.secondsLeft / 3600)
	local minutes = self.secondsLeft - (hour * 3600)
	minutes = floor(minutes / 60)
	
	local seconds = self.secondsLeft - ((hour * 3600) + (minutes * 60))
	]]

	local hours, minutes, seconds = 0, 0, 0
	local timeLeft = self.secondsLeft
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
		self.timer:SetFormattedText("%d:%02d:%02d", hours, minutes, seconds)
	else
		self.timer:SetFormattedText("%02d:%02d", minutes > 0 and minutes or 0, seconds)
	end

	self:SetValue(self.secondsLeft)
end

-- Update a single row
local buffTypes = {
	buff = {r = 0.30, g = 0.50, b = 1.0},
}

local function updateRow(row, config, data)
	-- Set name/rank
	if( data.rank and data.stack and data.stack > 1 and config.showRank and config.showStack ) then
		row.text:SetFormattedText("%s %s (%s)", data.name, data.rank, data.stack)
	elseif( data.rank and config.showRank ) then
		row.text:SetFormattedText("%s %s", data.name, data.rank)
	elseif( data.stack and data.stack > 1 and config.showStack ) then
		row.text:SetFormattedText("%s (%s)", data.name, data.stack)
	else
		row.text:SetText(data.name)
	end
	
	-- Set icon
	row.icon:SetWidth(config.height)
	row.icon:SetHeight(config.height)
	row.icon:SetTexture(data.icon)
	row.icon:Show()
	
	local color
	if( data.type == "tempBuffs" ) then
		color = config.tempColor
		row.iconBorder:SetTexture("Interface\\Buttons\\UI-TempEnchant-Border")
		row.iconBorder:Show()
	elseif( data.type == "debuffs" or data.buffIndex == -1 ) then
		color = DebuffTypeColor[data.buffType] or DebuffTypeColor.none

		row.iconBorder:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		row.iconBorder:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
		row.iconBorder:SetVertexColor(color.r, color.g, color.b)
		row.iconBorder:Show()
	elseif( data.type == "tracking" and data.trackingType ~= "spell" ) then
		color = buffTypes.buff

		row.iconBorder:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		row.iconBorder:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
		row.iconBorder:SetVertexColor(0.81, 0.81, 0.81)
		row.iconBorder:Show()
	else
		color = buffTypes.buff
		row.iconBorder:Hide()
	end
	
	-- Color bar by the debuff type
	if( color and config.colorByType ) then
		row:SetStatusBarColor(color.r, color.g, color.b, 0.80)
		row.bg:SetStatusBarColor(color.r, color.g, color.b, 0.30)
	end

	-- Setup for sorting
	local time = GetTime()
	row.enabled = true
	row.type = data.type
	row.data = data
	
	-- Don't use an on update if it has no timer
	if( not data.untilCanceled ) then
		row.secondsLeft = data.endTime - time
		row.endTime = data.endTime or 0
		row.lastUpdate = time

		row:SetMinMaxValues(0, data.startSeconds)
		row:SetScript("OnUpdate", OnUpdate)
		row.timer:Show()
	else
		row.endTime = 0
		
		row:SetScript("OnUpdate", nil)
		row:SetMinMaxValues(0, 1)
		row:SetValue(config.fillTimeless and 1 or 0)
		row.timer:Hide()
	end
end

-- Sort rows
local function sortRows(a, b)
	if( not a.enabled ) then
		return false
	elseif( not b.enabled ) then
		return true
	end
	
	if( a.data.type == "tracking" ) then
		return true
	elseif( b.data.type == "tracking" ) then
		return false
	end
	
	if( a.data.untilCanceled and b.data.untilCanceled ) then
		return a.data.name < b.data.name
	end
	
	return a.sortID > b.sortID
end

-- Update display for the passed time
function SimpleBB:UpdateDisplay(displayID)
	local display = self.groups[displayID]
	local buffs = self[displayID]
	local config = self.db.profile.groups[displayID]
	
	-- If we're in the process of moving the frame, stop updating until it's done to prevent any issues
	if( display.isMoving ) then
		display.queueUpdate = true
		return
	end
	
	-- Reset all rows quickly
	for _, row in pairs(display.rows) do
		row.enabled = nil
		row.data = nil
		
		row:ClearAllPoints()
		row:Hide()
	end
	
	-- Create buffs
	local buffID = 1
	for id, data in pairs(self[displayID]) do
		if( data.enabled ) then
			if( not display.rows[buffID] ) then
				display.rows[buffID] = self:CreateBar(display)
			end

			local row = display.rows[buffID]
			updateRow(row, config, data)

			if( data.untilCanceled ) then
				row.sortID = string.format("8%s", data.name)
			else
				row.sortID = string.format("6%s", row.endTime)
			end

			buffID = buffID + 1
		end
	end
	
	-- Merge temp weapon enchants and tracking into buffs
	if( displayID == "buffs") then
		-- Tracking
		if( self.activeTrack.name ) then
			if( not display.rows[buffID] ) then
				display.rows[buffID] = self:CreateBar(display)
			end

			local row = display.rows[buffID]
			updateRow(row, config, self.activeTrack)
			buffID = buffID + 1
		end

		-- Temp weapon enchants
		for id, data in pairs(self.tempBuffs) do
			if( data.enabled ) then
				if( not display.rows[buffID] ) then
					display.rows[buffID] = self:CreateBar(display)
				end

				local row = display.rows[buffID]
				updateRow(row, config, data)

				row.sortID = string.format("7%s", row.endTime)
				buffID = buffID + 1
			end
		end
	end
	
	-- Example for congiration
	if( self.db.profile.showExample ) then
		if( not display.rows[buffID] ) then
			display.rows[buffID] = self:CreateBar(display)
		end

		local row = display.rows[buffID]
		updateRow(row, config, self.example[displayID])
		
		row.sortID = string.format("%s", self.example[displayID].endTime)
		buffID = buffID + 1
	end
	
	-- Nothing to show
	if( buffID == 1 ) then
		display:Hide()
		return
	end
	
	display:Show()
	
	-- Sort
	table.sort(display.rows, sortRows)
	
	-- Position
	local lastRow = 0
	for id, row in pairs(display.rows) do
		if( row.enabled and id <= config.maxRows ) then
			-- Position
			if( id > 1 ) then
				if( not config.growUp ) then
					row:SetPoint("TOPLEFT", display.rows[id - 1], "BOTTOMLEFT", 0, -config.spacing)
				else
					row:SetPoint("BOTTOMLEFT", display.rows[id - 1], "TOPLEFT", 0, config.spacing)
				end
			elseif( config.growUp ) then
				row:SetPoint("BOTTOMLEFT", display, "TOPLEFT", display.barOffset, 0)
			else
				row:SetPoint("TOPLEFT", display, "BOTTOMLEFT", display.barOffset, 0)
			end
			
			lastRow = id
			row:Show()
		else
			row:Hide()
		end
	end
	
	-- Setup the container frame to wrap around it, so we can position other groups to it (if needed)
	if( display.rows[1] and display.rows[1]:IsVisible() ) then
		display.container:ClearAllPoints()
		
		-- Update frame size based on rows used
		if( config.iconPosition == "LEFT" ) then
			display.container:SetPoint("TOPLEFT", display.rows[1].icon)
			display.container:SetPoint("BOTTOMRIGHT", display.rows[lastRow])
		else
			display.container:SetPoint("TOPLEFT", display.rows[1])
			display.container:SetPoint("BOTTOMRIGHT", display.rows[lastRow].icon)
		end
	end
end

-- Get the start seconds of this buff/debuff/ect
local buffTimes = {buffs = {}, debuffs = {}, tempBuffs = {}}
function SimpleBB:GetStartTime(type, name, rank, timeLeft)
	if( not name ) then
		return timeLeft
	end
	
	local bID = name .. (rank or "")
	if( buffTimes[type][bID] ) then
		if( timeLeft < buffTimes[type][bID] ) then
			timeLeft = buffTimes[type][bID]
		else
			buffTimes[type][bID] = timeLeft
		end
	else
		buffTimes[type][bID] = timeLeft
	end
		
	return timeLeft
end

-- Update auras
function SimpleBB:UpdateAuras(type, filter)
	for _, data in pairs(self[type]) do data.enabled = nil; data.untilCanceled = nil; end
		
	local buffID = 1
	while( true ) do
		local buffIndex, untilCanceled = GetPlayerBuff(buffID, filter)
		if( buffIndex == 0 ) then break end
		
		if( not self[type][buffID] ) then
			self[type][buffID] = {}
		end
		
		local name, rank = GetPlayerBuffName(buffIndex)
		
		local buff = self[type][buffID]
		buff.enabled = true
		buff.type = type
		buff.buffIndex = buffIndex
		buff.untilCanceled = (untilCanceled == 1)
		buff.icon = GetPlayerBuffTexture(buffIndex)
		buff.buffType = GetPlayerBuffDispelType(buffIndex)
		buff.stack = GetPlayerBuffApplications(buffIndex) or 0
		buff.timeLeft = GetPlayerBuffTimeLeft(buffIndex)
		buff.startSeconds = self:GetStartTime(type, name, rank, buff.timeLeft)
		buff.endTime = GetTime() + buff.timeLeft
		buff.name = name
		buff.rank = tonumber(string.match(rank, "(%d+)"))
		
		buffID = buffID + 1
	end
end

function SimpleBB:UpdateTracking()
	if( not self.db.profile.showTrack ) then
		return
	end
	
	self.activeTrack.name = nil
	
	for i=1, GetNumTrackingTypes() do
		local name, texture, active, type = GetTrackingInfo(i)
		if( active ) then
			self.activeTrack.name = name
			self.activeTrack.icon = texture
			self.activeTrack.trackingType = type
		end
	end
	
	if( not self.activeTrack.name ) then
		self.activeTrack.name = L["None"]
		self.activeTrack.icon = GetTrackingTexture()
		self.activeTrack.trackingType = nil
	end
	
	self:UpdateDisplay("buffs")
end

-- Parse out name/rank from a temp weapon buff
function SimpleBB:ParseName(slotID)
	if( not self.tooltip ) then
		self.tooltip = CreateFrame("GameTooltip", "SimpleBBTooltip", UIParent, "GameTooltipTemplate")
		self.tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end
	
	self.tooltip:SetInventoryItem("player", slotID)
	
	for i=1, self.tooltip:NumLines() do
		local text = getglobal("SimpleBBTooltipTextLeft" .. i):GetText()
		local name = string.match(text, "^(.+) %(%d+ [^%)]+%)$")
		if( name ) then
			local tName, rank = string.match(name, "^(.+) ([0-9]+)$")
			if( tName and rank ) then
				name = tName
			end
			
			return name, rank
		end
	end
	
	return nil, nil
end

-- Update temp weapon enchants
function SimpleBB:UpdateTempEnchant(id, slotID, hasEnchant, timeLeft, charges)
	if( not hasEnchant ) then
		self.tempBuffs[id].enabled = nil
		self.tempBuffs[id].untilCanceled = nil
		return
	end
	
	local name, rank = self:ParseName(slotID)
	local tempBuff = self.tempBuffs[id]
	-- When the players entering/leaving the world, we get a bad return on the name/rank
	-- So we only update it if we found one, and thus fixes it!
	if( name ) then
		tempBuff.name = name
		tempBuff.rank = rank
	end

	local timeLeft = timeLeft / 1000

	tempBuff.enabled = true
	tempBuff.type = "tempBuffs"
	tempBuff.slotID = slotID

	tempBuff.timeLeft = timeLeft
	tempBuff.endTime = GetTime() + timeLeft
	tempBuff.startSeconds = self:GetStartTime("tempBuffs", name, rank, timeLeft)

	tempBuff.icon = GetInventoryItemTexture("player", slotID)
	tempBuff.stack = charges or 0
end

function SimpleBB:UpdateWeapons()
	if( not self.db.profile.showTemp ) then
		return
	end
	
	local hasMain, mainTimeLeft, mainCharges, hasOff, offTimeLeft, offCharges = GetWeaponEnchantInfo()
	
	self:UpdateTempEnchant(1, MAINHAND_SLOT, hasMain, mainTimeLeft, mainCharges)
	if( self.tempBuffs[1].enabled ) then
		self:UpdateTempEnchant(2, OFFHAND_SLOT, hasOff, offTimeLeft, offCharges)
	else
		self:UpdateTempEnchant(1, OFFHAND_SLOT, hasOff, offTimeLeft, offCharges)
	end

	-- Update if needed
	if( self.tempBuffs[1].enabled or self.tempBuffs[2].enabled ) then
		self:UpdateDisplay("buffs")
	end
end

-- Update player buff/debuffs
function SimpleBB:PLAYER_AURAS_CHANGED()
	self:UpdateAuras("buffs", "HELPFUL|PASSIVE")
	self:UpdateAuras("debuffs", "HARMFUL")
	
	self:UpdateDisplay("buffs")
	self:UpdateDisplay("debuffs")
end
