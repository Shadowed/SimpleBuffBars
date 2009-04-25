if( not SimpleBB ) then return end

local Extras = SimpleBB:NewModule("Extras", "AceEvent-3.0")
local L = SimpleBBLocals

function Extras:OnInitialize()
	if( SimpleBB.db.profile.showExtras ) then
		self:Enable()
	end
end

function Extras:Enable()
	if( self.enabled ) then
		return
	end
	
	self.enabled = true
	
	-- Create DB defaults
	self.defaults.profile.groups.target = CopyTable(self.defaults.profile.anchors)
	self.defaults.profile.groups.target.enabled = false
	self.defaults.profile.groups.target.name = L["Target"]

	self.defaults.profile.groups.focus = CopyTable(self.defaults.profile.anchors)
	self.defaults.profile.groups.focus.enabled = false
	self.defaults.profile.groups.focus.name = L["Focus"]

	self.defaults.profile.groups.pet = CopyTable(self.defaults.profile.anchors)
	self.defaults.profile.groups.pet.enabled = false
	self.defaults.profile.groups.pet.name = L["Pet"]

	-- Create configuration
	self:CreateConfiguration()
	
	-- Register events
end

function Extras:Disable()
	if( not self.enabled ) then
		return
	end
	
	self.enabled = nil
	
	-- Reset DB data
	SimpleBB.db.profile.groups.target = nil
	SimpleBB.db.profile.groups.focus = nil
	SimpleBB.db.profile.groups.pet = nil
	
	-- Remove group anchors
	SimpleBB.groups.target:Hide()
	SimpleBB.groups.target = nil
	
	SimpleBB.groups.focus:Hide()
	SimpleBB.groups.focus = nil
	
	SimpleBB.groups.pet:Hide()
	SimpleBB.groups.pet = nil
	
	-- Remove any configuration
	if( SimpleBB.modules.Config.options ) then
		local options = SimpleBB.modules.Config.options
		options.args.target = nil
		options.args.focus = nil
		options.args.pet = nil
	end
	
	-- Unregister all events so it stops updating
	self:UnregisterAllEvents()
end


function Extras:Reload()
	if( SimpleBB.db.profile.showExtras ) then
		self:Enable()
	else
		self:Disable()
	end
end

-- Creates the configuration for these
function Extras:CreateConfiguration()
	if( not SimpleBB.db.profile.showExtras or not SimpleBB.modules.Config.options or SimpleBB.modules.Config.options.args.target ) then
		return
	end
	
	local Config = SimpleBB.modules.Config
	local options = Config.options
	options.args.target = Config:CreateAnchorSettings("target", L["Target"])
	options.args.focus = Config:CreateAnchorSettings("focus", L["Focus"])
	options.args.pet = Config:CreateAnchorSettings("pet", L["Pet"])
end
