return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
            integrations = {
                treesitter = true,
                native_lsp = { enabled = true },
                telescope = true,
                neogit = true,
                nvimtree = true,
                which_key = true,
            },
        })
        vim.cmd.colorscheme "catppuccin"
    end
}

