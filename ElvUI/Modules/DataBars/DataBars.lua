local E, L, V, P, G = unpack(select(2, ...))
local mod = E:GetModule("DataBars")

local CreateFrame = CreateFrame
local GetExpansionLevel = GetExpansionLevel
local MAX_PLAYER_LEVEL_TABLE = MAX_PLAYER_LEVEL_TABLE

function mod:OnLeave()
	if (self == ElvUI_ExperienceBar and mod.db.experience.mouseover) or (self == ElvUI_ReputationBar and mod.db.reputation.mouseover) then
		E:UIFrameFadeOut(self, 1, self:GetAlpha(), 0)
	end
	GameTooltip:Hide()
end

function mod:CreateBar(name, onEnter, onClick, ...)
	local bar = CreateFrame("Button", name, E.UIParent)
	bar:Point(...)
	bar:SetScript("OnEnter", onEnter)
	bar:SetScript("OnLeave", mod.OnLeave)
	bar:SetScript("OnClick", onClick)
	bar:Hide()

	bar.statusBar = CreateFrame("StatusBar", nil, bar)
	bar.statusBar:SetInside()
	E:RegisterStatusBar(bar.statusBar)

	bar.text = bar.statusBar:CreateFontString(nil, "OVERLAY")
	bar.text:FontTemplate()

	return bar
end

function mod:PLAYER_LEVEL_UP(level)
	local maxLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]
	if (level ~= maxLevel or not self.db.experience.hideAtMaxLevel) and self.db.experience.enable then
		self:ExperienceBar_Update("PLAYER_LEVEL_UP", level)
	else
		self.expBar:Hide()
	end
end

function mod:CreateBarBubbles(bar)
	local bubbles = CreateFrame("Frame", "$parent_Bubbles", bar)
	bubbles:SetAllPoints()
	bubbles.textures = {}

	for i = 1, 19 do
		bubbles.textures[i] = bubbles:CreateTexture(nil, "OVERLAY")
		bubbles.textures[i]:SetTexture(0, 0, 0, 1)
	end

	bar.bubbles = bubbles

	return bubbles
end

function mod:UpdateBarBubbles(bar, db)
	if db.showBubbles then
		local vertical = db.orientation ~= "HORIZONTAL"
		local width = vertical and db.width or 1
		local height = not vertical and db.height or 1
		local offset = (vertical and db.height or db.width) / 20

		for i, texture in ipairs(bar.bubbles.textures) do
			texture:Size(width, height)
			texture:Point("TOPLEFT", bar, "TOPLEFT", vertical and 0 or offset * i, vertical and -offset * i or 0)
			texture:Show()
		end
	else
		for _, texture in ipairs(bar.bubbles.textures) do
			texture:Hide()
		end
	end
end

function mod:UpdateDataBarDimensions()
	self:ExperienceBar_UpdateDimensions()
	self:ReputationBar_UpdateDimensions()
end

function mod:Initialize()
	self.Initialized = true
	self.db = E.db.databars

	self.maxExpansionLevel = MAX_PLAYER_LEVEL_TABLE[GetAccountExpansionLevel()]

	self:ExperienceBar_Load()
	self:ReputationBar_Load()
end

local function InitializeCallback()
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)