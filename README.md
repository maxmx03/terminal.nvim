# Terminal

![20241023_00h52m53s_grim](https://github.com/user-attachments/assets/4d9e9a72-7107-42a6-b4a2-18798c8d1946)

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
-- Open terminal in normal mode with F3
map("n", "<f3>", "<cmd>TermOpen<cr>", { silent = true })

-- Close terminal in terminal mode with F3
map("t", "<f3>", "<cmd>TermClose<cr>", { silent = true })

-- Open terminal and run a specific command (e.g., `make`) with F4
map("n", "<f4>", "<cmd>TermOpen make<cr>", { silent = true })

```


## Looking for Advanced Configuration Examples?

Check out the [Wiki](https://github.com/maxmx03/terminal.nvim/wiki)
