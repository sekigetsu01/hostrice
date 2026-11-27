--- @since 26.5.6
-- c a a: archive the selected files (or the hovered one) under a name you type;
-- c a p: the same with a password (a .zip). The extension picks the type: .zip (the default), .7z or a tar one.

local TAR = { tar = true, tgz = true, tbz = true, tbz2 = true, txz = true, tzst = true }

local targets = ya.sync(function()
	local groups, names = {}, {}
	local function add(file)
		local dir, name = tostring(file.url.parent), tostring(file.name)
		groups[dir] = groups[dir] or {}
		table.insert(groups[dir], name)
		names[#names + 1] = name
	end
	for _, file in pairs(cx.active.selected) do
		add(file)
	end
	if #names == 0 and cx.active.current.hovered then add(cx.active.current.hovered) end
	return groups, names, tostring(cx.active.current.cwd)
end)

local function notify(content, level)
	ya.notify { title = "Archive", content = content, timeout = 5, level = level }
end

local function ask(title, value, obscure)
	local s, event = ya.input { title = title, value = value, obscure = obscure, pos = { "top-center", y = 3, w = 40 } }
	if event == 1 then return s end
end

-- input: written to its stdin (the password: not on the command line, where other programs could read it)
local function run(cmd, input)
	cmd = cmd:stdout(Command.NULL):stderr(Command.PIPED)
	local out, err
	if input then
		local child
		child, err = cmd:stdin(Command.PIPED):spawn()
		if not child then return tostring(err) end
		child:write_all(input)
		child:flush()
		out, err = child:wait_with_output()
	else
		out, err = cmd:output()
	end
	if not out then return tostring(err) end
	if not out.status.success then return out.stderr:gsub("^Enter passphrase:%s*", ""):match("[^\n]+") or "failed" end
end

return {
	entry = function(_, job)
		ya.emit("escape", { visual = true })
		local groups, names, cwd = targets()
		if #names == 0 then return end

		local name = ask("Create archive:", (#names == 1 and names[1] or Url(cwd).name) .. ".zip")
		name = name and name:match("^%s*(.-)%s*$")
		if not name or name == "" then return end
		if name:find("/") then return notify("A name can't contain /", "error") end
		if not name:match("%.%w+$") then name = name .. ".zip" end
		local lower = name:lower()
		local ext = lower:match("%.(%w+)$")
		local kind = (ext == "zip" or ext == "7z") and ext or ((TAR[ext] or lower:match("%.tar%.%w+$")) and "tar")
		if not kind then return notify("Not an archive type: " .. name, "error") end

		local password
		if job.args[1] == "-p" then
			if kind ~= "zip" then return notify("Only a .zip can have a password", "error") end
			password = ask("Password:", nil, true)
			if not password or password == "" then return end
		end

		local tmp = fs.unique("dir", Url(cwd):join(Url(".archive-tmp")))
		local ok, err = fs.create("dir_all", tmp)
		if not ok then return notify(tostring(err), "error") end
		local out = tostring(tmp:join(Url(name)))

		if kind == "tar" then
			local args = { "-caf", out }
			for dir, list in pairs(groups) do
				args[#args + 1] = "-C"
				args[#args + 1] = dir
				for _, n in ipairs(list) do
					args[#args + 1] = n:sub(1, 1) == "-" and "./" .. n or n
				end
			end
			err = run(Command("tar"):arg(args):cwd(cwd))
		else
			-- (with a password, bsdtar in a session of its own, with no terminal to ask on, reads it from stdin)
			local args = password and { "-w", "bsdtar", "--format", "zip", "--options", "zip:encryption=aes256", "-cf", out }
				or { "-acf", out }
			for dir, list in pairs(groups) do
				args[#args + 1] = "-C"
				args[#args + 1] = dir
				for _, n in ipairs(list) do
					args[#args + 1] = n:sub(1, 1) == "-" and "./" .. n or n
				end
			end
			err = run(Command(password and "setsid" or "bsdtar"):arg(args):cwd(cwd), password and password .. "\n")
		end

		if not err then
			local final = fs.unique("file", Url(cwd):join(Url(name)))
			ok, err = fs.rename(Url(out), final)
			err = not ok and tostring(err) or nil
			name = final.name
		end
		fs.remove("dir_all", tmp)
		if err then
			notify("Couldn't make " .. name .. ": " .. err, "error")
		else
			notify("Made " .. name)
		end
	end,
}
