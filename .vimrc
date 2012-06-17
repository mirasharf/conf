"
" .vimrc
" Maintainer: Marco Elver <me AT marcoelver.com>
"

" Functions {{{
    function ToggleList()
      if !exists("b:toggle_list")
        let b:toggle_list = 0 " disabled by default if not existing
      endif

      if b:toggle_list == 0
        setlocal list
        let b:toggle_list = 1
        echo "List chars ON!"
      else
        setlocal nolist
        let b:toggle_list = 0
        echo "List chars OFF!"
      endif
    endfunction

    function SetList(toset)
      if a:toset == 0
        setlocal nolist
        let b:toggle_list = 0
      else
        setlocal list
        let b:toggle_list = 1
      endif
    endfunction

    function OverLengthHiOff()
      highlight clear OverLength
      let b:overlengthhi = 0

      " Remove autocommands
      execute "augroup OverLength_" . expand("%")
      execute "au!"
      execute "augroup END"
      execute "augroup! OverLength_" . expand("%")
    endfunction

    function OverLengthHiOn(length)
      " adjust colors/styles as desired
      highlight OverLength ctermbg=darkred gui=undercurl guisp=blue
      " change '81' to be 1+(number of columns)
      let l:match_cmd = "match OverLength /\\%" . (str2nr(a:length)+1) . "v.\\+/"
      execute l:match_cmd

      let b:overlengthhi = 1

      " This is to ensure the highlighting is buffer-local, as match defaults
      " to window-local.
      execute "augroup OverLength_" . expand("%")
      execute "au!"
      execute "au BufWinEnter " . expand("%") . " highlight OverLength ctermbg=darkred gui=undercurl guisp=blue | " . l:match_cmd
      execute "au BufWinLeave " . expand("%") . " highlight clear OverLength"
      execute "augroup END"
    endfunction

    function ToggleOverLengthHi(length)
      if exists("b:overlengthhi") && b:overlengthhi
        call OverLengthHiOff()
        echo "[ToggleOverLengthHi] OverLength highlight OFF"
      else
        call OverLengthHiOn(a:length)
        echo "[ToggleOverLengthHi] OverLength highlight ON"
      endif
    endfunction

    function ExecuteCursorFile()
      let l:file_name = expand(expand("<cfile>"))
      let l:is_url = stridx(l:file_name, "://") >= 0

      " If not existing, it might a file relative to file being edited but the
      " working directory is not the directory of the file being edited.
      if !l:is_url && !filereadable(l:file_name)
        let l:file_name = expand("%:p:h") . "/" . l:file_name
      endif

      if l:is_url || filereadable(l:file_name)
        execute "silent !xdg-open '" . l:file_name . "' &> /dev/null &"
        redraw!
        echo "[ExecuteCursorFile] Opened '" . l:file_name . "'"
      else
        echo "[ExecuteCursorFile] File '" . l:file_name . "' does not exist!"
      endif
    endfunction

    function FindTabStyle(prev_line_regex)
      let l:found = 0

      for line in getline(1, 500)
        if l:found
          " Check if valid line to test for indendation style
          if line =~ "^[ \t][ \t]*[^ \t]"
            if line =~ "^\t"
              setlocal noet
              echom "[FindTabStyle] No expand tab!"
            else " must be space
              let l:spaces = 0
              while line[l:spaces] == " "
                let l:spaces += 1
              endwhile

              execute "setlocal ts=" . l:spaces
              execute "setlocal sw=" .  l:spaces
              execute "setlocal sts=" . l:spaces
              setlocal et

              echom "[FindTabStyle] Expand tabs with " . l:spaces . " spaces!"
            endif

            " done
            break
          else
            " continue search
            let l:found = 0
          endif
        endif

        if line =~ a:prev_line_regex
          let l:found = 1
        endif
      endfor
    endfunction
" }}}

" Plugins {{{
    " Pathogen {{{
      runtime! autoload/pathogen.vim
      if exists("*pathogen#infect")
        call pathogen#infect()
      endif
    " }}}

    " NERDTree {{{
      let g:NERDTreeBookmarksFile = $HOME . "/.vim/.NERDTreeBookmarks"
      let g:NERDTreeWinSize=28
    " }}}
" }}}

" General {{{
    set nocompatible " get out of vi-compatible mode
    set noexrc " do not execute vimrc in local dir
    set cpoptions=aABceFs " vim defaults

    set encoding=utf-8
    set backspace=indent,eol,start
    set fileformats=unix,dos,mac
    set hidden

    set noerrorbells
    set whichwrap=b,s,<,>

    if isdirectory($HOME . "/.vim")
      set spellfile=~/.vim/spellfile.add
    else
      set spellfile=~/.vimspellfile.add
    endif

    set spelllang=en
" }}}

