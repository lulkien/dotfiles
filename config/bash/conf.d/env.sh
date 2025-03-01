KBC_USER_PATH=("$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/go/bin")

for path in "${KBC_USER_PATH[@]}"; do
    if [[ ! $PATH =~ $path ]]; then
        export PATH=$path:$PATH
    fi
done
