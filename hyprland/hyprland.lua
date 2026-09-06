local terminal = "kitty"
local menu = "wofi --show drun"
local mainMod = "SUPER"

-- INIT
hl.on("hyprland.start", function()
	-- Stuff neccesary for dolphin
	hl.exec_cmd("XDG_MENU_PREFIX=plasma- kbuildsycoca6")

	-- Background and wallpapers
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("kitty +kitten panel --edge=background --output-name=DP-1 drift --scene starfield")

	-- Stuff neccesary for our clipboard history
	hl.exec_cmd("wl-paste --watch cliphist store")

	-- Tablet driver stuff
	hl.exec_cmd("otd-daemon")
	hl.exec_cmd("otd loadsettings ~/dotfiles/tablet/laptop_screen")

	-- Neccesary for displaying internet on waybar
	hl.exec_cmd("nm-applet --indicator")
end)

-- MONITORS
hl.monitor({
	output = "eDP-1",
	mode = "2880x1800@120.0000",
	position = "0x0",
	scale = "1"
})
-- hl.monitor({
-- 	output = "eDP-1",
-- 	mode = "1920x1200@120.00Hz",
-- 	position = "0x0",
-- 	scale = "1"
-- })
-- hl.monitor({
-- 	output = "HDMI-A-1",
-- 	mode = "2560x1440@59.95Hz",
-- 	position = "0x-1440",
-- 	scale = "1",
-- })
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@50.00Hz",
	position = "0x-1440",
	scale = "1",
})

-- AESTHETICS / THEME
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 0,

		border_size = 0,
		-- col.active_border = "rgba(255,255,255,0.5)",
		-- col.inactive_border = "rgba(86,15,100,0.25)",

		-- https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
		-- col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
		-- col.inactive_border = rgba(595959aa)

		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,

		-- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
		allow_tearing = false,

		layout = dwindle
	},
	decoration = {
		rounding = 0,
		active_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)"
		},
		blur = {
        enabled = true,
        size = 9,
        passes = 2,
        vibrancy = 0.1696
		},
		animations = {
			-- enabled = true
		}
	},
	dwindle = {
		preserve_split = true
	}
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.animation({ leaf = "global", enabled = true, speed = 9, bezier = "quick" })
hl.animation({ leaf = "windows", enabled = true, style = "slide", speed = 5.0, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, style = "fade", speed = 1.0, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, style = "slide", speed = 4.0, bezier = "easeInOutCubic" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.0, bezier = "almostLinear" })

-- INPUT AND DEVICES
hl.config({
	input = {
		kb_layout = us,
		repeat_delay = 250,
		repeat_rate = 71,
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true
		}
	}
})

hl.device({
	name = "at-translated-set-2-keyboard",
	kb_layout = "dk",
	kb_variant = "nodeadkeys",
	repeat_delay = 250,
	repeat_rate = 70,
	kb_options = "compose:caps"
})
hl.device({
	name = "wacom-co.-ltd.-------cintiq-pro-13-touch-touchscreen",
	enabled = false
})


-- KEYBINDINGS
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),    { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),               { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),               { locked = true, repeating = true })

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("/usr/bin/drag_pasted_image"))
hl.bind(mainMod .. " + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + left",  hl.dsp.window.move({ workspace = "r-1" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x =  -100, y = 0,    relative = true }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x =  100, y = 0,    relative = true }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0,    y =  100, relative = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0,    y = -100, relative = true }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + 1", hl.dsp.focus({workspace = 1}))
hl.bind(mainMod .. " + 2", hl.dsp.focus({workspace = 2}))
hl.bind(mainMod .. " + 3", hl.dsp.focus({workspace = 3}))
hl.bind(mainMod .. " + 4", hl.dsp.focus({workspace = 4}))
hl.bind(mainMod .. " + 5", hl.dsp.focus({workspace = 5}))
hl.bind(mainMod .. " + 6", hl.dsp.focus({workspace = 6}))
hl.bind(mainMod .. " + 7", hl.dsp.focus({workspace = 7}))
hl.bind(mainMod .. " + 8", hl.dsp.focus({workspace = 8}))
hl.bind(mainMod .. " + 9", hl.dsp.focus({workspace = 9}))
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))

-- Screenshots
hl.bind("Print",                        hl.dsp.exec_cmd("hyprshot -m region -o /home/buster/Images/screencaps"))
hl.bind(mainMod .. " + Print",          hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + SHIFT + Print",  hl.dsp.exec_cmd("hyprshot -m output -m eDP-1"))

-- Special applications
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(
    "rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"wl-copy '{result}'\""
))
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(
    "cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"
))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(
    "pkill -SIGUSR1 waybar || waybar -c /home/buster/dotfiles/waybar/config.jsonc"
))


-- WINDOW RULES
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1"})
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })

hl.window_rule({
	name = "dev-window1",
	match = {
		title = "window_dev"
	},
	size = "1000 720",
	move = "1500 0",
	workspace = "2"
})

-- MISC 
hl.config({
	misc = {
		force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
		enable_anr_dialog = false,
		anr_missed_pings = 10
	},
})

-- Quack device keys (keycodes 192 / 193 / 194)
-- hl.bind("code:192",       hl.dsp.exec_cmd("/home/buster/dotfiles/quack/increase_quack_step.sh"))
-- hl.bind("SHIFT + code:192", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
-- hl.bind("code:193",       hl.dsp.exec_cmd("/home/buster/dotfiles/quack/play_quack.sh"))
-- hl.bind("SHIFT + code:193", hl.dsp.exec_cmd("echo '0' > /home/buster/dotfiles/quack/quack_step.txt"))
-- hl.bind("code:194",       hl.dsp.exec_cmd("/home/buster/dotfiles/quack/decrease_quack_step.sh"))
-- hl.bind("SHIFT + code:194", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
