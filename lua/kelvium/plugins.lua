local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
	use('wbthomason/packer.nvim')
	use('aditya-azad/candle-grey')
	use('Shatur/neovim-ayu')
	use({
		'nvim-treesitter/nvim-treesitter',
		run = function()
			require('nvim-treesitter.install').update({ with_sync = true })()
		end,
	})
	use({
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-tree/nvim-web-devicons', opt = true },
		},
	})
	use({
		{ 'neovim/nvim-lspconfig' },
		{
			'L3MON4D3/LuaSnip',
			tag = 'v1.*',
		},
		{
			'hrsh7th/nvim-cmp',
			requires = {
				{ 'hrsh7th/cmp-nvim-lsp' },
				{ 'hrsh7th/cmp-buffer' },
				{ 'L3MON4D3/LuaSnip' },
				{ 'saadparwaiz1/cmp_luasnip' },
			},
		},
		{ 'ray-x/lsp_signature.nvim' },
	})

	if packer_bootstrap then
		require('packer').sync()
	end
end)
