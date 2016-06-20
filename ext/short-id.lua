return function()
  local src="id-short"
  Extensions.Register(src,1,0,"ID Extension Shortcuts")
  Extensions.Require(src,"id",1,0)

  GID=GetID
  GR=GetReference
  GIR=GetIDReference
end
