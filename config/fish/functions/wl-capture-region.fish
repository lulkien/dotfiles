function wl-capture-region
    if test "$XDG_SESSION_TYPE" != wayland
        echo "This function can only run on wayland."
        return 1
    end

    if not command -sq wf-recorder
        echo "Command not found: wf-recorder"
        return 2
    end

    if not command -sq slurp
        echo "Command not found: slurp"
        return 2
    end

    set -l record_region (slurp)
    if test $status -ne 0
        echo Canceled.
        return 4
    end

    echo "Execute: wf-recorder -g \"$record_region\""

    wf-recorder -g "$record_region" $argv
end
