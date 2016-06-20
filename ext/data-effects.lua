return function ()
  Extensions.Register("data-effect",1,0,"Data Effects")
  local def={}
  def.get=Effect.GetLabelObject
  def.set=Effect.SetLabelObject
  def.cr=Effect.CreateEffect
  def.cl=Effect.Clone
  def.gcr=Effect.GlobalEffect

  local function GetD(e)
    return def.get(e):GetValue()()
  end

  local function SetD(e,d)
    def.get(e):SetValue(function () return d end)
  end

  function Effect.CreateEffect(c,...)
    local b,e=pcall(def.cr,c,...)
    if not b then error(e,2) end
    local d=def.cr(c)
    local data={}
    d:SetValue(function () return data end)
    def.set(e,d)
    return e
  end

  function Effect.GlobalEffect(...)
    local e=def.gcr(...)
    local d=def.gcr()
    local data={}
    d:SetValue(function () return data end)
    def.set(e,d)
    return e
  end

  function Effect.Clone(e,...)
    local n=def.cl(e,...)
    local d=e:GetHandler() and def.cr(e:GetHandler()) or def.gcr()
    local data=GetD(e)
    d:SetValue(function () return data end)
    def.set(n,d)
    return n
  end

  function Effect.GetLabelObject(e,...)
    local d=def.get(e)
    return def.get(d,...)
  end

  function Effect.SetLabelObject(e,...)
    local d=def.get(e)
    return def.set(d,...)
  end

  function Effect.AddData(e,key,value)
    local data=GetD(e)
    local r=data[key]
    data[key]=value
    SetD(e,data)
    return r
  end

  function Effect.GetData(e,key)
    local data=GetD(e)
    return data[key]
  end

  function Effect.ClearData(e,key)
    local data=GetD(e)
    local r={}
    local x=nil
    for k,v in pairs(data) do
      if (k~=key) then
        r[k]=v
      else
        x=v
      end
    end
    SetD(e,r)
    return x
  end

  function Effect.HasData(e,key)
    local data=GetD(e)
    return data[key]~=nil
  end

  function Effect.GetDataOrDefault(e,key,default)
    return e:HasData(key) and e:GetData(key) or default
  end

  function Effect.MaybeGetData(e,key)
    local f=function ()
      local M=require "lib.maybe"
      return M
    end
    local b,M=pcall(f)
    if not b then error("Effect.MaybeGetData, could not find lib/maybe.lua",2) end
    return e:HasData(key) and M.Just(e:GetData(key)) or M.Nothing()
  end

  function Effect.EitherGetDataOrDefault(e,key,default)
    local f=function ()
      local E=require "lib.either"
      return E
    end
    local E=pcall(f)
    if not E then error("Effect.EitherGetDataOrDefault, could not find lib/either.lua",2) end
    return e:HasData(key) and Either.Left(e:GetData(key)) or Either.Right(default)
  end
end
