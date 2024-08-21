function fzf-ghq() {
  ######################
  ### Option Parser
  ######################

  local __parse_options (){
    local prompt="$1" && shift
    local option_list
    if [[ "$SHELL" == *"/bin/zsh" ]]; then
      option_list=("$@")
    elif [[ "$SHELL" == *"/bin/bash" ]]; then
      local -n arr_ref=$1
      option_list=("${arr_ref[@]}")
    fi

    ### Select the option
    selected_option=$(printf "%s\n" "${option_list[@]}" | fzf --ansi --prompt="${prompt} > ")
    if [[ -z "$selected_option" || "$selected_option" =~ ^[[:space:]]*$ ]]; then
      return 1
    fi

    ### Normalize the option list
    local option_list_normal=()
    for option in "${option_list[@]}"; do
        # Remove $(tput bold) and $(tput sgr0) from the string
        option_normalized="${option//$(tput bold)/}"
        option_normalized="${option_normalized//$(tput sgr0)/}"
        # Add the normalized string to the new array
        option_list_normal+=("$option_normalized")
    done
    ### Get the index of the selected option
    index=$(printf "%s\n" "${option_list_normal[@]}" | grep -nFx "$selected_option" | cut -d: -f1)
    if [ -z "$index" ]; then
      return 1
    fi

    ### Generate the command
    command=""
    if [[ "$SHELL" == *"/bin/zsh" ]]; then
      command="${option_list_normal[$index]%%:*}"
    elif [[ "$SHELL" == *"/bin/bash" ]]; then
      command="${option_list_normal[$index-1]%%:*}"
    else
      echo "Error: Unsupported shell. Please use bash or zsh to use fzf-ghq."
      return 1
    fi
    echo $command
    return 0
  }

  ######################
  ### ghq
  ######################

  local __ghq() {
  }

  local __ghq-cd() {
    local dir=$(ghq list --full-path | fzf --ansi --prompt="ghq cd > ")
    [ -n "$dir" ] && BUFFER="cd \"$dir\""
  }

  local __ghq-cd-open() {
    local dir=$(ghq list --full-path | fzf --ansi --prompt="ghq cd && open > ")
    [ -n "$dir" ] && BUFFER="cd \"$dir\" && open \"$dir\""
  }

  local __ghq-cd-cursor() {
    local dir=$(ghq list --full-path | fzf --ansi --prompt="ghq cd && cursor -n > ")
    [ -n "$dir" ] && BUFFER="cd \"$dir\" && open \"$dir\" && cursor -n \"$dir\""
  }

  local __ghq-cd-code() {
    local dir=$(ghq list --full-path | fzf --ansi --prompt="ghq cd && code -n > ")
    [ -n "$dir" ] && BUFFER="cd \"$dir\" && open \"$dir\" && code -n \"$dir\""
  }

  local __ghq-cd-stree() {
    local dir=$(ghq list --full-path | fzf --ansi --prompt="ghq cd && stree > ")
    [ -n "$dir" ] && BUFFER="cd \"$dir\" && open \"$dir\" && stree \"$dir\""
  }

  ######################
  ### Entry Point
  ######################

  local init() {
    local option_list=(
      "$(tput bold)ghq cd:$(tput sgr0)       Search and change the directory in the shell"
      "$(tput bold)ghq open:$(tput sgr0)     Search and open the directory in Finder"
    )
    local is_editor_added=false
    if command -v cursor &> /dev/null; then
      option_list+=("$(tput bold)ghq cursor:$(tput sgr0)   Search and open the directory in Finder and Cursor")
      is_editor_added=true
    fi
    if command -v code &> /dev/null; then
      option_list+=("$(tput bold)ghq code:$(tput sgr0)     Search and open the directory in Finder and Visual Studio Code")
      is_editor_added=true
    fi
    if command -v stree &> /dev/null; then
      option_list+=("$(tput bold)ghq stree:$(tput sgr0)    Search and open the directory in Finder and Sourcetree")
      is_editor_added=true
    fi
    if $is_editor_added; then
      option_list+=(" ")
    fi
    option_list+=(
      "$(tput bold)ghq list:$(tput sgr0)     Show the list of repositories"
      "$(tput bold)ghq get:$(tput sgr0)      Clone a new repository"
      "$(tput bold)ghq create:$(tput sgr0)   Create a new repository"
      "$(tput bold)ghq root:$(tput sgr0)     Show the root directory of ghq"
    )
    command=$(__parse_options "ghq" ${option_list[@]})
    if [ $? -eq 1 ]; then
        zle accept-line
        zle -R -c
        return 1
    fi
    case "$command" in
      "ghq cd")     __ghq-cd;;
      "ghq open")   __ghq-cd-open;;
      "ghq cursor") __ghq-cd-cursor;;
      "ghq code")   __ghq-cd-code;;
      "ghq stree")  __ghq-cd-stree;;
      "ghq list")   BUFFER="ghq list --full-path";;
      "ghq get")    BUFFER="ghq get";;
      "ghq create") BUFFER="ghq create";;
      "ghq root")   BUFFER="ghq root";;
      *)            BUFFER="echo \"Error: Unknown command '$command\"";;
    esac
    zle accept-line
    zle -R -c
  }

  init
}

zle -N fzf-ghq
if [[ "$SHELL" == *"/bin/zsh" ]]; then
  bindkey "${FZF_GHQ_KEY_BINDING}" fzf-ghq
elif [[ "$SHELL" == *"/bin/bash" ]]; then
  bind -x "'${FZF_GHQ_KEY_BINDING}': fzf-ghq"
fi