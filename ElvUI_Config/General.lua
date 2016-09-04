local E, L, V, P, G = unpack(ElvUI);
local B = E:GetModule("Blizzard")

E.Options.args.general = {
	type = "group",
	name = L["General"],
	order = 1,
	childGroups = "tab",
	get = function(info) return E.db.general[ info[#info] ] end,
	set = function(info, value) E.db.general[ info[#info] ] = value end,
	args = {
		animateConfig = {
			order = 1,
			type = "toggle",
			name = L["Animate Config"],
			get = function(info) return E.global.general.animateConfig; end,
			set = function(info, value) E.global.general.animateConfig = value; E:StaticPopup_Show("GLOBAL_RL"); end
		},
		spacer = {
			order = 2,
			type = "description",
			name = "",
			width = "full"
		},
		intro = {
			order = 3,
			type = "description",
			name = L["ELVUI_DESC"],
		},
		general = {
			order = 4,
			type = "group",
			name = L["General"],
			args = {
			header = {
 					order = 0,
					type = "header",
					name = L["General"],
				},
				pixelPerfect = {
					order = 1,
					name = L['Pixel Perfect'],
					desc = L['The Pixel Perfect option will change the overall apperance of your UI. Using Pixel Perfect is a slight performance increase over the traditional layout.'],
					type = 'toggle',
					get = function(info) return E.private.general.pixelPerfect end,
					set = function(info, value) E.private.general.pixelPerfect = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				interruptAnnounce = {
					order = 2,
					name = L['Announce Interrupts'],
					desc = L['Announce when you interrupt a spell to the specified chat channel.'],
					type = 'select',
					values = {
						['NONE'] = NONE,
						['SAY'] = SAY,
						['PARTY'] = L["Party Only"],
						['RAID'] = L["Party / Raid"],
						['RAID_ONLY'] = L["Raid Only"],
						["EMOTE"] = CHAT_MSG_EMOTE,
					},
				},
				autoRepair = {
					order = 3,
					name = L['Auto Repair'],
					desc = L['Automatically repair using the following method when visiting a merchant.'],
					type = 'select',
					values = {
						['NONE'] = NONE,
						['GUILD'] = GUILD,
						['PLAYER'] = PLAYER,
					},
				},
				autoAcceptInvite = {
					order = 4,
					name = L['Accept Invites'],
					desc = L['Automatically accept invites from guild/friends.'],
					type = 'toggle',
				},
				vendorGrays = {
					order = 5,
					name = L['Vendor Grays'],
					desc = L['Automatically vendor gray items when visiting a vendor.'],
					type = 'toggle',
				},
				loot = {
					order = 6,
					type = "toggle",
					name = L['Loot'],
					desc = L['Enable/Disable the loot frame.'],
					get = function(info) return E.private.general.loot end,
					set = function(info, value) E.private.general.loot = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				autoRoll = {
					order = 7,
					name = L['Auto Greed/DE'],
					desc = L['Automatically select greed or disenchant (when available) on green quality items. This will only work if you are the max level.'],
					type = 'toggle',
					disabled = function() return not E.private.general.lootRoll end
				},
				lootRoll = {
					order = 8,
					type = "toggle",
					name = L['Loot Roll'],
					desc = L['Enable/Disable the loot roll frame.'],
					get = function(info) return E.private.general.lootRoll end,
					set = function(info, value) E.private.general.lootRoll = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				autoScale = {
					order = 9,
					name = L["Auto Scale"],
					desc = L["Automatically scale the User Interface based on your screen resolution"],
					type = "toggle",
					get = function(info) return E.global.general.autoScale end,
					set = function(info, value) E.global.general[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL") end
				},
				hideErrorFrame = {
					order = 10,
					name = L["Hide Error Text"],
					desc = L["Hides the red error text at the top of the screen while in combat."],
					type = "toggle"
				},
				eyefinity = {
					order = 11,
					name = L["Multi-Monitor Support"],
					desc = L["Attempt to support eyefinity/nvidia surround."],
					type = "toggle",
					get = function(info) return E.global.general.eyefinity end,
					set = function(info, value) E.global.general[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL") end
				},
				taintLog = {
					order = 12,
					type = "toggle",
					name = L["Log Taints"],
					desc = L["Send ADDON_ACTION_BLOCKED errors to the Lua Error frame. These errors are less important in most cases and will not effect your game performance. Also a lot of these errors cannot be fixed. Please only report these errors if you notice a Defect in gameplay."],
				},
				bottomPanel = {
					order = 13,
					type = 'toggle',
					name = L['Bottom Panel'],
					desc = L['Display a panel across the bottom of the screen. This is for cosmetic only.'],
					get = function(info) return E.db.general.bottomPanel end,
					set = function(info, value) E.db.general.bottomPanel = value; E:GetModule('Layout'):BottomPanelVisibility() end
				},
				topPanel = {
					order = 14,
					type = 'toggle',
					name = L['Top Panel'],
					desc = L['Display a panel across the top of the screen. This is for cosmetic only.'],
					get = function(info) return E.db.general.topPanel end,
					set = function(info, value) E.db.general.topPanel = value; E:GetModule('Layout'):TopPanelVisibility() end
				},
				afk = {
					order = 15,
					type = 'toggle',
					name = L['AFK Mode'],
					desc = L['When you go AFK display the AFK screen.'],
					get = function(info) return E.db.general.afk end,
					set = function(info, value) E.db.general.afk = value; E:GetModule('AFK'):Toggle() end
				},
				enhancedPvpMessages = {
					order = 16,
					type = "toggle",
					name = L["Enhanced PVP Messages"],
					desc = L["Display battleground messages in the middle of the screen."]
				},
				numberPrefixStyle = {
					order = 17,
					type = "select",
					name = L["Number Prefix"],
					get = function(info) return E.db.general.numberPrefixStyle end,
					set = function(info, value) E.db.general.numberPrefixStyle = value; E:StaticPopup_Show("CONFIG_RL") end,
					values = {
						["METRIC"] = "k, M, G",
						["ENGLISH"] = "K, M, B",
						["CHINESE"] = "W, Y",
					},
				},
				chatBubbles = {
					order = 30,
					type = "group",
					guiInline = true,
					name = L["Chat Bubbles"],
					args = {
						style = {
							order = 1,
							type = "select",
							name = L["Chat Bubbles Style"],
							desc = L["Skin the blizzard chat bubbles."],
							get = function(info) return E.private.general.chatBubbles; end,
							set = function(info, value) E.private.general.chatBubbles = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							values = {
								['backdrop'] = L["Skin Backdrop"],
								['nobackdrop'] = L["Remove Backdrop"],
								['backdrop_noborder'] = L["Skin Backdrop (No Borders)"],
								['disabled'] = L["Disabled"]
							}
						},
						classColorMentionsSpeech = {
 							order = 2,
							type = "toggle",
							name = L["Class Color Mentions"],
							desc = L["Use class color for the names of players when they are mentioned."],
							get = function(info) return E.private.general.classColorMentionsSpeech end,
							set = function(info, value) E.private.general.classColorMentionsSpeech = value; E:StaticPopup_Show("PRIVATE_RL") end,
							disabled = function() return E.private.general.chatBubbles == "disabled" end,
						},
						font = {
							order = 3,
							type = "select",
							name = L["Font"],
							dialogControl = 'LSM30_Font',
							values = AceGUIWidgetLSMlists.font,
							get = function(info) return E.private.general.chatBubbleFont; end,
							set = function(info, value) E.private.general.chatBubbleFont = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							disabled = function() return E.private.general.chatBubbles == "disabled" end,
						},
						fontSize = {
							order = 4,
							type = "range",
							name = L["Font Size"],
							get = function(info) return E.private.general.chatBubbleFontSize; end,
							set = function(info, value) E.private.general.chatBubbleFontSize = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							min = 4, max = 20, step = 1,
							disabled = function() return E.private.general.chatBubbles == "disabled" end,
						},
					},
				},
			},
		},
		threat = {
			order = 6,
			get = function(info) return E.db.general.threat[ info[#info] ] end,
			set = function(info, value) E.db.general.threat[ info[#info] ] = value; E:GetModule('Threat'):ToggleEnable()end,
			type = "group",
			name = L['Threat'],
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["Threat"],
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				generalGroup = {
					order = 2,
					type = "group",
					guiInline = true,
					name = L["General"],
					disabled = function() return not E.db.general.threat.enable end,
					args = {
						position = {
							order = 1,
							type = 'select',
							name = L['Position'],
							desc = L['Adjust the position of the threat bar to either the left or right datatext panels.'],
							values = {
								['LEFTCHAT'] = L['Left Chat'],
								['RIGHTCHAT'] = L['Right Chat'],
							},
							set = function(info, value) E.db.general.threat[ info[#info] ] = value; E:GetModule('Threat'):UpdatePosition() end,
						},
					},
				},
				fontGroup = {
					order = 3,
					type = "group",
					guiInline = true,
					name = L["Font"],
					disabled = function() return not E.db.general.threat.enable end,
					args = {
						textfont = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 4,
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font,
							set = function(info, value) E.db.general.threat[ info[#info] ] = value; E:GetModule('Threat'):UpdatePosition() end,
						},
						textSize = {
							order = 5,
							name = L["Font Size"],
							type = "range",
							min = 6, max = 22, step = 1,
							set = function(info, value) E.db.general.threat[ info[#info] ] = value; E:GetModule('Threat'):UpdatePosition() end,
						},
						textOutline = {
							order = 6,
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							type = "select",
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = 'OUTLINE',
								['MONOCHROME'] = (not E.isMacClient) and 'MONOCHROME' or nil,
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE',
							},
							set = function(info, value) E.db.general.threat[ info[#info] ] = value; E:GetModule('Threat'):UpdatePosition() end,
						},
					},
				},
			},
		},	
		totems = {
			order = 7,
			type = "group",
			name = TUTORIAL_TITLE47,
			get = function(info) return E.db.general.totems[ info[#info] ] end,
			set = function(info, value) E.db.general.totems[ info[#info] ] = value; E:GetModule('Totems'):PositionAndSize() end,
			args = {
				header = {
 					order = 0,
					type = "header",
					name = L["Totem Bar"],
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value) E.db.general.totems[ info[#info] ] = value; E:GetModule('Totems'):ToggleEnable() end,
				},
				generalGroup = {
					order = 2,
					type = "group",
					guiInline = true,
					name = L["General"],
					disabled = function() return not E.db.general.totems.enable end,
					args = {
						size = {
							order = 1,
							type = 'range',
							name = L["Button Size"],
							desc = L['Set the size of your bag buttons.'],
							min = 24, max = 60, step = 1,
						},
						spacing = {
							order = 2,
							type = 'range',
							name = L['Button Spacing'],
							desc = L['The spacing between buttons.'],
							min = 1, max = 10, step = 1,
						},
						sortDirection = {
							order = 3,
							type = 'select',
							name = L["Sort Direction"],
							desc = L['The direction that the bag frames will grow from the anchor.'],
							values = {
								['ASCENDING'] = L['Ascending'],
								['DESCENDING'] = L['Descending'],
							},
						},
						growthDirection = {
							order = 4,
							type = 'select',
							name = L['Bar Direction'],
							desc = L['The direction that the bag frames be (Horizontal or Vertical).'],
							values = {
								['VERTICAL'] = L['Vertical'],
								['HORIZONTAL'] = L['Horizontal'],
							},
						},
					},
				},
			},
		},
		cooldown = {
			type = "group",
			order = 10,
			name = L['Cooldown Text'],
			get = function(info)
				local t = E.db.cooldown[ info[#info] ]
				local d = P.cooldown[info[#info]]
				return t.r, t.g, t.b, t.a, d.r, d.g, d.b
			end,
			set = function(info, r, g, b)
				E.db.cooldown[ info[#info] ] = {}
				local t = E.db.cooldown[ info[#info] ]
				t.r, t.g, t.b = r, g, b
				E:UpdateCooldownSettings();
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["Cooldown Text"],
				},
				enable = {
					type = "toggle",
					order = 1,
					name = L['Enable'],
					desc = L['Display cooldown text on anything with the cooldown spiril.'],
					get = function(info) return E.private.cooldown[ info[#info] ] end,
					set = function(info, value) E.private.cooldown[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				threshold = {
					type = 'range',
					name = L['Low Threshold'],
					desc = L['Threshold before text turns red and is in decimal form. Set to -1 for it to never turn red'],
					min = -1, max = 20, step = 1,
					order = 2,
					get = function(info) return E.db.cooldown[ info[#info] ] end,
					set = function(info, value)
						E.db.cooldown[ info[#info] ] = value
						E:UpdateCooldownSettings();
					end,
				},
				restoreColors = {
					type = 'execute',
					name = L["Restore Defaults"],
					order = 3,
					func = function() 
						E.db.cooldown.expiringColor = P['cooldown'].expiringColor;
						E.db.cooldown.secondsColor = P['cooldown'].secondsColor;
						E.db.cooldown.minutesColor = P['cooldown'].minutesColor;
						E.db.cooldown.hoursColor = P['cooldown'].hoursColor;
						E.db.cooldown.daysColor = P['cooldown'].daysColor;
						E:UpdateCooldownSettings();
					end,
				},
				expiringColor = {
					type = 'color',
					order = 4,
					name = L['Expiring'],
					desc = L['Color when the text is about to expire'],
				},
				secondsColor = {
					type = 'color',
					order = 5,
					name = L['Seconds'],
					desc = L['Color when the text is in the seconds format.'],
				},
				minutesColor = {
					type = 'color',
					order = 6,
					name = L['Minutes'],
					desc = L['Color when the text is in the minutes format.'],
				},
				hoursColor = {
					type = 'color',
					order = 7,
					name = L['Hours'],
					desc = L['Color when the text is in the hours format.'],
				},	
				daysColor = {
					type = 'color',
					order = 8,
					name = L['Days'],
					desc = L['Color when the text is in the days format.'],
				},
			},
		},
		reminder = {
			type = 'group',
			order = 11,
			name = L['Reminder'],
			get = function(info) return E.db.general.reminder[ info[#info] ] end,
			set = function(info, value) E.db.general.reminder[ info[#info] ] = value; E:GetModule('ReminderBuffs'):UpdateSettings(); end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["Reminder"],
				},
				enable = {
					order = 1,
					name = L['Enable'],
					desc = L['Display reminder bar on the minimap.'],
					type = 'toggle',
					set = function(info, value) E.db.general.reminder[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings(); end
				},
				generalGroup = {
					order = 2,
					type = 'group',
					guiInline = true,
					name = L['General'],
					disabled = function() return not E.db.general.reminder.enable end,
					args = {
						durations = {
							order = 1,
							name = L['Remaining Time'],
							type = 'toggle'
						},
						reverse = {
							order = 2,
							name = L['Reverse highlight'],
							type = 'toggle'
						},
						position = {
							order = 3,
							type = "select",
							name = L["Position"],
							set = function(info, value) E.db.general.reminder[ info[#info] ] = value; E:GetModule("ReminderBuffs"):UpdatePosition(); end,
							values = {
								["LEFT"] = L["Left"],
								["RIGHT"] = L["Right"]
							},
						},
					},
				},
				fontGroup = {
					order = 3,
					type = 'group',
					guiInline = true,
					name = L['Font'],
					disabled = function() return not E.db.general.reminder.enable or not E.db.general.reminder.durations end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 1,
							name = L['Font'],
							values = AceGUIWidgetLSMlists.font
						},
						fontSize = {
							order = 2,
							name = L['Font Size'],
							type = 'range',
							min = 6, max = 22, step = 1
						},
						fontOutline = {
							order = 3,
							name = L['Font Outline'],
							desc = L['Set the font outline.'],
							type = 'select',
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = 'OUTLINE',
								['MONOCHROME'] = (not E.isMacClient) and 'MONOCHROME' or nil,
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE'
							},
						},
					},
				},
			},
		},
		watchFrame = {
			order = 11,
			type = "group",
			name = L["Watch Frame"],
			get = function(info) return E.db.general[ info[#info] ]; end,
			set = function(info, value) E.db.general[ info[#info] ] = value; end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["Objective Frame"],
				},
				watchFrameHeight = {
					order = 1,
					type = "range",
					name = L["Watch Frame Height"],
					desc = L["Height of the watch tracker. Increase size to be able to see more objectives."],
					min = 400, max = E.screenheight, step = 1,
					set = function(info, value) E.db.general.watchFrameHeight = value; E:GetModule('Blizzard'):WatchFrameHeight(); end
				}
			}
		}
	}
};

E.Options.args.media = {
	order = 2,
	type = "group",
	name = L["Media"],
	get = function(info) return E.db.general[ info[#info] ] end,
	set = function(info, value) E.db.general[ info[#info] ] = value end,
	args = {
		fontHeader = {
 			order = 1,
			type = "header",
			name = L["Fonts"],
		},
		fontSize = {
			order = 2,
			name = L["Font Size"],
			desc = L["Set the font size for everything in UI. Note: This doesn't effect somethings that have their own seperate options (UnitFrame Font, Datatext Font, ect..)"],
			type = "range",
			min = 6, max = 22, step = 1,
			set = function(info, value) E.db.general[ info[#info] ] = value; E:UpdateMedia(); E:UpdateFontTemplates(); end,
		},	
		font = {
			type = "select", dialogControl = 'LSM30_Font',
			order = 3,
			name = L["Default Font"],
			desc = L["The font that the core of the UI will use."],
			values = AceGUIWidgetLSMlists.font,	
			set = function(info, value) E.db.general[ info[#info] ] = value; E:UpdateMedia(); E:UpdateFontTemplates(); end,
		},
		applyFontToAll = {
			order = 4,
			type = "execute",
			name = L["Apply Font To All"],
			desc = L["Applies the font and font size settings throughout the entire user interface. Note: Some font size settings will be skipped due to them having a smaller font size by default."],
			func = function()
				local font = E.db.general.font;
				local fontSize = E.db.general.fontSize;

				E.db.bags.itemLevelFont = font;
				E.db.bags.itemLevelFontSize = fontSize;
				E.db.bags.countFont = font;
				E.db.bags.countFontSize = fontSize;
				E.db.nameplate.font = font;
				--E.db.nameplate.fontSize = fontSize;
				E.db.nameplate.buffs.font = font;
				--E.db.nameplate.buffs.fontSize = fontSize;
				E.db.nameplate.debuffs.font = font;
				--E.db.nameplate.debuffs.fontSize = fontSize;
				E.db.actionbar.font = font
				--E.db.actionbar.fontSize = fontSize
				E.db.auras.font = font;
				E.db.auras.fontSize = fontSize;
				E.db.general.reminder.font = font;
				--E.db.general.reminder.fontSize = fontSize;
				E.db.chat.font = font;
				E.db.chat.fontSize = fontSize;
				E.db.chat.tabFont = font;
				E.db.chat.tapFontSize = fontSize;
				E.db.datatexts.font = font;
				E.db.datatexts.fontSize = fontSize;
				E.db.tooltip.font = font;
				E.db.tooltip.fontSize = fontSize;
				E.db.tooltip.headerFontSize = fontSize;
				E.db.tooltip.textFontSize = fontSize;
				E.db.tooltip.smallTextFontSize = fontSize;
				E.db.tooltip.healthBar.font = font;
				--E.db.tooltip.healthbar.fontSize = fontSize;
				E.db.unitframe.font = font;
				--E.db.unitframe.fontSize = fontSize;
				--E.db.unitframe.units.party.rdebuffs.font = font;
				E.db.unitframe.units.raid.rdebuffs.font = font;
				E.db.unitframe.units.raid40.rdebuffs.font = font;

				E:UpdateAll(true);
			end,
		},
		dmgfont = {
			type = "select", dialogControl = 'LSM30_Font',
			order = 5,
			name = L["CombatText Font"],
			desc = L["The font that combat text will use. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r"],
			values = AceGUIWidgetLSMlists.font,
			get = function(info) return E.private.general[ info[#info] ] end,
			set = function(info, value) E.private.general[ info[#info] ] = value; E:UpdateMedia(); E:UpdateFontTemplates(); E:StaticPopup_Show("PRIVATE_RL"); end,
		},
		namefont = {
			type = "select", dialogControl = 'LSM30_Font',
			order = 6,
			name = L["Name Font"],
			desc = L["The font that appears on the text above players heads. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r"],
			values = AceGUIWidgetLSMlists.font,
			get = function(info) return E.private.general[ info[#info] ] end,
			set = function(info, value) E.private.general[ info[#info] ] = value; E:UpdateMedia(); E:UpdateFontTemplates(); E:StaticPopup_Show("PRIVATE_RL"); end,
		},
		replaceBlizzFonts = {
			order = 7,
			type = "toggle",
			name = L["Replace Blizzard Fonts"],
			desc = L["Replaces the default Blizzard fonts on various panels and frames with the fonts chosen in the Media section of the ElvUI config. NOTE: Any font that inherits from the fonts ElvUI usually replaces will be affected as well if you disable this. Enabled by default."],
			get = function(info) return E.private.general[ info[#info] ]; end,
			set = function(info, value) E.private.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end
		},
		texturesHeaderSpacing = {
			order = 19,
			type = "description",
			name = " ",
		},
		texturesHeader = {
			order = 20,
			type = "header",
 			name = L["Textures"],
		},
		normTex = {
			type = "select", dialogControl = 'LSM30_Statusbar',
			order = 21,
			name = L["Primary Texture"],
			desc = L["The texture that will be used mainly for statusbars."],
			values = AceGUIWidgetLSMlists.statusbar,
			get = function(info) return E.private.general[ info[#info] ]; end,
			set = function(info, value)
				local previousValue = E.private.general[ info[#info] ];
				E.private.general[ info[#info] ] = value;

				if(E.db.unitframe.statusbar == previousValue) then
					E.db.unitframe.statusbar = value;
					E:UpdateAll(true);
				else
					E:UpdateMedia();
					E:UpdateStatusBars();
				end
			end
		},
		glossTex = {
			type = "select", dialogControl = 'LSM30_Statusbar',
			order = 22,
			name = L["Secondary Texture"],
			desc = L["This texture will get used on objects like chat windows and dropdown menus."],
			values = AceGUIWidgetLSMlists.statusbar,
			get = function(info) return E.private.general[ info[#info] ]; end,
			set = function(info, value)
				E.private.general[ info[#info] ] = value;
				E:UpdateMedia();
				E:UpdateFrameTemplates();
			end
		},
		applyTextureToAll = {
			order = 23,
			type = "execute",
			name = L["Apply Texture To All"],
			desc = L["Applies the primary texture to all statusbars."],
			func = function()
				local texture = E.private.general.normTex;
				E.db.unitframe.statusbar = texture;
				E:UpdateAll(true);
			end,
		},
		colorsHeaderSpacing = {
			order = 29,
			type = "description",
			name = " ",
		},
		colorsHeader = {
			order = 30,
			type = "header",
 			name = L["Colors"],
		},
		bordercolor = {
			type = "color",
			order = 31,
			name = L["Border Color"],
			desc = L["Main border color of the UI. |cffFF0000This is disabled if you are using the pixel perfect theme.|r"],
			hasAlpha = false,
			get = function(info)
				local t = E.db.general[ info[#info] ]
				local d = P.general[info[#info]]
				return t.r, t.g, t.b, t.a, d.r, d.g, d.b
			end,
			set = function(info, r, g, b)
				E.db.general[ info[#info] ] = {}
				local t = E.db.general[ info[#info] ]
				t.r, t.g, t.b = r, g, b
				E:UpdateMedia()
				E:UpdateBorderColors()
			end,
			disabled = function() return E.PixelMode end,
		},
		backdropcolor = {
			type = "color",
			order = 32,
			name = L["Backdrop Color"],
			desc = L["Main backdrop color of the UI."],
			hasAlpha = false,
			get = function(info)
				local t = E.db.general[ info[#info] ]
				local d = P.general[info[#info]]
				return t.r, t.g, t.b, t.a, d.r, d.g, d.b
			end,
			set = function(info, r, g, b)
				E.db.general[ info[#info] ] = {}
				local t = E.db.general[ info[#info] ]
				t.r, t.g, t.b = r, g, b
				E:UpdateMedia()
				E:UpdateBackdropColors()
			end,
		},
		backdropfadecolor = {
			type = "color",
			order = 33,
			name = L["Backdrop Faded Color"],
			desc = L["Backdrop color of transparent frames"],
			hasAlpha = true,
			get = function(info)
				local t = E.db.general[ info[#info] ]
				local d = P.general[info[#info]]
				return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
			end,
			set = function(info, r, g, b, a)
				E.db.general[ info[#info] ] = {}
				local t = E.db.general[ info[#info] ]
				t.r, t.g, t.b, t.a = r, g, b, a
				E:UpdateMedia()
				E:UpdateBackdropColors()
			end,
		},
		valuecolor = {
			type = "color",
			order = 34,
			name = L["Value Color"],
			desc = L["Color some texts use."],
			hasAlpha = false,
			get = function(info)
				local t = E.db.general[ info[#info] ]
				local d = P.general[info[#info]]
				return t.r, t.g, t.b, t.a, d.r, d.g, d.b
			end,
			set = function(info, r, g, b, a)
				E.db.general[ info[#info] ] = {}
				local t = E.db.general[ info[#info] ]
				t.r, t.g, t.b, t.a = r, g, b, a
				E:UpdateMedia()
			end,
		},
	},
}