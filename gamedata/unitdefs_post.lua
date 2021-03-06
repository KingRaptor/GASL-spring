--VFS.Include("gamedata/buildoptions.lua")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions = {}
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Utility
--

local function tobool(val)
  local t = type(val)
  if (t == 'nil') then
    return false
  elseif (t == 'boolean') then
    return val
  elseif (t == 'number') then
    return (val ~= 0)
  elseif (t == 'string') then
    return ((val ~= '0') and (val ~= 'false'))
  end
  return false
end

local function disableunits(unitlist)
  for name, ud in pairs(UnitDefs) do
    if (ud.buildoptions) then
      for _, toremovename in ipairs(unitlist) do
        for index, unitname in pairs(ud.buildoptions) do
          if (unitname == toremovename) then
            table.remove(ud.buildoptions, index)
          end
        end
      end
    end
  end
end

--deep not safe with circular tables! defaults To false
function CopyTable(tableToCopy, deep)
  local copy = {}
  for key, value in pairs(tableToCopy) do
    if (deep and type(value) == "table") then
      copy[key] = CopyTable(value, true)
    else
      copy[key] = value
    end
  end
  return copy
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- morale effects
local BASE_MORALE = 50
local MORALE_ACCURACY_BOOST = 0.25
local MORALE_SUPPRESSION_MOD_BOOST = 1

for name, ud in pairs(UnitDefs) do
    local cp = ud.customparams
    if cp.angel then
	local morale = modOptions["morale"..cp.angel] or cp.morale
	if morale then
	    cp.morale = morale
	    local moraleMod = (morale - BASE_MORALE)/BASE_MORALE
	    
	    -- weapon accuracy
	    local accMod = moraleMod * MORALE_ACCURACY_BOOST
	    --cp.moraleaccboost = accMod
	    for name, weaponData in pairs(ud.weapondefs) do
		if weaponData.accuracy then
		    weaponData.accuracy = weaponData.accuracy*(1-accMod)
		end
		if weaponData.sprayangle then
		    weaponData.sprayangle = weaponData.sprayangle*(1-accMod)
		end
	    end	    
	    -- suppression resistance
	    local suppressionModMod = moraleMod * MORALE_SUPPRESSION_MOD_BOOST
	    cp.suppressionmod = math.max((cp.suppressionmod or 1) - (cp.suppressionmod or 1)*suppressionModMod, 0)
	end
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Convert all CustomParams to strings
--

for name, ud in pairs(UnitDefs) do
  if (ud.customparams) then
    for tag,v in pairs(ud.customparams) do
      if (type(v) == "table") then
	    local str = "{"
		for i=1,#v do
			str = str .. [["]] .. v[i] .. [[", ]]
		end
		str = str .. "}"
        ud.customparams[tag] = str
      elseif (type(v) ~= "string") then
        ud.customparams[tag] = tostring(v)
      end
    end
  end
end 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Some movement stuff

for name, ud in pairs(UnitDefs) do
    if (ud.maxvelocity) then ud.maxreversevelocity = ud.maxvelocity * 0.33 end
	if (ud.canfly) then
		ud.floater = false
		ud.cansubmerge = true
	end
	if (ud.turnrate) then
	    ud.turnrate = ud.turnrate * 0.5
	end
end 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Sets metal cost (for tooltip)
for name, ud in pairs(UnitDefs) do
	if ud.customparams then
		ud.buildcostmetal = ud.customparams.cost or 1
		ud.buildtime = tonumber(ud.customparams.buildtime) or 1
	end
end

for name,ud in pairs(UnitDefs) do
    ud.customparams = ud.customparams or {}
    ud.customparams.missilejamstrength = ud.customparams.missilejamstrength or (30 + 20*(ud.customparams.ecm or 0)/100)
end

-- LOS settings
for name, ud in pairs(UnitDefs) do
    ud.radardistance = 0
    --ud.stealth = true
end

-- all units can see really far
for name, ud in pairs(UnitDefs) do
    ud.sightdistance = 60000
end

-- default movestate
for name, ud in pairs(UnitDefs) do
    ud.movestate = ud.movestate or 2
end


-- Per-piece colvols
for name, ud in pairs(UnitDefs) do
	--ud.usepiececollisionvolumes = true
end 