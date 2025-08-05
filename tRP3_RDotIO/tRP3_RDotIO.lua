--[[
========================================
Total RP 3: Raider.IO Tooltip Support
https://github.com/NinerBull/tRP3_RDotIO
========================================

------------------------------------------
Requires both Total RP 3 and Raider.IO
https://github.com/Total-RP/Total-RP-3
https://github.com/RaiderIO/raiderio-addon
------------------------------------------
]]--

local _, L = ...;


local TRP3RIO_Frame = CreateFrame("Frame")
TRP3RIO_Frame:RegisterEvent("PLAYER_LOGIN")
TRP3RIO_Frame:RegisterEvent("PLAYER_LOGOUT")
TRP3RIO_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
TRP3RIO_Frame:RegisterEvent("MODIFIER_STATE_CHANGED")



local ignoretooltip = false
local loadedstuff = false


local TRP3RIO_DividerGraphic = CreateSimpleTextureMarkup("interface\\friendsframe\\ui-friendsframe-onlinedivider", 320, 4)
local TRP3RIO_OldSeasonColor = CreateColorFromHexString("FF555555")

-- Debug function, prints LUA tables
local function TRP3RIO_TPrint (t, s)
	for k, v in pairs(t) do
		local kfmt = '["' .. tostring(k) ..'"]'
		if type(k) ~= 'string' then
			kfmt = '[' .. k .. ']'
		end
		local vfmt = '"'.. tostring(v) ..'"'
		if type(v) == 'table' then
			TRP3RIO_TPrint(v, (s or '')..kfmt)
		else
			if type(v) ~= 'string' then
				vfmt = tostring(v)
			end
			print(type(t)..(s or '')..kfmt..' = '..vfmt)
		end
	end
end


--Fixes inconsistent font sizes
local function TRP3RIO_FixFonts(small)
	small = small or false
	local thisFontSize = TRP3_API.ui.tooltip.getSubLineFontSize()

	if (small == true) then
		thisFontSize = TRP3_API.ui.tooltip.getSmallLineFontSize()
	end

	local line = _G[strconcat(TRP3_CharacterTooltip:GetName(), "TextLeft", TRP3_CharacterTooltip:NumLines())]
	local font, _ , flag = line:GetFont()
	line:SetFont(font, thisFontSize, flag)
	
	local line2 = _G[strconcat(TRP3_CharacterTooltip:GetName(), "TextRight", TRP3_CharacterTooltip:NumLines())]
	local font2, _ , flag2 = line2:GetFont()
	line2:SetFont(font2, thisFontSize, flag2)

end


-- Variable for TPR3 config

TRPRIOTOOLTIPS = select(2, ...);

	local function TRP3RIO_Init()
		
		-- TRP3 Variables

		TRPRIOTOOLTIPS.CONFIG = {};

		TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC = "trp3_riotooltips_hide_tooltips_ic";
		TRPRIOTOOLTIPS.CONFIG.ENABLE_DIVIDER = "trp3_riotooltips_enable_divider";
		TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP = "trp3_riotooltips_enable_mini_tooltip";
		TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_TITLE = "trp3_riotooltips_enable_title";
		TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE = "trp3_riotooltips_enable_score";
		TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE = "trp3_riotooltips_enable_raid";
		TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN = "trp3_riotooltips_enable_score_main";
		TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN = "trp3_riotooltips_enable_raid_main";
		TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE = "trp3_riotooltips_enable_prev_score";

		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC, false);
		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_DIVIDER, false);
		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP, false);
		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_TITLE, true);
		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE, true);
		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE, true);
		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN, true);
		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN, true);
		TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE, 3);
		
		
		-- Upgrade from older version
		if (type(TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE)) ~= "number") then
			if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE) == true) then
				TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE, 3)
			else
				TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE, 1)
			end
		end
	
		-- Don't use Minified Tooltip in Classic
		if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
			TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP, false)
			TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_DIVIDER, false);
		end
		
		

