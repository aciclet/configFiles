export EDITOR=/mass/bin/vim
export MYDOC=~/doc/mydoc.txt
export HISTTIMEFORMAT='%F %T '   # for history to include timestamps

## Prompt format
if [ "$TERM" = "xterm" -o "$TERM" = "konsole" -o "$TERM" = "dtterm" ]
then
   if [ `whoami` == adrien ]
   then
      PS1="\[\e[33;1m\] \[\e[0;0m\] \w> "
   else
      PS1="\[\e[33;1m\] \[\e[35;1m\]\u\[\e[33;1m\] \w>\[\e[0;0m\] "
   fi
fi


## Change the umask
umask 002
 
set -o allexport
set -o history

## sandboxes
export SPR=~/svn/perl
export SP=~/svn/python
export SC=~/svn/cpp
export SR=~/svn/R
export SB=~/svn/branches
alias spr="cd $SPR"
alias sp="cd $SP"
alias sc="cd $SC"
alias sr="cd $SR"
alias sb="cd $SB"


save_ssh () {
  echo "export SSH_AUTH_SOCK='$SSH_AUTH_SOCK'" > ~/.ssh_info
}

load_ssh () {
  source ~/.ssh_info
}

fing() {
   finger $1 | grep Name | tail -1 | sed 's/.*Name: \(.*\) [a-z0-9]\{7\}/\1/'
}

# tab autocompletion with 'tat' command for 'tmux a -t'
tat() {
   local session_name="$1"
   tmux attach-session -t "$session_name"
   if [ $? -ne 0 ]; then
      local code_dir="/home/ryandotsmith/src"
      local list_of_dirs=( $(find "$code_dir" -name "$session_name" -type d ) )
      local first_found="${dirs[0]}"
      cd "$first_found"
      echo "tat() is creating new tmux session with name=$session_name"
      tmux new-session -d -s "$session_name"
      echo "tat() is setting default path with dir=$first_found"
      tmux set default-path "$first_found"
      tmux attach-session -t "$session_name"
   fi
}
_tat() {
   COMPREPLY=()
   local session="${COMP_WORDS[COMP_CWORD]}"
   COMPREPLY=( $(compgen -W "$(tmux list-sessions 2>/dev/null | awk -F: '{ print $1 }')" -- "$session") )
}
complete -F _tat tat

# Grep with header
hgrep () {
  if [[ $# -ne 2 ]]; then
    echo "usage: hgrep pattern file"
    return 1
  fi
  head -n 1 $2
  tail -n +2 $2 | grep  "$1"
}
