local Bot={}
Bot.classifier=nil
Bot.records=nil
Bot.classAttribute=nil

local GameWorld = require("samples.GameWorld")

function Bot.initialize(agent)
	if Bot.classifier == nil then
		Bot.classifier=Bot.createNaiveBayseClassifier(agent:getScriptClassPath())
	end
	
	agent:setWalkSpeed(40)
	agent:setSenseRange(250)
	agent:setLife(300)
	
	local agentId=agent:getAgentId()
	
	Bot[agentId]={}
	Bot[agentId].brain=Bot.classifier
end

function Bot.createNaiveBayseClassifier(scriptClassPath)	
	local nbcFactory=require("NaiveBayesClassifier")
	local brain=nbcFactory.create()
	
	local attributeFactory=require("Attribute")
	Bot.classAttribute=attributeFactory.create("my action")
	Bot.classAttribute:addValue(GameWorld.GameAgentAction.ATTACK)
	Bot.classAttribute:addValue(GameWorld.GameAgentAction.IDLE)
	Bot.classAttribute:addValue(GameWorld.GameAgentAction.APPROACH)
	Bot.classAttribute:addValue(GameWorld.GameAgentAction.WANDER)
	Bot.classAttribute:addValue(GameWorld.GameAgentAction.ESCAPE)
	
	local data = require("samples.data")
	
	--build records
	Bot.records={}
	for recordIndex=1, (# data) do
		Bot.records[recordIndex]=Bot.createRecord(scriptClassPath, data[recordIndex]) -- check inside this function
	end
		
	return brain
end

function Bot.train(agent)	
	alert("Naive Bayse Classifier does not require training", "Training Not Required")
end

function Bot.createRecord(scriptClassPath, entity)
	local recordFactory=require("Record")
	local record=recordFactory.create()
	
	record:setAttribute("my action", entity:getCurrentAction())
	
	if entity:getSightedAttackerCount() >= 1 then
		record:setAttribute("I am under attack", true)
	else
		record:setAttribute("I am under attack", false)
	end
	
	if entity:getSightedTargetCount() >= 1 then
		record:setAttribute("I see enemy", true)
	else
		record:setAttribute("I see enemy", false)
	end
	
	if entity:getSightedAllyCount() >= 1 then
		record:setAttribute("I see ally", true)
	else
		record:setAttribute("I see ally", false)
	end
	
	if entity:getLife() >= 50 then
		record:setAttribute("my health", "good")
	elseif entity:getLife() >= 30 then
		record:setAttribute("my health", "medium")
	else
		record:setAttribute("my health", "bad")
	end
	
	if entity:getSenseRange() >= 100 then
		record:setAttribute("my eye sight", "good")
	else
		record:setAttribute("my eye sight", "bad")
	end
	
	if entity:getGun():getBulletCount() >= 1 then
		record:setAttribute("my weapon is loaded", true)
	else
		record:setAttribute("my weapon is loaded", false)
	end
	
	if entity:getGun():getWeaponChargingRate() > 10 then
		record:setAttribute("I can fast load weapon", true)
	else 
		record:setAttribute("I can fast load weapon", false)
	end
	
	local currentTarget=entity:getCurrentTarget()
	if currentTarget == nil then
		record:setAttribute("my target enemy's health", "NA")
		record:setAttribute("my target enemy's eye sight", "NA")
		record:setAttribute("my target enemy's action", "NA")
		record:setAttribute("my target enemy is attacking me", "NA")
		record:setAttribute("my target enemy's weapon is loaded", "NA")
		record:setAttribute("my target enemy can fast load weapon", "NA")
	else
		if currentTarget:getLife() > 50 then
			record:setAttribute("my target enemy's health", "good")
		elseif currentTarget:getLife() > 30 then
			record:setAttribute("my target enemy's health", "medium")
		else
			record:setAttribute("my target enemy's health", "bad")
		end
		
		if currentTarget:getSenseRange() > 100 then
			record:setAttribute("my target enemy's eye sight", "good")
		else
			record:setAttribute("my target enemy's eye sight", "bad")
		end
		
		record:setAttribute("my target enemy's action", currentTarget:getCurrentAction())
		
		record:setAttribute("my target enemy is attacking me", currentTarget:isAttacking(entity))
		
		if currentTarget:getGun():getBulletCount() >=1 then
			record:setAttribute("my target enemy's weapon is loaded", true)
		else
			record:setAttribute("my target enemy's weapon is loaded", false)
		end
		
		if currentTarget:getGun():getWeaponChargingRate() > 10 then
			record:setAttribute("my target enemy can fast load weapon", true)
		else
			record:setAttribute("my target enemy can fast load weapon", false)
		end
	end
	
	return record
end

function Bot.think(agent)
	local agentId=agent:getAgentId()
	local brain=Bot[agentId].brain
	--apply inputs to the neural network
	local record=Bot.createRecord(agent:getScriptClassPath(), agent)
	
	local action=brain:predict(record, Bot.records, Bot.classAttribute)
	
	if action==GameWorld.GameAgentAction.ATTACK then
		agent:attack()
	elseif action==GameWorld.GameAgentAction.APPROACH then
		agent:approach()
	elseif action==GameWorld.GameAgentAction.ESCAPE then
		agent:escape()
	elseif action==GameWorld.GameAgentAction.WANDER then
		agent:wander()
	elseif action==GameWorld.GameAgentAction.IDLE then
		agent:idle()
	end
end

return Bot
