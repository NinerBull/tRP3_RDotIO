local trp3rio = CreateFrame("Frame")
trp3rio:RegisterEvent("ADDON_LOADED")
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
											varPlayerScorePrevSeason = " (S" .. thisPlayerTables['mythicKeystoneProfile']['mplusPrevious']['season'] .. ")"
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
												varPlayerMainScorePrevSeason = " (S" .. thisPlayerTables['mythicKeystoneProfile']['mplusMainPrevious']['season'] .. ")"
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
								
						
						
								 if (thisPlayerTables['raidProfile']) then
								 
								 --tprint(thisPlayerTables['raidProfile'])
								
								for z=1,3  do
								
									
								
									if (thisPlayerTables['raidProfile']["progress"][z]) then
								
									
									varRaidName = thisPlayerTables['raidProfile']["progress"][z]["raid"]["shortName"]
								
										-- current prog
										if (thisPlayerTables['raidProfile']["progress"][z]["progressCount"]) then
										
									
											
										
											if (thisPlayerTables['raidProfile']["progress"][z]["difficulty"]) == 1 then
												--Normal
												
											
												
												strRaidProgress = strRaidProgress .. normalRaidColor .. "    N " .. normalRaidColorText .. thisPlayerTables['raidProfile']["progress"][z]["progressCount"] .. "/" .. thisPlayerTables['raidProfile']["progress"][z]["raid"]["bossCount"]
												
												varRaidNumNormal = thisPlayerTables['raidProfile']["progress"][z]["progressCount"]
												
												
											end
											
											if (thisPlayerTables['raidProfile']["progress"][z]["difficulty"]) == 2 then
												--Heroic
												
											
												 
												strRaidProgress = strRaidProgress .. heroicRaidColor .. "    H " .. heroicRaidColorText .. thisPlayerTables['raidProfile']["progress"][z]["progressCount"] .. "/" .. thisPlayerTables['raidProfile']["progress"][z]["raid"]["bossCount"]
												
												varRaidNumHeroic = thisPlayerTables['raidProfile']["progress"][z]["progressCount"]
												
											end
											
											
											if (thisPlayerTables['raidProfile']["progress"][z]["difficulty"]) == 3 then
												--Mythic												
												strRaidProgress = strRaidProgress .. mythicRaidColor .. "    M " .. mythicRaidColorText .. thisPlayerTables['raidProfile']["progress"][z]["progressCount"] .. "/" .. thisPlayerTables['raidProfile']["progress"][z]["raid"]["bossCount"]
												
												varRaidNumMythic = thisPlayerTables['raidProfile']["progress"][z]["progressCount"]
												
											end
											

										end
										
										
										if (TRP3_API.configuration.getValue(TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN)) then
										--main's progress
										
										if (thisPlayerTables['raidProfile']["mainProgress"]) then
										
										if (thisPlayerTables['raidProfile']["mainProgress"][z]) then
										
											if (thisPlayerTables['raidProfile']["mainProgress"][z]["progressCount"]) then
											
											varRaidName = thisPlayerTables['raidProfile']["mainProgress"][z]["raid"]["shortName"]
											
												if (thisPlayerTables['raidProfile']["mainProgress"][z]["progressCount"]) then
												
													varMainRaid = 0
													
													
													
													if (thisPlayerTables['raidProfile']["mainProgress"][z]["progressCount"]) then
															varMainRaid = thisPlayerTables['raidProfile']["mainProgress"][z]["progressCount"]
													end 
													
													
													if (thisPlayerTables['raidProfile']["mainProgress"][z]["difficulty"]) == 1 then
														--Normal
														
														
														
														if (varMainRaid >= varRaidNumNormal) then
															strRaidMainProgress = strRaidMainProgress .. normalRaidColor .. "    N " .. normalRaidColorText .. varMainRaid .. "/" .. thisPlayerTables['raidProfile']["progress"][z]["raid"]["bossCount"]
														end
														
													end
													
													if (thisPlayerTables['raidProfile']["mainProgress"][z]["difficulty"]) == 2 then
														--Heroic
														
														
														
														if (varMainRaid >= varRaidNumHeroic) then
															strRaidMainProgress = strRaidMainProgress .. heroicRaidColor .. "    H " .. heroicRaidColorText .. varMainRaid .. "/" .. thisPlayerTables['raidProfile']["progress"][z]["raid"]["bossCount"]
														end
													end
													
													
													if (thisPlayerTables['raidProfile']["mainProgress"][z]["difficulty"]) == 3 then
														--Mythic
														
													
														
														if (varMainRaid >= varRaidNumMythic) then													
															strRaidMainProgress = strRaidMainProgress .. mythicRaidColor .. "    M " .. mythicRaidColorText .. varMainRaid .. "/" .. thisPlayerTables['raidProfile']["progress"][z]["raid"]["bossCount"]
														end
														
													end
													

												end
											
											end
											
										end
											
											
										end
											
											
										end --eo main
										
										-- previous prog
										if (thisPlayerTables['raidProfile']["previousProgress"]) then
										if (thisPlayerTables['raidProfile']["previousProgress"][z]) then
											if (thisPlayerTables['raidProfile']["previousProgress"][z]["progressCount"]) then
											
											varRaidNamePrevious = thisPlayerTables['raidProfile']["previousProgress"][z]["raid"]["shortName"]
											
												if (thisPlayerTables['raidProfile']["previousProgress"][z]["raid"]["difficulty"]) == 1 then
													--Normal
													
													strRaidProgressPrevious = strRaidProgressPrevious  .. normalRaidColor .. "    N " .. normalRaidColorText .. thisPlayerTables['raidProfile']["previousProgress"][z]["progressCount"] .. "/" .. thisPlayerTables['raidProfile']["previousProgress"][z]["raid"]["bossCount"]
													
													
												end
												
												if (thisPlayerTables['raidProfile']["previousProgress"][z]["raid"]["difficulty"]) == 2 then
													--Heroic
													 
													strRaidProgressPrevious = strRaidProgressPrevious .. heroicRaidColor .. "    H " .. heroicRaidColorText .. thisPlayerTables['raidProfile']["previousProgress"][z]["progressCount"] .. "/" .. thisPlayerTables['raidProfile']["previousProgress"][z]["raid"]["bossCount"]
													
												end
												
												
												if (thisPlayerTables['raidProfile']["previousProgress"][z]["raid"]["difficulty"]) == 3 then
													--Mythic												
													strRaidProgressPrevious = strRaidProgressPrevious .. mythicRaidColor .. "    M " .. mythicRaidColorText .. thisPlayerTables['raidProfile']["previousProgress"][z]["progressCount"] .. "/" .. thisPlayerTables['raidProfile']["previousProgress"][z]["raid"]["bossCount"]
													
												end
												

											end
										end
										
										end
										
										
									end	
										
								
								end
								
								
			
			
								
								
								
											
								
								
							
								
								
								
								
								
								
								
								
							end
						end
						
						end
						
						end --eo raid
				
				-- EO RAID INFO
				
				---------------------------------------------------

			
				
					
				end
				
				
				
				-- Check to see if any of the strings have data in them. If so, show the RIO stuff.
				
				
			if ((varPlayerScore and varPlayerScore ~= 0) or (varPlayerScorePrevNum and varPlayerScorePrevNum ~= 0) or (varPlayerMainScore and varPlayerMainScore ~= 0 and varPlayerMainScore > varPlayerScore) or (varPlayerMainScorePrev ~= 0) or (strRaidProgress ~= "") or (strRaidMainProgress ~= "") or (strRaidProgressPrevious ~= "" and strRaidProgress == "")) then
				
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
					
					if (strRaidProgress ~= "") then
										
						TRP3_CharacterTooltip:AddDoubleLine(varRaidName .. " Progress" , strRaidProgress, 0.8, 0.8, 0.8 );
						fixFontsTrp3RIO()
						
						
					
					end
					
					if (strRaidMainProgress ~= "") then
					
						TRP3_CharacterTooltip:AddDoubleLine("Main's " .. varRaidName .. " Progress" , strRaidMainProgress, 0.8, 0.8, 0.8 );
					
						fixFontsTrp3RIO()
											
										
					end
						
						
					if (strRaidProgressPrevious ~= "" and strRaidProgress == "") then
							-- only show previous progress if nothing in current progress, useful when there's only 1 raid in current tier
						
							TRP3_CharacterTooltip:AddDoubleLine(varRaidNamePrevious .. " Progress" , strRaidProgressPrevious, 0.8, 0.8, 0.8 );
							
							fixFontsTrp3RIO()
							
						
					end
				
			
				
				end -- eo print to tooltip
				
				
				
				
				
				end
				
				
				
				
				
				
				
				end --eo showtooltip
				
				
				
				
				
				
				 
				TRP3_CharacterTooltip:Show()
				TRP3_CharacterTooltip:GetTop()
				
	
				
			
			end)		
			
			
		end
	 
	 
	 
		    
    end
	
	
	
end)







--Config stuff


TRPRIOTOOLTIPS.CONFIG = {};

TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC = "trp3_riotooltips_hide_tooltips_ic";
TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE = "trp3_riotooltips_enable_score";
TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE = "trp3_riotooltips_enable_raid";
TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN = "trp3_riotooltips_enable_score_main";
TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN = "trp3_riotooltips_enable_raid_main";

TRP3_API.configuration.registerConfigKey(TRPRIOTOOLTIPS.CONFIG.HIDE_RIO_TOOLTIPS_IC, false);
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
				title = "Show Raider.IO Score",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Show Raid Progress",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Show Main's Raider.IO Score",
				help = "Show the character's main's Raider.IO score, if available.",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE_MAIN,
				dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_RIO_SCORE },
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Show Main's Raid Progress",
				help = "Show the character's main's Raid Progress, if available.",
				configKey = TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE_MAIN,
				dependentOnOptions = { TRPRIOTOOLTIPS.CONFIG.ENABLE_RAID_SCORE },
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
