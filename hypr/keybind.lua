local scrPath = (os.getenv("HOME") or "") .. "/.config/hypr/Scripts"
local mainMod = "SUPER"
local TERMINAL = "kitty"
local EDITOR = "codium"
local EXPLORER = "thunar"
local BROWSER = scrPath .. "/browser-launcher.sh"
local MOVE_STEP = 30

-- Direction helpers
local directions = {
    left  = { x = -MOVE_STEP, y = 0 },
    right = { x = MOVE_STEP,  y = 0 },
    up    = { x = 0, y = -MOVE_STEP },
    down  = { x = 0, y = MOVE_STEP  },
}

-- Helpers
local function move_or_swap(dir)
    return function()
        local w = hl.get_active_window()
        if w and w.floating then
            hl.dispatch(hl.dsp.window.move({
                x = directions[dir].x,
                y = directions[dir].y,
                relative = true,
            }))
        else
            hl.dispatch(hl.dsp.window.move({
                direction = dir,
            }))
        end
    end
end

local function resize_window(dir)
    return function()
        hl.dispatch(hl.dsp.window.resize({
            x = directions[dir].x,
            y = directions[dir].y,
            relative = true,
        }))
    end
end

-- 1. Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(TERMINAL),                                                                                        { description = "Open terminal" })
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(EXPLORER),                                                                                        { description = "Open file manager" })
hl.bind(mainMod .. " + C",      hl.dsp.exec_cmd(EDITOR),                                                                                          { description = "Open editor" })
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(BROWSER),                                                                                         { description = "Open browser" })
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd("discord --enable-blink-features=MiddleClickAutoscroll"),                                         { description = "Open Discord" })
hl.bind(mainMod .. " + SPACE",  hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"),                                                            { description = "App launcher" }) -- old was hl.dsp.exec_cmd("/home/smill/.config/rofi/launchers/type-1/launcher.sh"), 
hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd("noctalia msg session lock"),                                                                     { description = "Lock screen" })
hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd("noctalia msg settings-toggle"),                                                                  { description = "Toggle settings panel" })
hl.bind(mainMod .. " + S",      hl.dsp.exec_cmd("steam"),                                                                                         { description = "Open Steam" })

-- 2. Special Characters
hl.bind("ALT + n",         hl.dsp.exec_cmd("wtype ñ"), { description = "Type ñ" })
hl.bind("ALT + SHIFT + n", hl.dsp.exec_cmd("wtype Ñ"), { description = "Type Ñ" })

-- 3. Window Management
hl.bind(mainMod .. " + Q", hl.dsp.window.close(),                      { description = "Close active window" })
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(),                 { description = "Toggle fullscreen" })
hl.bind(mainMod .. " + X", hl.dsp.window.resize(),                     { description = "Resize window" })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),               { mouse = true, description = "Drag window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(),             { mouse = true, description = "Resize window (mouse)" })

-- 4. Window Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }),  { description = "Focus window left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Focus window right" })
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }),    { description = "Focus window up" })
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }),  { description = "Focus window down" })
hl.bind("ALT + tab",           hl.dsp.window.cycle_next(),            { description = "Cycle to next window" })

-- 5. Resize Windows
for dir, _ in pairs(directions) do
    hl.bind(mainMod .. " + SHIFT + " .. dir, resize_window(dir), { description = "Resize window " .. dir })
end

-- 6. Move Windows
for dir, _ in pairs(directions) do
    hl.bind(mainMod .. " + SHIFT + CTRL + " .. dir, move_or_swap(dir), { description = "Move/swap window " .. dir })
end

-- 7. Workspaces
hl.bind(mainMod .. " + tab",         hl.dsp.exec_cmd(scrPath .. "/workspace.sh"), { description = "Workspace switcher" })
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }),         { description = "Previous workspace on monitor" })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }),        { description = "Next workspace" })
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ workspace = "r-1" }),        { description = "Previous workspace" })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.focus({ workspace = "empty" }),      { description = "Focus empty workspace" })
hl.bind(mainMod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }),        { description = "Scroll to next workspace" })
hl.bind(mainMod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }),        { description = "Scroll to previous workspace" })

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }),       { description = "Switch to workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end
hl.bind(mainMod .. " + 0",         hl.dsp.focus({ workspace = 10 }),        { description = "Switch to workspace 10" })
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }),  { description = "Move window to workspace 10" })
hl.bind(mainMod .. " + CTRL + ALT + right", hl.dsp.window.move({ workspace = "r+1" }), { description = "Move window to next workspace" })
hl.bind(mainMod .. " + CTRL + ALT + left",  hl.dsp.window.move({ workspace = "r-1" }), { description = "Move window to previous workspace" })

-- 8. Screenshots
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("HYPRSHOT_DIR=~/Pictures/Screenshots hyprshot -m window"),                                                                          { description = "Screenshot active window" })
hl.bind("ALT + PRINT",         hl.dsp.exec_cmd("HYPRSHOT_DIR=~/Pictures/Screenshots hyprshot -m output"),                                                                          { description = "Screenshot active monitor" })
hl.bind("SHIFT + PRINT",       hl.dsp.exec_cmd("HYPRSHOT_DIR=~/Pictures/Screenshots hyprshot -m region"),                                                                          { description = "Screenshot region" })
hl.bind(mainMod .. " + A",     hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | satty --filename - --output-filename ~/Pictures/Screenshots/Screenshot-$(date '+%Y%m%d-%H:%M:%S').png"), { description = "Screenshot region with annotation" })

-- 9. Media
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play/pause media" })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),       { locked = true, description = "Next track" })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),   { locked = true, description = "Previous track" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 3"),         { locked = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 3"),         { locked = true, description = "Volume down" })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pamixer -t"),           { locked = true, description = "Toggle mute" })

return true