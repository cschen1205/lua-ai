local Bot={}

local GameWorld = require("samples.GameWorld")
local GameUtil = require("samples.GameUtil")

Bot.actions={}
Bot.actions[GameWorld.GameAgentAction.ATTACK]=1
Bot.actions[GameWorld.GameAgentAction.IDLE]=2
Bot.actions[GameWorld.GameAgentAction.APPROACH]=3
Bot.actions[GameWorld.GameAgentAction.WANDER]=4
Bot.actions[GameWorld.GameAgentAction.ESCAPE]=5

Bot.err_threshold=0.1
Bot.max_epoches=200
Bot.stagnation_epoches=10
Bot.training_error=100000
Bot.min_improvement=0.1

function Bot.initialize(agent)
	--agent:addEnemy("PreyBot")
	--agent:addEnemy("PredatorBot")
	agent:setWalkSpeed(40)
	agent:setSenseRange(250)
	agent:setLife(300)
	
	local agentId=agent:getAgentId()
	
	Bot[agentId]={}
	Bot[agentId].brain=Bot.createMLP(agent:getScriptClassPath())
end

function Bot.createMLP(scriptClassPath)
	local brain={}
	
	local MLPFactory=require("MLP")
	local brain=MLPFactory.create(0.3)
	brain:addLayer(4) --input layer --Xianshun: I change it to 4...

	brain:addLayer(8) --hidden layer

	brain:addLayer(5) --output layer

	if GameUtil.fileExists("/tmp/decision-tree-saved.lua") then
		brain:load("/tmp/decision-tree-saved.lua")
	end
	
	return brain
end

function Bot.getInput(entity)
	local inputs={}
	
	inputs[1]=entity:isTargetAttackable()
	inputs[2]=entity:getSightedAttackerCount()
	inputs[3]=entity:getTargetRelativeDistance()
	inputs[4]=entity:getTargetRelativeLife()
	--inputs[5]=entity:getGun():getBulletCount()
	--inputs[6]=entity:getLife()
	--inputs[7]=entity:getScore()
	--Xianshun: I intentionally remove the last 3 input variables...
	
	return inputs
end

function Bot.getOutput(entity)
	local outputs={}
	
	outputs[1]=0
	outputs[2]=0
	outputs[3]=0
	outputs[4]=0
	outputs[5]=0
	
	outputs[entity:getCurrentAction()+1]=1
	
	-- since the value for current action is given by
	-- GameWorld.GameAgentAction.ATTACK=0
	-- GameWorld.GameAgentAction.IDLE=1
	-- GameWorld.GameAgentAction.APPROACH=2
	-- GameWorld.GameAgentAction.WANDER=3
	-- GameWorld.GameAgentAction.ESCAPE=4
		
	return outputs
end

function Bot.train(agent)
	local agentId=agent:getAgentId()
	local records=require("samples.data")
	
	local brain=Bot[agentId].brain
	local err=0
	
	GameUtil.showConsole(true)
	
	local minError=10000000000
	local stagnationCount=0
	for epoch = 1, Bot.max_epoches do
		err=0
		for recordIndex = 1, (# records) do
			local inputs=Bot.getInput(records[recordIndex])
			local outputs=Bot.getOutput(records[recordIndex])
		
			brain:forwardProp(inputs)
			brain:backwardProp(outputs)
			err=err + brain:getMSE(outputs)
		end
		GameUtil.print2Console("> epoch: " .. epoch .. " error: " .. err)
		GameUtil.repaint()
		if minError > err then
			minError = err
			brain:saveWeights()
		else
			stagnationCount=stagnationCount + 1
		end
		
		if stagnationCount > Bot.stagnation_epoches then
			brain:randomizeWeights()
			stagnationCount=0
		end
	end
	
	brain:loadWeights()
	
	GameUtil.showConsole(false)
	brain:save("/tmp/decision-tree-saved.lua")
	
	Bot.training_error=err
	GameUtil.alert("Training Completed with errors " .. err, "Training Completed")
end

function Bot.think(agent)
	local agentId=agent:getAgentId()
	local brain=Bot[agentId].brain
	--apply inputs to the neural network
	
	local inputs=Bot.getInput(agent)
	
	--compute outputs using neural network
	local outputs=brain:forwardProp(inputs)
	
	--convert neural network output into bot action
	local firingIndex=-1
	local firingDegree=-100000
	for i=1, 5 do
		if outputs[i] > firingDegree then
			firingIndex=i
			firingDegree=outputs[i]
		end
	end
	firingIndex=firingIndex-1
	
	if GameWorld.GameAgentAction.ATTACK == firingIndex then
		agent:attack()
	elseif GameWorld.GameAgentAction.APPROACH == firingIndex then
		agent:approach()
	elseif GameWorld.GameAgentAction.ESCAPE == firingIndex then
		agent:escape()
	elseif GameWorld.GameAgentAction.WANDER == firingIndex then
		agent:wander()
	elseif GameWorld.GameAgentAction.IDLE == firingIndex then
		agent:idle()
	end
end

function Bot.uploadConfig(agent)
	local agentId=agent:getAgentId()
	local brain=Bot[agentId].brain
	local hiddenLayers=brain:getLayerCount() - 2
	
	httpAddField("HiddenLayers", "" .. hiddenLayers)
	httpAddField("learningRate", "" .. (brain.learningRate))
	httpAddField("trainingError", "" .. (Bot.training_error))
	if hiddenLayers > 0 then
		for i=1, hiddenLayers do
			httpAddField("neuronCountInHiddenLayer" .. i, "" .. brain.network[i+1].neuronCount)
		end
	end
end

return Bot
