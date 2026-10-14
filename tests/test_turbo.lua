-- Automated tests for Turbo IDE

local function assert_true(cond, msg)
  if not cond then
    error("Assertion failed: " .. (msg or "condition was false"))
  end
end

print("=== Running Turbo IDE Test Suite ===")

-- 1. Test Themes
print("[Test 1] Testing Theme Engine...")
local theme = require("turbo.theme")
local themes_to_test = { "gruvbox", "borland", "monokai", "mocha" }
for _, t in ipairs(themes_to_test) do
  theme.set_theme(t)
  local cur = theme.get_current()
  assert_true(cur ~= nil, "Theme " .. t .. " returned nil")
  assert_true(vim.api.nvim_get_hl(0, { name = "TurboMenuBar" }).bg ~= nil, "TurboMenuBar highlight missing for " .. t)
  assert_true(vim.api.nvim_get_hl(0, { name = "TurboMenuSelect" }).bg ~= nil, "TurboMenuSelect highlight missing for " .. t)
  print("  ✓ Theme " .. t .. " applied successfully")
end

-- Reset to default Gruvbox
theme.set_theme("gruvbox")

-- 2. Test Menus & Mnemonic Parsing
print("[Test 2] Testing Menus & Mnemonic Parsing...")
local menus = require("turbo.menus")
assert_true(#menus.items >= 8, "Expected at least 8 top-level menus, found " .. #menus.items)
for i, m in ipairs(menus.items) do
  assert_true(m.title ~= nil and #m.title > 0, "Menu " .. i .. " missing title")
  assert_true(m.mnemonic ~= nil and #m.mnemonic == 1, "Menu " .. m.title .. " missing valid mnemonic")
  assert_true(m.title:find(m.mnemonic, 1, true) ~= nil, "Mnemonic " .. m.mnemonic .. " not found in title " .. m.title)
  assert_true(#m.entries > 0, "Menu " .. m.title .. " has no entries")
  for _, e in ipairs(m.entries) do
    if not e.separator then
      assert_true(e.label ~= nil, "Entry missing label in menu " .. m.title)
      assert_true(e.action ~= nil, "Entry " .. e.label .. " missing action in menu " .. m.title)
      if e.mnemonic then
        local found = e.label:find(e.mnemonic, 1, true) or e.label:lower():find(e.mnemonic:lower(), 1, true)
        assert_true(found ~= nil, "Mnemonic " .. e.mnemonic .. " not in label " .. e.label)
      end
    end
  end
  print("  ✓ Menu " .. m.title .. " parsed (" .. #m.entries .. " entries)")
end

-- 3. Test Menubar Coordinates & Tabline
print("[Test 3] Testing Menubar Coordinates & Tabline...")
local menubar = require("turbo.ui.menubar")
local tabline_str = menubar.render()
assert_true(tabline_str:find("TurboMenuBar") ~= nil, "Tabline output missing TurboMenuBar highlight")
assert_true(tabline_str:find("≡") ~= nil, "Tabline output missing system icon ≡")
local col1 = menubar.get_menu_col(1)
local col2 = menubar.get_menu_col(2)
assert_true(col2 > col1, "Menu 2 column should be after Menu 1")
print(string.format("  ✓ Menubar columns computed: File at %d, Edit at %d", col1, col2))

-- 4. Test Dropdown Open, Shadow, and Close
print("[Test 4] Testing Dropdown & Shadow Creation...")
local dropdown = require("turbo.ui.dropdown")
local state = require("turbo.state")
dropdown.open(1)
assert_true(state.menu_open == true, "state.menu_open should be true")
assert_true(state.active_menu_idx == 1, "state.active_menu_idx should be 1")
assert_true(state.menu_win ~= nil and vim.api.nvim_win_is_valid(state.menu_win), "Dropdown menu_win is not valid")
assert_true(state.shadow_win ~= nil and vim.api.nvim_win_is_valid(state.shadow_win), "Shadow window is not valid")

local desc = dropdown.get_selected_desc()
assert_true(desc ~= nil and #desc > 0, "Selected item description should not be empty")
print("  ✓ Selected item description: " .. desc)

dropdown.close()
assert_true(state.menu_open == false, "state.menu_open should be false after close")
assert_true(state.menu_win == nil, "state.menu_win should be nil after close")
assert_true(state.shadow_win == nil, "state.shadow_win should be nil after close")
print("  ✓ Dropdown opened, drop shadow created, and closed cleanly")

-- 5. Test Statusline
print("[Test 5] Testing Statusline...")
local statusline = require("turbo.ui.statusline")
local st_normal = statusline.render()
assert_true(st_normal:find("F10") ~= nil, "Statusline missing F10 Menu")
assert_true(st_normal:find("F2") ~= nil, "Statusline missing F2 Save")

-- With menu open
dropdown.open(1)
local st_menu = statusline.render()
assert_true(st_menu:find("TurboStatusDesc") ~= nil, "Statusline missing contextual description highlight")
dropdown.close()
print("  ✓ Statusline normal and contextual tooltip verified")

-- 6. Test Winbar & Layout
print("[Test 6] Testing Window Header (Winbar) & Layout...")
local layout = require("turbo.layout")
local wb = layout.render_winbar()
assert_true(wb:find("╔═") ~= nil, "Winbar missing left double box border")
assert_true(wb:find("═╗") ~= nil, "Winbar missing right double box border")
assert_true(wb:find("%[■%]") ~= nil, "Winbar missing close button [■]")
assert_true(wb:find("%[↑%]") ~= nil, "Winbar missing zoom button [↑]")
print("  ✓ Winbar rendered: " .. wb:sub(1, 40) .. "...")

-- 7. Test Compiler & Message Window
print("[Test 7] Testing Compiler & Message Window...")
local compiler = require("turbo.compiler")
compiler.toggle_message_win()
assert_true(state.message_win ~= nil and vim.api.nvim_win_is_valid(state.message_win), "Message window should be open")
compiler.compile_file()
local lines = vim.api.nvim_buf_get_lines(state.message_buf, 0, -1, false)
assert_true(#lines > 0, "Message buffer should have compiler lines")
assert_true(lines[1]:find("Compiling:") ~= nil, "First line should be Compiling header")
compiler.toggle_message_win()
assert_true(state.message_win == nil, "Message window should be closed")
print("  ✓ Compiler message window toggled and verified")

print("\n=== ALL TESTS PASSED SUCCESSFULLY! ===")
