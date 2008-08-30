-- By wowui.cn
if( GetLocale() ~= "zhCN" ) then
	return
end
SimpleBBLocals = setmetatable({
	["None"] = "无",

	-- Slash command
	["Simple Buff Bars slash commands"] = "Simple Buff Bars命令行",
	[" - ui - Opens the configuration."] = " - ui - 打开配置窗口.",
	
	-- GUI
	["General"] = "一般选项",
	
	["Show temporary weapon enchants"] = "显示临时武器附魔",
	["Shows your current temporary weapon enchants as a buff."] = "显示临时武器附魔.",
	
	["Show examples"] = "显示示例",
	["Shows an example buff/debuff for configuration."] = "显示BUFF/DEBUFF示例.",
	
	["Show tracking"] = "显示追踪类型",
	["Shows your current tracking as a buff, can change trackings through this as well."] = "将你当前的追踪类型显示为BUFF.",
	
	["Global options"] = "全局选项",
	["Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings."] = "设置Buff和Debuff的全局显示方式,你可以在单独选项里进行分别设置.(wowui.cn汉化)",
	
	["Lock frames"] = "锁定框体",
	["Prevents the frames from being dragged with ALT + Drag."] = "解锁框体后用ALT + 拖动来移动位置.",
	
	["Player buffs"] = "玩家Buff显示",
	["Player debuffs"] = "玩家Debuff显示",
	
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

	["Temporary buff color"] = "武器BUFF颜色",
	["Bar and background color for temporary weapon enchants, only used if color by type is enabled."] = "武器附魔BUFF的计时条和背景颜色.",
	
	["Fill timeless buffs"] = "填充无持续时间的计时条",
	["Buffs without a duration will have the status bar shown as filled in, instead of empty."] = "填充无持续时间的计时条.",
	
	["Display alpha"] = "显示透明度",
	
	["Text"] = "文字",
	
	["Size"] = "大小",
	["Font"] = "字体",
	
	["Row spacing"] = "间距",
	["How far apart each timer bar should be."] = "计时条之间的间距.",
	
	["Anchor"] = "锚点",
	["Buffs"] = "Buffs",
	["Debuffs"] = "Debuffs",
	
	["Spacing"] = "空距",
	["How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none."] = "锚点之间的空距.",
	
	["Buff sorting"] = "Buff排序",
	["Time left"] = "按剩余时间",
	["Order gained"] = "按获得顺序",
	["Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added."] = "Buff排序信息\n按剩余时间:\n追踪类型 > 光环 > 临时武器附魔 > 按剩余时间的Buff\n\n按获得顺序:\n追踪类型 > 临时武器附魔 > 光环 > 按新增获得的Buff.",

	["Anchor to"] = "依附到",
	["Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap."] = "将你的锚点%ss依附到其他的锚点防止重叠.",
	
	["Display"] = "显示方式",
	
	["Show stack size"] = "显示可堆叠数量",
	["Show spell rank"] = "显示法术等级",
}, {__index = SimpleBBLocals})