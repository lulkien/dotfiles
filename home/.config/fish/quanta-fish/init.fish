# ====================== LOAD CONFIGURATIONS ====================== #
source $QF_RUNTIME_PATH/conf.d/before/loader.fish

# Load user config, if it existed
for userconf in $QF_RUNTIME_PATH/customs/conf.d/*.fish
    source $userconf
end

# Load every post config, like styles, themes, etc.
for conf_after in $QF_RUNTIME_PATH/conf.d/after/*.fish
    source $conf_after
end

# ====================== LOAD FUNCTIONS ====================== #
# This will load every functions, prompts, override builtins and others
source $QF_RUNTIME_PATH/functions/loader.fish

# Load custom functions, override existed if possible
if test -f $QF_RUNTIME_PATH/customs/functions/loader.fish
    source $QF_RUNTIME_PATH/customs/functions/loader.fish
end

# ====================== LOAD COMPLETIONS ====================== #
# This just loads everything in the completions directory
for comp in $QF_RUNTIME_PATH/completions/*.fish
    source $comp
end

# Just load every custom completions
for comp in $QF_RUNTIME_PATH/customs/completions/*.fish
    source $comp
end
