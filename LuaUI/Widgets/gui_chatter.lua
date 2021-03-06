
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
local IMAGE_HEIGHT = 125*0.8
local PANEL_HEIGHT = 36
local PANEL_HEIGHT_MINOR = 24
local NAME_WIDTH = 80

local TIME_KEEP_WINDOW_OPEN = 6
local CHATTER_DELAY_PER_UNIT = 5*30
local WARNING_OVERLAY_PERIOD = 0.5
local STATIC_OVERLAY_PERIOD = 0.1
local IDLE_CHATTER_INTERVAL = 15
local EVENT_DELAY_IDLE_CHATTER_BY = 3

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
local warningTexture = "LuaUI/Images/emergency.png"

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
local warningOverlayPhase = 0
local staticOverlayTimer = 0
local warningOverlayTimer = 0

local static = false
local warning = false
local whiteoutTimer = 0
local idleChatterTimer = 5
local idleChatterIndex = {}	-- [unitDefID] = index
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
		image:Dispose()
		--image.file = params.image
		--image.color = (params.warningOverlay) and {1,0.5,0.5,1} or {1,1,1,1}
		--image:Invalidate()
		--return
	end
	image = Image:New{
		parent = fakewindow,
		width = IMAGE_WIDTH,
		height = IMAGE_HEIGHT,
		y = 4;
		x = 5;
		keepAspect = true,
		file = params.image,
		file2 = "LuaUI/Images/portraits/frame.png",
		--color = (params.warningOverlay) and {1,0.5,0.5,1} or {1,1,1,1},
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
	warning = params.warningOverlay or false
	
	stackPanel:AddChild(panel)
	panel:SetLayer(1)
	table.insert(chatItems, 1, {panel = panel, name = nameLabel, textBox = textBox, image = params.image})
	ShowWindow()
	
	-- clear overflow
	if #chatItems > maxItems then
		local oldPanel = chatItems[#chatItems].panel
		oldPanel:Dispose()
		chatItems[#chatItems] = nil
	end
end

local function GetEventDialogue(params, unitID, unitDefID, minor, forceIndex)
	local data = pilotDefs[unitDefID]
	if not data then
		return
	end
	local items = data.dialogue[params.eventType]
	if (not items) or #items == 0 then
		return
	end
	
	if minor then
		return {text = items.minor, minor = true}
	end
	
	local choice = forceIndex or math.random(1,#items)
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
			idleChatterTimer = idleChatterTimer + EVENT_DELAY_IDLE_CHATTER_BY
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

local function ProcessIdleChatter()
	local unitID = WG.COFC and WG.COFC.GetThirdPersonTrackUnit()
	if not unitID then
		local units = Spring.GetSelectedUnits()
		if units then
			unitID = units[1]
		end
	end
	if not unitID then	-- give up
		return
	end
	local unitDefID = Spring.GetUnitDefID(unitID)
	idleChatterIndex[unitDefID] = idleChatterIndex[unitDefID] or 1
	local params = GetEventDialogue({eventType = "idle"}, unitID, unitDefID, nil, idleChatterIndex[unitDefID])
	if params then
		CreateEventPanel(params)
		SetUnitLastChatter(unitID, 40)
		idleChatterIndex[unitDefID] = idleChatterIndex[unitDefID] + 1
		if idleChatterIndex[unitDefID] > #(pilotDefs[unitDefID].dialogue.idle) then
			idleChatterIndex[unitDefID] = 1
		end
		idleChatterTimer = IDLE_CHATTER_INTERVAL
	end
end

local function DrawTextureOverlay(x,y,texture, width, height, flipX, flipY)
	gl.PushMatrix()
	gl.Color(1,1,1,1)
	gl.Translate(x,y,0)
	gl.Texture(texture)
	gl.TexRect(0, 0, width, -height, flipX, flipY)
	gl.PopMatrix()
end

local function DrawRect(xsize, ysize)
	gl.Vertex(0,0,0)
	gl.Vertex(xsize, 0, 0)
	gl.Vertex(xsize, ysize, 0)
	gl.Vertex(0, ysize, 0)
end

local function DrawColorOverlay(x,y, color)
	gl.PushMatrix()
	gl.Translate(x,y,0)
	gl.Color(color)
	gl.BeginEnd(GL.QUADS, DrawRect, IMAGE_WIDTH, -IMAGE_HEIGHT)
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
	warningOverlayTimer = warningOverlayTimer + dt
	if warningOverlayTimer > WARNING_OVERLAY_PERIOD then
		warningOverlayPhase = warningOverlayPhase%2 + 1
		warningOverlayTimer = 0
	end
	]]
	warningOverlayPhase = (warningOverlayPhase+dt)%1
	
	if timer_opened then
		local timer_now = spGetTimer()
		if spDiffTimers(timer_now, timer_opened) >= TIME_KEEP_WINDOW_OPEN then
			HideWindow(dt)
			timer_opened = nil
		end
	end
end

function widget:DrawScreen()
	if warning and not window.hidden then
		local x, y = image:LocalToScreen(0, 0)
		y = screen0.height - y
		DrawColorOverlay(x, y, {1, 0.2, 0.2, 0.4*warningOverlayPhase + 0.2})
		DrawTextureOverlay(x + 4, y - 80, warningTexture, 83, 16, false, true)
	end
	if static and not window.hidden then
		local x, y = image:LocalToScreen(0, 0)
		y = screen0.height - y
		DrawTextureOverlay(x, y, staticTexture, IMAGE_WIDTH, IMAGE_HEIGHT, staticOverlayPhase%2 == 0, (staticOverlayPhase+1)%2 == 0)
	end
	gl.Color(1,1,1,1)
end

function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOpts, cmdParams)
	if commands[cmdID] then
		if Spring.GetUnitRulesParam(unitID, "isUsingSpecial") == 0 then
			return
		end
		ProcessEvent("commandReceived", 5, unitID, unitDefID, unitTeam)
	end
end

function widget:GameFrame(f)
	gameframe = f
	if (f%30 == 0) and Spring.GetGameRulesParam("combatSuspended") ~= 1 then
		idleChatterTimer = idleChatterTimer - 1
		if idleChatterTimer <= 0 then
			ProcessIdleChatter()
		end
	end
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

