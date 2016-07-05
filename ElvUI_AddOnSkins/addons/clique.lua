local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("Clique")) then return; end

function addon:Clique()
	local S = E:GetModule("Skins");
		
	CliqueSpellTab:StyleButton(nil, true);
	CliqueSpellTab:SetTemplate("Default", true);
	CliqueSpellTab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords));
	CliqueSpellTab:GetNormalTexture():SetInside();
	select(1, CliqueSpellTab:GetRegions()):Hide();

	local Frames = {
		CliqueDialog,
		CliqueConfig,
		CliqueConfigPage1,
		CliqueConfigPage2,
		CliqueClickGrabber,
		CliqueConfigBindAlert,
	}
	
	for _, object in pairs(Frames) do
		object:StripTextures()
		object:SetTemplate("Transparent")
	end
	
	
	local CliqueButtons = {
		CliqueConfigPage1ButtonSpell,
		CliqueConfigPage1ButtonOther,
		CliqueConfigPage1ButtonOptions,
		CliqueDialogButtonBinding,
		CliqueDialogButtonAccept,
		CliqueConfigPage2ButtonBinding,
		CliqueConfigPage2ButtonSave,
		CliqueConfigPage2ButtonCancel,
	}
	
	for _, object in pairs(CliqueButtons) do
		S:HandleButton(object, true)
	end
	
	CliqueConfigPage1:SetScript("OnShow", function(self)
		for i = 1, 12 do
			if _G["CliqueRow"..i] then
				_G["CliqueRow"..i.."Icon"]:SetTexCoord(unpack(E.TexCoords));
				_G["CliqueRow"..i.."Bind"]:ClearAllPoints()
				if _G["CliqueRow"..i] == CliqueRow1 then
					_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], 8,0)
				else
					_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], -9,0)
				end
				_G["CliqueRow"..i]:GetHighlightTexture():SetDesaturated(1)
			end
		end
		CliqueRow1:ClearAllPoints()
		CliqueRow1:SetPoint("TOPLEFT",5,-(CliqueConfigPage1Column1:GetHeight() +3))
	end)
	
	CliqueConfigPage1Column1:StripTextures()
	CliqueConfigPage1Column2:StripTextures()
	
	CliqueConfigPage1Column1:StyleButton()
	CliqueConfigPage1Column2:StyleButton()
	
	CliqueConfigPage1_VSlider:StripTextures(true)
	
	CliqueConfigInset:StripTextures()
	
	CliqueConfigBindAlertArrow:Kill()
	CliqueConfigBindAlert:SetPoint("BOTTOMLEFT", SpellButton1, "TOP", -48, 80)
	
	CliqueConfigPage1ButtonSpell:SetPoint('BOTTOMLEFT', CliqueConfig, 'BOTTOMLEFT', 3, 2)
	CliqueConfigPage1ButtonOptions:SetPoint('BOTTOMRIGHT', CliqueConfig, 'BOTTOMRIGHT', -5, 2)
	CliqueConfigPage2ButtonSave:SetPoint("BOTTOMLEFT", CliqueConfig,"BOTTOMLEFT", 3, 2)
	CliqueConfigPage2ButtonCancel:SetPoint('BOTTOMRIGHT', CliqueConfig, 'BOTTOMRIGHT', -5, 2)
	
	S:HandleScrollBar(CliqueScrollFrameScrollBar)
	
	S:HandleCloseButton(CliqueConfigCloseButton)
	S:HandleCloseButton(CliqueDialogCloseButton)

end

addon:RegisterSkin("Clique", addon.Clique);
