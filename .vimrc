" Source a global configuration file if available
if filereadable("/etc/vim/vimrc")
  source /etc/vim/vimrc
endif

call pathogen#infect()

set nobackup
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set nowrap
set dir=~/tmp/vim_swp/
set textwidth=0 " Turns off insertion of line breaks in long lines
set formatoptions-=tc
set ruler
set backspace=indent,eol,start
set relativenumber number
set nojoinspaces
set grepprg=rg\ --vimgrep
" Make search using lower case case insensitive, but if any upper case char
" is included in the search string, the search is case sensitive.
set smartcase
set breakindent
set nosmartindent

" Don't scroll while searching
set noincsearch
" Highlight search results
set hls

set nocompatible " We're running Vim, not Vi!
syntax on " Enable syntax highlighting
filetype off " Shut it off - to reload it! Needed by pathogen.
filetype on " Enable filetype detection
filetype indent on " Enable filetype-specific indenting
filetype plugin on " Enable filetype-specific plugins
"compiler ruby " Enable compiler support for ruby

if (&term =~ '^screen' || &term =~ 'tmux' || &term =~ 'alacritty') && !has("nvim")
  " tmux knows the extended mouse mode
  " http://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column/19253251#19253251
  set ttymouse=sgr
  " set ttymouse=xterm2
endif

if !has("nvim")
  set term=xterm
endif


if !has("nvim")
  colorscheme slate_vim82
  " colorscheme slate
else
  set background=dark
  colorscheme elflord
  " colorscheme slate
  " set termguicolors
endif
"set lines=62 columns=120 "sets window size

hi MatchParen cterm=none ctermbg=black ctermfg=yellow
hi Search term=reverse cterm=none ctermfg=black ctermbg=yellow
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
  autocmd FileType rust setlocal sw=4 sts=4 et tw=99 nosmartindent cindent formatoptions-=r formatoptions-=o
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType mail setlocal wrap linebreak keywordprg=gnome-dictionary
  autocmd FileType text setlocal ai sw=2 sts=2 et
  autocmd FileType sh setlocal ai sw=2 sts=2 et
  autocmd FileType gitcommit setlocal tw=80
  autocmd FileType typescript setlocal sw=4 sts=4 et nosmartindent cindent
  autocmd FileType markdown setlocal tw=80
  autocmd FileType odin setlocal sw=4 sts=4 et tw=80 nosmartindent cindent

  " vim-commentary config
  autocmd FileType sql setlocal commentstring=--\ %s
  autocmd FileType dot setlocal commentstring=//\ %s
  autocmd FileType sbt setlocal commentstring=//\ %s
  autocmd FileType ocaml setlocal commentstring=(*%s*)
  autocmd FileType cpp setlocal commentstring=//\ %s
augroup END


"
" Format bindings
"
function SetRustBindings()
  if has("nvim")
    nnoremap <A-f> :RustFmt<CR>
    nnoremap <A-m> :make check --workspace --tests<CR>:cw<CR>
    nnoremap <A-n> :cn<CR>
    nnoremap <A-p> :cp<CR>
  else
    nnoremap <Esc>f :RustFmt<CR>
    nnoremap <Esc>m :make check --workspace --tests<CR>:cw<CR>
    nnoremap <Esc>n :cn<CR>
    nnoremap <Esc>p :cp<CR>
  endif
endfunction

function SetTerraformFormatBindings()
  if has("nvim")
    nnoremap <A-f> :TerraformFmt<CR>
    inoremap <A-f> <Esc>:TerraformFmt<CR>
  else
    nnoremap <Esc>f :TerraformFmt<CR>
    inoremap <Esc>f <Esc>:TerraformFmt<CR>
  endif
endfunction


function CFormat()
  let save_pos = getpos(".")
  exe '%! clang-format'
  call setpos(".", save_pos)
endfunction

function SetCBindings()
  if has("nvim")
    nnoremap <A-f> :call CFormat()<CR>
    inoremap <A-f> <Esc>:call CFormat()<CR>
  else
    nnoremap <Esc>f :call CFormat()<CR>
    inoremap <Esc>f <Esc>:call CFormat()<CR>
  endif
endfunction


function OdinFormat()
  let save_pos = getpos(".")
  exe '%! odinfmt -stdin=true %'
  call setpos(".", save_pos)
endfunction

function SetOdinBindings()
  if has("nvim")
    nnoremap <A-f> :call OdinFormat()<CR>
    inoremap <A-f> <Esc>:call OdinFormat()<CR>
  else
    nnoremap <Esc>f :call OdinFormat()<CR>
    inoremap <Esc>f <Esc>:call OdinFormat()<CR>
  endif
endfunction


function GolangFormat()
  " let save_pos = getpos(".")
  " exe '! gofmt -w "%" "%"'
  write
  cexpr system('gofmt -e -w ' . expand('%'))
  if len(getqflist()) > 0
    " cfirst
  else
    edit!
  endif
  " call setpos(".", save_pos)
endfunction

