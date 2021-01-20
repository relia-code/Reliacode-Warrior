--- Modified version of Onni's Big Boy Warrior
local _G, select, setmetatable                        = _G, select, setmetatable
local TMW                                             = _G.TMW
local A                                             = _G.Action
local Unit                                            = A.Unit
local GameLocale                                    = A.FormatGameLocale(_G.GetLocale())
local StdUi                                            = A.StdUi
local Factory                                        = StdUi.Factory
local math_random                                    = math.random

partyIDs                                            = {
    [1] = "party1",
    [2] = "party2",
}
arenaIDs                                            = {
    [1] = "arena1",
    [2] = "arena2",
    [3] = "arena3",
}

local table                                            = {}

-- Condition: Partymember is not dead and  lower than given hp % or dies < 4 seconds and closer than 35 yards
-- Used for: Intervene & Rallying cry
function A.ProtectTeammate(hp)
    local needPeel = false
    for i = 1, 2 do
        if (Unit(partyIDs[i]):HealthPercent() > 0 and Unit(partyIDs[i]):HealthPercent() < hp or Unit(partyIDs[i]):TimeToDie() < 4) and Unit(partyIDs[i]):GetRange() < 35 then
            needPeel = true
            break
        end
    end
    return needPeel
end
A.ProtectTeammate = A.MakeFunctionCachedDynamic(A.ProtectTeammate)


function A.ShouldWarBanner()
    local use                = false
    local BerserkerRage        = A[A.PlayerSpec].BerserkerRage
    local sapDebuff            = 6770
    local shadowDanceBuff   = 185422

    -- Usecase: Immediatly use banner after you or a teammate gets sapped.
    if BerserkerRage and Unit("player"):HasDeBuffs(sapDebuff) > 0 and BerserkerRage:GetCooldown() == 0 then
        use = true
    else
        for i = 1, 2 do
            if Unit(partyIDs[i]):HasDeBuffs(sapDebuff) > 0 then
                use = true
                break
            end
        end
    end

    -- Usecase: Immediatly use banner when a rogue uses shadowdance
    if not use then
        for i = 1, 3 do
            if Unit(arenaIDs[i]):HasBuffs(shadowDanceBuff) > 0 then
                use = true
                break
            end
        end
    end

    -- TODO: Add other conditions when use use banner
    return use
end
A.ShouldWarBanner = A.MakeFunctionCachedDynamic(A.ShouldWarBanner)

function A.HasPriest()
    local found    = false
    for i = 1, 3 do
        if Unit(arenaIDs[i]):Class() == "PRIEST" then
            found = true
            break
        end
    end
    return found
end
A.HasPriest = A.MakeFunctionCachedDynamic(A.HasPriest)

table.DisarmPvP    = {
    -- Death Knight
    51271,                -- Pillar of Frost
    315443,                -- Abomination Limb
    -- Hunter
    308491,                -- Resonating Arrow
    -- Monk
    311123,                -- Weapons of Order
    137639,                -- Storm, earth and fire
    152173,                -- Serenity
    -- Paladin
    152262,                -- Seraphim
    343527,                -- Execution Sentence
    31884,                -- Avenging Wrath
    216331,                -- Avenging Crusader
    -- Rogue
    323547,                -- Echoing Reprimand
    185313,                -- Shadow Dance
    13750,                -- Adrenaline Rush
    -- Demon Hunter
    191427,                -- Metamorphosis
    -- Warrior
    107574,                -- Avatar
}

local L                                                = setmetatable({
        ruRU                                         = {
            ZakLLInterruptName         = "Shadowlands  Raid&Mythic+",
        },
        enUS                                        = {
            ZakLLInterruptName         = "Shadowlands  Raid&Mythic+",
        },
    }, { __index = function(t) return t.enUS end })
