#!/usr/bin/env bash
set -o pipefail
cd "${0%/*}"

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo ""
      echo "options:"
      echo "-h,      --help     : show this prompt"
      echo "-g,      --get      : clone the vim git project locally"
      echo "-v <os>, --vim <os> : configure, compile, and install vim from local source in $PWD/vim for <os>"
      echo "-e,      --env      : set up environment settings"
      echo "-y,      --ycm      : set up plugins and YCM"
      echo "-c,      --clean    : delete local vim/ directory"
      echo "-a <os>, --all <os> : ./setup.sh --get --vim <os> --clean --env --ycm"
      echo ""
      exit 0
      ;;
    -g|--get)
      git clone https://github.com/vim/vim
      git clone https://github.com/altercation/solarized
      git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
      yum install centos-release-scl-rh
      yum install ncurses-devel libX11-devel xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps python27-python-devel
      yum-builddep vim-enhanced
      cd "${0%/*}"
      shift
      ;;
    -v|--vim)
      #this setting is expected to be followed by an OS (centos, or ubuntu)
      cd vim
      if test $# -gt 0; then
        shift
        case "$1" in
          ubuntu)
            dir_start="/usr/lib"
            ;;
          centos)
            dir_start="/usr/lib64"
            ;;
          *)
            break
            ;;
        esac
        shift
      else
        echo "No OS specified. Use --help for usage advice."
        exit 1
      fi
      ./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes \
                  --enable-pythoninterp=no --with-python-config-dir=$dir_start/python2.7/config \
                  --enable-python3interp=no --with-python3-config-dir=$dir_start/python3.4/config \
                  --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=auto \
                  --enable-gtk2-check --enable-cscope --with-x --prefix=/usr/local
      make VIMRUNTIME=/usr/local/share/vim/vim81
      sudo make install
      cd "${0%/*}"
      shift
      ;;
    -e|--env)
      # Set up all common vim, vi, and editor aliases
      rm /usr/bin/editor /usr/bin/vi /usr/bin/vim
      sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
      sudo update-alternatives --set editor /usr/local/bin/vim
      sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
      sudo update-alternatives --set vi /usr/local/bin/vim
      sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 1
      sudo update-alternatives --set vim /usr/local/bin/vim
      # Set git editor to vim
      git config --global core.editor "vim"
      # Set up .vimrc and backup/swap/undo directory.
      cp .vimrc ~/.
      mkdir ~/.cache/vim
      cd "${0%/*}"
      shift
      ;;
    -y|--ycm)
      # Setup YCM
      vim +PluginInstall +qall
      cd ~/.vim/bundle/YouCompleteMe
      python3 install.py --clang-completer
      cd "${0%/*}"
      shift
      ;;
    -s|--solarized)
      mkdir ~/.vim/colors
      cp solarized/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/.
      cd "${0%/*}"
      shift
      ;;
    -c|--clean)
      rm -rf vim/
      rm -rf solarized/
      cd "${0%/*}"
      shift
      ;;
    -a|--all) #this setting is expected to be followed by an OS (centos, or ubuntu)
      shift
      ./setup.sh --get --vim $1 --solarized --clean --env --ycm
      echo "Installation complete!"
      exit 0;
      ;;
    *)
      echo "Incorrect flag. Run ./setup --help for assistance."
      exit 1;
      ;;
  esac
done

cd "${0%/*}"
./setup.sh --help
