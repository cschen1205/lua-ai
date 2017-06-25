local GameAgent = {}
GameAgent.__index = GameAgent
local GameWorld = require("samples.GameWorld")
local GameUtil = require("samples.GameUtil")

function GameAgent.create(agentId)
   local agnt = {}             -- our new object
   setmetatable(agnt,GameAgent)  -- make GameAgent handle lookup
   agnt.agentId = agentId      -- initialize our object
   agnt.walkSpeed=30
   agnt.senseRange=100
   agnt.life=100
   agnt.scriptId=""
   agnt.sightedAttackerCount=0
   agnt.sightedTargetCount=0
   agnt.sightedAllyCount=0
   agnt.score=0
   agnt.armor=0
   agnt.firingDelay=10
   local GameWeaponFactory=require("samples.GameWeapon")
   agnt.gun=GameWeaponFactory.create()
   
   agnt.currentTarget=nil
   agnt.strongestCandidateTarget=nil
   agnt.weakestCandidateTarget=nil
   agnt.closestCandidateTarget=nil
   agnt.attackerCandidateTarget=nil
   agnt.randomCandidateTarget=nil
   
   agnt.enemyScriptIds=nil
   agnt.rotationSpeed=0
   agnt.currentAction=GameWorld.GameAgentAction.IDLE
   agnt.currentTargetChoice=GameWorld.GameAgentTargetChoice.DEFAULT_ENEMY
   agnt.attackingTarget=nil
   agnt.attackables=nil
   agnt.targetAttackable=0
   agnt.targetRelativeDistance=1
   agnt.targetRelativeLife=0
   
   agnt.targetChoice=nil
   
   return agnt
end

function GameAgent:isTargetAttackable()
	return self.targetAttackable
end

function GameAgent:setTargetAttackable(attackable)
	self.targetAttackable=attackable
end

function GameAgent:getTargetRelativeDistance()
	return self.targetRelativeDistance
end

function GameAgent:setTargetRelativeDistance(distance)
	self.targetRelativeDistance=distance
end

function GameAgent:getTargetRelativeLife()
	return self.targetRelativeLife
end

function GameAgent:setTargetRelativeLife(life)
	self.targetRelativeLife=life
end

function GameAgent:setScore(score)
	self.score=score
end

function GameAgent:getScore()
	return self.score
end

function GameAgent:createCurrentTarget(agentId)
	self.currentTarget=GameAgent.create(agentId)
	return self.currentTarget
end

function GameAgent:createStrongestCandidateTarget(agentId)
	self.strongestCandidateTarget=GameAgent.create(agentId)
	return self.strongestCandidateTarget
end

function GameAgent:createWeakestCandidateTarget(agentId)
	self.weakestCandidateTarget=GameAgent.create(agentId)
	return self.weakestCandidateTarget
end

function GameAgent:createAttackerCandidateTarget(agentId)
	self.attackerCandidateTarget=GameAgent.create(agentId)
	return self.attackerCandidateTarget
end

function GameAgent:createClosestCandidateTarget(agentId)
	self.closestCandidateTarget=GameAgent.create(agentId)
	return self.closestCandidateTarget
end

function GameAgent:createRandomCandidateTarget(agentId)
	self.randomCandidateTarget=GameAgent.create(agentId)
	return self.randomCandidateTarget
end

function GameAgent:getStrongestCandidateTarget()
	return self.strongestCandidateTarget
end

function GameAgent:getWeakestCandidateTarget()
	return self.weakestCandidateTarget
end

function GameAgent:getClosestCandidateTarget()
	return self.closestCandidateTarget
end

function GameAgent:getRandomCandidateTarget()
	return self.randomCandidateTarget
end

function GameAgent:getAttackerCandidateTarget()
	return self.attackerCandidateTarget
end

function GameAgent:getSightedAttackerCount()
	return self.sightedAttackerCount
end

function GameAgent:setSightedAttackerCount(count)
	self.sightedAttackerCount=count
end

function GameAgent:getSightedTargetCount()
	return self.sightedTargetCount
end

function GameAgent:setSightedTargetCount(count)
	self.sightedTargetCount=count
end

function GameAgent:getSightedAllyCount()
	return self.sightedAllyCount
end

function GameAgent:setSightedAllyCount(count)
	self.sightedAllyCount=count
end

function GameAgent:getGun()
	return self.gun
end

function GameAgent:setScriptId(scriptId)
	self.scriptId=scriptId
end

function GameAgent:getScriptId()
	return self.scriptId
end

function GameAgent:setLife(life)
	self.life=life
end

function GameAgent:getLife()
	return self.life
end

function GameAgent:setWalkSpeed(speed)
	self.walkSpeed=speed
end

function GameAgent:getWalkSpeed()
	return self.walkSpeed
end

function GameAgent:setSenseRange(range)
	self.senseRange=range
end

function GameAgent:getSenseRange()
	return self.senseRange
