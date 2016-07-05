local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("Skada")) then return; end

function addon:Skada()
	local SkadaDisplayBar = Skada.displays['bar']

	hooksecurefunc(SkadaDisplayBar, 'AddDisplayOptions', function(self, win, options)
		options.baroptions.args.barspacing = nil
		options.titleoptions.args.texture = nil
		options.titleoptions.args.bordertexture = nil
		options.titleoptions.args.thickness = nil
		options.titleoptions.args.margin = nil
		options.titleoptions.args.color = nil
		options.windowoptions = nil
	end)
	
	hooksecurefunc(SkadaDisplayBar, 'ApplySettings', function(self, win)
		local skada = win.bargroup
		skada:SetSpacing(1)
		skada:SetFrameLevel(5)
		skada:SetBackdrop(nil)
		
		if(win.db.enabletitle) then
			skada.button:SetBackdrop(nil);
			if(not skada.button.backdrop) then
				skada.button:CreateBackdrop();
				skada.button.backdrop:SetFrameLevel(skada.button:GetFrameLevel());
			end
			skada.button.backdrop:SetTemplate(E.db.addOnSkins.skadaTitleTemplate, E.db.addOnSkins.skadaTitleTemplate == "Default" and E.db.addOnSkins.skadaTitleTemplateGloss or false);
		end
		if not skada.backdrop then
			skada:SetTemplate(E.db.addOnSkins.skadaTemplate, E.db.addOnSkins.skadaTemplate == "Default" and E.db.addOnSkins.skadaTemplateGloss or false);
		end
		if(skada.backdrop) then
			skada.backdrop:ClearAllPoints();
			if(win.db.reversegrowth) then
				skada.backdrop:SetPoint("LEFT", skada.button, "LEFT", -E.Border, 0);
				skada.backdrop:SetPoint("RIGHT", skada.button, "RIGHT", E.Border, 0);
				skada.backdrop:SetPoint("BOTTOM", skada.button, "TOP", 0, win.db.enabletitle and (E.Spacing) or -win.db.barheight - E.Border);
			else
				skada.backdrop:SetPoint("LEFT", skada.button, "LEFT", -E.Border, 0);
				skada.backdrop:SetPoint("RIGHT", skada.button, "RIGHT", E.Border, 0);
				skada.backdrop:SetPoint("TOP", skada.button, "BOTTOM", 0, win.db.enabletitle and -(E.Spacing) or win.db.barheight + E.Border);
			end
		end
	end)
	
	local module = E:GetModule("EmbedSystem");
	hooksecurefunc(Skada, "CreateWindow", function()
		if(module:CheckAddOn("Skada")) then
			module:Skada();
		end
	end);
	
	hooksecurefunc(Skada, "DeleteWindow", function()
		if(module:CheckAddOn("Skada")) then
			module:Skada();
		end
	end);
	
	hooksecurefunc(Skada, "UpdateDisplay", function()
		if(module:CheckAddOn("Skada") and not InCombatLockdown()) then
			module:Skada();
		end
	end);

	hooksecurefunc(Skada, "SetTooltipPosition", function(self, tt, frame)
		local p = self.db.profile.tooltippos;
		if(p == "default") then
			if(not E:HasMoverBeenMoved("TooltipMover")) then
				if ElvUI_ContainerFrame and ElvUI_ContainerFrame:IsShown() then
					tt:SetPoint("BOTTOMRIGHT", ElvUI_ContainerFrame, "TOPRIGHT", 0, 18)	
				elseif RightChatPanel:GetAlpha() == 1 and RightChatPanel:IsShown() then
					tt:SetPoint("BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", 0, 18)		
				else
					tt:SetPoint("BOTTOMRIGHT", RightChatPanel, "BOTTOMRIGHT", 0, 18)
				end
			else
				local point = E:GetScreenQuadrant(TooltipMover);
				if(point == "TOPLEFT") then
					tt:SetPoint("TOPLEFT", TooltipMover);
				elseif(point == "TOPRIGHT") then
					tt:SetPoint("TOPRIGHT", TooltipMover);
				elseif(point == "BOTTOMLEFT" or point == "LEFT") then
					tt:SetPoint("BOTTOMLEFT", TooltipMover);
				else
					tt:SetPoint("BOTTOMRIGHT", TooltipMover);
				end
			end
	   end
	end);
end

addon:RegisterSkin("Skada", addon.Skada);