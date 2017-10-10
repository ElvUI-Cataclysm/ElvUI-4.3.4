local E, L, V, P, G, _ = unpack(ElvUI);
local A = E:GetModule('Auras')

local format = string.format

local function GetAuraOptions(headerName)
	local auraOptions = {
		header = {
			order = 1,
			type = "header",
			name = headerName
		},
		size = {
			order = 2,
			type = 'range',
			name = L["Size"],
			desc = L["Set the size of the individual auras."],
			min = 16, max = 60, step = 2
		},
		growthDirection = {
			order = 3,
			type = 'select',
			name = L["Growth Direction"],
			desc = L["The direction the auras will grow and then the direction they will grow after they reach the wrap after limit."],
			values = {
				DOWN_RIGHT = format(L["%s and then %s"], L["Down"], L["Right"]),
				DOWN_LEFT = format(L["%s and then %s"], L["Down"], L["Left"]),
				UP_RIGHT = format(L["%s and then %s"], L["Up"], L["Right"]),
				UP_LEFT = format(L["%s and then %s"], L["Up"], L["Left"]),
				RIGHT_DOWN = format(L["%s and then %s"], L["Right"], L["Down"]),
				RIGHT_UP = format(L["%s and then %s"], L["Right"], L["Up"]),
				LEFT_DOWN = format(L["%s and then %s"], L["Left"], L["Down"]),
				LEFT_UP = format(L["%s and then %s"], L["Left"], L["Up"])
			}
		},
		wrapAfter = {
			order = 4,
			type = 'range',
			name = L["Wrap After"],
			desc = L["Begin a new row or column after this many auras."],
			min = 1, max = 32, step = 1
		},
		maxWraps = {
			order = 5,
			type = 'range',
			name = L["Max Wraps"],
			desc = L["Limit the number of rows or columns."],
			min = 1, max = 32, step = 1
		},
		horizontalSpacing = {
			order = 6,
			type = 'range',
			name = L["Horizontal Spacing"],
			min = 0, max = 50, step = 1
		},
		verticalSpacing = {
			order = 7,
			type = 'range',
			name = L["Vertical Spacing"],
			min = 0, max = 50, step = 1
		},
		sortMethod = {
			order = 8,
			type = 'select',
			name = L["Sort Method"],
			desc = L["Defines how the group is sorted."],
			values = {
				['INDEX'] = L["Index"],
				['TIME'] = L["Time"],
				['NAME'] = L["Name"]
			}
		},
		sortDir = {
			order = 9,
			type = 'select',
			name = L["Sort Direction"],
			desc = L["Defines the sort order of the selected sort method."],
			values = {
				['+'] = L["Ascending"],
				['-'] = L["Descending"]
			}
		},
		seperateOwn = {
			order = 10,
			type = 'select',
			name = L["Seperate"],
			desc = L["Indicate whether buffs you cast yourself should be separated before or after."],
			values = {
				[-1] = L["Other's First"],
				[0] = L["No Sorting"],
				[1] = L["Your Auras First"]
			}
		}
	}

	return auraOptions
end

