vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.g.colors_name = "nya"

local lush = require('lush')
local hsl = lush.hsl

local white = hsl(0, 0, 100)
local black = hsl(0, 0, 0)

local theme = lush(function()
  return {
		Comment { fg = white },
		Constant { fg = white },
		CursorLine { bg = white, fg = black },
		DiagnosticError { bg = white, fg = black },
		DiagnosticHint { bg = white, fg = black },
		DiagnosticInfo { bg = white, fg = black },
		DiagnosticOk { bg = white, fg = black },
		DiagnosticWarn { bg = white, fg = black },
		Directory { fg = white },
		Error { bg = white, fg = black },
		ErrorMsg { bg = white, fg = black },
		Identifier { fg = white },
		LineNr { bg = black, fg = white },
		MatchParen { bg = white, fg = black },
		MoreMsg { fg = white },
		NonText { fg = white },
		Normal { bg = black, fg = white },
		PreProc { fg = white },
		Question { fg = white },
		Search { bg = white, fg = black },
		Special { bg = white, fg = black },
		SpecialKey { bg = white, fg = black },
		Statement { fg = white },
		Todo { bg = white, fg = black },
		Type { fg = white },
		Visual { bg = white, fg = black },
		WarningMsg { bg = white, fg = black },
  }
end)
require("lush")(theme)
