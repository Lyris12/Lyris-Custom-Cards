local Maybe = {}

function Maybe.IsNothing(m)
  return m.value==nil
end

function Maybe.HasValue(m)
  return not m:IsNothing()
end

function Maybe.GetValue(m)
  if m:IsNothing() then
    error("Tried to get maybe value from Nothing.",2)
  end
  return m.value
end

function Maybe.GetValueOrDefault(m,def)
  return m:HasValue() and m:GetValue() or def
end

function Maybe.WithValue(m,f,...)
  local r=nil
  if m:HasValue() then
    local b=false
    b,r=pcall(f,m:GetValue(),...)
    if not b then error(r,2) end
    r=Maybe.Just(r)
  else
    r=Maybe.Nothing()
  end
  return r
end

function Maybe.OnValue(m,f,...)
  local r=nil
  if m:HasValue() then
    local b=false
    b,r=pcall(f,m:GetValue(),...)
    if not b then error(r,2) end
  end
end

function Maybe.WithValueException(m,f,e,...)
  local r=nil
  if m:HasValue() then
    r=f(m:GetValue(),...)
  else
    r=e(...)
  end
  return r
end

function Maybe.WithDefaultValue(m,f,d,...)
  return f(m:GetValueOrDefault(d),...)
end

function Maybe.WithValueOrDefault(m,f,d,...)
  local r=d
  if m:HasValue() then
    r=f(m:GetValue(),...)
  end
  return r
end

--[[function Maybe.OnValue(m,f,...)
  if m:HasValue() then
    f(m:GetValue(),...)
  end
end]]

local function JustValue(m)
  local v=m:GetValue()
  return table.concat({"Just ",v})
end

local function NothingValue()
  return "Nothing"
end

local function JustType(v)
    local t=table.concat({"just ",type(v)})
    return t
end

local function eq(m1,m2)
  if m1:IsNothing() and m2:IsNothing() then return true
    elseif m1:IsNothing() or m2:IsNothing() then return false end
  
  if type(m1)~=type(m2) then return false end
  return m1:GetValue()==m2:GetValue()
end

local function lt_check(a,b) return a<b end
local function lt(m1,m2)
  if m1:IsNothing() and m2:IsNothing() then return false
    elseif m1:IsNothing() then return true
    elseif m2:IsNothing() then return false
    else
      local v1,v2=m1:GetValue(),m2:GetValue()
      local b,r=pcall(lt_check,v1,v2)
      if not b then error(r,2) end
      return r
    end
end

local function le_check(a,b) return a<=b end
local function le(m1,m2)
  if m1:IsNothing() and m2:IsNothing() then return true
    elseif m1:IsNothing() then return true
    elseif m2:IsNothing() then return false
    else
      local v1,v2=m1:GetValue(),m2:GetValue()
      local b,r=pcall(le_check,v1,v2)
      if not b then error(r,2) end
      return r
    end
end

function Maybe.Just(value)
  if value==nil then
    error("Tried to create maybe with nil.",2)
  end
  local m={}
  setmetatable(m,{__index=Maybe,
                  __tostring=JustValue,
                  __type=JustType(value),
                  __eq=eq,
                  __lt=lt,
                  __le=le
                 })
  m.value=value
  return m
end

function Maybe.IfValue(m,c,f,e,n,...)
  e=e or function () return false end
  n=n or e
  if m:IsNothing() then return n() end
  local v=m:GetValue()
  local hasFunc=c(v,...)
  return hasFunc and f(v) or e(v)
end

function Maybe.DoIfValue(m,c,f,...)
  return m:IfValue(c,f,nil,nil,...)
end

function Maybe.If(m,c,f,e,n,...)
  e=e or function () return false end
  n=n or e
  if m:IsNothing() then return n() end
  local v=m:GetValue()
  local hasFunc=c(v,...)
  return hasFunc and f() or e()
end

function Maybe.DoIf(m,c,f,...)
  return m:If(c,f,nil,nil,...)
end

function Maybe.MaybeIf(m,c,f,e,...)
  e=e or function () return false end
  if m:IsNothing() then return m end
  local v=m:GetValue()
  local hasFunc=c(v,...)
  return Maybe.Just(hasFunc and f(v) or f(e))
end

function Maybe.MaybeDoIf(m,c,f,...)
  return m:MaybeIf(c,f,nil,...)
end

function Maybe.Nothing()
  local m={}
  m.value=nil
  setmetatable(m,{__index=Maybe,
                  __tostring=NothingValue,
                  __type="nothing",
                  __eq=eq,
                  __lt=lt,
                  __le=le
                 })
  return m
end
return Maybe
