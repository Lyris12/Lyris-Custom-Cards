local Either={}

Either.LEFT=0
Either.RIGHT=1

function Either.Either(pos,value)
  if pos>1 or pos<0 then
    error("Tried to create Either with an incorrect Left/Right value",2)
  end
  local e={}
  e.pos=pos;
  if pos==Either.LEFT then
    e.left=value
    e.right=nil
  else
    e.right=value
    e.left=nil
  end
  setmetatable(e,{ __index=Either})
  return e
end

function Either.Left(value)
  return Either.Either(Either.LEFT,value)
end

function Either.Right(value)
  return Either.Either(Either.RIGHT,value)
end

function Either.IsLeft(e)
  return e.pos==Either.LEFT
end

function Either.IsRight(e)
  return e.pos==Either.RIGHT
end

function Either.GetLeft(e)
  return e.left
end

function Either.GetRight(e)
  return e.right
end

return Either
