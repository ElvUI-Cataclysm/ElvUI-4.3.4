--[[
DT Text Colors, by Benik (Emerald Dream EU)

a plugin for ElvUI, that changes the DT text color to class color, value color or any user defined
]]--

local E, L, V, P, G, _ = unpack(ElvUI);
local DTC = E:NewModule('DataTextColors', 'AceEvent-3.0');
local DT = E:GetModule('DataTexts');
local EP = LibStub("LibElvUIPlugin-1.0")
local addon, ns = ...

local classColor = RAID_CLASS_COLORS[E.myclass]

if E.db.dtc == nil then E.db.dtc = {} end

-- Custom text color
local color = { r = 1, g = 1, b = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

-- Do the job
function DTC:ColorFont()
	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i = 1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			if E.db.dtc.customColor == 1 then
				panel.dataPanels[pointIndex].text:SetTextColor(classColor.r, classColor.g, classColor.b)
			elseif E.db.dtc.customColor == 2 then
				panel.dataPanels[pointIndex].text:SetTextColor(unpackColor(E.db.dtc.userColor))
			else
				panel.dataPanels[pointIndex].text:SetTextColor(unpackColor(E.db.general.valuecolor))
			end
		end
	end
end

-- Defaults
P['dtc'] = {
	['userColor'] = { r = 1, g = 1, b = 1 },
	['customColor'] = 2,
}

-- Options
function DTC:AddOptions()
	E.Options.args.datatexts.args.general.args.fontGroup.args.dtc = {
		order = 10,
		type = 'group',
		name = L["Text Color"],
		guiInline = true,
		args = {
			customColor = {
				order = 1,
				type = "select",
				name = COLOR,
				values = {
					[1] = CLASS_COLORS,
					[2] = CUSTOM,
					[3] = L["Value Color"],
				},
				get = function(info) return E.db.dtc[ info[#info] ] end,
				set = function(info, value) E.db.dtc[ info[#info] ] = value; DTC:ColorFont(); end,
			},
			userColor = {
				order = 2,
				type = "color",
				name = COLOR_PICKER,
				disabled = function() return E.db.dtc.customColor == 1 or E.db.dtc.customColor == 3 end,
				get = function(info)
					local t = E.db.dtc[ info[#info] ]
					return t.r, t.g, t.b, t.a
					end,
				set = function(info, r, g, b)
					local t = E.db.dtc[ info[#info] ]
					t.r, t.g, t.b = r, g, b
					DTC:ColorFont();
				end,
			},
		},
	}
end

function DTC:PLAYER_ENTERING_WORLD(...)
	self:ColorFont()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function DTC:Initialize()
	EP:RegisterPlugin(addon, self.AddOptions)
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

E:RegisterModule(DTC:GetName())
