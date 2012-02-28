source /etc/vim/vimrc

call pathogen#runtime_append_all_bundles()

set nobackup
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set nowrap
set dir=~/tmp

set grepprg=git\ grep\ $*

set nocompatible " We're running Vim, not Vi!
syntax on " Enable syntax highlighting
filetype off " Shut it off - to reload it! Needed by pathogen.
filetype on " Enable filetype detection
filetype indent on " Enable filetype-specific indenting
filetype plugin on " Enable filetype-specific plugins
compiler ruby " Enable compiler support for ruby
colorscheme slate
"set lines=62 columns=120 "sets window size

function CatchedChecktime()
    try
        checktime
    catch
    endtry
endfunction

augroup myglobal
    autocmd!
    au InsertEnter * call CatchedChecktime()
augroup END

set ic
set foldmethod=marker

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType yaml set ai sw=2 sts=2 et
  autocmd FileType python set omnifunc=pythoncomplete#Complete
augroup END


" Are we in GVim or vim in Terminal?
if (has("gui_macvim") || has("gui_gnome")) && has("gui_running")
  "
else
  set mouse=a
endif

map \c :call CommentLineToEnd('#')<CR>+
map \\ :call CommentLineToEnd('//')<CR>+
noremap \{ :call CommentLinePincer('{# ', ' #}')<CR>+
" map ,* :call CommentLinePincer('/* ', ' */')<CR>+

" Press Space to turn off highlighting and clear any message already
" displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>


if (has('mac'))
  set clipboard=unnamed
endif

" Map esc-w to write file
nnoremap <Esc>w :w<CR>
inoremap <Esc>w <Esc>:w<CR>

" Mappings for tabs:
" meta-t       = > :tabnew
" meta-shift-t = > :tabclose
nnoremap t :tabnew<CR>
nnoremap T :tabclose<CR>


" NERDTree ignores
let NERDTreeIgnore = ['\.pyc$']
nnoremap [24~ :NERDTreeToggle<CR>


" Netrw
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_liststyle = 3

" ctrlp config
let g:ctrlp_jump_to_buffer = 1

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv
