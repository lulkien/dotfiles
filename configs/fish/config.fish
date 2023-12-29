if status is-interactive
    set -g QF_RUNTIME_PATH $HOME/.config/fish/quanta-fish

    if test -d $QF_RUNTIME_PATH
        # Bootstrap
        if not test -d $QF_RUNTIME_PATH/customs
            fish $QF_RUNTIME_PATH/bootstrap/bootstrap.fish
        end
        
        source $QF_RUNTIME_PATH/init.fish
    end
end
