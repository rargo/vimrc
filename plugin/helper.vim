
"some small function 

let g:Log = "" 
function! Log(string)
	redir => g:Log
	echo a:string
	redir END
	execute "tabn2"
	silent put=g:Log
endfunction

function! LogCmd(cmd)
	redir => g:Log
	silent execute a:cmd
	redir END
	execute "tabn2"
	silent put=g:Log
	"set nomodified
	execute "tabn1"
endfunction

function! GetLastDir(path)
	let last_slash = strridx(a:path, "/")
	if last_slash != -1
		return strpart(a:path, last_slash+1)
	else
		return a:path
	endif
endfunction

func! GetFileDirAndName(filename)
	if a:filename == "%" "special,'%' means current file
		let current_file = getreg('%')
	else 
		let current_file = a:filename
	endif
	let last_slash = strridx(current_file, "/")
	if last_slash != -1
		let current_dir = strpart(current_file, 0, last_slash+1)
		let file = strpart(current_file, last_slash+1)
	else
		let current_dir = "./"
		let file = a:filename
	endif
	"echo current_dir
	return [current_dir,file]
endfunc

"command: Grep re path
function! Grep(cmd)
	execute 'cclose'
	call setqflist([])
	execute "silent! grep -r " . a:cmd . " ."
	execute "normal \<F4>"
	let qflist = getqflist()
	if len(qflist) >= 1
		execute 'rightbelow cw'
	endif
endfunction

"grep the word under the cursor
function! GrepCursorWord()
	let word = expand("<cword>")
	echo word
	"call getchar()
	"execute ":Grep " . word . " ."
	"let cmd = "" . word
	call Grep(word)
	"TODO highlight the word, not work!
	execute "normal /" . word . "\<cr>"
endfunc

function! GrepRaw(cmd)
	call setqflist([])
	execute 'cclose'
	let save_grepprg=&g:grepprg
	set grepprg=grep\ -n\ -R\ -H\ --exclude-dir=.git\ --exclude-dir=.svn
	execute "silent! grep " a:cmd
	let &g:grepprg=save_grepprg
	execute "normal \<F4>"
	let qflist = getqflist()
	if len(qflist) > 1
		execute 'rightbelow cw'
	endif
endfunction

function! TurnChar(word_prefix, word_postfix, char_prefix,char_postfix,char_step)
	let [lnum1, col1] = [line("'<"),col("'<")]
	let [lnum2, col2] = [line("'>"),col("'>")]

	"echo "a:startNum:" . a:startNum
	let lines = getline(lnum1, lnum2)
	let newlines = []

	let searchLength = col2
	"blockwise mode, adjust searchLength to the max line length
	if visualmode() == "V"
		for line in lines
			if strlen(line) > searchLength
				let searchLength = strlen(line)
			endif
		endfor
	endif

	"echo "===================="
	"find number position,change it
	let i = 0
	for line in lines

		let startByte = col1 - 1
		"echo "searchLength" . searchLength
		let line_new = strpart(line,0,startByte)
		while 9 
			let matchByte = match(line,"[0-9a-fA-F]\\+",startByte)
			"echo "matchByte:" . matchByte
			if matchByte != -1

				"echo "matchByte:" . matchByte
				let matchstr = matchstr(line,"[0-9a-fA-F]\\+", matchByte)
				let matchstr_len = len(matchstr)
				"echo "startByte:" . startByte
				"echo "matchstr:" . matchstr
				"echo "matchstr_len:" . matchstr_len

				if (matchByte + matchstr_len) > searchLength
					"echo "break"
					let line_new .= strpart(line,startByte)
					break
				endif

				"XXX below should use regular expression
				let line_new .= strpart(line,startByte,matchByte-startByte)

				let line_new .= a:word_prefix
				let char_visit_len = 0
				let char_start = 0
				let char_change = ""
				while char_visit_len < matchstr_len
					let char_split = strpart(matchstr,char_start,a:char_step)
					let char_change .= a:char_prefix . char_split . a:char_postfix
					let char_visit_len = char_visit_len + a:char_step
					let char_start = char_start + a:char_step
				endwhile
				let line_new .= char_change
				let line_new .= a:word_postfix

				"\x34\e\x34\e,\xad\e\xcd\e\x00\e
				"\x43\e,\xdf\e\xd0\e
				""\x34\e\x34\e","\xad\e\xcd\e\x00\e"
				""\x43\e","\xdf\e\xd0\e"
				"3434,adcd00
				"43,dfd0

				""echo a:startNum
				"if type(a:startNum) == type(0)
					""sort the number start by startNum
					""echo a:startNum + i*a:step
					"let line_new .= "" . (a:startNum + i*a:step)
				"else  " '.'
					""new number = old number + step
					"let line_new .= "" . eval(matchstr) + a:step
				"endif
				""echo "line_new" . line_new

				let startByte = matchByte + matchstr_len
				let i += 1
			else
				let line_new .= strpart(line,startByte)
				break
			endif
		endwhile
		call add(newlines,line_new)
	endfor

	let startLine = lnum1
	"set new line
	for line in newlines
		call setline(startLine, line)
		let startLine += 1
	endfor
