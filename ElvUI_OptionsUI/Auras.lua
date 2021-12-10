local E, _, V, P, G = unpack(ElvUI)
local C, L = unpack(select(2, ...))
local A = E:GetModule("Auras")
local RB = E:GetModule("ReminderBuffs")
local M = E:GetModule("Minimap")

E.Options.args.auras = {
	order = 2,
	type = "group",
	name = L["BUFFOPTIONS_LABEL"],
	childGroups = "tab",
	get = function(info) return E.private.auras[info[#info]] end,
	set = function(info, value)
		E.private.auras[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["AURAS_DESC"]
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["ENABLE"]
		},
		disableBlizzard = {
			order = 3,
			type = "toggle",
			name = L["Disabled Blizzard"]
		},
		buffsHeader = {
			order = 4,
			type = "toggle",
			name = L["Buffs"]
		},
		debuffsHeader = {
			order = 5,
			type = "toggle",
			name = L["Debuffs"]
		},
		weaponsHeader = {
			order = 6,
			type = "toggle",
			name = L["Weapons"]
		},
		cooldownShortcut = {
			order = 7,
			type = "execute",
			name = L["Cooldown Text"],
			func = function() E.Libs.AceConfigDialog:SelectGroup("ElvUI", "cooldown", "auras") end
		},
		buffs = {
			order = 8,
			type = "group",
			name = L["Buffs"],
			get = function(info) return E.db.auras.buffs[info[#info]] end,
			set = function(info, value) E.db.auras.buffs[info[#info]] = value A:UpdateHeader(A.BuffFrame) end,
			disabled = function() return not E.private.auras.enable or not E.private.auras.buffsHeader end,
			args = {
				growthDirection = {
					order = 1,
					type = "select",
					name = L["Growth Direction"],
					desc = L["The direction the auras will grow and then the direction they will grow after they reach the wrap after limit."],
					values = C.Values.GrowthDirection
				},
				sortMethod = {
					order = 2,
					type = "select",
					name = L["Sort Method"],
					desc = L["Defines how the group is sorted."],
					values = {
						INDEX = L["Index"],
						TIME = L["Time"],
						NAME = L["NAME"]
					}
				},
				sortDir = {
					order = 3,
					type = "select",
					name = L["Sort Direction"],
					desc = L["Defines the sort order of the selected sort method."],
					values = {
						["+"] = L["Ascending"],
						["-"] = L["Descending"]
					}
				},
				seperateOwn = {
					order = 4,
					type = "select",
					name = L["Seperate"],
					desc = L["Indicate whether buffs you cast yourself should be separated before or after."],
					values = {
						[-1] = L["Other's First"],
						[0] = L["No Sorting"],
						[1] = L["Your Auras First"]
					}
				},
				wrapAfter = {
					order = 5,
					type = "range",
					name = L["Wrap After"],
					desc = L["Begin a new row or column after this many auras."],
					min = 1, max = 32, step = 1
				},
				maxWraps = {
					order = 6,
					type = "range",
					name = L["Max Wraps"],
					desc = L["Limit the number of rows or columns."],
					min = 1, max = 32, step = 1
				},
				horizontalSpacing = {
					order = 7,
					type = "range",
					name = L["Horizontal Spacing"],
					min = -1, max = 50, step = 1
				},
				verticalSpacing = {
					order = 8,
					type = "range",
					name = L["Vertical Spacing"],
					min = -1, max = 50, step = 1
				},
				fadeThreshold = {
					order = 9,
					type = "range",
					name = L["Fade Threshold"],
					desc = L["Threshold before the icon will fade out and back in. Set to -1 to disable."],
					min = -1, max = 30, step = 1
				},
				size = {
					order = 10,
					type = "range",
					name = L["Size"],
					desc = L["Set the size of the individual auras."],
					min = 16, max = 60, step = 2
				},
				showDuration = {
					order = 11,
					type = "toggle",
					name = L["Duration Enable"]
				},
				masque = {
					order = 12,
					type = "toggle",
					name = L["Masque Support"],
					desc = L["Allow Masque to handle the skinning of this element."],
					get = function() return E.private.auras.masque.buffs end,
					set = function(_, value) E.private.auras.masque.buffs = value E:StaticPopup_Show("PRIVATE_RL") end,
					disabled = function() return not E.private.auras.enable or not E.private.auras.buffsHeader or not E.Masque end
				},
				timeGroup = {
					order = 13,
					type = "group",
					name = L["Time"],
					args = {
						timeFont = {
							order = 1,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						timeFontSize = {
							order = 2,
							type = "range",
							name = L["Font Size"],
							min = 4, max = 32, step = 1
						},
						timeFontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = C.Values.FontFlags
						},
						spacer = {
							order = 4,
							type = "description",
							name = ""
						},
						timeXOffset = {
							order = 5,
							type = "range",
							name = L["Time X-Offset"],
							min = -60, max = 60, step = 1
						},
						timeYOffset = {
							order = 6,
							type = "range",
							name = L["Time Y-Offset"],
							min = -60, max = 60, step = 1
						}
					}
				},
				countGroup = {
					order = 14,
					type = "group",
					name = L["Count"],
					args = {
						countFont = {
							order = 1,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						countFontSize = {
							order = 2,
							type = "range",
							name = L["Font Size"],
							min = 4, max = 32, step = 1
						},
						countFontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = C.Values.FontFlags
						},
						spacer = {
							order = 4,
							type = "description",
							name = ""
						},
						countXOffset = {
							order = 5,
							type = "range",
							name = L["Time X-Offset"],
							min = -60, max = 60, step = 1
						},
						countYOffset = {
							order = 6,
							type = "range",
							name = L["Time Y-Offset"],
							min = -60, max = 60, step = 1
						}
					}
				},
				statusBar = {
					order = 15,
					type = "group",
					name = L["Status Bar"],
					args = {
						barShow = {
							order = 1,
							type = "toggle",
							name = L["ENABLE"]
						},
						spacer = {
							order = 2,
							type = "description",
							name = ""
						},
						barTexture = {
							order = 3,
							type = "select",
							dialogControl = "LSM30_Statusbar",
							name = L["Texture"],
							values = AceGUIWidgetLSMlists.statusbar,
							disabled = function() return not E.db.auras.buffs.barShow end
						},
						barSize = {
							order = 4,
							type = "range",
							name = L["Size"],
							min = 1, max = 10, step = 1,
							disabled = function() return not E.db.auras.buffs.barShow end
						},
						barSpacing = {
							order = 5,
							type = "range",
							name = L["Spacing"],
							min = -10, max = 10, step = 1,
							disabled = function() return not E.db.auras.buffs.barShow end
						},
						barPosition = {
							order = 6,
							type = "select",
							name = L["Position"],
							values = {
								TOP = L["Top"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								RIGHT = L["Right"]
							},
							disabled = function() return not E.db.auras.buffs.barShow end
						},
						barNoDuration = {
							order = 7,
							type = "toggle",
							name = L["No Duration"],
							disabled = function() return not E.db.auras.buffs.barShow end
						},
						barColorGradient = {
							order = 8,
							type = "toggle",
							name = L["Color by Value"],
							disabled = function() return not E.db.auras.buffs.barShow end
						},
						barColor = {
							order = 9,
							type = "color",
							name = L["COLOR"],
							hasAlpha = false,
							get = function()
								local t = E.db.auras.buffs.barColor
								local d = P.auras.buffs.barColor
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(_, r, g, b)
								local t = E.db.auras.buffs.barColor
								t.r, t.g, t.b = r, g, b
								A:UpdateHeader(A.BuffFrame)
							end,
							disabled = function() return not E.db.auras.buffs.barShow or E.db.auras.buffs.barColorGradient end
						}
					}
				}
			}
		},
		debuffs = {
			order = 9,
			type = "group",
			name = L["Debuffs"],
			get = function(info) return E.db.auras.debuffs[info[#info]] end,
			set = function(info, value) E.db.auras.debuffs[info[#info]] = value A:UpdateHeader(A.DebuffFrame) end,
			disabled = function() return not E.private.auras.enable or not E.private.auras.debuffsHeader end,
			args = {
				growthDirection = {
					order = 1,
					type = "select",
					name = L["Growth Direction"],
					desc = L["The direction the auras will grow and then the direction they will grow after they reach the wrap after limit."],
					values = C.Values.GrowthDirection
				},
				sortMethod = {
					order = 2,
					type = "select",
					name = L["Sort Method"],
					desc = L["Defines how the group is sorted."],
					values = {
						INDEX = L["Index"],
						TIME = L["Time"],
						NAME = L["NAME"]
					}
				},
				sortDir = {
					order = 3,
					type = "select",
					name = L["Sort Direction"],
					desc = L["Defines the sort order of the selected sort method."],
					values = {
						["+"] = L["Ascending"],
						["-"] = L["Descending"]
					}
				},
				seperateOwn = {
					order = 4,
					type = "select",
					name = L["Seperate"],
					desc = L["Indicate whether buffs you cast yourself should be separated before or after."],
					values = {
						[-1] = L["Other's First"],
						[0] = L["No Sorting"],
						[1] = L["Your Auras First"]
					}
				},
				wrapAfter = {
					order = 5,
					type = "range",
					name = L["Wrap After"],
					desc = L["Begin a new row or column after this many auras."],
					min = 1, max = 32, step = 1
				},
				maxWraps = {
					order = 6,
					type = "range",
					name = L["Max Wraps"],
					desc = L["Limit the number of rows or columns."],
					min = 1, max = 32, step = 1
				},
				horizontalSpacing = {
					order = 7,
					type = "range",
					name = L["Horizontal Spacing"],
					min = -1, max = 50, step = 1
				},
				verticalSpacing = {
					order = 8,
					type = "range",
					name = L["Vertical Spacing"],
					min = -1, max = 50, step = 1
				},
				fadeThreshold = {
					order = 9,
					type = "range",
					name = L["Fade Threshold"],
					desc = L["Threshold before the icon will fade out and back in. Set to -1 to disable."],
					min = -1, max = 30, step = 1
				},
				size = {
					order = 10,
					type = "range",
					name = L["Size"],
					desc = L["Set the size of the individual auras."],
					min = 16, max = 60, step = 2
				},
				showDuration = {
					order = 11,
					type = "toggle",
					name = L["Duration Enable"]
				},
				masque = {
					order = 12,
					type = "toggle",
					name = L["Masque Support"],
					desc = L["Allow Masque to handle the skinning of this element."],
					get = function() return E.private.auras.masque.debuffs end,
					set = function(_, value) E.private.auras.masque.debuffs = value E:StaticPopup_Show("PRIVATE_RL") end,
					disabled = function() return not E.private.auras.enable or not E.private.auras.debuffsHeader or not E.Masque end
				},
				timeGroup = {
					order = 13,
					type = "group",
					name = L["Time"],
					args = {
						timeFont = {
							order = 1,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						timeFontSize = {
							order = 2,
							type = "range",
							name = L["Font Size"],
							min = 4, max = 32, step = 1
						},
						timeFontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = C.Values.FontFlags
						},
						spacer = {
							order = 4,
							type = "description",
							name = ""
						},
						timeXOffset = {
							order = 5,
							type = "range",
							name = L["Time X-Offset"],
							min = -60, max = 60, step = 1
						},
						timeYOffset = {
							order = 6,
							type = "range",
							name = L["Time Y-Offset"],
							min = -60, max = 60, step = 1
						}
					}
				},
				countGroup = {
					order = 14,
					type = "group",
					name = L["Count"],
					args = {
						countFont = {
							order = 1,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						countFontSize = {
							order = 2,
							type = "range",
							name = L["Font Size"],
							min = 4, max = 32, step = 1
						},
						countFontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = C.Values.FontFlags
						},
						spacer = {
							order = 4,
							type = "description",
							name = ""
						},
						countXOffset = {
							order = 5,
							type = "range",
							name = L["Time X-Offset"],
							min = -60, max = 60, step = 1
						},
						countYOffset = {
							order = 6,
							type = "range",
							name = L["Time Y-Offset"],
							min = -60, max = 60, step = 1
						}
					}
				},
				statusBar = {
					order = 15,
					type = "group",
					name = L["Status Bar"],
					args = {
						barShow = {
							order = 1,
							type = "toggle",
							name = L["ENABLE"]
						},
						spacer = {
							order = 2,
							type = "description",
							name = ""
						},
						barTexture = {
							order = 3,
							type = "select",
							dialogControl = "LSM30_Statusbar",
							name = L["Texture"],
							values = AceGUIWidgetLSMlists.statusbar,
							disabled = function() return not E.db.auras.debuffs.barShow end
						},
						barSize = {
							order = 4,
							type = "range",
							name = L["Size"],
							min = 1, max = 10, step = 1,
							disabled = function() return not E.db.auras.debuffs.barShow end
						},
						barSpacing = {
							order = 5,
							type = "range",
							name = L["Spacing"],
							min = -10, max = 10, step = 1,
							disabled = function() return not E.db.auras.debuffs.barShow end
						},
						barPosition = {
							order = 6,
							type = "select",
							name = L["Position"],
							values = {
								TOP = L["Top"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								RIGHT = L["Right"]
							},
							disabled = function() return not E.db.auras.debuffs.barShow end
						},
						barNoDuration = {
							order = 7,
							type = "toggle",
							name = L["No Duration"],
							disabled = function() return not E.db.auras.debuffs.barShow end
						},
						barColorGradient = {
							order = 8,
							type = "toggle",
							name = L["Color by Value"],
							disabled = function() return not E.db.auras.debuffs.barShow end
						},
						barColor = {
							order = 9,
							type = "color",
							name = L["COLOR"],
							hasAlpha = false,
							get = function()
								local t = E.db.auras.debuffs.barColor
								local d = P.auras.debuffs.barColor
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(_, r, g, b)
								local t = E.db.auras.debuffs.barColor
								t.r, t.g, t.b = r, g, b
								A:UpdateHeader(A.DebuffFrame)
							end,
							disabled = function() return not E.db.auras.debuffs.barShow or E.db.auras.debuffs.barColorGradient end
						}
					}
				}
			}
		},
		weapons = {
			order = 10,
			type = "group",
			name = L["Weapons"],
			get = function(info)
				return E.db.auras.weapons[info[#info]]
			end,
			set = function(info, value)
				E.db.auras.weapons[info[#info]] = value
				A:UpdateTempEnchant()
				A:UpdateTempEnchantHeader()
				A:UpdateTempEnchantQuality()
			end,
			disabled = function() return not E.private.auras.enable or not E.private.auras.weaponsHeader end,
			args = {
				growthDirection = {
					order = 1,
					type = "select",
					name = L["Growth Direction"],
					values = {
						RIGHT_LEFT = format(L["%s and then %s"], L["Right"], L["Left"]),
						LEFT_RIGHT = format(L["%s and then %s"], L["Left"], L["Right"]),
						DOWN_UP = format(L["%s and then %s"], L["Down"], L["Up"]),
						UP_DOWN = format(L["%s and then %s"], L["Up"], L["Down"])
					}
				},
				size = {
					order = 2,
					type = "range",
					name = L["Size"],
					desc = L["Set the size of the individual auras."],
					min = 16, max = 60, step = 1
				},
				spacing = {
					order = 3,
					type = "range",
					name = L["Spacing"],
					min = -1, max = 50, step = 1
				},
				fadeThreshold = {
					order = 4,
					type = "range",
					name = L["Fade Threshold"],
					desc = L["Threshold before the icon will fade out and back in. Set to -1 to disable."],
					min = -1, max = 30, step = 1
				},
				showDuration = {
					order = 5,
					type = "toggle",
					name = L["Duration Enable"],
				},
				quality = {
					order = 6,
					type = "toggle",
					name = L["Show Quality Color"],
					desc = L["Colors the border according to the Quality of the Item."]
				},
				fontGroup = {
					order = 7,
					type = "group",
					name = L["Time"],
					args = {
						timeFont = {
							order = 1,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						timeFontSize = {
							order = 2,
							type = "range",
							name = L["FONT_SIZE"],
							min = 6, max = 32, step = 1
						},
						timeFontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = C.Values.FontFlags
						},
						spacer = {
							order = 4,
							type = "description",
							name = ""
						},
						timeXOffset = {
							order = 5,
							type = "range",
							name = L["Time X-Offset"],
							min = -60, max = 60, step = 1
						},
						timeYOffset = {
							order = 6,
							type = "range",
							name = L["Time Y-Offset"],
							min = -60, max = 60, step = 1
						}
					}
				},
				statusBar = {
					order = 8,
					type = "group",
					name = L["Status Bar"],
					get = function(info) return E.db.auras.weapons[info[#info]] end,
					set = function(info, value) E.db.auras.weapons[info[#info]] = value A:UpdateTempEnchant() end,
					args = {
						barShow = {
							order = 1,
							type = "toggle",
							name = L["ENABLE"]
						},
						spacer = {
							order = 2,
							type = "description",
							name = ""
						},
						barTexture = {
							order = 3,
							type = "select",
							dialogControl = "LSM30_Statusbar",
							name = L["Texture"],
							values = AceGUIWidgetLSMlists.statusbar,
							disabled = function() return not E.db.auras.weapons.barShow end
						},
						barSize = {
							order = 4,
							type = "range",
							name = L["Size"],
							min = 1, max = 10, step = 1,
							disabled = function() return not E.db.auras.weapons.barShow end
						},
						barSpacing = {
							order = 5,
							type = "range",
							name = L["Spacing"],
							min = -10, max = 10, step = 1,
							disabled = function() return not E.db.auras.weapons.barShow end
						},
						barPosition = {
							order = 6,
							type = "select",
							name = L["Position"],
							values = {
								TOP = L["Top"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								RIGHT = L["Right"]
							},
							disabled = function() return not E.db.auras.weapons.barShow end
						},
						colorType = {
							order = 7,
							type = "select",
							name = L["Bar Color"],
							values = {
								CUSTOM = L["CUSTOM"],
								VALUE = L["Color by Value"],
								QUALITY = L["Color by Quality"]
							},
							get = function(info)
								return E.db.auras.weapons.colorType
							end,
							set = function(_, value)
								E.db.auras.weapons.colorType = value
								A:UpdateTempEnchant()
								A:UpdateTempEnchantQuality()
								A:UpdateTempEnchantStatusBar()
							end,
							disabled = function() return not E.db.auras.weapons.barShow end
						},
						barColor = {
							order = 8,
							type = "color",
							name = L["COLOR"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.auras.weapons.barColor
								local d = P.auras.weapons.barColor
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b)
								local t = E.db.auras.weapons.barColor
								t.r, t.g, t.b = r, g, b
								A:UpdateTempEnchant()
							end,
							disabled = function() return not E.db.auras.weapons.barShow or (E.db.auras.weapons.colorType ~= "CUSTOM" or not E.db.auras.weapons.barShow) end
						}
					}
				}
			}
		},
		reminder = {
			order = 11,
			type = "group",
			name = L["Reminder"],
			get = function(info) return E.db.general.reminder[info[#info]] end,
			set = function(info, value) E.db.general.reminder[info[#info]] = value RB:UpdateSettings() end,
			disabled = function() return not E.private.general.minimap.enable end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["ENABLE"],
					desc = L["Display reminder bar on the minimap."],
					set = function(info, value) E.db.general.reminder[info[#info]] = value M:UpdateSettings() end
				},
				generalGroup = {
					order = 2,
					type = "group",
					guiInline = true,
					name = L["General"],
					disabled = function() return not E.db.general.reminder.enable end,
					args = {
						durations = {
							order = 1,
							type = "toggle",
							name = L["Remaining Time"]
						},
						reverse = {
							order = 2,
							type = "toggle",
							name = L["Reverse Style"],
							desc = L["When enabled active buff icons will light up instead of becoming darker, while inactive buff icons will become darker instead of being lit up."]
						},
						masque = {
							order = 3,
							type = "toggle",
							name = L["Masque Support"],
							desc = L["Allow Masque to handle the skinning of this element."],
							get = function() return E.private.auras.masque.reminder end,
							set = function(_, value) E.private.auras.masque.reminder = value E:StaticPopup_Show("PRIVATE_RL") end,
							disabled = function() return not E.db.general.reminder.enable or not E.private.general.minimap.enable or not E.Masque end
						},
						position = {
							order = 4,
							type = "select",
							name = L["Position"],
							set = function(info, value) E.db.general.reminder[info[#info]] = value RB:UpdatePosition() end,
							values = {
								LEFT = L["Left"],
								RIGHT = L["Right"]
							}
						}
					}
				},
				fontGroup = {
					order = 3,
					type = "group",
					guiInline = true,
					name = L["Font"],
					disabled = function() return not E.db.general.reminder.enable or not E.db.general.reminder.durations end,
					args = {
						font = {
							order = 1,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						fontSize = {
							order = 2,
							type = "range",
							name = L["FONT_SIZE"],
							min = 6, max = 22, step = 1
						},
						fontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = C.Values.FontFlags
						}
					}
				}
			}
		}
	}
}