function SetGolangBindings()
  if has("nvim")
    nnoremap <A-f> :call GolangFormat()<CR>
    inoremap <A-f> <Esc>:call GolangFormat()<CR>
  else
    nnoremap <Esc>f :call GolangFormat()<CR>
    inoremap <Esc>f <Esc>:call GolangFormat()<CR>
  endif
endfunction


augroup myfilebindings
  autocmd FileType rust call SetRustBindings()
  autocmd FileType terraform call SetTerraformFormatBindings()
  autocmd FileType c call SetCBindings()
  autocmd FileType odin call SetOdinBindings()
  autocmd FileType go call SetGolangBindings()
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

" Map key to comment out line
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
if has("nvim")
  nnoremap <A-w> :w<CR>
  inoremap <A-w> <Esc>:w<CR>
else
  nnoremap <Esc>w :w<CR>
  inoremap <Esc>w <Esc>:w<CR>
endif

" Mappings for tabs:
" meta-t       = > :tabnew
" meta-shift-t = > :tabclose
if has("nvim")
  nnoremap <A-t> :tabnew<CR>
  nnoremap <A-T> :tabclose<CR>
else
  nnoremap <Esc>t :tabnew<CR>
  nnoremap <Esc>T :tabclose<CR>
endif


" NERDTree
let g:NERDTreeIgnore = ['\.pyc$']
let g:NERDTreeWinSize=41
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeSortOrder=[]
let g:NERDTreeDirArrowExpandable='+'
let g:NERDTreeDirArrowCollapsible='~'
nnoremap <F12> :NERDTreeToggle<CR>


" Netrw
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_liststyle = 3

" ctrlp config
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -cmo --exclude-standard | sort -u', 'find %s -type f']
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
nnoremap <F8> :w ! pulldown-cmark \| lynx -stdin<enter>

" Syntastic (syntax checker plugin)
" let g:syntastic_mode_map = { 'mode': 'passive',
"       \ 'active_filetypes': ['ruby', 'python'],
"       \ 'passive_filetypes': ['puppet', 'go'] }

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

" Color column toggle
function! g:ToggleColorColumn(col)
  if &colorcolumn != ''
    setlocal colorcolumn&
  else
    " setlocal colorcolumn=+1
    execute "setlocal colorcolumn=".a:col
  endif
endfunction
" nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>
nnoremap <silent> <F9> :call g:ToggleColorColumn(80)<CR>
nnoremap <silent> <S-F9> :call g:ToggleColorColumn(100)<CR>

" Style guide approved scaladoc indentation
let g:scala_scaladoc_indent = 1

" Rust config
let g:rust_recommended_style = 0
" let g:rustfmt_autosave = 1

" binds macro d - debug print statement in Rust
let @d = 'ieprintln!("{:?}", );b'
let @u = 'iunimplemented!();=='

" " plasticboy/vim-markdown config
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_no_default_key_mappings = 1
" let g:vim_markdown_auto_insert_bullets = 0
" let g:vim_markdown_new_list_item_indent = 0

" preservim/vim-markdown config
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_no_default_key_mappings = 1
" let g:vim_markdown_new_list_item_indent = 2

" gabrielelana/vim-markdown.git
" let g:markdown_include_jekyll_support = 0
" let g:markdown_enable_mappings = 0
" let g:markdown_enable_insert_mode_mappings = 0
" let g:markdown_enable_spell_checking = 0
" let g:markdown_enable_input_abbreviations = 0

" tpope/vim-markdown


" Protect against vulnerability
" https://threatpost.com/linux-command-line-editors-high-severity-bug/145569/
set nomodeline


"
" rust-analyzer
"
" if executable('rust-analyzer')
"   au User lsp_setup call lsp#register_server({
"         \   'name': 'Rust Language Server',
"         \   'cmd': {server_info->['rust-analyzer']},
"         \   'whitelist': ['rust'],
"         \   'initialization_options': {
"         \     'diagnostics': {
"         \       'enable': 0
"         \     }
"         \   }
"         \ })
" endif

" function! s:on_lsp_buffer_enabled() abort
"     setlocal omnifunc=lsp#complete
"     setlocal signcolumn=yes
"     if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
"     nmap <buffer> gd <plug>(lsp-definition)
"     nmap <buffer> gs <plug>(lsp-document-symbol-search)
"     nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
"     nmap <buffer> gr <plug>(lsp-references)
"     nmap <buffer> gi <plug>(lsp-implementation)
"     nmap <buffer> gt <plug>(lsp-type-definition)
"     nmap <buffer> <leader>rn <plug>(lsp-rename)
"     nmap <buffer> [g <plug>(lsp-previous-diagnostic)
"     nmap <buffer> ]g <plug>(lsp-next-diagnostic)
"     nmap <buffer> K <plug>(lsp-hover)
"     nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
"     nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

"     let g:lsp_format_sync_timeout = 1000
"     autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

"     " refer to doc to add more commands
" endfunction

" augroup lsp_install
"     au!
"     " call s:on_lsp_buffer_enabled only for languages that has the server registered.
"     autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
" augroup END
