local LogFile={};

function LogFile.create(_filename)
	LogFile.filename=_filename;
	LogFile.handle=io.open(LogFile.filename, "w");
end

function LogFile.println(line)
	LogFile.handle:write(line .. "\n");
end

function LogFile.print(line)
	LogFile.handle:write(line);
end

function LogFile.close()
	LogFile.handle:close();
end

return LogFile;