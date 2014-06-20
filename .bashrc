[ -z "$PS1" ] && return
# interactive

source $HOME/.aliases
for sh in `find ${HOME}/.bash.d/ -type f 2>/dev/null`; do . $sh; done

# percol
export SELECTOR
if type -t 'percol' >&/dev/null; then SELECTOR=percol; fi
if [[ ! -z "$SELECTOR" ]]; then
    _search_history() {
        local l=$(HISTTIMEFORMAT= history|tac|LC_ALL=C sed -e 's/^\s*[0-9]\+\s\+//' | $SELECTOR --query "$READLINE_LINE")
        READLINE_LINE="$l"
        READLINE_POINT=${#l}
    }
    bind -x '"\C-r": _search_history'
    bind    '"\C-xr": reverse-search-history'

    _cd_cdhist() {
        local dir=$(for i in "${CDHIST_CDQ[@]}"; do echo $i; done | percol);
        echo "$dir"
        cd "$dir"
    }
    bind '"\e ": "_cd_cdhist\n"'

    _insert_pid() {
        local psopt
        if [[ $(id -u) = "0" ]]; then
            psopt='axwww'
        else
            psopt='xwww'
        fi
        local l=$(ps $psopt -o user,pid,cmd | $SELECTOR | awk '{print $2}')
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${l}${READLINE:$READLINE_POINRT}"
        READLINE_POINT=$(($READLINE_POINT + ${#l}))
    }
    bind -x '"\C-xp": _insert_pid'

    _select_git_commit() {
        git show-branch -a | percol | sed -r  's/[^\[]*\[(.*)\].*/\1/g'
    }
    _insert_git_commit() {
        local l=$(_select_git_commit)
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${l}${READLINE:$READLINE_POINRT}"
        READLINE_POINT=$(($READLINE_POINT + ${#l}))
    }
    _insert_git_branch() {
        local l=$(_select_git_commit | sed -r 's/^origin\/(.*)/\1/')
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${l}${READLINE:$READLINE_POINRT}"
        READLINE_POINT=$(($READLINE_POINT + ${#l}))
    }
    bind -x '"\C-xc": _insert_git_commit'
    bind -x '"\C-xb": _insert_git_branch'
fi

PS1='\e[32m\t \[\033[33m\]\u@\h \[\033[36m\]\w\[\e[0m\]\n\$ '
