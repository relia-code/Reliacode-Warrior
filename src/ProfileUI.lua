--- Modified version of Onni's Big Boy Warrior
local _G, select, setmetatable = _G, select, setmetatable
local TMW = _G.TMW

local A = _G.Action

local CONST = A.Const
local Print = A.Print
local GetSpellInfo = A.GetSpellInfo
local GetToggle = A.GetToggle
local GetLatency = A.GetLatency
local InterruptIsValid = A.InterruptIsValid
local Unit = A.Unit
local UnitIsUnit = _G.UnitIsUnit
local MultiUnits = A.MultiUnits
local ProtectTeammate = A.ProtectTeammate

local ACTION_CONST_WARRIOR_FURY = CONST.WARRIOR_FURY
local ACTION_CONST_WARRIOR_ARMS = CONST.WARRIOR_ARMS
local ACTION_CONST_WARRIOR_PROTECTION = CONST.WARRIOR_PROTECTION

local ipairs, pairs, type, CopyTable = _G.ipairs, _G.pairs, _G.type, _G.CopyTables
local player = "player"

local S = {
    Disarm = (GetSpellInfo(236077)),
    StormBolt = (GetSpellInfo(107570)),
    RallyingCry = (GetSpellInfo(97462)),
    EnragedRegeneration = (GetSpellInfo(184364)),
    Stoneform = (GetSpellInfo(20594)),
    BerserkerRage = (GetSpellInfo(18499)),
    IgnorePain = (GetSpellInfo(190456)),
    VictoryRush = (GetSpellInfo(34428)),
    DiebytheSword = (GetSpellInfo(118038)),
    DefensiveStance = (GetSpellInfo(197690)),
    Overwatch = (GetSpellInfo(329035)),
    Avatar = (GetSpellInfo(107574)),
    ShieldBlock = (GetSpellInfo(2565)),
    LastStand = (GetSpellInfo(12975)),
    ShieldWall = (GetSpellInfo(871)),
    ShieldSlam = (GetSpellInfo(23922))
}

