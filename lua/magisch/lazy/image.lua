return {
  '3rd/image.nvim',
  opts = {
    tmux_show_only_in_active_window = true,
  },
  config = function(_, opts)
    require('image').setup(opts)
    require('image').enable()
  end
}
