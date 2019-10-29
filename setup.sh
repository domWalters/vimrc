#!/usr/bin/env bash
set -euo pipefail
cd "${0%/*}"

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "options:"
      echo "-h, --help            show this prompt"
      echo "-v <os>, --vim <os>   install vim from source for <os> in this scripts directory"
      echo "-e, --env             set up environment settings"
      echo "-y, --ycm             set up plugins and YCM"
      echo "-c, --clean           delete vim/ directory (intended to be used after install completes)"
      echo "-a <os>, --all <os>   ./setup.sh --vim <os> --env --clean"
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
                  --enable-perlintep=yes --enable-luainterp=yes --enable-gui=gtk2 \
                  --enable-cscope --prefix=/usr/local
      make VIMRUNTIME=/usr/local/share/vim/vim81
      sudo make install
      git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim | true
      ;;
    -e|--env)
      sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
      sudo update-alternatives --set editor /usr/local/bin/vim
      sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
      sudo update-alternatives --set vi /usr/local/bin/vim
      # Copy vimrc and ycm_conf to home directory
      cp .vimrc ~/.
      # Set git editor to vim, install vundle if not installed
      git config --global core.editor "vim"
      shift
      ;;
    -y|--ycm)
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
      ./setup.sh --vim $1 --env --ycm --clean
      echo "Installation complete!"
      exit 0;
      ;;
    *)
      echo "Incorrect flag. Run ./setup --help for assistance."
      exit 1;
      ;;
  esac
done
