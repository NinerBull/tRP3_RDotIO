local TRP3RIOOld_Frame = CreateFrame("Frame")
TRP3RIOOld_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")


TRP3RIOOld_Frame:SetScript("OnEvent", function(self, event, arg1, arg2)

	if (event == "PLAYER_ENTERING_WORLD") then

		if (C_AddOns.DoesAddOnExist("tRP3_RDotIO")) then
			C_AddOns.DisableAddOn("tRP3_RDotIO")
		end

	end

end)