TRP3RIO_Frame:SetScript("OnEvent", function(self, event, arg1, arg2)


	if event == "PLAYER_LOGIN" and loadedstuff == false then

	 if TRP3_CharacterTooltip ~= nil then
	 

		hooksecurefunc(TRP3_CharacterTooltip, "AddDoubleLine", function(t)
				TRP3RIO_FixFonts()
		end)

		hooksecurefunc(TRP3_CharacterTooltip, "AddLine", function(t)
		
		end)

	 
		TRP3_CharacterTooltip:HookScript("OnShow", function(t)
		
			TRP3RIO_MainColor = WHITE_FONT_COLOR
			TRP3RIO_TitleColor = NORMAL_FONT_COLOR
		
		
			if (TRP3_Configuration[CONFIG_TOOLTIP_MAIN_COLOR]) then
				TRP3RIO_MainColor = TRP3_API.CreateColorFromHexString(TRP3_API.configuration.getValue(CONFIG_TOOLTIP_MAIN_COLOR))
			end
			
			if (TRP3_Configuration[CONFIG_TOOLTIP_TITLE_COLOR]) then
				TRP3RIO_TitleColor = TRP3_API.CreateColorFromHexString(TRP3_API.configuration.getValue(CONFIG_TOOLTIP_TITLE_COLOR))				
			end
				
			
			local showTooltip = true
			
			local thisPlayerToLookUp = t.target
			--local thisPlayerToLookUp = "X-Y"
			
			
			--Check if IC/OOC and if disable when IC is enabled
			if (TRP3_API.dashboard.isPlayerIC() and TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC)) then
				--Hide tooltips, user is IC and hiding IC tooltips
				showTooltip = false
			end
			

			--unset variables
			varPlayerScore = ""
			varPlayerScorePrevNum = ""
			varPlayerMainScore = ""
			varPlayerMainScorePrev = ""
			strRaidProgress = ""
			strRaidMainProgress = ""
			strRaidProgressPrevious = ""
			varRaidName = ""
			varRaidNamePrevious = ""
			varPlayerScore = 0
			varPlayerScoreNum = 0
			varPlayerScorePrev = 0
			varPlayerScorePrevNum = 0
			varPlayerMainScore = 0
			varPlayerMainScorePrev = 0
			varPlayerMainScorePrevNum = 0
			varRaidNumNormal = 0
			varRaidNumHeroic = 0
			varRaidNumMythic = 0
			tblRaidProgress = nil
			tblRaidMainProgress = nil
			tblRaidProgressPrev = nil
							
			
		if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP)) then
			
			if showTooltip then
				

					thisPlayerTables = RaiderIO.GetProfile(thisPlayerToLookUp)
					
						
				if (thisPlayerTables) then
				
				
				
				
				if (thisPlayerTables["success"] == true) then
				
					loadedstuff = false
					
				
					--This player has a Raider.io Profile
								

				---------------------------------------------------
				
				-- MPLUS Info
				
				if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE)) then
								
						if (thisPlayerTables['mythicKeystoneProfile']) then
							if (thisPlayerTables['mythicKeystoneProfile']['hasRenderableData'] == true) then
							
								
									--This char
									varPlayerScore = 0
									if (thisPlayerTables['mythicKeystoneProfile']['mplusCurrent']['score']) then
										varPlayerScore = thisPlayerTables['mythicKeystoneProfile']['mplusCurrent']['score'];
									end
									varPlayerScoreNum = varPlayerScore
									varPlayerPrevSeason = false
									varPlayerScorePrevSeason = ""
									
									if (thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['score']) then
										if (varPlayerScore <= thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['score']) then
											varPlayerPrevSeason = true
										end
										
									end
									
									
									
									
									if (varPlayerPrevSeason) then	
									
									
										varPlayerScorePrevNum = thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['score']
										varPlayerScorePrevSeason = ""
										if (thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['season']) then
											varPlayerScorePrevSeason = (1 + thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['season'])
										end
										

									end

									
									
									if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN)) then
										
										-- Main
										varPlayerMainScore = 0
										if (thisPlayerTables['mythicKeystoneProfile']['mplusMainCurrent']['score']) then
											varPlayerMainScore = thisPlayerTables['mythicKeystoneProfile']['mplusMainCurrent']['score'];
										end
										varPlayerMainScoreNum = varPlayerMainScore
										varPlayerMainPrevSeason = false
										varPlayerMainScorePrevSeason = ""
										
										
										if (thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score']) then
											if (varPlayerMainScore <= thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score']) then
												varPlayerMainPrevSeason = true
											end
										end
										
										
										
										
										if (varPlayerMainPrevSeason and thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score'] > varPlayerScore) then	
											varPlayerMainScorePrevNum = thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score']
											varPlayerMainScorePrevSeason = ""
											if (thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['season']) then
												varPlayerMainScorePrevSeason = (1 + thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['season'])
											end
											
											
										
											
										end
									

									end --eo main
									
									
								
								end
							end
				
				
				end
				
				-- EO MPLUS INFO
				
				---------------------------------------------------
				
				
				-- RAID INFO
				
					if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE)) then
							
							if (thisPlayerTables['raidProfile']) then
							
							if (thisPlayerTables['raidProfile']['hasRenderableData']) == true then
								--Raid Data
								
								tblRaidProgress = {}
								tblRaidProgress["progress"] = {}
								tblRaidProgress["prev"] = {}
								tblRaidProgress["main"] = {}
						
								 if (thisPlayerTables['raidProfile']) then

								-- Raid stuff
								
			
			
								for z=1,#thisPlayerTables['raidProfile']['sortedProgress']  do
								
								
								if (thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["shortName"]) then
								

											varRaidName = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["shortName"]
	
											
													
													if not tblRaidProgress["progress"][varRaidName] then
														tblRaidProgress["progress"][varRaidName] = {}
														tblRaidProgress["progress"][varRaidName]["name"] = varRaidName
														--tblRaidProgress["progress"][varRaidName]["obsolete"] = false
														tblRaidProgress["progress"][varRaidName]["thereIsScore"] = false
													end
													
													if not tblRaidProgress["prev"][varRaidName] then
														tblRaidProgress["prev"][varRaidName] = {}
														tblRaidProgress["prev"][varRaidName]["name"] = varRaidName
														--tblRaidProgress["prev"][varRaidName]["obsolete"] = false
														tblRaidProgress["prev"][varRaidName]["thereIsScore"] = false
													end
													
													if not tblRaidProgress["main"][varRaidName] then
														tblRaidProgress["main"][varRaidName] = {}
														tblRaidProgress["main"][varRaidName]["name"] = varRaidName
														--tblRaidProgress["main"][varRaidName]["obsolete"] = false
														tblRaidProgress["main"][varRaidName]["thereIsScore"] = false
													end
													

													varRaidType = "progress"
													thereIsRaidProgress = false
													
													
													
													-- Need to determine if this is current raid, prev raid, or main raid
													
													
													if (thisPlayerTables['raidProfile']['sortedProgress'][z]["isProgress"]) then
													
														if (thisPlayerTables['raidProfile']['sortedProgress'][z]["isProgress"] == true) then
														
															varRaidType = "progress"
														
														end
													
													end
													
													
													if (thisPlayerTables['raidProfile']['sortedProgress'][z]["isProgressPrev"]) then
													
														if (thisPlayerTables['raidProfile']['sortedProgress'][z]["isProgressPrev"] == true) then
														
															varRaidType = "prev"
														
														end
													
													end
													
													if (thisPlayerTables['raidProfile']['sortedProgress'][z]["isMainProgress"]) then
													
														if (thisPlayerTables['raidProfile']['sortedProgress'][z]["isMainProgress"] == true) then
														
															varRaidType = "main"
														
														end
													
													end
													
													
													
													
													
													
													
													
													local isThisRowObsolete = false
													
													if (thisPlayerTables['raidProfile']['sortedProgress'][z]["obsolete"]) then
														isThisRowObsolete = thisPlayerTables['raidProfile']['sortedProgress'][z]["obsolete"]
													end

													
													
													if ((thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["difficulty"] == 1) and (isThisRowObsolete == false)) then
													--Normal
													
														tblRaidProgress[varRaidType][varRaidName]["normal"] = {}
														tblRaidProgress[varRaidType][varRaidName]["normal"]["progressCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["progressCount"]
														
														tblRaidProgress[varRaidType][varRaidName]["normal"]["bossCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["bossCount"]
														
														tblRaidProgress[varRaidType][varRaidName]["thereIsScore"] = true
												
														
														
													end
													
													if ((thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["difficulty"] == 2) and (isThisRowObsolete == false)) then
														--Heroic
														
													
														tblRaidProgress[varRaidType][varRaidName]["heroic"] = {}
														tblRaidProgress[varRaidType][varRaidName]["heroic"]["progressCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["progressCount"]
														
														tblRaidProgress[varRaidType][varRaidName]["heroic"]["bossCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["bossCount"]
														
														tblRaidProgress[varRaidType][varRaidName]["thereIsScore"] = true
														
													end
													
													
													if ((thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["difficulty"] == 3) and (isThisRowObsolete == false)) then
														--Mythic								

														tblRaidProgress[varRaidType][varRaidName]["mythic"] = {}														
														tblRaidProgress[varRaidType][varRaidName]["mythic"]["progressCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["progressCount"]
														
														tblRaidProgress[varRaidType][varRaidName]["mythic"]["bossCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["bossCount"]
														
														tblRaidProgress[varRaidType][varRaidName]["thereIsScore"] = true
														
													end
													
												
												
												
												
											

												
												
												
								
											
										--end --eo obsolute bool
										
									--end --eo obsolute check
								
								end --eo sorted progress
								
								
								
								
							end
						end
						
						end
						
						end
						
						end --eo raid
				
				-- EO RAID INFO
				
				---------------------------------------------------

	
				
					
				end
				
				
				
				-- Check to see if any of the strings have data in them. If so, show the RIO stuff.
				
				
			if ((varPlayerScore and varPlayerScore ~= 0) or (varPlayerScorePrevNum and varPlayerScorePrevNum ~= 0) or (varPlayerMainScore and varPlayerMainScore ~= 0 and varPlayerMainScore > varPlayerScore) or (varPlayerMainScorePrev ~= 0) or (tblRaidProgress)) then
				
			
				if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_DIVIDER)) then
					TRP3_CharacterTooltip:AddDoubleLine(" ", " ")
					TRP3_CharacterTooltip:AddLine(TRP3RIO_DividerGraphic)
				end	
				
				
				TRP3_CharacterTooltip:AddDoubleLine(" ", " ")
				
				
				if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_TITLE)) then					
					TRP3_CharacterTooltip:AddDoubleLine(L.RAIDER_IO, " ", TRP3RIO_TitleColor.r, TRP3RIO_TitleColor.g, TRP3RIO_TitleColor.b)
				end
				
				
				
				
				--Show M+ Score
				if ((varPlayerScore and varPlayerScore ~= 0) or (varPlayerScorePrevNum and varPlayerScorePrevNum ~= 0)) then
					
				
					varMPlusTextExtra = ""
					if (varPlayerScore and varPlayerScore ~= 0) then
						varMPlusTextExtra = varPlayerScore
					end
					
					varMPlusPrevTextExtra = ""
					if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE) ~= 1) then
						if (varPlayerScorePrevNum and varPlayerScorePrevNum ~= 0) then
							varMPlusPrevTextExtra = TRP3RIO_OldSeasonColor:WrapTextInColorCode("(S" ..  varPlayerScorePrevSeason .. ": " .. varPlayerScorePrevNum .. ")")
						end
					end
					
						if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE) == 3) then
							varMPlusTextExtra = varMPlusTextExtra .. " " .. varMPlusPrevTextExtra
						else
							varMPlusTextExtra = varMPlusPrevTextExtra .. " " .. varMPlusTextExtra
						end
				
					TRP3_CharacterTooltip:AddDoubleLine(L.MPLUS_SCORE, varMPlusTextExtra:gsub("^%s*(.-)%s*$", "%1") ,  LORE_TEXT_BODY_COLOR.r, LORE_TEXT_BODY_COLOR.g, LORE_TEXT_BODY_COLOR.b, RaiderIO.GetScoreColor(varPlayerScore))
				end
				
				
					
			
					-- Raid Progress
					if(tblRaidProgress) then
					

						if(tblRaidProgress["progress"]) then
							
							
							for k,v in pairs(tblRaidProgress["progress"]) do
							
							strRaidProgress = ""
							strRaidProgressName = ""
								 
								 
								 if ((tblRaidProgress["progress"][k]["thereIsScore"] == true)) then
									-- and (tblRaidProgress["progress"][k]["obsolete"] == false)

									strRaidMainName = tblRaidProgress["progress"][k]["name"]
									
									
									if (tblRaidProgress["progress"][k]["normal"]) then
										--Normal

										strRaidProgress = strRaidProgress .. ITEM_GOOD_COLOR:WrapTextInColorCode("   N ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["progress"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["normal"]["bossCount"])

									end
									
									if (tblRaidProgress["progress"][k]["heroic"]) then
										--Heroic
										 
										strRaidProgress = strRaidProgress .. ITEM_SUPERIOR_COLOR:WrapTextInColorCode("   H ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["progress"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["heroic"]["bossCount"])
	
									end
									
									
									if (tblRaidProgress["progress"][k]["mythic"]) then
										--Mythic												
										strRaidProgress = strRaidProgress .. ITEM_EPIC_COLOR:WrapTextInColorCode("   M ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["progress"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["mythic"]["bossCount"])
											
									end
							
							
								 
								 
								 end
								
								
								if (strRaidProgress ~= "") then
										
									TRP3_CharacterTooltip:AddDoubleLine(strRaidMainName .. " " .. L.PROGRESS , strRaidProgress,  LORE_TEXT_BODY_COLOR.r, LORE_TEXT_BODY_COLOR.g, LORE_TEXT_BODY_COLOR.b );
									
									
									
								
								end
								 
							end 
							
							
							
									
						
							
						end --eo progress loop
						
						
						
						
					end
					
					
					
					
					
					
					
					
					-- Previous Raid Progress
					if(tblRaidProgress) then	
						
						if(tblRaidProgress["prev"]) then
							-- loop through prev progress
							
							
							
							for k,v in pairs(tblRaidProgress["prev"]) do
							
							strRaidProgressPrevious = ""
							strRaidProgressPreviousName = ""
								 
								 
								 if ((tblRaidProgress["prev"][k]["thereIsScore"] == true) and (tblRaidProgress["prev"][k]["obsolete"] == false)) then
								 --
								 
									
									strRaidProgressPreviousName = tblRaidProgress["prev"][k]["name"]
									
									
									if (tblRaidProgress["prev"][k]["normal"]) then
										--Normal
										
										strRaidProgressPrevious = strRaidProgressPrevious .. ITEM_GOOD_COLOR:WrapTextInColorCode("   N ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["prev"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["normal"]["bossCount"])

									end
									
									if (tblRaidProgress["prev"][k]["heroic"]) then
										--Heroic
										
										strRaidProgressPrevious = strRaidProgressPrevious .. ITEM_SUPERIOR_COLOR:WrapTextInColorCode("   H ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["prev"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["heroic"]["bossCount"])
											
									end
									
									
									if (tblRaidProgress["prev"][k]["mythic"]) then
										--Mythic		
										
										strRaidProgressPrevious = strRaidProgressPrevious .. ITEM_EPIC_COLOR:WrapTextInColorCode("   M ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["prev"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["mythic"]["bossCount"])
										
									end
					
								 
								 
								 end
								 
					 
								 

								if (strRaidProgressPrevious ~= "" and strRaidMainProgress == "") then
								
									TRP3_CharacterTooltip:AddDoubleLine(strRaidProgressPreviousName .. " " .. L.PROGRESS , strRaidProgressPrevious,  LORE_TEXT_BODY_COLOR.r, LORE_TEXT_BODY_COLOR.g, LORE_TEXT_BODY_COLOR.b );
								
								end
								 
							end 
							
							
							
							
						
							
						end --eo prev progress loop

					
					end
					
					
					
					
					
					
					
					
					
					
					-- Only show if main's score is higher than this char's score
					if ((varPlayerMainScore and varPlayerMainScore ~= 0) and (varPlayerMainScore > varPlayerScore)) then
						
						varMPlusMainTextExtra = ""
						if (varPlayerMainScore and varPlayerMainScore ~= 0) then
							varMPlusMainTextExtra = varPlayerMainScore
						end
						
						varMPlusMainPrevTextExtra = ""
						if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE) ~= 1) then
							if (varPlayerMainScorePrevNum and varPlayerMainScorePrevNum ~= 0) then
								varMPlusMainPrevTextExtra = TRP3RIO_OldSeasonColor:WrapTextInColorCode("(S" ..  varPlayerMainScorePrevSeason .. ": " .. varPlayerMainScorePrevNum ..")")
							end
						end
						
						if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE) == 3) then
							varMPlusMainTextExtra = varMPlusMainTextExtra .. " " .. varMPlusMainPrevTextExtra
						else
							varMPlusMainTextExtra = varMPlusMainPrevTextExtra .. " " .. varMPlusMainTextExtra
						end
						
						TRP3_CharacterTooltip:AddDoubleLine(L.MPLUS_SCORE_MAIN, varMPlusMainTextExtra:gsub("^%s*(.-)%s*$", "%1") ,  LIGHTGRAY_FONT_COLOR.r, LIGHTGRAY_FONT_COLOR.g, LIGHTGRAY_FONT_COLOR.b, RaiderIO.GetScoreColor(varPlayerMainScore));
						
						
					end
					
					
					
					
					
					
					-- Main's Raid Progress
					if(tblRaidProgress) then

						
						if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN)) then
							
							if(tblRaidProgress["main"]) then
							-- loop through main progress
							
							
							for k,v in pairs(tblRaidProgress["main"]) do
							
							strRaidMainProgress = ""
							strRaidMainProgressName = ""
							
							
								 
								 
								 if ((tblRaidProgress["main"][k]["thereIsScore"] == true)) then
								 --  and (tblRaidProgress["main"][k]["obsolete"] == false)

									strRaidMainProgressName = tblRaidProgress["main"][k]["name"]
									
									
									if (tblRaidProgress["main"][k]["normal"]) then
										--Normal

										strRaidMainProgress = strRaidMainProgress .. ITEM_GOOD_COLOR:WrapTextInColorCode("   N ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["main"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["normal"]["bossCount"])
											
									end
									
									if (tblRaidProgress["main"][k]["heroic"]) then
										--Heroic
										 
										strRaidMainProgress = strRaidMainProgress .. ITEM_SUPERIOR_COLOR:WrapTextInColorCode("   H ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["main"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["heroic"]["bossCount"])
										
									end
									
									
									if (tblRaidProgress["main"][k]["mythic"]) then
										--Mythic												
										strRaidMainProgress = strRaidMainProgress .. ITEM_EPIC_COLOR:WrapTextInColorCode("   M ") .. TRP3RIO_MainColor:WrapTextInColorCode(tblRaidProgress["main"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["mythic"]["bossCount"])
										
									end
							
								 
								 end
								 
								 if (strRaidMainProgress ~= "") then
						
									TRP3_CharacterTooltip:AddDoubleLine(string.format(L.PROGRESS_MAIN, strRaidMainProgressName) , strRaidMainProgress,  LIGHTGRAY_FONT_COLOR.r, LIGHTGRAY_FONT_COLOR.g, LIGHTGRAY_FONT_COLOR.b );
							
														
													
								end

								 
							end 
							
							
							
							
						
							
						end --eo main progress loop
						
						end
						
					end
					
					
					
					
					
					
					

					
					
					
					

			
				
				end -- eo print to tooltip
				
				
				
				
				
				end
				
				
				
				
				
				
				
				end --eo showTooltip
				
			
			
			else --end of mini tooltip
			
				thisPlayerTables = RaiderIO.GetProfile(thisPlayerToLookUp)
					
						
				if (thisPlayerTables) then
				
					
					local showThisTooltip = false
					
					if (thisPlayerTables['raidProfile'] ~= nil) then
						if (thisPlayerTables['raidProfile']['hasRenderableData'] == true) then
							showThisTooltip = true
						end
					end
					
					if (thisPlayerTables['mythicKeystoneProfile'] ~= nil) then
						if (thisPlayerTables['mythicKeystoneProfile']['hasRenderableData'] == true) then
							showThisTooltip = true
						end
					end
					
					if (thisPlayerTables['recruitmentProfile'] ~= nil) then
						if (thisPlayerTables['recruitmentProfile']['hasRenderableData'] == true) then
							showThisTooltip = true
						end
					end
					
					if (TRP3_API.dashboard.isPlayerIC() and TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC)) then
						--hide tooltips, user is IC and hiding IC tooltips
						showThisTooltip = false
					end
				
				
					if (showThisTooltip == true) then
					
						if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_DIVIDER)) then
							TRP3_CharacterTooltip:AddLine(" ")
							TRP3_CharacterTooltip:AddLine(TRP3RIO_DividerGraphic)
						end	
					
						RaiderIO.ShowProfile(TRP3_CharacterTooltip, thisPlayerToLookUp)
					
					end
					
					--end
				
				end
				
			end --end of main tooltip
				
					
					TRP3_CharacterTooltip:Show()
					TRP3_CharacterTooltip:GetTop()
					
			
			end)		
			
			
		end
	 
	 
		
			
	end
	
	--[[
	if event == "MODIFIER_STATE_CHANGED" then
	
		if (TRP3_CharacterTooltip:IsShown()) then
		
			if (arg1 == "LSHIFT") or (arg1 == "RSHIFT") then
			
				TRP3_CharacterTooltip:Show()
				
				if arg2 == 1 then
					-- SHIFT is pressed
					
						
				else
					-- SHIFT was let go 
				end
						
			
			end 
		
		end
	
	end 
	]]--

	
	
