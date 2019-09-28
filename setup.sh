#!/usr/bin/env bash

cp .vimrc ~/.
git config --global core.editor "vim"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
