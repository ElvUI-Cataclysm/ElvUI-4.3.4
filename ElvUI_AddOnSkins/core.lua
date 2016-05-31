local addonName = ...;
local E, L, V, P, G, _ = unpack(ElvUI);
local EP = LibStub("LibElvUIPlugin-1.0", true);
local addon = E:NewModule("AddOnSkins", "AceHook-3.0", "AceEvent-3.0");

local find = string.find;
local match = string.match;
local trim = string.trim;

addon.skins = {};
addon.events = {};
addon.register = {};
addon.addOns = {};

for i = 1, GetNumAddOns() do
	local name, title, notes, enabled = GetAddOnInfo(i);
	addon.addOns[strlower(name)] = enabled ~= nil;
end

local function getOptions()
	local function GenerateOptionTable(skinName, order)
		local text = trim(skinName:gsub("^Blizzard_(.+)","%1"):gsub("(%l)(%u%l)","%1 %2"));
		local options = {
			type = "toggle",
			order = order,
			name = text,
			desc = L["TOGGLESKIN_DESC"],
		};
		return options;
	end
	
	local options = {
		order = 100,
		type = "group",
		name = L["AddOn Skins"],
		args = {
			addOns = {
				order = 1,
				type = "group",
				name = L["AddOn Skins"],
				guiInline = true,
				get = function(info) return E.private.addOnSkins[info[#info]]; end,
				set = function(info, value) E.private.addOnSkins[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {},
			},
			blizzard = {
				order = 2,
				type = "group",
				name = L["Blizzard Skins"],
				guiInline = true,
				get = function(info) return E.private.addOnSkins[info[#info]]; end,
				set = function(info, value) E.private.addOnSkins[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {},
			},
			misc = {
				order = 3,
				type = "group",
				name = L["Misc Options"],
				guiInline = true,
				args = {
					skadaGroup = {
						order = 1,
						type = "group",
						name = L["Skada"],
						get = function(info) return E.db.addOnSkins[info[#info]]; end,
						set = function(info, value) E.db.addOnSkins[info[#info]] = value; Skada:UpdateDisplay(); end,
						disabled = function() return not addon:CheckAddOn("Skada"); end,
						args = {
							skadaTemplate = {
								order = 1,
								type = "select",
								name = L["Skada Template"],
								values = {
									["Default"] = L["Default"],
									["Transparent"] = L["Transparent"]
								}
							},
							skadaTemplateGloss = {
								order = 2,
								type = "toggle",
								name = L["Skada Template Gloss"],
								disabled = function() return E.db.addOnSkins.skadaTemplate == "Transparent" or not addon:CheckAddOn("Skada"); end
							},
							spacer = {
								order = 3,
								type = "description",
								name = ""
							},
							skadaTitleTemplate = {
								order = 4,
								type = "select",
								name = L["Skada Title Template"],
								values = {
									["Default"] = L["Default"],
									["Transparent"] = L["Transparent"]
								}
							},
							skadaTitleTemplateGloss = {
								order = 5,
								type = "toggle",
								name = L["Skada Title Template Gloss"],
								disabled = function() return E.db.addOnSkins.skadaTitleTemplate == "Transparent" or not addon:CheckAddOn("Skada"); end
							}
						}
					},
					dbmGroup = {
						order = 2,
						type = "group",
						name = L["DBM"],
						get = function(info) return E.db.addOnSkins[info[#info]]; end,
						set = function(info, value) E.db.addOnSkins[info[#info]] = value; DBM.Bars:ApplyStyle(); DBM.BossHealth:UpdateSettings(); end,
						disabled = function() return not addon:CheckAddOn("DBM-Core"); end,
						args = {
							dbmBarHeight = {
								order = 1,
								type = "range",
								name = "Bar Height",
								min = 6, max = 60,
								step = 1
							},
							dbmFont = {
								order = 2,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font
							},
							dbmFontSize = {
								order = 3,
								type = "range",
								name = L["Font Size"],
								min = 6, max = 22, step = 1
							},
							dbmFontOutline = {
								order = 4,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = L["None"],
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE"
								}
							}
						}
					},
					waGroup = {
						order = 3,
						type = "group",
						name = L["WeakAuras"],
						get = function(info) return E.db.addOnSkins[info[#info]]; end,
						set = function(info, value) E.db.addOnSkins[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						disabled = function() return not addon:CheckAddOn("WeakAuras"); end,
						args = {
							weakAuraAuraBar = {
								order = 1,
								type = "toggle",
								name = L["AuraBar Backdrop"]
							},
							weakAuraIconCooldown = {
								order = 2,
								type = "toggle",
								name = L["Icon Cooldown"]
							}
						}
					}
				}
			},
			embed = {
				order = 4,
				type = "group",
				name = "Embed Settings",
				get = function(info) return E.db.addOnSkins.embed[ info[#info] ] end,
				set = function(info, value) E.db.addOnSkins.embed[ info[#info] ] = value; E:GetModule("EmbedSystem"):Check() end,
				args = {
					desc = {
						order = 1,
						type = "description",
						name = "Settings to control Embedded AddOns: Available Embeds: Omen | Skada | Recount ",
					},
					embedType = {
						order = 2,
						type = "select",
						name = L["Embed Type"],
						values = {
							["DISABLE"] = L["Disable"],
							["SINGLE"] = L["Single"],
							["DOUBLE"] = L["Double"]
						},
					},
					left = {
						order = 3,
						type = "select",
						name = L["Left Panel"],
						values = {
							["Recount"] = "Recount",
							["Omen"] = "Omen",
							["Skada"] = "Skada"
						},
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end,
					},
					right = {
						order = 4,
						type = "select",
						name = L["Right Panel"],
						values = {
							["Recount"] = "Recount",
							["Omen"] = "Omen",
							["Skada"] = "Skada"
						},
						disabled = function() return E.db.addOnSkins.embed.embedType ~= "DOUBLE" end,
					},
					leftWidth = {
						type = "range",
						order = 5,
						name = "Embed Left Window Width",
						min = 100,
						max = 300,
						step = 1,
					},
					hideChat = {
						name = "Hide Chat Frame",
						order = 6,
						type = "select",
						values = E:GetModule("EmbedSystem"):GetChatWindowInfo(),
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end,
					},
					rightChat = {
						type = "toggle",
						name = "Embed into Right Chat Panel",
						order = 7,
					},
					belowTop = {
						type = "toggle",
						name = "Embed Below Top Tab",
						order = 8,
					},
				},
			},
		},
	}
	
	local order, blizzorder = 0, 0;
	for skinName, _ in addon:OrderedPairs(addon.register) do
		if(find(skinName, "Blizzard_")) then
			options.args.blizzard.args[skinName] = GenerateOptionTable(skinName, blizzorder);
			blizzorder = blizzorder + 1;
		else
			options.args.addOns.args[skinName] = GenerateOptionTable(skinName, order);
			order = order + 1;
		end
	end
	
	E.Options.args.addOnSkins = options;
end

function addon:CheckOption(optionName, ...)
	for i = 1, select("#", ...) do
		local addon = select(i, ...);
		if(not addon) then break; end
		if(not IsAddOnLoaded(addon)) then return false; end
	end
	return E.private.addOnSkins[optionName];
end

function addon:SetOption(optionName, value)
	E.private.addOnSkins[optionName] = value;
end

function addon:DisableOption(optionName)
	addon:SetOption(optionName, false);
end

function addon:EnableOption(optionName)
	addon:SetOption(optionName, true);
end

function addon:ToggleOption(optionName)
	E.private.addOnSkins[optionName] = not E.private.addOnSkins[optionName];
end

function addon:CheckAddOn(addon)
	return self.addOns[strlower(addon)] or false;
end

function addon:OrderedPairs(t, f)
	local a = {};
	for n in pairs(t) do tinsert(a, n); end
	sort(a, f);
	local i = 0;
	local iter = function()
		i = i + 1;
		if(a[i] == nil) then
			return nil;
		else
			return a[i], t[a[i]];
		end
	end
	return iter;
end

function addon:RegisterSkin(skinName, skinFunc, ...)
	local events = {};
	local priority = 1;
	for i = 1, select("#", ...) do
		local event = select(i, ...);
		if(not event) then
			break;
		end
		
		if(type(event) == "number") then
			priority = event;
		else
			events[event] = true;
		end
	end
	local registerMe = {func = skinFunc, events = events, priority = priority};
	if(not self.register[skinName]) then
		self.register[skinName] = {};
	end
	self.register[skinName][skinFunc] = registerMe;
end

function addon:GenerateEventFunction(event)
	local eventHandler = function(self, event, ...)
		for skin, funcs in pairs(self.skins) do
			if(self:CheckOption(skin) and self.events[event][skin]) then
				for _, func in ipairs(funcs) do
					self:CallSkin(skin, func, event, ...);
				end
			end
		end
	end
	return eventHandler;
end

function addon:RegisteredSkin(skinName, priority, func, events)
	local events = events;
	for c, _ in pairs(events) do
		if(find(c, "%[")) then
			local conflict = match(c, "%[([!%w_]+)%]");
			if(self:CheckAddOn(conflict)) then
				return;
			end
		end
	end
	
	if(not self.skins[skinName]) then
		self.skins[skinName] = {};
	end
	self.skins[skinName][priority] = func;
	
	for event, _ in pairs(events) do
		if(not find(event, "%[")) then
			if(not self.events[event]) then
				self[event] = self:GenerateEventFunction(event);
				self:RegisterEvent(event);
				self.events[event] = {};
			end
			self.events[event][skinName] = true;
		end
	end
end

function addon:CallSkin(skin, func, event, ...)
	local pass, errormsg = pcall(func, self, event, ...);
	if(not pass) then
		local errormessage = "%s Error: %s";
		--if(self:CheckOption("SkinDebug")) then
			if(GetCVarBool("scriptErrors")) then
				LoadAddOn("Blizzard_DebugTools");
				ScriptErrorsFrame_OnError(errormsg, false);
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(errormessage, skin, errormsg));
			end
		--end
	end
end

function addon:UnregisterSkinEvent(skinName, event)
	if(not addon.events[event]) then return; end
	if(not addon.events[event][skinName]) then return; end
	addon.events[event][skinName] = nil;
	local found = false;
	for skin,_ in pairs(addon.events[event]) do
		if(skin) then
			found = true;
			break;
		end
	end
	if(not found) then
		addon:UnregisterEvent(event);
	end
end

function addon:Initialize()
	EP:RegisterPlugin(addonName, getOptions);
	
	for skin, alldata in pairs(self.register) do
		for _, data in pairs(alldata) do
			self:RegisteredSkin(skin, data.priority, data.func, data.events);
		end
	end
	
	for skin, funcs in pairs(self.skins) do
		if self:CheckOption(skin) then
			for _, func in ipairs(funcs) do
				self:CallSkin(skin, func, event);
			end
		end
	end
end

E:RegisterModule(addon:GetName());