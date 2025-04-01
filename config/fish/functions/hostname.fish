function hostname
    if test -n "$hostname"
        printf "$hostname\n"
    else if command -q hostname
        command hostname
    else
        set -f HOSTNAME_ (head -1 /etc/hostname)
        test -n "$HOSTNAME_"; and printf "$HOSTNAME_\n"; or echo "Unknown\n"
    end
end
