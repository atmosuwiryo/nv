return {
    "ravitemer/mcphub.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = "MCPHub",
    build = "npm install -g mcp-hub@latest",
    config = function()
        require("mcphub").setup({
            port = 4000,
            config = vim.fn.expand("~/.mcpservers.json"),
            shutdown_delay = 0,
            log = {
                level = vim.log.levels.WARN,
                to_file = false,
                file_path = nil,
                prefix = "MCPHub"
            },
        })
    end
}
