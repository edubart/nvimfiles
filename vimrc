" vim: ts=2 sts=2 sw=2 expandtab:
"
" Customizations are organized into logical sections. Mappings are organized
" by section. Plugin customizations are located near the bottom.
"
" Thanks:
" @garybernhardt
" @tpope
" @carllerche
" @wycats
" @nelstrom
" @mislav
" @mathiasbynens

" =============================================================================
" Initialization
" =============================================================================

" Clear autocmds
autocmd!

" Use Vim settings, rather than Vi settings (default when a vimrc exists)
set nocompatible

" Load plugins with Pathogen
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Enable file type detection and load plugin indent files
filetype plugin indent on

" Load vimrc from current directory and disable unsafe commands in them
set exrc
set secure

" Use UTF-8 without BOM
set encoding=utf-8 nobomb
set spelllang=en

" Respect modelines in files up to this number of lines
set modeline
set modelines=4

" Set comma as <leader> instead of default backslash
let mapleader=","

" =============================================================================
" Terminal Interaction
" =============================================================================

" Prevent Vim from clearing the scrollback buffer
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" Disable bells
set visualbell t_vb=

" Get return codes from make
set shellpipe=2>&1\ \|\ tee\ %s;exit\ \${PIPESTATUS[0]}

" Clear PAGER if Vim's Man function is needed
let $PAGER=''

" ===
" Editing vimrc
" ===

command! Vreload :source ~/.vimrc

" Auto reload vimrc when saving
autocmd BufWritePost .vimrc source ~/.vimrc

" Fast vimrc editing
map <leader>v :e! ~/.vimrc<CR>

" =============================================================================
" Editing
" =============================================================================

""
"" Whitespace
""

set expandtab     " Tab in insert mode will produce spaces
set tabstop=2     " Width of a tab
set shiftwidth=2  " Width of reindent operations and auto indentation
set softtabstop=2 " Set spaces for tab in insert mode
set autoindent    " Enable auto indentation

" Backspace over everything in insert mode
set backspace=indent,eol,start

" Invisible characters
"set listchars=tab:▸\ ,nbsp:_
"set listchars=tab:\ \ ,trail:·,eol:¬,nbsp:_,extends:❯,precedes:❮
"set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:❯,precedes:❮
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" Don't show invisible characters (default)
"set nolist

" Show invisible characters
set list

" Toggle set list
nnoremap <leader>l :set list!<cr>

""
"" Wrapping
""

set wrap " Enable wrapping
set showbreak=↪\  " Character to precede line wraps

" Always move down and up by display lines instead of real lines
" nnoremap <silent>j gj
" nnoremap <silent>k gk

""
"" Joining
""

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j     
endif

" Use only 1 space after "." when joining lines instead of 2
set nojoinspaces

" Joining with indents is useless - instead join and delete spaces
nnoremap gJ Jdiw

""
"" Other
""

" Don't reset cursor to start of line when moving around
set nostartofline

" Do not jump to the matching bracket upon bracket insert (default)
set noshowmatch

" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>

" Set <c-c> to escape in insert mode
inoremap <c-c> <esc>

" Set <c-j> to underscore in insert mode
inoremap <c-j> _

" Disable number adding/subtracting with <c-a> and <c-x>
nnoremap <c-a> <nop>
nnoremap <c-x> <nop>

" =============================================================================
" Appearance
" =============================================================================

set cursorline      " Highlight current line
set scrolloff=5     " Keep more buffer context when scrolling
set showtabline=2   " Always show the tab bar
set cmdheight=1     " Set command line height (default)
set title           " Show the filename in the window titlebar
set t_Co=256        " 256 colors
set background=dark " Dark background
syntax on           " Enable syntax highlighting
colorscheme molokai " Set the default colorscheme
set noerrorbells    " Disable error bells
set shortmess=atI   " Don't show the Vim intro message
set number          " Show line numbers

""
"" Status Line
""

if has("statusline") && !&cp
  set laststatus=2 " windows always have status line
  set statusline=%f\ %y\%m\%r " filename [type][modified][readonly]
  set stl+=%{fugitive#statusline()} " git via fugitive.vim
  " buffer number / buffer count
  set stl+=\[b%n/%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}\]
  set stl+=\ %l/%L[%p%%]\,%v " line/total[%],column
endif

" =============================================================================
" GUI
" =============================================================================
"

if has("gui_running") 
  " Enable mouse in all modes
  set mouse=a

  " Use console dialogs instead of popup dialogs
  set guioptions+=c

  " Inactive menu items are grey
  set guioptions+=e

  " Show menu bar
  set guioptions+=m

  " Hide toolbar
  set guioptions-=T

  " Don't use Aqua scrollbars
  set guioptions-=rL

  " Smooth fonts
  set antialias

  " Increase font size for (MacVim default: 11)
  set guifont=Monospace\ 9

  " Increase line-height (default: 0)
  set linespace=1

  " Starting window position at top left
  winpos 0 0

  " Turn off the blinking cursor in normal mode
  set gcr=n:blinkon0

  " Tab tooltip format
  set guitabtooltip=%F

  " Tab label format
  set guitablabel=%N\ %t\ %m
