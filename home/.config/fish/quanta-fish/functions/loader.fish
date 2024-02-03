# Load prompt functions first
for fn in $QF_RUNTIME_PATH/functions/prompts/*.fish
    source $fn
end

# Load overrided builtin functions
for fn in $QF_RUNTIME_PATH/functions/override/*.fish
    source $fn
end

# Load singularity functions
for fn in $QF_RUNTIME_PATH/functions/extensions/*.fish
    source $fn
end
