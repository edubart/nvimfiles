#!/bin/bash
#
# Minifies and symlinks vimfiles to $HOME.

# Prints usage
usage() {
  cat << EOF
usage: $0 [-s|--submodules] [-h|--help]

OPTIONS:
  -s | --submodules    Initialize and update included git submodules
EOF
}

# Exits with given error message
die() {
  echo "$@"
  exit 1
}

here=$(dirname "$0") && here=$(cd "$here" && pwd -P)

while :
do
  case "$1" in
    -h | --help )
      usage
      exit 0
      ;;
    -s | --submodules )
      cd "$here"

      # Sync git submodules if already initialized
      if [ -f "${here}/core/pathogen/autoload/pathogen.vim" ]; then
        echo "Updating git submodules"
        (git submodule sync && git submodule update --init) \
          || die "Could not sync git submodules"
      else
        echo "Initializing git submodules"
        (git submodule init && git submodule update) \
          || die "Could not update git submodules"
      fi
      shift
      ;;
    -- )
      shift
      break
      ;;
    -* )
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    * )
      break
      ;;
  esac
done

DEST="${HOME}/.config/nvim"
rm -rf $DEST
mkdir -p $DEST/bundle
ln -s "${here}/vimrc" "$DEST/init.vim"

for file in "$here"/*; do
  dir_name="$(basename "$file")"

  if [ -d "$file" ]; then
    for plugin in "$file"/*; do
      plugin_name="$(basename "$plugin")"
      ln -s "$plugin" "$DEST/bundle/$plugin_name"
    done
  fi
done

