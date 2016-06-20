return function ()
  local src="card"
  Extensions.Register(src,1,1,"card")
  Extensions.Require(src,"type",1,0)
  Extensions.Require(src,"function",1,0)
  Extensions.Require(src,"math",1,0)
  function Card.Destroy(g,r,d)
    r=r or REASON_EFFECT
    return Duel.Destroy(g,r,d)
  end

  function Card.Banish(g,p,r)
    r=r or REASON_EFFECT
    p=p or POS_FACEUP
    return Duel.Remove(g,p,r)
  end

  function Card.BanishAsCost(g,p,r)
    r=(r or 0)+REASON_COST
    return g:Banish(p,r)
  end

  function Card.IsNotImmuneToEffect(c,e)
    return not c:IsImmuneToEffect(e)
  end

  function Card.SendtoGrave(target,reason)
    reason=reason or REASON_EFFECT
    return Duel.SendtoGrave(target,reason)
  end

  function Card.SendtoGraveAsCost(target,reason)
    reason=(reason or 0)+REASON_COST
    target:SendtoGrave(reason)
  end

  function Card.Discard(target,reason)
    reason=reason or REASON_EFFECT
    return target:SendtoGrave(reason+REASON_DISCARD)
  end

  function Card.DiscardAsCost(target,reason)
    reason=(reason or 0)+REASON_DISCARD
    return target:SendtoGraveAsCost(reason)
  end

  function Card.SendtoHand(target,player,reason)
    reason=reason or REASON_EFFECT
    return Duel.SendtoHand(target,player,reason)
  end

  function Card.SendtoHandAsCost(target,player,reason)
    reason=(reason or 0)+REASON_COST
    target:SendtoHand(player,reason)
  end

  function Card.SendtoDeck(target,player,seq,reason)
    seq=seq or 0
    reason=reason or REASON_EFFECT
    return Duel.SendtoDeck(target,player,seq,reason)
  end

  function Card.SendtoDeckAsCost(target,player,seq,reason)
    reason=(reason or 0)+REASON_COST
    return target:SendtoDeck(player,seq,reason)
  end

  function Card.ShuffletoDeck(target,player,reason)
    reason=reason or REASON_EFFECT
    return target:SendtoDeck(player,2,reason)
  end

  function Card.ShuffletoDeckAsCost(target,player,reason)
    reason=(reason or 0)+REASON_COST
    return target:ShuffletoDeck(target,player,reason)
  end

  function Card.Release(c,r)
    r=r or REASON_COST
    return Duel.Release(c,r)
  end

  function Card.SpecialSummon(target,sumtype,sumplayer,target_player,nocheck,nolimit,pos)
    target_player=target_player or sumplayer
    nocheck=nocheck or false
    nolimit=nolimit or false
    pos=pos or POS_FACEUP
    return Duel.SpecialSummon(target,sumtype,sumplayer,target_player,nocheck,nolimit,pos)
  end

  function Card.Overlay(c,tg)
    if type(tg)=="card" then
      tg=Group.FromCards(tg)
    end
    Duel.Overlay(c,tg)
  end
  Card.Attach=Card.Overlay

  local roc=Card.RemoveOverlayCard
  function Card.RemoveOverlayCard(c,p,min,max,r)
    p=p or c:GetControler()
    min=min or 1
    max=max or 1
    r=r or REASON_COST
    return roc(c,p,min,max,r)
  end
  Card.Detach=Card.RemoveOverlayCard

  local croc=Card.CheckRemoveOverlayCard
  function Card.CheckRemoveOverlayCard(c,tp,n,r)
    tp=tp or c:GetControler()
    n=n or 1
    r=r or REASON_COST
    return croc(c,tp,n,r)
  end

  function Card.HasSummonType(c,...)
    local t=0
    for _,v in pairs(...) do t=t+v end
    return bit.band(c:GetSummonType(),v)>0
  end

  function Card.IsAttack(c,atk)
    return c:GetAttack()==atk
  end

  function Card.IsDefence(c,def)
    return c:GetDefence()==def
  end

  function Card.IsLevel(c,level)
    local hasLevel=c:HasLevel()
    local isLevel=false
    if hasLevel then
      isLevel=c:GetLevel()==level
    end
    return isLevel,hasLevel
  end

  function Card.IsRank(c,rank)
    local hasRank=not c:HasLevel()
    local isRank=false
    if hasRank then
      isRank=c:GetRank()==rank
    end
    return isRank,hasRank
  end

  function Card.HasLevel(c)
    return c:IsLevelAbove(1) and c:IsNotStatus(STATUS_NO_LEVEL)
  end

  function Card.IsEqual(c1,c2)
    return c1==c2
  end

  function Card.ConfirmCards(c,tp)
    local tp=tp or 1-c:GetControler()
    return Duel.ConfirmCards(tp,Group.FromCards(c))
  end

  local uof=Card.SetUniqueOnField
  function Card.SetUniqueOnField(c,s,o,id)
    s=s or 1
    o=o or 0
    id=id or c:GetOriginalCode()
    return uof(c,s,o,id)
  end

  function Card.RegisterClone(c,e)
    c:RegisterEffect(e:Clone())
  end

  function Card.MoveToField(c,mp,tp,dest,pos,enabled)
    tp=tp or mp
    local t=c:IsType(TYPE_MONSTER)
    dest=dest or (t and LOCATION_MZONE or LOCATION_SZONE)
    pos=pos or (dest==LOCATION_MZONE and POS_FACEUP_ATTACK or POS_FACEUP)
    enabled=enabled==nil or enabled
    Duel.MoveToField(c,mp,tp,dest,pos,enabled)
  end

  function Card.IsMonster(c)
    return c:IsType(TYPE_MONSTER)
  end

  local ire=Card.IsRelateToEffect
  function Card.IsRelateToEffect(c,...)
    local args=table.pack(...)
    for n=1,args.n do
      if not ire(c,args[n]) then return false end
    end
    return true
  end

  function Card.IsNotRelateToEffect(c,...)
    return not c:IsRelateToEffect(...)
  end

  local ic=Card.IsCode
  function Card.IsCode(c,...)
    local args=table.pack(...)
    for n=1,args.n do
      if ic(c,args[n]) then return true end
    end
    return false
  end

  function Card.TargetFilterCheck(c,f,p,z,...)
    local hasFunction=(not f) or f(c,...)
    local hasControl=(not p) or c:IsControler(p)
    local isLocation=(not z) or c:IsLocation(z)
    
    return hasFunction and isLocation and hasControl
  end
  
  function Card.AddHandTrapActivation(c,con,cost)
    con=con or aux.TRUE
    local e=Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_SINGLE)
    e:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e:SetCondition(con)
    if cost then e:SetCost(cost) end
    c:RegisterEffect(e)
    return e
  end

  function Duel.GraveBanishCost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
      local canBanish=c:IsAbleToRemoveAsCost()
      return canBanish
    end
    c:BanishAsCost() end

  function Card.CreateGraveBanishEffect(c,pr,code,ty,n,id)
    ty=ty or EFFECT_TYPE_QUICK_O
    code=code or EVENT_FREE_CHAIN

    local e=Effect.CreateEffect(c,n,id)
    e:SetProperty(pr or 0)
    e:SetType(ty)
    e:SetCode(code)
    e:SetRange(LOCATION_GRAVE)
    e:SetCost(Duel.GraveBanishCost)
    return e
  end
  
  function Card.RegisterEffects(c,...)
    local args={...}
    for _,v in pairs(args) do
      if v then
        c:RegisterEffect(v)
      end
    end
  end

  function Card.IsSequence(c,seq)
    return c:GetSequence()==seq
  end

  function Card.ValueFunction(vf,ad,...)
    local args={...}
    return function(c)
      return ad(vf(c),table.unpack(args))
    end
  end

  function Card.AsGroup(c)
    return Group.FromCards(c)
  end

  local sm=Card.SetMaterial
  function Card.SetMaterial(c,g,...)
    if type(g)=="card" then
      g=g:AsGroup()
    end
    return sm(c,g,...)
  end

  function Card.AddLibProc(c,lib,n,...)
    local f=n and lib.proc[n] or lib.proc
    return f(c,...)
  end

  local function CreateStatFunction(get,cmp)
    return function(c,val)
      return cmp(get(c),val)
    end
  end

  local AtkFunc=Curry(CreateStatFunction,Card.GetBaseAttack)
  Card.IsBaseAttack=AtkFunc(math.equal)
  Card.IsBaseAttackAbove=AtkFunc(math.greater_eq)
  Card.IsBaseAttackBelow=AtkFunc(math.less_eq)

  local DefFunc=Curry(CreateStatFunction,Card.GetBaseDefence)
  Card.IsBaseDefence=DefFunc(math.equal)
  Card.IsBaseDefenceAbove=DefFunc(math.greater_eq)
  Card.IsBaseDefenceBelow=DefFunc(math.less_eq)

  function Card.MaybeGetReasonCard(c)
    local M=require "lib.maybe"
    local rc=c:GetReasonCard()
    return rc and M.Just(rc) or M.Nothing()
  end

  function Card.IsNotStatus(...)
    return not Card.IsStatus(...)
  end

  function Card.IsOverlayCount(c,n)
    return c:GetOverlayCount()==n
  end

  function Card.HasOverlayCount(c,n)
    return c:GetOverlayCount()>=n
  end
end
