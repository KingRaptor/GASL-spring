--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
include ("constants.lua")

local spGetUnitRulesParam = Spring.GetUnitRulesParam
--------------------------------------------------------------------------------
-- pieces
--------------------------------------------------------------------------------

local base, fuselage, pod_L, pod_R, prong_L, prong_R = piece('base', 'fuselage', 'pod_l', 'pod_r', 'prong_l', 'prong_r')
local laser, laserFlare = piece('laser', 'laserflare')
local railgun_brace, railgun_L, railgunFlare_L, railgun_R, railgunFlare_R = piece('railgun_brace', 'railgun_l', 'railgunflare_l', 'railgun_r', 'railgunflare_r')
local missile_L, missileflare_L, missile_R, missileflare_R = piece('missile_l', 'missileflare_l', 'missile_r', 'missileflare_r')
local phalanx_L, phalanxArm_L, phalanx_R, phalanxArm_R = piece('phalanx_l', 'phalanxarm_l', 'phalanx_r', 'phalanxarm_r')
local engine_L, engine_R = piece('engine_l', 'engine_r')

local weapons = {
    -- normal
    {aimpoint = base, muzzles = {railgunFlare_L, railgunFlare_R}, index = 1, emit = 1026},	-- railgun
    {aimpoint = laser, muzzles = {laserFlare}, index = 1},	-- laser
    {aimpoint = base, muzzles = {missileflare_L, missileflare_R}, index = 1},	-- missile
    {aimpoint = base, muzzles = {}, index = 1},	-- phalanx
    -- special
    {aimpoint = base, muzzles = {railgunFlare_L, railgunFlare_R}, index = 1, emit = 1026},	-- railgun
    {aimpoint = laser, muzzles = {laserFlare}, index = 1},	-- laser
    {aimpoint = base, muzzles = {missileflare_L, missileflare_R}, index = 1},	-- missile
    {aimpoint = base, muzzles = {}, index = 1},	-- phalanx
}
do
    local muzzles = weapons[4].muzzles
    local muzzles2 = weapons[8].muzzles
    for i=1,6 do
	muzzles[#muzzles+1] = piece("phalanx_l"..i)
	muzzles[#muzzles+1] = piece("phalanx_r"..i)
	muzzles2[#muzzles2+1] = piece("phalanx_l"..i)
	muzzles2[#muzzles2+1] = piece("phalanx_r"..i)
    end
    
    for i=1,8 do
	weapons[i].special = (i > 4)
    end
end

--------------------------------------------------------------------------------
-- constants
--------------------------------------------------------------------------------
local SIG_DAMAGE = 1
local SIG_SPECIAL = 4

--------------------------------------------------------------------------------
-- variables
--------------------------------------------------------------------------------
local isUsingSpecial = false
local specialTarget
local dead = false

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function DamageLoop()
    Signal(SIG_DAMAGE)
    SetSignalMask(SIG_DAMAGE)
    local health, maxHealth = Spring.GetUnitHealth(unitID)
    while (health/maxHealth < 0.5) do
	local cd = math.floor(25 - (health/maxHealth)*0.5)
	SetUnitValue(COB.CEG_DAMAGE, cd)
	EmitSfx(pod_L, 1024)
	if ((health/maxHealth) < 0.3) then
	    EmitSfx(prong_R, 1024)
	end
	if dead then
	    EmitSfx(pod_R, 1024)
	    EmitSfx(prong_L, 1024)
	    EmitSfx(fuselage, 1024)
	end
	Sleep(50)
    end
end

local function DebugPhalanx()
    while true do
	for i=1,6 do
	    EmitSfx(piece("phalanx_l"..i), 1026)
	    EmitSfx(piece("phalanx_r"..i), 1026)
	end
	Sleep(300)
    end
end

local function SetPhalanxPointVectors()
    local pair = 1
    for i=1,6 do
	local angleDeg = (i%2 == 0) and 80 or -80
	if pair ~= 2 then
	    --angleDeg = angleDeg*7/8
	end
	local angle = math.rad(angleDeg)
	local angle2 = math.rad(60 + 15*pair)
	Turn(piece("phalanx_l"..i), x_axis, angle)
	Turn(piece("phalanx_l"..i), y_axis, angle2)
	Turn(piece("phalanx_r"..i), x_axis, angle)
	Turn(piece("phalanx_r"..i), y_axis, -angle2)
	if i%2 == 0 then
	    pair = pair + 1
	end
    end
end

local function StrikeBurstThread()
    Signal(SIG_SPECIAL)
    SetSignalMask(SIG_SPECIAL)
    isUsingSpecial = true
    Spring.SetUnitRulesParam(unitID, "isUsingSpecial", 1)
    
    Turn(phalanxArm_L, z_axis, math.rad(-24), math.rad(240))
    Turn(phalanxArm_R, z_axis, math.rad(24), math.rad(240))
    Turn(phalanx_L, y_axis, math.rad(-90), math.rad(360))
    Turn(phalanx_R, y_axis, math.rad(90), math.rad(360))
    
    local pair = 1
    for i=1,6 do
	local angle = math.rad(75 + 15*pair)
	if i%2 == 0 then angle = -angle end
	Turn(piece("phalanx_l"..i), x_axis, angle)
	Turn(piece("phalanx_l"..i), y_axis, 0)
	Turn(piece("phalanx_r"..i), x_axis, angle)
	Turn(piece("phalanx_r"..i), y_axis, 0)
	if i%2 == 0 then
	    pair = pair + 1
	end
    end
    
    Sleep(5000)
    
    Turn(phalanxArm_L, z_axis, math.rad(-12), math.rad(80))
    Turn(phalanxArm_R, z_axis, math.rad(12), math.rad(80))
    Turn(phalanx_L, y_axis, 0, math.rad(120))
    Turn(phalanx_R, y_axis, 0, math.rad(120))
    SetPhalanxPointVectors()
    isUsingSpecial = false
    Spring.SetUnitRulesParam(unitID, "isUsingSpecial", 0)
    GG.FlightControl.SetChaseTarget(unitID, nil)
    Spring.SetUnitTarget(unitID, 0)
end

function StrikeBurstTrigger(params)
    specialTarget = params[1]
    GG.FlightControl.SetChaseTarget(unitID, params[1])
    Spring.SetUnitTarget(unitID, params[1])
    StartThread(StrikeBurstThread)
end

local function FeatherLoop()
    while true do
	local spirit = spGetUnitRulesParam(unitID, "spirit")
	if spirit == 100 then
	    EmitSfx(engine_L, 1027)
	    EmitSfx(engine_R, 1027)
	end
	Sleep(500)
    end
end



function script.Create()
    Turn(pod_L, z_axis, math.rad(12))
    Turn(pod_R, z_axis, math.rad(-12))
    Turn(prong_L, z_axis, math.rad(-42))
    Turn(prong_R, z_axis, math.rad(42))
    Turn(prong_L, x_axis, math.rad(30))
    Turn(prong_R, x_axis, math.rad(30))
    Turn(prong_L, y_axis, math.rad(-20))
    Turn(prong_R, y_axis, math.rad(20))
    Turn(phalanxArm_L, z_axis, math.rad(-12))
    Turn(phalanxArm_R, z_axis, math.rad(12))
    
    SetPhalanxPointVectors()
    
    --StartThread(DebugPhalanx)
    StartThread(FeatherLoop)
end

function script.MoveRate(rate)
end

function script.AimFromWeapon(num)
    local data = weapons[num]
    return data.aimpoint
end

function script.QueryWeapon(num)
    local data = weapons[num]
    return data.muzzles[data.index]
end

function script.FireWeapon(num)
end

function script.AimWeapon(num)
    GG.UpdateWeaponAccuracy(unitID, unitDefID, num)
    return weapons[num].special == isUsingSpecial
end

function script.Shot(num)
    local data = weapons[num]
    if data.emit then
	EmitSfx(data.muzzles[data.index], data.emit)
    end
    data.index = data.index + 1
    if data.index > #data.muzzles then
	data.index = 1
    end
end

function script.BlockShot(weaponID, targetID, userTarget)
    local minRange = minRanges[weaponID]
    local energyPerShot = (GG.Energy) and energyPerShot[weaponID]
    if minRange then
	local distance
	if targetID then
	    distance = Spring.GetUnitSeparation(unitID, targetID, true)
	elseif userTarget then
	    local cmd = Spring.GetUnitCommands(unitID, 1)[1]
	    if cmd.id == CMD.ATTACK then
		local tx,ty,tz = unpack(cmd.params)
		distance = GetUnitDistanceToPoint(unitID, tx, ty, tz, true)
	    end
	end
	if distance < minRange then return true end
    end
    if isUsingSpecial and (not Spring.GetUnitIsDead(specialTarget)) and specialTarget ~= targetID then
	return true
    end
    if energyPerShot then
	return (not GG.Energy.UseUnitEnergy(unitID, unitDefID, energyPerShot))
    end
    return false
end

function script.HitByWeapon()
    if isUsingSpecial then
	return 0
    end
    StartThread(DamageLoop)
end

function script.Killed(recentDamage, maxHealth)
    dead = true
    for i=1,8 do
	EmitSfx(base, 1025)
	Sleep(500)
    end
    EmitSfx(fuselage, 1028)
end