return {
  'stevearc/oil.nvim',
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
    require("oil").setup({
      columns = {
        "icon",
      },
      view_options = {
        show_hidden = true,
      },
      delete_to_trash = true, -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
      -- Window-local options to use for oil buffers
      win_options = {
        winbar = "%#@attribute.builtin#%{substitute(v:lua.require('oil').get_current_dir(), '^' . $HOME, '~', '')}",
      },
    })

    vim.keymap.set("n", "<leader>e", ":Oil<CR>")
  end
}