local L = {}
L.AUTO = {
    enUS = "Auto",
    ruRU = "Авто "
}
L.OFF = {
    enUS = "Off",
    ruRU = "Выкл."
}
L.PVP = {
    ANY = "PvP"
}
L.MOUSEOVER = {
    enUS = "Use\
@mouseover",
    ruRU = "Использовать\
@mouseover"
}
L.MOUSEOVERTT = {
    enUS = "Will unlock use actions for @mouseover units\
Example: Resuscitate, Healing\
\
Right click: Create macro",
    ruRU = "Разблокирует использование действий для @mouseover юнитов\
Например: Воскрешение, Хилинг\
\
Правая кнопка мышки: Создать макрос"
}
L.AOE = {
    enUS = "Use\
AoE",
    ruRU = "Использовать\
AoE"
}
L.AOETT = {
    enUS = "Enable multiunits rotation\
\
Right click: Create macro",
    ruRU = "Включает ротацию для нескольких целей\
\
Правая кнопка мышки: Создать макрос"
}
L.DEFENSIVE = {
    enUS = "-- Self Defensive --",
    ruRU = "Своя Оборона"
}
L.OFFENSIVE = {
    enUS = "-- Offensive --",
    ruRU = "-- Offensive --"
}
L.ROTATION = {
    enUS = "Rotation",
    ruRU = "Ротация"
}
L.CATCHINVISIBLE = {
    enUS = "Catch Invisible (arena)",
    ruRU = "Поймать Невидимок (арена)"
}
L.CATCHINVISIBLETT = {
    enUS = "Cast when combat around has been begin and enemy team still has unit in invisible\
Doesn't work if you're mounted or in combat!\
\
Right click: Create macro",
    ruRU = "Применять когда бой поблизости начат и команда противника до сих пор имеет юнита в невидимости\
Не работает, когда вы на транспорте или в бою!\
\
Правая кнопка мышки: Создать макрос"
}
L.STORMBOLTPVP = {
    ANY = "PvP " .. S.StormBolt
}
L.STORMBOLTPVPTT = {
    enUS = "@arena1-3 interrupt PvP list from 'Interrupts' tab by " ..
        S.StormBolt .. "\
More custom config you can find in group by open /tmw\
\
Right click: Create macro",
    ruRU = "@arena1-3 прерывание Параличом PvP списка из вкладки 'Прерывания'\
Больше кастомизации вы найдете в группе открыв /tmw\
\
Правая кнопка мышки: Создать макрос"
}
L.STORMBOLTPVP_ONLYHEAL = {
    enUS = "Only Heal Casts",
    ruRU = "Только Исцел. Заклинания"
}
L.STORMBOLTPVP_ONLYPVP = {
    enUS = "Only PvP Casts",
    ruRU = "Только PvP Заклинания"
}
L.STORMBOLTPVP_BOTH = {
    enUS = "Heal + PvP Casts",
    ruRU = "Исцел. + PvP Заклинания"
}
L.DISARMPVP = {
    enUS = "PvP " .. S.Disarm .. "\
Triggers",
    ruRU = "PvP " .. S.Disarm .. "\
Триггеры"
}
L.DISARMPVPTT = {
    enUS = "@arena1-3, @target, @mouseover, @targettarget\
ON MELEE BURST - Only if melee player has damage buffs\
ON COOLDOWN - means will use always on melee players\
OFF - Cut out from rotation but still allow work through Queue and MSG systems\
If you want fully turn it OFF then you should make SetBlocker in 'Actions' tab\
\
Right click: Create macro",
    ruRU = "@arena1-3, @target, @mouseover, @targettarget\
ON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\
ON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\
OFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\
Если нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'\
\
Правая кнопка мышки: Создать макрос"
}
L.DISARMPVP_MELEEBURST = {
    enUS = "On melee burst",
    ruRU = "На бурст ближ. боя"
}
L.DISARMPVP_ONCD = {
    enUS = "On cooldown",
    ruRU = "По восстановлению"
}
L.DISARMPVPUNITS = {
    enUS = "PvP " .. S.Disarm .. "\
Destinations",
    ruRU = "PvP " .. S.Disarm .. "\
Цели"
}
L.DISARMPVPUNITSTT = {
    enUS = "@primary - is @target, @mouseover, @focustarget, @targettarget (these units are depend on toggles above)\
\
Right click: Create macro",
    ruRU = "@primary - это @target, @mouseover, @focustarget, @targettarget (эти юниты зависят от чекбоксов наверху)\
\
Правая кнопка мышки: Создать макрос"
}
L.USEBERSERKERRAGE_LOC = {
    enUS = S.BerserkerRage .. "\
Loss of Control",
    ruRU = S.BerserkerRage .. "\
Потеря контроля"
}
L.LOC_TT = {
    enUS = "It will be used in the desired rotation order to remove the available effects of loss of control over the character",
    ruRU = "Будет использовано в нужном порядке ротации для снятия доступных эффектов потери контроля над персонажем"
}
L.IGNOREPAIN = {
    enUS = S.IgnorePain .. "\
Health Percent (Self)",
    ruRU = S.IgnorePain .. "\
Здоровье Процент (Свое)"
}
L.VICTORYRUSH = {
    enUS = S.VictoryRush .. "\
Health Percent (Self)",
    ruRU = S.VictoryRush .. "\
Здоровье Процент (Свое)"
}
L.ENRAGEDREGENERATION = {
    enUS = S.EnragedRegeneration .. "\
Health Percent (Self)",
    ruRU = S.EnragedRegeneration .. "\
Здоровье Процент (Свое)"
}
L.RALLYINGCRY = {
    enUS = S.RallyingCry .. "\
Health Percent (Self)",
    ruRU = S.RallyingCry .. "\
Здоровье Процент (Свое)"
}
L.TRINKETDEFENSIVE = {
    enUS = "Protection Trinkets\
Health Percent (Self)",
    ruRU = "Аксессуары Защиты\
Здоровье Процент (Свое)"
}
L.STONEFORM = {
    enUS = S.Stoneform .. "\
Health Percent",
    ruRU = S.Stoneform .. "\
Процент Здоровья"
}
L.DIEBYTHESWORD = {
    enUS = S.DiebytheSword .. "\
Health Percent (Self)",
    ruRU = S.DiebytheSword .. "\
Здоровье Процент (Свое)"
}
L.DEFENSIVESTANCEPVP = {
    enUS = "PvP " .. S.DefensiveStance .. "\
Health Percent (Self) <=",
    ruRU = "PvP " .. S.DefensiveStance .. "\
Здоровье Процент (Свое) <="
}
L.BATTLETANCEPVP = {
    enUS = "PvP Battle Stance \
Health Percent (Self) >=",
    ruRU = "PvP Battle Stance \
Здоровье Процент (Свое)>="
}
L.RALLYINGCRYPARTY = {
    enUS = S.RallyingCry .. "\
Health Percent (Party)",
    ruRU = S.RallyingCry .. "\
Здоровье Процент (Party)"
}
L.STORMBOLTFOCUSPVP = {
    enUS = S.StormBolt .. "\
Queue Focus (Arena)"
}
L.STORMBOLTTARGETRUN = {
    enUS = S.StormBolt .. "\
Target Run Out"
}
L.CUSTOMINTERRUPTPVE = {
    ANY = "Mythic+ & Raid\
Custom Interrupts (PvE)"
}
L.CUSTOMINTERRUPTPVE_TT = {
    enUS = "Custom list for Interrupt and CC in Mythic+ and Raid"
}
L.BURSTPVP = {
    ANY = "Burst PvP"
}
L.PREPAREBURST = {
    ANY = "Prepare Burst \
PvP"
}
L.FORCEBURST = {
    ANY = "Force Burst \
PvP"
}
L.ShieldBlockHP = {
    ANY = S.ShieldBlock .. "\
health (%) <="
}
L.ShieldBlockHits = {
    ANY = S.ShieldBlock .. "\
number of hits >="
}
L.ShieldBlockPhys = {
    ANY = S.ShieldBlock .. "\
inc. phys. dmg (%) >="
}
L.CatchKillStrike = {
    ANY = "Catch death hit"
}
L.CatchKillStrike_TT = {
    ANY = "Try to manage to use\
ability before receiving a fatal strike\
This option is not related to other triggers!"
}
L.HealthPercent = {
    ANY = "health (%) <="
}
L.HealthPercent_TT = {
    ANY = "OFF - The trigger is disabled\
0->100 Less than or equal to the specified percentage of your health\
WARNING: There must be at least one of several triggers turned on\
When selecting multiple triggers, they will be synchronized as one general condition"
}
L.TimeToDieSec = {
    ANY = "time to die (sec) <="
}
L.TimeToDieSec_TT = {
    ANY = "OFF - The trigger is disabled\
0->100 Less than or equal to the specified percentage of your health\
WARNING: There must be at least one of several triggers turned on\
When selecting multiple triggers, they will be synchronized as one general condition"
}
L.OffensiveRage = {
    ANY = "Offensive Rage!"
}
L.OffensiveRage_TT = {
    ANY = "Prioritizes damage over defense."
}
L.OffensiveShieldBlock = {
    ANY = "Offensive " .. S.ShieldBlock
}
L.OffensiveShieldBlock_TT = {
    ANY = "Use to increase the damage of the " .. S.ShieldSlam
}
L.ManageBurstPvP = {
    ANY = "Burst Manually \
By Buttons"
}
L.AutoBurstPvP = {
    ANY = "AUTO Burst\
in killable windows"
}
L.IgnoreKarma = {
    ANY = "Damage on \
Touch of Karma"
}

