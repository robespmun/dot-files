call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'zivyangll/git-blame.vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'freitass/todo.txt-vim'

Plug 'vim-airline/vim-airline'

Plug 'morhetz/gruvbox'

Plug 'christoomey/vim-tmux-navigator'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

call plug#end()

colorscheme gruvbox

set relativenumber
set ignorecase
set smartcase

set smarttab
set cindent
set tabstop=2
set shiftwidth=2
" always uses spaces instead of tab characters
set expandtab

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>yy  "+yy

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" Remap for do codeAction of selected region
"function! s:cocActionsOpenFromSelected(type) abort
  "execute 'CocAction ' . a:type
"endfunction
"xmap <silent> <leader>a :<C-u>execute 'CocAction ' . visualmode()<CR>
"nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

nmap <silent> gk <Plug>(coc-codeaction)

" coc config
let g:coc_global_extensions = [
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ ]

command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gk <Plug>(coc-action)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

let g:NERDTreeIgnore = ['^node_modules$']
let NERDTreeShowHidden=1

" sync open file with NERDTree
" " Check if NERDTree is open or active
"function! IsNERDTreeOpen()        
  "return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
"endfunction

" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
"function! SyncTree()
  "if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    "NERDTreeFind
    "wincmd p
  "endif
"endfunction

" Highlight currently open buffer in NERDTree
" autocmd BufEnter * call SyncTree()

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! CheckIfCurrentBufferIsFile()
  return strlen(expand('%')) > 0
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && CheckIfCurrentBufferIsFile() && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufRead * call SyncTree()

function! ToggleTree()
  if CheckIfCurrentBufferIsFile()
    if IsNERDTreeOpen()
      NERDTreeClose
    else
      NERDTreeFind
    endif
  else
    NERDTree
  endif
endfunction

" open NERDTree with ctrl + n
nmap <C-n> :call ToggleTree()<CR>

nmap <C-n> :NERDTreeToggle<CR>

vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

" golang gd
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)

" ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

" Format JSON
com! FormatJSON %!python -m json.tool

syntax on 
filetype plugin on
