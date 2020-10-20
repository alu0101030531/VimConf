set number
set mouse=a
set numberwidth=1
set clipboard=unnamed
syntax enable
set showcmd
set ruler
set encoding=utf-8
set showmatch
set sw=2
set relativenumber

set laststatus=2
set noshowmode

command! -nargs=1 Class call Class(<f-args>) 

call plug#begin('~/.vim/plugged')

" Themes
Plug 'morhetz/gruvbox'

" IDE
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}


call plug#end()

colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"
let NERDTreeQuitOnOpen=1

let mapleader = " "

nmap <Leader>s <Plug>(easymotion-s2)
nmap <Leader>f :NERDTreeFind<CR>

" Vim shortcuts
nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>

" COC.vim
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"File switch for c++ files
function! SwitchSourceHeader()
  :w
  if (expand ("%:e") == "cpp")
    :e %:t:r.h
  else
    :e %:t:r.cpp
  endif
endfunction

nmap <Leader>a :call SwitchSourceHeader()<CR>

fun! CreateFuncSrc()
  let func = getline('.')[:-2]
  call cursor(0, 1)
  let lnum = search('class')
  let className = split(getline(lnum))[1]
  let newFunc = join(split(func), " " . className . "::")
  if (expand ("%:e") == "h")
"    :$-1
    let file = expand('%:t:r') . ".cpp"
    call writefile(["", newFunc . " {","}"], file, 'a') 
    :vsp %:t:r.cpp 
  endif
endfun
nmap <Leader>j :call CreateFuncSrc() <CR>

 "C++ Class Generator                                                                                                    
 function! Class(ClassName)                                                                                              
    "==================  editing header file =====================                                                       
     let header = a:ClassName.".h"                                                                                                                                                                                                                                                                                        
     :vsp %:h/.h                                                                                                                                                                                                                             
     call append(0,"#ifndef ".toupper(a:ClassName)."_H")                                                                 
     call append(1,"#define ".toupper(a:ClassName)."_H")                                                           
     call append(2," ")                                                                                                  
     call append(3,"class ".a:ClassName )                                                                                
     call append(4, "{")                                                                                                 
     call append(5, "   public:")                                                                                        
     call append(6, "      ".a:ClassName."();")                                                                          
     call append(7, "      virtual ~".a:ClassName."();")                                                                 
     call append(8, "   protected:")                                                                                     
     call append(9, "   private:")                                                                                       
     call append(10, "};")                                                                                               
     call append(11,"#endif // ".toupper(a:ClassName)."_H")                                                              
     :execute 'write' header                                                                                             
   "================== editing source file ========================                                                      
     let src    = a:ClassName.".cpp"                                                                                     
     :vsp %:h/.cpp                                                                                                                                                                                                                     
     call append(0,"#include ".a:ClassName.".h")                                                                          
     call append(1," ")                                                                                                   
     call append(2,a:ClassName."::".a:ClassName."()")                                                                           
     call append(3,"{")                                                                                                   
     call append(4,"//ctor ")                                                                                             
     call append(5,"}")                                                                                                   
     call append(6," ")                                                                                                   
     call append(7," ")                                                                                                   
     call append(8,a:ClassName."::~".a:ClassName."()")                                                                         
     call append(9,"{")                                                                                                   
     call append(10,"//dtor ")                                                                                            
     call append(11,"}")                                                                                                  
    :execute 'write' src
endfunction
