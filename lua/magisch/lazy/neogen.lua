return {
  "danymat/neogen",
  version = "*",
  cmd = "Neogen",
  keys = { { "<Leader>nf", function() require("neogen").generate() end, silent = true } },
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
  end,
}

