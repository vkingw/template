# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an **AstroNvim v5+** user configuration repository. AstroNvim is a modern Neovim configuration framework that provides a solid foundation with sensible defaults and modular plugin management.

## Architecture

### Core Structure
- **`init.lua`**: Bootstrap file that installs and loads Lazy.nvim plugin manager
- **`lua/lazy_setup.lua`**: Main plugin configuration that imports AstroNvim core, community plugins, and user plugins
- **`lua/plugins/`**: Directory for user plugin configurations
- **`lua/community.lua`**: AstroCommunity plugin imports (currently disabled)
- **`lua/polish.lua`**: Post-setup configuration file with three-column layout initialization

### Three-Column Layout Architecture
- **Left Panel**: Neo-tree file explorer (30% width)
  - File navigation and project structure
  - Auto-opens on startup when no file specified
  - Follows current file automatically

- **Center Panel**: Main editing area
  - Primary workspace for file editing
  - Dynamic resizing based on side panels

- **Right Panel**: Aerial symbol outline (30% width)
  - Language server-powered symbol tree
  - Auto-opens when LSP attaches
  - Supports LSP, Treesitter, Markdown symbols

### Layout Management
- Automatic window balancing with `<leader>fw`
- Panel toggling with dedicated key mappings
- Smart auto-open behavior based on context
- Preserved layout state across sessions

### Plugin Architecture
AstroNvim uses a modular plugin system with these key components:

1. **AstroCore** (`plugins/astrocore.lua`): Core mappings, options, and features
   - Leader key: `<Space>`
   - Local leader key: `,`
   - Key mappings for buffer navigation, diagnostics, etc.

2. **AstroUI** (`plugins/astroui.lua`): User interface configuration
   - Colorscheme: `onedark` (navarasu/onedark.nvim)
   - Icon configuration and highlight overrides

3. **AstroLSP** (`plugins/astrolsp.lua`): Language server configuration
   - Format on save enabled
   - Semantic tokens enabled
   - CodeLens enabled

4. **Language Support Plugins**:
   - **Treesitter** (`plugins/treesitter.lua`): Syntax highlighting
   - **Mason** (`plugins/mason.lua`): LSP, formatter, and debugger installation
   - **None-ls** (`plugins/none-ls.lua`): Formatter and linter configuration

## Key Mappings

### Navigation
- `]b` / `[b` - Next/previous buffer
- `<Leader>bd` - Close buffer from tabline
- `<C-h>/<C-l>/<C-j>/<C-k>` - Navigate between panels

### Three-Column Layout
- `<leader>fe` - Toggle file explorer (Neo-tree)
- `<leader>fo` - Toggle outline (Aerial)
- `<leader>fw` - Balance windows
- `<leader>e` - Toggle Neo-tree (alternative)
- `<leader>o` - Toggle Aerial (alternative)
- `<leader>a` - Toggle Aerial (alternative)

### Aerial Auto-Open Behavior
- **Automatic Display**: Opens automatically when opening supported file types
- **Supported File Types**: Lua, Python, JavaScript, TypeScript, Java, Go, Rust, C/C++, PHP, Ruby, Shell scripts, JSON, YAML, Markdown, Vim, Help
- **Trigger Conditions**:
  - File type is supported
  - AND (LSP supports documentSymbol OR Treesitter is active)
  - AND Aerial is not already open
  - AND buffer is normal (not special buffer)
- **Smart Timing**: Waits for LSP to attach and symbols to load (300-500ms delay)

### LSP Mappings
- `gD` - Go to declaration
- `<Leader>uY` - Toggle LSP semantic highlighting (buffer)

## Development Workflow

### Adding New Plugins
1. Edit `lua/plugins/user.lua` (remove the `if true then return {} end` line to activate)
2. Add plugin specifications following the Lazy.nvim format
3. Run `:Lazy sync` to install

### Configuring Existing Plugins
Each plugin has its own configuration file in `lua/plugins/`:
- Remove the `if true then return {} end` line to activate the file
- Modify the `opts` table to customize settings

### Language Server Setup
1. Use `:Mason` to install language servers
2. Configure in `lua/plugins/astrolsp.lua`
3. Enable format on save and other features as needed

## Code Style

- **Lua formatting**: Stylua with 2-space indentation, 120 column width
- **Configuration**: All files use Lua tables with type annotations
- **File organization**: Modular structure with clear separation of concerns

## Theme Configuration

- **Current Theme**: `onedark` (navarasu/onedark.nvim)
- **Configuration**: Customized with italic comments, standard code styling
- **Available Styles**: dark, darker, cool, deep, warm, warmer
- **Installation**: Automatically installed via Lazy.nvim
- **Location**: Configured in `lua/plugins/astroui.lua` and `lua/plugins/user.lua`

## Common Commands

- `:Lazy` - Open plugin manager
- `:Mason` - Install LSP servers and tools
- `:LspInfo` - Show active language servers
- `:checkhealth` - Verify system health
- `:Lazy sync` - Update and sync plugins

## Important Notes

- Most configuration files are disabled by default with `if true then return {} end`
- Remove this line to activate any configuration file
- The framework prioritizes backward compatibility and stability
- All changes should maintain the modular structure and not break existing functionality