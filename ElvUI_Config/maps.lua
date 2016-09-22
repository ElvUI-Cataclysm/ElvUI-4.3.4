local E, L, V, P, G, _ = unpack(ElvUI);

local M = E:GetModule("Minimap")

E.Options.args.maps = {
	type = "group",
	name = L["Maps"],
	childGroups = "tab",
	args = {
		worldMap = {
			order = 1,
			type = "group",
			name = WORLD_MAP,
			args = {
				header = {
					order = 0,
					type = "header",
					name = WORLD_MAP
				},
				smallerWorldMap = {
					order = 1,
					type = "toggle",
					name = L["Smaller World Map"],
					desc = L["Make the world map smaller."],
					descStyle = "inline",
					get = function(info) return E.global.general.smallerWorldMap; end,
					set = function(info, value) E.global.general.smallerWorldMap = value; E:StaticPopup_Show("GLOBAL_RL"); end,
					width = "double"
				},
				mapAlphaWhenMoving = {
					order = 2,
					type = "range",
					name = L["Map Opacity When Moving"],
					isPercent = true,
					min = 0, max = 1, step = 0.01,
					get = function(info) return E.global.general.mapAlphaWhenMoving; end,
					set = function(info, value) E.global.general.mapAlphaWhenMoving = value; end
				},
				spacer  = {
					order = 3,
					type = "description",
					name = "\n"
				},
				worldMapCoordinatesEnable = {
					order = 4,
					type = "toggle",
					name = L["World Map Coordinates"],
					desc = L["Puts coordinates on the world map."],
					descStyle = "inline",
					get = function(info) return E.global.general.WorldMapCoordinates.enable; end,
					set = function(info, value) E.global.general.WorldMapCoordinates.enable = value; E:StaticPopup_Show("GLOBAL_RL"); end,
					width = "full"
				},
				position = {
					order = 5,
					type = "select",
					name = L["Position"],
					get = function(info) return E.global.general.WorldMapCoordinates.position; end,
					set = function(info, value) E.global.general.WorldMapCoordinates.position = value; E:GetModule("WorldMap"):PositionCoords(); end,
					disabled = function() return not E.global.general.WorldMapCoordinates.enable; end,
					values = {
						["TOP"] = "TOP",
						["TOPLEFT"] = "TOPLEFT",
						["TOPRIGHT"] = "TOPRIGHT",
						["BOTTOM"] = "BOTTOM",
						["BOTTOMLEFT"] = "BOTTOMLEFT",
						["BOTTOMRIGHT"] = "BOTTOMRIGHT"
					}
				},
				xOffset = {
					order = 6,
					type = "range",
					name = L["X-Offset"],
					get = function(info) return E.global.general.WorldMapCoordinates.xOffset; end,
					set = function(info, value) E.global.general.WorldMapCoordinates.xOffset = value; E:GetModule("WorldMap"):PositionCoords(); end,
					disabled = function() return not E.global.general.WorldMapCoordinates.enable; end,
					min = -200, max = 200, step = 1
				},
				yOffset = {
					order = 7,
					type = "range",
					name = L["Y-Offset"],
					get = function(info) return E.global.general.WorldMapCoordinates.yOffset end,
					set = function(info, value) E.global.general.WorldMapCoordinates.yOffset = value; E:GetModule("WorldMap"):PositionCoords(); end,
					disabled = function() return not E.global.general.WorldMapCoordinates.enable end,
					min = -200, max = 200, step = 1
				}
			}
		},
		minimap = {
			order = 2,
			type = "group",
			name = MINIMAP_LABEL,
			get = function(info) return E.db.general.minimap[ info[#info] ]; end,
			args = {
				minimapHeader = {
					order = 1,
					type = "header",
					name = MINIMAP_LABEL
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the minimap. |cffFF0000Warning: This will prevent you from seeing the minimap datatexts.|r"],
					get = function(info) return E.private.general.minimap[ info[#info] ]; end,
					set = function(info, value) E.private.general.minimap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end
				},
				combatHide = {
 					order = 3,
					type = "toggle",
					name = L["Hide in Combat"],
					get = function(info) return E.db.general.minimap[ info[#info] ] end,
					set = function(info, value) E.db.general.minimap[ info[#info] ] = value end,
					disabled = function() return not E.private.general.minimap.enable end
				},
				size = {
					order = 4,
					type = "range",
					name = L["Size"],
					desc = L["Adjust the size of the minimap."],
					min = 120, max = 250, step = 1,
					get = function(info) return E.db.general.minimap[ info[#info] ]; end,
					set = function(info, value) E.db.general.minimap[ info[#info] ] = value; E:GetModule("Minimap"):UpdateSettings(); end,
					disabled = function() return not E.private.general.minimap.enable end
				},
				enableZoomReset = {
					order = 5,
					type = "toggle",
					name = L["Zoom Reset"],
					get = function(info) return E.db.general.minimap.resetZoom.enable end,
					set = function(info, value) E.db.general.minimap.resetZoom.enable = value; M:UpdateSettings() end,
					disabled = function() return not E.private.general.minimap.enable end
				},
				zoomRestTime = {
					order = 6,
					type = "range",
					name = L["Zoom Reset Timer"],
					min = 1, max = 15, step = 1,
					get = function(info) return E.db.general.minimap.resetZoom.time end,
					set = function(info, value) E.db.general.minimap.resetZoom.time = value; M:UpdateSettings() end,
					disabled = function() return not E.db.general.minimap.resetZoom.enable or not E.private.general.minimap.enable end
				},
				locationTextHeader = {
					order = 7,
					type = "header",
					name = L["Location Text"]
				},
				font = {
				    order = 8,
				    type = "select",
				    dialogControl = 'LSM30_Font',
				    name = L["Font"],
				    values = AceGUIWidgetLSMlists.font,
					get = function(info) return E.db.general.minimap[ info[#info] ]; end,
				    set = function(info, value) E.db.general.minimap.font = value; M:Update_ZoneText() end,
					disabled = function() return not E.private.general.minimap.enable end
				},
				fontSize = {
				    order = 9,
				    type = "range",
				    name = L["Font Size"],
				    min = 4, max = 212, step = 1,
					get = function(info) return E.db.general.minimap[ info[#info] ]; end,
				    set = function(info, value) E.db.general.minimap.fontSize = value; M:Update_ZoneText() end,
					disabled = function() return not E.private.general.minimap.enable end
				},
				textOutline = {
				    order = 10,
				    type = "select",
				    name = L["Font Outline"],
					get = function(info) return E.db.general.minimap[ info[#info] ]; end,
				    set = function(info, value) E.db.general.minimap.textOutline = value; M:Update_ZoneText() end,
				    values = {
				        ['NONE'] = L["None"],
				        ['OUTLINE'] = 'OUTLINE',
				        ['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
				        ['THICKOUTLINE'] = 'THICKOUTLINE'
				    },
					disabled = function() return not E.private.general.minimap.enable end
				},
				locationText = {
				    order = 11,
				    type = 'select',
				    name = L["Visibility"],
				    desc = L["Change settings for the display of the location text that is on the minimap."],
				    get = function(info) return E.db.general.minimap.locationText end,
				    set = function(info, value) E.db.general.minimap.locationText = value; M:UpdateSettings(); M:Update_ZoneText() end,
				    values = {
				        ['MOUSEOVER'] = L["Minimap Mouseover"],
				        ['SHOW'] = L["Always Display"],
				        ['HIDE'] = L["Hide"]
				    },
				    disabled = function() return not E.private.general.minimap.enable end
				},
				minimapButtonsHeader = {
					order = 12,
					type = "header",
					name = L["Minimap Buttons"]
				},
				icons = {
					order = 13,
					type = "group",
					name = L["Buttons"],
					args = {
						calendar = {
							order = 1,
							type = "group",
							name = L["Calendar"],
							get = function(info) return E.db.general.minimap.icons.calendar[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.calendar[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								hideCalendar = {
									order = 1,
									type = "toggle",
									name = L["Hide"],
									get = function(info) return E.private.general.minimap.hideCalendar end,
									set = function(info, value) E.private.general.minimap.hideCalendar = value; E:GetModule('Minimap'):UpdateSettings() end,
									width = "full"
								},
								spacer = {
									order = 2,
									type = "description",
									name = "",
									width = "full"
								},
								position = {
									order = 3,
									type = "select",
									name = L["Position"],
									disabled = function() return E.private.general.minimap.hideCalendar end,
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									}
								},
								scale = {
									order = 4,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
									disabled = function() return E.private.general.minimap.hideCalendar end,
								},
								xOffset = {
									order = 5,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideCalendar end
								},
								yOffset = {
									order = 6,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideCalendar end
								}
							}
						},
						mail = {
							order = 2,
							type = "group",
							name = MAIL_LABEL,
							get = function(info) return E.db.general.minimap.icons.mail[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.mail[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									}
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05
								},
								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1
								}
							}
						},
						lfgEye = {
							order = 3,
							type = "group",
							name = L["LFG Queue"],
							get = function(info) return E.db.general.minimap.icons.lfgEye[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.lfgEye[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									}
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05
								},
								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1
								}
							}
						},
						battlefield = {
							order = 4,
							type = "group",
							name = L["PvP Queue"],
							get = function(info) return E.db.general.minimap.icons.battlefield[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.battlefield[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									}
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05
								},
								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1
								}
							}
						},
						difficulty = {
							order = 5,
							type = "group",
							name = L["Instance Difficulty"],
							get = function(info) return E.db.general.minimap.icons.difficulty[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.difficulty[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									}
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05
								},
								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1
								}
							}
						},
						vehicleLeave = {
							order = 6,
							type = "group",
							name = LEAVE_VEHICLE,
							get = function(info) return E.db.general.minimap.icons.vehicleLeave[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.vehicleLeave[ info[#info] ] = value; E:GetModule('ActionBars'):UpdateVehicleLeave() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								hide = {
									order = 1,
									type = "toggle",
									name = L["Hide"]
								},
								spacer = {
									order = 2,
									type = "description",
									name = "",
									width = "full"
								},
								position = {
									order = 3,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									}
								},
								size = {
									order = 4,
									type = "range",
									name = L["Size"],
									min = 1, max = 50, step = 1
								},
								xOffset = {
									order = 5,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1
								},
								yOffset = {
									order = 6,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1
								}
							}
						},
						ticket = {
							order = 7,
							type = "group",
							name = L["GM Ticket"],
							get = function(info) return E.db.general.minimap.icons.ticket[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.ticket[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									}
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05
								},
								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1
								}
							}
						},
						zoomIn = {
							order = 8,
							type = "group",
							name = L["Zoom In"],
							get = function(info) return E.db.general.minimap.icons.zoomIn[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.zoomIn[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								hideZoomIn = {
									order = 1,
									type = "toggle",
									name = L["Hide"],
									get = function(info) return E.private.general.minimap.hideZoomIn end,
									set = function(info, value) E.private.general.minimap.hideZoomIn = value; E:GetModule('Minimap'):UpdateSettings() end,
									width = "full"
								},
								position = {
									order = 2,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									},
									disabled = function() return E.private.general.minimap.hideZoomIn end
								},
								scale = {
									order = 3,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
									disabled = function() return E.private.general.minimap.hideZoomIn end
								},
								xOffset = {
									order = 4,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideZoomIn end
								},
								yOffset = {
									order = 5,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideZoomIn end
								}
							}
						},
						zoomOut = {
							order = 9,
							type = "group",
							name = L["Zoom Out"],
							get = function(info) return E.db.general.minimap.icons.zoomOut[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.zoomOut[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.private.general.minimap.enable end,
							args = {
								hideZoomOut = {
									order = 1,
									type = "toggle",
									name = L["Hide"],
									get = function(info) return E.private.general.minimap.hideZoomOut end,
									set = function(info, value) E.private.general.minimap.hideZoomOut = value; E:GetModule('Minimap'):UpdateSettings() end,
									width = "full"
								},
								position = {
									order = 2,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"]
									},
									disabled = function() return E.private.general.minimap.hideZoomOut end
								},
								scale = {
									order = 3,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
									disabled = function() return E.private.general.minimap.hideZoomOut end
								},
								xOffset = {
									order = 4,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideZoomOut end
								},
								yOffset = {
									order = 5,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideZoomOut end
								}
							}
						}
					}
				}
			}
		}
	}
};