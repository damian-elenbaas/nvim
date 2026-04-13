return {
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      require("tree-sitter-manager").setup({
        border = 'rounded',
        auto_install = true
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          pcall(vim.treesitter.start)
          vim.bo[ev.buf].syntax = 'ON'
        end,
      })
    end
  }
}
