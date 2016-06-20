return function()
  Extensions.Register("effect",1,1,"Effect")
  function Effect.SetUncopyable(e)
    e:SetProperty(e:GetProperty()+EFFECT_FLAG_UNCOPYABLE)
  end

  function Effect.SetNoDisable(e)
    e:SetProperty(e:GetProperty()+EFFECT_FLAG_CANNOT_DISABLE)
  end

  function Effect.SetNoCopyNoDisable(e)
    e:SetUncopyable()
    e:SetNoDisable()
  end

  function Effect.ResetTurnEnd(e)
    e:SetReset(RESET_PHASE+PHASE_END)
  end

  function Effect.ResetLeave(e)
    e:SetReset(RESET_EVENT+0x1fe0000)
  end

  function Effect.ResetEndOrLeave(e)
    e:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
  end

  function Effect.SetEffectDescription(e,id,n)
    e:SetDescription(aux.Stringid(id,n))
  end

  local ce=Effect.CreateEffect
  function Effect.CreateEffect(c,n,id,...)
    local b,e=pcall(ce,c,n,id,...)
    if not b then error(e,2) end
    id=id or c:GetOriginalCode()
    if n then e:SetEffectDescription(id,n) end
    return e
  end

  function Effect.CreateSingleEffect(c,co,pr,va,ra,re)
    if type(co)=="table" then
      co=co.code
      pr=co.property
      va=co.value
      ra=co.range
      re=co.reset
    end
    if ra==nil then ra=LOCATION_MZONE end
    pr=pr or 0
    re=re or 0
    local e=Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_SINGLE)
    e:SetCode(co)
    if ra then e:SetRange(ra) end
    e:SetProperty(pr)
    e:SetReset(re)
    e:SetValue(va)
    return e
  end

  function Effect.MultiSummonEffect(e,normal,flip,special,register,c)
    local e1,e2,e3=nil
    local f=function (b,s) if b then local e1=e:Clone() e1:SetCode(s) return e1 end end
    e1=f(normal,EVENT_SUMMON_SUCCESS)
    e2=f(flip,EVENT_FLIP_SUMMON_SUCCESS)
    e3=f(special,EVENT_SPSUMMON_SUCCESS)
    if register then c:RegisterEffects(e1,e2,e3) end
    return e1,e2,e3
  end

  function Card.AddActivateProc(c,...)
    local e=Effect.CreateEffect(c,...)
    e:SetType(EFFECT_TYPE_ACTIVATE)
    e:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffects(e)
    return e
  end

  function Effect.IsRelateToHandler(e)
    return e:GetHandler():IsRelateToEffect(e)
  end

  function Effect.Register(e,c)
    if c==nil then return function(x) e:Register(x) end end
    c:RegisterEffect(e)
  end

  function Effect.RegisterClone(e,c)
    if c==nil then return function(x) e:RegisterClone(x) end end
    local cl=e:Clone()
    c:RegisterEffect(cl)
    return cl
  end

  function Effect.IsRelatedTo(e,...)
    local g=Group.FromCards(...)
    return g:All(Card.IsRelateToEffect,e)
  end

  function Effect.IsNotRelatedTo(...)
    return not Effect.IsRelatedTo(...)
  end
end
