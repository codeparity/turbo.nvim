# Turbo.nvim: Nostalgia UI for Neovim

A retro **Borland / Turbo C++ 3.0** style "Nostalgia UI" for Neovim. 

Designed both as an **intuitive bridge for beginners learning Vim/Neovim** and a nostalgic treat for developers who love the classic 1990s DOS aesthetic. 

Works as:
1. **A standard Neovim plugin** (`require('turbo').setup()`) that can be added to any existing config or toggled on/off with `:TurboToggle`.
2. **A zero-dependency standalone IDE** via `./turbo`, packaging an embedded Neovim binary in a sandboxed runtime.

---

## Why Nostalgia UI for Beginners?

Modal editing and command-line interfaces can be intimidating for newcomers to Vim. **Turbo.nvim** solves this by providing:
- **Always-Visible Top Menubar**: `File`, `Edit`, `Search`, `Run`, `Compile`, `Debug`, `Project`, `Options`, `Window`, `Help`.
- **Intuitive Accelerators**: Standard `Alt+<Key>` (e.g. `Alt+F`, `Alt+E`) or `F10` opens dropdown menus immediately, just like GUI desktop applications.
- **Underlined Mnemonics**: Clear visual hints for keys inside every menu (e.g., `o` for Open, `s` for Save, `x` for Exit).
- **Familiar Function Keys**: `F1` (Help), `F2` (Save), `F3` (Open), `F5` (Zoom Window), `Alt+X` (Exit).
- **Full Lazy-Nvim & Which-Key Integration**: Uses `<Space>` as leader key; pressing `<Space>` triggers interactive Which-Key menus.
- **On/Off Toggle**: Press `:TurboToggle` anytime to switch between the retro TUI and your standard Neovim interface!

---

## Installation as a Neovim Plugin

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "paw/turbo.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    theme = "gruvbox",        -- "gruvbox" (default) | "borland" | "monokai" | "mocha"
    enable_tabline = true,    -- Top nostalgic menubar
    enable_statusline = true, -- Bottom Borland statusline
    enable_winbar = true,     -- Double-line ASCII window headers (╔═[■]═ 1 ... ═[↑]═╗)
    enable_keymaps = true,    -- Alt+<Key> accelerators and F1-F10 keys
    enable_lazy_keys = true,  -- Standard lazy-nvim keymaps (<leader> = <Space>)
    enable_mouse = true,      -- Mouse click support on menus and window buttons
  },
}
```

### Plugin Commands

| Command | Description |
| :--- | :--- |
| `:TurboToggle` | Turn the Nostalgia UI on/off |
| `:TurboEnable` | Enable the Nostalgia UI |
| `:TurboDisable` | Disable the Nostalgia UI & restore original settings |
| `:TurboTheme <name>` | Switch theme (`gruvbox`, `borland`, `monokai`, `mocha`) |
| `:TurboAbout` | Display authentic Borland / Turbo C++ About dialog |
| `:TurboCompile` | Compile current file & display diagnostics in Message pane |
| `:TurboMake` | Build project via `make` |
| `:TurboRun` | Run current program |

---

## Using as a Standalone "Zero-Install" App

If you don't have Neovim installed or want a completely isolated sandboxed environment:

```bash
# Clone the repository
git clone https://github.com/paw/turbo_nvim.git
cd turbo_nvim

# Launch immediately
./turbo

# Or open a specific file
./turbo main.cpp
```

`./turbo` runs completely sandboxed:
- Embedded Neovim runtime: `vendor/nvim/usr/share/nvim/runtime`
- Isolated config: `config/turbo/`
- Isolated data & plugins: `.local/share/turbo/`
- Zero modification to your system `~/.config/nvim`.

---

## Themes

Turbo.nvim ships with four curated retro & modern palettes:
- **`gruvbox`** (**Default**): Warm retro DOS feel with Gruvbox Dark tones and yellow/red underlined accelerators.
- **`borland`**: Iconic 1990s Turbo C++ 3.0 deep blue canvas (`#0000A8`), light gray menubars, and red accelerators.
- **`monokai`**: Monokai Pro high-contrast aesthetic.
- **`mocha`**: Catppuccin Mocha modern pastel palette.

