return function()
  local data={}
  local debug=false
  Extensions={}
  Extensions.Loaded=true
  Extensions.Error={
    NO_ERROR=1,
    NOT_LOADED=-1,
    INVALID_MAJOR_VERSION=-2,
    INVALID_MINOR_VERSION=-3,
    UNSUPPORTED_VERSION=-4}
    

  function EnableDebugFlag()
    debug=true
    Debug.Message("Debug Flag Enabled")
  end

  function CheckDebugFlag()
    return not debug
  end

  function IsDebugMode()
    return debug
  end

  function Extensions.Register(_id,_major,_minor,_name)
    _name=_name or _id
    if data[_id] then error(table.concat({"Extension Error : ","Extension \"",_id,"\" already exists."}),2) return false end
    if not (_id or _major or _minor) then error("Extension Error : Extensions.Register requires 3 arguments.",2) return false end
    if not type(_major)=="number" then error("Extension Error : Major Version Number is not a number",2) return false end
    if not type(_minor)=="number" then error("Extension Error : Minor Version Number is not a number",2) return false end
    local dat={
               name=_name,
               major=_major,
               minor=_minor} 
    data[_id]=dat
    return true
  end

  function Extensions.SetMinVersion(_id,_version)
    if not data[_id] then error(table.concat({"Extension Error : Extension \"",_id,"\" does not exist."}),2) end
    data[_id].min=_version
  end

  function Extensions.CheckVersion(_id,_major,_minor)
    if not data[_id] then return false,Extensions.Error.NOT_LOADED end
    local dat=data[_id]
    if _major > dat.major then return false,Extensions.Error.INVALID_MAJOR_VERSION end
    if _major==dat.major and _minor>dat.minor then return false,Extensions.Error.INVALID_MINOR_VERSION end
    if dat.min then
      if _major<dat.min then return false,Extensions.Error.UNSUPPORTED_VERSION end
    end
    return true,Extensions.Error.NO_ERROR
  end

  function Extensions.Require(_src,_id,_major,_minor)
    if not data[_src] then error(table.concat({"Extension Error : Error in Extension \"",_src,"\". Tried to use Extensions.Require before Extensions.Register."}),2) return false end
    local name=data[_src].name
    if not Extensions.Loaded then return false end
    local hasExtension,code=Extensions.CheckVersion(_id,_major,_minor)
    if hasExtension then return true end
    Extensions.Loaded=false
    local dat=data[_id]
    --error(table.concat({"Extension Error : Extension \"",_id,"\", version \"",_major,".",_minor,"\" required. Version \"",dat.major,".",dat.minor,"\" has been loaded."}),2)
    if code==Extensions.Error.NOT_LOADED then
      error(table.concat({"Extension Error : Extension \"",name,"\" requires unloaded Extension \"",_id,"\"."}),2)
    elseif code==Extensions.Error.INVALID_MAJOR_VERSION or code==Extensions.Error.INVALID_MINOR_VERSION then
      error(table.concat({"Extension Error : Extension \"",name,"\" requires Extension \"",dat.name,"\" of version \"",_major,".",_minor,"\", while \"",dat.name,"\" of version \"",dat.major,".",dat.minor,"\" is loaded."}),2)
    elseif code==Extensions.Error.UNSUPPORTED_VERSION then
      error(table.concat({"Extension Error : Extension \"",name,"\" requires Extension \"",dat.name,"\" of unsupported version \"",_major,".",_minor,"\". Only versions of \"",dat.name,"\" of major version \"",dat.min,"\" or higher are supported."}),2)
    elseif code==Extensions.Error.NO_ERROR then
      error(table.concat({"Extension Error : Extension \"",name,"\" requires Extension \"",dat.name,"\" of version \"",_major,".",_minor,"\". Check Version reported that the version was invalid but the error code indicated that there was no error. Please contact the developer of your version of the Extensions Extension."}),2)
      Extensions.Loaded=false
    else
      error(table.concat({"Extension Error : Extension \"",name,"\" requires Extension \"",dat.name,"\" of version \"",_major,".",_minor,"\". An unknown error code was reported. Please contact the devveloper of your version of the Extensions Extension."}),2)
    end
    data[_src].Error=true
    return false
  end

  function Extensions.GetData()
    if not CheckDebugFlag() then error("Extension Error : Extension.GetData, debug flag must be enabled.",2) end
    return data
  end

  function Card.initial_effect(c,...)
    if Extensions.Loaded then
      if c.start then c:start(...) end
    end
  end

  Extensions.Register("ext",1,0,"Extensions")
end
