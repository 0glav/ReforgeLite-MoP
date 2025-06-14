local _, addonTable = ...
local L = addonTable.L
local ReforgeLite = addonTable.ReforgeLite
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local tsort, tinsert = table.sort, tinsert

ReforgeLiteScalingTable = {
  -- gtCombatRatings.dbc
  -- Spirit dummy
  {},
  -- Dodge rating multipliers
  {
       0.796153187751770,    0.796153068542480,    0.796153068542480,    0.796153068542480,    0.796152949333191,
       0.796153128147125,    0.796153068542480,    0.796153008937836,    0.796153008937836,    0.796153128147125,
       1.194230556488037,    1.592308163642883,    1.990383744239807,    2.388461112976074,    2.786539077758789,
       3.184616804122925,    3.582691907882690,    3.980769872665405,    4.378847599029541,    4.776922702789307,
       5.175000190734863,    5.573077678680420,    5.971153259277344,    6.369230747222900,    6.767308712005615,
       7.165383338928223,    7.563461780548096,    7.961538791656494,    8.359617233276367,    8.757692337036133,
       9.155768394470215,    9.553846359252930,    9.951925277709961,   10.350001335144043,   10.748077392578125,
      11.146153450012207,   11.544231414794922,   11.942307472229004,   12.340383529663086,   12.738462448120117,
      13.136537551879883,   13.534616470336914,   13.932692527770996,   14.330768585205078,   14.728846549987793,
      15.126925468444824,   15.524999618530273,   15.923077583312988,   16.321155548095703,   16.719230651855469,
      17.117309570312500,   17.515386581420898,   17.913461685180664,   18.311538696289062,   18.709617614746094,
      19.107692718505859,   19.505769729614258,   19.903848648071289,   20.301923751831055,   20.700000762939453,
      21.486076354980469,   22.334213256835938,   23.252056121826172,   24.248571395874023,   25.334329605102539,
      26.521877288818359,   27.826231002807617,   29.265518188476562,   30.861820220947266,   32.642307281494141,
      35.121570587158203,   37.789138793945312,   40.659320831298828,   43.747493743896484,   47.070220947265625,
      50.645320892333984,   54.491958618164062,   58.630756378173828,   63.083904266357422,   67.875282287597656,
      89.125953674316406,  117.037277221679688,  153.750198364257812,  201.881378173828125,  265.078338623046875,
     335.000000000000000,  430.000000000000000,  545.000000000000000,  700.000000000000000,  885.000000000000000,
  },
  -- Parry rating multipliers
  {
       0.796153187751770,    0.796153068542480,    0.796153068542480,    0.796153068542480,    0.796152949333191,
       0.796153128147125,    0.796153068542480,    0.796153008937836,    0.796153008937836,    0.796153128147125,
       1.194230556488037,    1.592308163642883,    1.990383744239807,    2.388461112976074,    2.786539077758789,
       3.184616804122925,    3.582691907882690,    3.980769872665405,    4.378847599029541,    4.776922702789307,
       5.175000190734863,    5.573077678680420,    5.971153259277344,    6.369230747222900,    6.767308712005615,
       7.165383338928223,    7.563461780548096,    7.961538791656494,    8.359617233276367,    8.757692337036133,
       9.155768394470215,    9.553846359252930,    9.951925277709961,   10.350001335144043,   10.748077392578125,
      11.146153450012207,   11.544231414794922,   11.942307472229004,   12.340383529663086,   12.738462448120117,
      13.136537551879883,   13.534616470336914,   13.932692527770996,   14.330768585205078,   14.728846549987793,
      15.126925468444824,   15.524999618530273,   15.923077583312988,   16.321155548095703,   16.719230651855469,
      17.117309570312500,   17.515386581420898,   17.913461685180664,   18.311538696289062,   18.709617614746094,
      19.107692718505859,   19.505769729614258,   19.903848648071289,   20.301923751831055,   20.700000762939453,
      21.486076354980469,   22.334213256835938,   23.252056121826172,   24.248571395874023,   25.334329605102539,
      26.521877288818359,   27.826231002807617,   29.265518188476562,   30.861820220947266,   32.642307281494141,
      35.121570587158203,   37.789138793945312,   40.659320831298828,   43.747493743896484,   47.070220947265625,
      50.645320892333984,   54.491958618164062,   58.630756378173828,   63.083904266357422,   67.875282287597656,
      89.125953674316406,  117.037277221679688,  153.750198364257812,  201.881378173828125,  265.078338623046875,
     335.000000000000000,  430.000000000000000,  545.000000000000000,  700.000000000000000,  885.000000000000000,
  },
  -- Hit rating multipliers
  {
       0.307691991329193,    0.307691991329193,    0.307691991329193,    0.307691991329193,    0.307691991329193,
       0.307691991329193,    0.307691991329193,    0.307691991329193,    0.307691991329193,    0.307691991329193,
       0.461537986993790,    0.615384995937347,    0.769231021404266,    0.923076987266541,    1.076923012733459,
       1.230769038200378,    1.384614944458008,    1.538462042808533,    1.692307949066162,    1.846153974533081,
       2.000000000000000,    2.153846025466919,    2.307692050933838,    2.461539030075073,    2.615385055541992,
       2.769231081008911,    2.923077106475830,    3.076922893524170,    3.230768918991089,    3.384614944458008,
       3.538461923599243,    3.692307949066162,    3.846153974533081,    4.000000000000000,    4.153845787048340,
       4.307692050933838,    4.461537837982178,    4.615385055541992,    4.769230842590332,    4.923077106475830,
       5.076922893524170,    5.230769157409668,    5.384614944458008,    5.538462162017822,    5.692306995391846,
       5.846154212951660,    6.000000000000000,    6.153845787048340,    6.307693004608154,    6.461537837982178,
       6.615385055541992,    6.769230842590332,    6.923077106475830,    7.076922893524170,    7.230769157409668,
       7.384614944458008,    7.538462162017822,    7.692306995391846,    7.846154212951660,    8.000000000000000,
       8.303797721862793,    8.631579399108887,    8.986301422119141,    9.371427536010742,    9.791045188903809,
      10.250000000000000,   10.754098892211914,   11.310345649719238,   11.927273750305176,   12.615385055541992,
      13.573554992675781,   14.604499816894531,   15.713747978210449,   16.907243728637695,   18.191390991210938,
      19.573070526123047,   21.059694290161133,   22.659227371215820,   24.380252838134766,   26.231992721557617,
      34.444812774658203,   45.231800079345703,   59.420368194580078,   78.021789550781250,  102.445739746093750,
     130.000000000000000,  166.000000000000000,  211.000000000000000,  269.000000000000000,  340.000000000000000,
  },
  -- Crit rating multipliers
  {
       0.538461983203888,    0.538461983203888,    0.538461983203888,    0.538461983203888,    0.538461983203888,
       0.538461983203888,    0.538461983203888,    0.538461983203888,    0.538461983203888,    0.538461983203888,
       0.807691991329193,    1.076923012733459,    1.346153974533081,    1.615385055541992,    1.884614944458008,
       2.153846025466919,    2.423077106475830,    2.692307949066162,    2.961538076400757,    3.230768918991089,
       3.500000000000000,    3.769231081008911,    4.038462162017822,    4.307692050933838,    4.576922893524170,
       4.846154212951660,    5.115385055541992,    5.384614944458008,    5.653845787048340,    5.923077106475830,
       6.192306995391846,    6.461537837982178,    6.730769157409668,    7.000000000000000,    7.269230842590332,
       7.538462162017822,    7.807693004608154,    8.076923370361328,    8.346154212951660,    8.615384101867676,
       8.884614944458008,    9.153845787048340,    9.423076629638672,    9.692307472229004,    9.961538314819336,
      10.230770111083984,   10.500000000000000,   10.769231796264648,   11.038461685180664,   11.307692527770996,
      11.576923370361328,   11.846155166625977,   12.115385055541992,   12.384616851806641,   12.653846740722656,
      12.923078536987305,   13.192308425903320,   13.461539268493652,   13.730770111083984,   14.000000000000000,
      14.531646728515625,   15.105264663696289,   15.726029396057129,   16.399999618530273,   17.134328842163086,
      17.937500000000000,   18.819673538208008,   19.793104171752930,   20.872728347778320,   22.076923370361328,
      23.753721237182617,   25.557874679565430,   27.499055862426758,   29.587677001953125,   31.834934234619141,
      34.252872467041016,   36.854465484619141,   39.653648376464844,   42.665439605712891,   45.905986785888672,
      60.278423309326172,   79.155647277832031,  103.985641479492188,  136.538131713867188,  179.280044555664062,
     228.000000000000000,  290.000000000000000,  370.000000000000000,  470.000000000000000,  600.000000000000000,
  },
  -- Haste rating multipliers
  {
       0.384615004062653,    0.384615004062653,    0.384615004062653,    0.384615004062653,    0.384615004062653,
       0.384615004062653,    0.384615004062653,    0.384615004062653,    0.384615004062653,    0.384615004062653,
       0.576923012733459,    0.769231021404266,    0.961538016796112,    1.153846025466919,    1.346153974533081,
       1.538462042808533,    1.730769038200378,    1.923076987266541,    2.115385055541992,    2.307692050933838,
       2.500000000000000,    2.692307949066162,    2.884614944458008,    3.076922893524170,    3.269231081008911,
       3.461538076400757,    3.653846025466919,    3.846153974533081,    4.038462162017822,    4.230769157409668,
       4.423077106475830,    4.615385055541992,    4.807693004608154,    5.000000000000000,    5.192307949066162,
       5.384614944458008,    5.576922893524170,    5.769230842590332,    5.961537837982178,    6.153845787048340,
       6.346154212951660,    6.538462162017822,    6.730769157409668,    6.923077106475830,    7.115385055541992,
       7.307693004608154,    7.500000000000000,    7.692306995391846,    7.884614944458008,    8.076923370361328,
       8.269230842590332,    8.461538314819336,    8.653845787048340,    8.846154212951660,    9.038461685180664,
       9.230769157409668,    9.423076629638672,    9.615385055541992,    9.807692527770996,   10.000000000000000,
      10.379747390747070,   10.789473533630371,   11.232876777648926,   11.714286804199219,   12.238806724548340,
      12.812500000000000,   13.442624092102051,   14.137930870056152,   14.909090995788574,   15.769232749938965,
      16.966941833496094,   18.255624771118164,   19.642183303833008,   21.134054183959961,   22.739236831665039,
      24.466339111328125,   26.324617385864258,   28.324035644531250,   30.475315093994141,   32.789989471435547,
      43.056015014648438,   56.539749145507812,   74.275451660156250,   97.527236938476562,  128.057159423828125,
     162.000000000000000,  208.000000000000000,  264.000000000000000,  336.000000000000000,  425.000000000000000,
  },
  -- Expertise rating multipliers
  {
       0.307691991329193,    0.307691991329193,    0.307691991329193,    0.307691991329193,    0.307691991329193,
       0.307691991329193,    0.307691991329193,    0.307691991329193,    0.307691991329193,    0.307691991329193,
       0.461537986993790,    0.615384995937347,    0.769231021404266,    0.923076987266541,    1.076923012733459,
       1.230769038200378,    1.384614944458008,    1.538462042808533,    1.692307949066162,    1.846153974533081,
       2.000000000000000,    2.153846025466919,    2.307692050933838,    2.461539030075073,    2.615385055541992,
       2.769231081008911,    2.923077106475830,    3.076922893524170,    3.230768918991089,    3.384614944458008,
       3.538461923599243,    3.692307949066162,    3.846153974533081,    4.000000000000000,    4.153845787048340,
       4.307692050933838,    4.461537837982178,    4.615385055541992,    4.769230842590332,    4.923077106475830,
       5.076922893524170,    5.230769157409668,    5.384614944458008,    5.538462162017822,    5.692306995391846,
       5.846154212951660,    6.000000000000000,    6.153845787048340,    6.307693004608154,    6.461537837982178,
       6.615385055541992,    6.769230842590332,    6.923077106475830,    7.076922893524170,    7.230769157409668,
       7.384614944458008,    7.538462162017822,    7.692306995391846,    7.846154212951660,    8.000000000000000,
       8.303797721862793,    8.631579399108887,    8.986301422119141,    9.371427536010742,    9.791045188903809,
      10.250000000000000,   10.754098892211914,   11.310345649719238,   11.927273750305176,   12.615385055541992,
      13.573554992675781,   14.604499816894531,   15.713747978210449,   16.907243728637695,   18.191390991210938,
      19.573070526123047,   21.059694290161133,   22.659227371215820,   24.380252838134766,   26.231992721557617,
      34.444812774658203,   45.231800079345703,   59.420368194580078,   78.021789550781250,  102.445739746093750,
     130.000000000000000,  166.000000000000000,  211.000000000000000,  269.000000000000000,  340.000000000000000,
  },
  -- Mastery rating multipliers
  {
       0.538461983203888,    0.538461983203888,    0.538461983203888,    0.538461983203888,    0.538461983203888,
       0.538461983203888,    0.538461983203888,    0.538461983203888,    0.538461983203888,    0.538461983203888,
       0.807691991329193,    1.076923012733459,    1.346153974533081,    1.615385055541992,    1.884614944458008,
       2.153846025466919,    2.423077106475830,    2.692307949066162,    2.961538076400757,    3.230768918991089,
       3.500000000000000,    3.769231081008911,    4.038462162017822,    4.307692050933838,    4.576922893524170,
       4.846154212951660,    5.115385055541992,    5.384614944458008,    5.653845787048340,    5.923077106475830,
       6.192306995391846,    6.461537837982178,    6.730769157409668,    7.000000000000000,    7.269230842590332,
       7.538462162017822,    7.807693004608154,    8.076923370361328,    8.346154212951660,    8.615384101867676,
       8.884614944458008,    9.153845787048340,    9.423076629638672,    9.692307472229004,    9.961538314819336,
      10.230770111083984,   10.500000000000000,   10.769231796264648,   11.038461685180664,   11.307692527770996,
      11.576923370361328,   11.846155166625977,   12.115385055541992,   12.384616851806641,   12.653846740722656,
      12.923078536987305,   13.192308425903320,   13.461539268493652,   13.730770111083984,   14.000000000000000,
      14.531646728515625,   15.105264663696289,   15.726029396057129,   16.399999618530273,   17.134328842163086,
      17.937500000000000,   18.819673538208008,   19.793104171752930,   20.872728347778320,   22.076923370361328,
      23.753721237182617,   25.557874679565430,   27.499055862426758,   29.587677001953125,   31.834934234619141,
      34.252872467041016,   36.854465484619141,   39.653648376464844,   42.665439605712891,   45.905986785888672,
      60.278423309326172,   79.155647277832031,  103.985641479492188,  136.538131713867188,  179.280044555664062,
     228.000000000000000,  290.000000000000000,  370.000000000000000,  470.000000000000000,  600.000000000000000,
  },
}


