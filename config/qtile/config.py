from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os
import subprocess
from libqtile.widget import StatusNotifier

@hook.subscribe.startup_once
def autostart():
    #subprocess.Popen(['xrandr', '--output', 'Virtual-1', '--mode', '1920x1080'])
    home = os.path.expanduser('~/nixos-dotfiles/config/qtile/autostart.sh')
    subprocess.Popen([home])


mod = "mod4"
terminal = guess_terminal()
myTerm = "alacritty" 
lock_cmd = "i3lock -n -c 000000"
keys = [
    #Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    #Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    #Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    #Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "l", lazy.spawn(lock_cmd), desc="Lock the screen"),
    Key([mod], "e", lazy.spawn("thunar"), desc="Launch Thunar"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key(
        [], "Print",
        lazy.spawn(
            'bash -c \'ts=$(date +%s); dir="$HOME/Pictures/Screenshots"; '
            'mkdir -p "$dir" && grim -g "$(slurp)" "$dir/screen-$ts.png" && '
            'wl-copy < "$dir/screen-$ts.png" && '
            'notify-send -u normal "Screenshot" "Saved"\''
        ),
        desc="Скриншот выделенной области в файл и буфер"
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "d", lazy.spawn("rofi -show drun -show-icons"), desc='Run Launcher'),
    Key([mod], "b", lazy.spawn("librewolf"), desc='Run Librewolf'),
    #Key([], "Print", lazy.spawn("flameshot gui"), desc='Screenshot'),
    Key(
        [mod], 
        "s",
        lazy.spawn('sh -c "maim -s | xclip -selection clipboard -t image/png -i"'),
        desc="Screenshot"
    ),
]


groups = [Group(i) for i in "123456789"]

@hook.subscribe.startup
def set_primary_focus():
    qtile.focus_screen(0)

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc=f"Switch to & move focused window to group {i.name}",
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )

colors = [
    ["#1a1b26", "#1a1b26"],  # bg        (primary.background)
    ["#a9b1d6", "#a9b1d6"],  # fg        (primary.foreground)
    ["#32344a", "#32344a"],  # color01   (normal.black)
    ["#f7768e", "#f7768e"],  # color02   (normal.red)
    ["#9ece6a", "#9ece6a"],  # color03   (normal.green)
    ["#e0af68", "#e0af68"],  # color04   (normal.yellow)
    ["#7aa2f7", "#7aa2f7"],  # color05   (normal.blue)
    ["#ad8ee6", "#ad8ee6"],  # color06   (normal.magenta)
    ["#0db9d7", "#0db9d7"],  # color15   (bright.cyan)
    ["#444b6a", "#444b6a"]   # color[9]  (bright.black)
]

# helper in case your colors are ["#hex", "#hex"]
def C(x): return x[0] if isinstance(x, (list, tuple)) else x

layout_theme = {
    "border_width" : 1,
    "margin" : 1,
    "border_focus" : colors[6],
    "border_normal" : colors[0],
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font Propo Bold",
    fontsize=16,
    padding=0,
    background=colors[0],
)


extension_defaults = widget_defaults.copy()

sep = widget.Sep(linewidth=1, padding=8, foreground=colors[9])


primary_widgets = [
    widget.Spacer(length = 8),
    widget.Prompt(
        font = "Ubuntu Mono",
        fontsize=14,
        foreground = colors[1]
    ),
    widget.GroupBox(
        fontsize = 18,
        margin_y = 5,
        margin_x = 5,
        padding_y = 0,
        padding_x = 2,
        borderwidth = 3,
        active = colors[8],
        inactive = colors[9],
        rounded = False,
        highlight_color = colors[0],
        highlight_method = "line",
        this_current_screen_border = colors[7],
        this_screen_border = colors [4],
        other_current_screen_border = colors[7],
        other_screen_border = colors[4],
    ),
    widget.TextBox(
        text = '|',
        font = "JetBrainsMono Nerd Font Propo Bold",
        foreground = colors[9],
        padding = 2,
        fontsize = 14
    ),
    widget.CurrentLayout(
        foreground = colors[1],
        padding = 5
    ),
    widget.TextBox(
        text = '|',
        font = "JetBrainsMono Nerd Font Propo Bold",
        foreground = colors[9],
        padding = 2,
        fontsize = 14
    ),
    widget.WindowName(
        foreground = colors[6],
        padding = 8,
        max_chars = 40
    ),
   # widget.KeyboardLayout(
   # configured_keyboards=['us', 'ru'],
   # display_map={'us': 'US', 'ru': 'RU'},
   # foreground=colors[1],
   # padding=5
   # ),
    sep,
    widget.CPU(
        foreground = colors[4],
        padding = 8, 
        format="CPU: {load_percent}%",
    ),
    sep,
    widget.Memory(
        foreground = colors[8],
        padding = 8, 
        format = 'Mem: {MemUsed:.0f}{mm}',
    ),
    sep,
    widget.DF(
        update_interval = 60,
        foreground = colors[5],
        padding = 8, 
        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-disk')},
        partition = '/',
        format = '{uf:.3}{m} free',
        fmt = 'Disk: {}',
        visible_on_warn = False,
    ),
    sep,
    sep,
    widget.PulseVolume(
        foreground = colors[7],
        padding = 8,
        mouse_callbacks = {'Button1': lazy.spawn('pavucontrol')},
        fmt = 'Vol: {}',
    ),
    sep,
    widget.Clock(
        foreground = colors[8],
        padding = 8, 
        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-date')},
        format = "%a, %b %d - %H:%M",
    ),
    #widget.Systray(padding = 6),
    widget.Spacer(length = 8),
    StatusNotifier(padding = 6),
]

screens = [
    Screen(),
    Screen(top=bar.Bar(widgets=primary_widgets, size=30, margin=[0, 0, 0, 0])),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False

# Format: "wm_class": (X, Y, Width, Height)
CUSTOM_WINDOW_RULES = {
    "pavucontrol": (1220, 32, 700, 450),
    "thunar": (460, 190, 1000, 700)
}
app_matches = [Match(wm_class=app) for app in CUSTOM_WINDOW_RULES.keys()]
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        *app_matches,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    no_reposition_rules=app_matches
)

@hook.subscribe.client_managed
def configure_floating_windows(client):
    wm_classes = client.get_wm_class()
    if not wm_classes:
        return

    for app_class, coords in CUSTOM_WINDOW_RULES.items():
        if app_class in wm_classes:
            x, y, width, height = coords
            client.set_size_floating(width, height)
            client.set_position_floating(x, y)
            break

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

wmname = "LG3D"
