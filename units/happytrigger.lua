local unitName = "happytrigger"
local unitDef = {
	name = "Happy Trigger",
	description = "Assault Emblem Frame",

	-- Required Tags
	power = 400,
	mass = 240,
	icontype = "happytrigger",
	category = "SMALL STRONG TARGET ANY",
	footprintX = 2,
	footprintZ = 2,
	maxDamage = 15000,
	idleTime = 0,
	idleAutoHeal = 0,
	objectName = "happytrigger.s3o",
	SoundCategory = "FIGHTER",
	collisionVolumeType = "Box",
	collisionVolumeScales = "22 15 36",
	collisionVolumeTest = true,

	-- Movement
	canFly = true,
	hoverAttack = true,
	airHoverFactor = 0,
	airStrafe = false,
	cruiseAlt = 130,
	brakeRate = 1,
	acceleration = .06,
	canMove = true,
	maxVelocity = 2.4,
	turnRate = 600,
	collide = false,

	-- Construction
	levelGround = false,

	-- Sight/Radar
	--radarDistance = 975,
	sightDistance = 1500,
	noChaseCategory = "ANY",
	stealth = true,

	-- Weapons
	weapons = {
		{
			def = "RAILGUN",
			onlyTargetCategory = "TARGET",
			weaponMainDir = "0 0 1",
			maxAngleDif = 10,
		},
		{
			def = "LASER",
			onlyTargetCategory = "TARGET",
			weaponMainDir = "0 0 1",
			maxAngleDif = 10,
		},
		{
			def = "MISSILE",
			onlyTargetCategory = "TARGET",
			weaponMainDir = "0 0 1",
			maxAngleDif = 120,
		},
		{
			def = "PHALANX",
			onlyTargetCategory = "TARGET",
		},
		{
			def = "RAILGUN_SB",
			onlyTargetCategory = "TARGET",
			weaponMainDir = "0 0 1",
			maxAngleDif = 10,
		},
		{
			def = "LASER_SB",
			onlyTargetCategory = "TARGET",
			weaponMainDir = "0 0 1",
			maxAngleDif = 10,
		},
		{
			def = "MISSILE_SB",
			onlyTargetCategory = "TARGET",
			weaponMainDir = "0 0 1",
			maxAngleDif = 120,
		},
		{
			def = "PHALANX_SB",
			onlyTargetCategory = "TARGET",
		},
	},
	
	weaponDefs = {
		RAILGUN = {
			name                    = [[Assault Railgun]],
			areaOfEffect            = 32,
			--burst                   = 2,
			--burstRate               = 0.2,
			coreThickness           = 0,
			craterBoost             = 0,
			craterMult              = 0,
			
			customParams	= {
				ap = 150,
				damagetype = "kinetic",
				description = "Twin high-caliber railguns fire medium-velocity shells with a creamy high-explosive filling. Effective against larger ships.",
				minimumrange = 400,
				critchance = 0.1,
				energypershot = 180,
				category = {ballistic = true, railgun = true},
			},
			
			damage                  = {
				default = 450,
			},
			
			explosionGenerator      = "custom:missile",
			impactOnly              = true,
			impulseBoost            = 0,
			impulseFactor           = 0.4,
			intensity               = 1,
			interceptedByShieldType = 1,
			noSelfDamage            = true,
			projectiles             = 2,
			range                   = 1500,
			reloadTime              = 6,
			soundHit                = [[weapon/cannon/kheavyfire]],
			soundStart              = [[weapon/cannon/medplasma_fire]],
			sprayangle		= 250,
			thickness		= 6,
			texture1		= "plasma",
			texture2		= "null",
			turret                  = true,
			weaponType              = [[LaserCannon]],
			weaponVelocity          = 1200,	
		},
		
		LASER = {
			name		= "Beam Laser",
			accuracy	= 150,
			areaOfEffect	= 8,
			beamDecay	= 0.9,
			beamTTL		= 20,
			beamTime	= 0.1,
			
			customParams	= {
				ap = 0,
				damagetype = "energy",
				description = "A standard high-power laser weapon, effective against all targets.",
				critchance = 0.05,
				energypershot = 100,
				category = {laser = true, energy = true},
			},
			
			craterMult		= 0,
			craterBoost		= 0,
			
			damage = {
				default = 500,
			},
			
			explosiongenerator = "custom:laser",
			impactOnly 	= true,
			impulsefactor	= 0,
			impulseBoost	= 0,
			intensity	= 1,
			interceptedByShieldType = 2,
			laserFlareSize	= 8,
			minIntensity	= 1,
			noSelfDamage	= true,
			range		= 1750,
			reloadTime	= 4,
			rgbColor 	= "0.5 1 0.5",
			soundHit	= nil,
			soundStart 	= "weapon/laser/small_laser_fire2",
			thickness	= 3,
			tolerance	= 1000,
			turret		= true,
			weaponType	= "BeamLaser",
		},
		
		MISSILE = {
			name 		= "Standard Missile",
			areaofeffect	= 64,
			avoidfriendly 	= false,
			burnblow	= true,
			burst		= 3,
			burstRate	= 0.8,
			cegTag		= "missiletrailredsmall",
			
			customParams	= {
				ap = 100,
				damagetype = "kinetic",
				description = "A standard missile mounted on a fighter, good against other fighters and smaller ships.",
				minimumrange = 700,
				suppression_noFlank = 1,
				critchance = 0.075,
				energypershot = 720,
				jammable = true,
				--eccm = 20,
				category = {seeker = true, missile = true},
			},
			
			craterMult		= 0,
			craterBoost		= 0,
			
			damage = {
				default = 600,
			},
			
			dance 		= 10,
			explosiongenerator = "custom:missile",
			fixedLauncher	= true,
			flightTime	= 12,
			impulseFactor	= 0,
			impulseBoost	= 0,
			interceptedByShieldType = 4,
			model		= "wep_m_hailstorm.s3o",
			myGravity	= 0,
			noSelfDamage	= true,
			projectiles     = 2,
			range		= 1800,
			reloadTime	= 30,
			smoketrail 	= true,
			soundHit	= "weapon/missile/sabot_hit",
			soundStart	= "weapon/missile/missile_fire9",
			startVelocity	= 100,
			tolerance	= 3000,
			tracks		= true,
			turret		= true,
			turnrate	= 12800,
			weaponAcceleration = 25,
			weaponType 	= "MissileLauncher",
			weaponVelocity	= 300,
			wobble		= 22000,
		},
		
		PHALANX = {
			name 		= "Phalanx Seeker",
			areaofeffect	= 8,
			avoidfriendly 	= false,
			burnblow	= true,
			burst		= 3,
			burstRate	= 0.2,
			
			customParams	= {
				ap = 25,
				damagetype = "energy",
				description = "A general-purpose homing energy weapon.",
				minimumrange = 500,
				--seekerttl = 60,
				jammable = true,
				seekeraccuracy = 25,
				suppression_noFlank = 1,
				critchance = 0.05,
				energypershot = 320,
				category = {phalanx = true, seeker = true, energy = true},
			},
			
			craterMult		= 0,
			craterBoost		= 0,
			
			damage = {
				default = 100,
			},
			
			--dance 		= 10,
			explosiongenerator = "custom:laser",
			fixedLauncher	= true,
			flightTime	= 6,
			impactOnly	= true,
			impulseFactor	= 0,
			impulseBoost	= 0,
			interceptedByShieldType = 2,
			model		= "",
			myGravity	= 0,
			noSelfDamage	= true,
			projectiles	= 4,
			range		= 1450,
			reloadTime	= 18,
			smoketrail 	= false,
			--soundHit	= "weapons/mlighthit",
			soundStart	= "weapon/energy2",
			--sprayangle 	= 25,
			startVelocity	= 300,
			tolerance	= 3000,
			tracks		= true,
			turret		= true,
			turnrate	= 9600,
			weaponAcceleration = 25,
			weaponType 	= "MissileLauncher",
			weaponVelocity	= 300,
		},
	},

	explodeAs = "RetroDeathSmall",
	selfDestructAs = "RetroDeathSmall",

	-- Misc
	script = "happytrigger.lua",
	sfxTypes = {
		explosionGenerators = {
			"custom:damage_fire",
			"custom:missile",
			"custom:cannon_muzzle",
			"custom:feather",
			"custom:teleport",
		},
	},
	customParams  =  {
		shortname = "Happy Trigger",
		helptext = "More battleship than fighter, the GA-003 Happy Trigger is Forte Stollen's Emblem Frame. Its mobility suffers from the mass penalties imposed by its heavy armor and weaponry.",
		type = "brawler",
		role = "attacker",
		cost = 2000,
		useflightcontrol = 1,
		combatspeed = 1,
		combatrange = 1450,
		inertiafactor = 0.99,
		rollangle = 30,
		armor = 140,
		morale = 50,
		ecm = 20,
		energy = 15000,
		thrusterenergyuse = 1.4,
		suppressionmod = 0.8,
		canresupply = true,
		angel = 4,
	},
}

