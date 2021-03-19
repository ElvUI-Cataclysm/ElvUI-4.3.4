local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local GetLootRollItemInfo = GetLootRollItemInfo
local GetItemQualityColor = GetItemQualityColor
local NUM_GROUP_LOOT_FRAMES = NUM_GROUP_LOOT_FRAMES

local function LoadSkin()
	if E.private.general.lootRoll then return end
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lootRoll then return end

	local function OnShow(self)
		local name = self:GetName()
		local _, _, _, quality = GetLootRollItemInfo(self.rollID)

		self:SetTemplate("Transparent")

		_G[name.."Corner"]:SetTexture()
		_G[name.."IconFrame"]:SetBackdropBorderColor(GetItemQualityColor(quality))
		_G[name.."Timer"]:SetStatusBarColor(GetItemQualityColor(quality))
	end

	for i = 1, NUM_GROUP_LOOT_FRAMES do
		local frame = _G["GroupLootFrame"..i]
		frame:StripTextures()
		frame:ClearAllPoints()
		frame:Point("TOP", i == 1 and AlertFrameHolder or _G["GroupLootFrame"..i - 1], "BOTTOM", 0, -4)

		local frameName = frame:GetName()

		local iconFrame = _G[frameName.."IconFrame"]
		iconFrame:SetTemplate()
		iconFrame:StyleButton()

		local icon = _G[frameName.."IconFrameIcon"]
		icon:SetInside()
		icon:SetTexCoord(unpack(E.TexCoords))

		local statusBar = _G[frameName.."Timer"]
		statusBar:StripTextures()
		statusBar:CreateBackdrop()
		statusBar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(statusBar)

		local decoration = _G[frameName.."Decoration"]
		decoration:SetTexture([[Interface\DialogFrame\UI-DialogBox-Gold-Dragon]])
		decoration:Size(130)
		decoration:Point("TOPLEFT", -37, 20)

		local pass = _G[frameName.."PassButton"]
		S:HandleCloseButton(pass, frame)

		_G["GroupLootFrame"..i]:HookScript("OnShow", OnShow)
	end
end

S:AddCallback("LootRoll", LoadSkin)