-- setup for TrueZen.nvim
local true_zen = require("true-zen")
true_zen.setup({
    true_false_commands = false,
	cursor_by_mode = false,
	before_minimalist_mode_shown = false,
	before_minimalist_mode_hidden = false,
	after_minimalist_mode_shown = false,
	after_minimalist_mode_hidden = false,
	unknown_bkg_color_fix = false,
	bottom = {
		hidden_laststatus = 0,
		hidden_ruler = false,
		hidden_showmode = false,
		hidden_showcmd = false,
		hidden_cmdheight = 1,

		shown_laststatus = 2,
		shown_ruler = true,
		shown_showmode = false,
		shown_showcmd = false,
		shown_cmdheight = 1
	},
	top = {
		hidden_showtabline = 0,

		shown_showtabline = 2
	},
	left = {
		hidden_number = false,
		hidden_relativenumber = false,
		hidden_signcolumn = "no",

		shown_number = true,
		shown_relativenumber = false,
		shown_signcolumn = "no"
	},
	ataraxis = {
		just_do_it_for_me = false,
		left_padding = 40,
		right_padding = 40,
		top_padding = 0,
		bottom_padding = 0
	},
	focus = {
		margin_of_error = 5
	},
	integrations = {
		integration_galaxyline = false,
		integration_vim_airline = false,
		integration_vim_powerline = false,
		integration_tmux = false,
		integration_express_line = false,
		integration_gitgutter = false,
		integration_vim_signify = false,
		integration_limelight = false
	}
})
true_zen.after_minimalist_mode_hidden = function ()
	vim.cmd("echo 'I ran after minimalist mode hid everything :)'")
end

true_zen.before_minimalist_mode_hidden = function ()
	vim.cmd("echo 'I ran before minimalist mode hid everything :)'")
end

true_zen.after_minimalist_mode_shown = function ()
	vim.cmd("echo 'I ran after minimalist mode showed everything :)'")
end

true_zen.before_minimalist_mode_shown = function ()
	vim.cmd("echo 'I ran before minimalist mode showed everything :)'")
end
