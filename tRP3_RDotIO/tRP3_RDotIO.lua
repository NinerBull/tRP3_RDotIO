local trp3rio = CreateFrame("Frame")
trp3rio:RegisterEvent("PLAYER_LOGIN")
trp3rio:RegisterEvent("PLAYER_LOGOUT")
trp3rio:RegisterEvent("PLAYER_ENTERING_WORLD")


if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then


	local ignoretooltip = false
	local loadedstuff = false

	local normalRaidColor = "|cnITEM_GOOD_COLOR:"
	local normalRaidColorText = "|cnWHITE_FONT_COLOR:"
	local heroicRaidColor = "|cnITEM_SUPERIOR_COLOR:"
	local heroicRaidColorText = "|cnWHITE_FONT_COLOR:"
	local mythicRaidColor = "|cnITEM_EPIC_COLOR:"
	local mythicRaidColorText = "|cnWHITE_FONT_COLOR:"

	local dividerGraphic = "|Tinterface\\friendsframe\\ui-friendsframe-onlinedivider:4:320:0:0:0:0:0:0:6:8|t"



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

	--For debug


	--[[local function tprint (t, s)
		for k, v in pairs(t) do
			local kfmt = '["' .. tostring(k) ..'"]'
			if type(k) ~= 'string' then
				kfmt = '[' .. k .. ']'
			end
			local vfmt = '"'.. tostring(v) ..'"'
			if type(v) == 'table' then
				tprint(v, (s or '')..kfmt)
			else
				if type(v) ~= 'string' then
					vfmt = tostring(v)
				end
				print(type(t)..(s or '')..kfmt..' = '..vfmt)
			end
		end
	end]]


	-- variable for trp3 config

	local TRPRIOTOOLTIPS = select(2, ...);


	local function trp3rioinit()

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
															tblRaidProgress["progress"][varRaidName]["obsolete"] = false
															tblRaidProgress["progress"][varRaidName]["thereIsScore"] = false
														end
														
														if not tblRaidProgress["prev"][varRaidName] then
															tblRaidProgress["prev"][varRaidName] = {}
															tblRaidProgress["prev"][varRaidName]["name"] = varRaidName
															tblRaidProgress["prev"][varRaidName]["obsolete"] = false
															tblRaidProgress["prev"][varRaidName]["thereIsScore"] = false
														end
														
														if not tblRaidProgress["main"][varRaidName] then
															tblRaidProgress["main"][varRaidName] = {}
															tblRaidProgress["main"][varRaidName]["name"] = varRaidName
															tblRaidProgress["main"][varRaidName]["obsolete"] = false
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
														
														
														
														
														
														
														
														
														
														
														if (thisPlayerTables['raidProfile']['sortedProgress'][z]["obsolete"]) then
															tblRaidProgress[varRaidType][varRaidName]["obsolete"] = thisPlayerTables['raidProfile']['sortedProgress'][z]["obsolete"]
														end
														
														
														
														if (thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["difficulty"]) == 1 then
														--Normal
														
															tblRaidProgress[varRaidType][varRaidName]["normal"] = {}
															tblRaidProgress[varRaidType][varRaidName]["normal"]["progressCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["progressCount"]
															
															tblRaidProgress[varRaidType][varRaidName]["normal"]["bossCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["bossCount"]
															
															tblRaidProgress[varRaidType][varRaidName]["thereIsScore"] = true
													
															
															
														end
														
														if (thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["difficulty"]) == 2 then
															--Heroic
															
														
															 tblRaidProgress[varRaidType][varRaidName]["heroic"] = {}
															tblRaidProgress[varRaidType][varRaidName]["heroic"]["progressCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["progressCount"]
															
															tblRaidProgress[varRaidType][varRaidName]["heroic"]["bossCount"] = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["bossCount"]
															
															tblRaidProgress[varRaidType][varRaidName]["thereIsScore"] = true
															
														end
														
														
														if (thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["difficulty"]) == 3 then
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
						TRP3_CharacterTooltip:AddLine(" ")
						TRP3_CharacterTooltip:AddLine(dividerGraphic)
					end	
					
					
					TRP3_CharacterTooltip:AddDoubleLine(" ", " ")
					
					
					if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_TITLE)) then					
						TRP3_CharacterTooltip:AddDoubleLine("Raider.IO", " ", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
					end
					
					
					
					
					--Show M+ Score
					if ((varPlayerScore and varPlayerScore ~= 0) or (varPlayerScorePrevNum and varPlayerScorePrevNum ~= 0)) then
						
					
						local varMPlusTextExtra = ""
						if (varPlayerScore and varPlayerScore ~= 0) then
							varMPlusTextExtra = varPlayerScore
						end
						
						local varMPlusPrevTextExtra = ""
						if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE)) then
							if (varPlayerScorePrevNum and varPlayerScorePrevNum ~= 0) then
								varMPlusPrevTextExtra = " |cnGRAY_FONT_COLOR:(S" ..  varPlayerScorePrevSeason .. ": " .. varPlayerScorePrevNum ..")|r"
							end
						end
					
						TRP3_CharacterTooltip:AddDoubleLine("M+ Score", varMPlusTextExtra .. varMPlusPrevTextExtra,  NO_THREAT_COLOR.r, NO_THREAT_COLOR.g, NO_THREAT_COLOR.b, RaiderIO.GetScoreColor(varPlayerScore))
					end
					
					-- Only show if main's score is higher than this char's score
					if ((varPlayerMainScore and varPlayerMainScore ~= 0) and (varPlayerMainScore > varPlayerScore)) then
						
						local varMPlusMainTextExtra = ""
						if (varPlayerMainScore and varPlayerMainScore ~= 0) then
							varMPlusMainTextExtra = varPlayerMainScore
						end
						
						local varMPlusMainPrevTextExtra = ""
						if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE)) then
							if (varPlayerMainScorePrevNum and varPlayerMainScorePrevNum ~= 0) then
								varMPlusMainPrevTextExtra = " |cnGRAY_FONT_COLOR:(S" ..  varPlayerMainScorePrevSeason .. ": " .. varPlayerMainScorePrevNum ..")|r"
							end
						end
						
						local varScoreColourMain = 

						TRP3_CharacterTooltip:AddDoubleLine("Main's M+ Score", varMPlusMainTextExtra .. varMPlusMainPrevTextExtra,  LIGHTGRAY_FONT_COLOR.r, LIGHTGRAY_FONT_COLOR.g, LIGHTGRAY_FONT_COLOR.b, RaiderIO.GetScoreColor(varPlayerMainScore));
						
						
					end
						
				
						--loop through raid stuff
						
						
						
						if(tblRaidProgress) then
						
						
							
							
							if(tblRaidProgress["progress"]) then
								-- loop through main progress
								
								
								for k,v in pairs(tblRaidProgress["progress"]) do
								
								strRaidProgress = ""
								strRaidProgressName = ""
									 
									 
									 if ((tblRaidProgress["progress"][k]["thereIsScore"] == true) and (tblRaidProgress["progress"][k]["obsolete"] == false)) then

										strRaidMainName = tblRaidProgress["progress"][k]["name"]
										
										
										if (tblRaidProgress["progress"][k]["normal"]) then
											--Normal

											strRaidProgress = strRaidProgress .. normalRaidColor .. "   N " .. normalRaidColorText .. tblRaidProgress["progress"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["normal"]["bossCount"]
	
										end
										
										if (tblRaidProgress["progress"][k]["heroic"]) then
											--Heroic
											 
											strRaidProgress = strRaidProgress .. heroicRaidColor .. "   H " .. heroicRaidColorText .. tblRaidProgress["progress"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["heroic"]["bossCount"]
		
										end
										
										
										if (tblRaidProgress["progress"][k]["mythic"]) then
											--Mythic												
											strRaidProgress = strRaidProgress .. mythicRaidColor .. "   M " .. mythicRaidColorText .. tblRaidProgress["progress"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["mythic"]["bossCount"]
												
										end
								
								
									 
									 
									 end
									
									
									if (strRaidProgress ~= "") then
											
										TRP3_CharacterTooltip:AddDoubleLine(strRaidMainName .. " Progress" , strRaidProgress,  NO_THREAT_COLOR.r, NO_THREAT_COLOR.g, NO_THREAT_COLOR.b );
										
										
										
									
									end
									 
								end 
								
								
								
										
							
								
							end --eo progress loop
							
							
							
							
							
							
							
							
							
							
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

											strRaidMainProgress = strRaidMainProgress .. normalRaidColor .. "   N " .. normalRaidColorText .. tblRaidProgress["main"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["normal"]["bossCount"]
												
										end
										
										if (tblRaidProgress["main"][k]["heroic"]) then
											--Heroic
											 
											strRaidMainProgress = strRaidMainProgress .. heroicRaidColor .. "   H " .. heroicRaidColorText .. tblRaidProgress["main"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["heroic"]["bossCount"]
											
										end
										
										
										if (tblRaidProgress["main"][k]["mythic"]) then
											--Mythic												
											strRaidMainProgress = strRaidMainProgress .. mythicRaidColor .. "   M " .. mythicRaidColorText .. tblRaidProgress["main"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["mythic"]["bossCount"]
											
										end
								
								
								
								
										
										
										
									 
									 
									 end
									 
									 if (strRaidMainProgress ~= "") then
							
										TRP3_CharacterTooltip:AddDoubleLine("Main's " .. strRaidMainProgressName .. " Progress" , strRaidMainProgress,  LIGHTGRAY_FONT_COLOR.r, LIGHTGRAY_FONT_COLOR.g, LIGHTGRAY_FONT_COLOR.b );
								
															
														
									end

									 
								end 
								
								
								
								
							
								
							end --eo main progress loop
							
							end
							
							
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
											
											strRaidProgressPrevious = strRaidProgressPrevious .. normalRaidColor .. "   N " .. normalRaidColorText .. tblRaidProgress["prev"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["normal"]["bossCount"]

										end
										
										if (tblRaidProgress["prev"][k]["heroic"]) then
											--Heroic
											
											strRaidProgressPrevious = strRaidProgressPrevious .. heroicRaidColor .. "   H " .. heroicRaidColorText .. tblRaidProgress["prev"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["heroic"]["bossCount"]
												
										end
										
										
										if (tblRaidProgress["prev"][k]["mythic"]) then
											--Mythic		
											
											strRaidProgressPrevious = strRaidProgressPrevious .. mythicRaidColor .. "   M " .. mythicRaidColorText .. tblRaidProgress["prev"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["mythic"]["bossCount"]
											
										end
						
									 
									 
									 end
									 
						 
									 

									if (strRaidProgressPrevious ~= "" and strRaidMainProgress == "") then
									
										TRP3_CharacterTooltip:AddDoubleLine(strRaidProgressPreviousName .. " Progress" , strRaidProgressPrevious,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b );
									
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
	TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE, true);
	
	


		TRP3_API.configuration.registerConfigurationPage({
			id = "trp3_riotooltips_config",
			menuText = "Raider.IO",
			pageText = "Raider.IO Tooltip Support",
			elements = {
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
					help = "Show the yellow Raider.IO Title Text.",
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
					inherit = "TRP3_ConfigCheck",
					title = "Previous M+ Score (*)",
					help = "Show the characters M+ Score from the previous season, if higher than the current season's score.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_PREV_RIO_SCORE,
					dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE, TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
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
					title = "Main's M+ Score",
					help = "Show the character's main's M+ score on the tooltip, if available.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN,
					dependentOnOptions = { (TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE and TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP) },
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = "Main's Raid Progress",
					help = "Show the character's main's Raid Progress on the tooltip, if available.",
					configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN,
					dependentOnOptions = { (TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE and TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP) },
				}
				
			}
		
		});








	end



	TRP3_API.module.registerModule({
		name = "Raider.IO Tooltip Support",
		description = "Allows TRP 3 to show Raider.IO information on the tooltip.",
		version = "1.5.0",
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