----------------------------------------- CAP PRESETS ---------------------------------

function ReforgeLite:RatingPerPoint (stat, level)
  level = level or UnitLevel("player")
  if stat == self.STATS.SPELLHIT then
    stat = self.STATS.HIT
  end
  return ReforgeLiteScalingTable[stat][level] or 0
end
function ReforgeLite:GetMeleeHitBonus ()
  return GetHitModifier () or 0
end
function ReforgeLite:GetSpellHitBonus ()
  return GetSpellHitModifier () or 0
end
function ReforgeLite:GetExpertiseBonus ()
  local _, class = UnitClass ("player")
  if class == "HUNTER" then
    return select(3, GetExpertise()) - GetCombatRatingBonus(CR_EXPERTISE)
  else
    return GetExpertise() - GetCombatRatingBonus(CR_EXPERTISE)
  end
end
function ReforgeLite:GetNeededMeleeHit ()
  local diff = self.pdb.targetLevel
  if addonTable.MOP then
    return math.max(0, 3 + 1.5 * diff)
  else
    if diff <= 2 then
      return math.max (0, 5 + 0.5 * diff)
    else
      return 2 + 2 * diff
    end
  end
end
function ReforgeLite:GetNeededSpellHit ()
  local diff = self.pdb.targetLevel
  if diff <= 3 then
    return math.max(0, 6 + 3 * diff)
  else
    return 11 * diff - 18
  end
