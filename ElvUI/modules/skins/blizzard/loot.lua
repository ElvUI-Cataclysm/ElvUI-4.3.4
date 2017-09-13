local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins");

local _G = _G;
local unpack, select = unpack, select;

local UnitName = UnitName;
local IsFishingLoot = IsFishingLoot;
local GetLootRollItemInfo = GetLootRollItemInfo
local GetItemQualityColor = GetItemQualityColor
local SquareButton_SetIcon = SquareButton_SetIcon
local LOOTFRAME_NUMBUTTONS = LOOTFRAME_NUMBUTTONS;
local NUM_GROUP_LOOT_FRAMES = NUM_GROUP_LOOT_FRAMES
local LOOT = LOOT;

local function LoadSkin()
	if(E.private.general.loot) then return; end
	if(E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.loot ~= true) then return; end

	LootFrame:StripTextures();

	LootFrame:CreateBackdrop("Transparent")
	LootFrame.backdrop:Point("TOPLEFT", 13, -14);
	LootFrame.backdrop:Point("BOTTOMRIGHT", -75, 5);

	LootFramePortraitOverlay:SetParent(E.HiddenFrame);

	S:HandleCloseButton(LootCloseButton);
	LootCloseButton:Point("CENTER", LootFrame, "TOPRIGHT", -87, -26)

	for i = 1, LootFrame:GetNumRegions() do
		local region = select(i, LootFrame:GetRegions());
		if(region:GetObjectType() == "FontString") then
			if(region:GetText() == ITEMS) then
				LootFrame.Title = region;
			end
		end
	end

	LootFrame.Title:ClearAllPoints();
	LootFrame.Title:Point("TOPLEFT", LootFrame.backdrop, "TOPLEFT", 4, -4);
	LootFrame.Title:SetJustifyH("LEFT");

	for i = 1, LOOTFRAME_NUMBUTTONS do
		local button = _G["LootButton" .. i]
		local questTex = _G["LootButton"..i.."IconQuestTexture"]

		_G["LootButton" .. i .. "NameFrame"]:Hide()

		S:HandleItemButton(button, true)

		questTex:SetTexCoord(unpack(E.TexCoords))
		questTex:SetInside()
	end

	S:HandleNextPrevButton(LootFrameUpButton);
	SquareButton_SetIcon(LootFrameUpButton, "UP");
	LootFrameUpButton:Point("BOTTOMLEFT", 25, 20)

	S:HandleNextPrevButton(LootFrameDownButton);
	SquareButton_SetIcon(LootFrameDownButton, "DOWN");
	LootFrameDownButton:Point("BOTTOMLEFT", 143, 20)

	LootFrame:HookScript("OnShow", function(self)
		if(IsFishingLoot()) then
			self.Title:SetText(L["Fishy Loot"]);
		elseif(not UnitIsFriend("player", "target") and UnitIsDead("target")) then
			self.Title:SetText(UnitName("target"));
		else
			self.Title:SetText(LOOT);
		end
	end);
end

local function LoadRollSkin()
	if(E.private.general.lootRoll) then return; end
	if(not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lootRoll) then return; end

	local function OnShow(self)
		local cornerTexture = _G[self:GetName() .. "Corner"]
		local iconFrame = _G[self:GetName() .. "IconFrame"]
		local statusBar = _G[self:GetName() .. "Timer"]
		local _, _, _, quality = GetLootRollItemInfo(self.rollID)

		self:SetTemplate("Transparent")

		cornerTexture:SetTexture()

		iconFrame:SetBackdropBorderColor(GetItemQualityColor(quality))
		statusBar:SetStatusBarColor(GetItemQualityColor(quality))
	end

	for i = 1, NUM_GROUP_LOOT_FRAMES do
		local frame = _G["GroupLootFrame" .. i]
		frame:StripTextures();
		frame:ClearAllPoints();

		if(i == 1) then
			frame:Point("TOP", AlertFrameHolder, "BOTTOM", 0, -4);
		else
			frame:Point("TOP", _G["GroupLootFrame" .. i - 1], "BOTTOM", 0, -4);
		end

		local frameName = frame:GetName();

		local iconFrame = _G[frameName .. "IconFrame"];
		iconFrame:SetTemplate("Default");
		iconFrame:StyleButton()

		local icon = _G[frameName .. "IconFrameIcon"];
		icon:SetInside();
		icon:SetTexCoord(unpack(E.TexCoords));

		local statusBar = _G[frameName .. "Timer"];
		statusBar:StripTextures();
		statusBar:CreateBackdrop("Default");
		statusBar:SetStatusBarTexture(E["media"].normTex);
		E:RegisterStatusBar(statusBar);

		local decoration = _G[frameName .. "Decoration"];
		decoration:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Gold-Dragon");
		decoration:Size(130);
		decoration:Point("TOPLEFT", -37, 20);

		local pass = _G[frameName .. "PassButton"];
		S:HandleCloseButton(pass, frame);

		_G["GroupLootFrame" .. i]:HookScript("OnShow", OnShow);
	end
end

S:AddCallback("Loot", LoadSkin);
S:AddCallback("LootRoll", LoadRollSkin); 