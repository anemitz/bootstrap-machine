local function first_executable(candidates)
  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
end

local clangd = first_executable({
  "/opt/homebrew/opt/llvm@18/bin/clangd",
  "clangd-18",
  "clangd",
})
local clang_format = first_executable({
  "/opt/homebrew/opt/llvm@18/bin/clang-format",
  "clang-format-18",
  "clang-format",
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false,
          cmd = {
            clangd or "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          command = clang_format or "clang-format",
        },
      },
    },
  },
}
