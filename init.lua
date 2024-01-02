vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.expandtab = false
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.incsearch = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cinoptions = "N-s"
vim.g.mapleader = ","
vim.opt.background = "dark"
vim.opt.termguicolors = true

vim.g.rust_recommended_style = false
vim.g.zig_recommended_style = false
vim.g.zig_fmt_autosave = false
vim.g.meson_recommended_style = false

vim.cmd('colorscheme koehler')

local lsp_servers = {
	clangd = {
		cmd = {
			'clangd',
			'--header-insertion=never',
			'--header-insertion-decorators=0',
		},
	},
	rust_analyzer = {},
}

local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"rktjmp/lush.nvim",
		event = "VeryLazy",
	},
	{
		"gpanders/editorconfig.nvim",
		event = "BufEnter",
	},
	{
		"tpope/vim-commentary",
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {"c", "cpp", "rust"},
				incremental_selection = { enable = true },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		dependencies = {
			{"nvim-lua/plenary.nvim"},
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		cmd = "Telescope",
		keys = {
			{"<leader>ff", "<cmd>Telescope find_files<cr>"},
			{"<leader>ft", "<cmd>Telescope treesitter<cr>"},
			{"<leader>fg", "<cmd>Telescope live_grep<cr>"},
			{"<leader>fb", "<cmd>Telescope buffers<cr>"},
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			telescope.load_extension("fzf")
		end,
	},
	{
		"ggandor/leap.nvim",
		lazy = false,
		dependencies = {"tpope/vim-repeat"},
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = true,
		event = "VeryLazy",
	},
	{
		"neovim/nvim-lspconfig",
		event = {"BufReadPre", "BufNewFile"},
		config = function()
			local lspconfig = require("lspconfig")

			vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({"n", "v"}, "<space>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<space>f", function()
						vim.lsp.buf.format({async = true})
					end, opts)
				end,
			})
		end,
	},
	{"L3MON4D3/LuaSnip"},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},
		event = {"BufReadPre", "BufNewFile"},
		config = function()
			local cmp = require("cmp")
			local lspconfig = require("lspconfig")
			local luasnip = require("luasnip")

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						return luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({select = true}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, {"i", "s"}),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jum(-1)
						else
							fallback()
						end
					end, {"i", "s"}),
				}),
				sources = cmp.config.sources({
					{name = "nvim_lsp"},
					{name = "luasnip"},
				}, {
					{name = "buffer"},
				}),
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			for key, value in pairs(lsp_servers) do
				opts = vim.tbl_deep_extend("force", value, { capabilities = capabilities })
				lspconfig[key].setup(opts)
			end
		end,
	},
}, {})
