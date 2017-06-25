local Record={}
Record.__index=Record

function Record.create()
	local rec={}
	setmetatable(rec,Record)  -- make GameAgent handle lookup
	
	rec.attributes={}
	return rec
end

function Record:setAttribute(attrName, attrValue)
	self.attributes[attrName]=attrValue
end

function Record:getAttributeCount()
	return (# self.attributes)
end

function Record:getAttributeValue(attrName)
	return self.attributes[attrName]
end

function Record:toString()
	local msg=""
	local attrCount=self:getAttributeCount()
	for attrName, attrValue in next, self.attributes, nil do
		if attrValue==true then
			msg = msg .. attrName .. ": true"
		elseif attrValue==false then
			msg = msg .. attrName .. ": false"
		else
			msg = msg .. attrName .. ": " .. attrValue
		end
		msg = msg .. "\n"
	end
	return msg
end


return Record