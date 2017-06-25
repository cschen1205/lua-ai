local TreeNode={}
TreeNode.__index=TreeNode

function TreeNode.create(_cls)
	local node={}
	setmetatable(node,TreeNode)  -- make GameAgent handle lookup
	node.children=nil
	node.attributes=nil
	node.classAttribute=_cls -- class of the decision tree
	node.attribute=nil
	node.gain=0
	node.value=nil
	node.recordCount=0
	
	return node
end

function TreeNode:getValue()
	return self.value
end

function TreeNode:setValue(val)
	self.value=val
end

-- child methods
function TreeNode:isLeave()
	return self.children == nil
end

function TreeNode:addChild(child)
	if self.children==nil then
		self.children={}
		self.children[1]=child
	else
		local childIndex=(# self.children) + 1
		self.children[childIndex]=child
	end
end

function TreeNode:getChildCount()
	if self.children== nil then
		return 0
	else
		return (# self.children)
	end
end

function TreeNode:getChild(index)
	return self.children[index]
end

-- attribute methods
function TreeNode:addAttribute(attr)
	if self.attributes==nil then
		self.attributes={}
		self.attributes[1]=attr
		
	else
		local index=(# self.attributes) + 1
		self.attributes[index]=attr
	end
end

function TreeNode:getAttributeCount()
	if self.attributes==nil then
		return 0
	else
		return (# self.attributes)
	end
end

function TreeNode:split(records, attr)
	local split_records={}
	local attrName=attr:getName()
	local attrValueCount=attr:getValueCount()
	local recordCount=(# records)
	
	for j=1, attrValueCount do
		split_records[j]={}
	end
	
	for i=1, recordCount do
		local attrValue=records[i]:getAttributeValue(attrName)
		for j=1, attrValueCount do
			if attrValue == attr:getValue(j) then
				local k=(# split_records[j])+1
				split_records[j][k]=records[i]
			end
		end
	end
	
	return split_records
end

function TreeNode:build(records)
	local attributeCount=(# self.attributes)
	
	self.gain=0
	self.attribute=nil
	self.children=nil
	self.recordCount=(# records)
	
	for i=1, attributeCount do
		local gain=self:calcInformationGain(records, self.attributes[i])
		if self.gain < gain then
			self.gain=gain
			self.attribute=self.attributes[i]
		end
	end
	
	if self.attribute==nil or self:getAttributeCount() == 1 then
		local split_records=self:split(records, self.classAttribute)
		
		for i=1, self.classAttribute:getValueCount() do
			if (# split_records[i]) > 0 then
				local child=TreeNode.create(self.classAttribute)
				child:setValue(self.classAttribute:getValue(i))
				child.recordCount=(# split_records[i])
				self:addChild(child)
			end
		end
	else
		local split_records=self:split(records, self.attribute)
		local attrValueCount=self.attribute:getValueCount()
		for i=1, attrValueCount do
			if (# split_records[i]) > 0 then
				local child=TreeNode.create(self.classAttribute)
				for j=1, (# self.attributes) do
					if self.attributes[j]:getName() ~= self.attribute:getName() then
						child:addAttribute(self.attributes[j])
					end
				end
				child:setValue(self.attribute:getValue(i))
				child:build(split_records[i])
				self:addChild(child)
			end
		end	
	end
	
end

function TreeNode:calcInformationGain(records, attr)
	local recordCount=(# records)
	local attrValueCount=attr:getValueCount()
	local split_records=self:split(records, attr)
	
	local gain=self:calcEntropy(records, self.classAttribute)
	
	for j=1, attrValueCount do
		local groupRecordCount=(# split_records[j])
		if groupRecordCount > 0 then
			gain=gain - groupRecordCount * self:calcEntropy(split_records[j], self.classAttribute) / recordCount
		end
	end
	
	return gain
	
end

function TreeNode:calcEntropy(records, attr)
	local recordCount=(# records)
	local attrName=attr:getName()
	local attrValueCount=attr:getValueCount()
	
	local attrValues={}
	for j=1, attrValueCount do
		attrValues[j]=0
	end
	
	for i=1, recordCount do
		local attrValue=records[i]:getAttributeValue(attrName)
		
		for j=1, attrValueCount do
			if attrValue == attr:getValue(j) then
				attrValues[j]=attrValues[j]+1
			end
		end
	end

	local entropy=0
	for j=1, attrValueCount do
		local prob=1
		if attrValues[j]==0 then
			prob=0.00000000001
		elseif attrValues[j]==recordCount then
			return 0
		else
			prob = attrValues[j] / recordCount
		end
		entropy=entropy + (-prob * math.log(prob) / math.log(2))
	end
	
	return entropy
end

function TreeNode:predict(record)
	if self:isLeave()== true then
		return self:getValue()
	else
		local childCount=self:getChildCount()
		
		if self.children[1]:isLeave() then
			local supportLevel=0
			local classId=nil
			for i=1, childCount do
				if supportLevel < self.children[i].recordCount then
					supportLevel=self.children[i].recordCount
					classId=self.children[i]:getValue()
				end
			end
			return classId
		else
			for i=1, childCount do
				if self.children[i]:getValue() == record:getAttributeValue(self.attribute:getName()) then
					return self.children[i]:predict(record)
				end
			end
		end
	end
end

function TreeNode:toString(level)
	local msg = ""
	for i=1, level do
		msg = msg .. " "
	end
	msg = msg .. "level #" .. level .. "(" .. self.recordCount .. "):"
	if self.value == nil then
		msg = msg .. "[val: nil]"
	elseif self.value == true then
		msg = msg .. "[val: true]"
	elseif self.value == false then
		msg = msg .. "[val: false]"
	else
		msg = msg .. "[val: " .. self.value .. "]"
	end
	
	if self.attribute ~= nil then
		msg = msg .. "(" .. self.attribute:getName() .. ")"
	elseif self:isLeave() then
		msg = msg .. "(isLeave)"
	end
	
	msg = msg .. "\n"
	
	if self.children ~= nil then
		for i = 1, (# self.children) do
			msg = msg .. self.children[i]:toString(level+1)
		end
	end
	
	return msg
end

function TreeNode:toXML(logger)
	
	self:beginXML(logger)
	if self.children ~= nil then
		for i = 1, (# self.children) do
			self.children[i]:toXML(logger)
		end
	end
	self:endXML(logger)
end

function TreeNode:beginXML(logger)
	local val=""
	if self.value == nil then
		val = "nil"
	elseif self.value == true then
		val = "true"
	elseif self.value == false then
		val = "false"
	else
		val = "" .. self.value
	end
	
	local attrName=""
	local isLeave="false"
	if self.attribute ~= nil then
		attrName= self.attribute:getName()
	elseif self:isLeave() then
		attrName=self.classAttribute:getName()
		isLeave="true"
	end
	
	logger.println("<node value=\"" .. val .. "\" attribute=\"" .. attrName .. "\" isLeave=\"" .. isLeave .. "\" record_count=\"" .. self.recordCount .. "\">")
end

function TreeNode:endXML(logger)
	logger.println("</node>")
end

function TreeNode:printPredictionTrace(record, logger)	
	if self:isLeave()== true then
		return
	else
		local childCount=self:getChildCount()
		self:beginXML(logger)
		
		if self.children[1]:isLeave() then
			local supportLevel=0
			local classId=nil
			local bestChildIndex=-1
			for i=1, childCount do
				if supportLevel < self.children[i].recordCount then
					supportLevel=self.children[i].recordCount
					classId=self.children[i]:getValue()
					bestChildIndex=i
				end
			end
			if bestChildIndex ~= -1 then
				self.children[bestChildIndex]:toXML(logger)
			end
		else
			for i=1, childCount do
				if self.children[i]:getValue() == record:getAttributeValue(self.attribute:getName()) then
					self.children[i]:printPredictionTrace(record, logger)
				end
			end
		end
		
		self:endXML(logger)
	end
end

return TreeNode