endfunc

"python test
function! Date()
let g:testPy = "AAAA"
let g:testDir = {'sdf': 'sdfdsf', 0:1}
python << EOF
import vim
import time
def getDate():
now = time.asctime();
return now

def vimSetVar(var, value):
command = "let " + var + " = " + value
print command
vim.command(command)
return

print dir(vim.buffers)
print help(vim.buffers)
for b in vim.buffers:
print b

testPy = vim.eval("g:testPy")
testDir = vim.eval("g:testDir")
print testPy
print testDir
print testDir['0']
testPy += "BB"
print testPy
getDate()
vim.command("let g:testPy = \"BB\"");
#vimSetVar("g:testPy", "BB")
EOF
echo g:testPy
endfunc

"from current_path search up to nr_parent_dir parent directories to find to file_name file, 
"if current_path is "%",it means current directory
"return file path when file found, else return empty string ""
"it's mush faster then findfile()
function! CheckFileExist(file_name, dir, nr_parent_dir)
	let dir = a:dir
	let file = dir . a:file_name
	let file = expand(file)

	if filereadable(file)
		"let file = expand(file,":p")
		"echo file
		return file
	endif

	"search in current directory
	if a:nr_parent_dir == 0
		return ""
	endif

	"echo file
	for i in range(a:nr_parent_dir)
		let file = dir . "../" . a:file_name
		if filereadable(file)
			"let file = expand(file,":p")
			"echo file
			return file
		endif
		"echo file
	endfor
	"echo "nothing"
	return ""
endfunc

"get file name part
func! HelperGetFileName(filename)
	if a:filename == "%" "special,'%' means current file
		let current_file = getreg('%')
	else 
		let current_file = a:filename
	endif
	let last_slash = strridx(current_file, "/")
	if last_slash != -1
		let current_file = strpart(current_file, last_slash+1)
	endif
	"echo current_dir
	return current_file
endfunc

"get dir name part
func! GetFileDir(filename)
	if a:filename == "%" "special,'%' means current file
		let current_file = getreg('%')
	else 
		let current_file = a:filename
	endif

	if isdirectory(filename)
		return current_file
	endif

	let last_slash = strridx(current_file, "/")
	if last_slash != -1
		let current_dir = strpart(current_file, 0, last_slash+1)
	else
		let current_dir = "./"
	endif
	"echo current_dir
	return current_dir
endfunc

function! TabMessage(cmd)
	redir => message
	silent execute a:cmd
	redir END
	tabnew
	silent put=message
	set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

"{==========================================================
"delete #if 0/1 ..... #endif surroud statement
function! DeleteIfStatement()
	let save_cursor = getpos(".")

	let line_if = search("#if", 'b')
	if line_if
		execute "normal " . line_if . "Gdd"
	endif

	let line_endif = search("#endif")
	if line_endif
		execute "normal " . line_endif . "Gdd"
	endif

	call setpos('.', save_cursor)
endfunction

"reverse #if 0/1 statement
function! ReverseIfCondition()
	let save_cursor = getpos(".")
	let line_if = search("#if", 'b')
	if line_if
		"echo line_if
		let match_line = getline(line_if)
		
		if(match(match_line,'0') != -1)
			execute "normal 0f0r1"
		elseif (match(match_line,'1') != -1)
			execute "normal 0f1r0"
		endif
	endif
	call setpos('.', save_cursor)
	return
