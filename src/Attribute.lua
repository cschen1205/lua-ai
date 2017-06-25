local Attribute={}
Attribute.__index=Attribute

function Attribute.create(name)
	local attr={}
	setmetatable(attr,Attribute)  -- make GameAgent handle lookup
	attr.values=nil
	attr.name=name
	
	return attr
end

function Attribute:getName()
	return self.name
end

function Attribute:getValueCount()
	if self.values == nil then
		return 0
	else
		return (# self.values)
	end
end

function Attribute:getValue(index)
	return self.values[index]
end

function Attribute:addValue(val)
	if self.values== nil then
		self.values={}
		self.values[1]=val
	else
		local indx=(# self.values) + 1
		self.values[indx]=val
	end
end

function Attribute:toString()
	local msg="name: " .. self:getName() .. "\n"
	for i=1, (# self.values) do
		local val=self.values[i]
		if val== true then
			msg = msg .. "value #" .. i .. ": true\n"
		elseif val==false then
			msg = msg .. "value #" .. i .. ": false\n"
		else
			msg = msg .. "value #" .. i .. ": " .. val
		end
	end
	return msg
end

return Attribute
