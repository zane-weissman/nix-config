# reminder: \x2d = "-"
#           \x1d = "↔ " (???)
set -u __fish_initialized 3400


# main colors
set -u fish_color_normal normal
set -u fish_color_command magenta # e.g. "echo"
set -u fish_color_keyword \x1d # e.g. "if"
set -u fish_color_autosuggestion brwhite # what you press right arrow to complete
set -u fish_color_cancel brred \x2d\x2dreverse # "^C after you press <C-c>
set -u fish_color_comment brwhite # following "#"
set -u fish_color_cwd normal
set -u fish_color_cwd_root brred
set -u fish_color_end green # ;, &, etc
set -u fish_color_error brred
set -u fish_color_escape brcyan \x2d\x2dbold# \nx, \x70, etc
set -u fish_color_history_current \x2d\x2dbold
set -u fish_color_host brwhite
set -u fish_color_host_remote brcyan
set -u fish_color_match \x2d\x2dbackground\x3dbrblue
set -u fish_color_operator \x2d\x2d
set -u fish_color_option \x1d
set -u fish_color_param brcyan
set -u fish_color_quote brgreen
set -u fish_color_redirection green # > etc
set -u fish_color_search_match bryellow\x1e\x2d\x2dbackground\x3dbrblack
set -u fish_color_selection white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
set -u fish_color_status yellow # >, #, etc
set -u fish_color_user brblack
set -u fish_color_valid_path brcyan --underline

set -u fish_key_bindings fish_vi_key_bindings


set -u fish_pager_color_background \x1d
set -u fish_pager_color_completion normal
set -u fish_pager_color_description B3A06D
set -u fish_pager_color_prefix normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
set -u fish_pager_color_progress brwhite\x1e\x2d\x2dbackground\x3dcyan
set -u fish_pager_color_secondary_background \x1d
set -u fish_pager_color_secondary_completion \x1d
set -u fish_pager_color_secondary_description \x1d
set -u fish_pager_color_secondary_prefix \x1d
set -u fish_pager_color_selected_background \x2d\x2dbackground\x3dbrblack
set -u fish_pager_color_selected_completion \x1d
set -u fish_pager_color_selected_description \x1d
set -u fish_pager_color_selected_prefix \x1d
