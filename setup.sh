#!/usr/bin/env bash
set -o pipefail
cd "${0%/*}"

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo ""
      echo "options:"
      echo "-h,      --help       show this prompt"
      echo "-v <os>, --vim <os>   install vim from source for <os> in $PWD"
      echo "-e,      --env        set up environment settings"
      echo "-y,      --ycm        set up plugins and YCM"
      echo "-c,      --clean      delete vim/ directory"
      echo "-a <os>, --all <os>   ./setup.sh --vim <os> --clean --env --ycm"
      echo ""
      exit 0
      ;;
    -v|--vim) #this setting is expected to be followed by an OS (centos, or ubuntu)
      git clone https://github.com/vim/vim
      cd vim
      shift
      if test $# -gt 0; then
        case "$1" in
          ubuntu)
            dir_start="/usr/lib"
            ;;
          centos)
            dir_start="/lib64"
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
                  --enable-pythoninterp=yes --with-python-config-dir=$dir_start/python2.7/config \
                  --enable-python3interp=yes --with-python3-config-dir=$dir_start/python3.4/config \
                  --enable-perlintep=yes --enable-luainterp=yes --enable-gui=auto \
                  --enable-gtk2-check --enable-cscope --with-x --prefix=/usr/local
      make VIMRUNTIME=/usr/local/share/vim/vim81
      sudo make install
      ;;
    -e|--env)
      # Set up all common vim, vi, and editor aliases
      sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
      sudo update-alternatives --set editor /usr/local/bin/vim
      sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
      sudo update-alternatives --set vi /usr/local/bin/vim
      sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 1
      sudo update-alternatives --set vim /usr/local/bin/vim
      cp .vimrc ~/.
      # Set up directory for vim backups, swaps, and undos
      mkdir ~/.cache/vim
      # Set git editor to vim
      git config --global core.editor "vim"
      shift
      ;;
    -y|--ycm)
      # Install Vundle
      git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
      # Setup YCM
      vim +PluginInstall +qall
      cd ~/.vim/bundle/YouCompleteMe
      python3 install.py --clang-completer
      shift
      ;;
    -c|--clean)
      rm -rf vim/
      shift
      ;;
    -a|--all) #this setting is expected to be followed by an OS (centos, or ubuntu)
      shift
      ./setup.sh --vim $1 --clean --env --ycm
      echo "Installation complete!"
      exit 0;
      ;;
    *)
      echo "Incorrect flag. Run ./setup --help for assistance."
      exit 1;
      ;;
  esac
done

./setup.sh --help
