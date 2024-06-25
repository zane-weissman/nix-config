function fish_right_prompt
    set last $status
    if [ $last = 0 ]
        echo (set_color brgreen) -
    else
        echo (set_color $fish_color_error) !$last
    end
    #echo -n -s ' '
end
