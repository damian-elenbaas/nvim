return {
  "sotte/presenting.nvim",
  opts = {
    -- see :help Presenting.config
    configure_slide_buffer = function(buf)
      -- Same as the plugin's default buffer setup
      vim.bo[buf].buftype = "nofile"
      vim.bo[buf].filetype = Presenting._state.filetype
      vim.bo[buf].bufhidden = "wipe"
      vim.bo[buf].modifiable = false

      -- Wrap on word boundaries instead of mid-word
      local win = vim.fn.bufwinid(buf)
      vim.wo[win].wrap = true
      vim.wo[win].linebreak = true
      vim.wo[win].breakindent = true
    end,
  },
  cmd = { "Presenting" },
}
