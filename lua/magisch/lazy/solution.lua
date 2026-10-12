return {
  'arkaragian/Solution.nvim',
  ft = "cs",
  cmd = { "LoadSolution", "DisplaySolution", "CompileSolution", "LaunchSolution" },
  config = function ()
    require('solution').setup()
  end
}
