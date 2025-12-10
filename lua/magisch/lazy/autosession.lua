return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<C-s>", "<cmd>AutoSession search<cr>", desc = "Open session picker" }
  },
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Downloads", "/" },
  },
}
