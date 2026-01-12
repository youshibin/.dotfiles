-- Example Plugin Configuration
-- Add your custom plugins here
-- Each file in lua/plugins/ will be automatically loaded

return {
  -- Example: Customize the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },

  -- Example: Add a custom plugin
  -- Uncomment to enable:
  -- {
  --   "folke/twilight.nvim",
  --   opts = {
  --     dimming = {
  --       alpha = 0.25,
  --     },
  --   },
  -- },

  -- Example: Customize an existing plugin
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     ensure_installed = {
  --       "bash",
  --       "html",
  --       "javascript",
  --       "json",
  --       "lua",
  --       "markdown",
  --       "markdown_inline",
  --       "python",
  --       "typescript",
  --       "vim",
  --       "yaml",
  --     },
  --   },
  -- },
}
