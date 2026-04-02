-- vim: sw=4 ts=4 et
-- for the above options check :help modeline

-- check :help init for where to place this file

-- "raw" options
----------------

vim.opt.number = true
vim.opt.wrap = true
-- tabulation
local tabsize = 4
vim.opt.shiftwidth = tabsize
vim.opt.tabstop = tabsize
vim.opt.expandtab = true -- indent with spaces instead of tabs when pressing TAB
-- higlight current line (if line wraps, only higlight line with cursor)
vim.opt.cursorline = true
vim.opt.cursorlineopt = {'number', 'screenline'}
-- do not secretly keep a file open after its window got closed
vim.opt.hidden = false
-- display selection size
vim.opt.showcmd = true
-- always display the status line (even when only 1 file open)
vim.opt.laststatus = 2
-- display ruler (column and line number on window' bottom-right)
vim.opt.ruler = true
-- highlight search
vim.opt.hlsearch = true
-- ignore case when searching only lowercase letter. override with \C / \c
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- search while typing
vim.opt.incsearch = true
-- show search count
vim.opt.shortmess:remove({'S'})
-- make mouse work in normal and visual mode
vim.opt.mouse = 'nv'
-- set terminal title to filename
vim.opt.title = true
-- use system clipboard for yank/paste
vim.opt.clipboard:append({'unnamed'})
-- open vertical splits on the right instead of left, and horizontal splits down
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 500
-- completion options
vim.opt.completeopt = {'menuone', 'popup', 'noinsert', 'fuzzy'}
-- Don't bother tools which don't save text files properly (like eclipse)
vim.opt.fixeol = false
-- filetype-specific options tweaking
local ftype_augroup = vim.api.nvim_create_augroup(
    'filetypecmd',
    { clear = true } -- unneeded: this is the default
)
vim.api.nvim_create_autocmd("Filetype", {
    pattern = 'svn',
    callback = function() vim.opt.textwidth = 72 end -- same as git commits 
})
vim.api.nvim_create_autocmd("Filetype", {
    pattern = 'make',
    -- makefiles must be indented via \t characters, not spaces
    callback = function() vim.opt.expandtab = false end
})
-- disable unneeded plugin providers (prefixes in :help internal-variables)
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0


-- plugins (via lazy.nvim plugin manager)
-----------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = "\\" -- ensure these are set before loading lazy.nvim
vim.g.maplocalleader = " "
-- load & setup lazy.nvim
require("lazy").setup({
    spec = {
        'tpope/vim-fugitive',
        'junegunn/fzf',
        'junegunn/fzf.vim',
        -- do not lazy load this since we use it immediately
        { 'rafi/awesome-vim-colorschemes', lazy = false },
        {
            "nvim-treesitter/nvim-treesitter",
            lazy = false, -- treesitter doesn't support lazy loading
            build = ":TSUpdate",
        },
        'neovim/nvim-lspconfig', -- example LSP configs
    },
    checker = { enabled = false }, -- do not automatically check for updates
    rocks = { enabled = false }, -- I don't need _another_ package manager
})

-- treesitter cfg
local ts_langs = { 'bash', 'c', 'c_sharp', 'javascript', 'markdown' }
-- note the differences from above
local ts_ftypes = { 'sh', 'c', 'cs', 'javascript', 'markdown' }
require('nvim-treesitter').install(ts_langs)
local plugins_augroup = vim.api.nvim_create_augroup('plugins_augroup', {})
vim.api.nvim_create_autocmd("FileType", {
    desc = 'Treesitter autostart hook',
    pattern = ts_ftypes,
    callback = function()
        vim.treesitter.start() -- use TS for syntax highlighting
    end,
})

-- styling
----------

local style_augroup = vim.api.nvim_create_augroup('style_override', {})
vim.api.nvim_create_autocmd("ColorScheme", {
    desc = 'molokai colorscheme customization',
    pattern = "molokai",
    group = style_augroup,
    -- yellow line numbers + selection inverts text background/foreground
    command = [[
        highlight LineNr guifg=Yellow ctermfg=Yellow
        highlight Visual gui=inverse guifg=NONE guibg=NONE
        highlight Visual cterm=inverse ctermfg=NONE ctermbg=NONE
    ]]
})
vim.api.nvim_create_autocmd("OptionSet", {
    desc = '`bat` theme customization so previews are more readable',
    pattern = 'background',
    group = style_augroup,
    -- vim.go.background is either 'light' or 'dark'
    callback = function() vim.env.BAT_THEME = vim.go.background end
})

vim.cmd.colorscheme("molokai") -- note vim.cmd instead of vim.opt

-- language servers
-------------------

-- for examples check https://github.com/neovim/nvim-lspconfig/tree/master
vim.lsp.config['clangd'] = {
    cmd = { 'clangd', '--header-insertion=never' },
}
-- defaults valid for all LSPs
vim.lsp.config('*', {
    root_markers = { '.git' }, -- .git as a valid root marker
})
-- use these LSPs automatically when possible
vim.lsp.enable({'bashls', 'clangd', 'lua_ls', 'pyright', --[['roslyn_ls',]] 'ts_ls'})
-- configure LSP depending on its capabilities
local lsp_augroup = vim.api.nvim_create_augroup('lsp_cfg', {})
vim.api.nvim_create_autocmd("LspAttach", {
    desc = 'LSP configuration',
    group = lsp_augroup,
    callback = function(ev)
        -- increase updatetime speed so CursorHold autocmd happens sooner
        vim.opt.updatetime = 300
        --local client = vim.lsp.get_client_by_id(ev.data.client_id)
        --if client:supports_method('...')
    end
})

-- commands / mappings
----------------------

-- fzf.vim commands' quick access
vim.keymap.set('n', '<leader>ff', '<cmd>Files<cr>')
vim.keymap.set('n', '<leader>gf', '<cmd>GitFiles<cr>')
vim.keymap.set('n', '<LocalLeader>ll', '<cmd>BLines<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Rg<cr>')

-- vim.lsp keybindings to emulate coc.nvim "defaults"
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<LocalLeader>o', vim.lsp.buf.document_symbol) -- outline
vim.keymap.set('n', '<LocalLeader>i', function()
    -- toggle inline hints (virtual text can get in the way during text alignment)
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)
-- open completion menu via tab
vim.keymap.set('i', '<TAB>',
    function()
        if (vim.fn.pumvisible()) ~= 0 then -- Pop-Up (completion) Menu open
            return '<C-n>' -- select next item in the PUM via ctrl+n
        end
        local curcol = vim.inspect_pos().col -- cursor's column
        local curchar = tostring(vim.api.nvim_get_current_line()):sub(curcol,curcol)
        if (curcol == 0 or curchar == ' ' or curchar == '\t') then
            return '<Tab>' -- insert tab into text
        end
        return '<C-x><C-i>' -- open completion menu (:help ins-completion)
    end,
    {silent = true, expr = true}
)
-- select previous completion via shit+tab
vim.keymap.set('i', '<S-Tab>',
    function()
        if vim.fn.pumvisible() ~= 0 then
            return '<C-p>' -- select previous 
        end
        return '<C-h>' -- "insert" backspace
    end,
    {silent = true, expr = true}
)
vim.keymap.set('i', '<CR>',
    function()
        if vim.fn.pumvisible() ~= 0 then
            return '<C-y>' -- accept completion suggestion via enter
        end
        return '<CR>' -- insert newline
    end,
    {silent = true, expr = true}
)

-- my custom keybindings
-- run `:Rg` on selection
vim.keymap.set('v', '<leader>fg', function()
    local orig_s = vim.fn.getreg('s')
    vim.cmd('normal! "sy') -- yank selection into @s
    local selection = vim.fn.getreg('s')
    selection = vim.fn.escape(selection, '{}[]()*|:.')
    vim.cmd.Rg(selection)
    vim.fn.setreg('s', orig_s) -- restore s' original value
end)
vim.keymap.set('n', '<leader>tt', '<cmd>tab split<cr>')
-- quickly create a scratch buffer
vim.keymap.set('n', '<leader>ss', '<cmd>new | setl buftype=nofile noswapfile<cr>')

-- workplace options
--------------------

-- (in separate file to not pollute "pure" vimrc)
local work_vimrc = vim.env.HOME .. '/.vimrc-work'
if vim.uv.fs_stat(work_vimrc) then
    vim.cmd.source(work_vimrc)
end