TMW:RegisterCallback("TMW_ACTION_INTERRUPTS_UI_CREATE_CATEGORY", function(callbackEvent, Category)
        local CL = Action.GetCL()
        Category.options[#Category.options + 1] = { text = L[GameLocale].ZakLLInterruptName, value = "ZakLLInterrupts" }
        Category:SetOptions(Category.options)
end)

Factory[4].ZakLLInterrupts = StdUi:tGenerateMinMax({
        [GameLocale] = {
            ISINTERRUPT = true,
            --De Other Side
            [332329] = { useKick = false, useCC = true, useRacial = true    }, --Devoted Sacrifice;         CC
            [332671] = { useKick = false, useCC = true, useRacial = true    }, --Bladestorm;                CC
            [332666] = { useKick = true, useCC = false, useRacial = false   }, --Renew;                     Kick
            [332706] = { useKick = true, useCC = false, useRacial = false   }, --Heal;                      Kick
            [332612] = { useKick = true, useCC = false, useRacial = false   }, --Healing Wave;              Kick
            [331927] = { useKick = false, useCC = false, useRacial = false  }, --Haywire;                   Block
            [332084] = { useKick = true, useCC = false, useRacial = false   }, --Self-Cleaning Cycle;       Kick
            [340026] = { useKick = false, useCC = true, useRacial = true    }, --Wailing Grief;             CC
            [321764] = { useKick = true, useCC = false, useRacial = false   }, --Bark Armor;                 Kick
            [320008] = { useKick = true, useCC = false, useRacial = false   }, --Frostbolt;                 Kick
            [332608] = { useKick = true, useCC = false, useRacial = false   }, --Lightning Discharge;       Kick
            [328729] = { useKick = true, useCC = false, useRacial = false   }, --Dark Lotus;                 Kick
            [332605] = { useKick = true, useCC = true, useRacial = true     }, --Hex;                         Kick+CC
            -- Halls of Attonement
            [325523] = { useKick = false, useCC = true, useRacial = true    }, --Deadly Thrust;             CC
            [326450] = { useKick = false, useCC = true, useRacial = true    }, --Loyal Beasts;              CC
            [325700] = { useKick = true, useCC = false, useRacial = false   }, --Collect Sins;              Kick
            [325701] = { useKick = true, useCC = true, useRacial = true     }, --Siphon Life;               Kick+CC
            [326607] = { useKick = true, useCC = false, useRacial = false   }, --Turn to Stone;             Kick
            [323552] = { useKick = true, useCC = false, useRacial = false    }, --Volley of Power; Kick
            [323538] = { useKick = true, useCC = false, useRacial = false    }, --Bolt of Power; Kick
            -- Mists of Tirna Scithe
            [322938] = { useKick = true, useCC = false, useRacial = false   }, --Harvest Essence;           Kick
            [322486] = { useKick = false, useCC = true, useRacial = true    }, --Overgrowth;                CC
            [324914] = { useKick = true, useCC = false, useRacial = false   }, --Nourish the Forest;        Kick
            [324776] = { useKick = true, useCC = false, useRacial = false   }, --Bramblethorn Coat;         Kick
            [326046] = { useKick = true, useCC = true, useRacial = true     }, --Stimulate Resistance;      Kick+CC
            [340544] = { useKick = true, useCC = true, useRacial = true     }, --Stimulate Regeneration;    Kick+CC
            [337235] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Pacification;    Kick
            [337251] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Incapacitation;  Kick
            [337253] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Domination;      Kick
            [326021] = { useKick = false, useCC = true, useRacial = true    }, --Acid Globule;              CC
            [331718] = { useKick = false, useCC = true, useRacial = true    }, --Spear Flurry;              CC
            [331743] = { useKick = false, useCC = true, useRacial = true    }, --Bucking Rampage;           CC
            [322450] = { useKick = true, useCC = false, useRacial = false   }, --Consumption;      Kick
            -- Necrotic Wake
            [334748] = { useKick = true, useCC = true, useRacial = true     }, --Drain Fluids;              Kick+CC
            [320462] = { useKick = true, useCC = false, useRacial = false   }, --Necrotic Bolt;             Kick
            [324293] = { useKick = true, useCC = true, useRacial = true     }, --Rasping Scream;            Kick+CC
            [320170] = { useKick = true, useCC = false, useRacial = false   }, --Necrotic Bolt;             Kick
            [338353] = { useKick = true, useCC = true, useRacial = true     }, --Goresplatter;              Kick+CC
            [334748] = { useKick = true, useCC = true, useRacial = true     }, --Drain Fluids;              Kick+CC
            [323190] = { useKick = true, useCC = true, useRacial = true     }, --meat shield;               Kick+CC
            [335143] = { useKick = false, useCC = false, useRacial = false    }, --Bonemend;                     Block        Does Damage if shield is broken, dont stop cast
            [327130] = { useKick = true, useCC = false, useRacial = false   }, --Repair Flesh;              Kick
            --Plaguefall
            [328177] = { useKick = false, useCC = true, useRacial = true    }, --Fungistorm;                CC
            [330403] = { useKick = false, useCC = false, useRacial = false  }, --Wing Buffet;                 Block
            [318949] = { useKick = false, useCC = true, useRacial = true    }, --Festering Belch;           CC
            [319070] = { useKick = true, useCC = false, useRacial = false   }, --Corrosive Gunk;            Kick
            [336451] = { useKick = false, useCC = true, useRacial = true    }, --Bulwark of Maldraxxus;     CC
            [328400] = { useKick = false, useCC = true, useRacial = true    },     --Stealthlings;             CC
            [328180] = { useKick = true, useCC = true, useRacial = true     },     --Gripping Infection;         Kick+CC
            [321999] = { useKick = true, useCC = false, useRacial = false   }, --Viral Globs;                Kick
            [328429] = { useKick = false, useCC = true, useRacial = true    },     --Crushing Embrace;         CC
            [328094] = { useKick = true, useCC = false, useRacial = false   }, --Pestilence Bolt;           Kick
            --Sanguine Depths
            [319654] = { useKick = true, useCC = false, useRacial = false   }, --Hungering Drain;           Kick
            [322433] = { useKick = true, useCC = false, useRacial = false   }, --Stoneskin;                 Kick
            [321038] = { useKick = true, useCC = false, useRacial = false   }, --Wrack Soul;                Kick
            [334653] = { useKick = true, useCC = false, useRacial = false    }, --Engorge; Kick
            [335305] = { useKick = true, useCC = false, useRacial = false    }, --Barbed Shackles; Kick
            [336277] = { useKick = true, useCC = false, useRacial = false    }, --Explosive Anger; Kick
            [326952] = { useKick = true, useCC = false, useRacial = false    }, --Fiery Cantrip Kick
            [324609] = { useKick = false, useCC = true, useRacial = true    }, --Animate Weapon; CC
            [326836] = { useKick = true, useCC = true, useRacial = true    }, --Curse of Suppression Kick+CC
            --Spires of Ascension
            [327413] = { useKick = true, useCC = false, useRacial = false   }, --Rebellious Fist;           Kick
            [317936] = { useKick = true, useCC = false, useRacial = false   }, --Forsworn Doctrine;         Kick
            [317963] = { useKick = true, useCC = false, useRacial = false   }, --Burden of Knowledge;       Kick
            [328295] = { useKick = true, useCC = true, useRacial = true     }, --Greater Mending;           Kick+CC
            [328137] = { useKick = true, useCC = false, useRacial = false   }, --Dark Pulse;                Kick
            [328331] = { useKick = true, useCC = false, useRacial = false   }, --Forced Confession;         Kick
            --Theater of Pain
            [341902] = { useKick = true, useCC = false, useRacial = false   }, --Unholy Fervor;             Kick
            [341969] = { useKick = true, useCC = true, useRacial = true     }, --Withering Discharge        Kick+CC
            [342139] = { useKick = true, useCC = false, useRacial = false   }, --Battle Trance;             Kick
            [330562] = { useKick = true, useCC = false, useRacial = false   }, --Demoralizing Shout;        Kick
            [330810] = { useKick = true, useCC = true, useRacial = true     }, --Bind Soul;                 Kick+CC
            [330586] = { useKick = false, useCC = true, useRacial = true    }, --Devour Flesh                CC
            [342675] = { useKick = true, useCC = true, useRacial = true     }, --Bone Spear;                Kick+CC
            [330868] = { useKick = true, useCC = true, useRacial = true     }, --Necrotic Bolt volley;      Kick+CC
            [341771] = { useKick = true, useCC = false, useRacial = false   }, --Grave Spike;                Kick
            [330532] = { useKick = false, useCC = true, useRacial = true    }, --Jagged Quarrel             CC
            [330875] = { useKick = true, useCC = false, useRacial = false   }, --Spirit Frost;                Kick
            [319669] = { useKick = true, useCC = false, useRacial = false   }, --Spectral Reach;            Kick
            -- Castle Nathria
            [325590] = { useKick = true, useCC = false, useRacial = false   }, --Scornful Blast;            Kick
            [328254] = { useKick = true, useCC = false, useRacial = false   }, --Shattering Ruby;            Kick
            [333002] = { useKick = true, useCC = false, useRacial = false   }, --Vulgar Brand;                Kick
            [337110] = { useKick = true, useCC = false, useRacial = false   }, --Dreadbolt Volley;            Kick

            --[[ Templates
        [] = { useKick = false, useCC = false, useRacial = false}    , -- Block
        [] = { useKick = true, useCC = true, useRacial = true    }, -- Kick+CC
        [] = { useKick = true, useCC = false, useRacial = false    }, -- Kick
        [] = { useKick = false, useCC = true, useRacial = true    }, -- CC
        --]]

        },
    }, 75, 85, math_random(87, 95), true)