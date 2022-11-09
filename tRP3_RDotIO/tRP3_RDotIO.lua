local trp3rio = CreateFrame("Frame")
--trp3rio:RegisterEvent("ADDON_LOADED")
trp3rio:RegisterEvent("PLAYER_LOGIN")
trp3rio:RegisterEvent("PLAYER_LOGOUT")
trp3rio:RegisterEvent("PLAYER_ENTERING_WORLD")


local ignoretooltip = false
local loadedstuff = false

local normalRaidColor = "|cff1eff00"
local normalRaidColorText = "|cff98f989"
local heroicRaidColor = "|cff0070dd"
local heroicRaidColorText = "|cff67abea"
local mythicRaidColor = "|cffa335ee"
local mythicRaidColorText = "|cffce94f7"


local function fixFontsTrp3RIO (dummy)

--Incredibly rough but it works, for now
			local line = _G[strconcat(TRP3_CharacterTooltip:GetName(), "TextLeft", TRP3_CharacterTooltip:NumLines())]
			local font, _ , flag = line:GetFont()
			line:SetFont(font, 12, flag)
			
			local line2 = _G[strconcat(TRP3_CharacterTooltip:GetName(), "TextRight", TRP3_CharacterTooltip:NumLines())]
			local font2, _ , flag2 = line2:GetFont()
			line2:SetFont(font2, 12, flag2)
			
			--print('called')


end

--For debug

--[[
local function tprint (t, s)
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
end
]]--

-- variable for trp3 config

local TRPRIOTOOLTIPS = select(2, ...);


local function trp3rioinit()



