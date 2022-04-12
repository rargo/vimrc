
"set global as csopce program
set csprg=gtags-cscope 
set cscopequickfix=g-,s-,c-,d-,i-,t-,e-
set cscopetag

"reload gtags on tab change, coperate with tab.vim
function! ReloadCGtag()
	cs kill 0
	cs add GTAGS
	set tags=tags
endfunction

" find reference
nnoremap \s :exec CscopeCmd("s")<CR>
nnoremap \S :exec CscopeCmd("s")<CR>
" "\d" find functions which current function calls
nnoremap \d :exec CscopeCmd("d")<CR>
nnoremap \D :exec CscopeCmd("d")<CR>
" "\c" find caller
nnoremap \c :exec CscopeCmd("c")<CR>
nnoremap \C :exec CscopeCmd("c")<CR>
" "\t" find string
nnoremap \t :exec CscopeCmd("t")<CR>
nnoremap \T :exec CscopeCmd("t")<CR>
" "\e" find using egrep mode
nnoremap \e :exec CscopeCmd("e")<CR>
nnoremap \E :exec CscopeCmd("e")<CR>
" "\f" find file
nnoremap \f :exec CscopeCmd("f")<CR>
nnoremap \F :exec CscopeCmd("f")<CR>
" "\i" find file which include current file
nnoremap \i :exec CscopeCmd("i")<CR>
nnoremap \I :exec CscopeCmd("i")<CR>

function! CscopeCmd(type)
	"clear old qflist
	let qflist = []
	execute "cclose"
	call setqflist(qflist)
	if a:type == 'i' || a:type == 'f'
		let word_file = expand("<cfile>")
	else
		let word_file = expand("<cword>")
	endif
	execute "silent cs find " . a:type . " " . word_file
	"echo word_file
	"execute "normal \<cr>\<cr>"
	"get quickfix results
	let qflist = getqflist()
	if len(qflist) > 1
		execute 'rightbelow cw'
	endif
endfunction

