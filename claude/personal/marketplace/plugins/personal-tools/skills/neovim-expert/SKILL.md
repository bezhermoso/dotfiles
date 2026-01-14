---
name: neovim-expert
description: Neovim configuration, Lua scripting, plugin development, and advanced editing techniques. Use when working with Neovim, init.lua, or vim plugins.
---

# Neovim Expert

Expert knowledge for Neovim configuration, Lua scripting, plugin management, and advanced editing workflows.

## Configuration Architecture

### Modern Neovim Structure (Lua)

**Directory structure:**
```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Vim options
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── autocmds.lua     # Autocommands
│   │   └── lazy.lua         # Plugin manager setup
│   ├── plugins/             # Plugin configurations
│   │   ├── lsp.lua
│   │   ├── treesitter.lua
│   │   ├── telescope.lua
│   │   └── ...
│   └── utils.lua            # Utility functions
└── after/
    └── ftplugin/            # Filetype-specific config
        ├── lua.lua
        ├── python.lua
        └── ...
```

**init.lua structure:**
```lua
-- init.lua
-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugin manager (lazy.nvim)
require("config.lazy")
```

### Vim Options (options.lua)

**Essential options:**
```lua
-- lua/config/options.lua
local opt = vim.opt

-- UI
opt.number = true              -- Line numbers
opt.relativenumber = true      -- Relative line numbers
opt.cursorline = true          -- Highlight current line
opt.signcolumn = "yes"         -- Always show sign column
opt.wrap = false               -- No line wrap
opt.scrolloff = 8              -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8          -- Keep 8 columns left/right of cursor

-- Search
opt.ignorecase = true          -- Ignore case in search
opt.smartcase = true           -- Unless uppercase in search
opt.hlsearch = true            -- Highlight search results
opt.incsearch = true           -- Show matches as you type

-- Indentation
opt.expandtab = true           -- Use spaces instead of tabs
opt.shiftwidth = 2             -- Indent width
opt.tabstop = 2                -- Tab width
opt.softtabstop = 2            -- Backspace deletes indent
opt.smartindent = true         -- Smart autoindenting

-- Files
opt.backup = false             -- No backup files
opt.writebackup = false        -- No backup before overwriting
opt.swapfile = false           -- No swap files
opt.undofile = true            -- Persistent undo
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Completion
opt.completeopt = "menu,menuone,noselect"  -- Better completion

-- Splits
opt.splitright = true          -- Vertical splits to right
opt.splitbelow = true          -- Horizontal splits below

-- Performance
opt.updatetime = 250           -- Faster completion
opt.timeoutlen = 300           -- Faster key sequences
opt.lazyredraw = false         -- Don't redraw during macros (nvim handles this)

-- Mouse
opt.mouse = "a"                -- Enable mouse support

-- Clipboard
opt.clipboard = "unnamedplus"  -- Use system clipboard
```

### Key Mappings (keymaps.lua)

**Essential keymaps:**
```lua
-- lua/config/keymaps.lua
local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- Move text up/down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Clear search highlighting
keymap("n", "<Esc>", ":noh<CR>", opts)

-- Save and quit
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>Q", ":qa!<CR>", opts)

-- File explorer (netrw or file manager plugin)
keymap("n", "<leader>e", ":Explore<CR>", opts)

-- Terminal
keymap("t", "<Esc>", "<C-\\><C-n>", opts)  -- Exit terminal mode
```

## Plugin Management

### Lazy.nvim (Modern Plugin Manager)

**Installation (in init.lua or lazy.lua):**
```lua
-- lua/config/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins", {
  change_detection = {
    notify = false,  -- Don't notify on config changes
  },
})
```

**Plugin specification:**
```lua
-- lua/plugins/example.lua
return {
  "plugin/name",
  dependencies = { "required/plugin" },
  event = "VeryLazy",           -- Lazy load on VeryLazy event
  keys = {                      -- Lazy load on keymap
    { "<leader>f", ":Telescope<CR>", desc = "Find files" },
  },
  ft = { "lua", "python" },     -- Lazy load on filetype
  cmd = "CommandName",          -- Lazy load on command
  config = function()           -- Plugin configuration
    require("plugin").setup({
      -- options
    })
  end,
}
```

### Essential Plugins

**Core plugins:**
```lua
-- lua/plugins/core.lua
return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Treesitter (better syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "python", "javascript" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "tsserver" },
      })
      -- See LSP section below for full config
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    -- See completion section below for config
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", ":Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", ":Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help tags" },
    },
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto" },
      })
    end,
  },

  -- Comment.nvim
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
}
```

