local freedesktop = require("freedesktop")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "restart", awesome.restart },
}

shutdownmenu = {
    { "Lock Screen", "i3lock"},
    { "Log out", awesome.quit},
    { "Suspend", "systemctl suspend"},
    { "Hibernate", "systemctl hibernate"},
    { "Reboot", "systemctl reboot"},
    { "Shutdown", "poweroff"}
}

function menu() 
    return freedesktop.menu.build({
        before = {
            { "Awesome", myawesomemenu, beautiful.awesome_icon}
        },
        after = {
            { "Open terminal", terminal},
            { "Shutdwon", shutdownmenu}
        }
    })
end

return menu
