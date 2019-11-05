" show line numbers 
set number

set colorcolumn=80
set nocompatible
syntax on
set nowrap
set encoding=utf8
" omni complete (^p in insert mode)
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" Set Proper Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Enable highlighting of the current line
set cursorline

" fuzzy matching
set path+=**
set wildmenu

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .


" Theme and Styling 
colorscheme desert 

if (has("termguicolors"))
  set termguicolors
endif

" Always display the status line
set laststatus=2

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

set switchbuf=usetab

"""""""""""""""""""""""""""""""""""""
" Mappings configurationn
"""""""""""""""""""""""""""""""""""""

let mapleader = "-"
map <leader>a :!tig<CR>
map <leader>h  :tabp<CR>
map <leader>l  :tabn<CR>
map <C-Left> b
map <C-Right> w

map <C-Up> ddkP
map <C-Down> ddp
map <f5> :!docker build .<CR>


"""""""""""""""""""""""""""""""""""
" Directory browser setup
"""""""""""""""""""""""""""""""""""
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
let g:netrw_winsize = 25

" Snippets

autocmd FileType javascript :iabbrev <buffer> iff if ()<left>
autocmd FileType java :iabbrev <buffer> if if () then {} else {}<left>

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <C-E> :call ToggleVExplorer()<CR>


"""""""""""""""""""""""""""""""""""""""""
" Collect filenames of current subtree
" http://vim.wikia.com/wiki/Collect_filenames_of_current_subtree
"""""""""""""""""""""""""""""""""""""""""
map <C-L> :call ListTree('.')<CR>
function! ListTree(dir)
  new
  set buftype=nofile
  set bufhidden=hide
  set noswapfile
  normal i.
  while 1
    let file = getline(".")
    if (file == '')
      normal dd
    elseif (isdirectory(file))
      normal dd
      let @" = glob(file . "/*")
      normal O
      normal P
      let @" = glob(file . "/.[^.]*")
      if (@" != '')
        normal O
        normal P
      endif
    else
      if (line('.') == line('$'))
        return
      else
        normal j
      endif
    endif
  endwhile
endfunction





""""""""""""""""""""""""


" use ':PrettyXML' to format. Uses 'xmllint' 
" see: http://vim.wikia.com/wiki/Pretty-formatting_XML
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()





" shift+arrow selection
nmap <S-Up> v<Up>
map <S-End> v<End>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

" copy with ctrl+ {c,x,v}
vmap <C-c> y<Esc>i
vmap <C-x> d<Esc>i
map <C-v> pi
imap <C-v> <Esc>pi
imap <C-z> <Esc>ui

