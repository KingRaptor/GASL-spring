
function widget:GetInfo()
	return {
		name = "Combat Chatter",
		desc = "Talking is a free action",
		author = "KingRaptor (L.J. Lim)",
		date = "July 30th, 2009",
		license = "Public Domain",
		layer = 0,
		enabled = true
	}
end

--------------------------------------------------------------------------------
-- speedups
local spGetGameFrame = Spring.GetGameFrame
local spIsUnitAllied = Spring.IsUnitAllied
local spGetTimer     = Spring.GetTimer
local spDiffTimers   = Spring.DiffTimers

--------------------------------------------------------------------------------
--  CONFIG
--------------------------------------------------------------------------------
VFS.Include("LuaUI/Configs/chatter/general.lua")
VFS.Include("LuaRules/Configs/customcmds.h.lua")

local WINDOW_WIDTH = 540
local WINDOW_HEIGHT = 144
local IMAGE_WIDTH = 89
local IMAGE_HEIGHT = 100
local PANEL_HEIGHT = 48
local PANEL_HEIGHT_MINOR = 24
local NAME_WIDTH = 80
local TIME_KEEP_WINDOW_OPEN = 6
local CHATTER_DELAY_PER_UNIT = 5*30
local WARNING_OVERLAY_PERIOD = 0.5
local STATIC_OVERLAY_PERIOD = 0.1

local commands = {	-- TODO
	[CMD.ATTACK] = true,
	[CMD.FIGHT] = true,
	[CMD.MOVE] = true,
	[CMD.PATROL] = true,
	[CMD.GUARD] = true,
	[CMD_RESUPPLY] = true,
}

local maxItems = 12	-- TODO delegate to Epic Menu
local staticTexture  = "LuaUI/Images/overlay_static1.png"

local gameframe = spGetGameFrame()
--------------------------------------------------------------------------------
-- Chili classes
local Chili
local Button
local Label
local Window
local Panel
local TextBox
local Image
local ScrollPanel
local StackPanel

local timer_opened
local hidingWindow = false
--------------------------------------------------------------------------------
-- Chili instances
local chatItems = {}	-- [1] = {panel = panel, image = image, name = name, textbox = textbox, sound = sound}
local screen0
local window
local fakewindow
local scrollPanel
local stackPanel
local image
--------------------------------------------------------------------------------
-- variables
local lastChatterByUnit = {}	-- [unitID] = {gameframe=n, priority=x}
local staticOverlayPhase = 1
local warningOverlayPhase = 1
local staticOverlayTimer = 0
local warningOverlayTimer = 0

local static = false
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function HideWindow(dt)
	if not window.hidden then
		--[[
		local alpha = window.color[4]
		alpha = alpha - dt/WINDOW_HIDE_TIME
		if alpha < = 0 then
			alpha = 0
			hidingWindow = false
		end
		window:SetColor({1,1,1,alpha})
		]]--
		image.file = nil
		image:Invalidate()
		screen0:RemoveChild(window)
		window.hidden = true
	end
end

local function ShowWindow()
	--window:SetColor({1,1,1,1})
	if window.hidden then
		window.hidden = false
		screen0:AddChild(window)
	end
	timer_opened = spGetTimer()
end

local function CreateImage(params)
	if image then
		--image:Dispose()
		image.file = params.image
		image.color = (params.warningOverlay) and {1,0.5,0.5,1} or {1,1,1,1}
		image:Invalidate()
		return
	end
	image = Image:New{
		parent = fakewindow,
		width = IMAGE_WIDTH,
		height = IMAGE_HEIGHT,
		y = 4;
		x = 5;
		keepAspect = true,
		file = params.image,
		color = (params.warningOverlay) and {1,0.5,0.5,1} or {1,1,1,1},
	}
end

local function SetUnitLastChatter(unitID, priority)
	lastChatterByUnit[unitID] = {priority = priority, gameframe = gameframe}
end

