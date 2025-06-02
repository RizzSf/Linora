# Linora Aimbot Library v1
Universal : Free, Open Source

## Use
```lua
getgenv().LinoraAimbot = {
    Fov = {
        ["Fov Size"] = 60,
        ["Fov Color"] = Color3.fromRGB(255, 100, 100),
        ["Fov Thickness"] = 2
    },
    ["Max Distance"] = 400,
    ["Team Check"] = true,
    ["Enabled"] = true
}

local script_url = "https://raw.githubusercontent.com/RizzSf/Linora/refs/heads/main/--/LinoraLib_Aimbot.lua"

loadstring(game:HttpGet(script_url))()
```
