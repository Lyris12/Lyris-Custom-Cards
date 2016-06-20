return function()
  Extensions.Register("id",1,0,"ID and Reference")

  function GetID(n)
    n=n or 2
    local t={}
    debug.getinfo(n,'S').source:gsub(".",function (v) table.insert(t,v) end)
    local r=""
    for i = (#t-4),1,-1 do
      if t[i]~='c' then
        r=t[i]..r
      else
        break
      end
    end
    return tonumber(r)
  end

  function GetReference(id)
    return _G['c'..id]
  end

  function GetIDReference()
    local id=GetID(3)
    local ref=GetReference(id)
    
    return id,ref
  end
end
