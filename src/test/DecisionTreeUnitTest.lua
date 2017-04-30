dofile("GameUtil.lua");
dofile("GameWorld.lua");
GameAgentFactory=dofile("GameAgent.lua");

--train to obtain Saved.lua file;
local agent=GameAgentFactory.create("UserBot");
initializeAgent(agent, agent:getScriptClassPath() .. "/DecisionTreeBot.lua");
trainAgent(agent);

--test accuracy of the training
local records=dofile("data.lua");

local accuracy=0;
for recordIndex = 1, (# records) do
	agent:setTargetAttackable(records[recordIndex]:isTargetAttackable());
	agent:setSightedAttackerCount(records[recordIndex]:getSightedAttackerCount());
	agent:setTargetRelativeDistance(records[recordIndex]:getTargetRelativeDistance());
	agent:setTargetRelativeLife(records[recordIndex]:getTargetRelativeLife());
	agent:getGun():setBulletCount(records[recordIndex]:getGun():getBulletCount());
	agent:setLife(records[recordIndex]:getLife());
	agent:setScore(records[recordIndex]:getScore());
	
	processAgent(agent);
	print2Console("recorded: " .. records[recordIndex]:getCurrentAction() .. "\tpredicted: " .. agent:getCurrentAction());
	if records[recordIndex]:getCurrentAction() == agent:getCurrentAction() then
		accuracy=accuracy + 1;
	end
end

accuracy=accuracy * 100 / (# records);

print2Console("accuracy: " .. accuracy .. "%");

