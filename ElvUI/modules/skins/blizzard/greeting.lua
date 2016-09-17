local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins');

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.greeting ~= true then return end

	QuestFrameGreetingPanel:HookScript("OnShow", function()
		QuestFrameGreetingPanel:StripTextures()

		S:HandleButton(QuestFrameGreetingGoodbyeButton, true)
		QuestFrameGreetingGoodbyeButton:Point("BOTTOMRIGHT", QuestFrameGreetingPanel, "BOTTOMRIGHT", -49, 72)

		GreetingText:SetTextColor(1, 1, 1)
		CurrentQuestsText:SetTextColor(1, 0.80, 0.10)
		AvailableQuestsText:SetTextColor(1, 0.80, 0.10)

		QuestGreetingFrameHorizontalBreak:Kill()

		S:HandleScrollBar(QuestGreetingScrollFrameScrollBar)

		for i=1, MAX_NUM_QUESTS do
			local button = _G["QuestTitleButton"..i]
			if button:GetFontString() then
				if button:GetFontString():GetText() and button:GetFontString():GetText():find("|cff000000") then
					button:GetFontString():SetText(string.gsub(button:GetFontString():GetText(), "|cff000000", "|cffFFFF00"))
				end
			end
		end
	end)
end

S:AddCallback("Greeting", LoadSkin);