function fish_prompt
    set -l last_status $status

    set_color -o cyan
    printf '%s' $USER
    set_color -o white
    printf ' at '

    set_color -o yellow
    echo -n (prompt_hostname)
    set_color -o white
    printf ' in '

    set_color -o green
    printf '%s' (prompt_pwd --full-length-dirs=7)
    set_color normal

    # todo add git prompt

    # Line 2
    echo
    if not test $last_status -eq 0
        set_color -o $fish_color_error
    else
        set_color -o white
    end
    printf '$ '
    set_color normal
end

function fish_right_prompt -d "Write out the right prompt"
    printf '[%s]' (date '+%H:%M')
end

# Set up fzf key bindings
if command -v fzf > /dev/null
    fzf --fish | source
end


