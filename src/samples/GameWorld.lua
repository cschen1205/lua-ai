local GameWorld={}

GameWorld.GameAgentAction={}
GameWorld.GameAgentAction.ATTACK=0
GameWorld.GameAgentAction.IDLE=1
GameWorld.GameAgentAction.APPROACH=2
GameWorld.GameAgentAction.WANDER=3
GameWorld.GameAgentAction.ESCAPE=4
GameWorld.GameAgentAction.DIE=5
GameWorld.GameAgentAction.SHOOT=6
GameWorld.GameAgentAction.WALK=7
GameWorld.GameAgentAction.SLUMP=8
GameWorld.GameAgentAction.DEAD=9
GameWorld.GameAgentAction.UNKNOWN=10

GameWorld.GameAgentTargetChoice={}
GameWorld.GameAgentTargetChoice.DEFAULT_ENEMY=0
GameWorld.GameAgentTargetChoice.CLOSEST_ENEMY=1
GameWorld.GameAgentTargetChoice.RANDOM_ENEMY=2
GameWorld.GameAgentTargetChoice.STRONGEST_ENEMY=3
GameWorld.GameAgentTargetChoice.WEAKEST_ENEMY=4
GameWorld.GameAgentTargetChoice.ATTACKER_ENEMY=5
GameWorld.GameAgentTargetChoice.UNKOWN=6

function GameWorld.initializeAgent(agent, aiScriptPath)
	local scriptId=agent:getScriptId()
	if GameWorld[scriptId] == nil then
		GameWorld[scriptId]=require(aiScriptPath)
	end
	GameWorld[scriptId].initialize(agent)
end

function GameWorld.processAgent(agent)
	local scriptId=agent:getScriptId()
	GameWorld[scriptId].think(agent)
end

function GameWorld.trainAgent(agent)
	local scriptId=agent:getScriptId()
	GameWorld[scriptId].train(agent)
end

function GameWorld.uploadAgentConfig(agent)
	local scriptId=agent:getScriptId()
	GameWorld[scriptId].uploadConfig(agent)
end

return GameWorld





