local _, NS = ...
local Timers = NS.Timers
local Icons = NS.Icons
local Info = NS.Info

local Diminish = CreateFrame("Frame")
Diminish:RegisterEvent("PLAYER_LOGIN")
Diminish:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

-- used for Diminish_Options
NS.Diminish = Diminish
_G.DIMINISH_NS = NS

local IsInBrawl = _G.C_PvP.IsInBrawl
local hunterList = {}

local unitEvents = {
    target = "PLAYER_TARGET_CHANGED",
    focus = "PLAYER_FOCUS_CHANGED",
    party = "GROUP_ROSTER_UPDATE",
    arena = "ARENA_OPPONENT_UPDATE",
    player = "COMBAT_LOG_EVENT_UNFILTERED",
}

function Diminish:ToggleForZone(dontRunEnable)
    local _, instanceType = IsInInstance()
    local registeredOnce = false

    if instanceType == "arena" then
        -- check if inside arena brawl, C_PvP.IsInBrawl() doesn't
        -- work on PLAYER_ENTERING_WORLD so delay it with this event
       self:RegisterEvent("PVP_BRAWL_INFO_UPDATED")
    else
        self:UnregisterEvent("PVP_BRAWL_INFO_UPDATED")
    end

     -- PVP_BRAWL_INFO_UPDATED triggered ToggleForZone
    if instanceType == "arena" and IsInBrawl() then
        instanceType = "pvp" -- treat arena brawl as a battleground
        self:UnregisterEvent("PVP_BRAWL_INFO_UPDATED")
    end

    -- (Un)register unit events for current zone depending on user settings
    for unit, settings in pairs(NS.db.unitFrames) do -- DR tracking for focus/target etc each have their own seperate settings
        local event = unitEvents[unit]

        if settings.enabled then
            -- Loop through every zone/instance enabled and see if we're currently in that instance
            for zone, state in pairs(settings.zones) do
                if state and zone == instanceType then
                    registeredOnce = true
                    settings.isEnabledForZone = true -- cache for later

                    if not self:IsEventRegistered(event) then
                        self:RegisterEvent(event)
                        NS.Debug("Registered %s for instance %s.", event, instanceType)
                    end

                    break
                else
                    settings.isEnabledForZone = false
                    if self:IsEventRegistered(event) then
                        self:UnregisterEvent(event)
                        NS.Debug("Unregistered %s for instance %s.", event, instanceType)
                    end
                end
            end
        else -- unitframe is not enabled for tracking at all
            settings.isEnabledForZone = false
            if event and self:IsEventRegistered(event) then
                self:UnregisterEvent(event)
                NS.Debug("Unregistered %s for instance %s.", event, instanceType)
            end
        end
    end

    if dontRunEnable then
        -- PVP_BRAWL_INFO_UPDATED triggered ToggleForZone again,
        -- so dont run Enable twice
        return self:SetCLEUWatchVariables()
    end

    if registeredOnce then
        self:Enable()
    else
        self:Disable()
    end
end

function Diminish:SetCLEUWatchVariables()
    local cfg = NS.db.unitFrames

    local targetOrFocusWatchFriendly = false
    if cfg.target.watchFriendly and cfg.target.isEnabledForZone then
        targetOrFocusWatchFriendly = true
    elseif cfg.focus.watchFriendly and cfg.focus.isEnabledForZone then
        targetOrFocusWatchFriendly = true
    end

    -- PvE mode
    self.isWatchingNPCs = NS.db.trackNPCs
    if not cfg.target.isEnabledForZone and not cfg.focus.isEnabledForZone then
        -- PvE mode only works for target/focus so disable mode if those frames are not active
        self.isWatchingNPCs = false
    end

    -- Check if we're tracking any friendly units and not just enemy only
    self.isWatchingFriendly = false
    if cfg.player.isEnabledForZone or cfg.party.isEnabledForZone or targetOrFocusWatchFriendly then
        self.isWatchingFriendly = true
    end

    -- Check if only PlayerFrame tracking is enabled for friendly, if it is
    -- we want to ignore all friendly units later in CLEU except where destGUID == playerGUID
    self.onlyPlayerWatchFriendly = cfg.player.isEnabledForZone
    if cfg.player.isEnabledForZone then
        if cfg.party.isEnabledForZone or targetOrFocusWatchFriendly then
            self.onlyPlayerWatchFriendly = false
        end
    end

    -- Check if we're only tracking friendly units so we can ignore enemy units in CLEU
    self.onlyFriendlyTracking = true
    if cfg.target.isEnabledForZone or cfg.focus.isEnabledForZone or cfg.arena.isEnabledForZone then
        self.onlyFriendlyTracking = false
    end

    -- Check if we're only tracking friendly party members so we can ignore outsiders
    self.onlyTrackingPartyForFriendly = cfg.party.isEnabledForZone
    if targetOrFocusWatchFriendly then
        self.onlyTrackingPartyForFriendly = false
    end
