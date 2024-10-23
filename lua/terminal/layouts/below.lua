local state = require("terminal.state")
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local M = {}

M.open_terminal = function(args)
	if state.win_id and api.nvim_win_is_valid(state.win_id) then
		M.close_terminal()
		return
	end

	local buffer = api.nvim_create_buf(false, true)
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
