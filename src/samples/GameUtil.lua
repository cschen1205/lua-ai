local GameUtil = {}

function GameUtil.fileExists(fileName)
	local f=io.open(fileName)
	if f==nil then
		return false
	else
		io.close(f)
		return true
	end
end

function GameUtil.alert(title, msg)
	print(title .. ": " .. msg)
end

function GameUtil.print2Console(msg)
	print(msg)
end

function GameUtil.getDefaultScriptPath()
	return "."
end

function GameUtil.showConsole(shown)

end

function GameUtil.print2File(msg)
	print(msg)
end

function GameUtil.repaint()

end

return GameUtil
