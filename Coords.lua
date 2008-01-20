local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")

local MODNAME = "Coords"
local Coords = Mapster:NewModule(MODNAME)

local GetCursorPosition = GetCursorPosition
local GetPlayerMapPosition = GetPlayerMapPosition
local WorldMapDetailFrame = WorldMapDetailFrame
local display, cursortext, playertext
local texttemplate, text = "%%s: %%.%df, %%.%df"

local MouseXY, OnUpdate

local db
local defaults = { 
	profile = {
		accuracy = 1,
	}
}

local optGetter, optSetter
do
	local mod = Coords
	function optGetter(info)
		local key = info[#info]
		return db[key]
	end
	
	function optSetter(info, value)
		local key = info[#info]
		db[key] = value
		mod:Refresh()
	end
end

local options = {
	coords = {
		type = "group",
		name = "Coordinates",
		arg = MODNAME,
		get = optGetter,
		set = optSetter,
		args = {
			intro = {
				order = 1,
				type = "description",
				name = "The Coordinates module adds a display of your current location, and the coordinates of your mouse cursor to the World Map frame.",
			},
			enabled = {
				order = 2,
				type = "toggle",
				name = "Enable Coordinates",
				get = function() return Mapster:GetModuleEnabled(MODNAME) end,
				set = function(info, value) Mapster:SetModuleEnabled(MODNAME, value) end,
			},
			accuracydesc = {
				order = 3,
				type = "description",
				name = "\nYou can control the accuracy of the coordinates, e.g. if you need very exact coordinates you can set this to 2.",
			},
			accuracy = {
				order = 4,
				type = "range",
				name = "Accuracy",
				min = 0, max = 2, step = 1,
			},
		},
	},
}

function Coords:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile
	
	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:InjectOptions(MODNAME, options)
end

function Coords:OnEnable()
	if not display then
		display = CreateFrame("Frame", "Mapster_CoordsFrame", WorldMapFrame)

		cursortext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		cursortext:SetPoint("RIGHT", WorldMapFrame, "CENTER", -50, -367)

		playertext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		playertext:SetPoint("LEFT", WorldMapFrame, "CENTER", 50, -367)
	end
	display:SetScript("OnUpdate", OnUpdate)
	display:Show()
	self:Refresh()
end

function Coords:OnDisable()
	display:SetScript("OnUpdate", nil)
	display:Hide()
end

function Coords:Refresh()
	db = self.db.profile
	text = texttemplate:format(db.accuracy, db.accuracy)
end

function MouseXY()
	local left, top = WorldMapDetailFrame:GetLeft(), WorldMapDetailFrame:GetTop()
	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()

	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height

	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		return
	end

	return cx, cy
end

function OnUpdate()
	local cx, cy = MouseXY()
	local px, py = GetPlayerMapPosition("player")

	if cx then
		cursortext:SetFormattedText(text, "Cursor", 100 * cx, 100 * cy)
	else
		cursortext:SetText("")
	end

	if px == 0 then
		playertext:SetText("")
	else
		playertext:SetFormattedText(text, "Player", 100 * px, 100 * py)
	end
end
