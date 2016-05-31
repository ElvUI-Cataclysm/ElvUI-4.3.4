local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");
local S = E:GetModule("Skins");

if(not addon:CheckAddOn("DBM-Core")) then return; end

function addon:DBM(event, addonName)
	local db = E.db.addOnSkins;
	local function SkinBars(self)
		for bar in self:GetBarIterator() do
			if(not bar.injected) then
				hooksecurefunc(bar, "ApplyStyle", function()
					local frame = bar.frame;
					local tbar = _G[frame:GetName() .. "Bar"];
					local icon1 = _G[frame:GetName() .. "BarIcon1"];
					local icon2 = _G[frame:GetName() .. "BarIcon2"];
					local name = _G[frame:GetName() .. "BarName"];
					local timer = _G[frame:GetName() .. "BarTimer"];
					local spark = _G[frame:GetName() .. "BarSpark"];
					
					spark:Kill()
					
					if(not icon1.overlay) then
						icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar);
						icon1.overlay:SetTemplate("Default");
						icon1.overlay:SetFrameLevel(1);
						icon1.overlay:Point("BOTTOMRIGHT", frame, "BOTTOMLEFT", -(E.Border + E.Spacing), 0);
						
						local backdroptex = icon1.overlay:CreateTexture(nil, "BORDER");
						backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=]);
						backdroptex:SetInside(icon1.overlay);
						backdroptex:SetTexCoord(unpack(E.TexCoords));
					end
					
					if(not icon2.overlay) then
						icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar);
						icon2.overlay:SetTemplate("Default");
						icon2.overlay:SetFrameLevel(1);
						icon2.overlay:Point("BOTTOMLEFT", frame, "BOTTOMRIGHT", (E.Border + E.Spacing), 0);
						
						local backdroptex = icon2.overlay:CreateTexture(nil, "BORDER");
						backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=]);
						backdroptex:SetInside(icon2.overlay);
						backdroptex:SetTexCoord(unpack(E.TexCoords));
					end
					
					icon1.overlay:Size(db.dbmBarHeight);
					icon1:SetTexCoord(unpack(E.TexCoords));
					icon1:ClearAllPoints();
					icon1:SetInside(icon1.overlay);
					
					icon2.overlay:Size(E.db.addOnSkins.dbmBarHeight);
					icon2:SetTexCoord(unpack(E.TexCoords));
					icon2:ClearAllPoints();
					icon2:SetInside(icon2.overlay);
					
					tbar:SetInside(frame);
					
					frame:Height(E.db.addOnSkins.dbmBarHeight);
					frame:SetTemplate("Default");
					
					name:ClearAllPoints();
					name:Point("LEFT", frame, "LEFT", 4, 0.5);
					name:SetFont(E.LSM:Fetch("font", db.dbmFont), db.dbmFontSize, db.dbmFontOutline);
					
					timer:ClearAllPoints();
					timer:Point("RIGHT", frame, "RIGHT", -4, 0.5);
					timer:SetFont(E.LSM:Fetch("font", db.dbmFont), db.dbmFontSize, db.dbmFontOutline);
					
					if(bar.owner.options.IconLeft) then icon1.overlay:Show(); else icon1.overlay:Hide(); end
					if(bar.owner.options.IconRight) then icon2.overlay:Show(); else icon2.overlay:Hide(); end
					
					bar.injected = true;
				end);
				bar:ApplyStyle();
			end
		end
	end
	
	local SkinBoss = function()
		local count = 1;
		while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
			local bar = _G[format("DBM_BossHealth_Bar_%d", count)];
			local barname = bar:GetName();
			local background = _G[barname .. "BarBorder"];
			local progress = _G[barname .. "Bar"];
			local name = _G[barname .. "BarName"];
			local timer = _G[barname .. "BarTimer"];
			local pointa, anchor, pointb, _, _ = bar:GetPoint();
			
			if not pointa then return; end
			bar:ClearAllPoints();
			
			bar:Height(E.db.addOnSkins.dbmBarHeight);
			bar:SetTemplate("Transparent");
			
			background:SetNormalTexture(nil);
			
			progress:SetStatusBarTexture(E["media"].normTex);
			progress:ClearAllPoints();
			progress:SetInside(bar);
			
			name:ClearAllPoints();
			name:Point("LEFT", bar, "LEFT", 4, 0);
			name:SetFont(E.LSM:Fetch("font", db.dbmFont), db.dbmFontSize, db.dbmFontOutline);
			
			timer:ClearAllPoints();
			timer:Point("RIGHT", bar, "RIGHT", -4, 0)
			timer:SetFont(E.LSM:Fetch("font", db.dbmFont), db.dbmFontSize, db.dbmFontOutline);
			
			if(DBM.Options.HealthFrameGrowUp) then
				bar:Point(pointa, anchor, pointb, 0, count == 1 and 8 or 4);
			else
				bar:Point(pointa, anchor, pointb, 0, -(count == 1 and 8 or 4));
			end
			count = count + 1;
		end
	end
	
	local function SkinRange(self, range, filter)
		DBMRangeCheck:SetTemplate("Transparent");
	end
	
	hooksecurefunc(DBT, "CreateBar", SkinBars);
	hooksecurefunc(DBM.BossHealth, "Show", SkinBoss);
	hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss);
	hooksecurefunc(DBM.BossHealth, "UpdateSettings", SkinBoss);
	hooksecurefunc(DBM.RangeCheck, "Show", SkinRange);
	
	local RaidNotice_AddMessage_ = RaidNotice_AddMessage;
	RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
		if(textString:find(" |T")) then
			textString = string.gsub(textString, "(:12:12)", ":18:18:0:0:64:64:5:59:5:59");
		end
		return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo);
	end
	
	if(addonName == "DBM-GUI") then
		DBM_GUI_OptionsFrame:HookScript("OnShow", function(self)
			self:StripTextures();
			self:SetTemplate("Transparent");
			DBM_GUI_OptionsFrameBossMods:StripTextures();
			DBM_GUI_OptionsFrameBossMods:SetTemplate("Transparent");
			DBM_GUI_OptionsFrameDBMOptions:StripTextures();
			DBM_GUI_OptionsFrameDBMOptions:SetTemplate("Transparent");
			DBM_GUI_OptionsFramePanelContainer:SetTemplate("Transparent");
			DBM_GUI_Option_2:StripTextures();
			DBM_GUI_Option_13:StripTextures();
			DBM_GUI_Option_16:StripTextures();
			DBM_GUI_Option_24:StripTextures();
			DBM_GUI_Option_26:StripTextures();
			DBM_GUI_Option_31:StripTextures();
			DBM_GUI_Option_36:StripTextures();
			DBM_GUI_Option_43:StripTextures();
			DBM_GUI_Option_59:StripTextures();
			DBM_GUI_Option_75:StripTextures();
			DBM_GUI_Option_80:StripTextures();
			DBM_GUI_Option_87:StripTextures();
			DBM_GUI_Option_101:StripTextures();
			DBM_GUI_Option_108:StripTextures();
			DBM_GUI_Option_113:StripTextures();
			S:HandleButton(DBM_GUI_Option_8)
			S:HandleButton(DBM_GUI_Option_9)
			S:HandleButton(DBM_GUI_Option_10)
			S:HandleButton(DBM_GUI_Option_11)
			S:HandleButton(DBM_GUI_Option_22)
			S:HandleButton(DBM_GUI_Option_57)
			S:HandleButton(DBM_GUI_Option_52)
			S:HandleButton(DBM_GUI_Option_53)
			S:HandleButton(DBM_GUI_Option_54)
			S:HandleButton(DBM_GUI_Option_55)
			S:HandleButton(DBM_GUI_Option_60)
			S:HandleButton(DBM_GUI_Option_65)
			S:HandleButton(DBM_GUI_Option_66)
			S:HandleButton(DBM_GUI_Option_90)
			S:HandleButton(DBM_GUI_Option_91)
			S:HandleButton(DBM_GUI_Option_95)
			S:HandleButton(DBM_GUI_Option_99)
			S:HandleButton(DBM_GUI_Option_105)
			S:HandleButton(DBM_GUI_Option_106)
			S:HandleButton(DBM_GUI_Option_121)
			S:HandleButton(DBM_GUI_Option_124)
			S:HandleButton(DBM_GUI_Option_127)
			S:HandleButton(DBM_GUI_Option_130)
			S:HandleButton(DBM_GUI_Option_133)
			S:HandleButton(DBM_GUI_Option_136)
			S:HandleButton(DBM_GUI_Option_139)
			S:HandleButton(DBM_GUI_Option_142)
			S:HandleButton(DBM_GUI_Option_145)
			S:HandleCheckBox(DBM_GUI_Option_25)
			S:HandleCheckBox(DBM_GUI_Option_27)
			S:HandleCheckBox(DBM_GUI_Option_28)
			S:HandleCheckBox(DBM_GUI_Option_29)
			S:HandleCheckBox(DBM_GUI_Option_30)
			S:HandleCheckBox(DBM_GUI_Option_32)
			S:HandleCheckBox(DBM_GUI_Option_33)
			S:HandleCheckBox(DBM_GUI_Option_34)
			S:HandleCheckBox(DBM_GUI_Option_37)
			S:HandleCheckBox(DBM_GUI_Option_38)
			S:HandleCheckBox(DBM_GUI_Option_39)
			S:HandleCheckBox(DBM_GUI_Option_40)
			S:HandleCheckBox(DBM_GUI_Option_88)
			S:HandleCheckBox(DBM_GUI_Option_89)
			S:HandleCheckBox(DBM_GUI_Option_102)
			S:HandleCheckBox(DBM_GUI_Option_103)
			S:HandleCheckBox(DBM_GUI_Option_102)
			S:HandleCheckBox(DBM_GUI_Option_103)
			S:HandleCheckBox(DBM_GUI_Option_109)
			S:HandleCheckBox(DBM_GUI_Option_110)
			S:HandleCheckBox(DBM_GUI_Option_111)
			S:HandleCheckBox(DBM_GUI_Option_112)
			S:HandleCheckBox(DBM_GUI_Option_114)
			S:HandleCheckBox(DBM_GUI_Option_115)
			S:HandleCheckBox(DBM_GUI_Option_116)
			S:HandleCheckBox(DBM_GUI_Option_117)
			S:HandleSliderFrame(DBM_GUI_Option_92)
			S:HandleSliderFrame(DBM_GUI_Option_104)

			DBM_GUI_Option_17:StripTextures();
			DBM_GUI_Option_17:SetTemplate()
			DBM_GUI_Option_18:StripTextures();
			DBM_GUI_Option_18:SetTemplate()
			DBM_GUI_Option_19:StripTextures();
			DBM_GUI_Option_19:SetTemplate()
			DBM_GUI_Option_20:StripTextures();
			DBM_GUI_Option_20:SetTemplate()
		end);
		
		S:HandleButton(DBM_GUI_OptionsFrameOkay);
		S:HandleScrollBar(DBM_GUI_OptionsFramePanelContainerFOVScrollBar);
		
		S:HandleTab(DBM_GUI_OptionsFrameTab1);
		S:HandleTab(DBM_GUI_OptionsFrameTab2);
		
		addon:UnregisterSkinEvent("DBM", event);
	end
end

addon:RegisterSkin("DBM", addon.DBM, "ADDON_LOADED");