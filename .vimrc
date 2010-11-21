source /etc/vim/vimrc

call pathogen#runtime_append_all_bundles()

set nobackup
set shiftwidth=2
set tabstop=2
set expandtab
set nowrap
set dir=~/tmp

set nocompatible " We're running Vim, not Vi!
syntax on " Enable syntax highlighting
filetype on " Enable filetype detection
filetype indent on " Enable filetype-specific indenting
filetype plugin on " Enable filetype-specific plugins
compiler ruby " Enable compiler support for ruby
colorscheme slate
set lines=62 columns=120
map \b :FufBuffer 
"map \f :FufFile **/
map \f :FufCoverageFile 
au InsertEnter *.* checktime
set ic

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType yaml set ai sw=2 sts=2 et
augroup END

source ~/.vim/plugin/lodgeit.vim

