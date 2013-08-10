--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:GetInfo()
	return {
		name      = "Unit Info",
		desc      = "v0.2 Displays unit information",
		author    = "KingRaptor (L.J. Lim)",
		date      = "2013.05.14",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true,
		handler   = true,
	}
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- TODO: merge duplicate weapons

local MIN_HEIGHT = 80
local MIN_WIDTH = 200

local WEAPON_PANEL_HEIGHT = 64

local DAMAGETYPE_IMAGES = {
	kinetic = "LuaUI/Images/damage_kinetic.png",
	energy = "LuaUI/Images/damage_energy.png",
}

-- Chili classes
local Chili
local Button
local Label
local InfoLabel	-- custom class
local Window
local Grid
local Panel
local ScrollPanel
local StackPanel
local TextBox
local Image
local Progressbar
local Control
local screen0

local vsx, vsy

local pilotData = {	-- FIXME
	[UnitDefNames.luckystar.id] = {name = "Milfeulle Sakuraba", affiliation = "Angel Wing", portrait = "LuaUI/Images/portraits/milfeulle_normal.png"},
	[UnitDefNames.kungfufighter.id] = {name = "Ranpha Franboise", affiliation = "Angel Wing", portrait = "LuaUI/Images/portraits/ranpha_normal.png"},
	[UnitDefNames.happytrigger.id] = {name = "Forte Stollen", affiliation = "Angel Wing", portrait = "LuaUI/Images/portraits/forte_normal.png"},
}
local shipData = {}
local weaponData = {}