end)

TRP3_API.RegisterCallback(TRP3_API.GameEvents, "MODIFIER_STATE_CHANGED", function()
	--[[if (TRP3_CharacterTooltip:IsShown()) then
		TRP3_CharacterTooltip:Hide()
		TRP3_CharacterTooltip:Show()
	end]]
end);











--Config stuff
local TRPRIOTOOLTIPS_DROPDOWNSTUFF = {
	{ L.DROPDOWN_IC_OOC, false },
	{ L.DROPDOWN_OOC_ONLY, true }
}

local TRPRIOTOOLTIPS_PREVDROPDOWN = {
	{ L.PREVDROPDOWN_DONTSHOW, 1 },
	{ L.PREVDROPDOWN_BEFORE, 2 },
	{ L.PREVDROPDOWN_AFTER, 3 },	
}

if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then

	TRP3RIOTooltipsConfigElements = {
			{
				inherit = "TRP3_ConfigButton",
				title = L.CONFIG_TITLE,
				help = L.CONFIG_TITLE_HELP,
				text = L.CONFIG_TITLE_TEXT,
				callback = function()
					DEFAULT_CHAT_FRAME.editBox:SetText("/raiderio") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0) 
				end,
			},
			{
				inherit = "TRP3_ConfigNote",
				title = " ",
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.CONFIG_MAINSETTINGS_TITLE,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "trp3_riotooltips_hide_tooltips_ic",
				title = L.CONFIG_SHOWRIO_TITLE,
				help = L.CONFIG_SHOWRIO_HELP,
				listContent = TRPRIOTOOLTIPS_DROPDOWNSTUFF,
				configKey = TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC,
				listCallback = function(value)
					TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC, value)
				end,

			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.CONFIG_DIVGRAPHIC_TITLE,
				help = L.CONFIG_DIVGRAPHIC_HELP,
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_DIVIDER
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.CONFIG_MINIFIED_TITLE,
				help = L.CONFIG_MINIFIED_HELP,
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP
			},
			
			{
				inherit = "TRP3_ConfigNote",
				title = " ",
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.CONFIG_MINIFIED_SETTINGS_TITLE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.CONFIG_MINIFIED_SHOWRIOTITLE_TITLE,
				help = L.CONFIG_MINIFIED_SHOWRIOTITLE_HELP,
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_TITLE,
				dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
			},
			{
				inherit = "TRP3_ConfigCheck",
				title =  L.CONFIG_MINIFIED_SHOWMPLUS_TITLE,
				help = L.CONFIG_MINIFIED_SHOWMPLUS_HELP,
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE,
				dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "trp3_riotooltips_enable_prev_score",
				title = L.CONFIG_MINIFIED_SHOWPREVMPLUS_TITLE .. " " .. LIGHTGRAY_FONT_COLOR:WrapTextInColorCode("(*)"),
				help = L.CONFIG_MINIFIED_SHOWPREVMPLUS_HELP,
				dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE, TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
				listContent = TRPRIOTOOLTIPS_PREVDROPDOWN,
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE,
				listCallback = function(value)
					TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE, value)
				end,

			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.CONFIG_MINIFIED_RAIDPROG_TITLE,
				help = L.CONFIG_MINIFIED_RAIDPROG_HELP,
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE,
				dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = LORE_TEXT_BODY_COLOR:WrapTextInColorCode(L.CONFIG_MINIFIED_MAINMPLUS_TITLE),
				help = L.CONFIG_MINIFIED_MAINMPLUS_HELP,
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN,
				dependentOnOptions = { (TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE and TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP) },
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = LORE_TEXT_BODY_COLOR:WrapTextInColorCode(L.CONFIG_MINIFIED_RAIDPROG_TITLE),
				help = L.CONFIG_MINIFIED_RAIDPROG_HELP,
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN,
				dependentOnOptions = { (TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE and TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP) },
			}
			
	}

