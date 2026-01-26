-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration
local config = {}

-- Use config builder if available (newer versions)
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- START MAXIMIZED
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- ============================================================================
-- COLOR SCHEME
-- ============================================================================
-- Uncomment your preferred theme. These preserve your LS_COLORS for file/dir colors.
-- Try different ones and see what you like!

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Gruvbox Dark (Gogh)"
-- config.color_scheme = "Nord"
-- config.color_scheme = "Dracula"
-- config.color_scheme = "One Dark (Gogh)"
-- config.color_scheme = "3024 Night (Gogh)"
-- config.color_scheme = "3024 Night"
-- config.color_scheme = "3024 (dark) (terminal.sexy)"
-- config.color_scheme = "3024 (base16)"

-- To see all available themes, run: wezterm ls-fonts --list-schemes

-- ============================================================================
-- FONT
-- ============================================================================

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 16.0
config.line_height = 1.2

-- Enable ligatures (optional, disable if you don't like them)
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- ============================================================================
-- APPEARANCE
-- ============================================================================

-- Window appearance
-- config.window_decorations = "RESIZE" -- Hide title bar, keep resize
config.window_padding = {
	left = 16,
	right = 16,
	top = 16,
	bottom = 16,
}

-- Modern macOS window styling
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Tab bar (hidden since we're using Zellij for multiplexing)
config.enable_tab_bar = false

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 800

-- ============================================================================
-- BEHAVIOR
-- ============================================================================

-- Scrollback
config.scrollback_lines = 10000

-- Disable annoying bell
config.audible_bell = "Disabled"

-- ============================================================================
-- KEYBOARD SHORTCUTS
-- ============================================================================
-- WezTerm handles terminal emulator functions (CMD modifier)
-- Zellij handles multiplexing (tabs/panes/sessions)

config.keys = {
}

-- ============================================================================
-- MOUSE BINDINGS
-- ============================================================================

config.mouse_bindings = {
}

-- ============================================================================
-- PERFORMANCE
-- ============================================================================

config.front_end = "WebGpu"
config.max_fps = 120

-- ============================================================================
-- SHELL INTEGRATION
-- ============================================================================

-- Start with zsh
config.default_prog = { "/bin/zsh", "-l" }

-- Enable shell integration features (useful for prompts like Starship)
config.set_environment_variables = {
	TERM = "wezterm",
}

return config
