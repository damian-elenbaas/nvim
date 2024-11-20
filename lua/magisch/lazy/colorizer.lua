return {
  'norcalli/nvim-colorizer.lua',
  name = 'colorizer',
  config = function()
    local colorizer = require("colorizer")
    colorizer.setup(
      {
        'html',
        'css',
        'razor'
      },
      {
        mode = 'background'
      }
    )
  end
}