end
function ReforgeLite:GetNeededExpertiseSoft ()
  local diff = self.pdb.targetLevel
  if addonTable.MOP then
    return math.max(0, 3 + 1.5 * diff)
  else
    return math.ceil (math.max (0, 5 + 0.5 * diff) / 0.25)
  end
end
function ReforgeLite:GetNeededExpertiseHard ()
  local diff = self.pdb.targetLevel
  if addonTable.MOP then
    return math.max(0, 6 + 3 * diff)
  else
    if diff <= 2 then
      return math.ceil (math.max (0, 5 + 0.5 * diff) / 0.25)
    else
      return math.ceil (14 / 0.25)
    end
  end
end

function ReforgeLite:GetSpellHasteBonus()
    local hastePercent = 0
    if GetCombatRatingBonus and CR_HASTE_SPELL then
        hastePercent = GetCombatRatingBonus(CR_HASTE_SPELL) or 0
    elseif GetSpellHaste then
        hastePercent = GetSpellHaste() or 0
    else
        local hasteRating = GetCombatRating and GetCombatRating(CR_HASTE_SPELL) or 0
        local level = UnitLevel("player")
        local hastePerPoint = ReforgeLiteScalingTable[ReforgeLite.STATS.HASTE][level] or 1
        hastePercent = hasteRating / hastePerPoint
    end
    return 1 + (hastePercent / 100)
end

function ReforgeLite:GetRangedHasteBonus()
    local hastePercent = 0
    if GetCombatRatingBonus and CR_HASTE_RANGED then
        hastePercent = GetCombatRatingBonus(CR_HASTE_RANGED) or 0
    elseif GetSpellHaste then
        hastePercent = GetSpellHaste() or 0
    else
        local hasteRating = GetCombatRating and GetCombatRating(CR_HASTE_RANGED) or 0
        local level = UnitLevel("player")
        local hastePerPoint = ReforgeLiteScalingTable[ReforgeLite.STATS.HASTE][level] or 1
        hastePercent = hasteRating / hastePerPoint
    end
    return 1 + (hastePercent / 100) 
end

function ReforgeLite:GetMeleeHasteBonus()
  local hastePercent = 0
  if GetCombatRatingBonus and CR_HASTE_MELEE then
    hastePercent = GetCombatRatingBonus(CR_HASTE_MELEE) or 0
  else
    local hasteRating = GetCombatRating and GetCombatRating(CR_HASTE_MELEE) or 0
    local level = UnitLevel("player")
    local hastePerPoint = ReforgeLiteScalingTable[ReforgeLite.STATS.HASTE][level] or 1
    hastePercent = hasteRating / hastePerPoint
  end
  return 1 + (hastePercent / 100)
end

function ReforgeLite:GetHasteBonuses()
  return self:GetMeleeHasteBonus(), self:GetRangedHasteBonus(), self:GetSpellHasteBonus()
end

function ReforgeLite:CalcHasteWithBonus(haste, hasteBonus)
  return ((hasteBonus - 1) * 100) + haste * hasteBonus
end

function ReforgeLite:CalcHasteWithBonuses(haste)
  local meleeBonus, rangedBonus, spellBonus = self:GetHasteBonuses()
  return self:CalcHasteWithBonus(haste, meleeBonus), self:CalcHasteWithBonus(haste, rangedBonus), self:CalcHasteWithBonus(haste, spellBonus)
