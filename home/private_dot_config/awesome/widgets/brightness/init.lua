-------------------------------------------------
-- Brightness Widget for Awesome Window Manager
-- Shows the brightness level of the laptop display
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/brightness-widget

-- @author Pavel Makhov
-- @copyright 2021 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local gfs = require("gears.filesystem")
local naughty = require("naughty")
local beautiful = require("beautiful")

local ICON_DIR = gfs.get_configuration_dir() .. "widgets/brightness/"
local get_brightness_cmd
local set_brightness_cmd
local inc_brightness_cmd
local dec_brightness_cmd
local brightness = {}

local function show_warning(message)
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Brightness Widget",
		text = message,
	})
end

local function worker(user_args)
	  local args = user_args or {}

    local type = args.type or 'arc' -- arc or icon_and_text
    local path_to_icon = args.path_to_icon or ICON_DIR .. 'brightness.svg'
    local font = args.font or beautiful.font
    local timeout = args.timeout or 100

    local program = args.program or 'xbacklight'
    local step = args.step or 5
    local base = args.base or 20
    local current_level = 0 -- current brightness value
    local tooltip = args.tooltip or false
    local percentage = args.percentage or false
    if program == 'light' then
        get_brightness_cmd = 'light -G'
        set_brightness_cmd = 'light -S %d' -- <level>
        inc_brightness_cmd = 'light -A '
        dec_brightness_cmd = 'light -U '
    elseif program == 'xbacklight' then
        get_brightness_cmd = 'xbacklight -get'
        set_brightness_cmd = 'xbacklight -set %d' -- <level>
        inc_brightness_cmd = 'xbacklight -inc '
        dec_brightness_cmd = 'xbacklight -dec '
    elseif program == 'brightnessctl' then
        get_brightness_cmd = "brightnessctl get"
        set_brightness_cmd = "brightnessctl set %d%%" -- <level>
        inc_brightness_cmd = "brightnessctl set +" .. step .. "%"
        dec_brightness_cmd = "brightnessctl set " .. step .. "-%"
    else
        show_warning(program .. " command is not supported by the widget")
        return
    end

    if type == 'icon_and_text' then
        brightness.widget = wibox.widget {
            {
                {
                    image = path_to_icon,
                    resize = false,
                    widget = wibox.widget.imagebox,
                },
                valign = 'center',
                layout = wibox.container.place
            },
            {
                id = 'txt',
                font = font,
                widget = wibox.widget.textbox
            },
            spacing = 4,
            layout = wibox.layout.fixed.horizontal,
            set_value = function(self, level)
                local display_level = level
                if percentage then
                    display_level = display_level .. '%'
                end
                self:get_children_by_id('txt')[1]:set_text(display_level)
            end
        }
    elseif type == 'arc' then
        brightness.widget = wibox.widget {
            {
                {
                    image = path_to_icon,
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                valign = 'center',
                layout = wibox.container.place
            },
            max_value = 100,
            thickness = 2,
            start_angle = 4.71238898, -- 2pi*3/4
            forced_height = 18,
            forced_width = 18,
            paddings = 1,
            widget = wibox.container.arcchart,
            set_value = function(self, level)
                self:set_value(level)
            end
        }
    else
        show_warning(type .. " type is not supported by the widget")
        return

    end

    local update_widget = function(widget, stdout, _, _, _)
        local brightness_level = tonumber(string.format("%.0f", stdout))
        current_level = brightness_level
        widget:set_value(brightness_level)
    end

    function brightness:set(value)
        current_level = value
        spawn.easy_async(string.format(set_brightness_cmd, value), function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness.widget, out)
            end)
        end)
    end
    local old_level = 0
    function brightness:toggle()
        if old_level < 0.1 then
            -- avoid toggling between '0' and 'almost 0'
            old_level = 1
        end
        if current_level < 0.1 then
            -- restore previous level
            current_level = old_level
        else
            -- save current brightness for later
            old_level = current_level
            current_level = 0
        end
        brightness:set(current_level)
    end

    function brightness:inc(s)
		if not s then s = step end
        spawn.easy_async(inc_brightness_cmd .. s, function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness.widget, out)
            end)
        end)
    end
    function brightness:dec(s)
		if not s then s = step end
        spawn.easy_async(dec_brightness_cmd .. s, function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness.widget, out)
            end)
        end)
    end

    brightness.widget:buttons(
		awful.util.table.join(
			awful.button({}, 1, function() brightness:set(base) end),
			-- awful.button({}, 3, function() brightness_widget:toggle() end),
			awful.button({ "Shift" }, 4, function() brightness:inc(5) end),
			awful.button({ "Shift" }, 5, function() brightness:dec(5) end),
			awful.button({}, 4, function() brightness:inc() end),
			awful.button({}, 5, function() brightness:dec() end)
		)
	)

    watch(get_brightness_cmd, timeout, update_widget, brightness.widget)

    if tooltip then
        awful.tooltip {
            objects        = { brightness.widget },
            timer_function = function()
                return current_level .. " %"
            end,
        }
    end

    return brightness.widget
end

return setmetatable(brightness, {
	__call = function(_, ...)
		return worker(...)
	end,
})
