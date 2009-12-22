-- By wowui.cn
if( GetLocale() ~= "zhTW" ) then
	return
end

local SimpleBB = select(2, ...)
SimpleBB.L = setmetatable({
	["None"] = "無",

	-- GUI
	["General"] = "壹般選項",
	
	["Show temporary weapon enchants"] = "顯示臨時武器附魔",
	["Shows your current temporary weapon enchants as a buff."] = "顯示臨時武器附魔.",

	["Enable extra units"] = "啟用額外單位",
	["Allows you to configure and show buff bars for target, focus and pet units.\nDisabling this will reset the anchor configuration for those three units."] = "允許妳配置並顯示目標,焦點和寵物的Buff計時條.\n禁用此項將重置這些單位的錨點配置.",
	
	["Show examples"] = "顯示示例",
	["Shows an example buff/debuff for configuration."] = "顯示BUFF/DEBUFF示例.",
	
	["Show tracking"] = "顯示追蹤類型",
	["Shows your current tracking as a buff, can change trackings through this as well."] = "將妳當前的追蹤類型顯示為BUFF.",
	
	["Global options"] = "全局選項",
	["Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings.\n\nNOTE! Not all options are available, things like anchoring or hiding passive buffs are only available in the anchors own configuration."] = "設置Buff和Debuff的全局顯示方式,妳可以在單獨選項裏進行分別設置.",
	
	["Lock frames"] = "鎖定框體",
	["Prevents the frames from being dragged with ALT + Drag."] = "解鎖框體後用ALT + 拖動來移動位置.",

	["Enable group"] = "啟用分組",
	["Enable showing this group, if it's disabled then no timers will appear inside."] = "啟用顯示這個分組, 如果禁用將不再顯示任何計時條.",

	["Hide buffs you didn't cast"] = "隱藏妳不能施放的Buff",
	
	["Player buffs"] = "玩家Buff顯示",
	["Player debuffs"] = "玩家Debuff顯示",
	["Temporary enchants"] = "臨時武器附魔",
	["petbuffs"] = "寵物buff顯示",
	["petdebuffs"] = "寵物Debuff顯示",
	["targetbuffs"] = "目標buff顯示",
	["targetdebuffs"] = "目標Debuff顯示",
	["focusbuffs"] = "焦點buff顯示",
	["focusdebuffs"] = "焦點Debuff顯示",
	
	["Anchor configuration for %ss."] = "錨點配置: %s.",

	["Grow display up"] = "向上增長",
	["Instead of adding everything from top to bottom, timers will be shown from bottom to top."] = "新增的Buff/Debuff向上增長.",
	
	["Display scale"] = "縮放大小",
	["How big the actual timers should be."] = "縮放大小.",
	
	["Max timers"] = "最大計時條數量",
	["Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed."] = "設置要顯示的最大計時條的數量.",
	
	["Icon position"] = "法術圖標位置",
	["Right"] = "右",
	["Left"] = "左",
	
	["Bars"] = "計時條",
	["Height"] = "高",
	["Width"] = "寬",
	["Texture"] = "材質",
	["Colors"] = "顏色",
	
	["Color by type"] = "按類型著色計時條",
	["Sets the bar color to the buff type, if it's a buff light blue, temporary weapon enchants purple, debuffs will be colored by magic type, or red if none."] = "按Buff和Debuff類型著色計時條.",
	
	["Color"] = "顏色",
	["Bar color and background color, if color by type is enabled then this only applies to buffs and tracking."] = "計時條和背景顏色.",

	["Temporary enchant colors"] = "臨時附魔顏色",
	["Bar and background color for temporary weapon enchants, only used if color by type is enabled."] = "武器附魔BUFF的計時條和背景顏色.",
	
	["Fill timeless buffs"] = "填充無持續時間的計時條",
	["Buffs without a duration will have the status bar shown as filled in, instead of empty."] = "填充無持續時間的計時條.",
	
	["Display alpha"] = "顯示透明度",
	
	["Text"] = "文字",
	
	["Size"] = "大小",
	["Font"] = "字體",
	
	["Row spacing"] = "間距",
	["How far apart each timer bar should be."] = "計時條之間的間距.",

	["%s anchor configuration."] = "%s 的錨點配置.",
	["Hide"] = "隱藏",
	
	["Anchor"] = "錨點",
	["Buffs"] = "Buff",
	["Debuffs"] = "Debuff",
	["Temporary enchants"] = "臨時武器附魔",
	
	["Spacing"] = "空距",
	["How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none."] = "錨點之間的空距.",
	
	["Buff sorting"] = "Buff排序",
	["Time left"] = "按剩余時間",
	["Order gained"] = "按獲得順序",
	["Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added."] = "Buff排序信息\n按剩余時間:\n追蹤類型 > 光環 > 臨時武器附魔 > 按剩余時間的Buff\n\n按獲得順序:\n追蹤類型 > 臨時武器附魔 > 光環 > 按新增獲得的Buff.",

	["Hide passive buffs"] = "隱藏被動Buffs",
	["Hide buffs without a duration, this is only buffs and not debuffs."] = "隱藏沒有持續時間的被動Buffs，不包括Debuffs.",

	["Move to"] = "移動到",
	["Allows you to move the temporary weapon enchants into another anchor."] = "允許妳移動臨時武器附魔計時到另壹個錨點內.",

	["Anchor to"] = "依附到",
	["Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap."] = "將妳的錨點%ss依附到其他的錨點防止重疊.",
	
	["Display"] = "顯示方式",

	["Filters"] = "過濾器",
	["Allows you to reduce the amount of buffs that are shown by using different filters to hide things that are not relevant to your current talents.\n\nThis will filter things that are not directly related to the filter type, the Physical filter will hide things like Flametongue Totem, or Divine Spirit, while the Caster filter will hide Windfury Totem or Battle Shout."] = "允許妳使用不同的過濾器來根據妳的當前天賦隱藏和減少顯示Buff的數量.\n\n過濾器將根據過濾類型來隱藏不同的計時條,如物理過濾器將隱藏類似於火舌圖騰;施法者過濾器將隱藏如風怒圖騰或戰鬥怒吼等.",

	["Auto filter"] = "自動過濾",
	["Automatically enables the physical or caster filters based on talents and class."] = "根據天賦職業自動啟用物理或者施法者過濾器.",

	["Time display"] = "時間顯示",
	["HH:MM:SS"] = "HH:MM:SS",
	["Blizzard default"] = "Blizzard默認",
	
	["Show stack first"] = "優先顯示堆疊",
	["Show stack size"] = "顯示可堆疊數量",
	["Show spell rank"] = "顯示法術等級",
}, {__index = SimpleBB.L})