for i=1,#UnitDefs do
	local unitDef = UnitDefs[i]
	local customParams = unitDef.customParams
	shipData[i] = {
		name = unitDef.humanName,
		desc = customParams.helptext,
		image = "LuaUI/Images/shippics/"..unitDef.name .. ".png",
		armor = customParams.armor or 100,
		speed = ("%.2f"):format(unitDef.speed),
		combatSpeed = ("%.2f"):format(customParams.combatSpeed and ustomParams.combatSpeed*30 or (0.6*unitDef.speed)),
		turnrate = ("%.0f"):format(unitDef.turnRate/2),
		combatRange = tonumber(customParams.combatrange) or 1000,
		maneuverability = math.floor((1 - (customParams.inertiafactor or 0.98)) * 1000),
		ecm = customParams.ecm or 0,
		morale = tonumber(customParams.morale),
		energy = tonumber(customParams.energy),
		
		weapons = {}
	}
	for index,weaponInfo in ipairs(unitDef.weapons) do
		shipData[i].weapons[#shipData[i].weapons + 1] = weaponInfo.weaponDef
	end
end

for i=1,#WeaponDefs do
	local wd = WeaponDefs[i]
	local customParams = wd.customParams
	weaponData[i] = {
		name = wd.description,
		desc = customParams.description,
		damage = wd.damages[0],
		burstSize = wd.salvoSize or 1,
		projectiles = wd.projectiles or 1,
		reloadTime = wd.reload or 1,
		range = wd.range,
		damageType = customParams.damagetype or "kinetic",
		ap = customParams.ap,
		critChance = customParams.critchance,
		special = customParams.special,
	}
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function GetHealthColor(fraction, returnType)
	local midpt = (fraction > .5)
	local r, g
	if midpt then 
		r = ((1-fraction)/0.5)
		g = 1
	else
		r = 1
		g = (fraction)/0.5
	end
	if returnType == "char" then
		return string.char(255,math.floor(255*r),math.floor(255*g),0)
	end
	return {r, g, 0, 1}
end

local function CreateWeaponPanel(weaponID, count, index, parent)
	local data = weaponData[weaponID]
	local panel = Panel:New{
		parent = parent,
		y = (index - 1)*WEAPON_PANEL_HEIGHT,
		width = "100%",
		height = WEAPON_PANEL_HEIGHT,
		tooltip = data.desc,
		padding = {10, 5, 10, 5},
		hitTestAllowEmpty = true,
	}
	local nameString = data.name
	if count > 1 then
		nameString = nameString .. " x" .. count
	end
	local name = Label:New{
		parent = panel;
		caption = nameString,
		x = 0,
		y = 0,
		align="left";
		fontSize = 14;
		fontShadow = true;
	}
	local damageType = Image:New{
		parent = panel,
		file = DAMAGETYPE_IMAGES[data.damageType],
		right = 12,
		y = 4,
		width = 48,
		height = 48,
	}
	local dmgString = "Damage: "..data.damage
	local projectiles = data.burstSize * data.projectiles
	if projectiles > 1 then
		dmgString = dmgString .. " x "..projectiles
	end
	local damage = Label:New{
		parent = panel;
		caption = dmgString,
		x = 0,
		y = 18,
		align="left";
		fontSize = 12;
		fontShadow = true;
	}
	local value_reloadTime = ("%.2f"):format(data.reloadTime)
	local reloadTime = Label:New{
		parent = panel;
		caption = "Reload: " .. value_reloadTime .. " s",
		x = 144,
		y = 18,
		align="left";
		fontSize = 12;
		fontShadow = true;
	}
	local value_dps = ("%.1f"):format(data.damage*projectiles/data.reloadTime)
	local dps = Label:New{
		parent = panel;
		caption = "DPS: " .. value_dps,
		x = 288,
		y = 18,
		align="left";
		fontSize = 12;
		fontShadow = true;
	}
	local range = Label:New{
		parent = panel;
		caption = "Range: " .. data.range,
		x = 0,
		y = 36,
		align="left";
		fontSize = 12;
		fontShadow = true;
	}
	local ap
	if data.ap then
		ap = Label:New{
			parent = panel;
			caption = "Armor piercing: " .. data.ap,
			x = 144,
			y = 36,
			align="left";
			fontSize = 12;
			fontShadow = true;
		}
	end
	local critChance
	if data.critChance then
		critChance = Label:New{
			parent = panel;
			caption = "Crit chance: " .. ("%.1f"):format(data.critChance*100) .. "%",
			x = ap and 288 or 144,
			y = 36,
			align= "left";
			fontSize = 12;
			fontShadow = true;
		}
	end
end

local function CreateWeaponPanels(data, parent)
	-- first go through the weapon list and count duplicates
	local weaponIDs = {}
	for i=1,#data.weapons do
		local weaponID = data.weapons[i]
		weaponIDs[weaponID] = (weaponIDs[weaponID] or 0) + 1
	end
	-- make sure duplicates are only sorted once
	local index = 1
	for i=1,#data.weapons do
		local weaponID = data.weapons[i]
		local count = weaponIDs[weaponID] 
		if count then
			CreateWeaponPanel(weaponID, count, index, parent)
			index = index + 1
		end
		weaponIDs[weaponID] = nil
	end
end

local function FillPilotBiodata(unitID, unitDefID, pilotData, container)
	--[[
	local nameHeader = Label:New{
		parent = container;
		caption = "Name",
		align="left";
		fontSize = 13;
		fontShadow = true;
		x = 0,
		y = 0,
	}
	]]--
	local name = Label:New{
		parent = container;
		caption = pilotData and pilotData.name or "-",
		align="left";
		fontSize = 13;
		fontShadow = true;
		--x = 64,
		y = 0,
	}
	--[[
	local affiliationHeader = Label:New{
		parent = container;
		caption = "Unit",
		align="left";
		fontSize = 13;
		fontShadow = true;
		x = 0,
		y = 16,
	}
	]]
	local affiliation = Label:New{
		parent = container;
		caption = pilotData and pilotData.affiliation or "-",
		align="left";
		fontSize = 13;
		fontShadow = true;
		--x = 64,
		y = 24,
	}
end

local function CreateStatsWindow(unitID, unitDefID)
	local data = shipData[unitDefID]
	local pilot = pilotData[unitDefID]

	local window_main = Window:New{
		parent = screen0,
		--name   = 'unitinfo_window';
		width = 600;
		height = 580;
		x = vsx/2 - 300; 
		y = vsy/2 - 300;
		draggable = true,
		resizable = false,
		tweakResizable = false,
		minWidth = MIN_WIDTH,
		minHeight = MIN_HEIGHT,
		padding = {0, 0, 0, 0},
		itemMargin  = {0, 0, 0, 0},
	}
	local scroll_main = Panel:New{
		parent = window_main,
		--horizontalScrollbar = false,
		x = 0,
		y = 0,
		width='100%',
		bottom = 28,
		backgroundColor = {0,0,0,0},
	}
	local button_close = Button:New{
		parent = window_main,
		caption = 'Close', 
		OnMouseUp = { function(self) window_main:Dispose() end }, 
		right = 8,
		height = 24,
		bottom = 4,
	}
	--local scroll_main = window_main
	
	local panel_ship = Panel:New{
		parent = scroll_main,
		rows = 3,
		width = '100%',
		height = 270,
	}
	local panel_ship_id = Panel:New{
		parent = panel_ship,
		height = '75%',
		width = '100%',
		backgroundColor = {0,0,0,0},
	}
	local image_ship = Image:New {
		parent = panel_ship_id,
		width = "40%";
		height="100%";
		file = data.image,
		keepAspect = true,
	}
	local panel_ship_namedesc = Panel:New{
		parent = panel_ship_id,
		rows = 2,
		x = "40%",
		width = '60%',
		height = '50%',
		padding = {12, 5, 8, 5}
	}
	local label_shipname = Label:New{
		parent = panel_ship_namedesc;
		caption = data.name,
		y = 0,
		align="left";
		fontSize = 14;
		fontShadow = true;
	}
	local scroll_shipdesc = ScrollPanel:New{
		parent = panel_ship_namedesc;
		--horizontalScrollbar = false,
		x = 0,
		y = 18,
		padding = {5,5,5,5},
		height = "100%",
		width='100%',
		color = {0,0,0,0},
		borderColor = {0,0,0,0},
	}
	local textbox_shipdesc = TextBox:New{
		parent = scroll_shipdesc;
		text = data.desc,
		--y = "100%",
		width = "100%",
		align="left";
		fontSize = 12;
		fontShadow = true;
		backgroundColor = {0,0,0,0},
	}
	local panel_ship_stats = Panel:New{
		parent = panel_ship_id,
		x = "40%",
		y = "50%",
		width = '60%',
		height = '50%',
		backgroundColor = {0,0,0,0},
	}	
	local grid_ship_stats2 = Grid:New{
		parent = panel_ship,
		rows = 3,
		columns = 3,
		y = "70%",
		width = '100%',
		height = '30%',
	}
	local panel_hp = Panel:New{
		parent = panel_ship_stats;
		y = 0,
		width = "100%",
		height = "33%",
	}
	local label_hp = Label:New{
		parent = panel_hp;
		caption = "HP",
		height="100%";
		align="left";
		fontSize = 12;
		fontShadow = true;
		tooltip = "HP represents the ship's structural integrity. When a ship's HP drops to zero, it is destroyed or forced to withdraw.",
	}
	local hp, maxHP = Spring.GetUnitHealth(unitID)
	local progress_hp = Progressbar:New{
		parent  = panel_hp,
		x	= "20%",
		width   = "80%";
		height	= "100%",
		y = 0,
		max     = 1;
		value	= hp/maxHP;
		caption = math.floor(hp) .. "/" .. maxHP;
		color   = GetHealthColor(hp/maxHP);
	}
	local shieldOn, shieldPower = Spring.GetUnitShieldState(unitID)
	if shieldOn then
		local panel_shield = Panel:New{
			parent = panel_ship_stats;
			y = "33%",
			width = "100%",
			height = "33%",
			tooltip = "Shields provide a forward layer of defense against incoming weapons fire. They recharge slowly over time.",
		}
		local label_shield = Label:New{
			parent = panel_shield;
			caption = "Shield",
			height="100%";
			align="left";
			fontSize = 12;
			fontShadow = true;
		}
	end
	local maxEnergy = data.energy
	if maxEnergy then
		local energy = Spring.GetUnitRulesParam(unitID, "energy")
		local panel_energy = Panel:New{
			parent = panel_ship_stats;
			y = shieldOn and "66%" or "33%",
			width = "100%",
			height = "33%",
			tooltip = "Energy is required by the Elsior and the Emblem Frames to move and fight. Emblem Frames can restore energy from the Elsior's reserves.",
		}
		local label_energy = Label:New{
			parent = panel_energy;
			caption = "Energy",
			height="100%";
			align="left";
			fontSize = 12;
			fontShadow = true;
		}
		local progress_energy = Progressbar:New{
			parent  = panel_energy,
			x	= "20%",
			width   = "80%";
			height	= "100%",
			y = 0,
			max     = 1;
			value	= energy;
			caption = math.floor(energy*maxEnergy) .. "/" .. maxEnergy;
			color   = {1,1,0,1};
		}
	end
	
	
	local label_speed = InfoLabel:New{
		parent = grid_ship_stats2;
		caption = "Speed:\t"..data.speed,
		width="100%";
		align="left";
		fontSize = 13;
		fontShadow = true;
		tooltip = "This is how fast the ship moves when not fighting.",
	}
	local label_combatSpeed = InfoLabel:New{
		parent = grid_ship_stats2;
		caption = "Combat speed:\t"..data.combatSpeed,
		width="100%";
		align="left";
		fontSize = 13;
		fontShadow = true;
		tooltip = "The ship slows to this speed when making an attack run.",
	}
	local label_turnRate = InfoLabel:New{
		parent = grid_ship_stats2;
		caption = "Turn rate:\t"..data.turnrate,
		width="100%";
		align="left";
		fontSize = 13;
		fontShadow = true;
		tooltip = "This is how fast the ship turns.",
	}
	local label_combatRange = InfoLabel:New{
		parent = grid_ship_stats2;
		caption = "Combat range:\t"..data.combatRange,
		width="100%";
		align="left";
		fontSize = 13;
		fontShadow = true;
		tooltip = "This is the distance to the target at which the ship uses its combat speed, and how far away it flies before beginning another attack run.",
	}
	local label_armor = InfoLabel:New{
		parent = grid_ship_stats2;
		caption = "Armor:\t"..data.armor,
		width="100%";
		align="left";
		fontSize = 13;
		fontShadow = true;
		tooltip = "Armor reduces incoming damage by a percentage, depending on the weapon's damage type and armor penetration.",
	}
	local label_maneuverability = InfoLabel:New{
		parent = grid_ship_stats2;
		caption = "Maneuverability:\t"..data.maneuverability,
		width="100%";
		align="left";
		fontSize = 13;
		fontShadow = true;
		tooltip = "This is how fast the ship changes velocity.",
	}
	local label_ecm = InfoLabel:New{
		parent = grid_ship_stats2;
		caption = "ECM rating:\t"..data.ecm,
		width="100%";
		align="left";
		fontSize = 13;
		fontShadow = true;
		tooltip = "Every point of ECM increases the spread of incoming weapons fire (except missiles) by 1%.",
	}
	
	local scroll_weapons = ScrollPanel:New{
		parent = scroll_main,
		x = 0,
		y = 270,
		width='100%',
		height=150,
		padding = {5, 5, 5, 5},
	}
	CreateWeaponPanels(data, scroll_weapons)
	
	local panel_pilot = Panel:New{
		parent = scroll_main,
		y = 420,
		width = '100%',
		height = 125,
	}
	local panel_pilot_stats = Panel:New{
		parent = panel_pilot,
		x = "50%",
		y = 0,
		height = "100%",
		right = 0,
		backgroundColor = {0,0,0,0},
	}
	local image_pilot = Image:New {
		parent = panel_pilot,
		x = 6,
		width = 111,
		height= 125,
		file = pilot and pilot.portrait or nil,
		keepAspect = true,
	}
	local panel_pilot_biodata = Panel:New{
		parent = panel_pilot,
		rows = 3,
		columns = 2,
		x = 128,
		right = "50%",
		height = '100%',
		backgroundColor = {0,0,0,0},
		--[[
		itemMargin    = {0,0,0,0},
		itemPadding   = {0,0,0,0},
		resizeItems = true,
		centerItems = false
		]]
	}
	FillPilotBiodata(unitID, unitDefID, pilot, panel_pilot_biodata)
	
	local panel_morale = Panel:New{
		parent = panel_pilot_stats;
		y = 0,
		width = "100%",
		height = '33%',
		tooltip = "Angels with high morale get bonuses to accuracy, damage, and defense.",
	}
	local label_morale = Label:New{
		parent = panel_morale;
		caption = "Morale",
		height="100%";
		align="left";
		fontSize = 12;
		fontShadow = true;
		y = 2,
	}
	local morale = data.morale
	local progress_morale = Progressbar:New{
		parent  = panel_morale,
		x	= "30%",
		width   = "70%";
		height	= "100%",
		y = 0,
		max     = 100;
		value	= morale or 0,
		caption = morale and morale.."%" or "-";
		color   = {1,0.5,0.5,1};
	}
	local panel_spirit = Panel:New{
		parent = panel_pilot_stats;
		y = '33%',
		width = "100%",
		height = '33%',
		tooltip = "When the Angel's spirit is at maximum, she can use her special attack.",
	}
	local label_spirit = Label:New{
		parent = panel_spirit;
		caption = "Spirit",
		height="100%";
		align="left";
		fontSize = 12;
		fontShadow = true;
		y = 2,
	}
	local spirit = Spring.GetUnitRulesParam(unitID, "spirit")
	local progress_spirit = Progressbar:New{
		parent  = panel_spirit,
		x	= "30%",
		width   = "70%";
		height	= "100%",
		y = 0,
		max     = 100;
		value	= spirit or 0;
		caption = spirit and math.floor(spirit).."%" or "-";
		color   = {0,0.5,1,1};
	}
	local panel_suppression = Panel:New{
		parent = panel_pilot_stats;
		y = "66%",
		width = "100%",
		height = '33%',
		tooltip = "Suppression reduces the ship's rate of fire and accuracy.",
	}
	local label_suppression = Label:New{
		parent = panel_suppression;
		caption = "Suppression",
		height="100%";
		align="left";
		fontSize = 12;
		fontShadow = true;
		y = 2,
	}
	local suppression = Spring.GetUnitRulesParam(unitID, "suppression")
	local progress_suppression = Progressbar:New{
		parent  = panel_suppression,
		x	= "30%",
		width   = "70%";
		height	= "100%",
		y = 0,
		max     = 1;
		value	= suppression or 0;
		caption = suppression and math.floor(suppression*100).."%" or "-";
		color   = {1,0,0,1};
	}
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	--CreateStatsWindow(unitDefID)
end

function widget:MousePress(x,y,button)
	if button ~= 1 then return end
	
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	
	if alt then
		local type, data = Spring.TraceScreenRay(x, y)
		if (type == 'unit') then
			local unitID = data
			local unitDefID = (Spring.GetUnitDefID(unitID))
			local ud = UnitDefs[Spring.GetUnitDefID(unitID)]
			if ud then
				CreateStatsWindow(unitID, unitDefID)
			end
			-- FIXME enable later when does not show useless info MakeUnitContextMenu(unitID,x,y)
			return true
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:Initialize()
	-- setup Chili
	Chili = WG.Chili
	Button = Chili.Button
	Label = Chili.Label
	Window = Chili.Window
	Grid = Chili.Grid
	Panel = Chili.Panel
	ScrollPanel = Chili.ScrollPanel
	StackPanel = Chili.StackPanel
	TextBox = Chili.TextBox
	Image = Chili.Image
	Progressbar = Chili.Progressbar
	Control = Chili.Control
	screen0 = Chili.Screen0
	
	InfoLabel = Label:Inherit{}
	function InfoLabel:HitTest(x,y) return self end
	
	vsx,vsy = Spring.GetWindowGeometry()
	
	WG.CreateStatsWindow = CreateStatsWindow
end

function widget:Shutdown()
	WG.CreateStatsWindow = nil
end

function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = viewSizeX
	vsy = viewSizeY
end