end

local function CreateIconMarkup(icon)
  if not icon then
    icon = 134400 
  end
  return CreateSimpleTextureMarkup(icon, 16, 16) .. " "
end

local AtLeast = addonTable.StatCapMethods.AtLeast
local AtMost = addonTable.StatCapMethods.AtMost

local StatHit = ReforgeLite.STATS.HIT
local StatCrit = ReforgeLite.STATS.CRIT
local StatHaste = ReforgeLite.STATS.HASTE
local StatExp = ReforgeLite.STATS.EXP

local CAPS = {
  ManualCap = 1,
  MeleeHitCap = 2,
  SpellHitCap = 3,
  MeleeDWHitCap = 4,
  ExpSoftCap = 5,
  ExpHardCap = 6,
  FirstHasteBreak = 7,
  SecondHasteBreak = 8,
  ThirdHasteBreak = 9,
  FourthHasteBreak = 10,
  FifthHasteBreak = 11,
}

ReforgeLite.capPresets = {
  {
    value = CAPS.ManualCap,
    name = TRACKER_SORT_MANUAL,
    getter = nil
  },
  {
    value = CAPS.MeleeHitCap,
    name = L["Melee hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () - ReforgeLite:GetMeleeHitBonus ())
    end,
    category = StatHit
  },
  {
    value = CAPS.SpellHitCap,
    name = L["Spell hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.SPELLHIT) * (ReforgeLite:GetNeededSpellHit () - ReforgeLite:GetSpellHitBonus ())
    end,
    category = StatHit
  },
  {
    value = CAPS.MeleeDWHitCap,
    name = L["Melee DW hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () + 19 - ReforgeLite:GetMeleeHitBonus ())
    end,
    category = StatHit
  },
  {
    value = CAPS.ExpSoftCap,
    name = L["Expertise soft cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.EXP) * (ReforgeLite:GetNeededExpertiseSoft () - ReforgeLite:GetExpertiseBonus ())
    end,
    category = StatExp
  },
  {
    value = CAPS.ExpHardCap,
    name = L["Expertise hard cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.EXP) * (ReforgeLite:GetNeededExpertiseHard () - ReforgeLite:GetExpertiseBonus ())
    end,
    category = StatExp
  },
}

local function GetActiveItemSet()
  local itemSets = {}
  for _,v in ipairs({INVSLOT_HEAD,INVSLOT_SHOULDER,INVSLOT_CHEST,INVSLOT_LEGS,INVSLOT_HAND}) do
    local item = Item:CreateFromEquipmentSlot(v)
    if not item:IsItemEmpty() then
      local itemSetId = select(16, C_Item.GetItemInfo(item:GetItemID()))
      if itemSetId then
        itemSets[itemSetId] = (itemSets[itemSetId] or 0) + 1
      end
    end
  end
  return itemSets
end

local function GetSpellHasteRequired(percentNeeded)
  return function()
    local hasteMod = ReforgeLite:GetSpellHasteBonus()
    return ceil((percentNeeded - (hasteMod - 1) * 100) * ReforgeLite:RatingPerPoint(ReforgeLite.STATS.HASTE) / hasteMod)
  end
end

local function GetRangedHasteRequired(percentNeeded)
  return function()
    local hasteMod = ReforgeLite:GetRangedHasteBonus()
    return ceil((percentNeeded - (hasteMod - 1) * 100) * ReforgeLite:RatingPerPoint(ReforgeLite.STATS.HASTE) / hasteMod)
  end
end

do
  local nameFormat = "%s%s%% +%s %s "
  local nameFormatWithTicks = nameFormat..L["ticks"]
  if addonTable.playerClass == "DRUID" then
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(136081), 20.01, 1, C_Spell.GetSpellName(774)),
      getter = GetSpellHasteRequired(20.01),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.SecondHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(236153)..CreateIconMarkup(134222), 25.0, 1, C_Spell.GetSpellName(48438) .. " / " .. C_Spell.GetSpellName(81269)),
      getter = GetSpellHasteRequired(25.0),
    })
  elseif addonTable.playerClass == "PRIEST" then
    local devouringPlague, devouringPlagueMarkup = C_Spell.GetSpellName(2944), CreateIconMarkup(252997)
    local shadowWordPain, shadowWordPainMarkup = C_Spell.GetSpellName(589), CreateIconMarkup(136207)
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(devouringPlagueMarkup, 33.33, 1, devouringPlague),
      getter = GetSpellHasteRequired(33.33),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.SecondHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(shadowWordPainMarkup, 20.0, 1, shadowWordPain),
      getter = GetSpellHasteRequired(20.0),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.ThirdHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(devouringPlagueMarkup, 66.67, 2, devouringPlague),
      getter = GetSpellHasteRequired(66.67),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FourthHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(shadowWordPainMarkup, 40.0, 2, shadowWordPain),
      getter = GetSpellHasteRequired(40.0),
    })
  elseif addonTable.playerClass == "MAGE" then
    local combustion, combustionMarkup = C_Spell.GetSpellName(11129), CreateIconMarkup(135824)
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(combustionMarkup, 20.0, 1, combustion),
      getter = GetSpellHasteRequired(20.0),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.SecondHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(combustionMarkup, 40.0, 2, combustion),
      getter = GetSpellHasteRequired(40.0),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.ThirdHasteBreak,
      category = StatHaste,
      name = ("%s %s %s"):format(CreateIconMarkup(135735), D_SECONDS:format(1.5), C_Spell.GetSpellName(30451)),
      getter = function()
        local percentNeeded = 66.67
        if addonTable.playerRace == "Goblin" then
          percentNeeded = 66.67 - 1
        end
        return ceil(ReforgeLite:RatingPerPoint(ReforgeLite.STATS.HASTE) * percentNeeded)
      end,
    })
  elseif addonTable.playerClass == "HUNTER" then
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormat:format(CreateIconMarkup(461114), 20, 3, C_Spell.GetSpellName(77767)),
      getter = GetRangedHasteRequired(19.99),
    })
  elseif addonTable.playerClass == "SHAMAN" then
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(462328), 20.0, 1, C_Spell.GetSpellName(51730)),
      getter = GetSpellHasteRequired(20.0),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.SecondHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(252995), 20.0, 1, C_Spell.GetSpellName(61295)),
      getter = GetSpellHasteRequired(20.0),
    })
  elseif addonTable.playerClass == "MONK" then
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(620831), 11.11, 1, C_Spell.GetSpellName(115151)),
      getter = GetSpellHasteRequired(11.11),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.SecondHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(620831), 22.22, 2, C_Spell.GetSpellName(115151)),
      getter = GetSpellHasteRequired(22.22),
    })
  elseif addonTable.playerClass == "WARLOCK" then
    local corruption = C_Spell.GetSpellName(172)
    local unstableAffliction = C_Spell.GetSpellName(30108)
    local immolate = C_Spell.GetSpellName(348)
    local doom = C_Spell.GetSpellName(603)
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(136122), 16.67, 1, corruption .. " / " .. unstableAffliction),
      getter = GetSpellHasteRequired(16.67),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.SecondHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(135817), 20.0, 1, immolate),
      getter = GetSpellHasteRequired(20.0),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.ThirdHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(136145), 25.0, 1, doom),
      getter = GetSpellHasteRequired(25.0),
    })
  elseif addonTable.playerClass == "DEATHKNIGHT" then
    local frostFever = C_Spell.GetSpellName(55095)
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(135833), 14.29, 1, frostFever),
      getter = GetSpellHasteRequired(14.29),
    })
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.SecondHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(135833), 28.57, 2, frostFever),
      getter = GetSpellHasteRequired(28.57),
    })
  elseif addonTable.playerClass == "PALADIN" then
    local holyRadiance = C_Spell.GetSpellName(82327)
    tinsert(ReforgeLite.capPresets, {
      value = CAPS.FirstHasteBreak,
      category = StatHaste,
      name = nameFormatWithTicks:format(CreateIconMarkup(461859), 20.0, 1, holyRadiance),
      getter = GetSpellHasteRequired(20.0),
    })
  end
