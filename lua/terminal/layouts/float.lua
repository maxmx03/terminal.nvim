local columns = vim.o.columns
local lines = vim.o.lines
local window_width = math.floor(columns * 0.7)
local window_height = math.floor(lines * 0.7)
local position_w = (columns - window_width) / 2
local position_h = (lines - window_height) / 2

---@type vim.api.keyset.win_config
local config = {
	relative = "editor",
	col = position_w,
	row = position_h,
	width = window_width,
	height = window_height,
	border = "single",
	focusable = true,
	noautocmd = true,
	style = "minimal",
}

return config