else

	TRP3RIOTooltipsConfigElements = {
			{
				inherit = "TRP3_ConfigButton",
				title = L.CONFIG_TITLE,
				help = L.CONFIG_TITLE_HELP,
				text = L.CONFIG_TITLE_TEXT,
				callback = function()
					DEFAULT_CHAT_FRAME.editBox:SetText("/raiderio") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0) 
				end,
			},
			{
				inherit = "TRP3_ConfigNote",
				title = " ",
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.CONFIG_MAINSETTINGS_TITLE,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "trp3_riotooltips_hide_tooltips_ic",
				title = L.CONFIG_SHOWRIO_TITLE,
				help = L.CONFIG_SHOWRIO_HELP,
				listContent = TRPRIOTOOLTIPS_DROPDOWNSTUFF,
				configKey = TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC,
				listCallback = function(value)
					TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC, value)
				end,

			}
			
	}

end

	TRP3_API.configuration.registerConfigurationPage({
		id = "trp3_riotooltips_config",
		menuText = L.RAIDER_IO,
		pageText = L.ADDON_NAME,
		elements = TRP3RIOTooltipsConfigElements
	
	});

end



TRP3_API.module.registerModule({
	name = L.ADDON_NAME,
	description = L.ADDON_DESC,
	version = C_AddOns.GetAddOnMetadata("tRP3_RDotIO", "Version"),
	id = "trp3_riotooltips",
	onStart = TRP3RIO_Init,
	requiredDeps = { { "RaiderIO", "external" }, { "trp3_tooltips", 1.0 } },
	minVersion = 130,
});






-- Slash Command
local function TRP3RIO_OpenConfig()
	TRP3_API.navigation.openMainFrame();
	TRP3_API.navigation.page.setPage("main_config_aaa_general");
	TRP3_API.navigation.page.setPage("trp3_riotooltips_config");
end

local TRP3RIO_OpenConfigCommand = {
	id = "rio",
	helpLine = " ".. L.ADCOM_HELP,
	handler = function()
		TRP3RIO_OpenConfig();
	end,
}

TRP3_API.slash.registerCommand(TRP3RIO_OpenConfigCommand);