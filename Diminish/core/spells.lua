local _, NS = ...
local C = NS.CATEGORIES

--[[
    If you find any missing or incorrect spellIDs please let me know
    https://wow.curseforge.com/projects/diminish

    Feel free to use this list however you want.
]]

NS.spellList = {
    [207167]  = C.DISORIENT,       -- Blinding Sleet
    [198909]  = C.DISORIENT,       -- Song of Chi-ji
    [202274]  = C.DISORIENT,       -- Incendiary Brew
    [33786]   = C.DISORIENT,       -- Cyclone
    [209753]  = C.DISORIENT,       -- Cyclone Honor Talent
    [31661]   = C.DISORIENT,       -- Dragon's Breath
    [105421]  = C.DISORIENT,       -- Blinding Light
    [8122]    = C.DISORIENT,       -- Psychic Scream
    [605]     = C.DISORIENT,       -- Mind Control
    [2094]    = C.DISORIENT,       -- Blind
    [5782]    = C.DISORIENT,       -- Fear
    [118699]  = C.DISORIENT,       -- Fear (Incorrect?)
    [130616]  = C.DISORIENT,       -- Fear (Incorrect?)
    [5484]    = C.DISORIENT,       -- Howl of Terror
    [115268]  = C.DISORIENT,       -- Mesmerize
    [6358]    = C.DISORIENT,       -- Seduction
    [5246]    = C.DISORIENT,       -- Intimidating Shout
    [207685]  = C.DISORIENT,       -- Sigil of Misery
    [236748]  = C.DISORIENT,       -- Intimidating Roar
    [226943]  = C.DISORIENT,       -- Mind Bomb
    [2637]    = C.DISORIENT,       -- Hibernate
    --[xxxx]  = C.DISORIENT,       -- Holographic Horror Projector

    [99]      = C.INCAPACITATE,    -- Incapacitating Roar
    [203126]  = C.INCAPACITATE,    -- Maim (Blood trauma)
    [236025]  = C.INCAPACITATE,    -- Enraged Maim
    [3355]    = C.INCAPACITATE,    -- Freezing Trap
    [203337]  = C.INCAPACITATE,    -- Freezing Trap (Honor Talent)
    [212365]  = C.INCAPACITATE,    -- Freezing Trap (Incorrect?)
    [19386]   = C.INCAPACITATE,    -- Wyvern Sting
    [209790]  = C.INCAPACITATE,    -- Freezing Arrow
    [213691]  = C.INCAPACITATE,    -- Scatter Shot
    [118]     = C.INCAPACITATE,    -- Polymorph
    [126819]  = C.INCAPACITATE,    -- Polymorph (Porcupine)
    [61721]   = C.INCAPACITATE,    -- Polymorph (Rabbit)
    [28271]   = C.INCAPACITATE,    -- Polymorph (Turtle)
    [28272]   = C.INCAPACITATE,    -- Polymorph (Pig)
    [161353]  = C.INCAPACITATE,    -- Polymorph (Bear cub)
    [161372]  = C.INCAPACITATE,    -- Polymorph (Peacock)
    [61305]   = C.INCAPACITATE,    -- Polymorph (Black Cat)
    [61780]   = C.INCAPACITATE,    -- Polymorph (Turkey)
    [161355]  = C.INCAPACITATE,    -- Polymorph (Penguin)
    [161354]  = C.INCAPACITATE,    -- Polymorph (Monkey)
    [277792]  = C.INCAPACITATE,    -- Polymorph (Bumblebee)
    [277787]  = C.INCAPACITATE,    -- Polymorph (Baby Direhorn)
    [82691]   = C.INCAPACITATE,    -- Ring of Frost
    [115078]  = C.INCAPACITATE,    -- Paralysis
    [20066]   = C.INCAPACITATE,    -- Repentance
    [9484]    = C.INCAPACITATE,    -- Shackle Undead
    [200196]  = C.INCAPACITATE,    -- Holy Word: Chastise
    [1776]    = C.INCAPACITATE,    -- Gouge
    [6770]    = C.INCAPACITATE,    -- Sap
    [199743]  = C.INCAPACITATE,    -- Parley
    [51514]   = C.INCAPACITATE,    -- Hex
    [211004]  = C.INCAPACITATE,    -- Hex (Spider)
    [210873]  = C.INCAPACITATE,    -- Hex (Raptor)
    [211015]  = C.INCAPACITATE,    -- Hex (Cockroach)
    [211010]  = C.INCAPACITATE,    -- Hex (Snake)
    [196942]  = C.INCAPACITATE,    -- Hex (Voodoo Totem)
    [277784]  = C.INCAPACITATE,    -- Hex (Wicker Mongrel)
    [277778]  = C.INCAPACITATE,    -- Hex (Zandalari Tendonripper)
    [710]     = C.INCAPACITATE,    -- Banish
    [6789]    = C.INCAPACITATE,    -- Mortal Coil
    [107079]  = C.INCAPACITATE,    -- Quaking Palm
    [217832]  = C.INCAPACITATE,    -- Imprison
    [221527]  = C.INCAPACITATE,    -- Imprison (Honor Talent)
    [197214]  = C.INCAPACITATE,    -- Sundering
    --[274930]  = C.INCAPACITATE,  -- Organic Discombobulation Grenade

    [47476]   = C.SILENCE,         -- Strangulate
    [204490]  = C.SILENCE,         -- Sigil of Silence
    [78675]   = C.SILENCE,         -- Solar Beam
    [202933]  = C.SILENCE,         -- Spider Sting
    [233022]  = C.SILENCE,         -- Spider Sting 2
    [217824]  = C.SILENCE,         -- Shield of Virtue
    [199683]  = C.SILENCE,         -- Last Word
    [15487]   = C.SILENCE,         -- Silence
    [1330]    = C.SILENCE,         -- Garrote
    [43523]   = C.SILENCE,         -- Unstable Affliction Silence Effect
    [196364]  = C.SILENCE,         -- Unstable Affliction Silence Effect 2

    [210141]  = C.STUN,            -- Zombie Explosion
    [108194]  = C.STUN,            -- Asphyxiate (unholy)
    [221562]  = C.STUN,            -- Asphyxiate (blood)
    [91800]   = C.STUN,            -- Gnaw
    [212332]  = C.STUN,            -- Smash
    [91797]   = C.STUN,            -- Monstrous Blow
    [22570]   = C.STUN,            -- Maim (invalid?)
    [203123]  = C.STUN,            -- Maim
    [163505]  = C.STUN,            -- Rake (Prowl)
    [5211]    = C.STUN,            -- Mighty Bash
    [19577]   = C.STUN,            -- Intimidation (no longer used?)
    [24394]   = C.STUN,            -- Intimidation
--  [232055]  = C.STUN,            -- Fists of Fury
    [119381]  = C.STUN,            -- Leg Sweep
    [853]     = C.STUN,            -- Hammer of Justice
    [1833]    = C.STUN,            -- Cheap Shot
    [408]     = C.STUN,            -- Kidney Shot
    [199804]  = C.STUN,            -- Between the Eyes
    [118905]  = C.STUN,            -- Static Charge (Capacitor Totem)
    [118345]  = C.STUN,            -- Pulverize
    [89766]   = C.STUN,            -- Axe Toss
    [171017]  = C.STUN,            -- Meteor Strike (Infernal)
    [171018]  = C.STUN,            -- Meteor Strike (Abyssal)
    [22703]   = C.STUN,            -- Infernal Awakening
    [30283]   = C.STUN,            -- Shadowfury
    [46968]   = C.STUN,            -- Shockwave
    [132168]  = C.STUN,            -- Shockwave (Protection)
    [132169]  = C.STUN,            -- Storm Bolt
    [64044]   = C.STUN,            -- Psychic Horror
    [200200]  = C.STUN,            -- Holy Word: Chastise Censure
    [204399]  = C.STUN,            -- Earthfury
    [179057]  = C.STUN,            -- Chaos Nova
    [205630]  = C.STUN,            -- Illidan's Grasp, primary effect
    [208618]  = C.STUN,            -- Illidan's Grasp, secondary effect
    [211881]  = C.STUN,            -- Fel Eruption
    [20549]   = C.STUN,            -- War Stomp
    [199085]  = C.STUN,            -- Warpath
    [204437]  = C.STUN,            -- Lightning Lasso
    [255723]  = C.STUN,            -- Bull Rush
    [202244]  = C.STUN,            -- Overrun (Also a knockback)
--    [213688]  = C.STUN,          -- Fel Cleave (doesn't seem to DR)

    [204085]  = C.ROOT,            -- Deathchill
    [339]     = C.ROOT,            -- Entangling Roots
    [170855]  = C.ROOT,            -- Entangling Roots (Nature's Grasp)
    [201589]  = C.ROOT,            -- Entangling Roots (Tree of Life)
    [235963]  = C.ROOT,            -- Entangling Roots (Feral honor talent)
    [45334]   = C.ROOT,            -- Immobilized (Wild Charge) TODO: does not cause DR?
    [102359]  = C.ROOT,            -- Mass Entanglement
    [53148]   = C.ROOT,            -- Charge (Hunter pet)
    [162480]  = C.ROOT,            -- Steel Trap
    [190927]  = C.ROOT,            -- Harpoon
    [200108]  = C.ROOT,            -- Ranger's Net
    [212638]  = C.ROOT,            -- Tracker's net
    [201158]  = C.ROOT,            -- Super Sticky Tar
    [136634]  = C.ROOT,            -- Narrow Escape
    [122]     = C.ROOT,            -- Frost Nova
    [33395]   = C.ROOT,            -- Freeze
    [198121]  = C.ROOT,            -- Frostbite
    [116706]  = C.ROOT,            -- Disable
    [64695]   = C.ROOT,            -- Earthgrab (Totem effect)
    [233582]  = C.ROOT,            -- Entrenched in Flame
    [117526]  = C.ROOT,            -- Binding Shot
    [207171]  = C.ROOT,            -- Winter is Coming

    [207777]  = C.DISARM,          -- Dismantle
    [233759]  = C.DISARM,          -- Grapple Weapon
    [236077]  = C.DISARM,          -- Disarm
    [236236]  = C.DISARM,          -- Disarm (Prot)
    [209749]  = C.DISARM,          -- Faerie Swarm (Balance)

    --[[
    -- May only be tracked by spell aura applied, not broken/refresh
    [51490]   = C.KNOCKBACK,       -- Thunderstorm
    [204263]  = C.KNOCKBACK,       -- Shining Force
    [61391]   = C.KNOCKBACK,       -- Typhoon

    -- May only be tracked by second SPELL_AURA_APPLIED ?
    [102793]  = C.KNOCKBACK,       -- Ursol's Vortex (or 127797 ?)

    -- May only be tracked by SPELL_DAMAGE
    [236776]  = C.KNOCKBACK,       -- Hi-Explosive Trap
    [115770]  = C.KNOCKBACK,       -- Fellash (still exists?)
    [6360]    = C.KNOCKBACK,       -- Whiplash (still exists?)
    ]]
}
