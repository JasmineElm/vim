#!/usr/bin/env bash

update() {
  # Explicitly copy local files rather than rely on symlinks
  rsync "$HOME"/.vimrc .
  rsync "$HOME"/.vim/templates/* .vim/templates/
  rsync "$HOME"/.vim/local_functions.vim .vim/local_functions.vim
}

datestamp() {
  date +"%Y-%m-%d %H:%M"
} 

pushit() {
  git pull
  git add .
  git commit -q -m "sync: $(datestamp)"
  git push
}

main() {
  # update, and push any changes
  update
  out_of_sync=$(git status --porcelain | wc -l)
  [ "$out_of_sync" -eq 0 ] || pushit
}

main




