" TODO:
" - $VIMRUNTIME/plugin/matchit.vim
" - |Using tags|
" - |Installing vim|
" - map keys o move line up/down (ddkp/ddp), possibly ^j/^k or <LEADER>O/o
" - set clang-format as 'equalprg' so that clang-format is called on =
" - checkout 'formatprg' options
" - check if "set iskeyword+=-" is needed for lisp files
" - check if "set iskeyword-=_" is needed for c,cpp(,all???) files
" - check if cmdheight needs to be 2 or can be set to 1

" NOTES:
" i_CTRL-O : execute 1 commmand in normal mode
" c_U : undo entire line
" n_ZZ : write file and exit
" :e! : reloads the original version file (deletes all unsaved changes)
" n_CTRL-] : jump to tag
" n_CTRL-T : pop tag (go back to previous position)
" n_CTRL-O : jump to older position
" n_CTRL-I : jump to newer position in jump-stack
" :helpgrep
" :help E(n) : help on specific error number, where (n) is the number
" n_ge : jump to end of previous word
" n_[count]$ : when using count it goes to [count] lines underneath it
" n_; : repeats search with fFtT
" n_' : repeats search with fFtT in oposite direction
" n_% : searches for the first occurence of a matchpair when not inside one and goes to its counterpart
" n_CTRL-G : gives details of file (name and current position in file)
" n_[0-100]% : goes to the first line at that percent in the file
" n_? : backwards n_/
" n_[count]* : count can be used to skip item searches in the findings
" n_g* : match partial word under cursor
" :nohlsearch : disables search highlighting for the currently active search highlighting
" n_`` : go to last position
" . in regex : any charactar
" v_o : move cursor to other end of visual selection
" v_o (block) : move cursor to other oposite corner
" v_O (block) : move cursor to other other corner of same line
" c_[command]aw : A Word. c_di( deletes inside the braces, c_da( deletes inside the braces including the braces

" {{{
"     utitilies
"functions
function! s:unixtowinpath(path) " replace
    return substitute(a:path, "/", "\\\\", "g")
endfunction

" variables
let s:win32 = has('win32')
let s:nvim = has('nvim')
let s:home_clean=substitute($HOME," ","\\\\\\ " ,"g") " cleanup spaces in home path

" set global vim config directory
if s:nvim
    if s:win32
        let s:vimdir=s:home_clean . '/AppData/Local/nvim/'
        let s:vimdir= substitute(s:home_clean, "\\", "\\\\\\", "g") . '/AppData/Local/nvim/'
    else
        let s:vimdir=s:home_clean . '/.config/nvim/'
    endif
else
    if s:win32
        let s:vimdir=s:home_clean . '/vimfiles/'
    else
        let s:vimdir=s:home_clean . '/.vim/'
    endif
endif

" autoinstall vim plug
if empty(glob(s:vimdir . 'autoload/plug.vim'))
    silent execute "!curl -fLo " . s:vimdir . "autoload/plug.vim --create-dirs "
                \ . "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    execute "autocmd VimEnter * PlugInstall --sync | source $MYVIMRC"
endif
" }}}


call plug#begin(s:vimdir . 'plugged')

" functionality
Plug 'junegunn/vim-plug'                                       " add plug help files
Plug 'lambdalisue/suda.vim'                                    " neovim sudo write
Plug 'machakann/vim-highlightedyank'                           " highlight yanked region
Plug 'scrooloose/nerdcommenter'                                " easy (un)commenting
Plug 'tpope/vim-repeat'                                        " repeat plugin commands with '.'
Plug 'sgur/vim-editorconfig'                                   " support .editorconfig files in projects
Plug 'Yggdroot/indentLine'                                     " add indentation guide line

Plug 'tpope/vim-surround'                                      " quotes/braces/stuff surrounding text made easy

