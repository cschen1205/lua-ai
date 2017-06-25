local GameWeapon = {}
GameWeapon.__index = GameWeapon

function GameWeapon.create()
   local weapon = {}             -- our new object
   setmetatable(weapon,GameWeapon)  -- make GameWeapon handle lookup
   weapon.bulletCount = 20      -- initialize our object
   weapon.weaponChargingRate=0.02
   weapon.weaponSpeed=30
   weapon.weaponImpact=10
   weapon.weaponPenetration=10
   return weapon
end

function GameWeapon:getBulletCount()
	return self.bulletCount
end

function GameWeapon:setBulletCount(bulletCount)
	self.bulletCount=bulletCount
end

function GameWeapon:getWeaponChargingRate()
	return self.weaponChargingRate
end

function GameWeapon:setWeaponChargingRate(rate)
	self.weaponChargingRate=rate
end

function GameWeapon:setWeaponImpact(impact)
	self.weaponImpact=impact
end

function GameWeapon:getWeaponImpact()
	return self.weaponImpact
end

function GameWeapon:setWeaponPenetration(penetration)
	self.weaponPenetration=penetration
end

function GameWeapon:getWeaponPenetration()
	return self.weaponPenetration
end

function GameWeapon:hasBullets()
	if self.bulletCount > 0 then
		return 1
	else
		return 0
	end
end

function GameWeapon:setMaxBulletCount(bulletCount)
	self.bulletCount=bulletCount
end

function GameWeapon:setWeaponSpeed(speed)
	self.weaponSpeed=speed
end

function GameWeapon:getWeaponSpeed()
	return self.weaponSpeed
end

return GameWeapon
