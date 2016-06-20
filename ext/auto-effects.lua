return function ()
  Extensions.Register("auto-effect",1,0,"Auto Effects")
  local autoeffect={}

  function Effect.StartAutoEffects(c)
    autoeffect.card=c
    autoeffect.effects={}
  end

  function Effect.RegisterAutoEffects()
    for _,v in ipairs(autoeffect.effects) do
      autoeffect.card:RegisterEffect(v)
    end
    autoeffect={}
    autoeffect.card=nil
  end

  local ie=Card.initial_effect
  function Card.initial_effect(c,...)
    Effect.StartAutoEffects(c)
    if ie then ie(c,...) end
    Effect.RegisterAutoEffects()
  end

  local ce=Effect.CreateEffect

  function Effect.CreateEffect(c,...)
    if c==nil and autoeffect.card then
      local e=ce(autoeffect.card,...)
      table.insert(autoeffect.effects,e)
      return e
    elseif c and type(c)~="card" and autoeffect.card then
      local e=ce(autoeffect.card,c,...)
      table.insert(autoeffect.effects,e)
      return e
    else
      return ce(c,...)
    end
  end

  local cl=Effect.Clone
  function Effect.Clone(e,...)
      local n=cl(e,...)
      if autoeffect.card then table.insert(autoeffect.effects,n) end
      return n
  end
end
