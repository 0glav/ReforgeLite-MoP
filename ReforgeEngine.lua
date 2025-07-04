local addonName, addonTable = ...
local REFORGE_COEFF = addonTable.REFORGE_COEFF

local ReforgeLite = addonTable.ReforgeLite
local L = addonTable.L
local DeepCopy = addonTable.DeepCopy
local playerClass, playerRace = addonTable.playerClass, addonTable.playerRace
local missChance = (playerRace == "NIGHTELF" and 7 or 5)

local floor, tinsert, unpack, pairs, random = floor, tinsert, unpack, pairs, random
local GetItemStats = C_Item.GetItemStats or GetItemStats

---------------------------------------------------------------------------------------
function ReforgeLite:GetPlayerBuffs()
  local kings, flask, food, spellHaste, meleeHaste
  local slots = {C_UnitAuras.GetAuraSlots('player','helpful')}
  for i = 2, #slots do
    local aura = C_UnitAuras.GetAuraDataBySlot('player',slots[i])
    if aura then
      local id = aura.spellId
      if id == 20217 or id == 1126 or id == 115921 then -- Blessing of Kings, Mark of the Wild, Legacy of the Emperor
        kings = true
      elseif id == 105694 then -- 250 mastery food (Sea Mist Rice Noodles)
        food = 1
      elseif id == 105701 then -- 250 strength food (Black Pepper Ribs and Shrimp)
        food = 4
      elseif id == 104300 then -- 100 strength food (Chun Tian Spring Rolls)
        food = 5
      elseif id == 94162 then -- 1000 strength flask (Flask of Winter's Bite)
        flask = 1
      elseif id == 92679 then -- 300 stamina flask (Flask of Steelskin)
        flask = 2
      elseif id == 24907 or id == 15473 or id == 51470 then -- Moonkin Aura, Shadowform, Elemental Oath
        spellHaste = true
      elseif id == 55610 or id == 30809 or id == 113742 then -- Unholy Aura, Unleashed Rage, Swiftblade's Cunning
        meleeHaste = true
      end
    end
  end
  return kings, flask, food, spellHaste, meleeHaste
end

function ReforgeLite:DiminishStat (rating, stat)
  return rating > 0 and 1 / (0.00687 + 0.956 / (rating / self:RatingPerPoint(stat))) or 0
end
function ReforgeLite:GetMethodScore (method)
  local score = 0
  for i = 1, #self.itemStats do
    score = score + self:GetStatScore (i, method.stats[i])
  end
  return RoundToSignificantDigits(score, 2)
end

local itemBonuses = {
  -- Mists of Pandaria Trinkets
  [87063] = { 0, 0, 0, 1658 },  -- Qin-xi's Polarizing Seal (Mastery)
  [87065] = { 0, 0, 0, 1658 },  -- Lei Shin's Final Orders (Mastery)
  [86790] = { 0, 0, 0, 1467 },  -- Relic of Niuzao (Mastery proc)
  [87065] = { 0, 0, 0, 1658 },  -- Bottle of Infinite Stars (Mastery)
  [87163] = { 0, 0, 0, 1658 },  -- Steadfast Talisman of the Shado-Pan
  [87167] = { 0, 0, 0, 1658 },  -- Jade Warlord Figurine (Mastery)
}

function ReforgeLite:UpdateMethodStats (method)
  method.stats = {}
  for i = 1, #self.itemStats do
    method.stats[i] = self.itemStats[i].getter ()
  end
  local oldspi = method.stats[self.STATS.SPIRIT]
  method.stats[self.STATS.SPIRIT] = method.stats[self.STATS.SPIRIT] / self.spiritBonus
  for i = 1, #method.items do
    local item = self.itemData[i].item
    local stats = (item and GetItemStats (item) or {})
    if self.itemData[i].reforge then
      local src, dst = unpack(self.reforgeTable[self.itemData[i].reforge])
      local amount = floor ((stats[self.itemStats[src].name] or 0) * REFORGE_COEFF)
      method.stats[src] = method.stats[src] + amount
      method.stats[dst] = method.stats[dst] - amount
    end
    if method.items[i].src and method.items[i].dst then
      method.items[i].amount = floor ((stats[self.itemStats[method.items[i].src].name] or 0) * REFORGE_COEFF)
      method.stats[method.items[i].src] = method.stats[method.items[i].src] - method.items[i].amount
      method.stats[method.items[i].dst] = method.stats[method.items[i].dst] + method.items[i].amount
    else
      method.items[i].amount = nil
    end
  end
  method.stats[self.STATS.SPIRIT] = Round(method.stats[self.STATS.SPIRIT] * self.spiritBonus)
  if self.s2hFactor > 0 then
    method.stats[self.STATS.HIT] = method.stats[self.STATS.HIT] +
      Round((method.stats[self.STATS.SPIRIT] - oldspi) * self.s2hFactor / 100)
  end
end

function ReforgeLite:FinalizeReforge (data)
  for _,item in ipairs(data.method.items) do
    item.reforge = nil
    if item.src and item.dst then
      item.reforge = self:GetReforgeTableIndex(item.src, item.dst)
    end
    item.stats = nil
  end
  self:UpdateMethodStats (data.method)
end

function ReforgeLite:ResetMethod ()
  local method = { items = {} }
  for i = 1, #self.itemData do
    method.items[i] = {}
    if self.itemData[i].reforge then
      method.items[i].reforge = self.itemData[i].reforge
      method.items[i].src, method.items[i].dst = unpack(self.reforgeTable[self.itemData[i].reforge])
    end
  end
  self:UpdateMethodStats (method)
  self.pdb.method = method
  self:UpdateMethodCategory()
end

function ReforgeLite:CapAllows (cap, value)
  for _,v in ipairs(cap.points) do
    if v.method == addonTable.StatCapMethods.AtLeast and value < v.value then
      return false
    elseif v.method == addonTable.StatCapMethods.AtMost and value > v.value then
      return false
    elseif v.method == addonTable.StatCapMethods.Exactly and value ~= v.value then
      return false
    end
  end
  return true
end

function ReforgeLite:IsItemLocked (slot)
  local slotData = self.itemData[slot]
  return not slotData.item
  or slotData.ilvl < 200
  or self.pdb.itemsLocked[slotData.itemGUID]
end

------------------------------------- CLASSIC REFORGE ------------------------------

function ReforgeLite:MakeReforgeOption (item, data, src, dst)
  local delta1, delta2, dscore = 0, 0, 0
  if src then
    local amount = floor (item.stats[src] * REFORGE_COEFF)
    if src == self.STATS.SPIRIT then
      amount = floor (amount * self.spiritBonus + random ())
    end
    if src == data.caps[1].stat then
      delta1 = delta1 - amount
    elseif src == data.caps[2].stat then
      delta2 = delta2 - amount
    elseif src == self.STATS.SPIRIT then
      dscore = dscore - data.weights[src] * amount
      if self.s2hFactor > 0 then
        if data.caps[1].stat == self.STATS.HIT then
          delta1 = delta1 - floor (amount * self.s2hFactor / 100 + random ())
        elseif data.caps[2].stat == self.STATS.HIT then
          delta2 = delta2 - floor (amount * self.s2hFactor / 100 + random ())
        end
      end
    else
      dscore = dscore - data.weights[src] * amount
    end
  end
  if dst then
    local amount = floor (item.stats[src] * REFORGE_COEFF)
    if dst == self.STATS.SPIRIT then
      amount = floor (amount * self.spiritBonus + random ())
    end
    if dst == data.caps[1].stat then
      delta1 = delta1 + amount
    elseif dst == data.caps[2].stat then
      delta2 = delta2 + amount
    elseif dst == self.STATS.SPIRIT then
      dscore = dscore + data.weights[dst] * amount
      if self.s2hFactor > 0 then
        if data.caps[1].stat == self.STATS.HIT then
          delta1 = delta1 + floor (amount * self.s2hFactor / 100 + random ())
        elseif data.caps[2].stat == self.STATS.HIT then
          delta2 = delta2 + floor (amount * self.s2hFactor / 100 + random ())
        end
      end
    else
      dscore = dscore + data.weights[dst] * amount
    end
  end
  return {d1 = delta1, d2 = delta2, score = dscore, src = src, dst = dst}
end
function ReforgeLite:GetItemReforgeOptions (item, data, slot)
  if self:IsItemLocked (slot) then
    local src, dst = nil, nil
    if self.itemData[slot].reforge then
      src, dst = unpack(self.reforgeTable[self.itemData[slot].reforge])
    end
    return { self:MakeReforgeOption (item, data, src, dst) }
  end
  local aopt = {}
  aopt[0] = self:MakeReforgeOption (item, data)
  for src = 1, #self.itemStats do
    if item.stats[src] > 0 then
      for dst = 1, #self.itemStats do
        if item.stats[dst] == 0 then
          local o = self:MakeReforgeOption (item, data, src, dst)
          local pos = o.d1 + o.d2 * 10000
          if not aopt[pos] or aopt[pos].score < o.score then
            aopt[pos] = o
          end
        end
      end
    end
  end
  local opt = {}
  for _, v in pairs (aopt) do
    tinsert (opt, v)
  end
  return opt
end
function ReforgeLite:InitReforgeClassic ()
  local method = { items = {} }
  for i = 1, #self.itemData do
    method.items[i] = {}
    method.items[i].stats = {}
    local item = self.itemData[i].item
    local stats = (item and GetItemStats (item) or {})
    for j = 1, #self.itemStats do
      method.items[i].stats[j] = (stats[self.itemStats[j].name] or 0)
    end
  end

  local data = {}
  data.method = method
  data.weights = DeepCopy (self.pdb.weights)
  data.caps = DeepCopy (self.pdb.caps)
  data.caps[1].init = 0
  data.caps[2].init = 0
  data.initial = {}

  for i = 1, #self.itemStats do
    data.initial[i] = self.itemStats[i].getter ()
    if i == self.STATS.SPIRIT then
      data.initial[i] = data.initial[i] / self.spiritBonus
    end
    for j = 1, #data.method.items do
      data.initial[i] = data.initial[i] - data.method.items[j].stats[i]
    end
  end
  local reforgedSpirit = 0
  for i = 1, #data.method.items do
    local reforge = self.itemData[i].reforge
    if reforge then
      local src, dst = unpack(self.reforgeTable[reforge])
      local amount = floor (method.items[i].stats[src] * REFORGE_COEFF)
      data.initial[src] = data.initial[src] + amount
      data.initial[dst] = data.initial[dst] - amount
      if src == self.STATS.SPIRIT then
        reforgedSpirit = reforgedSpirit - amount
      elseif dst == self.STATS.SPIRIT then
        reforgedSpirit = reforgedSpirit + amount
      end
    end
  end
  if self.s2hFactor > 0 then
    data.initial[self.STATS.HIT] = data.initial[self.STATS.HIT] - Round(reforgedSpirit * self.spiritBonus * self.s2hFactor / 100)
  end

  for _,v in ipairs(data.caps) do
    if v.stat > 0 then
      v.init = data.initial[v.stat]
      for i = 1, #data.method.items do
        v.init = v.init + data.method.items[i].stats[v.stat]
      end
    end
  end
  if self.s2hFactor > 0 then
    if data.weights[self.STATS.SPIRIT] == 0 and (data.caps[1].stat == self.STATS.HIT or data.caps[2].stat == self.STATS.HIT) then
      data.weights[self.STATS.SPIRIT] = 1
    end
  end

  return data
end
local maxLoops
function ReforgeLite:RunYieldCheck()
  if (self.__chooseLoops or 0) >= maxLoops then
    self.__chooseLoops = nil
    coroutine.yield()
  else
    self.__chooseLoops = (self.__chooseLoops or 0) + 1
  end
end

function ReforgeLite:ChooseReforgeClassic (data, reforgeOptions, scores, codes)
  local bestCode = {nil, nil, nil, nil}
  local bestScore = {0, 0, 0, 0}
  for k, score in pairs (scores) do
    self:RunYieldCheck()
    local s1 = data.caps[1].init
    local s2 = data.caps[2].init
    local code = codes[k]
    for i = 1, #code do
      local b = code:byte (i)
      s1 = s1 + reforgeOptions[i][b].d1
      s2 = s2 + reforgeOptions[i][b].d2
    end
    local a1, a2 = true, true
    if data.caps[1].stat > 0 then
      a1 = a1 and self:CapAllows (data.caps[1], s1)
      score = score + self:GetCapScore (data.caps[1], s1)
    end
    if data.caps[2].stat > 0 then
      a2 = a2 and self:CapAllows (data.caps[2], s2)
      score = score + self:GetCapScore (data.caps[2], s2)
    end
    local allow = a1 and (a2 and 1 or 2) or (a2 and 3 or 4)
    if bestCode[allow] == nil or score > bestScore[allow] then
      bestCode[allow] = code
      bestScore[allow] = score
    end
  end
  return bestCode[1] or bestCode[2] or bestCode[3] or bestCode[4]
end

----------------------------------- SPIRIT-TO-HIT REFORGE ------------------------------

function ReforgeLite:GetItemReforgeOptionsS2H (item, data, slot)
  if self:IsItemLocked (slot) then
    local srcstat, dststat, delta1, delta2, dscore = nil, nil, 0, 0, 0
    local reforge = self.itemData[slot].reforge
    if reforge then
      srcstat, dststat = unpack(self.reforgeTable[reforge])
      local amount = floor (item.stats[srcstat] * REFORGE_COEFF)
      if srcstat == self.STATS.HIT then
        delta1 = delta1 - amount
      elseif srcstat == self.STATS.SPIRIT then
        delta2 = delta2 - amount
      else
        dscore = dscore - data.weights[srcstat] * amount
      end
      if dststat == self.STATS.HIT then
        delta1 = delta1 + amount
      elseif dststat == self.STATS.SPIRIT then
        delta2 = delta2 + amount
      else
        dscore = dscore + data.weights[dststat] * amount
      end
    end
    return {{src = srcstat, dst = dststat, d1 = delta1, d2 = delta2, score = dscore}}
  end
  local opt = {}
  local best = nil
  for i = 1, #self.itemStats do
    if item.stats[i] == 0 and i ~= self.STATS.HIT and i ~= self.STATS.SPIRIT and (best == nil or data.weights[i] > data.weights[best]) then
      best = i
    end
  end
  if best then
    local worst = nil
    local worstScore = 0
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 and i ~= self.STATS.HIT and i ~= self.STATS.SPIRIT then
        local score = (data.weights[best] - data.weights[i]) * floor (item.stats[i] * REFORGE_COEFF)
        if score > worstScore then
          worstScore = score
          worst = i
        end
      end
    end
    if worst then
      tinsert (opt, {src = worst, dst = best, d1 = 0, d2 = 0, score = worstScore})
    else
      tinsert (opt, {d1 = 0, d2 = 0, score = 0})
    end
  else
    tinsert (opt, {d1 = 0, d2 = 0, score = 0})
  end
  if item.stats[self.STATS.HIT] == 0 then
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 then
        local amount = floor (item.stats[i] * REFORGE_COEFF)
        tinsert (opt, {src = i, dst = self.STATS.HIT, d1 = amount, d2 = (i == self.STATS.SPIRIT and -amount or 0),
          score = -amount * (i == self.STATS.SPIRIT and 0 or data.weights[i])})
      end
    end
  elseif best then
    local amount = floor (item.stats[self.STATS.HIT] * REFORGE_COEFF)
    tinsert (opt, {src = self.STATS.HIT, dst = best, d1 = -amount, d2 = 0, score = data.weights[best] * amount})
  end
  if item.stats[self.STATS.SPIRIT] == 0 then
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 then
        local amount = floor (item.stats[i] * REFORGE_COEFF)
        tinsert (opt, {src = i, dst = self.STATS.SPIRIT, d1 = (i == self.STATS.HIT and -amount or 0), d2 = amount,
          score = -amount * (i == self.STATS.HIT and 0 or data.weights[i])})
      end
    end
  elseif best then
    local amount = floor (item.stats[self.STATS.SPIRIT] * REFORGE_COEFF)
    tinsert (opt, {src = self.STATS.SPIRIT, dst = best, d1 = 0, d2 = -amount, score = data.weights[best] * amount})
  end
  return opt
end
function ReforgeLite:InitReforgeS2H ()
  local method = { items = {} }
  for i = 1, #self.itemData do
    method.items[i] = {}
    method.items[i].stats = {}
    local item = self.itemData[i].item
    local stats = (item and GetItemStats (item) or {})
    for j = 1, #self.itemStats do
      method.items[i].stats[j] = (stats[self.itemStats[j].name] or 0)
    end
  end

  local usecap = 1
  if self.pdb.caps[1].stat == 0 then
    usecap = 2
  end
  local data = {}
  data.method = method
  data.weights = DeepCopy (self.pdb.weights)
  if data.weights[self.STATS.SPIRIT] == 0 then
    data.weights[self.STATS.SPIRIT] = 1
  end
  data.cap = {stat = self.STATS.HIT, points = DeepCopy (self.pdb.caps[usecap].points), init = 0}
  data.initial = {}
  for i = 1, #self.itemStats do
    data.initial[i] = self.itemStats[i].getter ()
    if i == self.STATS.SPIRIT then
      data.initial[i] = data.initial[i] / self.spiritBonus
    end
    for j = 1, #data.method.items do
      data.initial[i] = data.initial[i] - data.method.items[j].stats[i]
    end
  end
  for i = 1, #data.method.items do
    local reforge = self.itemData[i].reforge
    if reforge then
      local src, dst = unpack(self.reforgeTable[reforge])
      local amount = floor (method.items[i].stats[src] * REFORGE_COEFF)
      data.initial[src] = data.initial[src] + amount
      data.initial[dst] = data.initial[dst] - amount
    end
  end
  data.initial[self.STATS.HIT] = data.initial[self.STATS.HIT] - Round(self.itemStats[self.STATS.SPIRIT].getter () * self.s2hFactor / 100)
  data.cap.init = data.initial[self.STATS.HIT]
  data.spi = Round(data.initial[self.STATS.SPIRIT])
  for i = 1, #data.method.items do
    data.cap.init = data.cap.init + data.method.items[i].stats[self.STATS.HIT]
    data.spi = data.spi + data.method.items[i].stats[self.STATS.SPIRIT]
  end
  data.initial[self.STATS.SPIRIT] = Round(data.initial[self.STATS.SPIRIT] * self.spiritBonus)

  data.caps = {{stat = self.STATS.HIT, init = data.cap.init}, {stat = self.STATS.SPIRIT, init = data.spi}}

  return data
end

function ReforgeLite:ChooseReforgeS2H (data, reforgeOptions, scores, codes)
  local bestCode = {nil, nil}
  local bestScore = {0, 0}
  for k, score in pairs (scores) do
    self:RunYieldCheck()
    local code = codes[k]
    local hit = data.cap.init
    local spi = data.spi
    for i = 1, #code do
      local b = code:byte (i)
      hit = hit + reforgeOptions[i][b].d1
      spi = spi + reforgeOptions[i][b].d2
    end
    spi = Round(spi * self.spiritBonus)
    hit = hit + Round(spi * self.s2hFactor / 100)
    local allow = self:CapAllows (data.cap, hit) and 1 or 2
    score = score + self:GetCapScore (data.cap, hit) + data.weights[self.STATS.SPIRIT] * spi
    if bestCode[allow] == nil or score > bestScore[allow] then
      bestCode[allow] = code
      bestScore[allow] = score
    end
  end
  return bestCode[1] or bestCode[2]
end

function ReforgeLite:ComputeReforgeCore (data, reforgeOptions)
  local TABLE_SIZE = 10000
  local scores, codes = {}, {}
  local linit = floor (data.caps[1].init + random ()) + floor (data.caps[2].init + random ()) * TABLE_SIZE
  scores[linit] = 0
  codes[linit] = ""
  for i = 1, #self.itemData do
    local newscores, newcodes = {}, {}
    local opt = reforgeOptions[i]
    local count = 0
    for k, score in pairs (scores) do
      self:RunYieldCheck()
      local code = codes[k]
      local s1 = k % TABLE_SIZE
      local s2 = floor (k / TABLE_SIZE)
      for j = 1, #opt do
        local o = opt[j]
        local nscore = score + o.score
        local nk = s1 + floor (o.d1 + random ()) + (s2 + floor (o.d2 + random ())) * TABLE_SIZE
        if newscores[nk] == nil or nscore > newscores[nk] then
          if newscores[nk] == nil then
            count = count + 1
          end
          newscores[nk] = nscore
          newcodes[nk] = code .. strchar (j)
        end
      end
    end
    scores, codes = newscores, newcodes
  end
  return scores, codes
end

function ReforgeLite:ComputeReforge (initFunc, optionFunc, chooseFunc)
  local data = self[initFunc] (self)
  local reforgeOptions = {}
  for i = 1, #self.itemData do
    reforgeOptions[i] = self[optionFunc] (self, data.method.items[i], data, i)
  end

  self.__chooseLoops = nil
  maxLoops = self.db.speed

  local scores, codes = self:ComputeReforgeCore(data, reforgeOptions)

  local code = self[chooseFunc] (self, data, reforgeOptions, scores, codes)
  scores, codes = nil, nil
  collectgarbage ("collect")
  for i = 1, #data.method.items do
    local opt = reforgeOptions[i][code:byte (i)]
    if self.s2hFactor == 100 then
      if opt.dst == self.STATS.HIT and data.method.items[i].stats[self.STATS.SPIRIT] == 0 then
        opt.dst = self.STATS.SPIRIT
      end
    end
    data.method.items[i].src = opt.src
    data.method.items[i].dst = opt.dst
  end
  self.methodDebug = { data = DeepCopy(data) }
  self:FinalizeReforge (data)
  self.methodDebug.method = DeepCopy(data.method)
  if data.method then
    self.pdb.method = data.method
    self:UpdateMethodCategory ()
  end
end

function ReforgeLite:Compute ()
  if self.s2hFactor > 0 and ((self.pdb.caps[1].stat == self.STATS.HIT and self.pdb.caps[2].stat == 0) or
                             (self.pdb.caps[2].stat == self.STATS.HIT and self.pdb.caps[1].stat == 0)) then
    self:ComputeReforge ("InitReforgeS2H", "GetItemReforgeOptionsS2H", "ChooseReforgeS2H")
  else
    self:ComputeReforge ("InitReforgeClassic", "GetItemReforgeOptions", "ChooseReforgeClassic")
  end
end

function ReforgeLite:StartCompute(btn)
  local function endProcess()
    btn:RenderText(L["Compute"])
    addonTable.GUI:Unlock()
  end
  local co = coroutine.create( function() self:Compute() end )
  coroutine.resume(co)
  local normalStatus = { suspended = true, running = true }
  if not normalStatus[coroutine.status(co)] then
    endProcess()
  else
    C_Timer.NewTicker(0, function(timer)
      coroutine.resume(co)
      if not normalStatus[coroutine.status(co)] then
        timer:Cancel()
        endProcess()
      end
    end)
  end
end
