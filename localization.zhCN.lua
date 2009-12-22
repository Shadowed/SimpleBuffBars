-- By wowui.cn
if( GetLocale() ~= "zhCN" ) then
	return
end

local SimpleBB = select(2, ...)
SimpleBB.L = setmetatable({
	["None"] = "无",

	-- GUI
	["General"] = "一般选项",
	
	["Show temporary weapon enchants"] = "显示临时武器附魔",
	["Shows your current temporary weapon enchants as a buff."] = "显示临时武器附魔.",

	["Enable extra units"] = "启用额外单位",
	["Allows you to configure and show buff bars for target, focus and pet units.\nDisabling this will reset the anchor configuration for those three units."] = "允许你配置并显示目标,焦点和宠物的Buff计时条.\n禁用此项将重置这些单位的锚点配置.",
	
	["Show examples"] = "显示示例",
	["Shows an example buff/debuff for configuration."] = "显示BUFF/DEBUFF示例.",
	
	["Show tracking"] = "显示追踪类型",
	["Shows your current tracking as a buff, can change trackings through this as well."] = "将你当前的追踪类型显示为BUFF.",
	
	["Global options"] = "全局选项",
	["Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings.\n\nNOTE! Not all options are available, things like anchoring or hiding passive buffs are only available in the anchors own configuration."] = "设置Buff和Debuff的全局显示方式,你可以在单独选项里进行分别设置.",
	
	["Lock frames"] = "锁定框体",
	["Prevents the frames from being dragged with ALT + Drag."] = "解锁框体后用ALT + 拖动来移动位置.",

	["Enable group"] = "启用分组",
	["Enable showing this group, if it's disabled then no timers will appear inside."] = "启用显示这个分组, 如果禁用将不再显示任何计时条.",

	["Hide buffs you didn't cast"] = "隐藏你不能施放的Buff",
	
	["Player buffs"] = "玩家Buff显示",
	["Player debuffs"] = "玩家Debuff显示",
	["Temporary enchants"] = "临时武器附魔",
	["petbuffs"] = "宠物buff显示",
	["petdebuffs"] = "宠物Debuff显示",
	["targetbuffs"] = "目标buff显示",
	["targetdebuffs"] = "目标Debuff显示",
	["focusbuffs"] = "焦点buff显示",
	["focusdebuffs"] = "焦点Debuff显示",
	
	["Anchor configuration for %ss."] = "锚点配置: %s.",

	["Grow display up"] = "向上增长",
	["Instead of adding everything from top to bottom, timers will be shown from bottom to top."] = "新增的Buff/Debuff向上增长.",
	
	["Display scale"] = "缩放大小",
	["How big the actual timers should be."] = "缩放大小.",
	
	["Max timers"] = "最大计时条数量",
	["Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed."] = "设置要显示的最大计时条的数量.",
	
	["Icon position"] = "法术图标位置",
	["Right"] = "右",
	["Left"] = "左",
	
	["Bars"] = "计时条",
	["Height"] = "高",
	["Width"] = "宽",
	["Texture"] = "材质",
	["Colors"] = "颜色",
	
	["Color by type"] = "按类型着色计时条",
	["Sets the bar color to the buff type, if it's a buff light blue, temporary weapon enchants purple, debuffs will be colored by magic type, or red if none."] = "按Buff和Debuff类型着色计时条.",
	
	["Color"] = "颜色",
	["Bar color and background color, if color by type is enabled then this only applies to buffs and tracking."] = "计时条和背景颜色.",

	["Temporary enchant colors"] = "临时附魔颜色",
	["Bar and background color for temporary weapon enchants, only used if color by type is enabled."] = "武器附魔BUFF的计时条和背景颜色.",
	
	["Fill timeless buffs"] = "填充无持续时间的计时条",
	["Buffs without a duration will have the status bar shown as filled in, instead of empty."] = "填充无持续时间的计时条.",
	
	["Display alpha"] = "显示透明度",
	
	["Text"] = "文字",
	
	["Size"] = "大小",
	["Font"] = "字体",
	
	["Row spacing"] = "间距",
	["How far apart each timer bar should be."] = "计时条之间的间距.",

	["%s anchor configuration."] = "%s 的锚点配置.",
	["Hide"] = "隐藏",
	
	["Anchor"] = "锚点",
	["Buffs"] = "Buff",
	["Debuffs"] = "Debuff",
	["Temporary enchants"] = "临时武器附魔",
	
	["Spacing"] = "空距",
	["How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none."] = "锚点之间的空距.",
	
	["Buff sorting"] = "Buff排序",
	["Time left"] = "按剩余时间",
	["Order gained"] = "按获得顺序",
	["Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added."] = "Buff排序信息\n按剩余时间:\n追踪类型 > 光环 > 临时武器附魔 > 按剩余时间的Buff\n\n按获得顺序:\n追踪类型 > 临时武器附魔 > 光环 > 按新增获得的Buff.",

	["Hide passive buffs"] = "隐藏被动Buffs",
	["Hide buffs without a duration, this is only buffs and not debuffs."] = "隐藏没有持续时间的被动Buffs，不包括Debuffs.",

	["Move to"] = "移动到",
	["Allows you to move the temporary weapon enchants into another anchor."] = "允许你移动临时武器附魔计时到另一个锚点内.",

	["Anchor to"] = "依附到",
	["Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap."] = "将你的锚点%ss依附到其他的锚点防止重叠.",
	
	["Display"] = "显示方式",

	["Filters"] = "过滤器",
	["Allows you to reduce the amount of buffs that are shown by using different filters to hide things that are not relevant to your current talents.\n\nThis will filter things that are not directly related to the filter type, the Physical filter will hide things like Flametongue Totem, or Divine Spirit, while the Caster filter will hide Windfury Totem or Battle Shout."] = "允许你使用不同的过滤器来根据你的当前天赋隐藏和减少显示Buff的数量.\n\n过滤器将根据过滤类型来隐藏不同的计时条,如物理过滤器将隐藏类似于火舌图腾;施法者过滤器将隐藏如风怒图腾或战斗怒吼等.",

	["Auto filter"] = "自动过滤",
	["Automatically enables the physical or caster filters based on talents and class."] = "根据天赋职业自动启用物理或者施法者过滤器.",

	["Time display"] = "时间显示",
	["HH:MM:SS"] = "HH:MM:SS",
	["Blizzard default"] = "Blizzard默认",
	
	["Show stack first"] = "优先显示堆叠",
	["Show stack size"] = "显示可堆叠数量",
	["Show spell rank"] = "显示法术等级",
}, {__index = SimpleBB.L})