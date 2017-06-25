local Bot={}
Bot.C45=nil

function Bot.initialize(agent)
	if Bot.C45 == nil then
		Bot.C45=Bot.createDecisionTree(agent:getScriptClassPath())
	end
	
	agent:setWalkSpeed(40)
	agent:setSenseRange(250)
	agent:setLife(300)
	
	local agentId=agent:getAgentId()
	
	Bot[agentId]={}
	Bot[agentId].brain=Bot.C45
end

function Bot.createDecisionTree(scriptClassPath)	
	local decisionTreeFactory=require("DecisionTree")
	local attributeFactory=require("Attribute")
	
	local classAttribute=attributeFactory.create("my action")
	classAttribute:addValue(GameAgentAction.ATTACK)
	classAttribute:addValue(GameAgentAction.IDLE)
	classAttribute:addValue(GameAgentAction.APPROACH)
	classAttribute:addValue(GameAgentAction.WANDER)
	classAttribute:addValue(GameAgentAction.ESCAPE)
	
	local brain=decisionTreeFactory.create(scriptClassPath, classAttribute)
	local attribute=attributeFactory.create("is my target attackable")
	attribute:addValue(1)
	attribute:addValue(0)
	brain:addAttribute(attribute)
	
	attribute=attributeFactory.create("am i under attack")
	attribute:addValue("none")
	attribute:addValue("slight")
	attribute:addValue("heavy")
	brain:addAttribute(attribute)
	
	attribute=attributeFactory.create("target distance")
	attribute:addValue("very close")
	attribute:addValue("close")
	attribute:addValue("reachable")
	attribute:addValue("too far")
	brain:addAttribute(attribute)
	
	attribute=attributeFactory.create("is enemy healthy")
	attribute:addValue("far better than me")
	attribute:addValue("better than me")
	attribute:addValue("same as me")
	attribute:addValue("worse than me")
	attribute:addValue("far worse than me")
	brain:addAttribute(attribute)
		
	return brain
end

function Bot.train(agent)	
	local agentId=agent:getAgentId()
	local scriptClassPath=agent:getScriptClassPath()
	local brain=Bot[agentId].brain
	
	if brain:isTrained() then
		alert("C45 has already been trained", "Training Completed")
	else
		local data=dofile("data.lua")
	
		--build C45
		local records={}
		for recordIndex=1, (# data) do
			records[recordIndex]=Bot.createRecord(scriptClassPath, data[recordIndex])
		end
		brain:build(records)
		
		brain:printXML("test-results/decision-tree-saved.xml")
		alert("Training Completed with Saved.xml generated for C45 ", "Training Completed")
	end
end

function Bot.createRecord(scriptClassPath, userbot)
	local recordFactory=require("Record")
	local record=recordFactory.create()
	
	--class attribute
	record:setAttribute("my action", userbot:getCurrentAction())
	
	record:setAttribute("is my target attackable", userbot:isTargetAttackable())
	
	local attackerCount=userbot:getSightedAttackerCount()
	if attackerCount==0 then
		record:setAttribute("am i under attack", "none")
	elseif attackerCount==1 then
		record:setAttribute("am i under attack", "slight")
	else
		record:setAttribute("am i under attack", "heavy")
	end 
	
	local targetRelativeDistance=userbot:getTargetRelativeDistance()
	if targetRelativeDistance < 0.3 then
		record:setAttribute("target distance", "very close")
	elseif targetRelativeDistance < 0.6 then
		record:setAttribute("target distance", "close")
	elseif targetRelativeDistance < 0.999 then
		record:setAttribute("target distance", "reachable")
	else
		record:setAttribute("target distance", "too far")
	end
	
	local targetRelativeLife=userbot:getTargetRelativeLife()
	if targetRelativeLife < 0.5 then
		record:setAttribute("is enemy healthy", "far worse than me")
	elseif targetRelativeLife < 1 then
		record:setAttribute("is enemy healthy", "worse than me")
	elseif targetRelativeLife == 1 then
		record:setAttribute("is enemy healthy", "same as me")
	elseif targetRelativeLife < 2 then
		record:setAttribute("is enemy healthy", "better than me")
	else
		record:setAttribute("is enemy healthy", "far better than me")
	end	
	
	return record
end

function Bot.think(agent)
	local agentId=agent:getAgentId()
	local brain=Bot[agentId].brain
	--apply inputs to the neural network
	local record=Bot.createRecord(agent:getScriptClassPath(), agent)
	
	--compute outputs using neural network
	local action=brain:predict(record)
	--brain:printPredictionTrace(record, agent:getScriptClassPath() .. "/" .. os.date("%H%M%S") .. ".xml")
	
	if action==GameAgentAction.ATTACK then
		agent:attack()
	elseif action==GameAgentAction.APPROACH then
		agent:approach()
	elseif action==GameAgentAction.ESCAPE then
		agent:escape()
	elseif action==GameAgentAction.WANDER then
		agent:wander()
	elseif action==GameAgentAction.IDLE then
		agent:idle()
	end
end

return Bot
