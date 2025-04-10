return {
  'nvim-java/nvim-java',
  filetype = { 'java' },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    require('java').setup()

    local capabilities = require('blink.cmp').get_lsp_capabilities()
    require('lspconfig').jdtls.setup({
      capabilities = capabilities,
      settings = {
        java = {
          configuration = {
            saveActions = {
              organizeImports = true,
            },
            runtimes = {
              {
                name = 'JavaSE-24',
                path = '/usr/lib/jvm/java-24-openjdk',
                default = true
              },
            },
          },
          project = {
            referencedLibraries = {
              "/usr/local/lib/java/*.jar"
            }
          }
        }
      }
    })
  end
}