end
----------------------------------------- WEIGHT PRESETS ------------------------------

local HitCap = {
  stat = StatHit,
  points = {
    {
      method = AtLeast,
      preset = CAPS.MeleeHitCap
    }
  }
}

local HitCapSpell = {
  stat = StatHit,
  points = {
    {
      method = AtLeast,
      preset = CAPS.SpellHitCap,
    }
  }
}

local SoftExpCap = {
  stat = StatExp,
  points = {
    {
      method = AtLeast,
      preset = CAPS.ExpSoftCap
    }
  }
}

local MeleeCaps = {
  HitCap,
  SoftExpCap
}

local RangedCaps = { HitCap }

local CasterCaps = { HitCapSpell }

local specInfo = {}

do

  local specs = {
    deathknight = {
      blood = 398,
      frost = 399,
      unholy = 400
    },
    druid = {
      balance = 752,
      feralcombat = 750,
      restoration = 748
    },
    hunter = {
      beastmastery = 811,
      marksmanship = 807,
      survival = 809
    },
    mage = {
      arcane = 799,
      fire = 851,
      frost = 823,
    },
    paladin = {
      holy = 831,
      protection = 839,
      retribution = 855
    },
    priest = {
      discipline = 760,
      holy = 813,
      shadow = 795
    },
    rogue = {
      assassination = 182,
      combat = 181,
      subtlety = 183
    },
    shaman = {
      elemental = 261,
      enhancement = 263,
      restoration = 262
    },
    warlock = {
      afflication = 871,
      demonology = 867,
      destruction = 865
    },
    warrior = {
      arms = 746,
      fury = 815,
      protection = 845
    },
    monk = {
    brewmaster = 268,
    mistweaver = 270,
    windwalker = 269
    }
}

	for _,ids in pairs(specs) do
		for _, id in pairs(ids) do
			local _, tabName, _, icon = GetSpecializationInfoForSpecID(id)
			specInfo[id] = { name = tabName, icon = icon }
		end
	end

	specInfo[268] = specInfo[268] or {}
	specInfo[268].name = specInfo[268].name or "Brewmaster"
	specInfo[268].icon = specInfo[268].icon or 608951 -- Keg Smash
	specInfo[269] = specInfo[269] or {}
	specInfo[269].name = specInfo[269].name or "Windwalker"
	specInfo[269].icon = specInfo[269].icon or 608953 -- Fists of Fury
	specInfo[270] = specInfo[270] or {}
	specInfo[270].name = specInfo[270].name or "Mistweaver"
	specInfo[270].icon = specInfo[270].icon or 608952

