if exists("b:current_syntax_addtion")
  finish
endif

hi Constant ctermfg=124
hi String   ctermfg=124
hi Comment  ctermfg=125

"hi Comment term=bold ctermfg=11 guifg=gray
"hlight Functions
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>("me=e-1
"hi cFunctions gui=NONE cterm=bold  ctermfg=97
hi cFunctions gui=NONE cterm=bold  ctermfg=98

" C math operators 
syn match       cMathOperator     display "[-+\*%=]" 
"" C pointer operators 
syn match       cPointerOperator  display "->\|\.\|\:\:" 
" C logical   operators - boolean results 
syn match       cLogicalOperator  display "[!<>]=\=" 
syn match       cLogicalOperator  display "==" 
" C bit operators 
syn match       cBinaryOperator   display "\(&\||\|\^\|<<\|>>\)=\=" 
syn match       cBinaryOperator   display "\~" 
syn match       cBinaryOperatorError display "\~=" 
" More C logical operators - highlight in preference to binary 
syn match       cLogicalOperator  display "&&\|||" 
syn match       cLogicalOperatorError display "\(&&\|||\)=" 

" More C priority operators - highlight in preference to binary 
syn match       cpriorityperator  display "(\|)\|\[\|\]\|{\|}" 

" Math Operator 
hi cMathOperator            guifg=#9AC0CD  ctermfg=25
hi cMathOperator            guifg=#9AC0CD  ctermfg=25
hi cPointerOperator         guifg=#EEAEEE  ctermfg=25
hi cLogicalOperator         guifg=#CDCD00  ctermfg=25
hi cBinaryOperator          guifg=#BBFFFF  ctermfg=25
hi cBinaryOperatorError     guifg=#C0FF3E  ctermfg=25
hi cLogicalOperator         guifg=#C0FF3E  ctermfg=25
hi cLogicalOperatorError    guifg=#C0FF3E  ctermfg=25
hi cpriorityperator	    guifg=#CDAD00  ctermfg=58

let b:current_syntax_addtion = "c"

