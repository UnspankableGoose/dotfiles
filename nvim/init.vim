" Make the vim clipboard sync with the system clipboard.
set clipboard+=unnamedplus
" This is used so fancy stuff works!
set nocompatible
" Set terminal colour to 256 colours.
set t_Co=256
" Set tabs to 4 chars.
set tabstop=4
" Set the indentation level to 4 chars.
set shiftwidth=4
" Convert tabs to spaces
set expandtab
" Show the current number line and all the lines relative to it.
set number relativenumber
" Automatically indent
set autoindent
" Highlight all search matches
set hlsearch
" Split below and to the right by default
set splitbelow
set splitright
" Show invisible characters
set hidden
" Enable true colours
set termguicolors
" Disable markdown conceal, it's stupid

" required for vim-markdown-composer
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Easily align text and symbols.
Plug 'junegunn/vim-easy-align'

" A github event browser.
Plug 'junegunn/vim-github-dashboard'

" Code snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'drmingdrmer/xptemplate'

" Vim File Manager
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" CLI File Fuzzy Finger
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Status line for vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

" Discord RPC
Plug 'hugolgst/vimsence'

" Highlight the yanked selection
Plug 'machakann/vim-highlightedyank'

" Add extra syntax highlighting to vim
Plug 'justinmk/vim-syntax-extra'
Plug 'chr4/nginx.vim'
Plug 'cespare/vim-toml'
Plug 'ron-rs/ron.vim'
Plug 'arzg/vim-rust-syntax-ext'
Plug 'sheerun/vim-polyglot'
Plug 'Sirsireesh/vim-dlang-phobos-highlighter'
Plug 'vim-python/python-syntax'

" Source code explorer
Plug 'liuchengxu/vista.vim'

" Toggle booleans
Plug 'sagarrakshe/toggle-bool'

" Rust stuff
Plug 'racer-rust/vim-racer'

" Dotnet stuff
Plug 'OmniSharp/omnisharp-vim'

" Git stuff
Plug 'tpope/vim-fugitive'

" Indentation lines
Plug 'Yggdroot/indentLine'

" Show the colour of various colour patterns in code.
Plug 'lilydjwg/colorizer'

" Asynchronous runner
Plug 'skywind3000/asyncrun.vim'

" Highlight all instances of words on cursor
Plug 'RRethy/vim-illuminate'

" Add autoformatting to the Code
Plug 'Chiel92/vim-autoformat'

" Colorschemes and syntax highlighters.
Plug 'sickill/vim-monokai'
Plug 'tomasr/molokai'
Plug 'flrnd/plastic.vim'
Plug 'ntk148v/vim-horizon'
Plug 'levelone/tequila-sunrise.vim'
Plug 'jasoncarr0/sidewalk-colorscheme'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'dracula/vim', { 'as': 'dracula' }

" Conquer of Completion (COC)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Asynchronous markdown viewer
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" Initialize plugin system
call plug#end()

""" Config for visuals, colorschemes and syntax highlighters.

" AirLine
let g:airline_theme = 'dracula'
let g:airline_powerline_fonts = 1

" TMUX
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"
let g:tmuxline_powerline_separators = 1

colorscheme dracula
set background=dark

" Vista!!

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
      \   "function": "⨍",
      \   "variable": "𝝒",
      \   "map": "𝜆",
      \   "class" : "𝕮",
      \   "implementation" : "◌⃪ ",
      \   "struct" : "𝓐",
      \  }


""" COC

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>

""" Syntastic
" https://github.com/vim-syntastic/syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

""" Snippets

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

""" Discord RPC Configuration

let g:vimsence_small_text = 'NeoVim, The One True Editor'
let g:vimsence_small_image = 'neovim'
let g:vimsence_editing_details = 'Editing: {}'
let g:vimsence_editing_state = 'Project: {}'
let g:vimsence_file_explorer_text = 'In NERDTree'
let g:vimsence_file_explorer_details = 'Exploring the files adventure'

""" Shortcuts for windows and splits manipulation

nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Right> :wincmd l<CR>

nmap <silent> <A-C-Left> :vertical resize +5<CR>
nmap <silent> <A-C-Down> :resize +5<CR>
nmap <silent> <A-C-Up> :resize -5<CR>
nmap <silent> <A-C-Right> :vertical resize -5<CR>

""" NERDTree

map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"let NERDTreeMapOpenInTab='\r'

""" Code Runners

noremap <buffer> <F7> :exec '!clang -o vim_compiled % && ./vim_compiled' shellescape(@%, 1)<cr>
noremap <buffer> <F8> :exec '!dotnet build' shellescape(@%, 1)<cr>
noremap <buffer> <F9> :exec '!python3' shellescape(@%, 1)<cr>
noremap <buffer> <F10> :exec '!rustc -o vim_compiled % && ./vim_compiled' shellescape(@%, 1)<cr>
noremap <buffer> <F11> :exec '!cargo run' shellescape(@%, 1)<cr>


""" Other

" Alternative Copy/Paste to clipboard.
vnoremap <C-c> "+y
map  <C-p> "+P

" Map ToggleBool to `Ctrl + q`
noremap <C-q> :ToggleBool<CR>

" Highlight yank duration to 1 second.
let g:highlightedyank_highlight_duration = 1000

" Rust Racer
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

" Dotnet Server
let g:OmniSharp_server_stdio = 1

" Easy Align
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Autocomplete {}
let g:xptemplate_brace_complete = '{'

" Highlight time in ms
let g:Illuminate_delay = 250

" Bind F3 to format the code
noremap <F3> :Autoformat<CR>

" plasticboy/vim-markdown
set conceallevel=0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" display messages for autoformat
"let g:autoformat_verbosemode=1

" change the default formatter for python to black
let g:formatters_python = ['black']

" set the path to the python binary to not have surprises
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
