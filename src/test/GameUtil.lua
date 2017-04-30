function fileExists(fileName)
	local f=io.open(fileName);
	if f==nil then
		return false;
	else
		io.close(f);
		return true;
	end
end

function alert(title, msg)
	print(title .. ": " .. msg);
end

function print2Console(msg)
	print(msg);
end

function getDefaultScriptPath()
	return ".";
end

function showConsole(shown)

end

function print2File(msg)
	print(msg);
end

function repaint()

end