E.Options.args.auras = {
	type = 'group',
	name = BUFFOPTIONS_LABEL,
	childGroups = "tab",
	get = function(info) return E.db.auras[ info[#info] ] end,
	set = function(info, value) E.db.auras[ info[#info] ] = value; A:UpdateHeader(ElvUIPlayerBuffs); A:UpdateHeader(ElvUIPlayerDebuffs) A:UpdateTempEnchant() end,
	args = {
		intro = {
			order = 1,
			type = 'description',
			name = L['AURAS_DESC']
		},
		enable = {
			order = 2,
			type = 'toggle',
			name = L['Enable'],
			get = function(info) return E.private.auras[ info[#info] ] end,
			set = function(info, value) 
				E.private.auras[ info[#info] ] = value; 
				E:StaticPopup_Show("PRIVATE_RL")
			end
		},
		disableBlizzard = {
			order = 3,
			type = 'toggle',
			name = L['Disabled Blizzard'],
			get = function(info) return E.private.auras[ info[#info] ] end,
			set = function(info, value) 
				E.private.auras[ info[#info] ] = value; 
				E:StaticPopup_Show("PRIVATE_RL")
			end
		},
		general = {
			order = 4,
			type = 'group',
			name = L['General'],
			args = {
				header = {
					order = 1,
					type = "header",
					name = L["General"]
				},
				fadeThreshold = {
					order = 2,
					type = 'range',
					name = L["Fade Threshold"],
					desc = L['Threshold before text changes red, goes into decimal form, and the icon will fade. Set to -1 to disable.'],
					min = -1, max = 30, step = 1
				},
				timeXOffset = {
					order = 3,
					type = 'range',
					name = L['Time xOffset'],
					min = -60, max = 60, step = 1
				},		
				timeYOffset = {
					order = 4,
					type = 'range',
					name = L['Time yOffset'],
					min = -60, max = 60, step = 1
				},
				countXOffset = {
					order = 5,
					type = 'range',
					name = L['Count xOffset'],
					min = -60, max = 60, step = 1
				},
				countYOffset = {
					order = 6,
					type = 'range',
					name = L['Count yOffset'],
					min = -60, max = 60, step = 1
				},
				fontGroup = {
					order = 7,
					type = "group",
					name = L["Font"],
					guiInline = true,
					args = {
						font = {
							order = 1,
							type = "select", dialogControl = 'LSM30_Font',
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						fontSize = {
							order = 2,
							type = "range",
							name = FONT_SIZE,
							min = 6, max = 22, step = 1
						},
						fontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = {
								['NONE'] = NONE,
								['OUTLINE'] = 'OUTLINE',
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE'
							}
						}
					}
				},
				masque = {
					order = 8,
					type = "group",
					guiInline = true,
					name = L["Masque Support"],
					get = function(info) return E.private.auras.masque[info[#info]] end,
					set = function(info, value) E.private.auras.masque[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					args = {
						buffs = {
							order = 1,
							type = "toggle",
							name = L["Buffs"],
							desc = L["Allow Masque to handle the skinning of this element."],
							disabled = function() return not E.private.auras.enable end
						},
						debuffs = {
							order = 2,
							type = "toggle",
							name = L["Debuffs"],
							desc = L["Allow Masque to handle the skinning of this element."],
							disabled = function() return not E.private.auras.enable end
						},
						reminder = {
							order = 3,
							type = "toggle",
							name = L["Reminder"],
							desc = L["Allow Masque to handle the skinning of this element."],
							disabled = function() return not E.db.general.reminder.enable end
						}
					}
				}
			}
		},
		buffs = {
			order = 5,
			type = 'group',
			name = L['Buffs'],
			get = function(info) return E.db.auras.buffs[ info[#info] ] end,
			set = function(info, value) E.db.auras.buffs[ info[#info] ] = value; A:UpdateHeader(ElvUIPlayerBuffs) end,
			args = GetAuraOptions(L["Buffs"]),
		},
		debuffs = {
			order = 6,
			type = 'group',
			name = L['Debuffs'],
			get = function(info) return E.db.auras.debuffs[ info[#info] ] end,
			set = function(info, value) E.db.auras.debuffs[ info[#info] ] = value; A:UpdateHeader(ElvUIPlayerDebuffs) end,
			args = GetAuraOptions(L["Debuffs"]),
		},
		weapons = {
			order = 6,
			type = "group",
			name = L["Weapons"],
			get = function(info) return E.db.auras.weapons[ info[#info] ] end,
			set = function(info, value) E.db.auras.weapons[ info[#info] ] = value A:UpdateTempEnchant() end,
			args = {
				header = {
					order = 1,
					type = "header",
					name = L["Weapons"]
				},
				size = {
					order = 2,
					type = "range",
					name = L["Size"],
					desc = L["Set the size of the individual auras."],
					min = 16, max = 60, step = 1
				},
				growthDirection = {
					order = 3,
					type = "select",
					name = L["Growth Direction"],
					values = {
						["LEFT"] = L["Left"],
						["RIGHT"] = L["Right"]
					}
				},
				horizontalSpacing = {
					order = 4,
					type = "range",
					name = L["Horizontal Spacing"],
					min = 0, max = 50, step = 1
				},
				fontGroup = {
					order = 5,
					type = "group",
					guiInline = true,
					name = L["Font"],
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
							name = FONT_SIZE,
							min = 6, max = 22, step = 1
						},
						fontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							values = {
								["NONE"] = NONE,
								["OUTLINE"] = "OUTLINE",
								["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
								["THICKOUTLINE"] = "THICKOUTLINE"
							}
						}
					}
				}
			}
		},
		reminder = {
			order = 8,
			type = 'group',
			name = L['Reminder'],
			get = function(info) return E.db.general.reminder[ info[#info] ] end,
			set = function(info, value) E.db.general.reminder[ info[#info] ] = value; E:GetModule('ReminderBuffs'):UpdateSettings(); end,
			disabled = function() return not E.private.general.minimap.enable end,
			args = {
				header = {
					order = 1,
					type = "header",
					name = L['Reminder']
				},
				enable = {
					order = 2,
					type = 'toggle',
					name = L['Enable'],
					desc = L['Display reminder bar on the minimap.'],
					set = function(info, value) E.db.general.reminder[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings(); end
				},
				generalGroup = {
					order = 3,
					type = 'group',
					guiInline = true,
					name = L['General'],
					disabled = function() return not E.db.general.reminder.enable end,
					args = {
						durations = {
							order = 1,
							type = 'toggle',
							name = L['Remaining Time']
						},
						reverse = {
							order = 2,
							type = 'toggle',
							name = L["Reverse Style"],
							desc = L["When enabled active buff icons will light up instead of becoming darker, while inactive buff icons will become darker instead of being lit up."]
						},
						position = {
							order = 3,
							type = "select",
							name = L["Position"],
							set = function(info, value) E.db.general.reminder[ info[#info] ] = value; E:GetModule("ReminderBuffs"):UpdatePosition(); end,
							values = {
								["LEFT"] = L["Left"],
								["RIGHT"] = L["Right"]
							}
						}
					}
				},
				fontGroup = {
					order = 4,
					type = 'group',
					guiInline = true,
					name = L['Font'],
					disabled = function() return not E.db.general.reminder.enable or not E.db.general.reminder.durations end,
					args = {
						font = {
							order = 1,
							type = 'select', dialogControl = 'LSM30_Font',
							name = L['Font'],
							values = AceGUIWidgetLSMlists.font
						},
						fontSize = {
							order = 2,
							type = 'range',
							name = FONT_SIZE,
							min = 6, max = 22, step = 1
						},
						fontOutline = {
							order = 3,
							type = 'select',
							name = L['Font Outline'],
							desc = L['Set the font outline.'],
							values = {
								['NONE'] = NONE,
								['OUTLINE'] = 'OUTLINE',
								['MONOCHROME'] = (not E.isMacClient) and 'MONOCHROME' or nil,
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE'
							}
						}
					}
				}
			}
		}
	}
}