local GameUtil = require("samples.GameUtil")
local GameWorld = require("samples.GameWorld")
local GameAgentFactory = require("samples.GameAgent")

describe("NBC()", function()
	describe("training", function()
		it("traing and produce accurarcy on testing", function()
			--train to obtain Saved.lua file
			local dummy = GameAgentFactory.create("dummy agent")
			GameWorld.initializeAgent(dummy, "samples.NBCBot")

			--test accuracy of the training
			local records = require("samples.data")

			local accuracy=0
			for recordIndex = 1, (# records) do
				local agent=GameAgentFactory.create(records[recordIndex]:getAgentId() .. "X")
				GameWorld.initializeAgent(agent) --load from Save.lua during initialization
				GameWorld.processAgent(agent)
				GameUtil.print2Console("recorded: " .. records[recordIndex]:getCurrentAction() .. "\tpredicted: " .. agent:getCurrentAction())
				if records[recordIndex]:getCurrentAction() == agent:getCurrentAction() then
					accuracy=accuracy + 1
				end
			end

			accuracy = accuracy * 100 / (# records)
			GameUtil.print2Console("accuracy: " .. accuracy .. "%")
		end)
	end)

end)

