return function()
  local src="group"
  Extensions.Register(src,1,1,"Group")
  Extensions.Require(src,"type",1,0)
  Extensions.Require(src,"function",1,0)

  local function getExcept(x) local t=type(x) if t=="nothing" then return nil elseif t:sub(1,4)=="just" then return x:GetValue() else return x or nil end
  end

  local function GetMaybe() 
    local M=require "lib.maybe"
    return M
  end

  function Group.Fold(g,f,base,...)
    local args=table.pack(...)
    if g:IsEmpty() then return base end
    local result=base
    g:ForEach(function (tc)
      result=f(result,tc,args)
    end)
    return result
  end

  function Group.Map(g,f,...)
    local result={}
    local args=table.pack(...)
    g:ForEach(function (tc)
      table.insert(result,f(tc,args))
    end)
  return result
  end

  function Group.MapGroup(g,f,...)
    local args=table.pack(...)
    local result=Group.CreateGroup()
    g:ForEach(function (tc)
      result:AddCards(f(tc,args))
    end)
    return result
  end
  Group.MapG=Group.MapGroup

  function Group.All(g,f,...)
    return g:IsExists(f,g:GetCount(),nil,...)
  end

  function Group.AllOf(g,filter,check,...)
    local g2=nil
    if type(filter)=="table" then
      local f=function(c,fl,...)
        return fl(c,...)
      end
      g2=g:Filter(f,nil,table.unpack(filter))
    else
      g2=g:Filter(filter,nil)
    end
    return g2:All(check,...)
  end

  function Group.AllWith(g,f,c,...)
    local t=g:Map(f)
    for _,v in pairs(t) do
      if not c(v,...) then return false end
    end
    return true
  end

  function Group.Any(g,f,...)
    return g:IsExists(f,1,nil,...)
  end

  function Group.AnyOf(g,filter,check,...)
    local g2=nil
    if type(filter)=="table" then
      local f=function(c,fl,...)
        return fl(c,...)
      end
      g2=g:Filter(f,nil,table.unpack(filter))
    else
      g2=g:Filter(filter,nil)
    end
    return g2:Any(check,...)
  end

  function Group.AnyWith(g,f,c,...)
    local t=g:Map(f)
    for _,v in pairs(t) do
      if c(v,...) then return true end
    end
    return false
  end

  function Group.Partition(g,f,...)
    local include=Group.CreateGroup()
    local exclude=Group.CreateGroup()
    local args=table.pack(...)

    g:ForEach(function (tc)
      if f(tc,table.unpack(args)) then
        include:AddCard(tc)
      else
        exclude:AddCard(tc)
      end
    end)
    return include,exclude
  end

  local function ceq(c1,c2)
    return c1==c2
  end

  function Group.IntersectBy(g1,g2,f)
    return g1:Filter(function (tc)
      return g2:FilterCount(function (cc)
        return f(tc,cc)
      end,nil)>0
    end,nil)
  end

  local fe=Group.ForEach
  function Group.ForEach(g,f,...)
    local args=table.pack(...)
    fe(g,function (tc)
      f(tc,table.unpack(args))
    end)
  end
  Group.Sequence=Group.ForEach

  function Group.ForEachWith(g,t,f,...)
    local args=table.pack(...)
    g:ForEach(function (tc)
      f(t(tc),table.unpack(args))
    end)
  end

  function Group.Intersect(g1,g2)
    g1:IntersectBy(g2,ceq)
  end

  local function diff_check(f,g1,g2)
    return g1:Filter(function (c)
      return g2:FilterCount(function (d)
        return f(c,d)
      end,nil)==0
    end)
  end

  function Group.DifferenceByM(g1,g2,f)
    local func=function (g01,g02) return diff_check(f,g01,g02) end
    local r1=func(g1,g2)
    local r2=func(g2,g1)
    return r1,r2
  end

  function Group.DifferenceBy(g1,g2,f)
    local r1,r2=g1:DifferenceByM(g2,f)
    return r1:Merge(r2)
  end

  function Group.Difference(g1,g2)
    return g1:DifferenceBy(g2,ceq)
  end

  function Group.DifferenceM(g1,g2)
    return g1:DifferenceByM(g2,ceq)
  end

  local ac=Group.AddCard
  function Group.AddCard(g,...)
    local args=table.pack(...)
    for n=1,args.n do
      if args[n] then ac(g,args[n]) end
      n=n+1
    end
  end
  Group.AddCards=Group.AddCard

  function Group.InsertCard(g,...)
    local ng=g:Clone()
    return ng:AddCard(...)
  end

  local rc=Group.RemoveCard
  function Group.RemoveCard(g,...)
    local args=table.pack(...)
    for n=1,args.n do
      local x=args[n]
      if type(x)=="card" then
        rc(g,x)
      elseif type(x)=="group" then
        x:ForEach(Curry(Group.RemoveCard,g))
      elseif type(x)=="number" then
        g:RemoveIf(CardCurry(Card.IsCode,x))
      elseif type(x)=="function" then
        g:RemoveIf(x)
      elseif type(x)=="table" then
        for _,v in ipairs(x) do
          g:RemoveCard(v)
        end
      end
    end
  end

  function Group.DropCard(g,...)
    local ng=g:Clone()
    return ng:RemoveCard(...)
  end

  function Group.RemoveIf(g,f,...)
    local r=g:Filter(f,nil,...)
    g:RemoveCard(r)
  end

  function Group.RemoveUnless(g,f,...)
    g:RemoveIf(Negate(f),...)
  end

  function Group.DropIf(g,...)
    return g:Clone():RemoveIf(...)
  end

  function Group.DropUnless(g,...)
    return g:Clone():RemoveUnless(...)
  end

  function Group.AsTable(g)
    return g:Map(function (c) return c end)
  end

  function Group.CreateFromTable(t)
    local g=Group.CreateGroup()
    for _,v in pairs(t) do
      g:AddCard(v)
    end
    return g
  end
  Group.FromTable=Group.CreateFromTable

  function Group.ConfirmCards(tg,tp)
    Duel.ConfirmCards(tp,tg)
  end

  function Group.Sort(g,f)
    local t=g:AsTable()
    local n=Group.CreateGroup()
    table.sort(t,f)
    for _,v in pairs(t) do
      n:AddCard(v)
    end
    return n
  end

  function Group.Take(g,n)
    local c=g:GetFirst()
    local r=Group.CreateGroup()
    local a=0
    while a<n do
      r:AddCard(c)
      c=g:GetNext()
      a=a+1
    end
    return r
  end

  function Group.GetFirstMatch(g,f,...)
    local tc=g:GetFIrst()
    local r=nil
    while((not r) and (tc)) do
      r=f(tc,...) and tc
      tc=g:GetNext()
    end
    return r
  end

  function Group.MaybeGetFirstMatch(g,f,...)
    local b,M=pcall(GetMaybe)
    if not b then error("Group.MaybeGetFirstMatch, could not load lib/maybe.lua",2) end
    local r=g:GetFirstMatch(f,...)
    return r and M.Just(r) or M.Nothing()
  end

  function Group.MaybeGetFirst(g)
    local b,M=pcall(GetMaybe)
    if not b then error("Group.MaybeGetFirstMatch, could not load lib/maybe.lua",2) end
    local tc=g:GetFirst()
    return tc and M.Just(tc) or M.Nothing()
  end

  function Group.MaybeGetNext(g)
    local b,M=pcall(GetMaybe)
    if not b then error("Group.MaybeGetFirstMatch, could not load lib/maybe.lua",2) end
    local tc=g:GetNext()
    return tc and M.Just(tc) or M.Nothing()
  end

  function Group.Destroy(g,r,d)
    r=r or REASON_EFFECT
    return Duel.Destroy(g,r,d)
  end

  function Group.Banish(g,p,r)
    r=r or REASON_EFFECT
    p=p or POS_FACEUP
    return Duel.Remove(g,p,r)
  end

  function Group.BanishAsCost(g,p,r)
    r=(r or 0)+REASON_COST
    return g:Banish(p,r)
  end

  function Group.SendtoGrave(target,reason)
    reason=reason or REASON_EFFECT
    return Duel.SendtoGrave(target,reason)
  end

  function Group.SendtoGraveAsCost(target,reason)
    reason=(reason or 0)+REASON_COST
    target:SendtoGrave(reason)
  end

  function Group.Discard(target,reason)
    reason=reason or REASON_EFFECT
    return target:SendtoGrave(reason+REASON_DISCARD)
  end

  function Group.DiscardAsCost(target,reason)
    reason=(reason or 0)+REASON_DISCARD
    return target:SendtoGraveAsCost(reason)
  end

  function Group.SendtoHand(target,player,reason)
    reason=reason or REASON_EFFECT
    return Duel.SendtoHand(target,player,reason)
  end

  function Group.SendtoHandAsCost(target,player,reason)
    reason=(reason or 0)+REASON_COST
    target:SendtoHand(player,reason)
  end

  function Group.SendtoDeck(target,player,seq,reason)
    seq=seq or 0
    reason=reason or REASON_EFFECT
    return Duel.SendtoDeck(target,player,seq,reason)
  end

  function Group.SendtoDeckAsCost(target,player,seq,reason)
    reason=(reason or 0)+REASON_COST
    return target:SendtoDeck(player,seq,reason)
  end

  function Group.ShuffletoDeck(target,player,reason)
    reason=reason or REASON_EFFECT
    return target:SendtoDeck(player,2,reason)
  end

  function Group.ShuffletoDeckAsCost(target,player,reason)
    reason=(reason or 0)+REASON_COST
    return target:ShuffletoDeck(target,player,reason)
  end

  function Group.Release(g,r)
    r=r or REASON_COST
    return Duel.Release(g,r)
  end

  function Group.SpecialSummon(target,sumtype,sumplayer,target_player,nocheck,nolimit,pos)
    sumtype=sumtype or 0
    nocheck=nocheck or false
    nolimit=nolimit or false
    pos=pos or POS_FACEUP
    local f = function (tc)
      local p=sumplayer or tc:GetControler()
      local tp=target_player or p
      return Duel.SpecialSummon(tc,sumtype,p,tp,nocheck,nolimit,pos)
    end
    local tc=target:GetFirst()
    local n=0
    while (tc) do
      n=n+Duel.SpecialSummon(tc,sumtype,sumplayer,target_player,nocheck,nolimit,pos)
      tc=target:GetNext()
    end
    return n
  end

  function Group.IsEmpty(g)
    return g:GetCount()==0
  end

  function Group.HasCard(g)
    return not g:IsEmpty()
  end

  function Group.HasCount(g,count)
    return g:GetCount()>=count
  end

  function Group.IsUnderCount(g,count)
    return not g:HasCount(count)
  end

  local m=Group.Merge
  function Group.Merge(g,...)
    local r=nil
    local args=table.pack(...)
    for n=1,args.n do
      local d=args[n]
      if type(d)=="card" then
        r=m(g,Group.FromCards(d))
      elseif type(d)=="effect" then
        r=m(g,Group.FromCards(d:GetHandler()))
      elseif type(d)=="function" then
        local x=Duel.GetMatchingGroup(d,tp,0xFF,0xFF,nil)
        r=m(g,x)
      elseif type(d)=="just card" then
        local x=d:WithValueOrDefault(Group.CreateGroup,Group.CreateGroup())
        r=m(g,x)
      else
        r=m(g,d)
      end
    end
    return r
  end

  function Group.MergeIf(g1,g2,f,...)
    local filter=CC(f,...)
    g2:ForFilter(f,Group.AddCard,g1)
  end

  function Group.ForFilter(g,f,a,...)
    g:ForEach(function (tc,...)
      if f(tc,...) then a(tc) end
    end,...)
  end

  function Group.MaxBy(g,f,...)
    return g:Fold(function (acc,tc,...) return f(tc,...)>f(acc,...) and tc or acc end,g:GetFirst(),...)
  end

  function Group.MinBy(g,f,...)
    return g:Fold(function (acc,tc,...) return f(tc,...)<f(acc,...) and tc or acc end,g:GetFirst(),...)
  end

  function Group.SumBy(g,f,b,...)
    b=b or 0
    return g:Fold(function (acc,tc,...) return acc+f(tc,...) end,b,...)
  end

  function Group.MaybeMaxBy(g,f,...)
    local b,M=pcall(GetMaybe)
    if not b then error("Group.MaybeGetFirstMatch, could not load lib/maybe.lua",2) end
    return g:Fold(function (acc,tc,...)
      if not acc:HasValue() then return M.Just(tc) end
      return f(tc,...)>f(acc:GetValue(),...) and M.Just(tc) or acc
    end,M.Nothing(),...)
  end

  function Group.MaybeMinBy(g,f,...)
    local b,M=pcall(GetMaybe)
    if not b then error("Group.MaybeGetFirstMatch, could not load lib/maybe.lua",2) end
    return g:Fold(function (acc,tc,...)
      if not acc:HasValue() then return M.Just(tc) end
      return f(tc,...)<f(acc:GetValue(),...) and M.Just(tc) or acc
    end,M.Nothing(),...)
  end

  function Group.FoldWith(g,af,vf,b)
    return g:Fold(function (acc,x) return af(acc,vf(x)) end,b)
  end

  local gc=Group.GetCount
  function Group.GetCount(g,arg1,...)
    if type(arg1)=="number" then
      return gc(g)*arg1
    elseif type(arg1)=="function" then
      return arg1(gc(g),...)
    else
      return gc(g,arg1,...)
    end
  end

  function Group.NubWith(g,f,...)
    local r=Group.CreateGroup()
    local args={...}
    g:ForEach(function (tc)
      if not r:Any(function (c) return f(tc,c,table.unpack(args)) end) then
        r:AddCard(tc)
      end
    end)
    return r
  end

  function Group.NubBy(g,f,...)
    local chk=function (tc,ex,...) return f(tc,...)==f(ex,...) end
    return g:NubWith(chk,...)
  end

  function Group.Nub(g)
    return g:NubBy(Card.GetCode)
  end

  function Group.HasClassCount(g,f,n,...)
    return g:GetClassCount(f,...)>=n
  end

  function Group.IsUnderClassCount(g,f,n,...)
    return not g:HasClassCount(f,n,...)
  end

  function Group.Join(g,...)
    local r=Group.CreateGroup()
    r:Merge(g,...)
    return r
  end
  
  local fs=Group.FilterSelect
  function Group.FilterSelect(g,p,f,min,max,x,...)
    min=min or 1
    max=max or 1
    x=getExcept(x)
    return fs(g,p,f,min,max,x,...)
  end

  function Group.WithFilterSelection(g,f,p,fil,min,max,x,...)
    local tg=g:FilterSelect(p,fil,min,max,x,...)
    local bool,res=pcall(f,tg)
    if not bool then error(res,2) end
    --return f(tg)
    return res
  end

  local s=Group.Select
  function Group.Select(g,p,min,max,ex)
    min=min or 1
    max=max or 1
    ex=getExcept(ex)
    return s(g,p,min,max,ex)
  end

  function Group.WithSelection(g,f,p,min,max,ex)
    local tg=g:FilterSelect(p,min,max,ex)
    return f(tg)
  end
  
  function Group.FilterSetCode(g,sc)
    local fg=g:Filter(Card.IsSetCard,nil,sc)
    return fg
  end

  function Group.WithGroup(g,f,...)
    if g:HasCard() then
      return f(g,...)
    end
  end
end
