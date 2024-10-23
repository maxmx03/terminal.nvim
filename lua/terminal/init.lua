local state = require("terminal.state")
local api = vim.api

local M = {}

M.config = {
	layout = "float",
}

M.setup = function(opts)
	local config = vim.tbl_deep_extend("force", M.config, opts or {})
	local ok, layout = pcall(require, ("terminal.layouts." .. config.layout))
	if not ok then
		vim.notify("terminal.nvim error: Invalid layout", vim.log.levels.ERROR)
		layout = require("terminal.layouts.float")
	end
	M.open_terminal = layout.open_terminal
end

M.close_terminal = function()
	if state.win_id and api.nvim_win_is_valid(state.win_id) then
		api.nvim_win_close(state.win_id, true)
		state.win_id = nil
	end
end

api.nvim_create_user_command("TermOpen", function(args)
	M.open_terminal(args.args)
end, { nargs = "?", bang = false })

api.nvim_create_user_command("TermClose", function()
	M.close_terminal()
end, { nargs = 0, bang = false })

return M
