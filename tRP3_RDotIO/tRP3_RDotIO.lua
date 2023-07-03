local trp3rio = CreateFrame("Frame")
trp3rio:RegisterEvent("PLAYER_LOGIN")
trp3rio:RegisterEvent("PLAYER_LOGOUT")
trp3rio:RegisterEvent("PLAYER_ENTERING_WORLD")


if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then


	local ignoretooltip = false
	local loadedstuff = false
	
	Trp3RIOTitleColor = NORMAL_FONT_COLOR
	Trp3RIOTextColor = WHITE_FONT_COLOR

	local dividerGraphic = CreateSimpleTextureMarkup("interface\\friendsframe\\ui-friendsframe-onlinedivider", 320, 4)
	

	--Fixes inconsistent font sizes
	local function fixFontsTrp3RIO (small)

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


	-- variable for trp3 config

	TRPRIOTOOLTIPS = select(2, ...);


		local function trp3rioinit()
			
			local Trp3RIOTextColorsFunc = TRP3_API.ui.tooltip.getTooltipTextColors
			
			if (TRP3_Configuration[CONFIG_TOOLTIP_MAIN_COLOR]) then
				Trp3RIOTitleColor = TRP3_API.CreateColorFromHexString(TRP3_API.configuration.getValue(CONFIG_TOOLTIP_MAIN_COLOR))
			else 
				Trp3RIOTitleColor = WHITE_FONT_COLOR
			end
			
			if (TRP3_Configuration[CONFIG_TOOLTIP_TITLE_COLOR]) then
				Trp3RIOTitleColor = TRP3_API.CreateColorFromHexString(TRP3_API.configuration.getValue(CONFIG_TOOLTIP_TITLE_COLOR))
			else 
				Trp3RIOTitleColor = NORMAL_FONT_COLOR
			end
						
				
			-- TRP 3 Variables

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
		
		

	trp3rio:SetScript("OnEvent", function(self, event, arg1, arg2)


		if event == "PLAYER_LOGIN" and loadedstuff == false then
		
		
		
		 if TRP3_CharacterTooltip ~= nil then
		 
		 

			hooksecurefunc(TRP3_CharacterTooltip, "AddDoubleLine", function(t)
					fixFontsTrp3RIO()
			end)
			
			
			
			
			hooksecurefunc(TRP3_CharacterTooltip, "AddLine", function(t)
			
			end)
			
			
			
				
		 
			TRP3_CharacterTooltip:HookScript("OnShow", function(t)
				
				
				local showtooltip = true
				
				local thisPlayerToLookUp = t.target
				--t.target
				
				
				--check if IC/OOC and if disable when IC is enabled
				
				if (TRP3_API.dashboard.isPlayerIC() and TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC)) then
					--hide tooltips, user is IC and hiding IC tooltips
					showtooltip = false
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
				
				if showtooltip then
					
			
						
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
						TRP3_CharacterTooltip:AddLine(dividerGraphic)
					end	
					
					
					TRP3_CharacterTooltip:AddDoubleLine(" ", " ")
					
					
					if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_TITLE)) then					
						TRP3_CharacterTooltip:AddDoubleLine("Raider.IO", " ", Trp3RIOTitleColor.r, Trp3RIOTitleColor.g, Trp3RIOTitleColor.b)
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
								varMPlusPrevTextExtra = GRAY_FONT_COLOR:WrapTextInColorCode("(S" ..  varPlayerScorePrevSeason .. ": " .. varPlayerScorePrevNum .. ")")
							end
						end
						
							if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE) == 3) then
								varMPlusTextExtra = varMPlusTextExtra .. " " .. varMPlusPrevTextExtra
							else
								varMPlusTextExtra = varMPlusPrevTextExtra .. " " .. varMPlusTextExtra
							end
					
						TRP3_CharacterTooltip:AddDoubleLine("M+ Score", varMPlusTextExtra:gsub("^%s*(.-)%s*$", "%1") ,  LORE_TEXT_BODY_COLOR.r, LORE_TEXT_BODY_COLOR.g, LORE_TEXT_BODY_COLOR.b, RaiderIO.GetScoreColor(varPlayerScore))
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

											strRaidProgress = strRaidProgress .. ITEM_GOOD_COLOR:WrapTextInColorCode("   N ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["progress"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["normal"]["bossCount"])
	
										end
										
										if (tblRaidProgress["progress"][k]["heroic"]) then
											--Heroic
											 
											strRaidProgress = strRaidProgress .. ITEM_SUPERIOR_COLOR:WrapTextInColorCode("   H ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["progress"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["heroic"]["bossCount"])
		
										end
										
										
										if (tblRaidProgress["progress"][k]["mythic"]) then
											--Mythic												
											strRaidProgress = strRaidProgress .. ITEM_EPIC_COLOR:WrapTextInColorCode("   M ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["progress"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["mythic"]["bossCount"])
												
										end
								
								
									 
									 
									 end
									
									
									if (strRaidProgress ~= "") then
											
										TRP3_CharacterTooltip:AddDoubleLine(strRaidMainName .. " Progress" , strRaidProgress,  LORE_TEXT_BODY_COLOR.r, LORE_TEXT_BODY_COLOR.g, LORE_TEXT_BODY_COLOR.b );
										
										
										
									
									end
									 
								end 
								
								
								
										
							
								
							end --eo progress loop
							
							
							
							
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
									varMPlusMainPrevTextExtra = GRAY_FONT_COLOR:WrapTextInColorCode("(S" ..  varPlayerMainScorePrevSeason .. ": " .. varPlayerMainScorePrevNum ..")") .. " "
								end
							end
							
							if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE) == 3) then
								varMPlusMainTextExtra = varMPlusMainTextExtra .. " " .. varMPlusMainPrevTextExtra
							else
								varMPlusMainTextExtra = varMPlusMainPrevTextExtra .. " " .. varMPlusMainTextExtra
							end
							
							TRP3_CharacterTooltip:AddDoubleLine("Main's M+ Score", varMPlusMainTextExtra:gsub("^%s*(.-)%s*$", "%1") ,  LIGHTGRAY_FONT_COLOR.r, LIGHTGRAY_FONT_COLOR.g, LIGHTGRAY_FONT_COLOR.b, RaiderIO.GetScoreColor(varPlayerMainScore));
							
							
						end
						
						
						
						
						
						
						-- Main's Raid Progress
						if(tblRaidProgress) then
	
							
							if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN)) then
								
								if(tblRaidProgress["main"]) then
								-- loop through main progress
								
								
								
								
								for k,v in pairs(tblRaidProgress["main"]) do
								
								strRaidMainProgress = ""
								strRaidMainProgressName = ""
									 
									 
									 if ((tblRaidProgress["main"][k]["thereIsScore"] == true) and (tblRaidProgress["main"][k]["obsolete"] == false)) then

										strRaidMainProgressName = tblRaidProgress["main"][k]["name"]
										
										
										if (tblRaidProgress["main"][k]["normal"]) then
											--Normal

											strRaidMainProgress = strRaidMainProgress .. ITEM_GOOD_COLOR:WrapTextInColorCode("   N ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["main"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["normal"]["bossCount"])
												
										end
										
										if (tblRaidProgress["main"][k]["heroic"]) then
											--Heroic
											 
											strRaidMainProgress = strRaidMainProgress .. ITEM_SUPERIOR_COLOR:WrapTextInColorCode("   H ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["main"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["heroic"]["bossCount"])
											
										end
										
										
										if (tblRaidProgress["main"][k]["mythic"]) then
											--Mythic												
											strRaidMainProgress = strRaidMainProgress .. ITEM_EPIC_COLOR:WrapTextInColorCode("   M ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["main"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["mythic"]["bossCount"])
											
										end
								
									 
									 end
									 
									 if (strRaidMainProgress ~= "") then
							
										TRP3_CharacterTooltip:AddDoubleLine("Main's " .. strRaidMainProgressName .. " Progress" , strRaidMainProgress,  LIGHTGRAY_FONT_COLOR.r, LIGHTGRAY_FONT_COLOR.g, LIGHTGRAY_FONT_COLOR.b );
								
															
														
									end

									 
								end 
								
								
								
								
							
								
							end --eo main progress loop
							
							end
							
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
											
											strRaidProgressPrevious = strRaidProgressPrevious .. ITEM_GOOD_COLOR:WrapTextInColorCode("   N ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["prev"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["normal"]["bossCount"])

										end
										
										if (tblRaidProgress["prev"][k]["heroic"]) then
											--Heroic
											
											strRaidProgressPrevious = strRaidProgressPrevious .. ITEM_SUPERIOR_COLOR:WrapTextInColorCode("   H ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["prev"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["heroic"]["bossCount"])
												
										end
										
										
										if (tblRaidProgress["prev"][k]["mythic"]) then
											--Mythic		
											
											strRaidProgressPrevious = strRaidProgressPrevious .. ITEM_EPIC_COLOR:WrapTextInColorCode("   M ") .. Trp3RIOTextColor:WrapTextInColorCode(tblRaidProgress["prev"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["mythic"]["bossCount"])
											
										end
						
									 
									 
									 end
									 
						 
									 

									if (strRaidProgressPrevious ~= "" and strRaidMainProgress == "") then
									
										TRP3_CharacterTooltip:AddDoubleLine(strRaidProgressPreviousName .. " Progress" , strRaidProgressPrevious,  Trp3RIOTextColor.r, Trp3RIOTextColor.g, Trp3RIOTextColor.b );
									
									end
									 
								end 
								
								
								
								
							
								
							end --eo prev progress loop
	
						
						end

						
						
						
						

				
					
					end -- eo print to tooltip
					
					
					
					
					
					end
					
					
					
					
					
					
					
					end --eo showtooltip
					
				
				
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
					
					
						if (showThisTooltip == true) then
						
							if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_DIVIDER)) then
								TRP3_CharacterTooltip:AddLine(" ")
								TRP3_CharacterTooltip:AddLine(dividerGraphic)
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
		
		
		
	end)







	
	

	
	
	
	--Config stuff
	local TRPRIOTOOLTIPS_DROPDOWNSTUFF = {
		{ "When IC and OOC", false },
		{ "When OOC Only", true }
	}
	
	local TRPRIOTOOLTIPS_PREVDROPDOWN = {
		{ "Don't Show", 1 },
		{ "Before Current M+ Score", 2 },
		{ "After Current M+ Score", 3 },	
	}
	
	
	TRP3RIOTooltipsConfigElements = {
				{
					inherit = "TRP3_ConfigButton",
					title = "Show Raider.IO Addon Options",
					help = "Open the Options for the actual Raider.IO Addon.",
					text = "Open R.IO Options",
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
					title = "Main Settings",
				},
				{
					inherit = "TRP3_ConfigDropDown",
					widgetName = "trp3_riotooltips_hide_tooltips_ic",
					title = "Show Raider.IO Info on TRP3 Tooltip",
					help = "Determine whether R.IO Info should show if you are IC or OOC.",
					listContent = TRPRIOTOOLTIPS_DROPDOWNSTUFF,
					configKey = TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC,
					listCallback = function(value)
						TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC, value)
					end,

				},
				{
					inherit = "TRP3_ConfigCheck",
					title = "Add Divider Graphic above Raider.IO Info",
					help = "If checked, adds a divider graphic to seperate the main TRP3 Tooltip Info from the Raider.IO Tooltip Info.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_DIVIDER
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = "Use Minified Raider.IO Tooltip",
					help = "If checked, the addon's minified formatting will be used instead of the original Raider.IO tooltip info.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP
				},
				
				{
					inherit = "TRP3_ConfigNote",
					title = " ",
				},
				{
					inherit = "TRP3_ConfigH1",
					title = "Minified Tooltip Settings",
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = "Show Raider.IO Title",
					help = "Show the Raider.IO Title Text.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_TITLE,
					dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
				},
				{
					inherit = "TRP3_ConfigCheck",
					title =  "M+ Score",
					help = "Show the character's M+ Score on the tooltip.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE,
					dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
				},
				{
					inherit = "TRP3_ConfigDropDown",
					widgetName = "trp3_riotooltips_enable_prev_score",
					title = "Previous M+ Score " .. LIGHTGRAY_FONT_COLOR:WrapTextInColorCode("(*)"),
					help = "Show the character's M+ Score from the previous season, if higher than the current season's score.",
					dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE, TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
					listContent = TRPRIOTOOLTIPS_PREVDROPDOWN,
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE,
					listCallback = function(value)
						TRP3_API.configuration.setValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE, value)
					end,

				},
				{
					inherit = "TRP3_ConfigCheck",
					title = "Raid Progress",
					help = "Show the character's Raid Progress on the tooltip.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE,
					dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = LORE_TEXT_BODY_COLOR:WrapTextInColorCode("Main's M+ Score"),
					help = "Show the character's main's M+ score on the tooltip, if available.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN,
					dependentOnOptions = { (TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE and TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP) },
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = LORE_TEXT_BODY_COLOR:WrapTextInColorCode("Main's Raid Progress"),
					help = "Show the character's main's Raid Progress on the tooltip, if available.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN,
					dependentOnOptions = { (TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE and TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP) },
				}
				
			}

		TRP3_API.configuration.registerConfigurationPage({
			id = "trp3_riotooltips_config",
			menuText = "Raider.IO",
			pageText = "Raider.IO Tooltip Support",
			elements = TRP3RIOTooltipsConfigElements
		
		});








	end



	TRP3_API.module.registerModule({
		name = "Raider.IO Tooltip Support",
		description = "Allows TRP 3 to show Raider.IO information on the tooltip.",
		version = "1.5.2",
		id = "trp3_riotooltips",
		onStart = trp3rioinit,
		requiredDeps = { { "RaiderIO", "external" }, { "trp3_tooltips", 1.0 } },
		minVersion = 110,
	});






	-- Slash Command
	local function trp3RDotIOOpenConfig()
		TRP3_API.navigation.openMainFrame();
		TRP3_API.navigation.page.setPage("main_config_aaa_general");
		TRP3_API.navigation.page.setPage("trp3_riotooltips_config");
	end

	local trp3RDotIOOpenConfigCommand = {
		id = "rio",
		helpLine = " Open the Raider.IO Tooltip Config.",
		handler = function()
			trp3RDotIOOpenConfig();
		end,
	}

	TRP3_API.slash.registerCommand(trp3RDotIOOpenConfigCommand);


else

	-- Retail Only

end