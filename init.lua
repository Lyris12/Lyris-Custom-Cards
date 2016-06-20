dofile("ext/extensions.lua")()
if not Extensions and Extensions.CheckVersion("ext",1,0) then
  error("init.lua requires Extension \"Extensions\" of at least version \"1.0\" to load Extensions.")
end
function ext(file)
  if Extensions.Loaded then
    local path=table.concat({"ext/",file,".lua"})
    local x=dofile(path)
    x()
  end
end

ext("extensions")
ext("type")
ext("function")
ext("function-short")
ext("math")
ext("id")
ext("short-id")
ext("effect")
ext("auto-effects")
ext("data-effects")
ext("ignore")
ext("group")
ext("card")
ext("debug")
ext("short-debug")
ext("duel")
ext("short-duel")
ext("constant")
ext("chain-data")
