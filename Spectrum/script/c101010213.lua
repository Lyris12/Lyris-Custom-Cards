--Spectrum Piece Test General 2
function c101010213.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101010213.sppcost)
	c:RegisterEffect(e1)
end
function c101010213.sppcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	local red=Duel.GetFlagEffect(p,10001000)
	local orange=Duel.GetFlagEffect(p,10002000)
	local yellow=Duel.GetFlagEffect(p,10003000)
	local green=Duel.GetFlagEffect(p,10004000)
	local blue=Duel.GetFlagEffect(p,10005000)
	local indigo=Duel.GetFlagEffect(p,10006000)
	local purple=Duel.GetFlagEffect(p,10007000)
	local spectrum=red+orange+yellow+green+blue+indigo+purple
	if chk==0 then return spectrum>=1 end
	if spectrum==7 then Duel.ResetFlagEffect(p,10008000) end
	for i=1,1 do
		local pcs=10000000+((Duel.SelectOption(p,aux.Stringid(450,1),aux.Stringid(450,2),aux.Stringid(450,3),aux.Stringid(450,4),aux.Stringid(450,5),aux.Stringid(450,6),aux.Stringid(450,7))+1)*1000)
		while Duel.GetFlagEffect(p,pcs)==0 do
			pcs=10000000+((Duel.SelectOption(p,aux.Stringid(450,1),aux.Stringid(450,2),aux.Stringid(450,3),aux.Stringid(450,4),aux.Stringid(450,5),aux.Stringid(450,6),aux.Stringid(450,7))+1)*1000)
		end
		Duel.ResetFlagEffect(p,pcs,0,0,1)
	end
end
