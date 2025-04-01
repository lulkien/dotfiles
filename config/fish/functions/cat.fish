function cat --wraps=cat --description='bat wrapper'
    if command -q bat
        bat $argv
    else
        command cat $argv
    end
end