endfunction
"}==========================================================

function! K_func()
	let v:errmsg = ""

	let word = expand("<cword>")
	"TODO why, according to ":help silent", v:errmsg should still be set when "use silent!"
	"execute ":silent! cs find g " word
	call setqflist([])
	execute "cclose"
	execute ":cs find g " word
	if v:errmsg == ""
		let qflist = getqflist()
		if len(qflist) > 1
			execute 'rightbelow cw'
		endif
		return
	endif

	execute "tag " word
	if v:errmsg == ""
		return
	endif

	if v:errmsg != ""
		"first unmap K
		unmap K
		execute "silent normal K"
		redraw
		"restore K maping
		nnoremap K :call K_func()<CR>
	endif

	execute "normal \<F4>"
endfunc

function! WaitKey()
	"consume buffer key
	"while getchar(1) != 0
	"endwhile

	call getchar()
endfunction

let g:SpecialMode = {'quickfix':0,'nerdtree':0,'tagbar':0}

function! Tagbar_enter()
	let g:SpecialMode['tagbar'] = 1
	exec "vertical resize " . g:Nerdtree_window_enter_width
	"nnoremap <buffer> f :call LineJumpForward()<cr>
	"nnoremap <buffer> b :call LineJumpBackward()<cr>
	"echo "tagbar window enter"
endfunction

function! Windows_Leave()
	"set nocursorline
endfunction

function! Tagbar_leave()
	let g:SpecialMode['tagbar'] = 0
	exec "vertical resize " . g:Nerdtree_window_leave_width
	"nunmap <buffer> f
	"nunmap <buffer> b
	"echo "tagbar window leave"
endfunction

function! Nerdtree_enter()
	exec "vertical resize " . g:Nerdtree_window_enter_width
	"let g:SpecialMode['nerdtree'] = 1
	"nnoremap <buffer> f :call LineJumpForward()<cr>
	"nnoremap <buffer> b :call LineJumpBackward()<cr>
	"echo "Nerdtree window enter"
	"echo expand("<afile>")
	"call WaitKey()
endfunction

function! Nerdtree_leave()
	exec "vertical resize " . g:Nerdtree_window_leave_width
	"let g:SpecialMode['nerdtree'] = 0
	"nunmap <buffer> f
	"nunmap <buffer> b
	"echo "Nerdtree window leave"
	"echo expand("<afile>")
	"call WaitKey()
endfunction

"autocmd BufWinEnter quickfix call QuickfixWinEnter_event()
"
"function! Quickfix_o_func()
"	echo "Quickfix_O_func"
"	let savepos = getpos('.')
"	let nr = winnr()
"	execute "normal \<cr>"
"	execute nr . " wincmd w"
"	call setpos('.', savepos)
"endfunction
"
"function! Quickfix_enter()
"	let g:SpecialMode['quickfix'] = 1
"	nnoremap o :call Quickfix_o_func()<cr>
"	"exec "resize " . g:Quickfix_window_enter_height
"endfunction
"
"function! Quickfix_leave_o()
"	let g:SpecialMode['quickfix'] = 0
"	nunmap o
"	"max window height
"	"exec "wincmd _"
"endfunction
"
"function! Quickfix_leave()
"	let g:SpecialMode['quickfix'] = 0
"	nunmap o
"	"exec "resize " . g:Quickfix_window_leave_height
"endfunction
"
"function! QuickfixWinEnter_event()
"	"echo "quickfix window enter"
"	au! * <buffer>
"	au BufEnter <buffer> call Quickfix_enter()
"	au BufLeave <buffer> call Quickfix_leave()
"
"	call Quickfix_enter()
"	"echo "quickfix bufnr " g:Quickfix_bufnr
"	"call WaitKey()
"endfunction

