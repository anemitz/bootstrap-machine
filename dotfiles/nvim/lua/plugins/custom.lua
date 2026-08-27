-- ~/.config/nvim/lua/plugins/custom.lua
-- Custom plugins layered on top of LazyVim
-- LazyVim already includes: treesitter, telescope, lsp, mason, which-key,
-- neo-tree, bufferline, lualine, gitsigns, mini.*, etc.

return {
  -- === UI Cleanup ===
  { "akinsho/bufferline.nvim", enabled = false },

  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline", -- classic bottom cmdline instead of floating popup
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
      },
      lsp = {
        progress = { enabled = false },
      },
    },
  },

  -- === Tmux Integration ===
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left (tmux/vim)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down (tmux/vim)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up (tmux/vim)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (tmux/vim)" },
    },
  },

  -- === Git ===
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- === Completion: blink.cmp — use Tab to cycle/accept completions ===
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "super-tab" },
    },
  },

  -- === Surround (add/change/delete surrounding chars) ===
  -- LazyVim includes mini.surround, but if you prefer tpope-style:
  -- { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

  -- === Harpoon (quick file switching) ===
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon: add file",
      },
      {
        "<leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon: menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon: file 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon: file 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon: file 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon: file 4",
      },
    },
    opts = {},
  },

  -- === Oil.nvim (edit filesystem like a buffer) ===
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },

  -- === Trouble (better diagnostics list) ===
  -- LazyVim includes this, but ensure it's configured:
  {
    "folke/trouble.nvim",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    },
  },

  -- === Zen Mode (distraction-free writing) ===
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      window = { width = 120 },
    },
  },

  -- === Colorscheme ===
  -- LazyVim defaults to tokyonight. Other good options:
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
  -- { "rebelot/kanagawa.nvim", priority = 1000 },
  --
  -- To change: add to lua/config/lazy.lua:
  --   { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },

  -- === Language-specific (uncomment what you need) ===
  -- LazyVim has "extras" you can enable in lua/config/lazy.lua:
  --   { import = "lazyvim.plugins.extras.lang.typescript" },
  --   { import = "lazyvim.plugins.extras.lang.python" },
  --   { import = "lazyvim.plugins.extras.lang.rust" },
  --   { import = "lazyvim.plugins.extras.lang.go" },
  --   { import = "lazyvim.plugins.extras.lang.json" },
  --   { import = "lazyvim.plugins.extras.lang.yaml" },
  --   { import = "lazyvim.plugins.extras.lang.docker" },
  --   { import = "lazyvim.plugins.extras.lang.markdown" },
}
