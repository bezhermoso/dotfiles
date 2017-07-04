# Taken from https://github.com/nicholaspufal/dotfiles/blob/master/symlinks/.colorscheme, with some changes.
function __base16 {
  local base16_dir="$HOME/.dotfiles/base16-shell/scripts"

  if [[ $# -eq 0 ]]; then
    for b in $(find $base16_dir -name "base16-*.sh"); do
      echo $b | sed -e "s#$base16_dir/##" | sed -e "s/.sh$//"
    done
    return
  fi

  if [[ $# -eq 1 ]]; then
    COLORSCHEME="$base16_dir/base16-$1.sh"
    colorscheme $COLORSCHEME
  elif [[ $# -eq 2 ]]; then
    COLORSCHEME="$base16_dir/base16-$1.$2.sh"
    colorscheme $COLORSCHEME
  else
    find $base16_dir -name "base16-*.light.sh" | \
      sed -E "s/.*base16-([^.]*).*\.sh/\1/"
  fi
  export VIM_COLOR=base16-$1
}

function colorscheme {
  if [[ -s "$1" ]]; then
    export COLORSCHEME="$1"
    source $COLORSCHEME
  fi
}

function invert-colors {
  case "${COLORSCHEME}" in
    *light.sh )
      FROM_COLOR="light"
      TO_COLOR="dark"
      ;;
    *dark.sh  )
      FROM_COLOR="dark"
      TO_COLOR="light"
      ;;
  esac

  COLORSCHEME="$(echo $COLORSCHEME | sed -e "s/${FROM_COLOR}/${TO_COLOR}/")"
  colorscheme $COLORSCHEME
}

# default color scheme