end

function Diminish:Disable()
    self:UnregisterAllEvents()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CVAR_UPDATE")
    Timers:ResetAll(true)
    wipe(hunterList)

    Info("Disabled addon for zone %s.", select(2, IsInInstance()))
end

function Diminish:Enable()
    Timers:ResetAll(true)
    wipe(hunterList)

    self.currInstanceType = select(2, IsInInstance())
    if self.currInstanceType == "pvp" then
        self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
    else
        self:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
        self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    end

    self:SetCLEUWatchVariables()
    self:GROUP_ROSTER_UPDATE()
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    Info("Enabled addon for zone %s.", self.currInstanceType)
end

function Diminish:UnitIsHunter(name) -- for BGs only
    return hunterList[name]
end

function Diminish:InitDB()
    DiminishDB = DiminishDB and next(DiminishDB) ~= nil and DiminishDB or {
        version = GetAddOnMetadata("Diminish", "Version"),
        profileKeys = {},
        profiles = {},
    }

    -- Reset config completly if updating from 2.0.0b-0.1
    -- TODO: remove this when bfa beta is over
    if not DiminishDB.version then
        wipe(DiminishDB)
        self:InitDB()
        return
    end
    DiminishDB.version = DiminishDB.version or GetAddOnMetadata("Diminish", "Version")

    -- Reset config when updating from 2.0.0b-0.2/0.3 to 0.4
    -- (due to new icon size logic)
    -- TODO: remove this when bfa beta is over
    if DiminishDB.version == "2.0.0b" then
        wipe(DiminishDB)
        self:InitDB()
        return
    end

    local playerName = UnitName("player") .. "-" .. GetRealmName()
    local profile = DiminishDB.profileKeys[playerName]

    if not profile or not DiminishDB.profiles[profile] then
        -- Profile doesn't exist or is deleted, reset to default
        DiminishDB.profileKeys[playerName] = "Default"
        profile = "Default"
    end

    -- Copy any settings from default if they don't exist in current profile
    NS.CopyDefaults({
        [profile] = NS.DEFAULT_SETTINGS
    }, DiminishDB.profiles)

    -- Reference to active db profile
    -- Always use this directly or reference will be invalid
    -- after changing profile in Diminish_Options
    NS.db = DiminishDB.profiles[profile]
    NS.activeProfile = profile

    if not IsAddOnLoaded("Diminish_Options") then -- TODO: retest
        -- Cleanup functions/tables only used for Diminish_Options when it's not loaded
        NS.DEFAULT_SETTINGS = nil
        NS.CopyDefaults = nil
        Icons.OnFrameConfigChanged = nil
    end
    self.InitDB = nil
end

--------------------------------------------------------------
-- Events
--------------------------------------------------------------

function Diminish:PLAYER_LOGIN()
    self:InitDB()

    local Masque = LibStub and LibStub("Masque", true)
    NS.MasqueGroup = Masque and Masque:Group("Diminish")
    NS.useCompactPartyFrames = GetCVarBool("useCompactPartyFrames")
    self.PLAYER_GUID = UnitGUID("player")
    self.PLAYER_CLASS = select(2, UnitClass("player"))

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CVAR_UPDATE")
    self:UnregisterEvent("PLAYER_LOGIN")
    self.PLAYER_LOGIN = nil
end

function Diminish:CVAR_UPDATE(name, value)
    if name == "USE_RAID_STYLE_PARTY_FRAMES" then
        NS.useCompactPartyFrames = value ~= "0"
        Icons:AnchorPartyFrames()
    end
end

function Diminish:PVP_BRAWL_INFO_UPDATED()
    if not IsInBrawl() then
        self:UnregisterEvent("PVP_BRAWL_INFO_UPDATED")
    else
        self:ToggleForZone(true)
    end
end

function Diminish:PLAYER_ENTERING_WORLD()
    self:ToggleForZone()

    -- If both Diminish and sArena DR tracking is enabled for arena, then
    -- disable sArena tracking since they overlap each other
    if not self.sArenaDetectRan and self.currInstanceType == "arena" then
        if NS.db.unitFrames.arena.enabled then
            if LibStub and LibStub("AceAddon-3.0", true) then
                local _, sArena = pcall(function()
                    return LibStub("AceAddon-3.0"):GetAddon("sArena")
                end)

                if sArena and sArena.db.profile.drtracker.enabled then
                    sArena.db.profile.drtracker.enabled = false
                    sArena:RefreshConfig()
                end
                self.sArenaDetectRan = true
            end
        end
    end
end

function Diminish:PLAYER_TARGET_CHANGED()
    Timers:Refresh("target")
end

function Diminish:PLAYER_FOCUS_CHANGED()
    Timers:Refresh("focus")
end

