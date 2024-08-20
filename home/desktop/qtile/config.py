# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import sys
import subprocess
from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Group, Match, Screen
# Make sure 'qtile-extras' is installed or this config will not work.
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration
#from qtile_extras.widget import StatusNotifier

# local
from keys import keys, mouse
from groups import groups
import colors
from devices import hostname


colors = colors.DoomOne

layout_theme = {"border_width": 2,
                "margin": 4,
                "border_focus": colors[8],
                "border_normal": colors[0]
                }

layouts = [
    #layout.Bsp(**layout_theme),
    #layout.Floating(**layout_theme)
    #layout.RatioTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    layout.MonadTall(name="mon", **layout_theme, new_client_position='top'),
    #layout.MonadWide(**layout_theme),
    layout.Max(
         border_width = 0,
         margin = 0,
         ),
    #layout.Stack(**layout_theme, num_stacks=2),
    layout.Columns(name = "col", **layout_theme),
    layout.TreeTab(
         name = "tst",
         font = "Monospace Bold",
         fontsize = 16,
         border_width = 0,
         bg_color = colors[0],
         active_bg = colors[8],
         active_fg = colors[2],
         inactive_bg = colors[1],
         inactive_fg = colors[0],
         padding_left = 8,
         padding_x = 8,
         padding_y = 6,
         sections = ["ONE", "TWO", "THREE"],
         section_fontsize = 10,
         section_fg = colors[7],
         section_top = 15,
         section_bottom = 15,
         level_shift = 8,
         vspace = 3,
         panel_width = 240
         ),
    layout.VerticalTile(name = "vrt", **layout_theme),
    #layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="Monospace Bold",
    fontsize = 18,
    padding = 0,
    background=colors[0]
)

extension_defaults = widget_defaults.copy()

groupbox1 = widget.GroupBox(
        disable_drag = True,
        fontsize = 14,
        margin_y = 5,
        margin_x = 0,
        padding_y = 0,
        padding_x = 1,
        borderwidth = 3,
        active = colors[8],
        inactive = colors[1],
        rounded = False,
        highlight_color = colors[2],
        highlight_method = "line",
        this_current_screen_border = colors[7],
        this_screen_border = colors [4],
        other_current_screen_border = colors[7],
        other_screen_border = colors[4],
        visible_groups = ['1','2','3','4','5']
        ),
groupbox2 = widget.GroupBox(
        disable_drag = True,
        fontsize = 14,
        margin_y = 5,
        margin_x = 0,
        padding_y = 0,
        padding_x = 1,
        borderwidth = 3,
        active = colors[8],
        inactive = colors[1],
        rounded = False,
        highlight_color = colors[2],
        highlight_method = "line",
        this_current_screen_border = colors[7],
        this_screen_border = colors [4],
        other_current_screen_border = colors[7],
        other_screen_border = colors[4],
        visible_groups = ['6','7','8','9','10']
        ),
