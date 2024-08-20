from libqtile.config import Key, KeyChord, Drag, Click
from libqtile.lazy import lazy
from devices import hostname, default_layout
from groups import groups
import traverse
from lazy import *

if hostname == "clara":
    mod = "mod4"              # Sets mod key to SUPER/WINDOWS
    mod2 = "control"
    myBrowser = "qutebrowser"       # My browser of choice
else:
    mod = "mod4"
    mod2 = "shift"
    myBrowser = "flatpak run org.mozilla.firefox"
myTerm = "nixGL alacritty"      # My terminal of choice
keys = []

keys.extend([
    # The essentials
    #Key([mod], "Return", lazy.spawn(myTerm), desc="Terminal"),
    #Key([mod, mod2], "Return", lazy.spawn("xterm"), desc="Terminal"),
    #Key([mod], "d", lazy.spawn("rofi -show drun"), desc='Run Launcher'),
    #Key([mod], "w", lazy.spawn(myBrowser), desc='Web browser'),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, mod2], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, mod2], "q", kill_all(), desc="Logout menu"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    
    # Switch between windows
    # Some layouts like 'monadtall' only need to use j/k to move
    # through the stack, but other layouts like 'columns' will
    # require all four directions h/j/k/l to move around.
    Key([mod], "h",
        # TODO: import "layouts" and make a function "not_layout(exclude_list)" that creates a list of layouts minus exclude_list
        #lazy.function(traverse.left).when(layout!=["col"]),
        lazy.function(traverse.left),
        #lazy.layout.left().when(layout=["col"]),
        desc="Move focus to left"),
    Key([mod], "l",
        #lazy.function(traverse.right).when(layout!=["col"]),
        lazy.function(traverse.right),
        #lazy.layout.left().when(layout=["col"]),
        desc="Move focus to right"),
    Key([mod], "j", lazy.function(traverse.down), desc="Move focus down"),
    Key([mod], "k", lazy.function(traverse.up), desc="Move focus up"),
    Key([mod], "u", lazy.screen.prev_group(), desc="Previous group"),
    Key([mod], "i", lazy.screen.next_group(), desc="Next group"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, mod2], "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab"),

    Key([mod, mod2], "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab"),

    Key([mod, mod2], "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab"
    ),
    Key([mod, mod2], "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab"
    ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, mod2], "space", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Treetab prompt
    Key([mod, mod2], "a", add_treetab_section, desc='Prompt to add new section in treetab'),

    # Grow/shrink windows left/right. 
    # This is mainly for the 'monadtall' and 'monadwide' layouts
    # although it does also work in the 'bsp' and 'columns' layouts.
    # maximize/reset in vertical??
    Key([mod], "equal",
        lazy.layout.grow_left().when(layout=["bsp", "col"]),
        lazy.layout.grow().when(layout=["mon", "monadwide"]),
        desc="Grow window to the left"
    ),
    Key([mod], "minus",
        lazy.layout.grow_right().when(layout=["bsp", "col"]),
        lazy.layout.shrink().when(layout=["mon", "monadwide"]),
        desc="Grow window to the left"
    ),

    # Grow windows up, down, left, right.  Only works in certain layouts.
    # Works in 'bsp' and 'columns' layout.
    #Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    #Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    #Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    #Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "a", set_layout(default_layout), desc = "set default layout"),
    Key([mod], "s", set_layout("col"), desc = "set columns layout"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    #Key([mod], "m", lazy.layout.maximize(), desc='Toggle between min and max sizes'),
    Key([mod], "t", lazy.window.toggle_floating(), desc='toggle floating'),
    Key([mod], "f", maximize_by_switching_layout(), 
        #lazy.window.toggle_fullscreen(), 
        desc='toggle fullscreen'),
    Key([mod], "m", lazy.window.toggle_minimize(), desc="Toggle hide/show current window"),
    Key([mod, mod2], "m", toggle_minimize_all(), desc="Toggle hide/show all windows on current group"),

    # Switch focus of monitors
    Key([mod], "o", lazy.next_screen(), desc='Move focus to next monitor'),
    Key([mod], "y", lazy.prev_screen(), desc='Move focus to prev monitor'),
    # move window between monitors
    Key([mod, mod2], "o", move_to_screen(1), desc='Move focus to next monitor'),
    Key([mod, mod2], "y", move_to_screen(-1), desc='Move focus to prev monitor'),
    
    # Emacs programs launched using the key chord CTRL+e followed by 'key'
    # Dmenu/rofi scripts launched using the key chord SUPER+p followed by 'key'
    KeyChord([mod], "p", [
        Key([], "h", lazy.spawn("dm-hub -r"), desc='List all dmscripts'),
        Key([], "a", lazy.spawn("dm-sounds -r"), desc='Choose ambient sound'),
        Key([], "b", lazy.spawn("dm-setbg -r"), desc='Set background'),
        Key([], "c", lazy.spawn("dtos-colorscheme -r"), desc='Choose color scheme'),
        Key([], "e", lazy.spawn("dm-confedit -r"), desc='Choose a config file to edit'),
        Key([], "i", lazy.spawn("dm-maim -r"), desc='Take a screenshot'),
        Key([], "k", lazy.spawn("dm-kill -r"), desc='Kill processes '),
        Key([], "m", lazy.spawn("dm-man -r"), desc='View manpages'),
        Key([], "n", lazy.spawn("dm-note -r"), desc='Store and copy notes'),
        Key([], "o", lazy.spawn("dm-bookman -r"), desc='Browser bookmarks'),
        Key([], "p", lazy.spawn("rofi-pass"), desc='Logout menu'),
        Key([], "q", lazy.spawn("dm-logout -r"), desc='Logout menu'),
        Key([], "r", lazy.spawn("dm-radio -r"), desc='Listen to online radio'),
        Key([], "s", lazy.spawn("dm-websearch -r"), desc='Search various engines'),
        Key([], "t", lazy.spawn("dm-translate -r"), desc='Translate text')
    ]),
    #brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn('../../device/scripts/brightness_up.fish'))
])


for i in groups[:-1]:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                #lazy.group[i.name].toscreen(),
                go_to_group(i.name),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + ctrl + letter of group = move focused window to group
            Key(
                [mod, mod2],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                go_to_group(i.name),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )
keys.extend(
    [
        # mod1 + letter of group = switch to group
        Key(
            [mod],
            "0",
            #lazy.group[i.name].toscreen(),
            go_to_group("10"),
            desc="Switch to group {}".format("10"),
        ),
        # mod1 + ctrl + letter of group = move focused window to group
        Key(
            [mod, mod2],
            "0",
            lazy.window.togroup("10", switch_group=True),
            go_to_group("10"),
            desc="Move focused window to group {}".format("10"),
        ),
    ]
)

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
