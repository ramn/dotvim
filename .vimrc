source /etc/vim/vimrc

call pathogen#infect()

set nobackup
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set nowrap
set dir=~/tmp
set textwidth=0 " Turns off insertion of line breaks in long lines
set formatoptions-=tc
set ruler
set backspace=indent,eol,start
set relativenumber number
set nojoinspaces
set grepprg=git\ grep\ -n\ $*
" Make search using lower case case insensitive, but if any upper case char
" is included in the search string, the search is case sensitive.
set smartcase

set nocompatible " We're running Vim, not Vi!
syntax on " Enable syntax highlighting
filetype off " Shut it off - to reload it! Needed by pathogen.
filetype on " Enable filetype detection
filetype indent on " Enable filetype-specific indenting
filetype plugin on " Enable filetype-specific plugins
"compiler ruby " Enable compiler support for ruby

if &term =~ '^screen'
  " tmux knows the extended mouse mode
  " http://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column/19253251#19253251
  set ttymouse=sgr
  " set ttymouse=xterm2
endif
set term=xterm


colorscheme slate
"set lines=62 columns=120 "sets window size

hi MatchParen cterm=none ctermbg=black ctermfg=magenta
set showmatch

try
function CatchedChecktime()
    try
        checktime
    catch
    endtry
endfunction
catch
endtry

augroup myglobal
    autocmd!
    au InsertEnter * call CatchedChecktime()
augroup END

set ic
set foldmethod=manual

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType yaml setlocal ai sw=2 sts=2 et
  autocmd FileType sql setlocal ai sw=2 sts=2 et
  autocmd FileType rust setlocal sw=4 sts=4 et tw=80
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType mail setlocal wrap linebreak keywordprg=gnome-dictionary
  autocmd FileType text setlocal ai sw=2 sts=2 et
  autocmd FileType sh setlocal ai sw=2 sts=2 et
augroup END


" Are we in GVim or vim in Terminal?
if (has("gui_macvim") || has("gui_gnome")) && has("gui_running")
  "
else
  set mouse=a
endif


" ToggleComment plugin config
" map \c :call CommentLineToEnd('#')<CR>+
" map \\ :call CommentLineToEnd('//')<CR>+
" noremap \- :call CommentLineToEnd('--')<CR>+
" noremap \{ :call CommentLinePincer('{# ', ' #}')<CR>+
" noremap \< :call CommentLinePincer('<!--', '-->')<CR>+
" map ,* :call CommentLinePincer('/* ', ' */')<CR>+


" vim-commentary config
autocmd FileType sql set commentstring=--\ %s
nmap \\ gcc

" Press Space to turn off highlighting and clear any message already
" displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>


if (has('mac'))
  set clipboard=unnamed
elseif version >= 704
  " Regular yanks go to system clipboard
  set clipboard=unnamedplus
  " Visual yanks go to system mouse middlebutton clipboard
  " set clipboard=autoselectplus,exclude:cons\|linux
endif

" Map esc-w to write file
nnoremap <Esc>w :w<CR>
inoremap <Esc>w <Esc>:w<CR>

" Mappings for tabs:
" meta-t       = > :tabnew
" meta-shift-t = > :tabclose
nnoremap t :tabnew<CR>
nnoremap T :tabclose<CR>


" NERDTree
let NERDTreeIgnore = ['\.pyc$']
let g:NERDTreeWinSize=41
nnoremap <F12> :NERDTreeToggle<CR>


" Netrw
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_liststyle = 3

" ctrlp config
let g:ctrlp_jump_to_buffer = 1
let g:ctrlp_custom_ignore = {
\   'file': '\.pyc$\|\.class$',
\   'dir': 'target$\|build$'
\ }

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Easy split navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-Left> <C-w>h
noremap <C-Down> <C-w>j
noremap <C-Up> <C-w>k
noremap <C-Right> <C-w>l


" Render markdown buffer as html
nnoremap <F8> :w ! markdown \| lynx -stdin<enter>

" Syntastic (syntax checker plugin)
let g:syntastic_mode_map = { 'mode': 'passive',
      \ 'active_filetypes': ['ruby', 'python'],
      \ 'passive_filetypes': ['puppet'] }

" Split method parameter list in several lines
" Best for Python
" nnoremap <F7> :s/\v^(.{-}\()(.*)/\1\r\2/<CR> :s/, /,\r/g<CR>
" Best for Scala
nnoremap <F7> :s/\v^(.{-}\()(.*)/\1\r\2/e<CR> :s/, /,\r/ge<CR> :s/\v(.*)(\))/\1\r\2/e<CR>

" Tagbar keybindings
nnoremap <F6> :TagbarToggle<CR>

" Make it unlikely to accidentally enter the horrible Ex mode
nnoremap Q <nop>

" Ctags
set tags=./.tags;,.tags;,./tags;,tags;

" Bring up todo's in quickfix list
noremap <leader>gt :grep! TODO\\\\\|FIXME <CR>:cw<CR>