end

function GameAgent:setCurrentTarget(target)
	self.currentTarget=target
end

function GameAgent:getCurrentTarget()
	return self.currentTarget
end

function GameAgent:getAgentId()
	return self.agentId
end

function GameAgent:getScriptClassPath()
	return "../main"
end

function GameAgent:getName()
	return "Game Agent [" .. self.agentId .. "]"
end

function GameAgent:setCurrentAction(action)
	self.currentAction=action
end

function GameAgent:getCurrentAction()
	return self.currentAction
end

function GameAgent:attack()
	self:setCurrentAction(GameWorld.GameAgentAction.ATTACK)
	local targetName="unknown"
	if self:getCurrentTarget() ~= nil then
		targetName=self.currentTarget.getName()
	end
	GameUtil.print2Console(self:getName() .. " attack " .. targetName)
end

function GameAgent:escape()
	self:setCurrentAction(GameWorld.GameAgentAction.ESCAPE)
	local targetName="unknown"
	if self:getCurrentTarget() ~= nil then
		targetName=self.currentTarget.getName()
	end
	GameUtil.print2Console(self:getName() .. " escape from " .. targetName)
end

function GameAgent:idle()
	self:setCurrentAction(GameWorld.GameAgentAction.IDLE)
	GameUtil.print2Console(self:getName() .. " idle")
end

function GameAgent:approach()
	self:setCurrentAction(GameWorld.GameAgentAction.APPROACH)
	local targetName="unknown"
	if self:getCurrentTarget() ~= nil then
		targetName=self.currentTarget.getName()
	end
	GameUtil.print2Console(self:getName() .. " approach " .. targetName)
end

function GameAgent:wander()
	self:setCurrentAction(GameWorld.GameAgentAction.WANDER)
	GameUtil.print2Console(self:getName() .. " wander")
end

function GameAgent:die()
	self:setCurrentAction(GameWorld.GameAgentAction.DIE)
	GameUtil.print2Console(self:getName() .. " die")
end

function GameAgent:walk()
	self:setCurrentAction(GameWorld.GameAgentAction.WALK)
	GameUtil.print2Console(self:getName() .. " walk")
end

function GameAgent:slump()
	self:setCurrentAction(GameWorld.GameAgentAction.SLUMP)
	GameUtil.print2Console(self:getName() .. " slump")
end

function GameAgent:shoot()
	self:setCurrentAction(GameWorld.GameAgentAction.SHOOT)
	GameUtil.print2Console(self:getName() .. " shoot")
end

function GameAgent:addEnemy(enemyScriptId)
	if self.enemyScriptIds == nil then
		self.enemyScriptIds={}
		self.enemyScriptIds[1]=enemyScriptId
	else
		local index=(# self.enemyScriptIds) + 1
		self.enemyScriptIds[index]=enemyScriptId
	end
end
			
function GameAgent:setRotationSpeed(speed)
	self.rotationSpeed=speed
end

function GameAgent:getDistance(agent)
	
end

function GameAgent:targetClosest()
	self:setTargetChoice(GameWorld.GameAgentTargetChoice.CLOSEST_ENEMY)
end

function GameAgent:targetStrongest()
	self:setTargetChoice(GameWorld.GameAgentTargetChoice.STRONGEST_ENEMY)
end

function GameAgent:targetWeakest()
	self:setTargetChoice(GameWorld.GameAgentTargetChoice.WEAKEST_ENEMY)
end

function GameAgent:targetRandom()
	self:setTargetChoice(GameWorld.GameAgentTargetChoice.RANDOM_ENEMY)
end

function GameAgent:targetAttacker()
	self:setTargetChoice(GameWorld.GameAgentTargetChoice.ATTACKER_ENEMY)
end

function GameAgent:setArmor(armor)
	self.armor=armor
end

function GameAgent:getArmor()
	return self.armor
end
	
function GameAgent:setFiringDelay(delay)
	self.firingDelay=delay
end

function GameAgent:getFiringDelay()
	return self.firingDelay
end

function GameAgent:doNothing()
	GameUtil.print2Console(self:getName() .. " do nothing")
end
			
function GameAgent:isAttacking(agent)
	return self.attackingTarget == agent
end

function GameAgent:setAttacking(agent)
	self.attackingTarget=agent
end

function GameAgent:isAttackable(agent)
	if self.attackables == nil then
		return false
	end
	for i=1, (# self.attackables) do
		if self.attackables[i]==agent then
			return true
		end
	end
	
	return false
end

function GameAgent:setAttackable(agent)
	if self.attackables == nil then
		self.attackables={}
		self.attackables[1]=agent
		return
	end
	self.attackables[(# self.attackables) + 1]=agent
end

function GameAgent:setTargetChoice(c)
	self.targetChoice=c
end

function GameAgent:getTargetChoice(c)
	return self.targetChoice
end

return GameAgent