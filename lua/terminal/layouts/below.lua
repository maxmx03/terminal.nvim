local lines = vim.o.lines
local window_height = math.floor(lines * 0.3)

---@type vim.api.keyset.win_config
local config = {
	height = window_height,
	focusable = true,
	noautocmd = true,
	style = "minimal",
	split = "below",
}

return config
