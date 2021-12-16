local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              c:emit_signal(
                                                  "request::activate",
                                                  "tasklist",
                                                  {raise = true}
                                              )
                                          end),
                     awful.button({ }, 2, function(c) c:kill() end),
                     awful.button({ }, 3, function(c)
                                              c.minimized = true
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end))

function bind_tasklist_button(widget, client, property_name)
    widget:buttons(awful.button({}, 1, function()end, 
        function(c) 
            --naughty.notify({text=property_name .. ": " .. tostring(client[property_name])})
            if not client[property_name] then
                client[property_name] = true
            else
                client[property_name] = false
            end
        end
    ))
    client:connect_signal("property::" .. property_name, function(c) 
        if c[property_name] then
            widget.image = beautiful["titlebar_" .. property_name .. "_button_focus_active"]
        else
            widget.image = beautiful["titlebar_" .. property_name .. "_button_focus_inactive"]
        end
    end)
end
                                          
function new_takslisk(screen)
    return awful.widget.tasklist {
        screen  = screen,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        right = 4,
                        widget  = wibox.container.margin,
                        id = "buttons",
                    },
                    {
                        {
                            widget = wibox.widget.textbox,
                            id = "text_role",
                        },
                        layout = wibox.container.margin,
                        id = "buttons",
                    },
                    {
                        {
                            widget = wibox.widget.imagebox,
                            image = beautiful.titlebar_floating_button_focus_inactive,
                            id = "floating_button",
                        },
                        {
                            widget = wibox.widget.imagebox,
                            image = beautiful.titlebar_sticky_button_focus_inactive,
                            id = "sticky_button",
                        },
                        {
                            widget = wibox.widget.imagebox,
                            image = beautiful.titlebar_ontop_button_focus_inactive,
                            id = "ontop_button"
                        },
                        widget = wibox.layout.fixed.horizontal,
                    },
                    layout = wibox.layout.align.horizontal,
                },
                left = 5,
                right = 3,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
        update_function = function(w, buttons, label, data, objects, args)
            args = args or {}
            awful.widget.common.list_update(w, {}, label, data, objects, args)
            for i = 1, #w.children do
                local o = objects[i]
                for _, b in ipairs(data[o].primary:get_children_by_id("buttons")) do
                    b:buttons(awful.widget.common.create_buttons(buttons, o))
                end
                bind_tasklist_button(data[o].primary:get_children_by_id("floating_button")[1], o, "floating")
                bind_tasklist_button(data[o].primary:get_children_by_id("sticky_button")[1], o, "sticky")
                bind_tasklist_button(data[o].primary:get_children_by_id("ontop_button")[1], o, "ontop")
            end
        end,
    }
end

return new_takslisk
