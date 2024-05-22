return {
  "mistricky/codesnap.nvim",
  build = "make build_generator",
  keys = {
    { "<leader>cc", "<cmd>CodeSnap<cr>",     mode = "x", desc = "Save selected code snapshot into clipboard" },
    { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
  },
  opts = {
    save_path = "~/Pictures",
    has_breadcrumbs = false,
    bg_color = "#535c68",
    watermark = ""
  },
}
