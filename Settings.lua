do
	local addon, namespace = ...
	_G[addon] = _G[addon] or {}
	setfenv(1, setmetatable(namespace, { __index = _G }))
end

options = {
	type = "group",
	childGroups = "tab",
	args = {},
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("Settings", options, { "settings", "config" })

if DataRegistry then
	dataobj = DataRegistry.GetDataObjectByName("Settings") or
	DataRegistry.NewDataObject("Settings", {
		type = "launcher",
		icon = [[Interface/WorldMap/Gear_64Grey]],
		})
	dataobj.OnClick = function() LibStub("AceConfigDialog-3.0"):Open("Settings") end

end
