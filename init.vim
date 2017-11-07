call plug#begin('~/.vim/plugged')
    " File tree
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'jistr/vim-nerdtree-tabs'

    " Git integration
    Plug 'tpope/vim-fugitive'

    " ------ COLOR SCHEMES ------
    Plug 'altercation/vim-colors-solarized'
    Plug 'freeo/vim-kalisi'
    Plug 'romainl/flattened'
    Plug 'mhartington/oceanic-next'

    " airline - install powerline fonts separetely
    " need to use one of the patched fonts
    Plug 'bling/vim-airline'
    "Plug 'jszakmeister/vim-togglecursor'
    Plug 'vim-airline/vim-airline-themes'
    " shows indent levels
    Plug 'Yggdroot/indentLine'

    " match parenthesis color
    Plug 'kien/rainbow_parentheses.vim'

    " trailing whitespace
    " run :FixWhitespace to remove the whitespace
    Plug 'bronson/vim-trailing-whitespace'

    " c++11/14 syntax highlighting
    Plug 'octol/vim-cpp-enhanced-highlight'

    " JSON formatter and options to see double quotes
    Plug 'elzr/vim-json'
    " Buffer explorer
    Plug 'jeetsukumaran/vim-buffergator'

call plug#end()

" allows for editing of hidden buffers
set hidden

let g:nerdtree_tabs_open_on_console_startup = 1
" nmap <silent> <leader>t :NERDTreeTabsToggle<CR>

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

let g:airline_theme="kalisi"
let mapleader = "\<Space>"

" save shortcut
nnoremap <Leader>w :w<CR>

" use leader-move to switch between windows
nnoremap <Leader>h <C-w>h
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l

" newline and return to normal node
nnoremap <Leader>o o<Esc>

" turn off highlight
nnoremap <Leader>/ :noh<CR>

set number
set relativenumber

set autoindent
filetype indent plugin on
syntax enable

let g:cpp_class_scope_highlight = 1

" share clipboard with the system
set clipboard=unnamedplus

" removes the automatic comment continuation
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.

if !&scrolloff
  set scrolloff=3       " Show next 3 lines while scrolling.
endif

set modeline            " Enable modeline.

" Search optiosn
set hlsearch            " Highlight search results.
set smartcase           " ... unless the query has capital letters.
set incsearch           " Incremental search.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).

" dont hide double quotes from json files
" also needs this when using the plugin indentLine
let g:indentLine_noConcealCursor=""
let g:vim_json_syntax_conceal = 0

" closes a buffer, leaves the windows

"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

" Create a mapping (e.g. in your .vimrc) like this:
"nmap <C-W>! <Plug>Kwbd

noremap <Leader>c :Kwbd<CR>

" Buffergator configuration
let g:buffergator_suppress_keymaps = 1
nnoremap <Leader>b :BuffergatorToggle<CR>

" NERD Tree configuration
nnoremap <Leader>t :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

" This allows for closing Neovim when only NERDTree is present
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set background=dark
colorscheme kalisi

" This runs current python script
nnoremap <Leader>x :w !python<CR>
