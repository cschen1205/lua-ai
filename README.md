# lua-ai
Implementation of machine learning and artificial intelligence algorithms in lua

# Usage

### Multi-Layer Perceptron Neural Network

The sample code on how to use the MLP to build a intelligent game bot can be found in the "src/samples/MLPBot.lua"

After the bot is built, it can then be trained to understand player'action and try to learn from him:


```lua
local GameUtil = require("samples.GameUtil")
local GameWorld = require("samples.GameWorld")
local GameAgentFactory=require("samples.GameAgent")

--train to obtain MLP model file
local agent=GameAgentFactory.create("UserBot")
GameWorld.initializeAgent(agent, "samples.MLPBot")
GameWorld.trainAgent(agent)

--test accuracy of the training
local records=require("samples.data")

local accuracy=0
for recordIndex = 1, (# records) do
    agent:setTargetAttackable(records[recordIndex]:isTargetAttackable())
    agent:setSightedAttackerCount(records[recordIndex]:getSightedAttackerCount())
    agent:setTargetRelativeDistance(records[recordIndex]:getTargetRelativeDistance())
    agent:setTargetRelativeLife(records[recordIndex]:getTargetRelativeLife())
    agent:getGun():setBulletCount(records[recordIndex]:getGun():getBulletCount())
    agent:setLife(records[recordIndex]:getLife())
    agent:setScore(records[recordIndex]:getScore())

    GameWorld.processAgent(agent)
    GameUtil.print2Console("recorded: " .. records[recordIndex]:getCurrentAction() .. "\tpredicted: " .. agent:getCurrentAction())
    if records[recordIndex]:getCurrentAction() == agent:getCurrentAction() then
        accuracy=accuracy + 1
    end
end

accuracy=accuracy * 100 / (# records)

GameUtil.print2Console("accuracy: " .. accuracy .. "%")
```