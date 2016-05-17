do
	local addon, namespace = ...
	_G[addon] = _G[addon] or {}
	setfenv(1, setmetatable(namespace, { __index = _G }))
end

local addons = {}
for name, f in LibStub("AceConfigRegistry-3.0"):IterateOptionsTables() do
	if name ~= "Settings" then
		local success, ret = pcall(f, "dialog", "Settings-0")
		if success then
			addons[name] = { [name] = ret }
		else
			geterrorhandler()(ret)
		end
	end
end

options.args.interface = {
	type = "group",
	name = "Interface Settings",
	args = {},
	plugins = addons,
}