def init_widgets_list():
    widgets_list = [
        widget.GroupBox(
                 disable_drag = True,
                 fontsize = 14,
                 margin_y = 5,
                 margin_x = 0,
                 padding_y = 0,
                 padding_x = 1,
                 borderwidth = 3,
                 active = colors[8],
                 inactive = colors[1],
                 rounded = False,
                 highlight_color = colors[2],
                 highlight_method = "line",
                 this_current_screen_border = colors[7],
                 this_screen_border = colors [4],
                 other_current_screen_border = colors[7],
                 other_screen_border = colors[4],
                 visible_groups = ['1','2','3','4','5']
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Monospace",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.CurrentLayoutIcon(
                 # custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                 foreground = colors[1],
                 padding = 4,
                 scale = 0.6
                 ),
        widget.CurrentLayout(
                 foreground = colors[1],
                 padding = 5
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Monospace",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.Prompt(
                 font = "Monospace",
                 fontsize=18,
                 foreground = colors[1]
        ),
        widget.TaskList(
                 foreground = colors[6],
                 font = "Monospace",
                 fontsize = 14,
                 margin_y = 4
                 # max_chars = 40
                 ),
        widget.Spacer(length = 8),
        widget.CPU(
                 format = 'C {load_percent}%',
                 foreground = colors[4],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                 decorations=[
                     BorderDecoration(
                         colour = colors[4],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
        widget.Spacer(length = 8),
        widget.Memory(
                 foreground = colors[8],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                 format = '{MemUsed: .0f}{mm}',
                 fmt = 'M{}',
                 decorations=[
                     BorderDecoration(
                         colour = colors[8],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
        widget.Spacer(length = 8),
        widget.DF(
                 update_interval = 60,
                 foreground = colors[5],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e df')},
                 partition = '/' if hostname == "clara" else '/home',
                 #format = '[{p}] {uf}{m} ({r:.0f}%)',
                 format = '-{uf}{m}',
                 fmt = 'D {}',
                 visible_on_warn = False,
                 decorations=[
                     BorderDecoration(
                         colour = colors[5],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
        widget.Spacer(length = 8),
        widget.Volume(
                 foreground = colors[7],
                 fmt = 'V {}',
                 decorations=[
                     BorderDecoration(
                         colour = colors[7],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
        widget.Spacer(length = 8),
        widget.Wlan(
                foreground = colors[4], format = "{quality}/70", fmt = "N {}",
                decorations=[
                    BorderDecoration(
                        colour = colors[4],
                        border_width = [0, 0, 2, 0],
                    )
                ],
                ),
        widget.Spacer(length = 8),
        widget.Battery(
                foreground = colors[3],
                battery = "axp20x-battery" if hostname == "clara" else 0,
                format = "{char}{percent:2.0%}",
                fmt = "B {}",
                decorations=[
                    BorderDecoration(
                        colour = colors[3],
                        border_width = [0, 0, 2, 0],
                    )
                ],
                ),
        widget.Spacer(length = 8),
        widget.Clock(
                 foreground = colors[6],
                 format = "%^b%d %I:%M%p",
                 #fmt = '<span text_transform="uppercase">{}</span>',
                 #timezone = datetime.timezone.est,
                 decorations=[
                     BorderDecoration(
                         colour = colors[6],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
        widget.Spacer(length = 8),
        widget.Systray(padding = 3),
        #widget.Spacer(length = 8),

        ]
    return widgets_list

# def init_widgets_screen1_only_screen():
#     widgets_screen1 = init_widgets_list()
#     return widgets_screen1 
widgets_screen1 = []
def init_widgets_screen1():
    #widgets_screen1 = []
    widgets_screen1.extend(init_widgets_list())
    #if (qtile.screens == 2):
    widgets_screen1[0].visible_groups = ['1', '2', '3', '4', '5']
    #widgets_screen1.insert(1, groupbox1)
    return widgets_screen1 

# All other monitors' bars will display everything but the last two widgets (systray and spacer).
def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    #widgets_screen2[1].visible_groups = ['6', '7', '8', '9', '10']
    #widgets_screen2.insert(1, groupbox2)
    del widgets_screen2[-2:-1]
    return widgets_screen2

# For adding transparency to your bar, add (background="#00000000") to the "Screen" line(s)
# For ex: Screen(top=bar.Bar(widgets=init_widgets_screen2(), background="#00000000", size=24)),

def init_screens():
    return [Screen(bottom=bar.Bar(widgets=widgets_screen1, size=26)),
            Screen(bottom=bar.Bar(widgets=init_widgets_screen2(), size=26)),
            Screen(bottom=bar.Bar(widgets=init_widgets_screen2(), size=26))]

@hook.subscribe.screens_reconfigured
async def update_widgets():
    if len(qtile.screens) == 1:
        qtile.screen.bar[bottom].widget[groupbox].visible_groups = ['1','2','3','4','5','6','7','8','9','10']

#@hook.subscribe.screens_reconfigured
#async def _():
#    if len(qtile.screens) > 1:
#        groupbox1.visible_groups = ['1', '2', '3','4','5']
#    else:
#        groupbox1.visible_groups = ['1', '2', '3','4','5','6', '7', '8','9','10']
#    if hasattr(groupbox1, 'bar'):
#        groupbox1.bar.draw()

if __name__ in ["config", "__main__"]:
    init_widgets_screen1()
    screens = init_screens()
    update_widgets()
    #widgets_list = init_widgets_list()
    #widgets_screen1 = init_widgets_screen1()
    #widgets_screen2 = init_widgets_screen2()


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)

def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)

def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),   # gitk
        Match(wm_class="dialog"),         # dialog boxes
        Match(wm_class="download"),       # downloads
        Match(wm_class="error"),          # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class='kdenlive'),       # kdenlive
        Match(wm_class="makebranch"),     # gitk
        Match(wm_class="maketag"),        # gitk
        Match(wm_class="notification"),   # notifications
        Match(wm_class='pinentry-gtk-2'), # GPG key password entry
        Match(wm_class="ssh-askpass"),    # ssh-askpass
        Match(wm_class="toolbar"),        # toolbars
        Match(wm_class="Yad"),            # yad boxes
        Match(title="branchdialog"),      # gitk
        Match(title='Confirmation'),      # tastyworks exit box
        Match(title='Qalculate!'),        # qalculate-gtk
        Match(title="pinentry"),          # GPG key password entry
        Match(title="tastycharts"),       # tastytrade pop-out charts
        Match(title="tastytrade"),        # tastytrade pop-out side gutter
        Match(title="tastytrade - Portfolio Report"), # tastytrade pop-out allocation
        Match(wm_class="tasty.javafx.launcher.LauncherFxApp"), # tastytrade settings
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    #subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
