return function()
  local src="debug-short"
  Extensions.Register(src,1,0,"Debug Extension Shortcuts")
  Extensions.Require(src,"debug",1,0)

  AEE=AddEvalEffect
  D=Dynamic
end
