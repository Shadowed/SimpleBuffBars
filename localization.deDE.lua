if( GetLocale() ~= "deDE" ) then
	return
end

SimpleBBLocals = setmetatable({
}, {__index = SimpleBBLocals})