" movement and searching stuff
Plug 'easymotion/vim-easymotion'                               " move to char with <backspace>
Plug 'junegunn/fzf',          { 'do': { -> fzf#install() } }   " for both fzf and ripgrep integration.
Plug 'junegunn/fzf.vim'

" git stuff
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'        " git commit browser
Plug 'rhysd/committia.vim'    " better overview when comitting
Plug 'rhysd/git-messenger.vim'  " better git blame like stuff

" languages
Plug 'zig-lang/zig.vim',                   { 'for': 'zig' }
Plug 'zah/nim.vim',                        { 'for': 'nim' }
Plug 'tetralux/odin.vim',                  { 'for': 'odin' }
Plug 'ollykel/v-vim',                      { 'for': 'v' }
Plug 'taffyquinzel/vim-MetaCasanova',      { 'for': 'mc' }
Plug 'kovisoft/slimv',                     { 'for': 'lisp' }
Plug 'sirtaj/vim-openscad',                { 'for': 'scad' }
Plug 'rust-lang/rust.vim',                 { 'for': 'rust' }
Plug 'peterhoeg/vim-qml',                  { 'for': 'qml' }

" colorschemes
Plug 'srcery-colors/srcery-vim'
Plug 'dguo/blood-moon',                    {'rtp': 'applications/vim'}
Plug 'jorengarenar/vim-darkness'   " set notermguicolors
Plug 'ayu-theme/ayu-vim'
Plug 'taffyquinzel/chaos.vim'

call plug#end()


" {{{
"     easymotion
" easymotion binding
map  <BS> <Plug>(easymotion-bd-f)
nmap <BS> <Plug>(easymotion-overwin-f)
" }}}


" {{{
"     looks
" set linebreak character
let &showbreak='᚛ '
" set list characters
set list
" set listchars=tab:▷␣,trail:·,extends:◣,precedes:◢,nbsp:○,eol:↵,space:·
set listchars=tab:\|-,trail:-,extends:>,precedes:<,nbsp:%

" Height of the command bar
set cmdheight=2

" Turn on the WiLd menu
set wildmenu
" Ignore compiled files
set wildignore=*.aux,*.o,*~,*.pyc

" Always show current position
set ruler

" enable cursor bar & column highlighter
" set cursorcolumn " slows down vim extremely
set cursorline

" cursor color settings (does not work in all terminals, terminal needs to support escape sequence 12)
" use an red cursor in insert mode (same as inverted terminal cursor color)
let &t_SI = "\<Esc>]12;#f14d24\x7"
" use a light blue cursor otherwise (same as normal cursor color)
let &t_EI = "\<Esc>]12;#24c8f1\x7"


" folding
set foldmethod=indent

set belloff=all

" gui stuff
if or(has('gui'), s:nvim)
    " set font permanently
    set guifont=Source\ Code\ Pro\ Medium:h12
    " TODO: What is happening here with the pc speaker?????
    " disable pc speaker bell
    if !s:nvim
        " use an actual render, greatly REDUCES performance.
        "TODO: Find out what's going on here???
        " set renderoptions=type:directx
                    " \,gamma:1.5
                    " \,contrast:0.5
                    " \,level:0.5
                    " \,geom:1
                    " \,renmode:5
                    " \,taamode:1

        " remove menubar
        set guioptions -=m
        " remove toolbar
        set guioptions -=T
        " remove scrollbar
        set guioptions -=r
        set guioptions -=R
        set guioptions -=l
        set guioptions -=L
    else
        " neovide options
        let g:neovide_cursor_vfx_mode=""
        let g:neovide_refres_rate=60
        let g:neovide_cursor_animation_length=0
        let g:neovide_cursor_trail_length=0
        let g:neovide_cursor_antialiasing=v:true
        let g:neovide_no_idle=v:true

        " For some reason Neovide does not listen to dpi settings, so we use a bigger font.
        "   TODO: Neovide refuses to use the font specified.
        " set guifont=Source\ Code\ Pro\ Medium:h12
    endif
elseif has('termguicolors')
    set termguicolors
endif

" colorscheme
" set background=dark
" colorscheme black_default
colorscheme chaos
" }}}


" {{{
"     misc
" cleanup whitespace automatically
function! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call StripTrailingWhitespaces()

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8
" Use Unix as the standard file type
if s:win32
    set ffs=dos,unix,mac
else
    set ffs=unix,dos,mac
endif

" Enable use of the mouse with the ability to paste with middle mouse button
set mouse=a

" make sure plugins can read filetypes
filetype indent plugin on

" show command keys pressed
set showcmd

" always show the status line
set laststatus=2

" set up tabs properly
" set size of tabs
set tabstop=4
set shiftwidth=4
" insert space instead of tab
set expandtab

" set up scrolling better
set scrolloff=7

" make commands case insensitive
set wildignorecase " for filenames
set ignorecase " for commands
set smartcase " fix for search(replace)
set infercase " fix for auto complete in insert mode

" use autoindent
set autoindent

" disable auto comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Use XML highlilghting for .Xaml files
au BufNewFile,BufRead *.xaml        setf xml

" Set the correct file type for .yga files
au BufNewFile,BufRead *.yga         setf yga

" automatically reread changed file
set autoread
" autoread doesn't always update automatically. With :checktime the autoread is forcibly triggers autoread.
map <F5> :checktime<CR>
map! <F5> <C-O>:checktime<CR>

" highlight all searched items
set hlsearch
" immediatly go to result when searching
set incsearch

" preview substitute changes
if s:nvim
    set inccommand=split
endif
" }}}


" {{{
"     nerdcommenter
let NERDSpaceDelims=1
let g:NERDCustomDelimiters = {
            \ 'nim': { 'left': '#', 'leftAlt': '#[', 'rightAlt': ']#' },
            \ 'v': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
            \ 'yga': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' }
            \ }
" }}}


" {{{
"     remappings
map <Space> <leader>

nnoremap <leader><Space> :
nnoremap <leader>; :

" build with <Leader>m
nnoremap <silent> <Leader>m :make<CR>
" build release with <Leader>M
nnoremap <silent> <Leader>M :make release<CR>

" source current window with <Leader>s
nnoremap <silent> <Leader>% :so%<CR>

" disable search highlighting with <Leader>n
nnoremap <silent> <Leader>n :nohl<CR>

" open a split window with <Leader>s
nnoremap <Leader>e :e<Space>
nnoremap <Leader>s :sp<Space>
nnoremap <Leader>v :vsp<Space>
nnoremap <silent> <Leader>S :sp<CR>
nnoremap <silent> <Leader>V :vsp<CR>

" save and close buffer with <Leader>x
nnoremap <silent> <Leader>x :x<CR>
nnoremap <silent> <Leader>X :x!<CR>
" close buffer with <Leader>q
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>Q :q!<CR>
" write buffer with <Leader>s
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>W :w!<CR>

" jump to tag definition on vertical split
nnoremap <silent> <Leader>] :vsp<CR>:tag<CR>
set tags=./tags,tags,s:vimdir . /commontags
nnoremap <Leader>gt :!ctags -R --exclude=build --exclude=.git -f "s:vimdir . commontags/ . pwd" ./

" save file with sudo permissions
if s:nvim
    cmap w!! w suda://%
else
    cmap w!! %w !sudo tee %
endif

" tab navigation
nnoremap <F2> :tabprevious<CR>
nnoremap <F3> :tabnext<CR>

" terminal
" enter normal mode with <Esc>
if s:nvim
    :tnoremap <Esc> <C-\><C-n>
else
    :tnoremap <Esc> <C-W>N
endif

" show syntax highlight group of word under the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}


" {{{
"     tmpfiles

" tell it to use an undo file
set undofile
" set a directory to store the undo history
execute "set undodir=" . s:vimdir . "undo/"

" put backupfiles in one place
if !isdirectory(s:vimdir . 'backup')
    if s:win32
        silent execute "!mkdir " . substitute(s:vimdir . "backup/", "/", "\\\\", "g")
    else
        silent execute "!mkdir " . s:vimdir . "backup/"
    endif
endif
execute "set backupdir=" . s:vimdir . "backup/"

" put swapfiles in one place
if !isdirectory(s:vimdir . 'swp')
    if s:win32
        silent execute "!mkdir " . substitute(s:vimdir . "swp/", "/", "\\\\", "g")
    else
        silent execute "!mkdir " . s:vimdir . "swp/"
    endif
endif
execute "set directory=" . s:vimdir . "swp/"

" put viminfo file in one place
if !isdirectory(s:vimdir . 'viminfo')
    if s:win32
        silent execute "!mkdir " . substitute(s:vimdir . "viminfo/", "/", "\\\\", "g")
    else
        silent execute "!mkdir " . s:vimdir . "viminfo/"
    endif
endif
execute "set viminfo+=n" . s:vimdir . "viminfo"

" }}}


" {{{
"     make stuff
" auto save file on :make
set autowrite
" specify what to do on :make
if s:win32
    set makeprg=build.bat
else
    set makeprg=./build.sh
endif
" }}}


" {{{
"     local vimrc files
" allow loading of local vimrc files
set exrc
" don't allow :autocmd in local vimrc files
set secure
" }}}


" {{{
"     vimrc_example
" don't be compatible with vi
set nocompatible
" when opening a file jump to the position active when the file was lasted closed
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' && &diff != 1
            \ |     execute "normal! g`\""
            \ | endif
" }}}


" {{{
"     slimv
" tmux command
" let g:slimv_swank_cmd = '!tmux new-window -d -n REPL-SBCL ros run --load $HOME/.vim/plugged/slimv/slime/start-swank.lisp'
" built in terminal command
let g:slimv_swank_cmd = ':term ros run --load $HOME/.config/nvim/plugged/slimv/slime/start-swank.lisp'
let g:slimv_lisp = 'sbcl'
" disable paredit mode
let g:paredit_mode = 0
let g:slimv_balloon = 1
" }}}


" {{{
"     git stuff
" disable folding for git buffers
autocmd FileType git set nofoldenable
" }}}


" {{{
"     netrw
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_winsize = 25
" }}}


" {{{
"     fzf
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
let $FZF_DEFAULT_COMMAND = 'fd --type f --exclude build'

" search through all open buffers
nmap <Leader>b :Buffers<CR>
" search through files in current working directory
nmap <Leader>f :Files <CR>

" ripgrep search with <Leader>g
nnoremap <Leader>g :Rg<Space>
nnoremap <silent> <Leader>G :Rg <C-R><C-W><CR>

" To really select the output and get it into the quickfix window , first
" select all the output with <C-a> and then use <C-q> to populate and open the
" quickfix window.
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

let g:fzf_action = {
            \ 'ctrl-q': function('s:build_quickfix_list'),
            \}
" }}}