local SliderMarginOptions = {margin = {top = 10}}
local LayoutConfigOptions = {gutter = 4, padding = {left = 5, right = 5}}
A.Data.ProfileEnabled[A.CurrentProfile] = true
A.Data.ProfileUI = {
    DateTime = "v1.14 (01.12.2020)",
    [2] = {
        [ACTION_CONST_WARRIOR_FURY] = {
            LayoutOptions = LayoutConfigOptions,
            {
                {
                    E = "Checkbox",
                    DB = "mouseover",
                    DBV = true,
                    L = L.MOUSEOVER,
                    TT = L.MOUSEOVERTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = L.AOE,
                    TT = L.AOETT,
                    M = {}
                }
            },
            {
                {
                    E = "Checkbox",
                    DB = "UseBerserkerRage-LoC",
                    DBV = true,
                    L = L.USEBERSERKERRAGE_LOC,
                    TT = L.LOC_TT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "ZakLLInterrupts",
                    DBV = true,
                    L = L.CUSTOMINTERRUPTPVE,
                    TT = L.CUSTOMINTERRUPTPVE_TT,
                    M = {}
                }
            },
            {
                {
                    E = "Header",
                    L = L.DEFENSIVE
                }
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IgnorePain",
                    DBV = 100,
                    ONOFF = true,
                    L = L.IGNOREPAIN,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Stoneform",
                    DBV = 100,
                    ONOFF = true,
                    L = L.STONEFORM,
                    M = {}
                }
            },
            {
                -- [4]
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "EnragedRegeneration",
                    DBV = 100,
                    ONOFF = true,
                    L = L.ENRAGEDREGENERATION,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RallyingCry",
                    DBV = 100,
                    ONOFF = true,
                    L = L.RALLYINGCRY,
                    M = {}
                }
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "VictoryRush",
                    DBV = 60,
                    ONOFF = false,
                    L = L.VICTORYRUSH,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "TrinketDefensive",
                    DBV = 50,
                    ONOFF = false,
                    L = L.TRINKETDEFENSIVE,
                    M = {}
                }
            },
            {
                {
                    E = "Header",
                    L = L.PVP
                }
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "RallyingCryParty",
                    DBV = 30,
                    ONOFF = false,
                    L = L.RALLYINGCRYPARTY,
                    M = {}
                }
            },
            {
                {
                    E = "Checkbox",
                    DB = "CatchInvisible",
                    DBV = true,
                    L = L.CATCHINVISIBLE,
                    TT = L.CATCHINVISIBLETT,
                    M = {}
                },
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.STORMBOLTPVP_ONLYHEAL, value = "Heal"},
                        {text = L.STORMBOLTPVP_ONLYPVP, value = "PvP"},
                        {text = L.STORMBOLTPVP_BOTH, value = "BOTH"},
                        {text = L.OFF, value = "OFF"}
                    },
                    DB = "StormBoltPvP",
                    DBV = "BOTH",
                    L = L.STORMBOLTPVP,
                    TT = L.STORMBOLTPVPTT,
                    M = {}
                }
            },
            {
                -- [10]
                RowOptions = SliderMarginOptions,
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.DISARMPVP_MELEEBURST, value = "ON MELEE BURST"},
                        {text = L.DISARMPVP_ONCD, value = "ON COOLDOWN"},
                        {text = L.OFF, value = "OFF"}
                    },
                    DB = "DisarmPvP",
                    DBV = "ON MELEE BURST",
                    L = L.DISARMPVP,
                    TT = L.DISARMPVPTT,
                    M = {}
                },
                {
                    E = "Dropdown",
                    OT = {
                        {text = "@arena1", value = 1},
                        {text = "@arena2", value = 2},
                        {text = "@arena3", value = 3},
                        {text = "@primary", value = 4}
                    },
                    MULT = true,
                    DB = "DisarmPvPunits",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true
                    },
                    L = L.DISARMPVPUNITS,
                    TT = L.DISARMPVPUNITSTT,
                    M = {}
                }
            },
            {
                {
                    E = "Checkbox",
                    DB = "QueueStormBoltFocus",
                    DBV = false,
                    L = L.STORMBOLTFOCUSPVP,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "StormBoltTargetRun",
                    DBV = false,
                    L = L.STORMBOLTTARGETRUN,
                    M = {}
                }
            }
        },
        [ACTION_CONST_WARRIOR_ARMS] = {
            LayoutOptions = LayoutConfigOptions,
            {
                {
                    E = "Checkbox",
                    DB = "mouseover",
                    DBV = true,
                    L = L.MOUSEOVER,
                    TT = L.MOUSEOVERTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = L.AOE,
                    TT = L.AOETT,
                    M = {}
                }
            },
            {
                {
                    E = "Checkbox",
                    DB = "UseBerserkerRage-LoC",
                    DBV = true,
                    L = L.USEBERSERKERRAGE_LOC,
                    TT = L.LOC_TT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "ZakLLInterrupts",
                    DBV = true,
                    L = L.CUSTOMINTERRUPTPVE,
                    TT = L.CUSTOMINTERRUPTPVE_TT,
                    M = {}
                }
            },
            {
                -- [2] Self Defensives
                {
                    E = "Header",
                    L = L.DEFENSIVE
                }
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IgnorePain",
                    DBV = 100,
                    ONOFF = true,
                    L = L.IGNOREPAIN,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Stoneform",
                    DBV = 100,
                    ONOFF = true,
                    L = L.STONEFORM,
                    M = {}
                }
            },
            {
                -- [4]
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DiebytheSword",
                    DBV = 100,
                    ONOFF = true,
                    L = L.DIEBYTHESWORD,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RallyingCry",
                    DBV = 100,
                    ONOFF = true,
                    L = L.RALLYINGCRY,
                    M = {}
                }
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "VictoryRush",
                    DBV = 60,
                    ONOFF = false,
                    L = L.VICTORYRUSH,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "TrinketDefensive",
                    DBV = 50,
                    ONOFF = false,
                    L = L.TRINKETDEFENSIVE,
                    M = {}
                }
            },
            {
                {
                    E = "Header",
                    L = L.BURSTPVP
                }
            },
            {
                {
                    E = "Checkbox",
                    DB = "ManageBurstPvP",
                    DBV = true,
                    L = L.ManageBurstPvP,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "AutoBurstPvP",
                    DBV = true,
                    L = L.AutoBurstPvP,
                    M = {}
                }
            },
            {
                {
                    E = "Button",
                    H = 35,
                    OnClick = function(self, button, down)
                        if button == "LeftButton" then
                            A.PrepareBurst("ExecuteProc")
                        else
                            A.CraftMacro(
                                "P:Burst",
                                [[#showtip ]] .. S.Bladestorm .. "\
" .. [[/run Action.PrepareBurst("ExecuteProc")]],
                                1,
                                true,
                                true
                            )
                        end
                    end,
                    L = L.PREPAREBURST,
                    TT = L.PREPAREBURST
                },
                {
                    E = "Button",
                    H = 35,
                    OnClick = function(self, button, down)
                        if button == "LeftButton" then
                            A.ForceBurst("ExecuteProc")
                        else
                            A.CraftMacro(
                                "F:Burst",
                                [[#showtip ]] .. S.Avatar .. "\
" .. [[/run Action.ForceBurst("ExecuteProc")]],
                                1,
                                true,
                                true
                            )
                        end
                    end,
                    L = L.FORCEBURST,
                    TT = L.FORCEBURST
                }
            },
            {
                {
                    E = "Header",
                    L = L.PVP
                }
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "BattleStancePvP",
                    DBV = 75,
                    ONOFF = false,
                    L = L.BATTLETANCEPVP,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DefensiveStancePvP",
                    DBV = 50,
                    ONOFF = false,
                    L = L.DEFENSIVESTANCEPVP,
                    M = {}
                }
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "RallyingCryParty",
                    DBV = 30,
                    ONOFF = false,
                    L = L.RALLYINGCRYPARTY,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "IgnoreKarma",
                    DBV = true,
                    L = L.IgnoreKarma,
                    TT = L.IgnoreKarma,
                    M = {}
                }
            },
            {
                {
                    E = "Checkbox",
                    DB = "CatchInvisible",
                    DBV = true,
                    L = L.CATCHINVISIBLE,
                    TT = L.CATCHINVISIBLETT,
                    M = {}
                },
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.STORMBOLTPVP_ONLYHEAL, value = "Heal"},
                        {text = L.STORMBOLTPVP_ONLYPVP, value = "PvP"},
                        {text = L.STORMBOLTPVP_BOTH, value = "BOTH"},
                        {text = L.OFF, value = "OFF"}
                    },
                    DB = "StormBoltPvP",
                    DBV = "BOTH",
                    L = L.STORMBOLTPVP,
                    TT = L.STORMBOLTPVPTT,
                    M = {}
                }
            },
            {
                -- [10]
                RowOptions = SliderMarginOptions,
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.DISARMPVP_MELEEBURST, value = "ON MELEE BURST"},
                        {text = L.DISARMPVP_ONCD, value = "ON COOLDOWN"},
                        {text = L.OFF, value = "OFF"}
                    },
                    DB = "DisarmPvP",
                    DBV = "ON MELEE BURST",
                    L = L.DISARMPVP,
                    TT = L.DISARMPVPTT,
                    M = {}
                },
                {
                    E = "Dropdown",
                    OT = {
                        {text = "@arena1", value = 1},
                        {text = "@arena2", value = 2},
                        {text = "@arena3", value = 3},
                        {text = "@primary", value = 4}
                    },
                    MULT = true,
                    DB = "DisarmPvPunits",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true
                    },
                    L = L.DISARMPVPUNITS,
                    TT = L.DISARMPVPUNITSTT,
                    M = {}
                }
            },
            {
                {
                    E = "Checkbox",
                    DB = "QueueStormBoltFocus",
                    DBV = false,
                    L = L.STORMBOLTFOCUSPVP,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "StormBoltTargetRun",
                    DBV = false,
                    L = L.STORMBOLTTARGETRUN,
                    M = {}
                }
            }
        },
        [ACTION_CONST_WARRIOR_PROTECTION] = {
            LayoutOptions = LayoutConfigOptions,
            {
                {
                    E = "Checkbox",
                    DB = "mouseover",
                    DBV = true,
                    L = L.MOUSEOVER,
                    TT = L.MOUSEOVERTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = L.AOE,
                    TT = L.AOETT,
                    M = {}
                }
            },
            {
                {
                    E = "Checkbox",
                    DB = "UseBerserkerRage-LoC",
                    DBV = true,
                    L = L.USEBERSERKERRAGE_LOC,
                    TT = L.LOC_TT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "ZakLLInterrupts",
                    DBV = true,
                    L = L.CUSTOMINTERRUPTPVE,
                    TT = L.CUSTOMINTERRUPTPVE_TT,
                    M = {}
                }
            },
            {
                {
                    E = "Header",
                    L = L.OFFENSIVE
                }
            },
            {
                RowOptions = {margin = {top = -10}},
                {
                    E = "Checkbox",
                    DB = "offensiveRage",
                    DBV = false,
                    L = L.OffensiveRage,
                    TT = L.OffensiveRage_TT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "offensiveShieldBlock",
                    DBV = false,
                    L = L.OffensiveShieldBlock,
                    TT = L.OffensiveShieldBlock_TT,
                    M = {}
                }
            },
            {
                {
                    E = "Header",
                    L = L.DEFENSIVE
                }
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ShieldBlockHP",
                    DBV = 90,
                    ONOFF = false,
                    L = L.ShieldBlockHP,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 5,
                    DB = "ShieldBlockHits",
                    DBV = 2,
                    ONOFF = false,
                    L = L.ShieldBlockHits,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 5,
                    DB = "ShieldBlockPhys",
                    DBV = 2,
                    ONOFF = false,
                    L = L.ShieldBlockPhys,
                    M = {}
                }
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IgnorePain",
                    DBV = 100,
                    ONOFF = true,
                    L = L.IGNOREPAIN,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VictoryRush",
                    DBV = 100,
                    ONOFF = true,
                    L = L.VICTORYRUSH,
                    M = {}
                }
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. S.RallyingCry .. " -- "
                    }
                }
            },
            {
                RowOptions = {margin = {top = 5}},
                {
                    E = "Checkbox",
                    DB = "RallyingCryCatchKillStrike",
                    DBV = true,
                    L = L.CatchKillStrike,
                    TT = L.CatchKillStrike_TT,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RallyingCryHP",
                    DBV = 30,
                    ONOFF = true,
                    L = L.HealthPercent,
                    TT = L.HealthPercent_TT,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 20,
                    DB = "RallyingCryTTD",
                    DBV = 10,
                    ONOFF = true,
                    L = L.TimeToDieSec,
                    TT = L.TimeToDieSec_TT,
                    M = {}
                }
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. S.LastStand .. " -- "
                    }
                }
            },
            {
                RowOptions = {margin = {top = 5}},
                {
                    E = "Checkbox",
                    DB = "LastStandCatchKillStrike",
                    DBV = true,
                    L = L.CatchKillStrike,
                    TT = L.CatchKillStrike_TT,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LastStandHP",
                    DBV = 20,
                    ONOFF = true,
                    L = L.HealthPercent,
                    TT = L.HealthPercent_TT,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 20,
                    DB = "LastStandTTD",
                    DBV = 5,
                    ONOFF = true,
                    L = L.TimeToDieSec,
                    TT = L.TimeToDieSec_TT,
                    M = {}
                }
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. S.ShieldWall .. " -- "
                    }
                }
            },
            {
                RowOptions = {margin = {top = 5}},
                {
                    E = "Checkbox",
                    DB = "ShieldWallCatchKillStrike",
                    DBV = true,
                    L = L.CatchKillStrike,
                    TT = L.CatchKillStrike_TT,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ShieldWallHP",
                    DBV = 20,
                    ONOFF = true,
                    L = L.HealthPercent,
                    TT = L.HealthPercent_TT,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 20,
                    DB = "ShieldWallTTD",
                    DBV = 5,
                    ONOFF = true,
                    L = L.TimeToDieSec,
                    TT = L.TimeToDieSec_TT,
                    M = {}
                }
            }
        }
    }
}
-----------------------------------------
--                   PvP
-----------------------------------------
-----------------------------------------
--            SPELL REFLECTION - LOGIC IN WORDS
--             (1) Have you learned Spellreflect & Berserker rage? -- Prevent leveling error
--             (1) Is Spellreflect ready before enemy cast ends? -- General logic
--             (2) Logic block for PvE + WPvP + BG's
--             - (2.a) Am I PvP tagged and do I want to reflect this PvP cast?
--             - (2.a) Unit is not casting something I can break
--             - (2.b) Am I in PvE and do I want to relect this PvE cast?
--             (3) Logic block for arena
--             - (3.a) Calculate latest possible reflect time based on end of cast & latency
--             - (3.a) Unit is arena enemy
--             - (3.a) Unit is casting something I want to reflect
--             - (3.a) Unit is not casting something I can break
-----------------------------------------

