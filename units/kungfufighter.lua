local unitName = "kungfufighter"
local unitDef = {
	name = "Kung-fu Fighter",
	description = "Interceptor Emblem Frame",

	-- Required Tags
	power = 400,
	mass = 120,
	icontype = "kungfufighter",
	category = "SMALL STRONG TARGET ANY",
	footprintX = 2,
	footprintZ = 2,
	maxDamage = 7500,
	idleTime = 0,
	idleAutoHeal = 0,
	objectName = "kungfufighter.s3o",
	SoundCategory = "FIGHTER",
	collisionVolumeType = "Box",
	collisionVolumeScales = "22 15 30",
	collisionVolumeTest = true,

	-- Movement
	canFly = true,
	hoverAttack = true,
	airHoverFactor = 0,
	airStrafe = false,
	cruiseAlt = 130,
	brakeRate = 1.5,
	acceleration = .09,
	canMove = true,
	maxVelocity = 3.5,
	turnRate = 1400,
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
			def = "VULCAN_HEAVY_DUAL",
			onlyTargetCategory = "TARGET",
			badTargetCategory = "ARMORED",
			weaponMainDir = "0 0 1",
			maxAngleDif = 10,
		},
		{
			def = "MISSILE_DOGFIGHT",
			onlyTargetCategory = "TARGET",
			badTargetCategory = "ARMORED",
			weaponMainDir = "0 0 1",
			maxAngleDif = 120,
		},
		{
			def = "MISSILE_HARPOON",
			onlyTargetCategory = "LARGE",
			weaponMainDir = "0 0 1",
			maxAngleDif = 90,
		},
	},
	
	weaponDefs = {
		MISSILE_DOGFIGHT = 
		{
			name 		= "Dogfight Missile",
			areaofeffect	= 32,
			avoidfriendly 	= false,
			burnblow	= true,
			burst		= 3,
			burstRate	= 0.8,
			cegTag		= "missiletrailredsmall",
			
			customParams	= {
				ap = 75,
				damagetype = "kinetic",
				description = "Multiple small missiles with excellent agility, highly effective against enemy fighters.",
				minimumrange = 550,
				suppression_noFlank = 1,
				critchance = 0.075,
				energypershot = 270,
				jammable = true,
				eccm = 15,
			},
			
			craterMult		= 0,
			craterBoost		= 0,
			
			damage = {
				default = 450,
			},
			
			dance 		= 10,
			explosiongenerator = "custom:missile",
			fixedLauncher	= true,
			flightTime	= 10,
			impulseFactor	= 0,
			impulseBoost	= 0,
			interceptedByShieldType = 4,
			model		= "wep_m_ajax.s3o",
			myGravity	= 0,
			noSelfDamage	= true,
			projectiles	= 2,
			range		= 1400,
			reloadTime	= 18,
			smoketrail 	= true,
			soundHit	= "explosion/ex_small6",
			soundStart	= "weapon/missile/missile_small",
			startVelocity	= 100,
			tolerance	= 3000,
			tracks		= true,
			turret		= false,
			turnrate	= 12800,
			weaponAcceleration = 25,
			weaponType 	= "MissileLauncher",
			weaponVelocity	= 300,
			wobble		= 20000,
		},
		
		VULCAN_HEAVY_DUAL = {
			name			= "Dual Heavy Vulcan Cannon",
			areaOfEffect		= 8,
			burst                   = 3,
			burstRate               = 0.1,
			
			customParams	= {
				ap = 62.5,
				damagetype = "kinetic",
				description = "Twin upscaled autocannons, boasting considerably greater firepower than the normal version. Best employed against lightly armored targets.",
				critchance = 0.075,
				energypershot = 12,
			},
			
			craterMult		= 0,
			craterBoost		= 0,
			
			damage = {
				default = 20,
			},
			
			duration		= .02,
			explosiongenerator	= "custom:kinetic",
			fallOffRate		= .05,
			impactOnly		= 1,
			impulsefactor		= 0,
			impulseBoost		= 0,
			intensity		= 1,
			interceptedByShieldType = 1,
			noSelfDamage		= true,
			projectiles		= 2,
			range			= 1350,
			reloadtime		= .3,
			rgbColor		= "1 0.5 0",
			soundStart		= "weapon/cannon/klightfire",
			soundHit		= "weapon/cannon/klighthit",
			soundTrigger            = true,
			sprayangle		= 400,
			thickness		= .75,
			tolerance		= 3000,
			turret			= false,
			weaponVelocity		= 850,
			weaponType		= "LaserCannon",
		},
		
		MISSILE_HARPOON = 
		{
			name 		= "Harpoon Missile",
			areaofeffect	= 96,
			avoidfriendly 	= false,
			burnblow	= true,
			cegTag		= "missiletrailredsmall",
			
			customParams	= {
				ap = 150,
				damagetype = "kinetic",
				description = "Heavy shipkiller missile with increased punch and ECCM capability, but poor maneuverability.",
				minimumrange = 900,
				suppression_noFlank = 1,
				critchance = 0.1,
				energypershot = 140,
				jammable = true,
				eccm = 40,
			},
			
			craterMult		= 0,
			craterBoost		= 0,
			
			damage = {
				default = 1400,
			},
			
			dance 		= 15,
			explosiongenerator = "custom:missile",
			fixedLauncher	= true,
			flightTime	= 16,
			impulseFactor	= 0,
			impulseBoost	= 0,
			interceptedByShieldType = 4,
			model		= "wep_m_phoenix.s3o",
			myGravity	= 0,
			noSelfDamage	= true,
			range		= 2000,
			reloadTime	= 14,
			smoketrail 	= true,
			soundHit	= "explosion/ex_med17",
			soundStart	= "weapon/missile/missile_fire",
			startVelocity	= 100,
			tolerance	= 3000,
			tracks		= true,
			turret		= false,
			turnrate	= 9000,
			weaponAcceleration = 20,
			weaponType 	= "MissileLauncher",
			weaponVelocity	= 250,
			wobble		= 20000,
		},
	},

	explodeAs = "RetroDeathSmall",
	selfDestructAs = "RetroDeathSmall",

	-- Misc
	script = "kungfufighter.lua",
	sfxTypes = {
		explosionGenerators = {
			"custom:damage_fire",
			"custom:death_small",
			"custom:gunmuzzle",
			"custom:feather",
		},
	},
	customParams  =  {
		shortname = "Kung-fu Fighter",
		helptext = "The GA-002 Kung-fu Fighter is a blazing fast Emblem Frame piloted by Ranpha Franboise. Its extreme mobility comes at the expense of armor protection.",
		type = "small",
		role = "brawler",
		cost = 2000,
		useflightcontrol = 1,
		combatspeed = 1.6,
		combatrange = 1300,
		inertiafactor = 0.978,
		rollangle = math.rad(30),
		armor = 75,
		morale = 50,
		ecm = 25,
		suppressionmod = 0.75,
		energy = 10000,
	},
}

unitDef.unitname = unitName
return lowerkeys({ [unitName] = unitDef })
