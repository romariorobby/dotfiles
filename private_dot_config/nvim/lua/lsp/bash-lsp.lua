-- npm -i g bash-language-server
require'lspconfig'.bashls.setup{
	cmd = {DATA_PATH .. "/lspinstall/bash/node_modules/.bin/bash-language-server", "start"},
	on_attach = COMPTACH,
	filetypes = { "sh" ,"zsh" }
}
