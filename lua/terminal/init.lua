local float = require("terminal.layouts.float")
local below = require("terminal.layouts.below")
local state = require("terminal.state")
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local M = {}

M.config = {
	layout = "float",
	size = nil,
}

M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

---@param value string?
---@return boolean
local function is_empty(value)
	return value == nil or value == ""
end

M.open_terminal = function(args)
	if not state.buffer then
		state.buffer = api.nvim_create_buf(false, true)
	end
	local layout = M.config.layout
	local size = M.config.size
	local config = {}

	-- USER LAYOUT CONFIG
	if is_empty(layout) then
		config = float
	elseif layout == "below" then
		config = below
	else
		config = float
	end

	-- USER SIZE CONFIG
	if not is_empty(size) and type(size) == "number" then
		if layout == "below" then
			local lines = vim.o.lines
			config.height = math.floor(lines * size)
		else
			local columns = vim.o.columns
			local lines = vim.o.lines
			local window_width = math.floor(columns * size)
			local window_height = math.floor(lines * size)
			local position_w = (columns - window_width) / 2
			local position_h = (lines - window_height) / 2
			config.col = position_w
			config.row = position_h
			config.width = window_width
			config.height = window_height
		end
	end

	if state.is_hidden then
		state.win_id = api.nvim_open_win(state.buffer, true, config)
		api.nvim_set_option_value("winhl", "FloatBorder:NormalFloat", { win = state.win_id })
		cmd.startinsert()
		state.is_hidden = false
	end

	if state.win_id and api.nvim_win_is_valid(state.win_id) then
		api.nvim_set_current_win(state.win_id)
		cmd.startinsert()
		return
	end

	local ok, id = pcall(api.nvim_open_win, state.buffer, true, config)

	if not ok then
		state.buffer = api.nvim_create_buf(false, true)
		state.win_id = api.nvim_open_win(state.buffer, true, config)
	else
		state.win_id = id
	end

	api.nvim_set_option_value("winhl", "FloatBorder:NormalFloat", { win = state.win_id })
	if args == "" or args == nil then
		fn.termopen(vim.o.shell)
	else
		fn.termopen(args or vim.o.shell)
	end
	cmd.startinsert()
end

M.close_terminal = function()
	if state.win_id and api.nvim_win_is_valid(state.win_id) then
		api.nvim_win_close(state.win_id, true)
		state.win_id = nil
		state.buffer = nil
	end
end

M.hide_terminal = function()
	if state.win_id and api.nvim_win_is_valid(state.win_id) then
		state.win_id = api.nvim_win_hide(state.win_id)
		state.is_hidden = true
	end
end

return M
