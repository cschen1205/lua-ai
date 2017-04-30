GameWorld={};

GameAgentAction={};
GameAgentAction.ATTACK=0;
GameAgentAction.IDLE=1;
GameAgentAction.APPROACH=2;
GameAgentAction.WANDER=3;
GameAgentAction.ESCAPE=4;
GameAgentAction.DIE=5;
GameAgentAction.SHOOT=6;
GameAgentAction.WALK=7;
GameAgentAction.SLUMP=8;
GameAgentAction.DEAD=9;
GameAgentAction.UNKNOWN=10;

GameAgentTargetChoice={};
GameAgentTargetChoice.DEFAULT_ENEMY=0;
GameAgentTargetChoice.CLOSEST_ENEMY=1;
GameAgentTargetChoice.RANDOM_ENEMY=2;
GameAgentTargetChoice.STRONGEST_ENEMY=3;
GameAgentTargetChoice.WEAKEST_ENEMY=4;
GameAgentTargetChoice.ATTACKER_ENEMY=5;
GameAgentTargetChoice.UNKOWN=6;

function initializeAgent(agent, aiScriptPath)
	local scriptId=agent:getScriptId();
	if GameWorld[scriptId] == nil then
		GameWorld[scriptId]=dofile(aiScriptPath);
	end
	GameWorld[scriptId].initialize(agent);
end

function processAgent(agent)
	local scriptId=agent:getScriptId();
	GameWorld[scriptId].think(agent);
end

function trainAgent(agent)
	local scriptId=agent:getScriptId();
	GameWorld[scriptId].train(agent);
end

function uploadAgentConfig(agent)
	local scriptId=agent:getScriptId();
	GameWorld[scriptId].uploadConfig(agent);
end