local presets = {
  ["DEATHKNIGHT"] = {
    [specs.deathknight.blood] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          110, -- Dodge
          100, -- Parry
          150, -- Hit
          20,  -- Crit
          50,  -- Haste
          120, -- Expertise
          200  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtMost,
                preset = CAPS.MeleeHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtMost,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          100, -- Dodge
          90,  -- Parry
          140, -- Hit
          30,  -- Crit
          60,  -- Haste
          110, -- Expertise
          180  -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          120, -- Dodge
          80,  -- Parry
          160, -- Hit
          40,  -- Crit
          70,  -- Haste
          130, -- Expertise
          170  -- Mastery
        },
        caps = MeleeCaps,
      },
    },
    [specs.deathknight.frost] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          90, -- Crit
          160, -- Haste
          50,  -- Expertise
          120   -- Mastery
        },
        caps = MeleeCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          80, -- Crit
          150, -- Haste
          45,  -- Expertise
          120  -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          70, -- Crit
          140, -- Haste
          40,  -- Expertise
          100   -- Mastery
        },
        caps = MeleeCaps,
      },
    },
    [specs.deathknight.unholy] = {
    [RAID] = {
      targetLevel = 3,
      weights = {
        0,   -- Spirit
        0,   -- Dodge
        0,   -- Parry
        261, -- Hit
        233, -- Crit
        240, -- Haste
        113, -- Expertise
        187  -- Mastery
      },
      caps = MeleeCaps,
    },
    [LFG_TYPE_DUNGEON] = {
      targetLevel = 2,
      weights = {
        0,   -- Spirit
        0,   -- Dodge
        0,   -- Parry
        250, -- Hit
        240, -- Crit
        250, -- Haste
        120, -- Expertise
        170  -- Mastery
      },
      caps = MeleeCaps,
    },
    [L["Challenge Mode"]] = {
      targetLevel = 2,
      weights = {
        0,   -- Spirit
        0,   -- Dodge
        0,   -- Parry
        240, -- Hit
        250, -- Crit
        260, -- Haste
        130, -- Expertise
        160  -- Mastery
      },
      caps = MeleeCaps,
    },
   },
  },
  ["DRUID"] = {
    [specs.druid.balance] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          100, -- Crit
          150, -- Haste
          0,   -- Expertise
          130  -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          110, -- Crit
          160, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          120, -- Crit
          170, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = CasterCaps,
      },
    },
    [specs.druid.feralcombat] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          54,  -- Dodge
          0,   -- Parry
          150, -- Hit
          53,  -- Crit
          80,  -- Haste
          120, -- Expertise
          200  -- Mastery
        },
        caps = MeleeCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          50,  -- Dodge
          0,   -- Parry
          140, -- Hit
          60,  -- Crit
          90,  -- Haste
          110, -- Expertise
          180  -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          40,  -- Dodge
          0,   -- Parry
          130, -- Hit
          70,  -- Crit
          100, -- Haste
          100, -- Expertise
          170  -- Mastery
        },
        caps = MeleeCaps,
      },
    },
    [specs.druid.restoration] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          150, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          130, -- Crit
          160, -- Haste
          0,   -- Expertise
          140  -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.FirstHasteBreak,
                after = 120,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          140, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          140, -- Crit
          170, -- Haste
          0,   -- Expertise
          130  -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.FirstHasteBreak,
                after = 110,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          130, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          150, -- Crit
          180, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.FirstHasteBreak,
                after = 100,
              },
            },
          },
        },
      },
    },
  },
  ["HUNTER"] = {
    [specs.hunter.beastmastery] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          150, -- Crit
          110,  -- Haste
          200,   -- Expertise
          80  -- Mastery
        },
        caps = RangedCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          140, -- Crit
          100,  -- Haste
          190,   -- Expertise
          70  -- Mastery
        },
        caps = RangedCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          130, -- Crit
          90, -- Haste
          180,   -- Expertise
          60   -- Mastery
        },
        caps = RangedCaps,
      },
    },
    [specs.hunter.marksmanship] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          150, -- Crit
          110, -- Haste
          200,   -- Expertise
          80   -- Mastery
        },
        caps = RangedCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          160, -- Crit
          120, -- Haste
          190,   -- Expertise
          70   -- Mastery
        },
        caps = RangedCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          170, -- Crit
          130, -- Haste
          180,   -- Expertise
          60   -- Mastery
        },
        caps = RangedCaps,
      },
    },
    [specs.hunter.survival] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          110, -- Crit
          150,  -- Haste
          200,   -- Expertise
          80   -- Mastery
        },
        caps = {
          HitCap,
          {
            stat = StatHaste,
            points = {
              {
                method = AtMost,
                preset = CAPS.FirstHasteBreak,
                after = 0,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          100, -- Crit
          140,  -- Haste
          190,   -- Expertise
          70   -- Mastery
        },
        caps = {
          HitCap,
          {
            stat = StatHaste,
            points = {
              {
                method = AtMost,
                preset = CAPS.FirstHasteBreak,
                after = 0,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          90, -- Crit
          130, -- Haste
          180,   -- Expertise
          60   -- Mastery
        },
        caps = {
          HitCap,
          {
            stat = StatHaste,
            points = {
              {
                method = AtMost,
                preset = CAPS.FirstHasteBreak,
                after = 0,
              },
            },
          },
        },
      },
    },
  },
  ["MAGE"] = {
    [specs.mage.arcane] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          100, -- Crit
          150, -- Haste
          0,   -- Expertise
          130  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ThirdHasteBreak,
                after = 2,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          110, -- Crit
          160, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ThirdHasteBreak,
                after = 2,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          120, -- Crit
          170, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ThirdHasteBreak,
                after = 2,
              },
            },
          },
        },
      },
    },
    [specs.mage.fire] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          160, -- Crit
          140, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SecondHasteBreak,
                after = 2,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          150, -- Crit
          130, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SecondHasteBreak,
                after = 2,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          140, -- Crit
          120, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SecondHasteBreak,
                after = 2,
              },
            },
          },
        },
      },
    },
    [specs.mage.frost] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          140, -- Crit
          160, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatCrit,
            points = {
              {
                method = AtMost,
                value = addonTable.playerRace == "Worgen" and 2922 or 3101,
                after = 100,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          130, -- Crit
          150, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatCrit,
            points = {
              {
                method = AtMost,
                value = addonTable.playerRace == "Worgen" and 2922 or 3101,
                after = 100,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          120, -- Crit
          140, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = {
          HitCapSpell,
          {
            stat = StatCrit,
            points = {
              {
                method = AtMost,
                value = addonTable.playerRace == "Worgen" and 2922 or 3101,
                after = 100,
              },
            },
          },
        },
      },
    },
  },
  ["PALADIN"] = {
    [specs.paladin.holy] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          160, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          80,  -- Crit
          200, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          150, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          90,  -- Crit
          210, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          140, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          100, -- Crit
          220, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = CasterCaps,
      },
    },
    [specs.paladin.protection] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          100, -- Dodge
          100, -- Parry
          150, -- Hit
          50,  -- Crit
          80,  -- Haste
          120, -- Expertise
          200  -- Mastery
        },
        caps = MeleeCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          90,  -- Dodge
          90,  -- Parry
          140, -- Hit
          60,  -- Crit
          90,  -- Haste
          110, -- Expertise
          180  -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          80,  -- Dodge
          80,  -- Parry
          130, -- Hit
          70,  -- Crit
          100, -- Haste
          100, -- Expertise
          170  -- Mastery
        },
        caps = MeleeCaps,
      },
    },
    [specs.paladin.retribution] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          120, -- Crit
          160, -- Haste
          180, -- Expertise
          140  -- Mastery
        },
        caps = MeleeCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          110, -- Crit
          150, -- Haste
          170, -- Expertise
          130  -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          100, -- Crit
          140, -- Haste
          160, -- Expertise
          120  -- Mastery
        },
        caps = MeleeCaps,
      },
    },
  },
  ["PRIEST"] = {
    [specs.priest.discipline] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          150, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          100, -- Crit
          120, -- Haste
          0,   -- Expertise
          80   -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          140, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          110, -- Crit
          130, -- Haste
          0,   -- Expertise
          90   -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          130, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          120, -- Crit
          140, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = CasterCaps,
      },
    },
    [specs.priest.holy] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          150, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          80,  -- Crit
          120, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          140, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          90,  -- Crit
          130, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          130, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          100, -- Crit
          140, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = CasterCaps,
      },
    },
    [specs.priest.shadow] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          130, -- Crit
          140, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          120, -- Crit
          130, -- Haste
          0,   -- Expertise
          90  -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          110, -- Crit
          120, -- Haste
          0,   -- Expertise
          80  -- Mastery
        },
        caps = CasterCaps,
      },
    },
  },
  ["ROGUE"] = {
    [specs.rogue.assassination] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          110, -- Crit
          130, -- Haste
          120, -- Expertise
          140  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 82,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtMost,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          120, -- Crit
          140, -- Haste
          110, -- Expertise
          130  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 82,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtMost,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          130, -- Crit
          150, -- Haste
          100, -- Expertise
          120  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 82,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtMost,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
    },
    [specs.rogue.combat] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          125, -- Crit
          170, -- Haste
          215, -- Expertise
          150  -- Mastery
        },
        caps = {
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 100,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          135, -- Crit
          180, -- Haste
          205, -- Expertise
          140  -- Mastery
        },
        caps = {
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 100,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          145, -- Crit
          190, -- Haste
          195, -- Expertise
          130  -- Mastery
        },
        caps = {
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 100,
              },
            },
          },
        },
      },
    },
    [specs.rogue.subtlety] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          155, -- Hit
          145, -- Crit
          155, -- Haste
          130, -- Expertise
          90   -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.MeleeHitCap,
                after = 110,
              },
              {
                preset = CAPS.SpellHitCap,
                after = 80,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          145, -- Hit
          155, -- Crit
          165, -- Haste
          120, -- Expertise
          80   -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.MeleeHitCap,
                after = 110,
              },
              {
                preset = CAPS.SpellHitCap,
                after = 80,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          135, -- Hit
          165, -- Crit
          175, -- Haste
          110, -- Expertise
          70   -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.MeleeHitCap,
                after = 110,
              },
              {
                preset = CAPS.SpellHitCap,
                after = 80,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
    },
  },
  ["SHAMAN"] = {
    [specs.shaman.elemental] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          80,  -- Crit
          140, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          90,  -- Crit
          150, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          100, -- Crit
          160, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = CasterCaps,
      },
    },
    [specs.shaman.enhancement] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          250, -- Hit
          120, -- Crit
          160,  -- Haste
          190, -- Expertise
          140  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 50,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          240, -- Hit
          110, -- Crit
          150,  -- Haste
          180, -- Expertise
          130  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 50,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          230, -- Hit
          100, -- Crit
          140, -- Haste
          170, -- Expertise
          120  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SpellHitCap,
                after = 50,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
    },
    [specs.shaman.restoration] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          130, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          100, -- Crit
          120, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SecondHasteBreak,
                after = 100,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          120, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          90, -- Crit
          110, -- Haste
          0,   -- Expertise
          100   -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SecondHasteBreak,
                after = 90,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          110, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          80, -- Crit
          100, -- Haste
          0,   -- Expertise
          90   -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.SecondHasteBreak,
                after = 80,
              },
            },
          },
        },
      },
    },
  },
  ["WARLOCK"] = {
    [specs.warlock.afflication] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          120, -- Crit
          160, -- Haste
          0,   -- Expertise
          140  -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          110, -- Crit
          150, -- Haste
          0,   -- Expertise
          130  -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          100, -- Crit
          140, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = CasterCaps,
      },
    },
    [specs.warlock.demonology] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          120, -- Crit
          160, -- Haste
          0,   -- Expertise
          140  -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          130, -- Crit
          170, -- Haste
          0,   -- Expertise
          130  -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          140, -- Crit
          180, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = CasterCaps,
      },
    },
    [specs.warlock.destruction] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          160, -- Crit
          140, -- Haste
          0,   -- Expertise
          120  -- Mastery
        },
        caps = CasterCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          150, -- Crit
          130, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = CasterCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          140, -- Crit
          120, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = CasterCaps,
      },
    },
  },
  ["WARRIOR"] = {
    [specs.warrior.arms] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          150, -- Crit
          130, -- Haste
          200, -- Expertise
          110  -- Mastery
        },
        caps = MeleeCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          140, -- Crit
          120, -- Haste
          190, -- Expertise
          100  -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          130, -- Crit
          110, -- Haste
          180, -- Expertise
          90  -- Mastery
        },
        caps = MeleeCaps,
      },
    },
    [specs.warrior.fury] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          150, -- Crit
          130, -- Haste
          180, -- Expertise
          110  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.MeleeHitCap,
                after = 140,
              },
            },
          },
          SoftExpCap,
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          140, -- Crit
          120, -- Haste
          170, -- Expertise
          100  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.MeleeHitCap,
                after = 140,
              },
            },
          },
          SoftExpCap,
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          130, -- Crit
          110, -- Haste
          160, -- Expertise
          90  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = CAPS.MeleeHitCap,
                after = 140,
              },
            },
          },
          SoftExpCap,
        },
      },
    },
    [specs.warrior.protection] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,  -- Spirit
          100, -- Dodge
          100, -- Parry
          170, -- Hit
          50,  -- Crit
          160,  -- Haste
          170, -- Expertise
          140  -- Mastery
        },
        caps = MeleeCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,  -- Spirit
          90,  -- Dodge
          90,  -- Parry
          160, -- Hit
          45,  -- Crit
          150,  -- Haste
          160, -- Expertise
          130  -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,  -- Spirit
          80,  -- Dodge
          80,  -- Parry
          150, -- Hit
          40,  -- Crit
          140, -- Haste
          150, -- Expertise
          120  -- Mastery
        },
        caps = MeleeCaps,
      },
    },
  },
  ["MONK"] = {
    [specs.monk.brewmaster] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          110, -- Dodge
          0,   -- Parry
          175, -- Hit
          50,  -- Crit
          160,  -- Haste
          120, -- Expertise
          175  -- Mastery
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtMost,
                preset = CAPS.MeleeHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtMost,
                preset = CAPS.ExpSoftCap,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          100, -- Dodge
          0,   -- Parry
          160, -- Hit
          45,  -- Crit
          150,  -- Haste
          160, -- Expertise
          130  -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          90, -- Dodge
          0,   -- Parry
          150, -- Hit
          40,  -- Crit
          140,  -- Haste
          150, -- Expertise
          120  -- Mastery
        },
        caps = MeleeCaps,
      },
    },
    [specs.monk.mistweaver] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          150, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          100, -- Crit
          120, -- Haste
          0,   -- Expertise
          110  -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.FirstHasteBreak,
                after = 90,
              },
            },
          },
        },
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          140, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          110, -- Crit
          130, -- Haste
          0,   -- Expertise
          100  -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.FirstHasteBreak,
                after = 90,
              },
            },
          },
        },
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          130, -- Spirit
          0,   -- Dodge
          0,   -- Parry
          0,   -- Hit
          120, -- Crit
          140, -- Haste
          0,   -- Expertise
          90   -- Mastery
        },
        caps = {
          {
            stat = StatHaste,
            points = {
              {
                method = AtLeast,
                preset = CAPS.FirstHasteBreak,
                after = 90,
              },
            },
          },
        },
      },
    },
    [specs.monk.windwalker] = {
      [RAID] = {
        targetLevel = 3,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          200, -- Hit
          130, -- Crit
          150, -- Haste
          180, -- Expertise
          100  -- Mastery
        },
        caps = MeleeCaps,
      },
      [LFG_TYPE_DUNGEON] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          190, -- Hit
          120, -- Crit
          140, -- Haste
          170, -- Expertise
          90   -- Mastery
        },
        caps = MeleeCaps,
      },
      [L["Challenge Mode"]] = {
        targetLevel = 2,
        weights = {
          0,   -- Spirit
          0,   -- Dodge
          0,   -- Parry
          180, -- Hit
          110, -- Crit
          130, -- Haste
          160, -- Expertise
          80   -- Mastery
        },
        caps = MeleeCaps,
      },
    },
  },
}

