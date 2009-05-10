if( not SimpleBB ) then return end

local Filters = SimpleBB:NewModule("Filters", "AceEvent-3.0")
local L = SimpleBBLocals

local loadedData, loadedFilters, filteredBuffs = {}, {}, {}
local filterList = {["Caster"] = L["Caster"], ["Physical"] = L["Physical"]}
local frame
local timeElapsed = 0

-- Setup filters if needed
function Filters:OnInitialize()
	self:Reload()
end

function Filters:Reload()
	if( SimpleBB.db.profile.autoFilter ) then
		self:RegisterEvent("SPELLS_CHANGED")
		self:CheckAutoLoad()
		return
	end

	self:UnregisterEvent("SPELLS_CHANGED")
	for type, enabled in pairs(SimpleBB.db.profile.filtersEnabled) do
		if( enabled ) then
			self:Load(type)
		else
			self:Unload(type)
		end
	end
end

-- Recheck auto loading
function Filters:SPELLS_CHANGED()
	self:CheckAutoLoad()
end

function Filters:CheckAutoLoad()
	-- If they aren't at the level cap, don't do any sort of filtering
	local level = UnitLevel("player")
	if( level < MAX_PLAYER_LEVEL_TABLE[GetAccountExpansionLevel()] ) then
		return
	end
	
	-- No data yet, check again in a second
	if( not GetTalentTabInfo(1) ) then
		-- Timer already running
		if( frame and frame:IsVisible() ) then
			return
		
		-- Frame ran, but we don't have data still check again in a second
		elseif( frame ) then
			timeElapsed = 0
			frame:Show()
			return
		end
		
		frame = CreateFrame("Frame")
		frame:SetScript("OnUpdate", function(self, elapsed)
			timeElapsed = timeElapsed + elapsed
			if( timeElapsed >= 1.0 ) then
				Filters:CheckAutoLoad()
				self:Hide()
			end
		end)
		return
	end

	local class = select(2, UnitClass("player"))
	-- Always a physical class
	if( class == "WARRIOR" or class == "HUNTER" or class == "DEATHKNIGHT" or class == "ROGUE" ) then
		self:Load("Physical")
		
	-- Always a caster class
	elseif( class == "PRIEST" or class == "MAGE" or class == "WARLOCK" ) then
		self:Load("Caster")
	
	-- Can be physical or caster
	elseif( class == "SHAMAN" ) then
		-- Less than 30 points in Enhancement, load caster since enh benefits from both
		if( select(3, GetTalentTabInfo(2)) <= 30 ) then
			self:Load("Caster")
		end
	
	-- Can be physical or caster
	elseif( class == "DRUID" ) then
		-- More than 30 points in Feral
		if( select(3, GetTalentTabInfo(2)) >= 31 ) then
			self:Load("Physical")
		else
			self:Load("Caster")
		end
	
	-- Can be physical or caster
	-- My understanding, is that Prot + Ret benefit from both caster, and physical buffs
	-- so will only filter for Holy Paladins
	elseif( class == "PALADIN" ) then
		-- More than 30 points in Holy
		if( select(3, GetTalentTabInfo(1)) >= 31 ) then
			self:Load("Caster")
		end
	end
end

-- Load a filter list
function Filters:Load(type)
	if( loadedFilters[type] ) then
		return
	end

	local data = loadedData[type] or self["Load" .. type]()
	for name in pairs(data) do
		filteredBuffs[name] = true
	end
	
	loadedData[type] = data
	loadedFilters[type] = true
end

-- Unload a filter list
function Filters:Unload(type)
	if( not loadedFilters[type] ) then
		return
	end
		
	-- Remove this filters data from the list + mark it as unloaded
	for name in pairs(loadedData[type]) do
		filteredBuffs[name] = nil
	end
	
	loadedFilters[type] = nil
	
	-- Now reload the filters from the other lists
	for type in pairs(loadedFilters) do
		for name in pairs(loadedData[type]) do
			filteredBuffs[name] = true
		end
	end
end

-- Check if we should hide this buff
function Filters:IsFiltered(name)
	return filteredBuffs[name]
end

-- List of filters
function Filters:GetList()
	return filterList
end

-- Load buffs to filter out for a caster dpser
function Filters:LoadCaster()
	local list = {
		-- Horn of Winter
		[(GetSpellInfo(57623))] = true,
		-- Stoneskin
		[(GetSpellInfo(8072))] = true,
		-- Strength of Earth Totem
		[(GetSpellInfo(58643))] = true,
		-- Battle Shout
		[(GetSpellInfo(59614))] = true,
		-- Blessing of Might
		[(GetSpellInfo(56520))] = true,
		-- Greater Blessing of Might
		[(GetSpellInfo(48934))] = true,
		-- Furious Howl
		[(GetSpellInfo(59274))] = true,
		-- Abomination's Might
		[(GetSpellInfo(53136))] = true,
		-- Trueshot Aura
		[(GetSpellInfo(31519))] = true,
		-- Unleashed Rage
		[(GetSpellInfo(30805))] = true,
		-- Leader of the Pack
		[(GetSpellInfo(24932))] = true,
		-- Rampage
		[(GetSpellInfo(54475))] = true,
		-- Improved Icy Talons
		[(GetSpellInfo(55789))] = true,
		-- Windfury Totem
		[(GetSpellInfo(27621))] = true,
		-- Strength of Earth
		[(GetSpellInfo(8076))] = true,
	}
	
	return list
end 

function Filters:LoadPhysical()
	local list = {
		-- Arcane Intellect
		[(GetSpellInfo(45525))] = true,
		-- Fel Intelligence
		[(GetSpellInfo(57567))] = true,
		-- Blessing of Wisdom
		[(GetSpellInfo(56521))] = true,
		-- Greater Blessing of Wisdom
		[(GetSpellInfo(48938))] = true,
		-- Replenishment
		[(GetSpellInfo(57669))] = true,
		-- Moonkin Aura
		[(GetSpellInfo(24907))] = true,
		-- Elemental Oath
		[(GetSpellInfo(53414))] = true,
		-- Wrath of Air Totem
		[(GetSpellInfo(3738))] = true,
		-- Demonic Pact
		[(GetSpellInfo(54909))] = true,
		-- Flametongue Totem
		[(GetSpellInfo(58656))] = true,
		-- Totem of Wrath
		[(GetSpellInfo(57722))] = true,
		-- Divine Spirit
		[(GetSpellInfo(48073))] = true,
	}
	
	return list
end