" Vim UI {{{
    if has("mouse") && !exists("no_mouse_please")
      set mouse=a
    endif

    syntax on " syntax highlighting on

    " Show unwanted chars
    set nolist
    if v:version >= 700
      set listchars=tab:»·,trail:·
    else
      set listchars=tab:>-,trail:-
    endif

    "set showmatch
    "set matchtime=5
    set novisualbell
    set report=0
    set ruler
    set scrolloff=3
    set showcmd
    set laststatus=2
    set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
    set titlestring=[%{hostname()}]%(\ %)%t%(\ %M%)%(\ (%{expand(\"%:.:h\")})%)%(\ %a%)%(\ -\ VIM%)
    set incsearch
    set hlsearch

    " Autocompletion
    set completeopt=menuone
" }}}

" Default Text Formatting {{{
    if has("autocmd")
      filetype plugin indent on
    else
      set autoindent
    endif " has("autocmd")

    "set formatoptions=rq " Automatically insert comment leader on return
    set wrap
" }}}

" Folding {{{
    set foldenable
    set foldmarker={{{,}}}
    set foldmethod=marker
    set foldlevel=0
" }}}

" Mappings {{{
    " Fold toggle
    map <C-F> za

    " Fold close all - zR to unfold all
    "map <C-F> zM

    map <C-H> <ESC>:noh<CR>

    imap <S-CR> <ESC>

    " NERDTree plugin; redraw! hack required for gvim in tiling WM
    map <C-N> <ESC>:NERDTreeToggle<Bar>redraw!<Bar>redraw!<CR>

    " taglist plugin
    map <C-T> <ESC>:TlistToggle<CR>

    map <C-L> <ESC>:call ToggleOverLengthHi(80)<CR>

    " Function keys
    map <F5> <ESC>:call g:ClangUpdateQuickFix()<CR>
    map <F9> <ESC>:call ToggleList()<CR>
    map <F10> <ESC>:call ToggleList()<CR>

    " Open file under cursor with xdg-open
    map xf <ESC>:call ExecuteCursorFile()<CR>
" }}}

" Autocommands {{{
    augroup ftgroup_python
      au!
      au BufRead,BufNewFile *.py,*.pyw setf python
      au FileType python setlocal ts=8 sw=4 sts=4 et | call SetList(1) | call OverLengthHiOn(80)
      au BufNewFile *.py,*.pyw setlocal fileformat=unix
    augroup END

    augroup ftgroup_ccppobjc
      au!
      au FileType c    setlocal ts=8 sw=8 sts=8 noet | call SetList(0) | call FindTabStyle("{$") | call OverLengthHiOn(80)
      au FileType cpp  setlocal ts=4 sw=4 sts=4 noet | call SetList(0) | call FindTabStyle("{$") | call OverLengthHiOn(80)
      au FileType objc setlocal ts=4 sw=4 sts=4 noet | call SetList(0) | call FindTabStyle("{$") | call OverLengthHiOn(80)
      au BufNewFile *.c,*.cpp,*.h,*.hpp setlocal fileformat=unix
    augroup END

    augroup ftgroup_java
      au!
      au BufRead,BufNewFile *.java setlocal ts=4 sw=4 sts=4 noet | call SetList(0) | call FindTabStyle("{$")
      au BufNewFile *.java setlocal fileformat=unix
    augroup END

    augroup ftgroup_sh
      au!
      au FileType sh,bash,zsh setlocal ts=4 sw=4 sts=4 noet | call SetList(0)
    augroup END

    augroup ftgroup_perl
      au!
      au FileType perl setlocal ts=8 sw=4 sts=4 et | call SetList(0) | call FindTabStyle("{$") | call OverLengthHiOn(80)
      au BufNewFile *.pl setlocal fileformat=unix
    augroup END

    augroup ftgroup_vim
      au!
      au FileType vim setlocal ts=8 sw=2 sts=2 et ai | call SetList(1)
      au BufNewFile *.vim,*vimrc setlocal fileformat=unix
    augroup END

    augroup ftgroup_dot
      au!
      au FileType dot setlocal ts=4 sw=4 sts=4 noet ai | call SetList(0)
      au BufNewFile *.dot setlocal fileformat=unix
    augroup END

    augroup ftgroup_tex
      au!
      au FileType tex,plaintex setlocal ts=2 sw=2 sts=2 et ai tw=79 spell | call SetList(1) | call OverLengthHiOn(80)
      au BufNewFile *.tex setlocal fileformat=unix
    augroup END

    augroup ftgroup_bibtex
      au!
      au FileType bib setlocal ts=2 sw=2 sts=2 et ai tw=109 foldmarker=@,}. | call SetList(1)
      au BufNewFile *.bib setlocal fileformat=unix
    augroup END

    augroup ftgroup_sql
      au!
      au FileType sql setlocal ts=4 sw=2 sts=2 et | call SetList(1)
      au BufNewFile *.sql setlocal fileformat=unix
    augroup END

    augroup ftgroup_text
      au!
      au BufRead,BufNewFile *README*,*INSTALL*,*TODO* setlocal ts=4 sw=4 sts=4 tw=79 et | call SetList(0)
    augroup END

    augroup ftgroup_slice
      au!
      au FileType slice setlocal ts=4 sw=4 sts=4 et ai | call SetList(0)
      au BufNewFile *.ice setlocal fileformat=unix
    augroup END

    augroup ftgroup_haskell
      au!
      au FileType haskell setlocal ts=8 sw=4 sts=4 et | call SetList(1) | call OverLengthHiOn(80)
      au BufNewFile *.hs setlocal fileformat=unix
    augroup END

    augroup ftgroup_htmlcss
      au!
      au FileType html,xhtml,css setlocal ts=2 sw=2 sts=2 tw=79 noet | call SetList(0)
      au BufNewFile *.htm,*.html,*.css setlocal fileformat=unix
    augroup END

    augroup ftgroup_js
      au!
      au FileType javascript setlocal ts=4 sw=4 sts=4 noet | call SetList(0) | call FindTabStyle("{$")
      au BufNewFile *.js setlocal fileformat=unix
    augroup END

    augroup ftgroup_php
      au!
      " [fo]rmatoptions is setlocal to allow text-wrap like in HTML files.
      au FileType php setlocal ts=2 sw=2 sts=2 tw=79 fo=tqrowcb noet | call SetList(0)
      au BufNewFile *.php setlocal fileformat=unix
    augroup END

    augroup ftgroup_xmlant
      au!
      au FileType xml,ant setlocal ts=2 sw=2 sts=2 noet | call SetList(0)
      au BufNewFile *.xml setlocal fileformat=unix
    augroup END

    augroup ftgroup_rst
      au!
      au FileType rst setlocal ts=8 sw=4 sts=4 tw=79 et spell | call SetList(1) | call OverLengthHiOn(80)
      au BufNewFile *.rst setlocal fileformat=unix
    augroup END

    augroup ftgroup_cmake
      au!
      au BufRead,BufNewFile *.cmake,CMakeLists.txt setf cmake
      au FileType cmake setlocal ts=8 sw=4 sts=4 et | call SetList(1)
      au BufNewFile *.cmake,CMakeLists.txt setlocal fileformat=unix
    augroup END

    augroup ftgroup_Makefile
      au!
      au FileType automake,make setlocal noet
      au BufNewFile Makefile* setlocal fileformat=unix
    augroup END

    augroup ftgroup_hdl
      au!
      au FileType verilog setlocal ts=3 sw=3 sts=3 noet | call SetList(0) | call OverLengthHiOn(80)
      au BufNewFile *.v setlocal fileformat=unix
    augroup END

    augroup ftgroup_lua
      au!
      au FileType lua setlocal ts=4 sw=4 sts=4 et | call SetList(1)
    augroup END

    " PLAN: last, override existing settings, use my taskman script.
    augroup ftgroup_PLAN
      au!
      au BufRead,BufNewFile *PLAN*,*/gtd/*.rst call taskman#setup() | setlocal tw=109 | call OverLengthHiOn(110)
    augroup END

" }}}

" GUI/Term Specific Settings {{{
    if has("gui_running")
      " GUI {{{
      " Set font, based on preference and if available:
      if has("win32")
        set guifont=Consolas:h11:cANSI
      else
        if exists("use_alt_font")
          set guifont=Terminus\ 12
        else
          set guifont=Monospace\ 11
        endif
      endif

      set columns=120
      set lines=45
      set mousehide

      "set guioptions=aegimrLt
      set guioptions=aegiLt

      "set background=dark
      try
        colorscheme desertEx
      catch /^Vim\%((\a\+)\)\=:E185/
        echo "WARNING: Preferred GUI colorscheme not found!"
        colorscheme desert
      endtry

      " GUI Mappings {
        " Toggle menubar
        nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>

        " Toggle scrollbar
        nnoremap <C-F2> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

        " Toggle toolbar
        nnoremap <C-F3> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>

        " Copy/Paste
        vmap <C-M-C> "+y
        nmap <C-M-V> "+gP
      " }
      " }}}
    else
      " Terminal {{{
      set background=dark

      " Terminal color palette; shouldn't need to set this, as vim detects
      " this properly if TERM=xterm-256color is set by terminal emulator.
      "set t_Co=256

      colorscheme wombat256 " Should override background if neccessary
      " }}}
    endif
" }}}

" vim: set ts=8 sw=2 sts=2 et ai foldmarker={{{,}}} foldlevel=0 fen fdm=marker:
