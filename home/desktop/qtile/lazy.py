from libqtile.lazy import lazy
# Allows you to input a name when adding treetab section.
@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)

# if any minimized windows, unminimze them
# otherwise, minimize all windows
@lazy.function
def toggle_minimize_all(qtile):
    for win in qtile.current_group.windows:
        if (hasattr(win, "toggle_minimize") and win.minimized):
            qtile.current_group.unminimize_all()
            return
    # if left loop then no windows minimized
    for win in qtile.current_group.windows:
        if (hasattr(win, "toggle_minimize")):
            win.toggle_minimize()
           
# A function for killing all the windows in a group
@lazy.function
def kill_all(qtile):
    for win in qtile.current_group.windows:
        win.kill()

# A function for toggling between MAX and MONADTALL layouts
max_layouts = {}
@lazy.function
def maximize_by_switching_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    # store last layout when maximizing
    if current_layout_name != 'max': 
        max_layouts[qtile.current_group.name] = current_layout_name
        qtile.current_group.layout = 'max'
    # recover and clear if un-maximizing
    elif qtile.current_group.name in max_layouts:
        qtile.current_group.layout = max_layouts[qtile.current_group.name]
        del max_layouts[qtile.current_group.name]
    # if in max but just from cycling through layouts, return to default
    else:
        qtile.current_group.layout = "mon"
    #if current_layout_name == 'max':
        #qtile.current_group.layout = 'monadtall'
    #else
        #qtile.current_group.layout = 'max'

@lazy.function
def set_layout(qtile, l):
    qtile.current_group.setlayout(l)

@lazy.function
def move_to_screen(qtile, offset):
    n = len(qtile.screens)
    i = (qtile.screens.index(qtile.current_screen) + offset) % n
    group = qtile.screens[i].group.name
    qtile.current_window.togroup( group, switch_group = False)
    qtile.focus_screen(i)

@lazy.function
def go_to_group(qtile, name: str):
    # if only 1 screen just 
    if len(qtile.screens) == 1:
        qtile.groups_map[name].toscreen()
        return

    if name in '12345':
        qtile.focus_screen(0)
        qtile.groups_map[name].toscreen()
    else:
        qtile.focus_screen(1)
        qtile.groups_map[name].toscreen()
