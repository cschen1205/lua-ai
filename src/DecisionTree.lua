local DecisionTree={}
DecisionTree.__index=DecisionTree

function DecisionTree.create(scriptPath, _cls)
	local tree={}
	setmetatable(tree, DecisionTree)
	
	tree.scriptPath=scriptPath
	local treeNodeFactory=require("TreeNode")
	tree.root=treeNodeFactory.create(_cls)
	tree.trained=false
	
	return tree
end

function DecisionTree:addAttribute(attr)
	self.root:addAttribute(attr)
end

function DecisionTree:getAttributeCount()
	return self.root:getAttributeCount()
end

function DecisionTree:build(records)
	self.root:build(records)
	self.trained=true
end

function DecisionTree:isTrained()
	return self.trained
end

function DecisionTree:getScriptClassPath()
	return self.scriptPath
end

function DecisionTree:load(fileName)
	--local rootData=dofile(filename)
	--self.root:load(rootData)
end

function DecisionTree:save(filename)
	--local logger=dofile(getDefaultScriptPath() .. "/Logger.lua")
	--logger.create(filename)
	--self.root:save("", filename)
	--logger.close()
end

function DecisionTree:predict(record)
	return self.root:predict(record)
end

function DecisionTree:toString()
	return self.root:toString(1)
end

function DecisionTree:printXML(fileName)
	local logger=require("Logger")
	logger.create(fileName)
	logger.println("<?xml version=\"1.0\"?>")
	self.root:toXML(logger)
	logger.close()
end

function DecisionTree:printPredictionTrace(record, fileName)
	local logger=require("Logger.lua")
	logger.create(fileName)
	logger.println("<?xml version=\"1.0\"?>")
	self.root:printPredictionTrace(record, logger)
	logger.close()
end

return DecisionTree

