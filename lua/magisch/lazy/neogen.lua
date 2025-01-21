return {
  "danymat/neogen",
  version = "*",
  config = function()
    require('neogen').setup {
      enabled = true,
      languages = {
        lua = {
          template = {
            annotation_convention = "emmylua" -- for a full list of annotation_conventions, see supported-languages below,
          }
        },
        cs = {
          template = {
            annotation_convention = "xmldoc" -- for a full list of annotation_conventions, see supported-languages below,
          }
        }
      }
    }

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
  end,
}