local unitIDtargets =
    setmetatable(
    {},
    {
        -- string cache for faster performance
        __index = function(t, v)
            t[v] = v .. "target"
            return t[v]
        end
    }
)
local Reflect_Nameplates = MultiUnits:GetActiveUnitPlates()
local Temp = {
    IsSpellReflectPvPDmg = {
        [203286] = true, -- Greater Pyroblast
        [116858] = true, -- Chaos Bolt
        [323673] = true, -- Mindgames
        [204160] = true, -- Chill Streak
        [323764] = true -- Convoke
    },
    IsSpellReflectPvPCC = {
        [33786] = true, -- Cyclone
        [118] = true, -- Polymorph - normal
        [118] = true, -- Polymorph - Sheep
        [28271] = true, -- Polymorph - Turtle
        [28272] = true, -- Polymorph - Pig
        [61305] = true, -- Polymorph - Black Cat
        [61721] = true, -- Polymorph - Rabbit
        [61025] = true, -- Polymorph - Serpent
        [61780] = true, -- Polymorph - Turkey
        [161372] = true, -- Polymorph - Peacock
        [161355] = true, -- Polymorph - Penguin
        [161353] = true, -- Polymorph - Polar Bear Cub
        [161354] = true, -- Polymorph - Monkey
        [126819] = true, -- Polymorph - Porcupine
        [277787] = true, -- Polymorph - Direhorn
        [277792] = true, -- Polymorph - Bumblebee
        [51514] = true, -- Hex - Normal
        [210873] = true, -- Hex - Compy
        [211004] = true, -- Hex - Spider
        [211015] = true, -- Hex - Cockroach
        [211010] = true, -- Hex - Snake
        [269352] = true, -- Hex - Skeletal Hatchling
        [277778] = true, -- Hex - Zandalari Tendonripper
        [277784] = true, -- Hex - Wicker Mongrel
        [309328] = true, -- Hex - Living Honey
        [20066] = true -- Repentance
    },
    IsBreakableSpellReflectPvPCC = {
        [5782] = true -- Warlock - Fear
    },
    IsSpellReflectPvE = {
        --De Other Side
        [332678] = true, -- Gushing Wound
        [332705] = true, -- Smite
        [332707] = true, -- Shadow Word: Pain
        [332605] = true, -- Hex
        [334076] = true, -- Shadowcore
        [332196] = true, -- Discharge
        [328707] = true, -- Scribe
        [333641] = true, -- Reaver
        [332234] = true, -- Essential Oil
        [333711] = true, -- Decrepit Bite
        [323544] = true, -- Blood Nova
        [323569] = true, -- Spilled Essence
        [322736] = true, -- Piercing Barb
        [322746] = true, -- Corrupted Blood
        [320008] = true, -- Frostbolt
        [201159] = true, -- Delta Finger Laser X-treme
        [320785] = true, -- Power Overwhelming
        [321948] = true, -- Explosive Contrivance
        [323687] = true, -- Arcane Lightning
        [321948] = true, -- Localized Explosive Contrivance
        [327646] = true, -- Soulcrusher
        --Halls of Atonement
        [338003] = true, -- Wicked Bolt
        [325700] = true, -- Collect Sins
        [326829] = true, -- Wicked Bolt
        [328791] = true, -- Ritual of Woe
        [323538] = true, -- Bolt of Power
        [319702] = true, -- Blood Torrent
        [328322] = true, -- Villainous Bolt
        [339237] = true, -- Sinlight Visions
        [323001] = true, -- Glass Shards
        --Free Hold
        [259092] = true, -- Lightning Bolt
        [281420] = true, -- Water Bolt
        --Siege of Boralus
        [272588] = true, -- Rotting Wounds
        [272581] = true, -- Water Spray
        [257063] = true, -- Brackish Bolt
        [272571] = true, -- Choking Waters
        -- Temple of Sethraliss
        [263318] = true, -- Jolt
        [263775] = true, -- Gust
        [268061] = true, -- Chain Lightning
        [272820] = true, -- Shock
        [268013] = true, -- Flame Shock
        [274642] = true, -- Lava Burst
        [268703] = true, -- Lightning Bolt
        [272699] = true, -- Venomous Spit
        --Shrine of the Storm
        [265001] = true, -- Sea Blast
        [264560] = true, -- Choking Brine
        [264144] = true, -- Undertow
        [268347] = true, -- Void Bolt
        [267969] = true, -- Water Blast
        [268233] = true, -- Electrifying Shock
        [268315] = true, -- Lash
        [268177] = true, -- Windblast
        [268273] = true, -- Deep Smash
        [268317] = true, -- Rip Mind
        [265001] = true, -- Sea Blast
        [274703] = true, -- Void Bolt
        [268214] = true, -- Carve Flesh
        --Motherlode
        [259856] = true, -- Chemical Burn
        [260318] = true, -- Alpha Cannon
        [262794] = true, -- Energy Lash
        [263202] = true, -- Rock Lance
        [262268] = true, -- Caustic Compound
        [263262] = true, -- Shale Spit
        [263628] = true, -- Charged Claw
        --Underrot
        [260879] = true, -- Blood Bolt
        [265084] = true, -- Blood Bolt
        --Tol Dagor
        [257777] = true, -- Crippling Shiv
        [257033] = true, -- Fuselighter
        [258150] = true, -- Salt Blast
        [258869] = true, -- Blaze
        --Waycrest Manor
        [260701] = true, -- Bramble Bolt
        [260700] = true, -- Ruinous Bolt
        [260699] = true, -- Soul Bolt
        [268271] = true, -- Wracking Chord
        [261438] = true, -- Wasting Strike
        [261440] = true, -- Virulent Pathogen
        [266225] = true, -- Darkened Lightning
        [273653] = true, -- Shadow Claw
        [265881] = true, -- Decaying Touch
        [264153] = true, -- Spit
        [278444] = true, -- Infest
        --Operation: Mechagn
        [298669] = true, -- Taze
        [300764] = true, -- slimebolt
        [300650] = true, -- suffocating smog
        [294195] = true, -- arcing zap
        [291878] = true, -- pulse blast
        -- TEST
        [183345] = true
    }
}
local ReflectSpellsPvP = {}
do
    for _, v in ipairs({Temp.IsSpellReflectPvPCC, Temp.IsSpellReflectPvPDmg, Temp.IsBreakableSpellReflectPvPCC}) do
        for spell, spellValue in pairs(v) do
            if type(spellValue) == "table" then
                ReflectSpellsPvP[spell] = CopyTable(spellValue)
            else
                ReflectSpellsPvP[spell] = spellValue
            end
        end
    end
