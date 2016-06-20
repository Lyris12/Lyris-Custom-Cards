return function()
  local src="function-short"
  Extensions.Register(src,1,2,"Function Extension Shortcuts")
  Extensions.Require(src,"function",1,2)

  DF=DoFunctions
  DCF=DoCurryFunctions
  AF=AndFunctions
  ACF=AndCurryFunctions
  OF=OrFunctions
  OCF=OrCurryFunctions
  CCF=CreateCheckedFunction
  MOF=MergeOperationFunctions
  C=Curry
  CCurry=CardCurry
  CC=CardCurry
  CIC=ChainInfoCurry
  CMP=Compose
  VF=ValueOnlyFunction
  OA=OrderArguments
  R=Reverse
  N=Negate
  WH=WithHandler
  WC=WithConfirm
  NOP=NoOperation
  SA=ShiftArguments
  SSA=SingleShiftArgument
  ASF=AndShiftFunctions
  OSF=OrShiftFunctions
  DSF=DoShiftFunctions
end
