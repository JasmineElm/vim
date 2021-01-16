#!/bin/bash



timestamp() {
  date +"%d-%m-%Y @ %T"
}

update() {
  # Explicitly copy local files rather than rely on symlinks
  rsync $HOME/.vimrc .
  rsync $HOME/.vim/templates/* .vim/templates/
  rsync $HOME/.vim/local_functions.vim .vim/local_functions.vim
}

commit() {
  if [[ $(git status --porcelain) ]]; then
      git add .
      git commit -m "Update: $(timestamp)"
  fi
}

update
commit
