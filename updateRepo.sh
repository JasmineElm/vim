#!/bin/sh

list_local_files() {
  # list local files
  find . -type f \
    -not -path './README.md' \
    -not -path './updateRepo.sh' \
    -not -path './.git/*'
}

update() {
  for file in $(list_local_files); do
    # copy local files to repo
    rsync "$HOME"/"$file" .
  done
  git add .
}

install() {
  # install vim-plug
  curl -fLo .vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall -c 'qa!'
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
    if [ -z "$*" ]
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