function Diminish:ARENA_OPPONENT_UPDATE(unitID, status)
    if status == "seen" and not IsInBrawl() and not strfind(unitID, "pet") then
        Timers:Refresh(unitID)
    end
end

function Diminish:GROUP_ROSTER_UPDATE()
    local members = min(GetNumGroupMembers(), 4)
    Icons:AnchorPartyFrames(members)

    for i = 1, members do
        Timers:Refresh("party"..i)
    end
end

function Diminish:PLAYER_REGEN_DISABLED()
    if not self.prevRegenCheckRan or (GetTime() - self.prevRegenCheckRan) > 20 then
        -- UPDATE_BATTLEFIELD_SCORE is not always ran on player joined/left BG so
        -- trigger on player joined combat to check for any new players
        RequestBattlefieldScoreData()

        self.prevRegenCheckRan = GetTime()
    end
end

function Diminish:UPDATE_BATTLEFIELD_SCORE()
    local GetBattlefieldScore = _G.GetBattlefieldScore
    for i = 1, GetNumBattlefieldScores() do
        local name, _, _, _, _, _, _, _, classToken = GetBattlefieldScore(i)
        if name and classToken == "HUNTER" then
            if not hunterList[name] then
                -- Used to detect if unit is hunter in combat log later on by checking destName
                -- We do this so we can ignore hunters in UNIT_DIED event since Feign Death triggers UNIT_DIED
                hunterList[name] = true
                Info("Add %s to hunter list.", name)
            end
        end
    end
end

do
    local COMBATLOG_PARTY_MEMBER = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_AFFILIATION_PARTY)
    local COMBATLOG_OBJECT_REACTION_FRIENDLY = _G.COMBATLOG_OBJECT_REACTION_FRIENDLY
    local COMBATLOG_OBJECT_TYPE_PLAYER = _G.COMBATLOG_OBJECT_TYPE_PLAYER
    local COMBATLOG_OBJECT_CONTROL_PLAYER = _G.COMBATLOG_OBJECT_CONTROL_PLAYER
    local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
    local bit_band = _G.bit.band

    local CATEGORY_STUN = NS.CATEGORIES.STUN
    local CATEGORY_TAUNT = NS.CATEGORIES.TAUNT
    local spellList = NS.spellList

    local build = select(4, GetBuildInfo())

    function Diminish:COMBAT_LOG_EVENT_UNFILTERED(_, eventType, _, srcGUID, _, _, _, destGUID, destName, destFlags, _, spellID, _, _, auraType)
        -- TODO: remove args & build when bfa is live
        if build >= 80000 then
            _, eventType, _, srcGUID, _, _, _, destGUID, destName, destFlags, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo()
        end

        if auraType == "DEBUFF" then
            local category = spellList[spellID] -- DR category
            if not category then return end

            -- TODO: faster to add eventType blacklist here?

            local isPlayer = bit_band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
            if not isPlayer then
                if not self.isWatchingNPCs then return end

                if bit_band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) <= 0 then -- is not player pet
                    if category ~= CATEGORY_STUN and category ~= CATEGORY_TAUNT then
                        -- only show taunt and stun for normal mobs
                        -- player pets will show all
                        return
                    end
                end
            else
                -- Ignore taunts for players
                if category == CATEGORY_TAUNT then return end
            end

            local isFriendly = bit_band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0
            if not isFriendly and self.onlyFriendlyTracking then return end

            if isFriendly then
                if not self.isWatchingFriendly then return end

                if self.onlyPlayerWatchFriendly then
                    -- Only store friendly timers for player
                    if destGUID ~= self.PLAYER_GUID  then return end
                end

                if self.onlyTrackingPartyForFriendly then
                    -- Only store friendly timers for party1-4 and player
                    if bit_band(destFlags, COMBATLOG_PARTY_MEMBER) == 0 then return end
                end
            end

            if eventType == "SPELL_AURA_REMOVED" then
                Timers:Insert(destGUID, srcGUID, category, spellID, isFriendly, false, nil, destName)
            elseif eventType == "SPELL_AURA_APPLIED" then
                Timers:Insert(destGUID, srcGUID, category, spellID, isFriendly, true, nil, destName)
            elseif eventType == "SPELL_AURA_REFRESH" then
                Timers:Update(destGUID, srcGUID, category, spellID, isFriendly, true, nil, destName)
            end
        end

        if eventType == "UNIT_DIED" or eventType == "PARTY_KILL" then
            if self.currInstanceType == "arena" and not IsInBrawl() then return end

            if destGUID == self.PLAYER_GUID then
                if self.PLAYER_CLASS == "HUNTER" then
                    if NS.GetAuraDuration("player", 5384) then return end -- is feign deathing
                end

                -- Delete all timers when player died
                return Timers:ResetAll()
            end

            -- Delete all timers for single unit
            Timers:Remove(destGUID, false)
        end
    end
end
