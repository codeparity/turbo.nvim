local state = require("turbo.state")

local M = {}

local function ensure_message_buf()
  if not state.message_buf or not vim.api.nvim_buf_is_valid(state.message_buf) then
    state.message_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.message_buf].buftype = "nofile"
    vim.bo[state.message_buf].bufhidden = "hide"
    vim.bo[state.message_buf].swapfile = false

    -- Jump to file and line on Enter
    vim.keymap.set("n", "<CR>", function()
      local line = vim.api.nvim_get_current_line()
      -- Try matching: Error file line: col or file:line:col
      local file, lnum = line:match("([^:%s]+):(%d+)")
      if not file then
        file, lnum = line:match("([%w%._%-]+)%s+(%d+):")
      end
      if file and lnum then
        vim.cmd("wincmd p")
        vim.cmd(string.format("edit +%s %s", lnum, vim.fn.fnameescape(file)))
      end
    end, { buffer = state.message_buf, silent = true })

    vim.keymap.set("n", "q", function()
      M.toggle_message_win()
    end, { buffer = state.message_buf, silent = true })
  end
  return state.message_buf
end

function M.toggle_message_win()
  if state.message_win and vim.api.nvim_win_is_valid(state.message_win) then
    vim.api.nvim_win_close(state.message_win, true)
    state.message_win = nil
    return
  end

  local buf = ensure_message_buf()
  vim.cmd("botright 8split")
  state.message_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.message_win, buf)

  -- Custom Winbar for Message Window
  local width = vim.api.nvim_win_get_width(state.message_win)
  local title = " Message "
  local fill = math.max(2, math.floor((width - #title - 4) / 2))
  local left_fill = string.rep("═", fill)
  local right_fill = string.rep("═", math.max(2, width - #title - 4 - fill))
  vim.wo[state.message_win].winbar = "%#TurboFrame#╔" .. left_fill .. "%#TurboFrameTitle#" .. title .. "%#TurboFrame#" .. right_fill .. "╗"
  vim.wo[state.message_win].number = false
  vim.wo[state.message_win].relativenumber = false
end

function M.set_message_lines(lines)
  local buf = ensure_message_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  if not state.message_win or not vim.api.nvim_win_is_valid(state.message_win) then
    M.toggle_message_win()
  end
end

function M.compile_file()
  local file = vim.fn.expand("%:t")
  if not file or #file == 0 then
    file = "NONAME00.CPP"
  end

  local lines = {
    string.format("Compiling: %s", file),
  }

  -- Check LSP diagnostics
  local diags = vim.diagnostic.get(0)
  if #diags == 0 then
    table.insert(lines, "Success: 0 Errors, 0 Warnings")
    table.insert(lines, "Code: 0 bytes, Data: 0 bytes")
  else
    local errors = 0
    local warnings = 0
    for _, d in ipairs(diags) do
      local severity = (d.severity == vim.diagnostic.severity.ERROR) and "Error" or "Warning"
      if d.severity == vim.diagnostic.severity.ERROR then errors = errors + 1 else warnings = warnings + 1 end
      table.insert(lines, string.format("%s %s %d: %s", severity, file, d.lnum + 1, d.message))
    end
    table.insert(lines, string.format("Completed with %d Errors, %d Warnings", errors, warnings))
  end

  M.set_message_lines(lines)
end

function M.make_project()
  local lines = {
    "Building project via make...",
  }
  M.set_message_lines(lines)

  vim.fn.jobstart({ "make" }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, l in ipairs(data) do
          if #l > 0 then table.insert(lines, l) end
        end
        M.set_message_lines(lines)
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, l in ipairs(data) do
          if #l > 0 then table.insert(lines, l) end
        end
        M.set_message_lines(lines)
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        table.insert(lines, "Make complete: Success")
      else
        table.insert(lines, string.format("Make exited with code: %d", code))
      end
      M.set_message_lines(lines)
    end,
  })
end

function M.build_all()
  M.make_project()
end

function M.run_current()
  local file = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")

  if ext == "lua" then
    vim.cmd("source " .. vim.fn.fnameescape(file))
    vim.notify("Executed Lua file", vim.log.levels.INFO)
  elseif ext == "py" then
    vim.cmd("botright split | terminal python3 " .. vim.fn.fnameescape(file))
  elseif ext == "c" or ext == "cpp" then
    local out = vim.fn.expand("%:p:r")
    local cmd = string.format("gcc -O2 %s -o %s && %s", vim.fn.fnameescape(file), vim.fn.fnameescape(out), vim.fn.fnameescape(out))
    vim.cmd("botright split | terminal " .. cmd)
  else
    vim.cmd("botright split | terminal")
  end
end

return M
