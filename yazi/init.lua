function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	local dir = self._file.cha.is_dir

	if dir then
		return string.format("%s", " ")
	end

	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%R %d/%m", time)
	else
		time = os.date("%D", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end


require("folder-rules"):setup()
-- require("full-border"):setup()
