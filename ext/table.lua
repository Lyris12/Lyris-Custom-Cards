return function()
  local src="table"
  Extensions.Register(src,1,0,"table")
  Extensions.Require(src,"group",1,0)

  function table.fold(t,f,b,...)
    local hasItme=false
    local r=b
    for k,v in ipairs(t) do
      r=f(r,v,...)
    end
    return r
  end

  function table.map(t,f,...)
    local r={}
    for _,v in ipairs(t) do
      table.insert(r,f(v,...))
    end
    return r
  end

  function table.mapG(...)
    return Group.CreateFromTable(table.map(...))
  end

  function table.all(t,f,...)
    local r=true
    for _,v in pairs(t) do
      r=f(v,...)
      if not r then break end
    end
    return r
  end

  function table.any(t,f,...)
    local r=true
    for _,v in pairs(t) do
      r=f(v,...)
      if r then break end
    end
    return r
  end
end