local function CreateEventPanel(params)
	local panel = Panel:New{
		width = "100%",
		height = params.minor and PANEL_HEIGHT_MINOR or PANEL_HEIGHT,	-- FIXME might want to get text height instead of hardcoding
		backgroundColor = {0,0,0,0},
		padding = {8, 6, 8, 6},
	}
	local nameLabel
	if not params.minor then
		nameLabel = Label:New{
			parent = panel;
			caption = params.name,
			x = 0,
			y = 0,
			width = NAME_WIDTH,
			height = "100%",
			align="left";
			fontSize = 14;
			fontShadow = true;
		}
	end
	textBox = TextBox:New{
		parent = panel,
		text = params.text,
		x = params.minor and NAME_WIDTH/2 or NAME_WIDTH,
		right = 5,
		align="left";
		fontSize = 13;
		fontShadow = true;
		backgroundColor = {0,0,0,0},
	}
	if params.image then
		CreateImage(params)
	elseif not params.minor then
		Spring.Log(widget.GetInfo().name, "warning", "Missing image for event " .. params.eventType .. ", pilot " .. params.name .. " with text \"" .. params.text .. "\"" )
	end
	
	static = params.staticOverlay or false
	
	stackPanel:AddChild(panel, nil, 1)
	table.insert(chatItems, 1, {panel = panel, name = nameLabel, textBox = textBox, image = params.image})
	ShowWindow()
	
	-- clear overflow
	if #chatItems > maxItems then
		local oldPanel = chatItems[#chatItems].panel
		oldPanel:Dispose()
		chatItems[#chatItems] = nil
	end
end

local function GetEventDialogue(params, unitID, unitDefID, minor)
	local data = pilotDefs[unitDefID]
	if not data then
		return
	end
	local items = data.dialogue[params.eventType]
	if not items then
		return
	end
	
	if minor then
		return {text = items.minor, minor = true}
	end
	
	local choice = math.random(#items)
	local selected = items[choice]
	local text, image, sound = selected.text, selected.image, selected.sound
	return {name = selected.name or data.name, text = text, image = image,
		sound = sound, eventType = params.eventType,
		warningOverlay = params.warningOverlay, staticOverlay = params.staticOverlay}
end

local function ProcessEvent(eventType, magnitude, unitID, unitDefID, unitTeam, unitID2, unitDefID2, unitTeam2, force)
	local eventDef = eventDefs[eventType]
	if not eventDef then
		Spring.Log(widget:GetInfo().name, LOG.WARNING, "missing definition for event " .. eventType)
		return
	end
	if not unitID then
		return
	end
	
	local params = {eventType = eventType, magnitude = magnitude, unitID = unitID, unitDefID = unitDefID,
		unitTeam = unitTeam, unitID2 = unitID2, unitDefID2 = unitDefID2, unitTeam2 = unitTeam2,
		warningOverlay = eventDef.warningOverlay, staticOverlay = eventDef.staticOverlay }
	
	local isEnemy = not spIsUnitAllied(unitID)
	local priority = (isEnemy and eventDef.priorityEnemy) or eventDef.priority or eventDef.priorityFunc(eventDef, params, isEnemy)
	local chance = math.random() * 100
	
	-- prevents one unit from hogging the mike with minor events
	local limitChatter = false
	local lastChatter = lastChatterByUnit[unitID]
	if lastChatter and ((lastChatter.gameframe + CHATTER_DELAY_PER_UNIT) > gameframe) then
		limitChatter = (lastChatter.priority > priority)
	end
	limitChatter = limitChatter or (eventDef.lastEvent + eventDef.maxPeriod > gameframe)
	
	if force or ( ((chance-eventDef.queueRating) < priority) and (not limitChatter)) then
		-- print full event
		local eventParams = GetEventDialogue(params, unitID, unitDefID)
		if eventParams then
			CreateEventPanel(eventParams)
			eventDef.queueRating = 0
			eventDef.lastEvent = gameframe
			SetUnitLastChatter(unitID, priority)
		end
	else
		-- increase chance of future event being reported
		if magnitude and magnitude ~= 0 then
			eventDef.queueRating = eventDef.queueRating + magnitude*eventDef.magnitudeQueueMult
		end
		-- print minor event
		if eventDef.allowMinorEvent and (not isEnemy) then
			local eventParams = GetEventDialogue(params, unitID, unitDefID, true)
			if eventParams then
				CreateEventPanel(eventParams)
				SetUnitLastChatter(unitID, priority)
			end
		end
	end
end

local function DrawOverlay(x,y,texture, flipX, flipY)
	gl.PushMatrix()
	gl.Translate(x,y,0)
	gl.Texture(texture)
	gl.TexRect(0, 0, IMAGE_WIDTH, -IMAGE_HEIGHT, flipX, flipY)
	gl.PopMatrix()
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:Update(dt)
	staticOverlayTimer = staticOverlayTimer + dt
	if staticOverlayTimer > STATIC_OVERLAY_PERIOD then
		staticOverlayPhase = staticOverlayPhase%4 + 1
		staticOverlayTimer = 0
	end
	
	--[[
	warningOverlayPhase = warningOverlayPhase + dt
	if warningOverlayTimer > STATIC_OVERLAY_PERIOD then
		warningOverlayPhase = warningOverlayPhase%2 + 1
		warningOverlayTimer = 0
	end
	]]
	
	if timer_opened then
		local timer_now = spGetTimer()
		if spDiffTimers(timer_now, timer_opened) >= TIME_KEEP_WINDOW_OPEN then
			HideWindow(dt)
			timer_opened = nil
		end
	end
end

function widget:DrawScreen()
	if static and not window.hidden then
		local x, y = image:LocalToScreen(0, 0)
		y = screen0.height - y
		DrawOverlay(x, y, staticTexture, staticOverlayPhase%2 == 0, (staticOverlayPhase+1)%2 == 0)
	end
end

function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOpts, cmdParams)
	if commands[cmdID] then
		ProcessEvent("commandReceived", 5, unitID, unitDefID, unitTeam)
	end
end

function widget:GameFrame(f)
	gameframe = f
end

function widget:Initialize()
	-- setup Chili
	Chili = WG.Chili
	Button = Chili.Button
	Label = Chili.Label
	Window = Chili.Window
	Panel = Chili.Panel
	TextBox = Chili.TextBox
	Image = Chili.Image
	ScrollPanel = Chili.ScrollPanel
	StackPanel = Chili.StackPanel
	screen0 = Chili.Screen0
	
	window = Window:New{
		parent = screen0,
		name   = 'chatterwindow';
		width = WINDOW_WIDTH,
		height = WINDOW_HEIGHT,
		x = (screen0.width-WINDOW_WIDTH) / 2, 
		y = 0,
		dockable = true;
		draggable = false,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = false,
		backgroundColor = {0,0,0,0},
		padding = {0, 0, 0, 0},
		--itemMargin  = {0, 0, 0, 0},
		hidden = false,
	}
	fakewindow = Panel:New{
		parent = window,
		padding = {6, 6, 6, 6},
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
	}
	
	scrollPanel = ScrollPanel:New{
		parent = fakewindow,
		right	= 4,
		y	= 4,
		bottom  = 4,
		x	= IMAGE_WIDTH + 5 + 5,
		horizontalScrollbar = false,
		padding = {2, 2, 2, 2},
	}
	
	stackPanel = StackPanel:New{
		parent = scrollPanel,
		resizeItems = false,
		width = "100%",
		height = "100%",
		x = 0,
		y = 0,
		autosize = true,
		padding = {0,0,0,0},
		itemMargin = {0, 0, 0, 0},
		autoArrangeV = true,
	}
	
	CreateImage({})
	HideWindow()
	widgetHandler:RegisterGlobal("ChatterEvent", ProcessEvent)
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("ChatterEvent")
end