trp3rio:SetScript("OnEvent", function(self, event, arg1, arg2)


    if event == "PLAYER_LOGIN" and loadedstuff == false then
		--loadedstuff = true

	 if TRP3_CharacterTooltip ~= nil then
			TRP3_CharacterTooltip:HookScript("OnShow", function(t)
			
			
			local showtooltip = true
			
			
			--check if IC/OOC and if disable when IC is enabled
			
			
			if (TRP3_API.dashboard.isPlayerIC() and TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC)) then
				--hide tooltips, user is IC and hiding IC tooltips
				showtooltip = false
			end
			
			
			
			--local thisPlayerGUID = UnitGUID("mouseover")
			
			--thisLocalizedClass, thisEnglishClass, thisLocalizedRace, thisEnglishRace, thisSex, thisName, thisRealm = GetPlayerInfoByGUID(thisPlayerGUID)
			
			--[[
			thisRaceName, thisRaceFile, thisRaceID = UnitRace("mouseover")
			--thisFaction = C_CreatureInfo.GetFactionInfo(thisRaceID)
			thisEnglishFaction, thisLocalizedFaction = UnitFactionGroup("mouseover")
			
			
			thisFactionID = 3 --neutral
			
			if thisEnglishFaction == "Alliance" then
				thisFactionID = 1
			end
			if thisEnglishFaction == "Horde" then
				thisFactionID = 2
			end
			
			
			thisPlayerString = TRP3_CharacterTooltip['target']
			
			thisName, thisRealm = thisPlayerString:match("([^,]+)-([^,]+)")
			]]--
			
			
			
			
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
				
		
			
					--thisPlayerTables = RaiderIO.GetProfile(thisName, thisRealm, thisFactionID)
					
					thisPlayerTables = RaiderIO.GetProfile("mouseover")
					
						
				if (thisPlayerTables) then
				
				
				if (thisPlayerTables["success"] == true) then
				
					loadedstuff = false
					
					--[[
					if (thisPlayerTables['mythicKeystoneProfile']['mplusMainCurrent']) then
					tprint(thisPlayerTables)
					end	
					]]--	
				
				
					--This player has a Raider.io Profile
								
								
				
				
				---------------------------------------------------
				
				-- MPLUS Info
				
				if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE)) then
								
						if (thisPlayerTables['mythicKeystoneProfile']) then
								
									--This char
									varPlayerScore = 0
									if (thisPlayerTables['mythicKeystoneProfile']['mplusCurrent']['score']) then
										varPlayerScore = thisPlayerTables['mythicKeystoneProfile']['mplusCurrent']['score'];
									end
									varPlayerScoreNum = varPlayerScore
									varPlayerPrevSeason = false
									varPlayerPrevSeasonLabel = ""
									
									if (thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['score']) then
										if (varPlayerScore <= thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['score']) then
											varPlayerPrevSeason = true
											varPlayerPrevSeasonLabel = "Current "
										end
										
									end
									
									
									
									
									if (varPlayerPrevSeason) then	
									
									
									
										varPlayerScorePrev = "±" .. thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['score']
										varPlayerScorePrevNum = thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['score']
										varPlayerScorePrevSeason = ""
										if (thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['season'] and thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['season'] ~= 0) then
											varPlayerScorePrevSeason = " (S" .. (1 + thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['season']) .. ")"
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
										varPlayerMainPrevSeasonLabel = ""
										
										
										if (thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score']) then
											if (varPlayerMainScore <= thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score']) then
												varPlayerMainPrevSeason = true
												varPlayerMainPrevSeasonLabel = "Current "
											end
										end
										
										
										
										
										if (varPlayerMainPrevSeason and thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score'] > varPlayerScore) then	
											varPlayerMainScorePrev = "±" .. thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score']
											varPlayerMainScorePrevNum = thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['score']
											
											varPlayerMainScorePrevSeason = ""
											if (thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['season'] and thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['season'] ~= 0) then
												varPlayerMainScorePrevSeason = " (S" .. (1 + thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['season']) .. ")"
											end
											
											
										
											
										end
									

									end --eo main
								
								
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
								 
								 --tprint(thisPlayerTables['raidProfile']["sortedProgress"])
								-- print(#thisPlayerTables['raidProfile']['sortedProgress'])
						
						
								-- Raid stuff
			
			
								for z=1,#thisPlayerTables['raidProfile']['sortedProgress']  do
								
								
								
								if (thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["dungeon"]["shortName"]) then
								
										--print("--------")
								
										--tprint(thisPlayerTables['raidProfile']['sortedProgress'][z])
									
									
								
								
								
											varRaidName = thisPlayerTables['raidProfile']["sortedProgress"][z]["progress"]["raid"]["dungeon"]["shortName"]
	
											
													
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
				
					TRP3_CharacterTooltip:AddDoubleLine(" ", " ", 100, 100, 0)
					TRP3_CharacterTooltip:AddDoubleLine("Raider.IO", " ", 100, 100, 0)
					fixFontsTrp3RIO()
			
			
					
						
					if (varPlayerScore and varPlayerScore ~= 0) then
					
						varPrevSeasonM = true
						if (varPlayerPrevSeasonLabel == "") then
							varPrevSeasonM = false
						end
					
						TRP3_CharacterTooltip:AddDoubleLine(varPlayerPrevSeasonLabel .. "M+ Score", varPlayerScore, 0.8, 0.8, 0.8, RaiderIO.GetScoreColor(varPlayerScoreNum, varPrevSeasonM));
						fixFontsTrp3RIO()
						
					end
					
					
					if (varPlayerScorePrevNum and varPlayerScorePrevNum ~= 0) then
						
							TRP3_CharacterTooltip:AddDoubleLine("Best M+ Score" .. varPlayerScorePrevSeason, varPlayerScorePrev, 0.8, 0.8, 0.8, RaiderIO.GetScoreColor(varPlayerScorePrevNum, true));
						fixFontsTrp3RIO()
						
						
						
					end
					
					-- Only show if main's score is higher than this char's score
					if (varPlayerMainScore and varPlayerMainScore ~= 0 and varPlayerMainScore > varPlayerScore) then
					
						varPrevSeasonMainM = true
						if (varPlayerMainPrevSeasonLabel == "") then
							varPrevSeasonMainM = false
						end
					
						TRP3_CharacterTooltip:AddDoubleLine("Main's " .. varPlayerMainPrevSeasonLabel .. "M+ Score", varPlayerMainScore, 0.8, 0.8, 0.8, RaiderIO.GetScoreColor(varPlayerMainScore, varPrevSeasonMainM));
						fixFontsTrp3RIO()
						
					end
					
					
					if (varPlayerMainScorePrev ~= 0) then
							TRP3_CharacterTooltip:AddDoubleLine("Main's Best M+ Score" .. varPlayerMainScorePrevSeason, varPlayerMainScorePrev, 0.8, 0.8, 0.8, RaiderIO.GetScoreColor(varPlayerMainScorePrevNum, true));
							fixFontsTrp3RIO()
					end
					
					
					
					
					--loop through raid stuff
					
					
					
					if(tblRaidProgress) then
					
					
						
						
						if(tblRaidProgress["progress"]) then
							-- loop through main progress
							
							

							
							
							for k,v in pairs(tblRaidProgress["progress"]) do
							
							strRaidProgress = ""
							strRaidProgressName = ""
								 
								 
								 if ((tblRaidProgress["progress"][k]["thereIsScore"] == true) ) then
								 --  and (tblRaidProgress["progress"][k]["obsolete"] == false)
								 
									--print(k)
									--tprint(tblRaidProgress["progress"][k])
									strRaidMainName = tblRaidProgress["progress"][k]["name"]
									
									
									if (tblRaidProgress["progress"][k]["normal"]) then
												--Normal

										
										strRaidProgress = strRaidProgress .. normalRaidColor .. "    N " .. normalRaidColorText .. tblRaidProgress["progress"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["normal"]["bossCount"]
										
										--varRaidNumNormal = thisPlayerTables['raidProfile']["progress"][z]["progressCount"]
										
										
									end
									
									if (tblRaidProgress["progress"][k]["heroic"]) then
										--Heroic
										
									
										 
										strRaidProgress = strRaidProgress .. heroicRaidColor .. "    H " .. heroicRaidColorText .. tblRaidProgress["progress"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["heroic"]["bossCount"]
										
										--varRaidNumHeroic = thisPlayerTables['raidProfile']["progress"][z]["progressCount"]
										
									end
									
									
									if (tblRaidProgress["progress"][k]["mythic"]) then
										--Mythic												
										strRaidProgress = strRaidProgress .. mythicRaidColor .. "    M " .. mythicRaidColorText .. tblRaidProgress["progress"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["progress"][k]["mythic"]["bossCount"]
										
										--varRaidNumMythic = thisPlayerTables['raidProfile']["progress"][z]["progressCount"]
										
									end
							
							
							
							
									
									
									
								 
								 
								 end
								
								
								if (strRaidProgress ~= "") then
										
									TRP3_CharacterTooltip:AddDoubleLine(strRaidMainName .. " Progress" , strRaidProgress, 0.8, 0.8, 0.8 );
									fixFontsTrp3RIO()
									
									
								
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
								 -- 
								 
									--print(k)
									--tprint(tblRaidProgress["main"][k])
									
									strRaidMainProgressName = tblRaidProgress["main"][k]["name"]
									
									
									if (tblRaidProgress["main"][k]["normal"]) then
												--Normal

										
										strRaidMainProgress = strRaidMainProgress .. normalRaidColor .. "    N " .. normalRaidColorText .. tblRaidProgress["main"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["normal"]["bossCount"]
										
										--varRaidNumNormal = thisPlayerTables['raidProfile']["main"][z]["progressCount"]
										
										
									end
									
									if (tblRaidProgress["main"][k]["heroic"]) then
										--Heroic
										
									
										 
										strRaidMainProgress = strRaidMainProgress .. heroicRaidColor .. "    H " .. heroicRaidColorText .. tblRaidProgress["main"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["heroic"]["bossCount"]
										
										--varRaidNumHeroic = thisPlayerTables['raidProfile']["main"][z]["progressCount"]
										
									end
									
									
									if (tblRaidProgress["main"][k]["mythic"]) then
										--Mythic												
										strRaidMainProgress = strRaidMainProgress .. mythicRaidColor .. "    M " .. mythicRaidColorText .. tblRaidProgress["main"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["main"][k]["mythic"]["bossCount"]
										
										--varRaidNumMythic = thisPlayerTables['raidProfile']["main"][z]["progressCount"]
										
									end
							
							
							
							
									
									
									
								 
								 
								 end
								 
								 if (strRaidMainProgress ~= "") then
						
									TRP3_CharacterTooltip:AddDoubleLine("Main's " .. strRaidMainProgressName .. " Progress" , strRaidMainProgress, 0.8, 0.8, 0.8 );
								
									fixFontsTrp3RIO()
														
													
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
								 
									--print(k)
									--tprint(tblRaidProgress["prev"][k])
									strRaidProgressPreviousName = tblRaidProgress["prev"][k]["name"]
									
									
									if (tblRaidProgress["prev"][k]["normal"]) then
												--Normal

										
										strRaidProgressPrevious = strRaidProgressPrevious .. normalRaidColor .. "    N " .. normalRaidColorText .. tblRaidProgress["prev"][k]["normal"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["normal"]["bossCount"]
										
										--varRaidNumNormal = thisPlayerTables['raidProfile']["prev"][z]["progressCount"]
										
										
									end
									
									if (tblRaidProgress["prev"][k]["heroic"]) then
										--Heroic
										
									
										 
										strRaidProgressPrevious = strRaidProgressPrevious .. heroicRaidColor .. "    H " .. heroicRaidColorText .. tblRaidProgress["prev"][k]["heroic"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["heroic"]["bossCount"]
										
										--varRaidNumHeroic = thisPlayerTables['raidProfile']["prev"][z]["progressCount"]
										
									end
									
									
									if (tblRaidProgress["prev"][k]["mythic"]) then
										--Mythic												
										strRaidProgressPrevious = strRaidProgressPrevious .. mythicRaidColor .. "    M " .. mythicRaidColorText .. tblRaidProgress["prev"][k]["mythic"]["progressCount"] .. "/" .. tblRaidProgress["prev"][k]["mythic"]["bossCount"]
										
										--varRaidNumMythic = thisPlayerTables['raidProfile']["prev"][z]["progressCount"]
										
									end
							
							
							
							
									
									
									
								 
								 
								 end
								 
								 
								 
								 
								 
								 
								 
								 
								 

								if (strRaidProgressPrevious ~= "") then
								
									TRP3_CharacterTooltip:AddDoubleLine(strRaidProgressPreviousName .. " Progress" , strRaidProgressPrevious, 0.8, 0.8, 0.8 );
									
									fixFontsTrp3RIO()
									
								
								end
								 
							end 
							
							
							
							
						
							
						end --eo prev progress loop
	
	
	
	
	
					
					end

					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
						
						
					
				
			
				
				end -- eo print to tooltip
				
				
				
				
				
				end
				
				
				
				
				
				
				
				end --eo showtooltip
				
			
			else --end of mini tooltip
			
			RaiderIO.ShowProfile(TRP3_CharacterTooltip, "mouseover")
			fixFontsTrp3RIO()
			
			
			end --end of main tooltip
				
				
				
				 
				TRP3_CharacterTooltip:Show()
				TRP3_CharacterTooltip:GetTop()
				
	
				
			
			end)		
			
			
		end
	 
	 
	 
		    
    end
	
	
	
end)







--Config stuff


TRPRIOTOOLTIPS.CONFIG = {};

TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC = "trp3_riotooltips_hide_tooltips_ic";
TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP = "trp3_riotooltips_enable_mini_tooltip";
TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE = "trp3_riotooltips_enable_score";
TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE = "trp3_riotooltips_enable_raid";
TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN = "trp3_riotooltips_enable_score_main";
TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN = "trp3_riotooltips_enable_raid_main";

TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC, false);
TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP, true);
TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE, true);
TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE, true);
TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN, true);
TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN, true);


	TRP3_API.configuration.registerConfigurationPage({
		id = "trp3_riotooltips_config",
		menuText = "Raider.IO",
		pageText = "Raider.IO Tooltips",
		elements = {
			{
				inherit = "TRP3_ConfigCheck",
				title = "Hide Raider.IO Tooltips when IC",
				help = "If this is ticked, Raider.IO info will not be shown when you are IC (In Character).",
				configKey = TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Use minified Raider.IO Tooltip formatting",
				help = "If this is ticked, the addon's minified formatting will be used instead of the original Raider.IO Tooltip info.",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Show Raider.IO Score",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE,
				dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Show Raid Progress",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE,
				dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP },
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Show Main's Raider.IO Score",
				help = "Show the character's main's Raider.IO score, if available.",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN,
				dependentOnOptions = { (TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE and TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP) },
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Show Main's Raid Progress",
				help = "Show the character's main's Raid Progress, if available.",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN,
				dependentOnOptions = { (TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE and TRPRIOTOOLTIPS.CONFIG.ENABLE_MINI_TOOLTIP) },
			}
			
		}
	
	});








end



TRP3_API.module.registerModule({
	name = "Raider.IO Info Tooltips",
	description = "(Unofficial) Adds Raider.IO Information to Total RP3's tooltips.",
	version = 1.36,
	id = "trp3_riotooltips",
	onStart = trp3rioinit,
	minVersion = 60,
});
