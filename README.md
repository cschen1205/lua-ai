# lua-ai
Implementation of machine learning and artificial intelligence algorithms in lua

# Install

```bash
luarocks install luai
```

# Features

* Artificial Neural Network with Back-propagation for training
* Decision tree
* Naive Bayes Classifier

# Usage

The implementation of the machine learning algorithms can be found in the following lua files:

* src/MLP.lua
* src/NaiveBayesClassifier.lua
* src/DecisionTree.lua

The src/samples folder contains these algorithms wrapped around the GameAgent obj to show how they can be
used to build an intelligent game bot. The actual usage can be found in the spec folder which contains their
unit testing codes.

### Multi-Layer Perceptron Neural Network Sample Codes

The sample code on how to use the MLP to build a intelligent game bot can be found in the "src/samples/MLPBot.lua"

After the bot is built, it can then be trained to understand player'action and try to learn from him:


```lua
local GameUtil = require("luai.samples.GameUtil")
local GameWorld = require("luai.samples.GameWorld")
local GameAgentFactory=require("luai.samples.GameAgent")

--train to obtain MLP model file
local agent=GameAgentFactory.create("UserBot")
GameWorld.initializeAgent(agent, "luai.samples.MLPBot")
GameWorld.trainAgent(agent)

--test accuracy of the training
local records=require("luai.samples.data")

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