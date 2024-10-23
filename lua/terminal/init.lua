local float = require("terminal.layouts.float")
local below = require("terminal.layouts.below")
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local M = {}

M.config = {
	layout = "float",
}

M.win_id = nil

M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

---@param value string?
---@return boolean
local function is_empty(value)
	return value == nil or value == ""
end

M.open_terminal = function(args)
	if M.win_id and api.nvim_win_is_valid(M.win_id) then
		M.close_terminal()
		return
	end

	local buffer = api.nvim_create_buf(false, true)
	local layout = M.config.layout
	local config = {}

	if is_empty(layout) then
		config = float
	elseif layout == "below" then
		config = below
	else
		config = float
	end
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

return M
