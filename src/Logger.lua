local LogFile={}
LogFile.__index = LogFile
LogFile.handle = nil

function LogFile.create(_filename)
	LogFile.filename=_filename
end

function LogFile.println(line)
	if LogFile.handle == nil then
		LogFile.handle=io.open(LogFile.filename, "w")
	end
	LogFile.handle:write(line .. "\n")
end

function LogFile.print(line)
	LogFile.handle:write(line)
end

function LogFile.close()
	LogFile.handle:close()
end

return LogFile