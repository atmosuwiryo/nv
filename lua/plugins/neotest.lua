return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
      quickfix = {
        enabled = false,
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      consumers = {
        overseer = require("neotest.consumers.overseer"),
      },
    },
  },
}