endif

" =============================================================================
" Command Line
" =============================================================================

" Display incomplete commands below the status line
set showcmd
set showmode

" Default shell and shell syntax
set shell=bash
let g:is_bash=1

" Remember more commands and search history (default: 20)
set history=100

" Set <c-n> and <c-p> to act like Up/Down so will filter command history
" Practical Vim p.69
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" <c-a> jumps to beginning of line to match <c-e>
cnoremap <c-a> <home>

" Open help in a vertical split instead of the default horizontal split
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev h <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'vert h' : 'h')<cr>
cabbrev help <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'vert h' : 'help')<cr>

" Expand %% to current directory
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Save with sudo and reload
command! WW :execute ':silent w !sudo tee % > /dev/null' | :edit!

""
"" Wildmode
""

" Make tab completion for files/buffers act like bash
set wildmenu

" Use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Ignore rails temporary asset caches
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*

" Ignore node modules
set wildignore+=node_modules/*

" Ignore build directories
set wildignore+=build/*,build.*/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

""
"" Search
""

set hlsearch   " Highlight searches
set incsearch  " Highlight dynamically as pattern is typed
set ignorecase " Make searches case-insensitive...
set smartcase  " ...unless they contain at least one uppercase character
set gdefault   " Use global search by default

" Clear last search highlighting with enter and clear the command line
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>:<backspace>
endfunction
call MapCR()

" Re-highlight last search pattern
nnoremap <leader>hs :set hlsearch<cr>

" =============================================================================
" Buffers
" =============================================================================

" Allow unsaved background buffers and remember marks/undo for them
set hidden

" Jump to the first open window that contains the specified buffer
set switchbuf=useopen

" Auto-reload buffers when files are changed on disk
set autoread

" Toggle current and alternate buffers
nnoremap <leader><leader> <c-^>

" Remember buffer count to show in status line
" au BufAdd * let g:zbuflistcount += 1
" au BufDelete * let g:zbuflistcount -= 1
au VimEnter * call UpdateZBufLC()
function UpdateZBufLC()
  let lst = range(1, bufnr('$'))
  call filter(lst, 'buflisted(v:val)')
  let g:zbuflistcount = len(lst)
endfunction

" =============================================================================
" Windows
" =============================================================================

" Set window width that works with standard 15" screen
set winwidth=80

" Split windows below and right instead of above and left
set splitbelow splitright

" Move around splits with <c-h/j/k/l> - This is now handled by
" tmux_navigator.vim - https://gist.github.com/mislav/5189704
" nnoremap <c-h> <c-w>h
" nnoremap <c-j> <c-w>j
" nnoremap <c-k> <c-w>k
" nnoremap <c-l> <c-w>l

" Allow switching windows while in insert mode
imap <C-w> <Esc><C-w>

" =============================================================================
" CMake/C++
" =============================================================================

" Override make command for CMake projects
function! SetupMake()
    if filereadable("CMakeLists.txt") && filereadable("./build/Makefile")
        set makeprg=make\ -j8\ -C\ build
    else
        set makeprg=make\ -j8
    endif
endfunction

function! Compile()
    call SetupMake()
    make
endfunction

function! Run()
    call SetupMake()
    make tests
endfunction

"command! Ctags :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .

" Formating style for c++
autocmd BufNewFile,BufRead *.cpp set formatprg=astyle\ -A1s4Sclk1
autocmd BufNewFile,BufRead *.hpp set formatprg=astyle\ -A2s4SOclk1
autocmd BufNewFile,BufRead *.c set formatprg=astyle\ -A1s4Sclk1
autocmd BufNewFile,BufRead *.h set formatprg=astyle\ -A2s4SOclk1

