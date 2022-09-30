-- Save History
--
local mp = require 'mp'
local fmt = string.format
local config = require("mp.options")
local histfile = os.getenv("HOME") .. "/.cache/mpvhistory"
local settings =  {
	autostart = false,
	command = { "mpvhist", "-p" }
}

local command = settings.command

os.execute("touch " .. histfile .. " 2>/dev/null")
config.read_options(settings, "savehistory")

local function exec(args)
	if type(args) ~= 'table' then args = { args } end
	local menu = mp.command_native({
		name = "subprocess",
		capture_stdout = true,
		args = args,
	})
	return menu.status, menu.stdout, menu
end

-- TODO: ft: ability to remove current videos if exist in history
local function save()
	local path = mp.get_property("path")
	local title = mp.get_property("media-title")

	-- if path already in histfile don't add it
	for line in io.lines(histfile) do
		if string.find(line, path, 1, true) then
			mp.msg.info("[Exist] " .. path)
			return
		end
	end
	-- save history to seperated with TAB "<title>\t<path>"
	local file = io.open(histfile, 'a+')
	if file then
		-- FIX: Why its always add newline? if i added something like this "%s"
		-- file:write(('"%s"\t"%s'):format(title, path))
		file:write(("%s\t%s\n"):format(title,path))
		mp.msg.info(fmt("[Saved] %s - %s", title,path))
		file:close()
		mp.osd_message("Added to history", 2)
	else
		mp.msg.error("Failed to open history file, check path or permissions")
	end
end

local function show_menu()
	local menu = os.getenv("MENU")
	if not (menu == "rofi" or menu == "dmenu") or (menu == nil) then
		mp.msg.error(fmt("MENU=%s not supported! Please use dmenu or rofi", menu))
		mp.osd_message(fmt("history: MENU=%s not supported", menu), 1)
		return 1
	end

	local es, out, ret = exec(command)
	if (out == nil) or (out == "") then
		if ( es < 0 ) then
			mp.msg.error("mpvhist not found on $PATH")
		else
			mp.osd_message("history: not selected any url", 1)
		end
		return 1
	end
	-- TODO: don't run if path not exist anymore
	mp.commandv("loadfile", out, "replace")
	mp.osd_message("Loaded " .. out, 2)
end

mp.add_key_binding("Alt+H", "savehistory", save)
mp.add_key_binding('Alt+m', 'menuhistory', show_menu)

if settings.autostart then
	mp.register_event('file-loaded', save)
end
