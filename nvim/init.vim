set nocompatible number ruler
set guifont=Terminus:h15
" always display the status line (even when only 1 file open)
set laststatus=2
" enable mouse support in Normal and Visual mode
set mouse=nv
" yank and paste using secondary (unnamed) or clipboard (unnamedplus)
set clipboard+=unnamedplus
" wrap long lines on multiple lines
set wrap
" highlight current line (if line wraps, only highlight line with cursor)
set cursorline cursorlineopt=number,screenline
" ignore case when search term only has lowercase letters. Override with \C
set ignorecase smartcase

" for all these variables check https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
if (expand('%:t') =~ '^Makefile')
    set noexpandtab
else
    " alas, we have to set this otherwise codesharing won't work well on all
    " target PCs
    set expandtab
endif

" split new panels on the right (v-split) or down (h-split)
set splitright splitbelow

function! s:packager_init(packager) abort
    call a:packager.add('kristijanhusak/vim-packager', { 'type': 'opt' })
    call a:packager.add('junegunn/fzf', { 'do': './install --all' })
    call a:packager.add('junegunn/fzf.vim')
    call a:packager.add('sheerun/vim-polyglot')
    call a:packager.add('sainnhe/sonokai')
    call a:packager.add('neoclide/coc.nvim', {'branch': 'release', 'type': 'opt'})
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'))

" Improved BLines with preview shamelessly copied from junegunn/fzf.vim/issues/374
command! -bang -nargs=* BL
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --smart-case . '.fnameescape(expand('%:p')), 1,
    \   fzf#vim#with_preview({'options': '--layout reverse --query '.shellescape(<q-args>).' --with-nth=4.. --delimiter=":"'}, 'right:50%'))

" with :RG, exec fzf.vim's :Rg on selection
command -range RG call <sid>rgwrapper()
function s:rgwrapper()
    let selstart = getpos("'<")
    let selend = getpos("'>")
    if selstart[1] != selend[1]
        echohl WarningMsg | echo "Multiple lines selected" | echohl None
        return
    endif
    let selection = getline(selstart[1])[selstart[2] -1 : selend[2] -1]
    let selection = escape(selection, '{}[]()*|:')
    execute 'Rg' selection
endfunction

" call some commands faster
nnoremap <leader>ff <cmd>Files<cr>
nnoremap <leader>gf <cmd>GitFiles<cr>
nnoremap <leader>fl <cmd>BL<cr>
nnoremap <leader>fg <cmd>Rg<cr>
nnoremap <leader>tt <cmd>tab split<cr>

function! s:startCompletions()
    packadd coc.nvim
    source ~/.config/nvim/cocrc.vim
endfunction

" colorscheme & styling
augroup style_override
  autocmd!
  " yellow line numbers
  autocmd ColorScheme sonokai highlight LineNr guifg=Yellow
  " selection inverts text background/foreground
  autocmd ColorScheme sonokai highlight Visual gui=inverse cterm=inverse
  " instead of underline, invert color in the cursorline number
  autocmd ColorScheme slate highlight CursorLineNr cterm=inverse gui=inverse
  autocmd ColorScheme slate highlight CursorLine ctermbg=Black cterm=NONE guibg=#303030
  " use terminal default (transparent) background
  autocmd ColorScheme slate highlight Normal guibg=CLEAR
  autocmd ColorScheme slate highlight EndOfBuffer guibg=CLEAR
augroup END

if (has('termguicolors') && ($TERM =~ '-256color$' || $COLORTERM == 'truecolor'))
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    let g:sonokai_style = 'andromeda'
    let g:sonokai_better_performance = 1
    let g:sonokai_transparent_background = 1
    let g:sonokai_current_word = 'underline'
    let g:sonokai_disable_italic_comment = 1
    colorscheme sonokai
    " with some modifications below...
    "highlight Normal guibg=CLEAR
    "highlight EndOfBuffer guibg=CLEAR
else
    colorscheme default
endif

" special config when editing source files
if (expand('%:p:h') =~ '^' . $HOME . '/src')
    call <sid>startCompletions()
endif

" special config when editing assembly files
if (expand('%:t') =~ '\.asm$')
    set filetype=nasm
    set shiftwidth=8 tabstop=8
endif
