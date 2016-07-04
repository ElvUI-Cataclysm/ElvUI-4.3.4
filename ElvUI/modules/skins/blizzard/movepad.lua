local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins');

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.movepad ~= true then return end

	MovePadFrame:StripTextures()
	MovePadFrame:SetTemplate("Transparent")

	S:HandleButton(MovePadStrafeLeft)
	S:HandleButton(MovePadStrafeRight)
	S:HandleButton(MovePadForward)
	S:HandleButton(MovePadBackward)
	S:HandleButton(MovePadJump)

	S:HandleButton(MovePadLock)
	MovePadLock:StripTextures()
	MovePadLock:SetScale(0.70)
	MovePadLock:Point("BOTTOMRIGHT", MovePadFrame, "BOTTOMRIGHT", -4, 4);

end

S:RegisterSkin('Blizzard_MovePad', LoadSkin);