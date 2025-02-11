local config = function()
  require("mason").setup({
    ui = {
      icons = {
        package_pending = " ",
        package_installed = "󰄳 ",
        package_uninstalled = " 󰚌",
      },
    },
  })
end

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = config,
  },
}
