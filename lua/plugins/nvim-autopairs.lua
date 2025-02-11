return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup({
            enable_check_bracket_line = true, -- Ensures deletion of matching pairs
            map_bs = true,  -- Enables backspace deletion
        })
    end
}
