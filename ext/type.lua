return function()
  Extensions.Register("type",1,0,"Type Function Override")
  
  local ty=type
  function type(o)
    local m=getmetatable(o)
    local t=m and m.__type or nil
    if t then return t
    elseif ty(o)~="userdata" then return ty(o)
    elseif o.GetOriginalCode then return "card"
    elseif o.KeepAlive then return "group"
    elseif o.SetLabelObject then return "effect"
    end
  end
end
