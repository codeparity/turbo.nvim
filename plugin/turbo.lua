-- Neovim plugin entrypoint for Turbo Nostalgia UI

if vim.g.loaded_turbo_nvim == 1 then
  return
end
vim.g.loaded_turbo_nvim = 1

vim.api.nvim_create_user_command("TurboToggle", function()
  require("turbo").toggle()
end, { desc = "Toggle Turbo Nostalgia UI on/off" })

vim.api.nvim_create_user_command("TurboEnable", function()
  require("turbo").enable()
end, { desc = "Enable Turbo Nostalgia UI" })

vim.api.nvim_create_user_command("TurboDisable", function()
  require("turbo").disable()
end, { desc = "Disable Turbo Nostalgia UI" })

vim.api.nvim_create_user_command("TurboTheme", function(args)
  require("turbo.theme").set_theme(args.args)
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(require("turbo.theme").themes)
  end,
  desc = "Switch Turbo UI theme",
})

vim.api.nvim_create_user_command("TurboAbout", function()
  require("turbo.layout").show_about_dialog()
end, { desc = "Show Turbo C++ About Dialog" })
