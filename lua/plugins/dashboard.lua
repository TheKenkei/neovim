return {
  "nvimdev/dashboard-nvim",
  lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  opts = function()
    local logo = [[
           ██╗  ██╗ ███████╗ ███╗   ██╗ ██╗  ██╗ ███████╗ ██╗
           ██║ ██╔╝ ██╔════╝ ████╗  ██║ ██║ ██╔╝ ██╔════╝ ██║
           █████╔╝  █████╗   ██╔██╗ ██║ █████╔╝  █████╗   ██║
           ██╔═██╗  ██╔══╝   ██║╚██╗██║ ██╔═██╗  ██╔══╝   ██║
           ██║  ██╗ ███████╗ ██║ ╚████║ ██║  ██╗ ███████╗ ██║
           ╚═╝  ╚═╝ ╚══════╝ ╚═╝  ╚═══╝ ╚═╝  ╚═╝ ╚══════╝ ╚═╝
      ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = true,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = 'Telescope find_files', desc = " Find File", icon = " ", key = "f" },
          { action = 'Telescope  live_grep', desc = " Find Text", icon = " ", key = "w" },
          { action = 'Telescope  git_files', desc = " Git files", icon = " ", key = "g" },

        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}
