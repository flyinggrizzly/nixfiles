# mvd: like `mv` but mkdir -p the destination directory first if missing.
#
# Supports common mv forms:
#   mvd src dst              # dst's parent dir is created if missing
#   mvd src1 src2 ... dir/   # dir is created if missing
#   mvd -t dir src1 ...      # dir is created if missing
mvd() {
  emulate -L zsh
  local target_dir=""
  local -a args
  args=("$@")

  # Handle -t/--target-directory explicitly.
  local i=1
  while (( i <= $#args )); do
    case "${args[i]}" in
      -t)
        target_dir="${args[i+1]}"
        break
        ;;
      --target-directory=*)
        target_dir="${args[i]#--target-directory=}"
        break
        ;;
      --)
        break
        ;;
    esac
    (( i++ ))
  done

  if [[ -z "$target_dir" ]]; then
    # Collect non-flag positional args.
    local -a positional
    local skip_next=0 seen_ddash=0 a
    for a in "${args[@]}"; do
      if (( skip_next )); then
        skip_next=0
        continue
      fi
      if (( ! seen_ddash )); then
        if [[ "$a" == "--" ]]; then
          seen_ddash=1
          continue
        fi
        if [[ "$a" == -t ]]; then
          skip_next=1
          continue
        fi
        if [[ "$a" == -* ]]; then
          continue
        fi
      fi
      positional+=("$a")
    done

    (( ${#positional} < 2 )) && { command mv "$@"; return $? }

    local last="${positional[-1]}"
    if (( ${#positional} > 2 )) || [[ "$last" == */ ]] || [[ -d "$last" ]]; then
      target_dir="$last"
    else
      target_dir="${last:h}"
    fi
  fi

  if [[ -n "$target_dir" && ! -d "$target_dir" ]]; then
    mkdir -p -- "$target_dir" || return $?
  fi

  command mv "$@"
}
