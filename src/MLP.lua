local MLP={}
MLP.__index=MLP

function MLP.create(_learningRate)
	local nn = {}             -- our new object
	setmetatable(nn, MLP)  -- make MLP handle lookup
	
	nn.saved={}
	nn.transfer_option=0
	nn.learningRate=_learningRate
	nn.layerCount=0
	nn.momentum=0 --beta: momentum constant between 0 and 1, typically 0.95, in special case, beta=0 and we have the delta rule otherwise it is called generalized delta rule
	nn.network={}

	return nn
end

function MLP:setMomentum(m)
	self.momentum=m
end

function MLP:transfer(x)
	if self.transfer_option == 0 then
		return self:func_sigmoid(x)
	elseif self.transfer_option == 1 then
		return self:func_linear(x)
	else
		return self:func_sigmoid(x)
	end
end

function MLP:func_sigmoid(x)
	return 1/(math.exp(-x)+1)
end

function MLP:func_linear(x)
	return x
end

function MLP:derivative_sigmoid(y)
	return (1-y)*y
end

function MLP:addLayer(_neuronCount)
	local layerIndex=self.layerCount+1
	self.network[layerIndex]={}
	
	self.network[layerIndex].neuronCount=_neuronCount
	
	local bound=2.4 / self.network[1].neuronCount
	for i=1, self.network[layerIndex].neuronCount do
		self.network[layerIndex][i]={}
		self.network[layerIndex][i].bias=math.random() * bound * 2 - bound
		self.network[layerIndex][i].val=0
		if layerIndex > 1 then
			for j=1, self.network[layerIndex-1].neuronCount do
				self.network[layerIndex][i][j]={}
				self.network[layerIndex][i][j].weight=math.random()*bound * 2 - bound
				self.network[layerIndex][i][j].deltaWeight=0
				self.network[layerIndex][i][j].deltaWeightPrev = self.network[layerIndex][i][j].deltaWeight
			end
		end
	end
	
	self.layerCount=layerIndex
end

function MLP:forwardProp(_inputs)
	local inputLayerIndex=1
	local firstHiddenLayerIndex=inputLayerIndex+1
	local outputLayerIndex=self.layerCount
	
	for i=1, self.network[inputLayerIndex].neuronCount do
		self.network[inputLayerIndex][i].val=_inputs[i]
	end
	
	for layerIndex=firstHiddenLayerIndex, outputLayerIndex do
		for i=1, self.network[layerIndex].neuronCount do
			local sum=-self.network[layerIndex][i].bias
			for j=1, self.network[layerIndex-1].neuronCount do
				sum=sum+self.network[layerIndex-1][j].val * self.network[layerIndex][i][j].weight
			end
			self.network[layerIndex][i].val=self:transfer(sum)
		end
	end
	
	local outputs={}
	for i=1, self.network[outputLayerIndex].neuronCount do
		outputs[i]=self.network[outputLayerIndex][i].val
	end
	
	return outputs
end

function MLP:backwardProp(_desired_outputs)
	local outputLayerIndex=self.layerCount
	local inputLayerIndex=1
	local firstHiddenLayerIndex=inputLayerIndex+1
	local lastHiddenLayerIndex=outputLayerIndex-1
	
	for i=1, self.network[outputLayerIndex].neuronCount do
		local u=self.network[outputLayerIndex][i].val
		self.network[outputLayerIndex][i].delta=(_desired_outputs[i] - u) * self:derivative_sigmoid(u)
	end
	
	for i=lastHiddenLayerIndex, inputLayerIndex, -1 do
		for j=1, self.network[i].neuronCount do
			local deltaij = 0
			for k = 1, self.network[i+1].neuronCount do
				deltaij = deltaij + self.network[i+1][k][j].weight * self.network[i+1][k].delta
			end
			local u=self.network[i][j].val
			self.network[i][j].delta = self:derivative_sigmoid(u) * deltaij
		end
	end
	
	for i = firstHiddenLayerIndex, outputLayerIndex do
		for j = 1, self.network[i].neuronCount do
			self.network[i][j].bias = self.network[i][j].bias + self.network[i][j].delta * self.learningRate
			for k = 1, self.network[i-1].neuronCount do
				self.network[i][j][k].deltaWeightPrev = self.network[i][j][k].deltaWeight
				self.network[i][j][k].deltaWeight = self.learningRate * self.network[i][j].delta * self.network[i-1][k].val
				self.network[i][j][k].deltaWeight = self.network[i][j][k].deltaWeight + self.momentum * self.network[i][j][k].deltaWeightPrev
				self.network[i][j][k].weight = self.network[i][j][k].weight + self.network[i][j][k].deltaWeight
			end
		end
	end
end

function MLP:getMSE(_desired_outputs)
	local outputLayerIndex=self.layerCount
	local outputNeuronCount=self.network[outputLayerIndex].neuronCount
	local sum=0
	for i = 1, outputNeuronCount do
		local err=self.network[outputLayerIndex][i].val - _desired_outputs[i]
		sum = sum + err * err
	end
	return sum / outputNeuronCount
