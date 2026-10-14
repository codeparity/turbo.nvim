# 🚀 turbo.nvim

[![Neovim](https://img.shields.io/badge/Neovim-0.9+-57A143?logo=neovim&logoColor=white)](https://neovim.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Iconic Borland / Turbo C++ 3.0 "Nostalgia UI" for Neovim.**  
> Designed as an **intuitive bridge for beginners** learning Vim/Neovim, and a nostalgic treat for developers who love the classic 1990s DOS aesthetic.

```
 ≡  File  Edit  Search  Run  Compile  Debug  Project  Options  Window  Help 
╔═[■]══════════════════════════ 1 main.c ════════════════════════════[↑]═╗
║ #include <stdio.h>                                                     ║
║                                                                        ║
║ int main(void) {                                                       ║
║     printf("Hello from Turbo C++ 3.0 Nostalgia UI!\n");                ║
║     return 0;                                                          ║
║ }                                                                      ║
╚════════════════════════════════════════════════════════════════════════╝
 F1 Help │ F2 Save │ F3 Open │ Alt+F9 Compile │ F9 Make │ Alt+X Exit      
```

---

## ✨ Features

- 🏛️ **Classic Top Menubar**: `File`, `Edit`, `Search`, `Run`, `Compile`, `Debug`, `Project`, `Options`, `Window`, `Help`.
- ⚡ **Intuitive Accelerators**: `Alt+F`, `Alt+E`, `Alt+S`, etc. or `F10` opens dropdown menus immediately, just like GUI desktop applications.
- 🎯 **Underlined Mnemonics**: Clear visual hints for keys inside every menu (e.g., `o` for Open, `s` for Save, `x` for Exit).
- ⌨️ **Standard Function Keys**: `F1` (Help), `F2` (Save), `F3` (Open), `F5` (Zoom Window), `F6` (Next Window), `Alt+X` (Exit).
- 🌲 **Modern File Browser Integration**: `File -> Open...` (`F3`) opens **Neo-tree** (with automatic fallback to `NERDTree`, `Snacks`, or `Telescope`).
- 🛠️ **Universal LSP Support**: Toolbar functions (`Format`, `Code Action`, `Definition`, `References`, `Symbols`) adapt automatically to any active Language Server (`clangd`, `pyright`, `rust-analyzer`, `vtsls`, `gopls`, etc.).
- 📟 **Retro Message Window**: `:TurboCompile` / `Alt+F9` collects LSP diagnostics into a retro DOS split window. Press `<CR>` on any error to jump directly to code.
- 🎨 **Adaptive Color Engine**: Respects your existing colorscheme without imposing background colors, or switch to iconic DOS Blue (`:TurboTheme borland`), Gruvbox, Monokai, or Mocha.
- 🔄 **Non-Destructive On/Off Toggle**: Press `:TurboToggle` anytime to seamlessly switch between the retro TUI and your regular Neovim interface.
- 📦 **Standalone Launcher**: Includes `./turbo` to launch an isolated, sandboxed environment without altering your system config.

---

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "codeparity/turbo.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    theme = "auto",           -- "auto" (respects your colorscheme) | "gruvbox" | "borland" | "monokai" | "mocha"
    enable_tabline = true,    -- Top Turbo menubar
    enable_statusline = true, -- Bottom Borland statusline (auto-disabled if lualine is active)
    enable_winbar = true,     -- Double-line ASCII window headers (╔═[■]═ 1 ... ═[↑]═╗)
    enable_keymaps = true,    -- Alt+<Key> accelerators and F1-F10 keys
    enable_mouse = true,      -- Mouse click support on menus and window buttons
    enable_lazy_keys = false, -- Set true if you want Turbo to map <leader> = <Space> shortcuts
  },
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "codeparity/turbo.nvim",
  config = function()
    require("turbo").setup()
  end,
})
```

---

## 🕹️ Standalone Sandbox Launcher

Don't want to touch your existing Neovim config? You can run Turbo as a standalone sandboxed app:

```bash
# Clone the repository
git clone https://github.com/codeparity/turbo.nvim.git
cd turbo.nvim

# Launch immediately
./turbo

