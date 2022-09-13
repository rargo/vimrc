### About
My vimrc files, contains lots of settings, the operating system is Ubuntu, 
other Linux system should also works.

### Vim build in Ubuntu:
Install dependency packages:
```
sudo apt-get install gcc git ruby ruby-dev lua5.2 lua5.2-dev libncurses5-dev python3-dev python3-pip

```

Get and build vim:
```
git clone https://github.com/vim/vim.git
cd vim
./configure --with-features=huge --enable-python3interp=yes --enable-rubyinterp=yes --enable-cscope --enable-luainterp=yes --prefix=/usr/
make
```

If make success, run:
```
sudo make install
```

### Vim Plugin install
install pynvim and neovim for vim
```
pip3 install --user pynvim

pip3 install --user neovim
```

copy .vimrc to your home directory
```
mkdir ~/.vimrc
cp .vimrc ~/.vimrc
```

copy plugin and syntax directory to ~/.vim/
```
mkdir ~/.vim
cp -rf plugin syntax ~/.vim/
```

In bash, run:
```
mkdir -p ~/.vim/bundle; cd ~/.vim/bundle; git clone https://github.com/VundleVim/Vundle.vim.git
```

open Vim, run command:
```
:PluginInstall
```

Build command-t ruby extend library:
```
cd ~/.vim/bundle/command-t/ruby/command-t/ext/command-t/; ruby extconf.rb; make
```

### tab key mappings
* <alt-1\>: switch to tab 1
* <alt-2\>: switch to tab 2
* <alt-3\>: switch to tab 3
* <alt-4\>: switch to tab 4
* <alt-5\>: switch to tab 5
* <alt-6\>: switch to tab 6
* <alt-7\>: switch to tab 7
* <alt-8\>: switch to tab 8
* <alt-9\>: switch to tab 9
* <alt-w\>: switch to next tab
* <alt-q\>: switch to previous tab
* <alt-a\>: switch to the tab last used

### Normal mode key mappings
* <leader\>h: map to ‘:noh’, stop the highlighting
* <leader\>q: map to ‘:q’, quit
* <F2\>: tagbar toggle
* <F3\>: NERDTree toggle
* <F4\>: redraw screen
* <F5\>: jump to quick fix list next item
* <F6\>: jump to quick fix list previous item
* <F7\>: open current file using system editor
* <F8\>: open current file's directory
* <F9\>: open command-t 
* <F10\>: grep the word under cursor
* <F11\>: pastetoggle
* <F12\>: open or close a terminal right below current window, useful for invoke shell temporary
* <alt-l\>: the same as CTRL-W l, move cursor to windows left of current one
* <alt-h\>: the same as CTRL-W h, move cursor to windows right of current one
* <alt-j\>: the same as CTRL-W j, move cursor to windows above of current one
* <alt-k\>: the same as CTRL-W k, move cursor to windows below of current one
* <alt-\-\>: the same as CTRL-W _, set current window to the highest height
* <alt-=\>: the same as CTRL-W =, make each window equally height and wide
* <c-d\>: map to :q<cr>, quit 
* <space\>b: open buffer explorer

### Terminal mode mappings:
* <ctrl-^\>: switch to previous buffer as in normal mode
* <alt-d\>: quick terminal
* <alt-p\>: paste content to the terminal
* <alt-b\>: open buffer explorer
* <alt-n\>: terminal go back to normal mode
* <alt-l\>: the same as CTRL-W l, move cursor to windows left of current one
* <alt-h\>: the same as CTRL-W h, move cursor to windows right of current one
* <alt-j\>: the same as CTRL-W j, move cursor to windows above of current one
* <alt-k\>: the same as CTRL-W k, move cursor to windows below of current one
* <alt-\-\>: the same as CTRL-W _, set current window to the highest height
* <alt-=\>: the same as CTRL-W =, make each window equally height and wide
* <ctrl-b\>: goto normal mode, so text can be scroll back

### Key remap
* <c-y\>: in insert mode, remap to function GetAboveWord(), that will insert the word above current position instead of insert a character
* K: in normal mode, remap to function K_func(), it will first try to jump to the tag, if fails, fall back to normal K function

### Commands
* GTAG: generate gtags for source under current directory
* File: open current edit file in system editor
* Dir: open current directory in system file explorer
* G <keyword>: grep keyword in current directory, the searching file patterns is specify in grepprg options
* Gr <keyword>: grep keyword in current directory, search all kinds of files
* T: open terminal in a new tab(default runs bash, change it in .vimrc)

### ve.c
ve.c is for edit files in Vim terminal, “ve file” will open file for edit in current Vim,
not start another Vim program in terminal window.

build and install:
```
sh install_ve.sh
```
