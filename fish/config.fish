if status is-interactive
    # Keybindings: use vi mode
    set -g fish_key_bindings fish_vi_key_bindings

    # Git aliases
    alias g="git"
    alias ga="git add"
    alias gaa="git add ."
    alias gb="git branch"
    alias gc="git commit -v"
    alias gcm="git commit -m"
    alias gco="git checkout"
    alias gd="git diff"
    alias gds="git diff --staged"
    alias gf="git fetch"
    alias gl="git log --oneline --graph --decorate"
    alias gm="git merge"
    alias gp="git push"
    alias gpl="git pull"
    alias gr="git remote"
    alias grv="git remote -v"
    alias gs="git status"
    alias gst="git stash"
    alias gstp="git stash pop"
    alias gsta="git stash apply"
    alias gt="git tag"

    # Bonus aliases
    alias gundo="git reset --soft HEAD~1"
    alias gclean="git clean -fd && git reset --hard"
    alias gfix="git commit --amend --no-edit"

    # Zoxide init
    zoxide init fish | source
end

# Created by `pipx` on 2025-06-26 02:54:59
set PATH $PATH /Users/gmartin/.local/bin