end

function MLP:getRMSE(_desired_outputs)
	local outputLayerIndex=self.layerCount
	local outputNeuronCount=self.network[outputLayerIndex].neuronCount
	local sum=0
	for i = 1, outputNeuronCount do
		local err=self.network[outputLayerIndex][i].val - _desired_outputs[i]
		sum = sum + err * err
	end
	return math.sqrt(sum / outputNeuronCount)
end

function MLP:getLayerCount()
	return self.layerCount
end

function MLP:save(fileName)
	local logger = require("Logger")
	
	logger.create(fileName)
	logger.println("local MLP={}")
	
	local inputLayerIndex=1
	local firstHiddenLayerIndex=inputLayerIndex+1
	local outputLayerIndex=self.layerCount
	
	logger.println("MLP.layerCount=" .. self.layerCount .. "")
	logger.println("MLP.network={}")
	
	for layerIndex=inputLayerIndex, outputLayerIndex do
		logger.println("MLP.network[" .. layerIndex .. "]={}")
		logger.println("MLP.network[" .. layerIndex .. "].neuronCount=" .. self.network[layerIndex].neuronCount .. "")
	end
	
	for layerIndex=firstHiddenLayerIndex, outputLayerIndex do
		for i=1, self.network[layerIndex].neuronCount do
			logger.println("MLP.network[" .. layerIndex .. "][" .. i .. "]={}")
			logger.println("MLP.network[" .. layerIndex .. "][" .. i .. "].bias=" .. self.network[layerIndex][i].bias .. "")
			for j=1, self.network[layerIndex-1].neuronCount do
				logger.println("MLP.network[" .. layerIndex .. "][" .. i .. "][" .. j .. "]=" .. self.network[layerIndex][i][j].weight)
			end
		end
	end
	
	logger.println("return MLP")
	logger.close()
end

function MLP:load(fileName)
	local savedMLP=dofile(fileName)
	
	if self.layerCount ~= savedMLP.layerCount then
		print2Console("Load Failed: layerCount does not match")
		return false
	end 
	
	local inputLayerIndex=1
	local firstHiddenLayerIndex=inputLayerIndex+1
	local outputLayerIndex=self.layerCount
	
	for layerIndex=inputLayerIndex, outputLayerIndex do
		if self.network[layerIndex].neuronCount ~= savedMLP.network[layerIndex].neuronCount then
			print2Console("Load Failed: neuronCount does not match")
			return false
		end
	end
	
	for layerIndex=firstHiddenLayerIndex, outputLayerIndex do
		for i=1, self.network[layerIndex].neuronCount do
			self.network[layerIndex][i].bias=savedMLP.network[layerIndex][i].bias
			for j=1, self.network[layerIndex-1].neuronCount do
				self.network[layerIndex][i][j].weight=savedMLP.network[layerIndex][i][j]
			end
		end
	end
	
	return true
end

function MLP:saveWeights()
	local inputLayerIndex=1
	local firstHiddenLayerIndex=inputLayerIndex+1
	local outputLayerIndex=self.layerCount
	
	self.saved={}
	for layerIndex=firstHiddenLayerIndex, outputLayerIndex do
		self.saved[layerIndex]={}
		for i=1, self.network[layerIndex].neuronCount do
			self.saved[layerIndex][i]={}
			self.saved[layerIndex][i].bias=self.network[layerIndex][i].bias
			for j=1, self.network[layerIndex-1].neuronCount do
				self.saved[layerIndex][i][j]=self.network[layerIndex][i][j].weight
			end
		end
	end
end

function MLP:loadWeights()
	local inputLayerIndex=1
	local firstHiddenLayerIndex=inputLayerIndex+1
	local outputLayerIndex=self.layerCount
	
	for layerIndex=firstHiddenLayerIndex, outputLayerIndex do
		for i=1, self.network[layerIndex].neuronCount do
			self.network[layerIndex][i].bias=self.saved[layerIndex][i].bias
			for j=1, self.network[layerIndex-1].neuronCount do
				self.network[layerIndex][i][j].weight = self.saved[layerIndex][i][j]
			end
		end
	end
end

function MLP:randomizeWeights()
	local inputLayerIndex=1
	local firstHiddenLayerIndex=inputLayerIndex+1
	local outputLayerIndex=self.layerCount
	
	local bound=2.4 / self.network[1].neuronCount
	for layerIndex=firstHiddenLayerIndex, outputLayerIndex do
		for i=1, self.network[layerIndex].neuronCount do
			self.network[layerIndex][i].bias=math.random() * 2 * bound - bound
			for j=1, self.network[layerIndex-1].neuronCount do
				self.network[layerIndex][i][j].weight = math.random() * 2 * bound - bound
			end
		end
	end
end

return MLP







