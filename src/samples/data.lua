--Year: 2009 Month:10 Day: 22 Hour: 16 Minute: 45 Second: 55
local userbot={}
local recordIndex=0
local GameAgentFactory=require("samples.GameAgent")

--recordIndex: 1
recordIndex=recordIndex+1
userbot[recordIndex]=GameAgentFactory.create("UserBot")
userbot[recordIndex]:setTargetAttackable(0)
userbot[recordIndex]:setSightedAttackerCount(0)
userbot[recordIndex]:setTargetRelativeDistance(1.000000)
userbot[recordIndex]:setTargetRelativeLife(1)
userbot[recordIndex]:getGun():setBulletCount(20)
userbot[recordIndex]:setLife(1000)
userbot[recordIndex]:setScore(0.000000)
userbot[recordIndex]:setCurrentAction(2)

--recordIndex: 2
recordIndex=recordIndex+1
userbot[recordIndex]=GameAgentFactory.create("UserBot")
userbot[recordIndex]:setTargetAttackable(1)
userbot[recordIndex]:setSightedAttackerCount(0)
userbot[recordIndex]:setTargetRelativeDistance(0.606732)
userbot[recordIndex]:setTargetRelativeLife(0)
userbot[recordIndex]:getGun():setBulletCount(16)
userbot[recordIndex]:setLife(1000)
userbot[recordIndex]:setScore(59.999908)
userbot[recordIndex]:setCurrentAction(0)

--recordIndex: 3
recordIndex=recordIndex+1
userbot[recordIndex]=GameAgentFactory.create("UserBot")
userbot[recordIndex]:setTargetAttackable(1)
userbot[recordIndex]:setSightedAttackerCount(0)
userbot[recordIndex]:setTargetRelativeDistance(0.978025)
userbot[recordIndex]:setTargetRelativeLife(0)
userbot[recordIndex]:getGun():setBulletCount(11)
userbot[recordIndex]:setLife(1000)
userbot[recordIndex]:setScore(159.999908)
userbot[recordIndex]:setCurrentAction(4)

--recordIndex: 4
recordIndex=recordIndex+1
userbot[recordIndex]=GameAgentFactory.create("UserBot")
userbot[recordIndex]:setTargetAttackable(0)
userbot[recordIndex]:setSightedAttackerCount(0)
userbot[recordIndex]:setTargetRelativeDistance(1.000000)
userbot[recordIndex]:setTargetRelativeLife(0)
userbot[recordIndex]:getGun():setBulletCount(12)
userbot[recordIndex]:setLife(1000)
userbot[recordIndex]:setScore(159.999908)
userbot[recordIndex]:setCurrentAction(3)

--recordIndex: 5
recordIndex=recordIndex+1
userbot[recordIndex]=GameAgentFactory.create("UserBot")
userbot[recordIndex]:setTargetAttackable(0)
userbot[recordIndex]:setSightedAttackerCount(0)
userbot[recordIndex]:setTargetRelativeDistance(1.000000)
userbot[recordIndex]:setTargetRelativeLife(0)
userbot[recordIndex]:getGun():setBulletCount(12)
userbot[recordIndex]:setLife(1000)
userbot[recordIndex]:setScore(159.999908)
userbot[recordIndex]:setCurrentAction(0)

--recordIndex: 6
recordIndex=recordIndex+1
userbot[recordIndex]=GameAgentFactory.create("UserBot")
userbot[recordIndex]:setTargetAttackable(0)
userbot[recordIndex]:setSightedAttackerCount(0)
userbot[recordIndex]:setTargetRelativeDistance(1.000000)
userbot[recordIndex]:setTargetRelativeLife(0)
userbot[recordIndex]:getGun():setBulletCount(12)
userbot[recordIndex]:setLife(1000)
userbot[recordIndex]:setScore(159.999908)
userbot[recordIndex]:setCurrentAction(2)

--recordIndex: 7
recordIndex=recordIndex+1
userbot[recordIndex]=GameAgentFactory.create("UserBot")
userbot[recordIndex]:setTargetAttackable(0)
userbot[recordIndex]:setSightedAttackerCount(0)
userbot[recordIndex]:setTargetRelativeDistance(1.000000)
userbot[recordIndex]:setTargetRelativeLife(0)
userbot[recordIndex]:getGun():setBulletCount(12)
userbot[recordIndex]:setLife(1000)
userbot[recordIndex]:setScore(159.999908)
userbot[recordIndex]:setCurrentAction(4)

--recordIndex: 8
recordIndex=recordIndex+1
userbot[recordIndex]=GameAgentFactory.create("UserBot")
userbot[recordIndex]:setTargetAttackable(0)
userbot[recordIndex]:setSightedAttackerCount(0)
userbot[recordIndex]:setTargetRelativeDistance(1.000000)
userbot[recordIndex]:setTargetRelativeLife(0)
userbot[recordIndex]:getGun():setBulletCount(12)
userbot[recordIndex]:setLife(1000)
userbot[recordIndex]:setScore(159.999908)
userbot[recordIndex]:setCurrentAction(1)

return userbot
