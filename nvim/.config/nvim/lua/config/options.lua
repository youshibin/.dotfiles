-- Neovim Options
-- These options override LazyVim defaults

local opt = vim.opt

-- ============================================================================
-- GENERAL
-- ============================================================================
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.mouse = "a" -- Enable mouse mode

-- ============================================================================
-- APPEARANCE
-- ============================================================================
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Highlight current line
opt.signcolumn = "yes" -- Always show sign column
opt.wrap = false -- Disable line wrap
opt.termguicolors = true -- True color support

-- ============================================================================
-- INDENTATION
-- ============================================================================
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.tabstop = 2 -- Number of spaces tabs count for

-- ============================================================================
-- SEARCH
-- ============================================================================
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show search matches as you type

-- ============================================================================
-- SPLITS
-- ============================================================================
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current

-- ============================================================================
-- PERSISTENCE
-- ============================================================================
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000

-- ============================================================================
-- COMPLETION
-- ============================================================================
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10 -- Maximum number of items in popup menu

-- ============================================================================
-- PERFORMANCE
-- ============================================================================
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.timeoutlen = 300 -- Time to wait for mapped sequence
