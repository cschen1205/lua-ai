dofile("GameUtil.lua");
dofile("GameWorld.lua");
GameAgentFactory=dofile("GameAgent.lua");

--train to obtain Saved.lua file;
local dummy=GameAgentFactory.create("dummy agent");
initializeAgent(dummy, "NBCBot.lua");

--test accuracy of the training
local records=dofile("data.lua");

local accuracy=0;
for recordIndex = 1, (# records) do
	local agent=GameAgentFactory.create(records[recordIndex]:getAgentId() .. "X");
	initializeAgent(agent); --load from Save.lua during initialization
	processAgent(agent);
	print2Console("recorded: " .. records[recordIndex]:getCurrentAction() .. "\tpredicted: " .. agent:getCurrentAction());
	if records[recordIndex]:getCurrentAction() == agent:getCurrentAction() then
		accuracy=accuracy + 1;
	end
end

accuracy = accuracy * 100 / (# records);
print2Console("accuracy: " .. accuracy .. "%");
