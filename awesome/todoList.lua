local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

function new(screen, text_file, width, height, buttons)
    buttons = buttons or {}

    local g = screen.geometry
    local x = g.x + (g.width - width) / 2
    local y = g.y + (g.height - height) / 2
    ret = wibox({
        screen=screen,
        x=x,
        y=y,
        width=width,
        height=height,
        --widget = awful.widget.watch("cat ".. os.getenv("HOME") .. "/todoList.txt"),
        bg=beautiful.todolist_bg or bg_normal,
        border_color = beautiful.todolist_border or border_normal,
        border_width = beautiful.border_width,
    })
    local watch = awful.widget.watch("cat ".. os.getenv("HOME") .. "/todoList.txt")
    watch.valign = "top"
    ret:setup{
        watch,
        margins = 8,
        layout = wibox.container.margin,
    }
    ret:buttons(buttons)
    ret.visible = true
    return ret
end

return new