end

function A.ShouldSpellReflect(self, delay)
    local SpellReflection = A[A.PlayerSpec].SpellReflection
    local BerserkerRage = A[A.PlayerSpec].BerserkerRage

    -- (1)
    if not SpellReflection or not BerserkerRage or not SpellReflection:IsReadyByPassCastGCD(player) then
        return
    end

    -- (2)
    if A.Zone ~= "arena" then
        -- (3)
        local castLeft, _, spellID
        local latency = GetLatency() + (delay * 2)

        for Reflect_UnitID in pairs(Reflect_Nameplates) do
            castLeft, _, spellID = Unit(Reflect_UnitID):IsCastingRemains()

            if
                castLeft > 0 and castLeft <= latency and UnitIsUnit(unitIDtargets[Reflect_UnitID], player) and
                    -- (2.a)
                    ((A.IsInPvP and ReflectSpellsPvP[spellID] and
                        (not Temp.IsBreakableSpellReflectPvPCC[spellID] or BerserkerRage:GetCooldown() > 0)) or
                        -- (2.b)
                        (not A.IsInPvP and Temp.IsSpellReflectPvE[spellID]))
             then
                return true
            end
        end
    else
        local castLeft, _, spellID
        local latency = delay + GetLatency() --+ delay

        for i = 1, 3 do
            castLeft, _, spellID = Unit(arenaIDs[i]):IsCastingRemains()
            -- (3.a)
            if
                castLeft > 0 and castLeft <= latency and UnitIsUnit(unitIDtargets[arenaIDs[i]], player) and
                    ReflectSpellsPvP[spellID] and
                    (not Temp.IsBreakableSpellReflectPvPCC[spellID] or BerserkerRage:GetCooldown() > 0)
             then
                return true
            end
        end
    end
