--------------------------------------------------------------------------------
--
--  Per-unitDef weaponDefs
--

local function isbool(x)   return (type(x) == 'boolean') end
local function istable(x)  return (type(x) == 'table')   end
local function isnumber(x) return (type(x) == 'number')  end
local function isstring(x) return (type(x) == 'string')  end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function ProcessUnitDef(udName, ud)
  local wds = ud.weapondefs
  if (not istable(wds)) then
    return
  end

  -- add this unitDef's weaponDefs
  for wdName, wd in pairs(wds) do
    if (isstring(wdName) and istable(wd)) then
      local fullName = udName .. '_' .. wdName
      WeaponDefs[fullName] = wd
      wd.filename = ud.filename
    end
  end

  -- convert the weapon names
  local weapons = ud.weapons
  if (istable(weapons)) then
    for i = 1, 16 do
      local w = weapons[i]
      if (istable(w)) then
        if (isstring(w.def)) then
          local ldef = string.lower(w.def)
          local fullName = udName .. '_' .. ldef
          local wd = WeaponDefs[fullName]
          if (istable(wd)) then
            w.name = fullName
          end
        end
        w.def = nil
      end
    end
  end
  
  -- convert the death explosions
  if (isstring(ud.explodeas)) then
    local fullName = udName .. '_' .. ud.explodeas
    if (WeaponDefs[fullName]) then
      ud.explodeas = fullName
    end
  end
  if (isstring(ud.selfdestructas)) then
    local fullName = udName .. '_' .. ud.selfdestructas
    if (WeaponDefs[fullName]) then
      ud.selfdestructas = fullName
    end
  end
  
end


--------------------------------------------------------------------------------
-- Process the unitDefs
--------------------------------------------------------------------------------

local UnitDefs = DEFS.unitDefs

for udName, ud in pairs(UnitDefs) do
  if (isstring(udName) and istable(ud)) then
    ProcessUnitDef(udName, ud)
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

for _, weaponDef in pairs(WeaponDefs) do
    --Spring.Echo(weaponDef.name)
    if weaponDef.weapontype == "BeamLaser" then
	weaponDef.sweepfire = false
    end
    
    -- all weapons can shoot through "water" and "land"
    weaponDef.waterweapon = true
    weaponDef.firesubmersed = true
    weaponDef.canattackground = false
    weaponDef.avoidground = false
    weaponDef.collideground = false
    
    weaponDef.targetborder = 0.8
    weaponDef.cylindertargeting = 0
    weaponDef.heightmod = 1
    --weaponDef.heightboostfactor = 0	-- only used for cannons
end