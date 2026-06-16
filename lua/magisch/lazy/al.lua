return {
  "abonckus/al.nvim",
  dependencies = {
    "nvim-neotest/nvim-nio",
  },
  config = function(_, opts)
    local lsp = require("al.lsp")
    local cfg = require("al.config")
    local original_find_lsp_path = lsp.find_lsp_path

    lsp.find_lsp_path = function(basePath, is_dll)
      local os_name = vim.loop.os_uname().sysname:lower()
      if not os_name:match("darwin") then
        return original_find_lsp_path(basePath, is_dll)
      end

      local sep = "/"
      local binary_folder = sep .. "bin" .. sep .. "darwin" .. sep
      local expanded_base = vim.fn.expand(basePath)
      local handle = vim.loop.fs_scandir(expanded_base)
      if not handle then
        return nil
      end

      local path = ""
      while true do
        local filename, t = vim.loop.fs_scandir_next(handle)
        if not filename then
          break
        end
        if t == "directory" then
          local match = filename:match("ms%-dynamics%-smb.al%-(.+)")
          if match then
            cfg.language_extension_version = match
            path = expanded_base
              .. (expanded_base:sub(-1) == sep and "" or sep)
              .. filename
              .. binary_folder
              .. (is_dll and "Microsoft.Dynamics.Nav.EditorServices.Host.dll"
                or "Microsoft.Dynamics.Nav.EditorServices.Host")
          end
        end
      end

      if path == "" then
        return nil
      end

      return path
    end

    require("al").setup(opts)
  end,
  opts = {
    -- Path to VS Code extensions directory.
    -- The plugin scans this for the AL Language extension.
    vscodeExtensionsPath = "~/.vscode/extensions/",

    integrations = {
      luasnip = true,
    },

    lsp = {
      telemetryLevel = "all",    -- "none" | "crash" | "error" | "all"
      browser = "SystemDefault", -- "SystemDefault" | "Chrome" | "Firefox"
      -- | "Edge" | "EdgeBeta"
      inlayHintsParameterNames = true,
      inlayHintsFunctionReturnTypes = true,
      semanticFolding = true,
      extendGoToSymbolInWorkspace = true,
      extendGoToSymbolInWorkspaceResultLimit = 100,
      extendGoToSymbolInWorkspaceIncludeSymbolFiles = true,
      log = {
        path = "",
        level = "Normal", -- "Debug" | "Verbose" | "Normal"
        -- | "Warning" | "Error"
      },
    },

    workspace = {
      alResourceConfigurationSettings = {
        assemblyProbingPaths = { "./.netpackages" },
        codeAnalyzers = {
          "${CodeCop}",
          "${analyzerFolder}BusinessCentral.LinterCop.dll",
        },
        enableCodeAnalysis = true,
        backgroundCodeAnalysis = true,
        packageCachePaths = { "./.alpackages" },
        ruleSetPath = ".vscode/ruleset.json",
        enableCodeActions = true,
        incrementalBuild = false,
        outputAnalyzerStatistics = false,
        enableExternalRulesets = true,
      },
    },

    -- Multi-project workspace settings (used with code-workspace.nvim)
    multiproject = {
      -- Relative path to per-project settings file (read for
      -- alResourceConfigurationSettings overrides per folder)
      settings_path = ".vscode/settings.json",
      -- Maximum time (ms) to wait for a project closure to load
      closure_timeout_ms = 300000,
    },
  },
}
