if( GetLocale() ~= "koKR" ) then
	return
end
SimpleBBLocals = setmetatable({
	["None"] = "None",

	-- GUI
	["General"] = "일반",
		
	["Show temporary weapon enchants"] = "무기강화 효과 보기",
	["Shows your current temporary weapon enchants as a buff."] = "Shows your current temporary weapon enchants as a buff.",
	
	["Enable extra units"] = "다른 유닛 사용",
	["Allows you to configure and show buff bars for target, focus and pet units.\nDisabling this will reset the anchor configuration for those three units."] = "Allows you to configure and show buff bars for target, focus and pet units.\nDisabling this will reset the anchor configuration for those three units.",
	
	["Show examples"] = "예제 보기",
	["Shows an example buff/debuff for configuration."] = "Shows an example buff/debuff for configuration.",
	
	["Show tracking"] = "추적 보기",
	["Shows your current tracking as a buff, can change trackings through this as well."] = "Shows your current tracking as a buff, can change trackings through this as well.",
	
	["Global options"] = "전체 옵션",
	["Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings.\n\nNOTE! Not all options are available, things like anchoring or hiding passive buffs are only available in the anchors own configuration."] = "Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings.\n\nNOTE! Not all options are available, things like anchoring or hiding passive buffs are only available in the anchors own configuration.",
	
	["Lock frames"] = "프레임 고정",
	["Prevents the frames from being dragged with ALT + Drag."] = "Prevents the frames from being dragged with ALT + Drag.",
	
	["Enable group"] = "사용하기",
	["Enable showing this group, if it's disabled then no timers will appear inside."] = "Enable showing this group, if it's disabled then no timers will appear inside.",
	
	["Hide buffs you didn't cast"] = "본인이 한것 외엔 숨기기",

	["Player buffs"] = "플레이어 버프",
	["Player debuffs"] = "플레이어 디버프",
	["Temporary enchants"] = "무기강화",
	["petbuffs"] = "펫 버프",
	["petdebuffs"] = "펫 디버프",
	["targetbuffs"] = "타켓 버프",
	["targetdebuffs"] = "타켓 디버프",
	["focusbuffs"] = "주시대상 버프",
	["focusdebuffs"] = "주시대상 디버프",
	
	["Anchor configuration for %ss."] = "Anchor configuration for %ss.",

	["Grow display up"] = "위로 쌓기",
	["Instead of adding everything from top to bottom, timers will be shown from bottom to top."] = "Instead of adding everything from top to bottom, timers will be shown from bottom to top.",
	
	["Display scale"] = "크기",
	["How big the actual timers should be."] = "How big the actual timers should be.",
	
	["Max timers"] = "최대 시간",
	["Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed."] = "Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed.",
	
	["Icon position"] = "아이콘 위치",
	["Right"] = "오른쪽",
	["Left"] = "왼쪽",
	
	["Bars"] = "바",
	["Height"] = "높이",
	["Width"] = "너비",
	["Texture"] = "텍스쳐",
	["Colors"] = "색상",
	
	["Color by type"] = "타입별 색상",
	["Sets the bar color to the buff type, if it's a buff light blue, temporary weapon enchants purple, debuffs will be colored by magic type, or red if none."] = "Sets the bar color to the buff type, if it's a buff light blue, temporary weapon enchants purple, debuffs will be colored by magic type, or red if none.",
	
	["Color"] = "색상",
	["Bar color and background color, if color by type is enabled then this only applies to buffs and tracking."] = "Bar color and background color, if color by type is enabled then this only applies to buffs and tracking.",
	
	["Temporary enchant colors"] = "무기강화 색상",
	["Bar and background color for temporary weapon enchants, only used if color by type is enabled."] = "Bar and background color for temporary weapon enchants, only used if color by type is enabled.",
	
	["Fill timeless buffs"] = "지속버프에 빈칸 채우기",
	["Buffs without a duration will have the status bar shown as filled in, instead of empty."] = "Buffs without a duration will have the status bar shown as filled in, instead of empty.",
	
	["Display alpha"] = "투명도",
	
	["Text"] = "글자",
	
	["Size"] = "사이즈",
	["Font"] = "폰트",
	
	["Row spacing"] = "행 간격",
	["How far apart each timer bar should be."] = "How far apart each timer bar should be.",
	
	["%s anchor configuration."] = "%s바 환경설정",
	["Hide"] = "숨김",
	
	["Anchor"] = "앵커",
	["Buffs"] = "버프",
	["Debuffs"] = "디버프",
	["Temporary enchants"] = "무기강화",
	
	["Spacing"] = "간격",
	["How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none."] = "How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none.",
	
	["Buff sorting"] = "버프 정렬",
	["Time left"] = "Time left",
	["Order gained"] = "Order gained",
	["Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added."] = "Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added.",
	
	["Hide passive buffs"] = "지속버프 숨김",
	["Hide buffs without a duration, this is only buffs and not debuffs."] = "Hide buffs without a duration, this is only buffs and not debuffs.",
	
	["Move to"] = "Move to",
	["Allows you to move the temporary weapon enchants into another anchor."] = "Allows you to move the temporary weapon enchants into another anchor.",
	
	["Anchor to"] = "Anchor to",
	["Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap."] = "Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap.",
	
	["Display"] = "Display",
	
	["Filters"] = "필터",
	["Allows you to reduce the amount of buffs that are shown by using different filters to hide things that are not relevant to your current talents.\n\nThis will filter things that are not directly related to the filter type, the Physical filter will hide things like Flametongue Totem, or Divine Spirit, while the Caster filter will hide Windfury Totem or Battle Shout."] = "Allows you to reduce the amount of buffs that are shown by using different filters to hide things that are not relevant to your current talents.\n\nThis will filter things that are not directly related to the filter type, the Physical filter will hide things like Flametongue Totem, or Divine Spirit, while the Caster filter will hide Windfury Totem or Battle Shout.",
	
	["Auto filter"] = "자동 필터",
	["Automatically enables the physical or caster filters based on talents and class."] = "Automatically enables the physical or caster filters based on talents and class.",
	
	["Physical"] = "물리",
	["Caster"] = "마법",
	["Filtering"] = "필터링",
	
	
	["Time display"] = "시계 보기",
	["HH:MM:SS"] = "HH:MM:SS",
	["Blizzard default"] = "Blizzard default",
	
	["Show stack first"] = "Show stack first",
	["Show stack size"] = "Show stack size",
	["Show spell rank"] = "Show spell rank",
}, {__index = SimpleBBLocals})