Spring.Utilities = Spring.Utilities or {}
VFS.Include("LuaRules/Utilities/tablefunctions.lua")

local specialWeapons = {
	RAILGUN_SB = {
		source = "RAILGUN",
		properties = {name = "Assault Railgun SB", projectiles = 1, reloadTime = 0.5, range = 1750, customParams = {special = true, statsprojectiles = 10}}
	},
	LASER_SB = {
		source = "LASER",
		properties = {name = "Beam Laser SB", reloadTime = 1, range = 2000, customParams = {special = true, statsprojectiles = 5}}
	},
	MISSILE_SB = {
		source = "MISSILE",
		properties = {name = "Standard Missile SB", burst = 15, burstRate = 0.36, reloadTime = 10, customParams = {special = true, retarget = 1600, retargettime = 30}}
	},
	PHALANX_SB = {
		source = "PHALANX",
		properties = {name = "Phalanx Seeker SB", burst = 18, burstRate = 0.3, range = 1650, reloadTime = 10, flightTime = 10, customParams = {special = true, seekerttl = 45, retarget = 1400, retargettime = 30}}
	},
}
local weaponDefs = unitDef.weaponDefs
for weaponName, data in pairs(specialWeapons) do
	local newWeapon = Spring.Utilities.CopyTable(weaponDefs[data.source], true)
	weaponDefs[weaponName] = Spring.Utilities.MergeTable(data.properties, newWeapon, true)
end

unitDef.unitname = unitName
return lowerkeys({ [unitName] = unitDef })
