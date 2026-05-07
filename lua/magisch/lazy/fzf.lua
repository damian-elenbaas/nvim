return {
  "ibhagwan/fzf-lua",
  enabled = false,
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "nvim-mini/mini.icons" },
  keys = {
    {
      "<leader>pf",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find files",
    },
    {
      "<C-p>",
      function()
        require("fzf-lua").vcs_files()
      end,
      desc = "Find VCS files",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>ps",
      function()
        require("fzf-lua").grep({ search = vim.fn.input("Grep > ") })
      end,
      desc = "Grep string",
    },
  },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostic disable: missing-fields
  opts = {
    "telescope"
  }
  ---@diagnostic enable: missing-fields
}
