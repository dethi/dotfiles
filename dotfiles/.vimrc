" =======================================
" Plugins
" =======================================

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'morhetz/gruvbox' " Colorscheme
Plugin 'bling/vim-airline' " Bottom bar
Plugin 'tpope/vim-fugitive' " Git
Plugin 'airblade/vim-gitgutter' " +/- for Git
Plugin 'Raimondi/delimitMate' " Autoclose delimiter
Plugin 'godlygeek/tabular' " Automatic alignement, like = or \
Plugin 'ctrlpvim/ctrlp.vim' " Full path fuzzy file finder
Plugin 'majutsushi/tagbar' " Tagbar

" Plugin 'Syntastic' " Syntax checking
" Required flake8 for Python support

Plugin 'Valloric/YouCompleteMe' " Autocompletation
" Required CMake. Please run the following command:
" ./install.sh --gocode-completer

Plugin 'fatih/vim-go' " Golang
" Required to run :GoInstallBinaries

Plugin 'elixir-lang/vim-elixir' " Elixir

call vundle#end()
filetype plugin indent on

" =======================================
" Plugins Configurations
" =======================================

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Disable checker for LateX
let g:syntastic_tex_checkers = []
" Don't lag with vim-go
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = {'mode': 'active', 'passive_filetypes': ['go']}

let g:go_fmt_command = "goimports"
" let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_addtags_transform = "snakecase"

let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'tex': 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
      \}
let g:ycm_complete_in_strings = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" =======================================
" Configurations
" =======================================

syntax on
set history=700
set number
set background=dark
set t_Co=256 " 256 Color
colorscheme gruvbox

" Highlight the current line
set cursorline

" A buffer can be hidden
set hidden

" Use Unix as the standard file type
set ffs=unix
set encoding=utf8

" Live reload file when edited from outside
set autoread

" Fix backspace key
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

" Activate the mouse
set mouse=a

" Turn off backup and swap
set nobackup
set nowb
set noswapfile

try
    set undodir=~/.vim/undo
    set undofile
catch
endtry

" Set red line
set cc=80,120

" Use spaces instead of tabs
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

autocmd FileType yaml,elixir :setlocal sw=2 ts=2

set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines

" Linebreak on 500 characters
set lbr
set tw=500

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Delete trailing white space on save
func! DeleteTrailingWS()
    if exists('b:noDeleteTraillingWS')
        return
    endif
    %s/\s\+$//ge
endfunc
autocmd BufWritePre * :call DeleteTrailingWS()

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
set laststatus=2

" Change invisible character when :set list
set listchars=eol:¬

" =======================================
" Mapping
" =======================================

" Map <space> to search
nmap <space> /

" Switch buffer
nmap <S-Tab> :bnext<cr>

" Opens a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Indent/Unindent in visual mode
vmap <Tab> >
vmap <S-Tab> <
