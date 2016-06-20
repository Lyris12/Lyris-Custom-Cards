return function()
  Extensions.Register("ignore",1,0,"Reason Ignore")
  REASON_IGNORE=0x10000000

  local sc=Effect.SetCondition
  local ce=Effect.CreateEffect

  local function make_con(f)
    return function (e,tp,eg,ep,ev,re,r,rp,...)
      if r then
        if bit.band(r,REASON_IGNORE)==REASON_IGNORE then
          return false
        end
      end
      return f(e,tp,eg,ep,ev,re,r,rp,...)
    end
  end

  local function t()
    return true
  end

  function Effect.SetCondition(e,f)
    if not f then sc(e,t) return end
    sc(e,make_con(f))
  end

  function Effect.CreateEffect(...)
    local b,e=pcall(ce,...)
    if not b then error(e,2) end
    e:SetCondition(make_con(t))
    return e
  end
end
