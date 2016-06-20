return function()
  Extensions.Register("debug",1,0,"Debug")
  Extensions.Require("debug","ext",1,0)

  function AddEvalEffect(c)
    if CheckDebugFlag() then error("Attempted to call debug function \"AddEvalEffect\".",2) end
    local t=Effect.CreateEffect(c)
    t:SetType(EFFECT_TYPE_QUICK_O)
    t:SetCode(EVENT_FREE_CHAIN)
    t:AddData("n",0)
    t:SetRange(0xFF)
    t:SetCost(function (e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end e:AddData("n",e:GetData("n")+1) end)
    t:SetTarget(function (e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end Duel.SetTargetParam(e:GetData("n")) e:AddData(e:GetData("n"),dofile("eval.lua")) end)
    t:SetOperation(function (e) e:GetData(Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM))() end)
    c:RegisterEffect(t)
  end

  function Dynamic(label,file)
    if CheckDebugFlag() then error("Attempted to call debug function \"Dynamic\".",2) end
    local file=file or GetID(3)
    if type(file)=="number" then
      file=table.concat({"script/c",file,".lua"})
    end
    return function(...)
      local dynamic=dofile(file)
      return dynamic[label](...)
    end
  end

  local function setfun(f)
    return function (e,s,...)
      if CheckDebugFlag() then f(e,s,...) end
      if type(s)=="string" then
        local c=e:GetHandler()
        local code=c:GetOriginalCode()
        local path=table.concat({"script/c",code,".lua"})
        f(e,Dynamic(s,path),...)
      else
        f(e,s,...)
      end
    end
  end

  local dmsg=Debug.Message
  function Debug.Message(...)
    if not CheckDebugFlag() then
      local args=table.pack(...)
      for n=1,args.n do
        dmsg(args[n])
      end
    end
  end
  
  local setcon=Effect.SetCondition
  local setcost=Effect.SetCost
  local settg=Effect.SetTarget
  local setval=Effect.SetValue
  local setop=Effect.SetOperation

  Effect.SetCondition=setfun(setcon)
  Effect.SetCost=setfun(setcost)
  Effect.SetTarget=setfun(settg)
  Effect.SetValue=setfun(setval)
  Effect.SetOperation=setfun(setop)
end
