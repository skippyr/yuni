setopt prompt_subst
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PATH=$(dirname $0)/bin:${PATH}
PROMPT='$(yuni)'
