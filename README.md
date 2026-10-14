# Turbo C++ 3.0 / Borland IDE for Neovim (`turbo_nvim`)

A retro **Borland / Turbo C++ 3.0** style Text User Interface (TUI) and complete IDE package for Neovim. 

Delivers the iconic 1990s DOS aesthetic (double-line ASCII boxes, drop shadows, top menubar with underlined mnemonics, bottom hotkey bar, and compiler message pane) combined with modern IDE features: **Lazy.nvim** plugin ecosystem, **Which-Key.nvim**, **LSP diagnostics**, and **Treesitter syntax highlighting**.

Default theme: **Gruvbox Dark**, with instant switching to **Borland Classic (DOS Blue)**, **Monokai Pro**, and **Catppuccin Mocha**.

---

## Highlights

- **Embedded & Portable**: Contains an embedded Neovim binary and runtime inside `vendor/nvim/` and `bin/nvim`. Runs out of the box with `./turbo` without requiring or modifying system Neovim configs.
- **Clean Top Menubar & Underlined Mnemonics**:
  - `≡ File Edit Search Run Compile Debug Project Options Window Help`.
  - Mnemonic accelerator characters are distinctively underlined (e.g. `~F~ile`, `~E~dit`).
  - Open any menu directly with **`Alt+<Key>`** (e.g. `Alt+F`, `Alt+E`, `Alt+C`) or **`F10`**.
  - Mouse click support: click any menu title or `≡` system box.
- **Authentic Floating Dropdowns with Drop Shadows**:
  - Double-line box-drawing borders (`╔═╗`, `║ ║`, `╚═╝`).
  - True 1990s DOS **drop-shadow** effect behind menus.
  - Arrow key navigation (`Up`/`Down`, `Left`/`Right` to switch menus) or instant trigger by typing the underlined mnemonic key (e.g., `o` for Open, `s` for Save, `x` for Exit).
- **Standard Lazy-Nvim Core Keymaps (<leader> = Space)**:
  - Full compatibility with core LazyVim keymaps.
  - **Which-Key** included out-of-the-box (`<leader>?` or pressing `<leader>`).
  - Seamless window navigation (`<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`), buffer cycling (`<S-h>`, `<S-l>`), and visual line movement (`J`/`K`).
- **Borland Window Frames (`winbar`)**:
  - `╔═[■]════ 1 NONAME00.CPP ════[↑]═╗` with window numbering, close button `[■]`, and zoom button `[↑]`.
- **Bottom Status & Hotkey Bar**:
  - Shows classic Borland shortcuts: `F1 Help │ F2 Save │ F3 Open │ Alt-F9 Compile │ F9 Make │ F10 Menu`.
  - Dynamically switches to display item descriptions when browsing menus!
- **Compiler Message Window**:
  - Bottom split window (`Window -> Message` or `F9 Make` / `Alt+F9 Compile`).
  - Displays compilation results and LSP diagnostic errors with `<CR>` jump-to-error.
- **Theme Presets**:
  - `Gruvbox Dark` (**Default**)
  - `Borland Classic` (Iconic `#0000A8` DOS Blue)
  - `Monokai Pro`
  - `Catppuccin Mocha`
  - Switch anytime via `Options -> Colors / Themes...` or `:TurboTheme <name>`.

---

## Quick Start

Launch the standalone IDE directly:

```bash
# Launch with welcome scratchpad
./turbo

# Or open an existing file
./turbo main.cpp
```

### Self-Contained Isolation
`./turbo` runs completely sandboxed:
- Neovim runtime: `vendor/nvim/usr/share/nvim/runtime`
- Config directory: `config/turbo`
- Data / Plugins / State: `.local/share/turbo` and `.local/state/turbo`
- Never touches or conflicts with your host `~/.config/nvim`.

---

## Keybindings Reference

### 1. Core Lazy-Nvim Keymaps (`<leader>` = `<Space>`)

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| **`<Space>`** | Which-Key | Trigger which-key popup menu |
| **`<leader>l` / `<leader>L`** | Lazy | Open Lazy plugin manager |
| **`<leader>m` / `<leader>cm`**| Mason | Open Mason package manager |
| **`<leader>ff`** | Find Files | Open file picker / dialog |
| **`<leader>fg` / `<leader>/`**| Live Grep | Search across project files |
| **`<leader>e` / `<leader>fe`**| Explorer | Open directory / file tree |
| **`<leader>fn`** | New File | Open new buffer |
| **`<leader>w` / `<leader>fs`**| Save File | Write current buffer |
| **`<leader>q` / `<leader>wd`**| Close Window | Close current window |
| **`<leader>wm`** | Zoom Window | Toggle maximize / tile |
| **`<leader>qq`** | Quit All | Exit IDE |
| **`<C-h/j/k/l>`** | Navigate | Move focus left / down / up / right |
| **`<S-h>` / `<S-l>`** | Buffers | Previous / Next buffer |
| **`[b` / `]b`** | Buffers | Previous / Next buffer |
| **`J` / `K` (Visual)** | Move Lines | Move selected lines down / up |
| **`<` / `>` (Visual)** | Indent | Indent lines while retaining selection |
| **`gd` / `K`** | LSP | Goto definition / Hover documentation |
| **`<leader>ca`** | Code Action | LSP code actions |
| **`<leader>cr`** | Rename | LSP rename symbol |
| **`<leader>xx`** | Diagnostics | Toggle Compiler & Diagnostic Message window |

---

### 2. Classic Borland Keybindings

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

---

## Navigation Inside Dropdowns

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
