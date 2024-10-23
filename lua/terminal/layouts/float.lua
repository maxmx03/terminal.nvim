local state = require("terminal.state")
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local M = {}

M.open_terminal = function(args)
	if state.win_id and api.nvim_win_is_valid(state.win_id) then
		return
	end

	local buffer = api.nvim_create_buf(false, true)
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

	state.win_id = api.nvim_open_win(buffer, true, config)
	api.nvim_set_option_value("winhl", "FloatBorder:NormalFloat", { win = M.win_id })
	if args == "" or args == nil then
		fn.termopen(vim.o.shell)
	else
		fn.termopen(args or vim.o.shell)
	end
	cmd.startinsert()
end

return M
