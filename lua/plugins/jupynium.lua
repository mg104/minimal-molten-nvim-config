return {
	{
		"kiyoon/jupynium.nvim",
		config = function() 
			require("config.jupynium")
		end,
		build = "conda run --no-capture-output -n jupynium pip install ~/.local/share/nvim/lazy/jupynium.nvim",
		enabled = vim.fn.isdirectory(vim.fn.expand "~/miniforge3/envs/jupynium"),
	},
	"rcarriga/nvim-notify",   -- optional
	"stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
}
