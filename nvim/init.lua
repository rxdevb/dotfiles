local pack_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/"
if not vim.pack then
    vim.pack = {
        add = function(specs)
            for _, spec in ipairs(specs) do
                local name = spec.src:match(".*/(.*)")
                local dir = pack_path .. name
                if vim.fn.isdirectory(dir) == 0 then
                    print("Installing " .. name .. "...")
                    vim.fn.system({ "git", "clone", "--depth", "1", spec.src, dir })
                end
            end
        end,
        get = function() return {} end,
        del = function() end
    }
end

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/LinArcX/telescope-env.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
	{ src = "https://github.com/julianolf/nvim-dap-lldb" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" }
})

local current_pack_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/"
local all_folders = vim.fn.expand(current_pack_path .. "*", false, true)
for _, folder in ipairs(all_folders) do
	vim.opt.runtimepath:append(folder)
end

local function safe_require(module, config_fn)
    local status, mod = pcall(require, module)
    if status then config_fn(mod) end
end

safe_require("vague", function(v) 
    v.setup({ transparent = true }) 
    vim.cmd("colorscheme vague")
end)

safe_require("marks", function(m) m.setup({ builtin_marks = { "<", ">", "^" } }) end)
safe_require("mason", function(m) m.setup() end)
safe_require("oil", function(o) o.setup({ columns = { "icon" }, float = { border = "rounded" } }) end)

safe_require("luasnip", function(l) 
    l.setup({ enable_autosnippets = true })
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
end)

safe_require("telescope", function(t)
	t.setup({
		defaults = {
			sorting_strategy = "ascending",
			layout_config = { prompt_position = "top" },
            borderchars = { "", "", "", "", "", "", "", "" },
		}
	})
	t.load_extension("ui-select")
end)

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'svelte', 'lua', 'rust', 'typescript', 'javascript', 'python', 'typst'},
	callback = function() pcall(vim.treesitter.start) end,
})

vim.lsp.enable({ "lua_ls", "rust_analyzer", "pyright", "ts_ls" })

local map = vim.keymap.set
local builtin = require("telescope.builtin")

map({ "n", "v", "x" }, ";", ":")
map({ "n", "v", "x" }, ":", ";")
map("n", "<leader>w", "<cmd>update<cr>")
map("n", "<leader>q", "<cmd>quit<cr>")
map("n", "<leader>e", "<cmd>Oil<CR>")
map("n", "<leader>f", builtin.find_files)
map("n", "<leader>g", builtin.live_grep)
map({ "n", "x" }, "<leader>y", '"+y')

pcall(require, "debug")

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.jsx,*.tsx",
	callback = function() vim.cmd([[set filetype=typescriptreact]]) end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    callback = function()
        local cmd = "tinymist"
        if vim.fn.executable(cmd) == 0 then
            cmd = vim.fn.expand("$HOME/.cargo/bin/tinymist")
        end

        vim.lsp.start({
            name = "tinymist",
            cmd = { cmd },
            root_dir = vim.fn.getcwd(),
            settings = {
                exportPdf = "onSave",
            }
        })
    end,
})
