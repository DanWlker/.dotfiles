-- Catppuccin Mocha palette for the Lua config.
-- mocha.conf is kept as-is because hyprlock/hypridle/hyprpaper still use hyprlang.
-- Keep the two in sync when you change a color.

local hex = {
    rosewater = "f5e0dc",
    flamingo  = "f2cdcd",
    pink      = "f5c2e7",
    mauve     = "cba6f7",
    red       = "f38ba8",
    maroon    = "eba0ac",
    peach     = "fab387",
    yellow    = "f9e2af",
    green     = "a6e3a1",
    teal      = "94e2d5",
    sky       = "89dceb",
    sapphire  = "74c7ec",
    blue      = "89b4fa",
    lavender  = "b4befe",
    text      = "cdd6f4",
    subtext1  = "bac2de",
    subtext0  = "a6adc8",
    overlay2  = "9399b2",
    overlay1  = "7f849c",
    overlay0  = "6c7086",
    surface2  = "585b70",
    surface1  = "45475a",
    surface0  = "313244",
    base      = "1e1e2e",
    mantle    = "181825",
    crust     = "11111b",
}

-- mocha.lavender -> "rgb(b4befe)", mocha.hex.lavender -> "b4befe"
local mocha = { hex = hex }
for name, value in pairs(hex) do
    mocha[name] = "rgb(" .. value .. ")"
end

return mocha
