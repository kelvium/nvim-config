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

vim.cmd('colorscheme quiet')

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
				ensure_installed = {"c", "cpp"},
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
}, {})
