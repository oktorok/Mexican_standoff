" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    .vimrc                                             :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: tnicolas <marvin@42.fr>                    +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2017/11/26 12:16:09 by tnicolas          #+#    #+#              "
"    Updated: 2017/11/26 16:30:28 by jagarcia         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

let mapleader = ","
syntax on
set autoindent
set cindent
set ruler
set number
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
highlight ExtraWhitespace ctermbg=red guibg=red
match Pmenu /\s\s\+/
2match ExtraWhitespace /\s\+\n/
set dir=$HOME/.vim

"""""""""""""""""""""""""""""""""""""42header"""""""""""""""""""""""""""""""""""
"create 42 header <C-c><C-h> or :Header
nmap <C-c><C-h> :call Create42Header()<CR>
command Header exe ':call Create42Header()'
"update date if the file is modified
autocmd BufWriteCmd * if &modified && Create42Header_if_exist() == 1
autocmd BufWriteCmd *	call Create42Header_update()
autocmd BufWriteCmd *	:write
autocmd BufWriteCmd * elseif &modified
autocmd BufWriteCmd *	:write

"create a header if we need it
function! Create42Header()
	let is_header = Create42Header_if_exist()
	if is_header == 0
		call Create42Header_create()
	else
		echo 'you already have a header'
	endif
endfunction

"check if the header exist
function! Create42Header_if_exist()
	let first_line_visible = line('w0') + 4
	let line_before = line('.')
	let col_before = col('.')
	let begin = '# '
	let end = ' #'
	let size_c = 1
	if expand('%:e') == 'c' || expand('%:e') == 'h' || expand('%:e') == 'cpp'
		let begin = '\/\*'
		let end = '\*\/'
		let size_c = 2
	elseif expand('%:e') == 'vim' || expand('%:t') == '.vimrc'
		let begin = '" '
		let end = ' "'
		let size_c = 1
	elseif expand('%:t') == '.emacs'
		let begin = '; '
		let end = ' ;'
		let size_c = 1
	endif
	:normal gg
	let is_header =  search(l:begin . '\s*\*\{' . (78 - 2 * l:size_c) . '}\s*'
				\. l:end . '\n
				\' . l:begin . '\s\+' . l:end . '\n
				\' . l:begin . '\s\+:::\s\+:\{8}\s\+' . l:end . '\n
				\' . l:begin . '\s\+\w\+.\w* \+:+:\s\+:+:\s\+:+:\s\+' . l:end
				\. '\n
				\' . l:begin . '\s\++:+ +:+\s\++:+\s\+' . l:end . '\n
				\' . l:begin . '\s\+By: \w\+ <.\+> \++#+  +:+ \{7}+#+ \{8}' .
				\l:end . '\n
				\' . l:begin . '\s\++#+#+#+#+#+\s\++#+\s\+' . l:end . '\n
				\' . l:begin . '\s\+Created: 20\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d
				\ by \w\+\s\+#+#\s\+#+#\s\+' . l:end . '\n
				\' . l:begin . '\s\+Updated: 20\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d
				\ by \w\+\s\+###\s\+#\{8}\.fr\s\+' . l:end . '\n
				\' . l:begin . '\s\+' . l:end . '\n
				\' . l:begin . '\s*\*\{' . (78 - 2 * l:size_c) . '}\s*'
				\. l:end . '\n', 'c', line('0'))
	exe ':' . first_line_visible
	:normal zt
	exe ':' . line_before
	exe ':normal ' . col_before . '|'
	return is_header
endfunction

"create a header
function! Create42Header_create()
	let first_line_visible = line('w0') + 4
	let line_before = line('.')
	let col_before = col('.')
	let user = $USER
	let mail = $MAIL
	let begin = '# '
	let end = ' #'
	let size_c = 1
	if expand('%:e') == 'c' || expand('%:e') == 'h' || expand('%:e') == 'cpp'
		let begin = '\/\*'
		let end = '\*\/'
		let size_c = 2
	elseif expand('%:e') == 'vim' || expand('%:t') == '.vimrc'
		let begin = '" '
		let end = ' "'
		let size_c = 1
	elseif expand('%:t') == '.emacs'
		let begin = '; '
		let end = ' ;'
		let size_c = 1
	endif
	"expand for srcs/main.c
	"	%:t main.c
	"	%:e c
	"	%:r srcs/main.c
	"	%:r:t srcs/main
	let filename = expand('%:t')
	let time_act = strftime('%Y\/%m\/%d %H:%M:%S')
	if user == '' || user == 'tim'
		let user = g:username42
	endif
	if mail == ''
		let mail = g:mail42
	endif
	:normal gg
	exe ':1 s/^/' . l:begin . repeat(' ', size_c - 1) .
				\repeat('*', 78 - 2 * size_c) . repeat(' ', size_c - 1) .
				\l:end . '\r'
	exe ':2 s/^/' . l:begin . repeat(' ', 76) . l:end . '\r'
	let line42 = ':::' . repeat(' ', 6) . '::::::::' . repeat(' ', 3)
	exe ':3 s/^/' . l:begin . repeat(' ', 56) . line42 . l:end . '\r'
	let line42 = ':+:' . repeat(' ', 6) . ':+:' . repeat(' ', 4) . ':+:' .
				\repeat(' ', 3)
	exe ':4 s/^/' . l:begin . repeat(' ', 3) . filename .
				\repeat(' ', 51 - strlen(filename)) .  line42 . l:end . '\r'
	let line42 = '+:+ +:+' . repeat(' ', 9) . '+:+' . repeat(' ', 5)
	exe ':5 s/^/' . l:begin . repeat(' ', 52) . line42 . l:end . '\r'
	let line42 = '+#+  +:+' . repeat(' ', 7) . '+#+' . repeat(' ', 8)
	exe ':6 s/^/' . l:begin . repeat(' ', 3) . 'By: ' . user . ' <' . mail . '>'
				\. repeat(' ', 40 - strlen(user) - strlen(mail)) .
				\line42 . l:end . '\r'
	let line42 = '+#+#+#+#+#+' . repeat(' ', 3) . '+#+' . repeat(' ', 11)
	exe ':7 s/^/' . l:begin . repeat(' ', 48) . line42 . l:end . '\r'
	let line42 = '#+#' . repeat(' ', 4) . '#+#' . repeat(' ', 13)
	exe ':8 s/^/' . l:begin . repeat(' ', 3) . 'Created: ' . time_act . ' by '
				\. user . repeat(' ', 39 - strlen(time_act) - strlen(user)) .
				\line42 . l:end . '\r'
	let line42 = '###' . repeat(' ', 3) . '########.fr' . repeat(' ', 7)
	exe ':9 s/^/' . l:begin . repeat(' ', 3) . 'Updated: ' . time_act . ' by '
				\. user .  repeat(' ', 38 - strlen(time_act) - strlen(user)) .
				\line42 . l:end . '\r'
	exe ':10 s/^/' . l:begin . repeat(' ', 76) . l:end . '\r'
	exe ':11 s/^/' . l:begin . repeat(' ', size_c - 1) .
				\repeat('*', 78 - 2 * size_c) . repeat(' ', size_c - 1) .
				\l:end . '\r\r'
	let line_before += 12
	exe ':' . first_line_visible
	:normal zt
	exe ':' . line_before
	exe ':normal ' . col_before . '|'
endfunction

"update date in header
function! Create42Header_update()
	let first_line_visible = line('w0') + 4
	let line_before = line('.')
	let col_before = col('.')
	:normal gg
	let time_act = strftime('%Y\/%m\/%d %H:%M:%S')
	exe ':9 s/\d\d\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d/' . time_act
	exe ':' . first_line_visible
	:normal zt
	exe ':' . line_before
	exe ':normal ' . col_before . '|'
endfunction
"""""""""""""""""""""""""""""""""""""42header"""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""norm"""""""""""""""""""""""""""""""""""""""
"norm
"	norm in the file :WW
command WW !echo "--------------------------------------------------------"
			\&& norminette % &&
			\echo "--------------------------------------------------------"<CR>
command Ww !echo "--------------------------------------------------------"
			\&& norminette % &&
			\echo "--------------------------------------------------------"<CR>

"	make norm in the file <leader>nn :Norm
nmap <leader>nn :call NormFile()<CR>
command Norm exe ':call NormFile()'
function! NormFile()
	let i = 0
	let max = 15
	:normal gg=G
	:call Create42Header()
	"remove space beetween () ex : ( ( = ((
	while i < max
		let i += 1
		:silent! 12, $ s/(\s\+(/((/g
		:silent! 12, $ s/)\s\+)/))/g
	endwhile
	"remove extra whitespaces (end of lines)
	:silent! 12, $ s/\s\+\n/\r/g
	"remove extra whitespaces (arround = & +...)
	"	test extra whitespace before and after =
	:silent! 12, $ s/\s\s\+=/ =/g
	:silent! 12, $ s/=\s\s\+/= /g
	"	test extra whitespace before and after +
	:silent! 12, $ s/\s\s\++/ +/g
	:silent! 12, $ s/+\s\s\+/+ /g
	"	test extra whitespace before and after -
	:silent! 12, $ s/\s\s\+-/ -/g
	:silent! 12, $ s/-\s\s\+/- /g
	"	test extra whitespace before and after <
	:silent! 12, $ s/\s\s\+</ </g
	:silent! 12, $ s/<\s\s\+/< /g
	"	test extra whitespace before and after >
	:silent! 12, $ s/\s\s\+>/ >/g
	:silent! 12, $ s/>\s\s\+/> /g
	"	test extra whitespace before and after !
	:silent! 12, $ s/\s\s\+\!/ \!/g
	"	test extra whitespace word(
	:silent! 12, $ s/\w\zs\s\+\ze(//g
	"	test extra whitespace if (
	:silent! 12, $ s/if(/if (/g
	:silent! 12, $ s/if\s\s\+(/if (/g
	"	test extra whitespace while (
	:silent! 12, $ s/while(/while (/g
	:silent! 12, $ s/while\s\s\+(/while (/g
	"	remove space before ;
	:silent! 12, $ s/\s\+;/;/g
	"	test extra whitespace return ( and return ;
	:silent! 12, $ s/return(/return (/g
	:silent! 12, $ s/return\s\s\+(/return (/g
	:silent! 12, $ s/return;/return ;/g
	:silent! 12, $ s/return\s\s\+;/return ;/g
	"	test extra whitespace break ;
	:silent! 12, $ s/break;/break ;/g
	:silent! 12, $ s/break\s\s\+;/break ;/g
	"	test extra whitespace around ( ) and [ ]
	:silent! 12, $ s/.\zs\s\+\ze[)\]]//g
	:silent! 12, $ s/[(\[]\zs\s\+\ze.//g
	:silent! 12, $ s/\w\zs\s\+\ze\[//g
	"	test extra whitespaces around ,
	:silent! 12, $ s/.\zs\s\+\ze,//g
	:silent! 12, $ s/,\zs\s\+\ze\n//g
	:silent! 12, $ s/,\s\zs\s\+\ze.//g
	:silent! 12, $ s/,\zs\ze\w/ /g
	"	test multiligne empty
	let i = 0
	while i < max
		let i += 1
		:silent! 12, $ s/^\n^\n/\r/g
	endwhile
	:normal gg=G
endfunction
"""""""""""""""""""""""""""""""""""""norm"""""""""""""""""""""""""""""""""""""""
