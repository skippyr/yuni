setopt prompt_subst
export VIRTUAL_ENV_DISABLE_PROMPT=1
__yuni=$(dirname $0)/yuni
PROMPT='$(${__yuni})'