# Or open a specific file
./turbo main.c
```

`./turbo` runs completely isolated:
- Isolated config: `config/turbo/`
- Isolated state & plugins: `.local/share/turbo/`
- Zero modification to your personal `~/.config/nvim`.

---

## ⌨️ Keybindings

### Borland Hotkeys & Menu Accelerators

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| **`Alt+F`** | File Menu | Open File dropdown (`New`, `Open`, `Save`, `Exit`) |
| **`Alt+E`** | Edit Menu | Open Edit dropdown (`Undo`, `Cut`, `Copy`, `Paste`, `Format`) |
| **`Alt+S`** | Search Menu | Open Search dropdown (`Find`, `Replace`, `Definition`, `References`) |
| **`Alt+R`** | Run Menu | Run current file / project |
| **`Alt+C`** | Compile Menu | Compile file, Make project, view Message window |
| **`Alt+D`** | Debug Menu | Breakpoints, Step Over, Step Into |
| **`Alt+P`** | Project Menu | Open Directory / Project Explorer (Neo-tree) |
| **`Alt+O`** | Options Menu | Colors / Themes, Lazy Plugins, Mason Tooling |
| **`Alt+W`** | Window Menu | Tile, Zoom, Close, Message window |
| **`Alt+H`** | Help Menu | Neovim Help, About dialog |
| **`F10`** | Activate Menu | Activates top menu bar |
| **`F1`** | Help | Open help index |
| **`F2`** | Save | Save current file (`:w`) |
| **`F3`** | Open | Open file browser (Neo-tree / Telescope / Snacks) |
| **`Alt+F3`** | Close Window | Close active window (`:close`) |
| **`F5`** | Zoom Window | Toggle maximize / tile on current window |
| **`F6`** | Next Window | Cycle focus to next window (`<C-w>w`) |
| **`F9`** | Make Project | Build project via `make` |
| **`Alt+F9`** | Compile File | Compile current file & show errors in Message pane |
| **`Ctrl+F9`**| Run | Build and execute current program |
| **`Alt+X`** | Exit | Exit IDE (`:confirm qall`) |

### Dropdown Navigation

- **`<Down>` / `j`**: Next menu item (skips separators).
- **`<Up>` / `k`**: Previous menu item (skips separators).
- **`<Left>` / `h`**: Move to previous top-level menu.
- **`<Right>` / `l`**: Move to next top-level menu.
- **`<CR>` / `<Space>`**: Execute highlighted action.
- **`<Esc>`**: Close menu and return focus to editor.
- **Mnemonic keys (`o`, `s`, `x`, etc.)**: Immediately execute that action without needing to scroll.

---

## 📟 Plugin Commands

| Command | Description |
| :--- | :--- |
| `:TurboToggle` | Toggle Nostalgia UI on/off |
| `:TurboEnable` | Enable Nostalgia UI |
| `:TurboDisable` | Disable Nostalgia UI and restore previous settings |
| `:TurboTheme <name>` | Switch theme (`auto`, `gruvbox`, `borland`, `monokai`, `mocha`) |
| `:TurboAbout` | Display authentic Borland / Turbo C++ About dialog |
| `:TurboCompile` | Collect LSP diagnostics into the retro Message pane |
| `:TurboMake` | Build project via `make` |
| `:TurboRun` | Run current program |

---

## 🎨 Themes

- **`auto`** (**Default**): Dynamically derives UI highlights from your active colorscheme (Gruvbox, Tokyonight, Catppuccin, Nord, etc.) without imposing background colors.
- **`borland`**: Authentic 1990s Turbo C++ 3.0 deep DOS blue canvas (`#0000A8`), light gray menubar, and red accelerators.
- **`gruvbox`**: Warm retro DOS aesthetic with Gruvbox dark tones.
- **`monokai`**: Monokai Pro high-contrast aesthetic.
- **`mocha`**: Catppuccin Mocha pastel palette.

Switch themes anytime via `Options -> Colors / Themes...` or `:TurboTheme <name>`.

---

## 🧪 Testing

Run the automated headless test suite:

```bash
VIMRUNTIME=/path/to/nvim/runtime nvim --headless -u NONE -c "set rtp+=." -c "luafile tests/test_turbo.lua" -c "qa!"
```

---

## 📄 License

[MIT](LICENSE) © 2026 Ashish aka Paw (codeparity)
