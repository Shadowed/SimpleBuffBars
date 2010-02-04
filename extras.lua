local SimpleBB = select(2, ...)
local Extras = SimpleBB:NewModule("Extras", "AceEvent-3.0")
local L = SimpleBB.L
local units = {["target"] = true, ["focus"] = true, ["pet"] = true}
local groups = {"targetbuffs", "targetdebuffs", "focusbuffs", "focusdebuffs", "petbuffs", "petdebuffs"}
local nameMap = {["targetbuffs"] = L["Target buffs"], ["targetdebuffs"] = L["Target debuffs"], ["focusbuffs"] = L["Focus buffs"], ["focusdebuffs"] = L["Focus debuffs"], ["petbuffs"] = L["Pet buffs"], ["petdebuffs"] = L["Pet debuffs"]}
local buffCache, debuffCache = {}, {}

function Extras:OnInitialize()
	if( SimpleBB.db.profile.showExtras ) then
		self:Enable()
	end
end

function Extras:UNIT_AURA(event, unit)
	if( not units[unit] ) then
		return
	end
	
	buffCache[unit] = buffCache[unit] or unit .. "buffs"
	debuffCache[unit] = debuffCache[unit] or unit .. "debuffs"
	
	SimpleBB:UpdateAuras(buffCache[unit], unit, "HELPFUL")
	SimpleBB:UpdateDisplay(buffCache[unit])

	SimpleBB:UpdateAuras(debuffCache[unit], unit, "HARMFUL")
	SimpleBB:UpdateDisplay(debuffCache[unit])
end

function Extras:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end

function Extras:PLAYER_PET_CHANGED()
	self:UNIT_AURA(nil, "pet")
end

function Extras:PLAYER_FOCUS_CHANGED()
	self:UNIT_AURA(nil, "focus")
end

-- Managing if it's enabled/disabled/etc
function Extras:Enable()
	if( self.enabled ) then
		return
	end
	
	self.enabled = true
	
	-- Create DB defaults
	for _, key in pairs(groups) do
		if( not SimpleBB.db.profile.groups[key] ) then
			SimpleBB.db.profile.groups[key] = CopyTable(SimpleBB.defaults.profile.anchors)
			SimpleBB.db.profile.groups[key].enabled = false
			SimpleBB.db.profile.groups[key].name = nameMap[key] or key
		end
	end
	
	-- Create groups
	SimpleBB:UpdateGroups()
	
	-- Create configuration
	self:CreateConfiguration()
	
	-- Update auras
	for unit in pairs(units) do
		self:UNIT_AURA(nil, unit)
	end
	
	-- Register events
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_PET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
end

function Extras:Disable()
	if( not self.enabled ) then
		return
	end
	
	self.enabled = nil
	
	-- Reset DB data
	for _, key in pairs(groups) do
		SimpleBB.db.profile.groups[key] = nil
		SimpleBB.groups[key]:Hide()
		
		if( SimpleBB.modules.Config.options ) then
			SimpleBB.modules.Config.options.args[key] = nil
		end
	end
		
	-- Unregister all events so it stops updating
	self:UnregisterAllEvents()
end


function Extras:Reload()
	if( SimpleBB.db.profile.showExtras ) then
		if( self.enabled ) then
			-- Update auras
			for unit in pairs(units) do
				self:UNIT_AURA(nil, unit)
			end
		end

		self:Enable()
	else
		self:Disable()
	end
end

-- Creates the configuration for these
function Extras:CreateConfiguration()
	if( not SimpleBB.db.profile.showExtras or not SimpleBB.modules.Config.options ) then
		return
	end
	
	local Config = SimpleBB.modules.Config
	for _, key in pairs(groups) do
		if( not Config.options.args[key] ) then
			Config.options.args[key] = Config:CreateGroupConfig(key, SimpleBB.db.profile.groups[key].name)
		end
	end
end

