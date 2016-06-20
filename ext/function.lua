return function()
  Extensions.Register("function",1,2,"Function")
  function DoFunctions(...)
    local args=table.pack(...)
    return function(...)
      local n=1
      while n<=args.n do
        local v=args[n]
        v(...)
        n=n+1
      end
    end
  end

  function AndFunctions(...)
    local args=table.pack(...)
    return function(...)
      local res=true
      for n=1,args.n do
        if not args[n] then res=false break end
        res=args[n](...)
        if not res then break end
      end
      return res and true or false
    end
  end

  function OrFunctions(...)
    local args={...}
    return function(...)
      local res=false
      for _,v in pairs(args) do
        res=v(...)
        if res then break end
      end
      return res and true or false
    end
  end

  local function CurryLoopFunctions(df)
    return function(...)
      local args=table.pack(...)
      local xf={}
      local n=1
      while n<=args.n do
        local f=args[n]
        n=n+1
        while n<=args.n and type(args[n])~="function" do
          f=CardCurry(f,args[n])
          n=n+1
        end
        table.insert(xf,f)
      end
      return df(table.unpack(xf))
    end
  end

  DoCurryFunctions=CurryLoopFunctions(DoFunctions)
  AndCurryFunctions=CurryLoopFunctions(AndFunctions)
  OrCurryFunctions=CurryLoopFunctions(OrFunctions)

  function CreateCheckedFunction(func,checked,target)
    checked=checked or aux.TRUE
    local function f(e,s) if type(s)=="string" then local path=table.concat({"script/c",e:GetHandler():GetOriginalCode(),".lua"}) return Dynamic(s,path) else return s end end
    return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
      local x=Curry(f,e)
      if target then
        if chkc then
          return x(target)(e,tp,eg,ep,ev,re,r,rp,chkc)
        end
      end
      if chk==0 then
        return x(checked)(e,tp,eg,ep,ev,re,r,rp)
      end
      x(func)(e,tp,eg,ep,ev,re,r,rp)
    end
  end

  function MergeOperationFunctions(...)
    local args=table.pack(...)
    return function (e,tp,eg,ep,ev,re,r,rp,chk,chkc)
      local res=true
      for n=1,args.n do
        if not args[n] then res=false break end
        local f=args[n]
        res=f(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
        if chk==0 then
          if not res then break end
        end
      end
      return res and true
    end
  end

  function Curry(f,...)
    local args=table.pack(...)
    return function(...)
      local a=table.pack(...)
      local t={}
      local c=0
      for n=1,args.n do
        t[n]=args[n]
        c=c+1
      end
      local l=c
      for n=1,a.n do
        t[n+c]=a[n]
        l=l+1
      end
      t.n=l
      return f(table.unpack(t))
    end
  end

  function CardCurry(f,...)
    local args={...}
    return function(c,...)
      local f=Curry(f,c,table.unpack(args))
      return f(...)
    end
  end

  --Do not use for now
  function ChainInfoCurry(f,...)
    local args={...}
    local function gt()
      local T=require "lib.toolbox"
      return T
    end
    local b,T=pcall(gt)
    if not b then error("ChainInfoCurry requires lib/toolbox.lua to exist",2) end
    if T.version_check==nil or T.version_check(1,3)==false then error("ChainInfoCurry requires toolbox version 1.3 or greater",2) end
    local ci=C(Duel.GetChainInfo,0)
    local a=T.map(args,ci)
    return C(f,table.unpack(a))
  end

  function Flip(f)
    return function (arg1,arg2,...)
      return f(arg2,arg1,...)
    end
  end

  function Compose(...)
    local args=table.pack(...)
    return function(...)
      res=nil
      local first=true
      --for _,v in pairs(args) do
      for n=1,args.n do
        if first then
          res=args[n](...)
          first=false
        else
          res=args[n](res)
        end
      end
      return res
    end
  end

  function ValueOnlyFunction(f)
    return function(n,...)
      if n~=nil then
        return f(n,...)
      end
    end
  end

  function OrderArguments(f,...)
    local args=table.pack(...)
    return function(...)
      local params=table.pack(...)
      for index=1,args.n do
        local swap=args[index]
        params[index],params[swap]=params[swap],params[index]
      end
      return f(table.unpack(params))
    end
  end

  function Reverse(f)
    return function(...)
      local args=table.pack(...)
      local t={}
      local n=args.n
      while n>0 do
        table.insert(t,args[n])
        n=n-1
      end
      f(table.unpack(t))
    end
  end

  function Negate(f)
    return function(...)
      return not f(...)
    end
  end

  function MaxBy(f,...)
    local args=table.pack(...)
    if args.n==0 then return nil end
    local r=args[1]
    local n=2
    while n<=args.n do
      local c=args[n]
      if f(c) then
        if f(c)>f(r) or f(r)==nil then r=c end
      end
      n=n+1
    end
    return r
  end

  function MinBy(f,...)
    local args=table.pack(...)
    if args.n==0 then return nil end
    local r=args[1]
    local n=2
    while n<=args.n do
      local c=args[n]
      if f(c) then
        if f(r)==nil or f(c)<f(r) then r=c end
      end
      n=n+1
    end
    return r
  end

  function WithHandler(f,...)
    local args={...}
    return function (e)
      return f(e:GetHandler(),table.unpack(args))
    end
  end

  function WithConfirm(tp,id,n,f,...)
    local hasConfirm=Duel.SelectYesNo(tp,aux.Stringid(id,n))
    if hasConfirm then return f(...) end
  end

  function Case(f,y,n,...)
    local f1=CC(f,...)
    return function (x,...)
      if f1(x,...) then return y else return n end
    end
  end

  function NoOperation() end

  function ShiftArguments(func,shift)
    shift=shift and shift-1 or 0
    if shift==-1 then return func end
    if shift<-1 then error(table.concat({"Shift Arguments : Second argument must be greater than 0. \"",shift+1,"\" was provided."})) end
    local f=function(c,_,...)
      return func(c,...)
    end
    return ShiftArguments(f,shift)
  end
  
  function SingleShiftArgument(func,shift)
    shift=shift+1
    return function(c,...)
      local args=table.pack(...)
      return func(c,args[shift])
    end
  end

  local function ShiftArgumentDoFunction(func)
    return function (...)
      local f={}
      local args=table.pack(...)
      for n=1,args.n do
        table.insert(f,SingleShiftArgument(args[n],n-1))
      end
      return func(table.unpack(f))
    end
  end
  AndShiftFunctions=ShiftArgumentDoFunction(AndFunctions)
  OrShiftFunctions=ShiftArgumentDoFunction(OrFunctions)
  DoShiftFunctions=ShiftArgumentDoFunction(DoFunctions)
end