end

function A.IntervenePvP(partyUnitID, delay, hasPriest)
    local Intervene = A[A.PlayerSpec].Intervene

    if A.IsInPvP and A.Zone == "arena" and Intervene then
        local castLeft, _, spellID
        local latency = GetLatency() + (delay * 2)
        for i = 1, 3 do
            castLeft, _, spellID = Unit(arenaIDs[i]):IsCastingRemains()
            if
                castLeft > 0 and castLeft <= latency and UnitIsUnit(unitIDtargets[arenaIDs[i]], partyUnitID) and
                    (ReflectSpellsPvP[spellID] and not hasPriest or spellID == 323673)
             then
                return true
            end
        end
    end
end

local DisarmPvPunits =
    setmetatable(
    {},
    {
        __index = function(t, v)
            t[v] = GetToggle(2, "DisarmPvPunits")
            return t[v]
        end
    }
)
local ImunBuffsCC = {"CCTotalImun", "DamagePhysImun", "TotalImun"}
local ImunBuffsInterrupt = {"KickImun", "TotalImun", "DamagePhysImun"}

function A.ShouldDisarm(unitID, skipShouldStop, isMsg)
    -- Rewrite Disarm
    if A.IsInPvP then
        local isArena = unitID:match("arena")

        if
            ((unitID == "arena1" and DisarmPvPunits[A.PlayerSpec][1]) or
                (unitID == "arena2" and DisarmPvPunits[A.PlayerSpec][2]) or
                (unitID == "arena3" and DisarmPvPunits[A.PlayerSpec][3]) or
                (not isArena and DisarmPvPunits[A.PlayerSpec][4]))
         then
            if
                (not isArena and Unit(unitID):IsEnemy() and Unit(unitID):IsPlayer()) or
                    (isArena and not Unit(unitID):InLOS() and (A.Zone == "arena" or A.Zone == "pvp"))
             then
                local Disarm = A[A.PlayerSpec].Disarm
                if
                    Disarm and
                        ((not isMsg and GetToggle(2, "DisarmPvP") ~= "OFF" and
                            ((not isArena and Disarm:IsReady(unitID, nil, nil, skipShouldStop)) or
                                (isArena and Disarm:IsReadyByPassCastGCD(unitID))) and
                            (Unit(unitID):IsMelee() or Unit(unitID):Class() == "HUNTER") and
                            (GetToggle(2, "DisarmPvP") == "ON COOLDOWN" or ProtectTeammate(25) or
                                Unit(unitID):HasBuffs(185422) > 1)) or
                            (isMsg and Disarm:IsReadyM(unitID))) and
                        Disarm:AbsentImun(unitID, ImunBuffsCC, true) and
                        Unit(unitID):IsControlAble("disarm") and
                        Unit(unitID):InCC() == 0 and
                        Unit(unitID):HasDeBuffs("Disarmed") == 0
                 then
                    return true
                end
            end
        end
    end