Switch themes dynamically via `Options -> Colors / Themes...` or with `:TurboTheme <name>`.

---

## Keybindings

### 1. Borland Hotkeys & Menu Accelerators

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| **`Alt+F`** | File Menu | Open File dropdown (`New`, `Open`, `Save`, `Exit`) |
| **`Alt+E`** | Edit Menu | Open Edit dropdown (`Undo`, `Cut`, `Copy`, `Paste`) |
| **`Alt+S`** | Search Menu | Open Search dropdown (`Find`, `Replace`, `LSP Definition`) |
| **`Alt+R`** | Run Menu | Run current file / project |
| **`Alt+C`** | Compile Menu | Compile file, Make project, view Message window |
| **`Alt+D`** | Debug Menu | Breakpoints, Step Over, Step Into |
| **`Alt+P`** | Project Menu | Open Directory / Project Explorer |
| **`Alt+O`** | Options Menu | Colors / Themes, Lazy Plugins, Mason Tooling |
| **`Alt+W`** | Window Menu | Tile, Zoom, Close, Message window |
| **`Alt+H`** | Help Menu | Neovim Help, About dialog |
| **`F10`** | Activate Menu | Activates top menu bar |
| **`F1`** | Help | Open help index |
| **`F2`** | Save | Save current file (`:w`) |
| **`F3`** | Open | Open file dialog |
| **`Alt+F3`** | Close Window | Close active window (`:close`) |
| **`F5`** | Zoom Window | Toggle maximize / tile on current window |
| **`F6`** | Next Window | Cycle focus to next window (`<C-w>w`) |
| **`F9`** | Make Project | Build project via `make` |
| **`Alt+F9`** | Compile File | Compile current file & show errors |
| **`Ctrl+F9`**| Run | Build and execute current program |
| **`Alt+X`** | Exit | Exit Turbo IDE (`:confirm qall`) |

### 2. Core Lazy-Nvim Keymaps (`<leader>` = `<Space>`)

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| **`<Space>`** | Which-Key | Trigger which-key popup menu |
| **`<leader>l`** | Lazy | Open Lazy plugin manager |
| **`<leader>m`** | Mason | Open Mason package manager |
| **`<leader>ff`** | Find Files | Open file picker / dialog |
| **`<leader>fg`** | Live Grep | Search across project files |
| **`<leader>e`** | Explorer | Open directory / file tree |
| **`<leader>w`** | Save File | Write current buffer |
| **`<leader>q`** | Close Window | Close current window |
| **`<leader>wm`** | Zoom Window | Toggle maximize / tile |
| **`<leader>qq`** | Quit All | Exit IDE |
| **`<C-h/j/k/l>`** | Navigate | Move focus left / down / up / right |
| **`<S-h>` / `<S-l>`** | Buffers | Previous / Next buffer |
| **`J` / `K` (Visual)** | Move Lines | Move selected lines down / up |
| **`<` / `>` (Visual)** | Indent | Indent lines while retaining selection |
| **`gd` / `K`** | LSP | Goto definition / Hover documentation |
| **`<leader>xx`** | Diagnostics | Toggle Compiler & Diagnostic Message window |

---

## Dropdown Menu Navigation

- **`<Down>` / `j`**: Next menu item (skips separators).
- **`<Up>` / `k`**: Previous menu item (skips separators).
- **`<Left>` / `h`**: Move to previous top-level menu.
- **`<Right>` / `l`**: Move to next top-level menu.
- **`<CR>` / `<Space>`**: Execute highlighted action.
- **`<Esc>`**: Close menu and return focus to editor.
- **Mnemonic keys (`o`, `s`, `x`, etc.)**: Immediately execute that action without needing to scroll.

---

## Testing

Run the automated test suite:

```bash
./turbo --headless -c "luafile tests/test_turbo.lua" -c "q"
```
