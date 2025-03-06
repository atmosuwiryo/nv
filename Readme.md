# Neovim

A modern, feature-rich Neovim configuration focused on performance, aesthetics, and developer productivity.

## Features

- 🚀 Based on [LazyVim](https://github.com/LazyVim/LazyVim) for solid plugin management and defaults
- 🧠 AI-assisted coding with [Avante](https://github.com/yetone/avante.nvim) and GitHub Copilot
- ⚡ Fast completion with [Blink.cmp](https://github.com/saghen/blink.cmp)
- 🔍 Intelligent symbol usage tracking
- 🎨 Beautiful aesthetics with Catppuccin and TokyoNight themes
- 📊 Enhanced diagnostics with inline displays
- 📝 Robust LSP configuration
- 🔧 Optimized for performance

## Requirements

- Neovim >= 0.11.0
- A working [Rust environment](https://www.rust-lang.org/tools/install) (for building Blink.cmp)
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- (Optional) [Lazygit](https://github.com/jesseduffield/lazygit) for git integration
- (Optional) [Ripgrep](https://github.com/BurntSushi/ripgrep) for better search

## Installation

```bash
# Back up existing Neovim configuration if needed
mv ~/.config/nvim ~/.config/nvim.backup

# Clone the repository
git clone https://github.com/abzcoding/nv.git ~/.config/nvim

# Start Neovim (plugins will be automatically installed)
nvim
```

> [!IMPORTANT]
> For building blink.cmp you need a working rust environment


## Plugin Highlights

- **Avante.nvim**: AI-powered code assistance
- **Blink.cmp**: Fast completion engine
- **Symbol-usage**: Display references, definitions and implementations of document symbol
- **Markview**: Enhanced markdown viewing
- **Neotest**: Framework for running tests
- **Grapple**: Quick file navigation and bookmarking
- **Overseer.nvim**: A task runner and job management plugin for Neovim
- **Tiny-inline-diagnostic**: Improved diagnostics display
- **Bufferline.nvim**: A snazzy bufferline for Neovim
- **Lualine.nvim**: A blazing fast statusline
- **Vim-tpipeline**: Embed your vim statusline in tmux


## Customization

Most configuration can be modified by editing the Lua files in the `~/.config/nvim/lua` directory:

- `config/options.lua` - General Neovim options
- `config/keymaps.lua` - Key mappings
- `config/autocmds.lua` - Autocommands
- `plugins/*.lua` - Plugin-specific configurations

## Credits

This configuration is built upon:

- [LazyVim](https://github.com/LazyVim/LazyVim)
- And many other exceptional Neovim plugins
