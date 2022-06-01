set number
set guifont=Terminus:h15
" always display the status line (even when only 1 file open)
set laststatus=2

" for all these variables check https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
if (expand('%:t') =~ '^Makefile')
	set noexpandtab
else
    " alas, we have to set this otherwise codesharing won't work well on all
    " target PCs
	set expandtab
endif

" special config when working on your thesis. Which you should do at all
" times
if ( !isdirectory('/home/andrea/Documenti/thesis'))
    throw 'directory does not exist anymore. change your config file'
endif
if (expand('%:p') =~ '^/home/andrea/Documenti/thesis/')
	set expandtab
    set tw=80
endif

" special config when working on the Linux kernel source.
" Which you should do all time when working (semi-cit.)
" source:  https://www.kernel.org/doc/html/latest/process/coding-style.html
" source2: https://kernelnewbies.org/FirstKernelPatch
if (expand('%:p') =~ '^/run/media/andrea/disctwo/CanonicalHW-LinuxSRC/')
    set noexpandtab
    set tabstop=8
    set softtabstop=8
    set shiftwidth=8
    set noexpandtab
endif
