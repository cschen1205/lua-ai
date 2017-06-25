local NaiveBayseClassifier={}
NaiveBayseClassifier.__index=NaiveBayseClassifier

function NaiveBayseClassifier.create()
	local nbc={}
	setmetatable(nbc, NaiveBayseClassifier)
	
	return nbc
end

function NaiveBayseClassifier:predict(record, records, classAttribute)
	local predictedValue=nil
	local predictedProb=0
	local classLabel=classAttribute:getName()
	
	for i=1, classAttribute:getValueCount() do
		local classValue=classAttribute:getValue(i)
		
		local CCount=0
		for j=1, (# records) do
			if records[j]:getAttributeValue(classLabel)==classValue then
				CCount=CCount + 1
			end
		end
		local classValueProb=CCount / (# records)
		
		for attrName, attrValue in next, record.attributes, nil do
			if attrName ~= classLabel then
				local fiCount=0
				for j=1, (# records) do
					if records[j]:getAttributeValue(attrName) == attrValue and records[j]:getAttributeValue(classLabel)==classValue then
						fiCount=fiCount+1
					end
				end
				local fiProb=fiCount / CCount
				classValueProb=classValueProb * fiProb
			end
		end
		
		if classValueProb > predictedProb then
			predictedProb = classValueProb
			predictedValue=classValue
		end
	end
	return predictedValue
end

return NaiveBayseClassifier

