local E, L, V, P, G = unpack(ElvUI);
local NP = E:GetModule("NamePlates")

local selectedFilter
local filters

local positionValues = {
	TOPLEFT = "TOPLEFT",
	LEFT = "LEFT",
	BOTTOMLEFT = "BOTTOMLEFT",
	RIGHT = "RIGHT",
	TOPRIGHT = "TOPRIGHT",
	BOTTOMRIGHT = "BOTTOMRIGHT",
	CENTER = "CENTER",
	TOP = "TOP",
	BOTTOM = "BOTTOM"
};

local function UpdateFilterGroup()
	if not selectedFilter or not E.global["nameplate"]["filter"][selectedFilter] then
		E.Options.args.nameplate.args.filters.args.filterGroup = nil
		return
	end

	E.Options.args.nameplate.args.filters.args.filterGroup = {
		type = "group",
		name = selectedFilter,
		guiInline = true,
		order = -10,
		get = function(info) return E.global["nameplate"]["filter"][selectedFilter][ info[#info] ] end,
		set = function(info, value) E.global["nameplate"]["filter"][selectedFilter][ info[#info] ] = value; NP:ForEachPlate("CheckFilter"); NP:UpdateAllPlates(); UpdateFilterGroup() end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Use this filter."]
			},
			hide = {
				order = 2,
				type = "toggle",
				name = L["Hide"],
				desc = L["Prevent any nameplate with this unit name from showing."]
			},
			customColor = {
				order = 3,
				type = "toggle",
				name = L["Custom Color"],
				desc = L["Disable threat coloring for this plate and use the custom color."]
			},
			color = {
				order = 4,
				type = "color",
				name = L["Color"],
				get = function(info)
					local t = E.global["nameplate"]["filter"][selectedFilter][ info[#info] ]
					if t then
						return t.r, t.g, t.b, t.a
					end
				end,
				set = function(info, r, g, b)
					E.global["nameplate"]["filter"][selectedFilter][ info[#info] ] = {}
					local t = E.global["nameplate"]["filter"][selectedFilter][ info[#info] ]
					if t then
						t.r, t.g, t.b = r, g, b
						UpdateFilterGroup()
						NP:ForEachPlate("CheckFilter")
						NP:UpdateAllPlates()
					end
				end
			},
			customScale = {
				order = 5,
				type = "range",
				name = L["Custom Scale"],
				desc = L["Set the scale of the nameplate."],
				min = 0.67, max = 2, step = 0.01
			}
		}
	}
end

E.Options.args.nameplate = {
	type = "group",
	name = L["NamePlates"],
	childGroups = "tab",
	get = function(info) return E.db.nameplate[ info[#info] ] end,
	set = function(info, value) E.db.nameplate[ info[#info] ] = value; NP:UpdateAllPlates() end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["NAMEPLATE_DESC"]
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function(info) return E.private.nameplate[ info[#info] ] end,
			set = function(info, value) E.private.nameplate[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end
		},
		general = {
			order = 1,
			type = "group",
			name = L["General"],
			disabled = function() return not E.NamePlates; end,
			args = {
				header = {
 					order = 0,
					type = "header",
					name = L["General"]
				},
				statusbar = {
					order = 1,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["HealthBar Texture"],
					values = AceGUIWidgetLSMlists.statusbar
				},
				showEnemyCombat = {
					order = 2,
					type = "select",
					name = L["Enemy Combat Toggle"],
					desc = L["Control enemy nameplates toggling on or off when in combat."],
					values = {
						["DISABLED"] = L["Disabled"],
						["TOGGLE_ON"] = L["Toggle On While In Combat"],
						["TOGGLE_OFF"] = L["Toggle Off While In Combat"]
					},
					set = function(info, value) 
						E.db.nameplate[ info[#info] ] = value; 
						NP:PLAYER_REGEN_ENABLED()
					end
				},
				showFriendlyCombat = {
					order = 3,
					type = "select",
					name = L["Friendly Combat Toggle"],
					desc = L["Control friendly nameplates toggling on or off when in combat."],
					values = {
						["DISABLED"] = L["Disabled"],
						["TOGGLE_ON"] = L["Toggle On While In Combat"],
						["TOGGLE_OFF"] = L["Toggle Off While In Combat"],
					},
					set = function(info, value) E.db.nameplate[ info[#info] ] = value; NP:PLAYER_REGEN_ENABLED() end
				},
				lowHealthThreshold = {
					order = 4,
					type = "range",
					name = L["Low Health Threshold"],
					desc = L["Make the unitframe glow yellow when it is below this percent of health, it will glow red when the health value is half of this value."],
					isPercent = true,
					min = 0, max = 1, step = 0.01
				},
				nonTargetAlpha = {
					order = 5,
					type = "range",
					name = L["Non-Target Transparency"],
					desc = L["Set the transparency level of nameplates that are not the target nameplate."],
					min = 0, max = 1, step = 0.01, isPercent = true
				},
				targetAlpha = {
					order = 6,
					type = "range",
					name = L["Target Transparency"],
					desc = L["Set the transparency level of current target nameplate."],
					min = 0, max = 1, step = 0.01, isPercent = true
				},
				colorNameByValue = {
					order = 7,
					type = "toggle",
					name = L["Color Name By Health Value"]
				},
				comboPoints = {
					order = 8,
					type = "toggle",
					name = L["Combo Points"],
					desc = L["Display combo points on nameplates."]
				},
				markHealers = {
					order = 9,
					type = 'toggle',
					name = L['Healer Icon'],
					desc = L['Display a healer icon over known healers inside battlegrounds or arenas.']
				},
				fontGroup = {
					order = 100,
					type = "group",
					guiInline = true,
					name = L["Fonts"],
					args = {
						showName = {
							order = 1,
							type = "toggle",
							name = L["Show Name"]
						},
						showLevel = {
							order = 2,
							type = "toggle",
							name = L["Show Level"]
						},
						wrapName = {
							order = 3,
							type = "toggle",
							name = L["Wrap Name"],
							desc = L["Wraps name instead of truncating it."]
						},
						font = {
							order = 4,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						fontSize = {
							order = 5,
							type = "range",
							name = L["Font Size"],
							min = 6, max = 22, step = 1
						},
						fontOutline = {
							order = 6,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = {
								["NONE"] = L["None"],
								["OUTLINE"] = "OUTLINE",
								["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
								["THICKOUTLINE"] = "THICKOUTLINE"
							}
						}
					}
				},
				castGroup = {
					order = 150,
					type = "group",
					name = L["Cast Bar"],
					guiInline = true,
					get = function(info)
						local t = E.db.nameplate[ info[#info] ];
						local d = P.nameplate[info[#info]];
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b;
					end,
					set = function(info, r, g, b)
						E.db.nameplate[ info[#info] ] = {};
						local t = E.db.nameplate[ info[#info] ];
						t.r, t.g, t.b = r, g, b;
					end,
					args = {
						castColor = {
							order = 1,
							type = "color",
							name = L["Cast Color"],
							hasAlpha = false
						},
						castNoInterruptColor = {
							order = 2,
							type = "color",
							name = L["Cast No Interrupt Color"],
							hasAlpha = false
						}
					}
				},
				reactions = {
					order = 200,
					type = "group",
					name = L["Reaction Colors"],
					guiInline = true,
					get = function(info)
						local t = E.db.nameplate.reactions[ info[#info] ]
						local d = P.nameplate.reactions[info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b
					end,
					set = function(info, r, g, b)
						E.db.nameplate.reactions[ info[#info] ] = {}
						local t = E.db.nameplate.reactions[ info[#info] ]
						t.r, t.g, t.b = r, g, b
						NP:UpdateAllPlates()
					end,
					args = {
						friendlyNPC = {
							order = 1,
							type = "color",
							name = L["Friendly NPC"],
							hasAlpha = false
						},
						friendlyPlayer = {
							order = 2,
							type = "color",
							name = L["Friendly Player"],
							hasAlpha = false
						},
						neutral = {
							order = 3,
							type = "color",
							name = L["Neutral"],
							hasAlpha = false
						},
						enemy = {
							order = 4,
							type = "color",
							name = L["Enemy"],
							hasAlpha = false
						},
						tapped = {
							order = 5,
							type = "color",
							name = L["Tagged NPC"],
							hasAlpha = false
						}
					}
				}
			}
		},
		healthBar = {
			order = 2,
			type = "group",
			name = L["Health Bar"],
			disabled = function() return not E.NamePlates; end,
			get = function(info) return E.db.nameplate.healthBar[ info[#info] ] end,
			set = function(info, value) E.db.nameplate.healthBar[ info[#info] ] = value; NP:UpdateAllPlates() end,
			args = {
				header = {
 					order = 1,
					type = "header",
					name = L["Health Bar"]
				},
				width = {
					order = 2,
					type = "range",
					name = L["Width"],
					desc = L["Controls the width of the nameplate"],
					min = 50, max = 125, step = 1
				},
				height = {
					order = 3,
					type = "range",
					name = L["Height"],
					desc = L["Controls the height of the nameplate"],
					min = 4, max = 30, step = 1
				},
				healthAnimationSpeed = {
 					order = 4,
					type = "range",
					name = L["Animation Speed"],
					desc = L["Controls the animation of the nameplate"],
					min = 0, max = 1, step = 0.01
				},
				colorByRaidIcon = {
					order = 5,
					type = "toggle",
					name = L["Color By Raid Icon"]
				},
				spacer = {
					order = 6,
					type = "description",
					name = "\n"
				},
				lowHPScale = {
					order = 7,
					type = "group",
					name = L["Scale if Low Health"],
					guiInline = true,
					get = function(info) return E.db.nameplate.healthBar.lowHPScale[ info[#info] ] end,
					set = function(info, value) E.db.nameplate.healthBar.lowHPScale[ info[#info] ] = value; NP:UpdateAllPlates() end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Adjust nameplate size on low health"]
						},
						width = {
							order = 2,
							type = "range",
							name = L["Low HP Width"],
							desc = L["Controls the width of the nameplate on low health"],
							min = 50, max = 125, step = 1
						},
						height = {
							order = 3,
							type = "range",
							name = L["Low HP Height"],
							desc = L["Controls the height of the nameplate on low health"],
							min = 4, max = 30, step = 1
						},
						toFront = {
							order = 4,
							type = "toggle",
							name = L["Bring to front on low health"],
							desc = L["Bring nameplate to front on low health"]
						},
						changeColor = {
							order = 5,
							type = "toggle",
							name = L["Change color on low health"],
							desc = L["Change color on low health"]
						},
						color = {
							get = function(info)
								local t = E.db.nameplate.healthBar.lowHPScale.color
								local d = P.nameplate.healthBar.lowHPScale.color
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								E.db.nameplate.healthBar.lowHPScale.color = {}
								local t = E.db.nameplate.healthBar.lowHPScale.color
								t.r, t.g, t.b = r, g, b
								NP:UpdateAllPlates()
							end,
							order = 6,
							type = "color",
							name = L["Color on low health"],
							hasAlpha = false
						}
					}
				},
				fontGroup = {
					order = 8,
					type = "group",
					name = L["Fonts"],
					guiInline = true,
					get = function(info) return E.db.nameplate.healthBar.text[ info[#info] ] end,
					set = function(info, value) E.db.nameplate.healthBar.text[ info[#info] ] = value; NP:UpdateAllPlates() end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"]
						},
						format = {
							order = 2,
							type = "select",
							name = L["Format"],
							values = {
								["CURRENT_MAX_PERCENT"] = L["Current - Max | Percent"],
								["CURRENT_PERCENT"] = L["Current - Percent"],
								["CURRENT_MAX"] = L["Current - Max"],
								["CURRENT"] = L["Current"],
								["PERCENT"] = L["Percent"],
								["DEFICIT"] = L["Deficit"]
							}
						}
					}
				}
			}
		},
		castBar = {
			order = 3,
			type = "group",
			name = L["Cast Bar"],
			disabled = function() return not E.NamePlates; end,
			get = function(info) return E.db.nameplate.castBar[ info[#info] ] end,
			set = function(info, value) E.db.nameplate.castBar[ info[#info] ] = value; NP:UpdateAllPlates() end,
			args = {
				header = {
 					order = 1,
					type = "header",
					name = L["Cast Bar"]
				},
				hideSpellName = {
					order = 2,
					type = "toggle",
					name = L["Hide Spell Name"]
				},
				hideTime = {
					order = 3,
					type = "toggle",
					name = L["Hide Time"]
				},
				height = {
					order = 4,
					type = "range",
					name = L["Height"],
					min = 4, max = 30, step = 1
				},
				castTimeFormat = {
					order = 5,
					type = "select",
					name = L["Cast Time Format"],
					values = {
						["CURRENT"] = L["Current"],
						["CURRENT_MAX"] = L["Current / Max"],
						["REMAINING"] = L["Remaining"]
					}
				},
				channelTimeFormat = {
					order = 6,
					type = "select",
					name = L["Channel Time Format"],
					values = {
						["CURRENT"] = L["Current"],
						["CURRENT_MAX"] = L["Current / Max"],
						["REMAINING"] = L["Remaining"]
					}
				},
				offset = {
 					order = 7,
					type = "range",
					name = L["Offset"],
					min = 0, max = 15, step = 1
				}
			}
		},
		targetIndicator = {
			order = 4,
			type = "group",
			name = L["Target Indicator"],
			get = function(info) return E.db.nameplate.targetIndicator[ info[#info] ] end,
			set = function(info, value) E.db.nameplate.targetIndicator[ info[#info] ] = value; WorldFrame.elapsed = 3; NP:UpdateAllPlates() end,
			disabled = function() return not E.NamePlates; end,
			args = {
				header = {
 					order = 0,
					type = "header",
					name = L["Target Indicator"]
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"]
				},
				width = {
					order = 2,
					type = "range",
					name = L["Width"],
					min = 0, max = 220, step = 1,
					disabled = function() return (NP.db.targetIndicator.style == "glow") end,
					set = function(info, value) E.db.nameplate.targetIndicator[ info[#info] ] = value; NP:SetTargetIndicatorDimensions() end
				},
				height = {
					order = 3,
					type = "range",
					name = L["Height"],
					min = 0, max = 220, step = 1,
					disabled = function() return (NP.db.targetIndicator.style == "glow") end,
					set = function(info, value) E.db.nameplate.targetIndicator[ info[#info] ] = value; NP:SetTargetIndicatorDimensions() end
				},
				style = {
					order = 4,
					type = "select",
					name = L["Style"],
					values = {
						arrow = L["Vertical Arrow"],
						doubleArrow = L["Horrizontal Arrows"],
						doubleArrowInverted = L["Horrizontal Arrows (Inverted)"],
						glow = L["Glow"]
					},
					set = function(info, value) E.db.nameplate.targetIndicator[ info[#info] ] = value; NP:SetTargetIndicator(); NP:UpdateAllPlates() end
				},
				xOffset = {
					order = 5,
					type = "range",
					name = L["X-Offset"],
					min = -100, max = 100, step = 1,
					disabled = function() return (NP.db.targetIndicator.style ~= "doubleArrow" and NP.db.targetIndicator.style ~= "doubleArrowInverted") end
				},
				yOffset = {
					order = 6,
					type = "range",
					name = L["Y-Offset"],
					min = -100, max = 100, step = 1,
					disabled = function() return (NP.db.targetIndicator.style ~= "arrow") end
				},
				colorMatchHealthBar = {
					order = 10,
					type = "toggle",
					name = L["Color By Healthbar"],
					desc = L["Match the color of the healthbar."],
					set = function(info, value) 
						E.db.nameplate.targetIndicator.colorMatchHealthBar = value;
						if(not value) then
							local color = E.db.nameplate.targetIndicator.color
							NP:ColorTargetIndicator(color.r, color.g, color.b)
						else
							WorldFrame.elapsed = 3
						end
					end
				},
				color = {
					order = 11,
					type = "color",
					name = L["Color"],
					disabled = function() return E.db.nameplate.targetIndicator.colorMatchHealthBar end,
					get = function(info)
						local t = E.db.nameplate.targetIndicator[ info[#info] ]
						local d = P.nameplate.targetIndicator[ info[#info] ]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b
					end,
					set = function(info, r, g, b)
						E.db.nameplate.targetIndicator[ info[#info] ] = {}
						local t = E.db.nameplate.targetIndicator[ info[#info] ]
						t.r, t.g, t.b = r, g, b
						NP:UpdateAllPlates()
					end
				}
			}
		},
		raidIcon = {
			order = 5,
			type = "group",
			name = L["Raid Icon"],
			get = function(info) return E.db.nameplate.raidIcon[ info[#info] ] end,
			set = function(info, value) E.db.nameplate.raidIcon[ info[#info] ] = value; NP:UpdateAllPlates() end,
			disabled = function() return not E.NamePlates; end,
			args = {
				header = {
 					order = 1,
					type = "header",
					name = L["Raid Icon"]
				},
				size = {
					order = 2,
					type = "range",
					name = L["Size"],
					min = 10, max = 200, step = 1
				},
				attachTo = {
					order = 3,
					type = "select",
					name = L["Attach To"],
					values = positionValues
				},
				xOffset = {
					order = 4,
					type = "range",
					name = L["X-Offset"],
					min = -150, max = 150, step = 1
				},
				yOffset = {
					order = 5,
					type = "range",
					name = L["Y-Offset"],
					min = -150, max = 150, step = 1
				}
			}
		},
		buffs = {
			order = 6,
			type = "group",
			name = L["Buffs"],
			get = function(info) return E.db.nameplate.buffs[ info[#info] ]; end,
			set = function(info, value) E.db.nameplate.buffs[ info[#info] ] = value; NP:UpdateAllPlates(); end,
			disabled = function() return not E.NamePlates; end,
			args = {
				header = {
 					order = 0,
					type = "header",
					name = L["Buffs"]
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"]
				},
				numAuras = {
					order = 2,
					type = "range",
					name = L["# Displayed Auras"],
					desc = L["Controls how many auras are displayed, this will also affect the size of the auras."],
					min = 1, max = 8, step = 1
				},
				baseHeight = {
					order = 3,
					type = "range",
					name = L["Icon Base Height"],
					desc = L["Base Height for the Aura Icon"],
					min = 6, max = 60, step = 1
				},
				filtersGroup = {
					order = 4,
					type = "group",
					name = L["Filters"],
					guiInline = true,
					get = function(info) return E.db.nameplate.buffs.filters[ info[#info] ]; end,
					set = function(info, value) E.db.nameplate.buffs.filters[ info[#info] ] = value; NP:UpdateAllPlates(); end,
					args = {
						personal = {
							order = 1,
							type = "toggle",
							name = L["Personal Auras"]
						},
						maxDuration = {
							order = 2,
							type = "range",
							name = L["Maximum Duration"],
							min = 5, max = 3000, step = 1
						},
						filter = {
							order = 3,
							type = "select",
							name = L["Additional Filter"],
							values = function()
								filters = {};
								filters[""] = NONE;
								for filter in pairs(E.global["unitframe"]["aurafilters"]) do
									filters[filter] = filter;
								end
								return filters;
							end
						}
					}
				}
			}
		},
		debuffs = {
			order = 7,
			type = "group",
			name = L["Debuffs"],
			get = function(info) return E.db.nameplate.debuffs[ info[#info] ]; end,
			set = function(info, value) E.db.nameplate.debuffs[ info[#info] ] = value; NP:UpdateAllPlates(); end,
			disabled = function() return not E.NamePlates; end,
			args = {
				header = {
 					order = 0,
					type = "header",
					name = L["Debuffs"]
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"]
				},
				numAuras = {
					order = 2,
					type = "range",
					name = L["# Displayed Auras"],
					desc = L["Controls how many auras are displayed, this will also affect the size of the auras."],
					min = 1, max = 8, step = 1
				},
				baseHeight = {
					order = 3,
					type = "range",
					name = L["Icon Base Height"],
					desc = L["Base Height for the Aura Icon"],
					min = 6, max = 60, step = 1
				},
				filtersGroup = {
					order = 4,
					type = "group",
					name = L["Filters"],
					guiInline = true,
					get = function(info) return E.db.nameplate.debuffs.filters[ info[#info] ]; end,
					set = function(info, value) E.db.nameplate.debuffs.filters[ info[#info] ] = value; NP:UpdateAllPlates(); end,
					args = {
						personal = {
							order = 1,
							type = "toggle",
							name = L["Personal Auras"]
						},
						maxDuration = {
							order = 2,
							type = "range",
							name = L["Maximum Duration"],
							min = 5, max = 3000, step = 1
						},
						filter = {
							order = 3,
							type = "select",
							name = L["Additional Filter"],
							values = function()
								filters = {};
								filters[""] = NONE;
								for filter in pairs(E.global["unitframe"]["aurafilters"]) do
									filters[filter] = filter;
								end
								return filters;
							end
						}
					}
				}
			}
		},
		threat = {
			order = 8,
			type = "group",
			name = L["Threat"],
			get = function(info)
				local t = E.db.nameplate.threat[ info[#info] ]
				local d = P.nameplate.threat[info[#info]]
				return t.r, t.g, t.b, t.a, d.r, d.g, d.b
			end,
			set = function(info, r, g, b)
				E.db.nameplate[ info[#info] ] = {}
				local t = E.db.nameplate.threat[ info[#info] ]
				t.r, t.g, t.b = r, g, b
			end,
			disabled = function() return not E.NamePlates; end,
			args = {
				header = {
 					order = 1,
					type = "header",
					name = L["Threat"]
				},
				useThreatColor = {
					order = 2,
					type = "toggle",
					name = L["Use Threat Color"],
					get = function(info) return E.db.nameplate.threat.useThreatColor; end,
					set = function(info, value) E.db.nameplate.threat.useThreatColor = value; end
				},
				goodScale = {
					order = 3,
					type = "range",
					name = L["Good"],
					min = 0.5, max = 1.5, step = 0.01, isPercent = true,
					get = function(info) return E.db.nameplate.threat[ info[#info] ] end,
					set = function(info, value) E.db.nameplate.threat[ info[#info] ] = value; end
				},
				badScale = {
					order = 4,
					type = "range",
					name = L["Bad"],
					min = 0.5, max = 1.5, step = 0.01, isPercent = true,
					get = function(info) return E.db.nameplate.threat[ info[#info] ] end,
					set = function(info, value) E.db.nameplate.threat[ info[#info] ] = value; end
				},
				goodColor = {
					order = 5,
					type = "color",
					name = L["Good"],
					hasAlpha = false
				},
				badColor = {
					order = 6,
					type = "color",
					name = L["Bad"],
					hasAlpha = false
				},
				goodTransition = {
					order = 7,
					type = "color",
					name = L["Good Transition"],
					hasAlpha = false
				},
				badTransition = {
					order = 8,
					type = "color",
					name = L["Bad Transition"],
					hasAlpha = false
				}
			}
		},
		filters = {
			order = 200,
			type = "group",
			name = L["Filters"],
			disabled = function() return not E.NamePlates; end,
			args = {
				header = {
 					order = 0,
					type = "header",
					name = L["Filters"]
				},
				addname = {
					order = 1,
					type = "input",
					name = L["Add Name"],
					get = function(info) return "" end,
					set = function(info, value) 
						if E.global["nameplate"]["filter"][value] then
							E:Print(L["Filter already exists!"])
							return
						end

						E.global["nameplate"]["filter"][value] = {
							["enable"] = true,
							["hide"] = false,
							["customColor"] = false,
							["customScale"] = 1,
							["color"] = {r = 104/255, g = 138/255, b = 217/255},
						}
						UpdateFilterGroup()
						NP:UpdateAllPlates()
					end
				},
				deletename = {
					order = 2,
					type = "input",
					name = L["Remove Name"],
					get = function(info) return "" end,
					set = function(info, value) 
						if G["nameplate"]["filter"][value] then
							E.global["nameplate"]["filter"][value].enable = false;
							E:Print(L["You can't remove a default name from the filter, disabling the name."])
						else
							E.global["nameplate"]["filter"][value] = nil;
							E.Options.args.nameplate.args.filters.args.filterGroup = nil;
						end
						UpdateFilterGroup()
						NP:UpdateAllPlates();
					end
				},
				selectFilter = {
					order = 3,
					type = "select",
					name = L["Select Filter"],
					get = function(info) return selectedFilter end,
					set = function(info, value) selectedFilter = value; UpdateFilterGroup() end,
					values = function()
						filters = {}
						for filter in pairs(E.global["nameplate"]["filter"]) do
							filters[filter] = filter
						end
						return filters
					end
				}
			}
		}
	}
};