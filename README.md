# Terminal

## Installation

```lua
{
    'maxmx03/terminal.nvim',
    opts = {
        layout = 'float' -- below
        size = 0.7 -- value between 0 and 1, 0.7 == 70%
    },
}
```

```vim
Plug 'maxmx03/terminal.nvim'

lua << EOF
local terminal = require('terminal')
terminal.setup({
    layout = 'float',
    size = 0.7
})
EOF
```

## Commands and Keymaps

```lua
map("n", "<f3>", "<cmd>TermOpen<cr>", { silent = true })
map("t", "<f3>", "<cmd>TermClose<cr>", { silent = true })

```

## Tips and Tricks

```lua

local api = vim.api

local runners = {
	c = function(dir)
		local root_dir = vim.fs.root(dir, {
			"makefile",
			"MakeFile",
			".clangd",
			".clang-tidy",
			".clang-format",
			"compile_commands.json",
			"compile_flags.txt",
			"configure.ac",
			"main.c",
		})
		if not root_dir then
			return
		end
		local file = vim.fn.expand("%:t")
		local program = string.format("%s/%s", root_dir, file)
		return string.format("gcc %s -o program && ./program", program)
	end,
	cpp = function(dir)
		local root_dir = vim.fs.root(dir, {
			"makefile",
			"MakeFile",
			".clangd",
			".clang-tidy",
			".clang-format",
			"compile_commands.json",
			"compile_flags.txt",
			"configure.ac",
			"main.c",
		})
		if not root_dir then
			return
		end
		local file = vim.fn.expand("%:t")
		local program = string.format("%s/%s", root_dir, file)
		return string.format("g++ %s -o program && ./program", program)
	end,
	lua = function(dir)
		local root_dir = vim.fs.root(dir, { "init.lua", "stylua.toml", ".stylua.toml" })
		if not root_dir then
			return
		end
		local file = vim.fn.expand("%:t")
		local program = string.format("%s/%s", root_dir, file)
		return string.format("luajit -b %s -X program && luajit program", program)
	end,
	python = function(dir)
		local root_dir = vim.fs.root(dir, { "main.py" })
		local file = vim.fn.expand("%:t")
		local program = string.format("%s/%s", root_dir, file)
		return string.format("python %s", program)
	end,
}

api.nvim_create_user_command("Runner", function()
	local ft = vim.bo.ft
	local dir, err, err_name = vim.uv.cwd()

	if err ~= nil or dir == nil or string.len(dir) == 0 then
		if err_name then
			local msg = string.format("Terminal-runner error: %s", err_name)
			vim.notify(msg, vim.log.levels.ERROR)
			return
		end
		vim.notify("Terminal-runner error: could not found current directory", vim.log.levels.ERROR)
		return
	end

	local runner = runners[ft]
	local arg = runner(ft)
	vim.cmd("TermOpen " .. arg)
end, { nargs = 0, bang = false })

vim.api.keyset('n', '<f4>', '<cmd>Runner<cr>', {})
```