"note, it cann't handle function like: int (*p(int a))(void)
"a complier???
function! CFuntionDefines(include_static)
	let save_rega = getreg('a')
	call setreg('a','')
	"execute '%g=^\h\w\+\s\+\h\w\+(.*)[^;]*$=normal "AY'
	execute '%g=^\(static\s\+\)*\(\h\w*\s\+\)\+\h\w*(.*)[^;]*$=normal "AY'
	let raw_funcs = getreg('a')
	if raw_funcs == ""
		return  ""
	endif
	let raw_funcs_list = split(raw_funcs,'\n')
	let func_list = []
	if a:include_static != 0
		for line in raw_funcs_list
			call add(func_list,line)
		endfor
	else
		"remove static functions
		for line in raw_funcs_list
			if match(line, '^static\s\+') == -1
				call add(func_list,line)
			endif
		endfor
	endif
	let funcs = join(func_list, ";\n")
	let funcs = funcs . ";\n"
	call setreg('a',save_rega)
	call setreg('0',funcs)
	return funcs
endfunction

"generate a head file for current c file
"if head file exist, promote for delete
function! CHeaderGen()
	let funcs = CFuntionDefines(0)
	if funcs == ""
		echo "no function found!"
		return
	endif
	let c_file = expand("%:p:t")
	let c_file_dir = GetFileDir(expand("%"))

	let head_file = substitute(c_file,'\(.*\)\.c', '\1\.h', "g")
	let head_file_path = c_file_dir . head_file

	let input_promote = 'Input header file path:'
	let input_path = inputdialog(input_promote, head_file_path,"null")
	if input_path == "null"
		return
	endif
	if input_path == ""
		let input_path = head_file_path
	endif

	if filereadable(input_path)
		redraw
		echo "head file exists, overwrite? y[es], N[o]"
		let key = getchar()
		let char = nr2char(key)
		if char != 'y' 
			return
		endif
	endif
	let name = substitute(toupper(head_file), '\.','_', "g")
	let content = "#ifndef " . name . "\n"
	let content = content . "#define " . name . "\n\n"
	let content = content . CFuntionDefines(0) . "\n"
	let content = content . "#endif" . "\n"
	"echo content
	"echo head_file_full_path
	"call getchar()
	call system("echo " . '"' . content . '"' . " > " . input_path)
endfunction

function! CPrevFunction()
	let pos = getpos('.')
	let save_pos = pos

	"skip search current line
	let pos[1] = pos[1] - 1
	call setpos('.',pos)

	let pattern = '^\(static\s\+\)*\(\h\w*\s\+\)\+\h\w*(.*)[^;]*$'
	let line = search(pattern, 'b')
	if line == -1
		call setpos('.',save_pos)
		return
	endif

	let pos_pattern = '\h\w*(.*)'
	let matchPos  = match(getline('.'),pos_pattern, 0)
	if matchPos == -1
		call setpos('.',save_pos)
		return
	endif
	"echo matchPos
	let newpos = [0, line, matchPos + 1 , 0] 
	"echo "setpos:" . string(newpos)
	call setpos('.',newpos)
endfunction

function! CNextFunction()
	let pos = getpos('.')
	let save_pos = pos

	"skip search current line
	let pos[1] = pos[1] + 1
	call setpos('.',pos)

	let pattern = '^\(static\s\+\)*\(\h\w*\s\+\)\+\h\w*(.*)[^;]*$'
	let line = search(pattern)
	if line == -1
		"echo "line is -1"
		call setpos('.',save_pos)
		return
	endif

	let pos_pattern = '\h\w*(.*)'
	let matchPos  = match(getline('.'),pos_pattern, 0)
	if matchPos == -1
		"echo "matchPos is -1"
		call setpos('.',save_pos)
		return
	endif
	"echo matchPos
	let newpos = [0, line, matchPos + 1 , 0] 
	"echo "setpos:" . string(newpos)
	call setpos('.',newpos)
endfunction

function! AddGtag()
	if filereadable('./GTAGS')
		exec "cs kill 0"
		exec "cs add GTAGS"
	endif
endfunction

function! GenGtag()
	exec "cs kill 0"
	exec "!gtags"
	exec "cs add GTAGS"
endfunction

command! -complete=customlist,NerdtreeDirComplete -nargs=1 Nd call NerdtreeDir(<q-args>)
function! NerdtreeDirComplete(ArgLead, CmdLine, CursorPos)
	return s:NerdtreeDirList
endfunction

