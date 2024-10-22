local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local M = {}

M.win_id = nil

M.open_terminal = function(args)
	if M.win_id and api.nvim_win_is_valid(M.win_id) then
		M.close_terminal()
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

	M.win_id = api.nvim_open_win(buffer, true, config)
	api.nvim_set_option_value("winhl", "FloatBorder:NormalFloat", { win = M.win_id })
	if args == "" or args == nil then
		fn.termopen(vim.o.shell)
	else
		fn.termopen(args or vim.o.shell)
	end
	cmd.startinsert()
end

M.close_terminal = function()
	if M.win_id and api.nvim_win_is_valid(M.win_id) then
		api.nvim_win_close(M.win_id, true)
		M.win_id = nil
	end
end

M.setup = function() end

api.nvim_create_user_command("TermOpen", function(args)
	M.open_terminal(args.args)
end, { nargs = "?", bang = false })

api.nvim_create_user_command("TermClose", function()
	M.close_terminal()
end, { nargs = 0, bang = false })

return M
