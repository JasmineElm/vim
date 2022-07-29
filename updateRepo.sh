#!/usr/bin/env bash

update() {
  # Explicitly copy local files rather than rely on symlinks
  rsync "$HOME"/.vim/vimrc .vim/vimrc
  rsync "$HOME"/.vim/templates/* .vim/templates/
  rsync "$HOME"/.vim/autoload/local_functions.vim .vim/autoload/local_functions.vim
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
    while getopts ":u" opt; do
        case $opt in
            u)
              update
            ;;
            *)
              add_and_push
            ;;
        esac
    done
}

_main "$@"

