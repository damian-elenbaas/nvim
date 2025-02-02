return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        columns = { "icon" },
        keymaps = {
          ["<M-h>"] = "actions.select_split",
          ["<CR>"] = "actions.select",
          ["<C-l>"] = "actions.refresh"
        },
        use_default_keymaps = false,
        view_options = {
          show_hidden = true,
        },
      })

      -- Open parent directory in current window
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

      -- Open parent directory in floating window
      -- vim.keymap.set("n", "<leader>e", require("oil").toggle_float)
    end,
  },
}
