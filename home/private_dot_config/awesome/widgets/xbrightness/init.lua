local awful = require("awful")
local naughty = require("naughty")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local brightness = {}

local ICON_DIR = gfs.get_configuration_dir() .. "widgets/xbacklight/"

local function worker(user_args)

	local args = user_args or {}
	local icondir = ICON_DIR
	local icon = icondir .. "brightness.svg"

	-- TODO: for now only support xbacklight! it would work though 
	-- if the command has the same order.
	local cmd = {
		name = args.command or "xbacklight"
	}
	local update_interval = args.interval or 1

	local step = args.step or 5

	brightness.widget = wibox.widget {
		{
			{
				image = icon,
				resize = false,
				widget = wibox.widget.imagebox,
			},
			valign = 'center',
			layout = wibox.container.place
		},
		{
			id = 'txt',
			font = beautiful.font,
			widget = wibox.widget.textbox
		},
		layout = wibox.layout.fixed.horizontal
	}

	function brightness:inc(s)
		if not s then s = step end
		cmd.args = "-inc"
		spawn.easy_async(string.format("%s %s %d", cmd.name,cmd.args, s))
	end

	function brightness:dec(s)
		if not s then s = step end
		cmd.args = "-dec"
		spawn.easy_async(string.format("%s %s %d", cmd.name,cmd.args, s))
	end

	-- local modkey = "Mod4"
	-- brightness.widget:button(
	-- 	awful.util.table.join(
	-- 		awful.button({}, 4, function() brightness:inc() end),
	-- 		awful.button({}, 5, function() brightness:dec() end)
	-- 	)
	-- )

	local update_cb = function(widget, stdout)
		local perc = tonumber(string.format("%.0f", stdout))
		widget:set_brightness(perc)
	end

	-- brightness.icon:set_image(icon)
	watch(cmd.name .. ' ' ..  '-get', update_interval, update_cb)

	return brightness.widget
end

return setmetatable(brightness,{
	__call = function(_, ...)
		return worker(...)
	end
})
