local GameUtil = require("samples.GameUtil")
local GameWorld = require("samples.GameWorld")
local GameAgentFactory=require("samples.GameAgent")

describe("NBC()", function()
	describe("training", function()
		it("traing and produce accurarcy on testing", function()
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
		end)
	end)
end)



