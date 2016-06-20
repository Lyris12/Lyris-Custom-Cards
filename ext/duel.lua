return function ()
  local src="duel"
  Extensions.Register(src,1,1,"Duel")
  Extensions.Require(src,"group",1,0)
  Extensions.Require(src,"type",1,0)

  local smc=Duel.SelectMatchingCard
  local function getExcept(x) local t=type(x) if t=="nothing" then return nil elseif t:sub(1,4)=="just" then return x:GetValue() else return x or nil end end
  function Duel.SelectMatchingCard(stp,f,tp,s,o,min,max,ex,...)
    if tp==nil then o=o or s
      else o=o or 0 end
    tp=tp or 0
    min=min or 1
    max=max or 1
    ex=getExcept(ex)
    return smc(stp,f,tp,s,o,min,max,ex,...)
  end

  function Duel.SelectSingleCard(stp,f,tp,s,o,ex,...)
    return Duel.SelectMatchingCard(stp,f,tp,s,o,1,1,ex,...):GetFirst()
  end

  function Duel.MaybeSelectSingleCard(...)
    local M=require "lib.maybe"
    local tc=Duel.SelectSingleCard(...)
    return tc and M.Just(tc) or M.Nothing()
  end

  local smt=Duel.SelectTarget
  function Duel.SelectTarget(sp,f,p,s,o,min,max,x,...)
    if p==nil then o=o or s
      else o=o or 0 end
    p=p or 0
    min=min or 1
    max=max or 1
    ex=getExcept(ex)
    return smt(sp,f,p,s,o,min,max,x,...)
  end

  function Duel.SelectSingleTarget(sp,f,p,s,o,x,...)
    return Duel.SelectTarget(sp,f,p,s,o,1,1,x,...):GetFirst()
  end

  function Duel.MaybeSelectSingleTarget(...)
    local M=require "lib.maybe"
    local tc=Duel.SelectSingleTarget(...)
    return tc and M.Just(tc) or M.Nothing()
  end

  function Duel.WithSelectedCard(op,stp,f,tp,s,o,min,max,ex,...)
    local g=Duel.SelectMatchingCard(stp,f,tp,s,o,min,max,ex,...)
    if g:HasCard() then
      return op(g)
    else
      return nil
    end
  end

  function Duel.MaybeSelectMatchingCard(...)
    local M=require "lib.maybe"
    local g=Duel.SelectMatchingCard(...)
    return g and g:HasCard() and M.Just(g) or M.Nothing()
  end

  function Duel.MaybeWithSelectedCard(op,stp,f,tp,s,o,min,max,ex,...)
    local M=require "lib.maybe"
    local g=Duel.SelectMatchingCard(stp,f,tp,s,o,min,max,ex,...)
    if g:HasCard() then
      return M.Just(op(g))
    else
      return M.Nothing()
    end
  end

  local dmg=Duel.Damage
  function Duel.Damage(p,v,r)
    r=r or REASON_EFFECT
    return dmg(p,v,r)
  end

  local dd=Duel.DiscardDeck
  function Duel.DiscardDeck(p,v,r)
    local r=r or REASON_EFFECT
    return dd(p,v,r)
  end

  local glc=Duel.GetLocationCount
  function Duel.GetLocationCount(tp,l,...)
    l=l or LOCATION_MZONE
    return glc(tp,l,...)
  end

  function Duel.ZoneCheck(tp,loc,count)
    loc=loc or LOCATION_MZONE
    count=count or 1
    return Duel.GetLocationCount(tp,loc)>=count
  end

  local gmg=Duel.GetMatchingGroup
  function Duel.GetMatchingGroup(f,p,s,o,e,...)
    if p==nil then o=o or s
      else o=o or 0 end
    p=p or 0
    e=getExcept(e)
    return gmg(f,p,s,o,e,...)
  end

  function Duel.WithMatchingGroup(op,f,p,s,o,e,...)
    local g=Duel.GetMatchingGroup(f,p,s,o,e,...)
    return op(g)
  end

  local iemc=Duel.IsExistingMatchingCard
  function Duel.IsExistingMatchingCard(f,p,s,o,c,e,...)
    if p==nil then o=o or s
      else o=o or 0 end
    c=c or 1
    e=getExcept(e)
    return iemc(f,p,s,o,c,e,...)
  end

  local iet=Duel.IsExistingTarget
  function Duel.IsExistingTarget(f,p,s,o,c,x,...)
    s=s or LOCATION_ONFIELD
    o=o or (p and 0 or s)
    p=p or 0
    c=c or 1
    x=getExcept(x)
    return iet(f,p,s,o,c,x,...)
  end

  function Duel.PlayerFilterCheck(filter,tp,location,ex,...)
    location=location or LOCATION_ONFIELD
    local loc=tp and 0 or location
    tp=tp or 0
    return Duel.IsExistingMatchingCard(filter,tp,location,loc,1,ex,...)
  end

  function Duel.PlayerFilterTargetCheck(filter,tp,location,ex,...)
    location=location or LOCATION_ONFIELD
    local loc=tp and 0 or location
    tp=tp or 0
    local hasTarget=Duel.IsExistingTarget(filter,tp,location,loc,1,ex,...)
    return hasTarget
  end

  function Duel.GetAttackCards()
    return Duel.GetAttacker(), Duel.GetAttackTarget()
  end

  function Duel.GetAttackGroup()
    local g=Group.CreateGroup()
    g:AddCards(Duel.GetAttackCards())
    return g
  end

  local function retcon(p)
    return function(e,tp,eg,ep,ev,re,r,rp)
      local check1=p and p==Duel.GetTurnPlayer()
      local check2=not p
      return check1 or check2
    end
  end

  local function retop(rpos,id)
    return function(e,tp,eg,ep,ev,re,r,rp)
      local t=e:GetLabel()
      if t>0 then
        e:SetLabel(t-1)
      else
        local c=e:GetLabelObject()
        if c:GetFlagEffect(id)~=0 then
          Duel.ReturnToField(c,rpos)
        end
        c:ResetFlagEffect(id)
      end
    end
  end

  function Duel.TempRemove(e,c,pos,r,id,tp,ph,tc,rpos)
    if not type(c)=="card" then error("TempRemove second argument is not \"card\".",2) end
    r=r or REASON_EFFECT
    ph=ph or PHASE_END
    tc=tc or 1
    local rp=0
    if tp then
      rp=tp==e:GetHandlerPlayer() and RESET_SELF_TURN or RESET_OPPO_TURN
    end
    rpos=rpos or c:GetPosition()
    local rt=Duel.Remove(c,pos or c:GetPosition(),r+REASON_TEMPORARY)
    if rt~=0 then
      c:RegisterFlagEffect(id,RESET_EVENT+RESET_TOGRAVE+RESET_TOHAND+RESET_TODECK+RESET_TOFIELD+RESET_OVERLAY,0,1)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetCode(EVENT_PHASE+ph)
      e1:SetReset(RESET_PHASE+ph+rp,tc)
      e1:SetCountLimit(1)
      e1:SetLabel(tc-1)
      e1:SetLabelObject(c)
      e1:SetCondition(retcon(tp))
      e1:SetOperation(retop(rpos,id))
      Duel.RegisterEffect(e1,e:GetHandlerPlayer())
    end
    return rt>0
  end

  local function makeTargetFunc(f)
    return function(...)
      local M=require "lib.maybe"
      local t,h=f(...)
      return h and M.Just(t) or M.Nothing()
    end
  end

  function Duel.GetUncheckedTargets(e)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg then return Group.CreateGroup(),false end
    tg=tg:Filter(Card.IsRelateToEffect,nil,e)
    return tg, tg:HasCard()
  end

  function Duel.GetCheckedTargets(e,f,...)
    local tg,ht=Duel.GetUncheckedTargets(e)
    if not ht then return tg,ht end
    tg:RemoveUnless(f,...)
    return tg,tg:HasCard()
  end

  function Duel.SingleCheckedTarget(e,func,...)
    local g,c=Duel.GetCheckedTargets(e,func,...)
    local r=g:HasCard()
    g=g:GetFirst() or nil
    return g,r
  end
  
  function Duel.SingleUncheckedTarget(e)
    local g,c=Duel.GetUncheckedTargets(e)
    local r=g:HasCard()
    local g=g:GetFirst() or nil
    return g,r
  end
  
  Duel.MaybeUncheckedTarget=makeTargetFunc(Duel.SingleUncheckedTarget)
  Duel.MaybeCheckedTarget=makeTargetFunc(Duel.SingleCheckedTarget)

  function Duel.BitCheck(b,c,f)
    f=f or bit.band
    return f(b,c)==c
  end
  
  local dr=Duel.Draw
  function Duel.Draw(p,c,r)
    c=c or 1
    r=r or REASON_EFFECT
    return dr(p,c,r)
  end
end
