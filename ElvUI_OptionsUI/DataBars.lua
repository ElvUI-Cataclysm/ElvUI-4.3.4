local E, _, V, P, G = unpack(ElvUI)
local C, L = unpack(select(2, ...))
local mod = E:GetModule("DataBars")

local textValues = {
	NONE = L["NONE"],
	CUR = L["Current"],
	REM = L["Remaining"],
	PERCENT = L["Percent"],
	CURMAX = L["Current - Max"],
	CURPERC = L["Current - Percent"],
	CURREM = L["Current - Remaining"],
	CURPERCREM = L["Current - Percent (Remaining)"]
}

local positionValues = {
	TOP = L["Top"],
	LEFT = L["Left"],
	RIGHT = L["Right"],
	BOTTOM = L["Bottom"],
	CENTER = L["Center"],
	TOPLEFT = L["Top Left"],
	TOPRIGHT = L["Top Right"],
	BOTTOMLEFT = L["Bottom Left"],
	BOTTOMRIGHT = L["Bottom Right"]
}

E.Options.args.databars = {
	order = 2,
	type = "group",
	name = L["DataBars"],
	childGroups = "tab",
	get = function(info) return E.db.databars[info[#info]] end,
	set = function(info, value) E.db.databars[info[#info]] = value end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["DATABAR_DESC"]
		},
		spacer = {
			order = 2,
			type = "description",
			name = ""
		},
		experience = {
			order = 3,
			type = "group",
			name = L["XPBAR_LABEL"],
			get = function(info) return mod.db.experience[info[#info]] end,
			set = function(info, value) mod.db.experience[info[#info]] = value mod:ExperienceBar_UpdateDimensions() end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["ENABLE"],
					set = function(info, value) mod.db.experience[info[#info]] = value mod:ExperienceBar_Toggle() end
				},
				spacer = {
					order = 2,
					type = "description",
					name = " "
				},
				width = {
					order = 3,
					type = "range",
					name = L["Width"],
					min = 5, max = ceil(GetScreenWidth() or 800), step = 1,
					disabled = function() return not mod.db.experience.enable end
				},
				height = {
					order = 4,
					type = "range",
					name = L["Height"],
					min = 5, max = ceil(GetScreenHeight() or 800), step = 1,
					disabled = function() return not mod.db.experience.enable end
				},
				statusbar = {
					order = 5,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["StatusBar Texture"],
					values = AceGUIWidgetLSMlists.statusbar,
					disabled = function() return not mod.db.experience.enable end
				},
				orientation = {
					order = 6,
					type = "select",
					name = L["Statusbar Fill Orientation"],
					desc = L["Direction the bar moves on gains/losses"],
					values = {
						HORIZONTAL = L["Horizontal"],
						VERTICAL = L["Vertical"]
					},
					disabled = function() return not mod.db.experience.enable end
				},
				transparent = {
					order = 7,
					type = "toggle",
					name = L["Transparent"],
					disabled = function() return not mod.db.experience.enable end
				},
				reverseFill = {
					order = 8,
					type = "toggle",
					name = L["Reverse Fill Direction"],
					disabled = function() return not mod.db.experience.enable end
				},
				showBubbles = {
					order = 9,
					type = "toggle",
					name = L["Show Bubbles"],
					disabled = function() return not mod.db.experience.enable end
				},
				clickThrough = {
					order = 10,
					type = "toggle",
					name = L["Click Through"],
					disabled = function() return not mod.db.experience.enable end
				},
				mouseover = {
					order = 11,
					type = "toggle",
					name = L["Mouseover"],
					disabled = function() return not mod.db.experience.enable end
				},
				hideInVehicle = {
					order = 12,
					type = "toggle",
					name = L["Hide In Vehicle"],
					set = function(info, value) mod.db.experience[info[#info]] = value mod:ExperienceBar_Update() end,
					disabled = function() return not mod.db.experience.enable end
				},
				hideInCombat = {
					order = 13,
					type = "toggle",
					name = L["Hide In Combat"],
					set = function(info, value) mod.db.experience[info[#info]] = value mod:ExperienceBar_Update() end,
					disabled = function() return not mod.db.experience.enable end
				},
				hideAtMaxLevel = {
					order = 14,
					type = "toggle",
					name = L["Hide At Max Level"],
					set = function(info, value) mod.db.experience[info[#info]] = value mod:ExperienceBar_Update() end,
					disabled = function() return not mod.db.experience.enable end
				},
				frameLevel = {
					order = 15,
					type = "range",
					name = L["Frame Level"],
					min = 1, max = 256, step = 1,
					disabled = function() return not mod.db.experience.enable end
				},
				frameStrata = {
					order = 16,
					type = "select",
					name = L["Frame Strata"],
					values = C.Values.Strata,
					disabled = function() return not mod.db.experience.enable end
				},
				text = {
					order = 17,
					type = "group",
					name = L["Text"],
					guiInline = true,
					get = function(info) return mod.db.experience[info[#info]] end,
					set = function(info, value) mod.db.experience[info[#info]] = value mod:ExperienceBar_UpdateDimensions() end,
					args = {
						textFormat = {
							order = 1,
							type = "select",
							name = L["Text Format"],
							customWidth = 210,
							values = textValues,
							set = function(info, value) mod.db.experience[info[#info]] = value mod:ExperienceBar_Update() end,
							disabled = function() return not mod.db.experience.enable end
						},
						font = {
							order = 2,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font,
							disabled = function() return not mod.db.experience.enable or mod.db.experience.textFormat == "NONE" end
						},
						textSize = {
							order = 3,
							type = "range",
							name = L["FONT_SIZE"],
							min = 6, max = 22, step = 1,
							disabled = function() return not mod.db.experience.enable or mod.db.experience.textFormat == "NONE" end
						},
						fontOutline = {
							order = 4,
							type = "select",
							name = L["Font Outline"],
							values = C.Values.FontFlags,
							disabled = function() return not mod.db.experience.enable or mod.db.experience.textFormat == "NONE" end
						},
						textAnchorPoint = {
							order = 5,
							type = "select",
							name = L["Anchor Point"],
							values = positionValues,
							disabled = function() return not mod.db.experience.enable or mod.db.experience.textFormat == "NONE" end
						},
						textXOffset = {
							order = 6,
							type = "range",
							name = L["X-Offset"],
							min = -300, max = 300, step = 1,
							disabled = function() return not mod.db.experience.enable or mod.db.experience.textFormat == "NONE" end
						},
						textYOffset = {
							order = 7,
							type = "range",
							name = L["Y-Offset"],
							min = -300, max = 300, step = 1,
							disabled = function() return not mod.db.experience.enable or mod.db.experience.textFormat == "NONE" end
						}
					}
				},
				questXP = {
					order = 18,
					type = "group",
					name = L["Quest XP"],
					guiInline = true,
					get = function(info) return mod.db.experience[info[#info]] end,
					args = {
						questXP = {
							order = 1,
							type = "toggle",
							name = L["ENABLE"],
							set = function(_, value)
								mod.db.experience.questXP = value
								mod:ExperienceBar_QuestXPToggle()
							end,
							disabled = function() return not mod.db.experience.enable end
						},
						questCurrentZoneOnly = {
							order = 2,
							type = "toggle",
							name = L["Quests in Current Zone Only"],
							set = function(_, value)
								mod.db.experience.questCurrentZoneOnly = value
								mod:ExperienceBar_QuestXPUpdate()
							end,
							disabled = function() return not mod.db.experience.enable or not mod.db.experience.questXP end
						},
						questCompletedOnly = {
							order = 3,
							type = "toggle",
							name = L["Completed Quests Only"],
							set = function(_, value)
								mod.db.experience.questCompletedOnly = value
								mod:ExperienceBar_QuestXPUpdate()
							end,
							disabled = function() return not mod.db.experience.enable or not mod.db.experience.questXP end
						},
						questTooltip = {
							order = 4,
							type = "toggle",
							name = L["Add Quest XP to Tooltip"],
							set = function(_, value)
								mod.db.experience.questTooltip = value
							end,
							disabled = function() return not mod.db.experience.enable or not mod.db.experience.questXP end
						}
					}
				},
				colors = {
					order = 19,
					type = "group",
					name = L["COLORS"],
					guiInline = true,
					get = function(info) return mod.db.experience[info[#info]] end,
					args = {
						expColor = {
							order = 1,
							type = "color",
							name = L["XPBAR_LABEL"],
							hasAlpha = true,
							get = function()
								local t = mod.db.experience.expColor
								return t.r, t.g, t.b, t.a, 0, 0.4, 1, 0.8
							end,
							set = function(_, r, g, b, a)
								local t = mod.db.experience.expColor
								t.r, t.g, t.b, t.a = r, g, b, a
								mod:ExperienceBar_UpdateDimensions()
							end,
							disabled = function() return not mod.db.experience.enable end
						},
						restedColor = {
							order = 2,
							type = "color",
							name = L["Rested XP"],
							hasAlpha = true,
							get = function()
								local t = mod.db.experience.restedColor
								return t.r, t.g, t.b, t.a, 1, 0, 1, 0.4
							end,
							set = function(_, r, g, b, a)
								local t = mod.db.experience.restedColor
								t.r, t.g, t.b, t.a = r, g, b, a
								mod:ExperienceBar_UpdateDimensions()
							end,
							disabled = function() return not mod.db.experience.enable end
						},
						questColor = {
							order = 3,
							type = "color",
							name = L["Quest XP"],
							hasAlpha = true,
							get = function()
								local t = mod.db.experience.questColor
								return t.r, t.g, t.b, t.a, 0, 1, 0, 0.4
							end,
							set = function(_, r, g, b, a)
								local t = mod.db.experience.questColor
								t.r, t.g, t.b, t.a = r, g, b, a
								mod:ExperienceBar_UpdateDimensions()
							end,
							disabled = function() return not mod.db.experience.enable or not mod.db.experience.questXP end
						}
					}
				}
			}
		},
		reputation = {
			order = 4,
			type = "group",
			name = L["REPUTATION"],
			get = function(info) return mod.db.reputation[info[#info]] end,
			set = function(info, value) mod.db.reputation[info[#info]] = value mod:ReputationBar_UpdateDimensions() end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["ENABLE"],
					set = function(info, value) mod.db.reputation[info[#info]] = value mod:ReputationBar_Toggle() end
				},
				spacer1 = {
					order = 2,
					type = "description",
					name = " "
				},
				width = {
					order = 3,
					type = "range",
					name = L["Width"],
					min = 5, max = ceil(GetScreenWidth() or 800), step = 1,
					disabled = function() return not mod.db.reputation.enable end
				},
				height = {
					order = 4,
					type = "range",
					name = L["Height"],
					min = 5, max = ceil(GetScreenHeight() or 800), step = 1,
					disabled = function() return not mod.db.reputation.enable end
				},
				statusbar = {
					order = 5,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["StatusBar Texture"],
					values = AceGUIWidgetLSMlists.statusbar,
					disabled = function() return not mod.db.reputation.enable end
				},
				orientation = {
					order = 6,
					type = "select",
					name = L["Statusbar Fill Orientation"],
					desc = L["Direction the bar moves on gains/losses"],
					values = {
						HORIZONTAL = L["Horizontal"],
						VERTICAL = L["Vertical"]
					},
					disabled = function() return not mod.db.reputation.enable end
				},
				transparent = {
					order = 7,
					type = "toggle",
					name = L["Transparent"],
					disabled = function() return not mod.db.reputation.enable end
				},
				reverseFill = {
					order = 8,
					type = "toggle",
					name = L["Reverse Fill Direction"],
					disabled = function() return not mod.db.reputation.enable end
				},
				showBubbles = {
					order = 9,
					type = "toggle",
					name = L["Show Bubbles"],
					disabled = function() return not mod.db.reputation.enable end
				},
				clickThrough = {
					order = 10,
					type = "toggle",
					name = L["Click Through"],
					disabled = function() return not mod.db.reputation.enable end
				},
				mouseover = {
					order = 11,
					type = "toggle",
					name = L["Mouseover"],
					disabled = function() return not mod.db.reputation.enable end
				},
				hideInVehicle = {
					order = 12,
					type = "toggle",
					name = L["Hide In Vehicle"],
					set = function(info, value) mod.db.reputation[info[#info]] = value mod:ReputationBar_Update() end,
					disabled = function() return not mod.db.reputation.enable end
				},
				hideInCombat = {
					order = 13,
					type = "toggle",
					customWidth = 300,
					name = L["Hide In Combat"],
					set = function(info, value) mod.db.reputation[info[#info]] = value mod:ReputationBar_Update() end,
					disabled = function() return not mod.db.reputation.enable end
				},
				frameLevel = {
					order = 15,
					type = "range",
					name = L["Frame Level"],
					min = 1, max = 256, step = 1,
					disabled = function() return not mod.db.reputation.enable end
				},
				frameStrata = {
					order = 16,
					type = "select",
					name = L["Frame Strata"],
					values = C.Values.Strata,
					disabled = function() return not mod.db.reputation.enable end
				},
				text = {
					order = 17,
					type = "group",
					name = L["Text"],
					guiInline = true,
					get = function(info) return mod.db.reputation[info[#info]] end,
					set = function(info, value) mod.db.reputation[info[#info]] = value mod:ReputationBar_UpdateDimensions() end,
					args = {
						textFormat = {
							order = 1,
							type = "select",
							name = L["Text Format"],
							customWidth = 210,
							values = textValues,
							set = function(info, value) mod.db.reputation[info[#info]] = value mod:ReputationBar_Update() end,
							disabled = function() return not mod.db.reputation.enable end
						},
						font = {
							order = 2,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font,
							disabled = function() return not mod.db.reputation.enable or mod.db.reputation.textFormat == "NONE" end
						},
						textSize = {
							order = 3,
							type = "range",
							name = L["FONT_SIZE"],
							min = 6, max = 22, step = 1,
							disabled = function() return not mod.db.reputation.enable or mod.db.reputation.textFormat == "NONE" end
						},
						fontOutline = {
							order = 4,
							type = "select",
							name = L["Font Outline"],
							values = C.Values.FontFlags,
							disabled = function() return not mod.db.reputation.enable or mod.db.reputation.textFormat == "NONE" end
						},
						textAnchorPoint = {
							order = 5,
							type = "select",
							name = L["Anchor Point"],
							values = positionValues,
							disabled = function() return not mod.db.reputation.enable or mod.db.reputation.textFormat == "NONE" end
						},
						textXOffset = {
							order = 6,
							type = "range",
							name = L["X-Offset"],
							min = -300, max = 300, step = 1,
							disabled = function() return not mod.db.reputation.enable or mod.db.reputation.textFormat == "NONE" end
						},
						textYOffset = {
							order = 7,
							type = "range",
							name = L["Y-Offset"],
							min = -300, max = 300, step = 1,
							disabled = function() return not mod.db.reputation.enable or mod.db.reputation.textFormat == "NONE" end
						}
					}
				},
				colors = {
					order = 18,
					type = "group",
					name = L["COLORS"],
					guiInline = true,
					get = function(info)
						local v = tonumber(info[#info])
						local t = E.db.databars.reputation.factionColors[v]
						local d = P.databars.reputation.factionColors[v]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
					end,
					set = function(info, r, g, b, a)
						local v = tonumber(info[#info])
						local t = E.db.databars.reputation.factionColors[v]
						t.r, t.g, t.b, t.a = r, g, b, a
						mod:ReputationBar_Update()
					end,
					args = {
						useCustomFactionColors = {
							order = 0,
							type = "toggle",
							name = L["Custom Faction Colors"],
							get = function(info) return mod.db.reputation[info[#info]] end,
							set = function(info, value)
								mod.db.reputation[info[#info]] = value
								mod:ReputationBar_Update()
							end,
							disabled = function() return not mod.db.reputation.enable end
						},
						reputationAlpha = {
							order = 0.1,
							type = "range",
							name = L["Reputation Alpha"],
							min = 0, max = 1, step = 0.05, isPercent = true,
							get = function(info) return mod.db.reputation[info[#info]] end,
							set = function(info, value)
								mod.db.reputation[info[#info]] = value
								mod:ReputationBar_Update()
							end,
							disabled = function() return not mod.db.reputation.enable end
						},
						spacer = {
							order = 0.2,
							type = "description",
							name = ""
						}
					}
				}
			}
		}
	}
}

for i = 1, 8 do
	E.Options.args.databars.args.reputation.args.colors.args[""..i] = {
		order = i,
		type = "color",
		hasAlpha = false,
		name = L["FACTION_STANDING_LABEL"..i],
		disabled = function() return not mod.db.reputation.enable or not mod.db.reputation.useCustomFactionColors end
	}
end