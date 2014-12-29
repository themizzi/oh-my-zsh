# mizzi.zsh-theme
# screenshot: 

function is_git() {
  [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
}

function is_svn() {
  svn info > /dev/null 2>&1
}

function vcs_prompt_info() {
  if is_git; then
    echo $(git_prompt_info)
  elif is_svn; then
    echo $(svn_prompt_info)
  fi
}

function vcs_prompt_status() {
  if is_git; then
    echo " $(git_prompt_status)"
  elif is_svn; then
    echo " $(svn_status_info)"
  fi
}

function svn_prompt_info() {
  local info
  info=$(svn info 2>&1) || return 1; # capture stdout and stderr
  local repo_need_upgrade=$(svn_repo_need_upgrade $info)

  if [[ -n $repo_need_upgrade ]]; then
    printf '%s%s%s%s%s%s%s\n' \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_PREFIX \
      $ZSH_PROMPT_BASE_COLOR \
      $repo_need_upgrade \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_SUFFIX \
      $ZSH_PROMPT_BASE_COLOR
  else
    printf '%s%s:%s%s%s%s%s' \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_PREFIX \
      \
      $ZSH_THEME_BRANCH_NAME_COLOR \
      $(svn_current_branch_name $info) \
      $ZSH_PROMPT_BASE_COLOR \
      \
      $(svn_current_revision $info) \
      $ZSH_PROMPT_BASE_COLOR \
      \
      $ZSH_THEME_SVN_PROMPT_SUFFIX \
      $ZSH_PROMPT_BASE_COLOR
  fi
}

if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
  local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%}"
  
  PROMPT='%{$fg_bold[green]%}➜ %{$fg_bold[cyan]%}%1~$(vcs_prompt_info) %(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}❯)%{$reset_color%} '

  ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}git%{$reset_color%}:%{$fg[red]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY=""
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  ZSH_THEME_SVN_PROMPT_PREFIX=" %{$fg[blue]%}svn%{$reset_color%}:%{$fg[red]%}"
  ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"

  RPROMPT='${return_status}$(vcs_prompt_status)%{$reset_color%}'

  ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%} ✚"
  ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%} ✹"
  ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%} ✖"
  ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%} ➜"
  ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%} ═"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%} ✭"

  ZSH_THEME_SVN_PROMPT_ADDITIONS="%{$fg_bold[green]%} ✚"
  ZSH_THEME_SVN_PROMPT_DELETIONS="%{$fg_bold[red]%} ✖"
  ZSH_THEME_SVN_PROMPT_MODIFICATIONS="%{$fg_bold[blue]%} ✹"
  ZSH_THEME_SVN_PROMPT_REPLACEMENTS="%{$fg_bold[magenta]%} ➜"
  ZSH_THEME_SVN_PROMPT_UNTRACKED="%{$fg_bold[cyan]%} ?"
  ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg_bold[yellow]%} !"
else 
  MODE_INDICATOR="❮❮❮"
  local return_status="%(?::⏎)"
  
  PROMPT='%c$(vcs_prompt_info) %(!.#.❯) '

  ZSH_THEME_GIT_PROMPT_PREFIX=" git:"
  ZSH_THEME_GIT_PROMPT_SUFFIX=""
  ZSH_THEME_GIT_PROMPT_DIRTY=""
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  ZSH_THEME_SVN_PROMPT_PREFIX=" svn:"
  ZSH_THEME_SVN_PROMPT_SUFFIX=""

  RPROMPT='${return_status}$(vcs_prompt_status)'

  ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
  ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
  ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
  ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
  ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
  ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"

  ZSH_THEME_SVN_PROMPT_ADDITIONS=" ✚"
  ZSH_THEME_SVN_PROMPT_DELETIONS=" ✖"
  ZSH_THEME_SVN_PROMPT_MODIFICATIONS=" ✹"
  ZSH_THEME_SVN_PROMPT_REPLACEMENTS=" ➜"
  ZSH_THEME_SVN_PROMPT_UNTRACKED=" ?"
  ZSH_THEME_SVN_PROMPT_DIRTY=" !"
fi