ReforgeLite.presets = presets[addonTable.playerClass]

end

function ReforgeLite:InitCustomPresets()
  local customPresets = {}
  for k, v in pairs(self.cdb.customPresets) do
    local preset = addonTable.DeepCopy(v)
    preset.name = k
    tinsert(customPresets, preset)
  end
  self.presets[CUSTOM] = customPresets
end

function ReforgeLite:InitPresets()
  self:InitCustomPresets()
  if PawnVersion then
    self.presets["Pawn"] = function ()
      if not PawnCommon or not PawnCommon.Scales then return {} end
      local result = {}
      for k, v in pairs (PawnCommon.Scales) do
        if v.ClassID == addonTable.playerClassID then
          local preset = {name = v.LocalizedName or k}
          preset.weights = {}
          local raw = v.Values or {}
          preset.weights[self.STATS.SPIRIT] = raw["Spirit"] or 0
          preset.weights[self.STATS.DODGE] = raw["DodgeRating"] or 0
          preset.weights[self.STATS.PARRY] = raw["ParryRating"] or 0
          preset.weights[self.STATS.HIT] = raw["HitRating"] or 0
          preset.weights[self.STATS.CRIT] = raw["CritRating"] or 0
          preset.weights[self.STATS.HASTE] = raw["HasteRating"] or 0
          preset.weights[self.STATS.EXP] = raw["ExpertiseRating"] or 0
          preset.weights[self.STATS.MASTERY] = raw["MasteryRating"] or 0
          local total = 0
          local average = 0
          for i = 1, #self.itemStats do
            if preset.weights[i] ~= 0 then
              total = total + 1
              average = average + preset.weights[i]
            end
          end
          if total > 0 and average > 0 then
            local factor = 1
            while factor * average / total < 10 do
              factor = factor * 100
            end
            while factor * average / total > 1000 do
              factor = factor / 10
            end
            for i = 1, #self.itemStats do
              preset.weights[i] = preset.weights[i] * factor
            end
            tinsert(result, preset)
          end
        end
      end
      return result
    end
  end

  local menuListInit = function(options)
    return function (menu, level)
      if not level then return end
      local list = menu.list
      if level > 1 then
        list = L_UIDROPDOWNMENU_MENU_VALUE
      else
        addonTable.GUI:ClearEditFocus()
      end
      local menuList = {}
      for k in pairs (list) do
        local v = GetValueOrCallFunction(list, k)
        local info = LibDD:UIDropDownMenu_CreateInfo()
        info.notCheckable = true
        info.sortKey = v.name or k
        info.text = info.sortKey
        info.prioritySort = v.prioritySort or 0
        info.value = v
        if specInfo[k] then
          info.text = CreateIconMarkup(specInfo[k].icon) .. specInfo[k].name
          info.sortKey = specInfo[k].name
          info.prioritySort = -1
        end
        if v.icon then
          info.text = CreateIconMarkup(v.icon) .. info.text
        end
        if v.tip then
          info.tooltipTitle = v.tip
          info.tooltipOnButton = true
        end
        if v.caps or v.weights then
          info.func = function()
            LibDD:CloseDropDownMenus()
            options.onClick(info)
          end
        else
          if next (v) then
            info.hasArrow = true
          else
            info.disabled = true
          end
          info.keepShownOnClick = true
        end
        tinsert(menuList, info)
      end
      tsort(menuList, function (a, b)
        if a.prioritySort ~= b.prioritySort then
          return a.prioritySort > b.prioritySort
        end
        return a.sortKey < b.sortKey
      end)
      for _,v in ipairs(menuList) do
        LibDD:UIDropDownMenu_AddButton (v, level)
      end
    end
  end

  self.presetMenu = LibDD:Create_UIDropDownMenu("ReforgeLitePresetMenu", self)
  self.presetMenu.list = self.presets
  LibDD:UIDropDownMenu_Initialize(self.presetMenu, menuListInit({
    onClick = function(info)
      if info.value.targetLevel then
        self.pdb.targetLevel = info.value.targetLevel
        self.targetLevel:SetValue(info.value.targetLevel)
      end
      self:SetStatWeights(info.value.weights, info.value.caps or {})
    end
  }), "MENU")

  local exportList = {
    [REFORGE_CURRENT] = function()
      local result = {
        prioritySort = 1,
        caps = self.pdb.caps,
        weights = self.pdb.weights,
      }
      return result
    end
  }
  addonTable.MergeTables(exportList, self.presets)

  --[===[@debug@
  self.exportPresetMenu = LibDD:Create_UIDropDownMenu("ReforgeLiteExportPresetMenu", self)
  self.exportPresetMenu.list = exportList
  LibDD:UIDropDownMenu_Initialize(self.exportPresetMenu, menuListInit({
    onClick = function(info)
      local output = addonTable.DeepCopy(info.value)
      output.prioritySort = nil
      self:ExportJSON(output, info.sortKey)
    end
  }), "MENU")
  --@end-debug@]===]

  self.presetDelMenu = LibDD:Create_UIDropDownMenu("ReforgeLitePresetDelMenu", self)
  LibDD:UIDropDownMenu_Initialize(self.presetDelMenu, function (menu, level)
    if level ~= 1 then return end
    addonTable.GUI:ClearEditFocus()
    local menuList = {}
    for _, db in ipairs({self.db, self.cdb}) do
      for k in pairs(db.customPresets or {}) do
        local info = LibDD:UIDropDownMenu_CreateInfo()
        info.notCheckable = true
        info.text = k
        info.func = function()
          db.customPresets[k] = nil
          self:InitCustomPresets()
          if not self:CustomPresetsExist() then
            self.deletePresetButton:Disable()
          end
          LibDD:CloseDropDownMenus()
        end
        tinsert(menuList, info)
      end
    end
    tsort(menuList, function (a, b) return a.text < b.text end)
    for _,v in ipairs(menuList) do
      LibDD:UIDropDownMenu_AddButton(v, level)
    end
  end, "MENU")

end
