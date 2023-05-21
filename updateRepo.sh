#!/usr/bin/env bash

update() {
  # Explicitly copy local files rather than rely on symlinks
  rsync "$HOME"/.vim/vimrc .vim/vimrc
  rsync "$HOME"/.vim/templates/* .vim/templates/
  rsync "$HOME"/.vim/autoload/local_functions.vim .vim/autoload/local_functions.vim
}

install() {
  # install vim-plug
  curl -fLo .vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vi +PlugInstall -c 'qa!'
}

restore() {
  # restore local files
  cp -r .vi* "$HOME"/
  cp -r .config/* "$HOME"/.config/
  install
}

datestamp() {
  # add a datestamp
  date +"%Y-%m-%d %H:%M"
}

pushit() {
  git pull
  git add .
  git commit -q -m "sync: $(datestamp)"
  git push
}

add_and_push() {
  # update, and push any changes
  update
  out_of_sync=$(git status --porcelain | wc -l)
  [ "$out_of_sync" -eq 0 ] || pushit
}

_main() {
    if [[ -z "$*" ]]
        then add_and_push;
    fi
    while getopts ":ui" opt; do
        case $opt in
            u)
              update
            ;;
            i)
              restore
            ;;
            *)
              add_and_push
            ;;
        esac
    done
}

_main "$@"