end

function A:CanInterruptPassive(unitID, countGCD)
    if A.IsInPvP and (A.Zone == "arena" or A.Zone == "pvp") then
        if self.isPummel then
            local useKick, _, _, notInterruptable = InterruptIsValid(unitID, "Heal", nil, countGCD)
            if not useKick then
                useKick, _, _, notInterruptable = InterruptIsValid(unitID, "PvP", nil, countGCD)
            end
            if
                useKick and not notInterruptable and self:IsReadyByPassCastGCD(unitID) and
                    self:AbsentImun(unitID, ImunBuffsInterrupt, true)
             then
                return true
            end
        end

        if self.isStormBolt then
            local StormBoltPvP = GetToggle(2, "StormBoltPvP")
            if StormBoltPvP and StormBoltPvP ~= "OFF" and self:IsReadyByPassCastGCD(unitID) then
                local _, useCC, castRemainsTime
                if Toggle == "BOTH" then
                    useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, "Heal", nil, countGCD))
                    if not useCC then
                        useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, "PvP", nil, countGCD))
                    end
                else
                    useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, Toggle, nil, countGCD))
                end
                if
                    useCC and castRemainsTime >= GetLatency() and Unit(unitID):IsControlAble("stun") and
                        not Unit(unitID):InLOS() and
                        self:AbsentImun(unitID, ImunBuffsCC, true)
                 then
                    return true
                end
            end
        end
    end
end
