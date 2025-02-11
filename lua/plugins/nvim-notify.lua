return {
  "rcarriga/nvim-notify",
  config = function()
    vim.notify = require("notify") -- Set notify as default message handler
  end,
	-- enabled = false
}
