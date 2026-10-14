local M = {}

M.active_theme = "gruvbox"
M.active_menu_idx = nil
M.menu_open = false
M.menu_win = nil
M.menu_buf = nil
M.shadow_win = nil
M.shadow_buf = nil
M.prev_win = nil
M.is_zoomed = false
M.zoom_saved_layout = nil
M.message_win = nil
M.message_buf = nil

return M
