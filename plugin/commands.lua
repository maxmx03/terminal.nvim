local terminal = require("terminal")
local api = vim.api

api.nvim_create_user_command("TermOpen", function(args)
	terminal.open_terminal(args.args)
end, { nargs = "?", bang = false })

api.nvim_create_user_command("TermClose", function()
	terminal.close_terminal()
end, { nargs = 0, bang = false })
