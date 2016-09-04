local MoveMyBuffBar = {}
function MoveMyBuffBar.init(f) 
	-- set up mover frame style
	f:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
	f:SetBackdropColor(0,1,0,0) 
	f:SetWidth(300)
	f:SetHeight(150)
	f:Show()
	f:RegisterForDrag("LeftButton")
	
	-- position wow buff frame relative to our mover frame
	BuffFrame:ClearAllPoints()
	BuffFrame:SetPoint("TOPRIGHT", f, "TOPRIGHT")
	BuffFrame.SetPoint = function() end	
	
	-- check for saved values 	
	if type(MoveMyBuffBarConfig) ~= "table" then
		MoveMyBuffBarConfig = {}
	end
	if MoveMyBuffBarConfig.buffsX and MoveMyBuffBarConfig.buffsY then
		print("|cff40c040MoveMyBuffBar: loading values from config|r")
		local s = f:GetEffectiveScale()
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", UIParent, 
			"BOTTOMLEFT", MoveMyBuffBarConfig.buffsX / s, MoveMyBuffBarConfig.buffsY / s)		
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		print("|cff40c040MoveMyBuffBar: no config found|r")
	end

	-- add slash commands to lock/unlock our frame and allow it to be moved
	_G["SLASH_MoveMyBuffBar1"] = "/MoveMyBuffBar"
	_G["SLASH_MoveMyBuffBar2"] = "/mmbb"
	_G["SlashCmdList"]["MoveMyBuffBar"] = function(command)
		if string.lower(command) == "lock" then
			f:SetBackdropColor(0,1,0,0)
			f:EnableMouse(false)
			f:SetMovable(false)
			MoveMyBuffBarConfig.Lock = true
			print("|cff40c040BuffBar Frame:|rLocked")
			MinimapCluster:SetMovable(false)
		elseif string.lower(command) == "unlock" then
			f:SetBackdropColor(0,1,0,1)
			f:EnableMouse(true)
			f:SetMovable(true)
			MoveMyBuffBarConfig.lock = nil
			print("|cff40c040BuffBar Frame:|rUnlocked")
		else 
			print("|cff40c040|r: ", "MoveMyBuffBar Commands:")
			print("|cff40c040|r: ", "/mmbb unlock")
			print("|cff40c040|r: ", "/mmbb lock")
		end
	end
	
	--  capture frame move events
	f:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
	f:SetScript("OnDragStop", function(frame)
		frame:StopMovingOrSizing()
		local s = frame:GetEffectiveScale()
		MoveMyBuffBarConfig.buffsX = frame:GetLeft() * s
		MoveMyBuffBarConfig.buffsY = frame:GetTop() * s
	end)	
end	

local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
	MoveMyBuffBar.init(self) 
	self:UnregisterEvent("PLAYER_LOGIN")
	self:SetScript("OnEvent", nil)	
end)