## LSP Configuration

### Basic LSP Setup

**Full LSP configuration:**
```lua
-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Setup mason
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "tsserver",
        "rust_analyzer",
      },
      automatic_installation = true,
    })

    -- Keymaps on LSP attach
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, silent = true, noremap = true }

      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end

    -- Capabilities (for nvim-cmp)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Configure language servers
    local servers = { "lua_ls", "pyright", "tsserver", "rust_analyzer" }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end

    -- Lua-specific config
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },  -- Recognize 'vim' global
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })
  end,
}
```

## Completion Setup

**nvim-cmp configuration:**
```lua
-- lua/plugins/completion.lua
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
}
```

## Lua Scripting

### Vim API in Lua

**Common operations:**
```lua
-- Variables
vim.g.mapleader = " "           -- Global variable
vim.b.my_var = "value"          -- Buffer variable
vim.w.my_var = "value"          -- Window variable
vim.t.my_var = "value"          -- Tab variable

-- Options
vim.opt.number = true           -- Set option
vim.opt_local.number = true     -- Buffer-local option

-- Commands
vim.cmd("command here")         -- Execute vim command
vim.cmd([[
  command1
  command2
]])                             -- Multiple commands

-- Key mappings
vim.keymap.set("n", "key", "command", { silent = true })

-- Autocommands
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Functions
local function my_function()
  -- code
end

-- Get/Set buffer content
local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "new", "lines" })

-- Get cursor position
local cursor = vim.api.nvim_win_get_cursor(0)  -- {row, col}

-- Notifications
vim.notify("Message", vim.log.levels.INFO)
```

### Plugin Development

**Basic plugin structure:**
```lua
-- lua/my-plugin/init.lua
local M = {}

M.config = {
  option1 = "default",
  option2 = false,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  -- Initialize plugin
end

function M.my_function()
  -- Plugin functionality
  print("Hello from my plugin!")
end

return M
```

**Using the plugin:**
```lua
-- In your config
require("my-plugin").setup({
  option1 = "custom",
})

-- Call function
require("my-plugin").my_function()

-- Or with keymap
vim.keymap.set("n", "<leader>mp", require("my-plugin").my_function)
```

## Performance Optimization

### Lazy Loading

**Lazy load on event:**
```lua
{
  "plugin/name",
  event = "VeryLazy",        -- Load after startup
  -- Or specific events:
  event = { "BufReadPost", "BufNewFile" },
}
```

**Lazy load on keymap:**
```lua
{
  "plugin/name",
  keys = {
    { "<leader>f", "<cmd>PluginCommand<cr>", desc = "Description" },
  },
}
```

**Lazy load on command:**
```lua
{
  "plugin/name",
  cmd = { "Command1", "Command2" },
}
```

### Startup Time Profiling

**Profile startup:**
```bash
nvim --startuptime startup.log
```

**Profile from within Neovim:**
```lua
-- Add to init.lua
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    print("⚡ Neovim loaded in " .. ms .. "ms")
  end,
})
```

## Advanced Techniques

### Autocommands

**Create autocommands:**
```lua
-- lua/config/autocmds.lua

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Auto-save on buffer leave
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.py", "*.rs" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Close certain windows with 'q'
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man", "qf" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
  end,
})
```

### Filetype-Specific Config

**Create filetype configs:**
```lua
-- after/ftplugin/python.lua
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

vim.keymap.set("n", "<leader>r", ":!python %<CR>", { buffer = true })

-- after/ftplugin/lua.lua
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
```

## Troubleshooting

### Check Health

```vim
:checkhealth
```

### LSP Debugging

```lua
-- Check LSP status
:LspInfo

-- View LSP logs
:lua vim.cmd('e' .. vim.lsp.get_log_path())

-- Enable LSP logging
vim.lsp.set_log_level("debug")
```

### Plugin Debugging

```lua
-- lazy.nvim commands
:Lazy                 -- Open plugin manager
:Lazy update          -- Update plugins
:Lazy clean           -- Remove unused plugins
:Lazy profile         -- Profile startup time
```

## Resources

- Neovim docs: `:help`
- Lua guide: `:help lua-guide`
- LSP: `:help lsp`
- API: `:help api`
- Lazy.nvim: https://github.com/folke/lazy.nvim
- Mason: https://github.com/williamboman/mason.nvim
- Kickstart.nvim: https://github.com/nvim-lua/kickstart.nvim (great starting point)
