" show line numbers 
set number

set nocompatible
syntax on
set nowrap
set encoding=utf8

" Set Proper Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Enable highlighting of the current line
set cursorline


" Theme and Styling 
set t_Co=256
set background=dark

if (has("termguicolors"))
  set termguicolors
endif

" Always display the status line
set laststatus=2


"""""""""""""""""""""""""""""""""""""
" Mappings configurationn
"""""""""""""""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>
map <C-a> :!tig<CR>
map <C-Left>  :tabp<CR>
map <C-Right>  :tabn<CR>

map <C-Up> ddkP
map <C-Down> ddp

let NERDTreeMapOpenInTab='<CR>'

"""""""""""""""""""""""""""""""""""
" Directory browser setup
"""""""""""""""""""""""""""""""""""
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

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