" Auto close preview window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Automatically opens quickfix window on make errors
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Treat std include files as cpp
au BufEnter /usr/include/c++/* setf cpp

" Turn off preview menu for omni
set completeopt=menu

" =============================================================================
" Registers
" =============================================================================

" Use the OS clipboard by default
set clipboard=unnamed

" Copy to X11 primary clipboard
map <leader>y "*y

" Paste from unnamed register and fix indentation
nmap <leader>p pV`]=

" Repeat the last macro in the `q` register
nmap <leader>2 @q

" Delete to the blackhole register
nnoremap <leader>x "_x
nnoremap <leader>d "_dd

" =============================================================================
" Backup
" =============================================================================

" Store temporary files in a central location
"set backup
"set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Ignore tmp directories for backup
"set backupskip=/tmp/*,/private/tmp/*

" Don't make a backup before overwriting a file
set nobackup
set nowritebackup

" Disable swap files
set updatecount=0

" =============================================================================
" Filetypes and Custom Autocmds
" =============================================================================

augroup vimrcEx
  " Clear all autocmds for the current group
  autocmd!

  " Jump to last cursor position unless it's invalid or in an event handler or
  " a git commit
  au BufReadPost *
    \ if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Some file types use real tabs
  au FileType {make,gitconfig} set noexpandtab sw=4

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json setf javascript

  " Make Python follow PEP8
  au FileType python set sts=4 ts=4 sw=4 tw=79

  " Use 4 spaces for Java
  au FileType java set sts=4 ts=4 sw=4

  " Make sure all markdown files have the correct filetype
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown

  " MultiMarkdown requires 4-space tabs
  au FileType markdown set sts=4 ts=4 sw=4

  " Use 4-space tabs for apache
  au FileType apache set sts=4 ts=4 sw=4

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there
  au! CmdwinEnter * :unmap <cr>
  au! CmdwinLeave * :call MapCR()
augroup END

" =============================================================================
" Multipurpose Tab Key
" =============================================================================

" Indent if at the beginning of a line, else do completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" =============================================================================
" Open urls in the default browser
" =============================================================================

function! OpenUrl()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
    silent exec "!open ".shellescape(s:uri, 1)
  else
    echo "No Url found in line."
  endif
endfunction
map <leader>j :call OpenUrl()<cr>

" =============================================================================
" Performance
" =============================================================================

" See :help slow-terminal

" Optimize for fast terminal connections
set ttyfast

" Time out on key codes but not mappings
set notimeout
set ttimeout
set ttimeoutlen=100

" Update syntax highlighting for more lines increased scrolling performance
syntax sync minlines=512

" Don't syntax highlight long lines
set synmaxcol=512

" Don't redraw screen while executing macros, registers
" set lazyredraw

" Maximum number of lines to scroll the screen
" ttyscroll=3

" Jump by more lines when scrolling
" set scrolljump=2

" =============================================================================
" Plugin Settings and Mappings
" =============================================================================

""
"" YankRing
""

" Fix yankring conflict with ctrlp
let g:yankring_replace_n_pkey = '<Char-172>'
let g:yankring_replace_n_nkey = '<Char-174>'

""
"" Fugitive
""

nnoremap <leader>ga :Gwrite<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gg :Gstatus<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gp :Git push<cr>
nnoremap <leader>gs :Git status -sb<cr>

""
"" Matchit
""

" Enable Matchit to use % to jump between def/end, if/else/end
runtime macros/matchit.vim

""
"" NERDTree
""

" Show hidden files in NERDTree
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1

" Toggle NERDTree
nnoremap <c-n> :NERDTreeToggle<cr>

""
"" Smooth Scroll
""

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 12, 2)<cr>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 14, 2)<cr>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 22, 4)<cr>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 24, 4)<cr>

""
"" Surround
""

nmap <leader>` ysiw`
nmap <leader>' ysiw'

""
"" Buffergator
""

let g:buffergator_viewport_split_policy="T"
let g:buffergator_split_size=15
let g:buffergator_sort_regime="mru"

""
"" YouCompleteMe
""

let g:ycm_confirm_extra_conf=0
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

" =============================================================================
" Application Interaction
" =============================================================================

"command! Marked silent !open -a "Marked.app" "%:p"
"nnoremap <silent> <leader>m :Marked<cr>\|:redraw!<cr>

" =============================================================================
" Typos, Errors, and Typing Discipline
" =============================================================================

" Overwrite :Q Ex mode and :X encryption
command! W :w
command! Q :q
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev X <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'x' : 'X')<cr>
" Fix common mistypes
cnoremap ww w
cnoremap wW w
cnoremap Ww w

" Don't save files named ":" or ";"
cnoremap w; w
cnoremap W; w
cnoremap x; x
cnoremap X; x
cnoremap w: w
cnoremap W: w
cnoremap x: x
cnoremap X: x

" Don't save files named ")" since this is a common mistake when shifts are
" externally mapped to parentheses
cnoremap w) w
cnoremap W) w
cnoremap x) x
cnoremap X) x

" Disable parentheses in normal mode since they are too easily triggered when
" shifts are externally mapped to parentheses
nnoremap ( <nop>
nnoremap ) <nop>

" Disable arrow keys in normal mode and insert mode
"noremap <left> <nop>
"noremap <right> <nop>
"noremap <up> <nop>
"noremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"

" ========================
" Use :w!! to write to a file using sudo if you forgot to 'sudo vim file'
cmap w!! %!sudo tee > /dev/null %

" Useful replacing macros
nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" Explorer mappings
nnoremap <f1> :NERDTreeToggle<cr>
nnoremap <f2> :BuffergatorToggle<cr>
nnoremap <f3> :Tagbar<cr>
nnoremap <f4> :GundoToggle<cr>
map <f5> :call Compile()<CR>
map <f6> :call Run()<CR>


" Toggle spell checking
nmap <silent> <leader>s :set spell!<CR>

" Key mapping for quickfix navigation
map <C-n> :cnext<CR>
map <C-b> :cprevious<CR>
map <leader>q :ccl<cr>

" Ctrl + S for saving files
map <C-s> :w<cr>
