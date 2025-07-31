# Installation

## git settings
	ln -s ~/.lido/git/gitconfig ~/.gitconfig
	ln -s ~/.lido/git/gitignore_global ~/.gitignore_global

## git user settings
	cp ~/.lido/git/gituser ~/.gituser

## vim settings
	ln -s ~/.lido/vim/vimrc ~/.vimrc

## tmux settings
	ln -s ~/.lido/tmux/tmux.conf ~/.tmux.conf

## zsh settings
1. install oh-my-zsh
	```zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	```

2. install zsh plugins
	```
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
	```

3. link settings to env
	```
	ln -s ~/.lido/zsh/dstj.zsh-theme ~/.oh-my-zsh/themes/dstj.zsh-theme
	ln -s ~/.lido/zsh/zshrc ~/.zshrc
	```

## htop settings
	ln -s ~/.lido/htop/htoprc ~/.config/htop/htoprc

## vscode
### settings
	ln -s ~/.lido/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	New-Item -ItemType SymbolicLink -Path "~/.lido/vscode/settings.json" -Target "%APPDATA%\Code\User\settings.json"

### extensions
	code --list-extensions > ~/.lido/vscode/extensions.list

	cat ~/.lido/vscode/extensions.list | xargs -L 1 code --install-extension
	cat ~/.lido/vscode/extensions.list | % { "code --install-extension $_" }

## zed
	ln -s ~/.lido/zed/settings.json ~/.config/zed/settings.json