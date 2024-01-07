return {
    'norcalli/nvim-colorizer.lua',
    name = 'colorizer',
    config = function()
        local colorizer = require("colorizer")
        colorizer.setup(
            {
                '*',
                html = { mode = 'background' },
            },
            {
                mode = 'foreground'
            }
        )
    end
}
