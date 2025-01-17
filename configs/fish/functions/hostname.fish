function hostname
    if test -n "$HOSTNAME"
        echo "$HOSTNAME"
    else if test -n "$hostname"
        echo "$hostname"
    else if command -sq hostname
        command hostname
    else
        set _HOSTNAME (head -1 /etc/hostname)
        test -n "$_HOSTNAME"; and echo "$_HOSTNAME"; or echo Unknown
    end
end
