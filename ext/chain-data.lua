return function()
  Extensions.Register("chain-data",1,0,"Chain Data")
  local data={}
  local turn=-1

  local function init_data()
    local t=Duel.GetTurnID()
    local c=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
    if t~=turn then data={} and turn=t end
    if not data[c] then data[c]={} end
    return c
  end

  function Duel.SetChainData(key,value)
    local c=init_data() 
    data[c][key]=value
  end

  function Duel.GetChainData(key)
    local c=init_data()
    return data[c][key]
  end

  function Duel.HasChainData(key)
    local c=init_data()
    return data[c][key]~=nil
  end

  function Duel.MaybeGetChainData(key)
    local M="lib.maybe"
    if Duel.HasChainData(key) then
      return M.Just(Duel.GetChainData(key))
    else
      return M.Nothing()
    end
  end

  function Duel.GetChainDataOrDefault(key,def)
    return Duel.HasChainData(key) and Duel.GetChainData(key) or def
  end
end
