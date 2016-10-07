--Spectrum Piece Test Remove 1
function c101010329.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101010329.sppcost)
	c:RegisterEffect(e1)
end
function c101010329.sppcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	local red=Duel.GetFlagEffect(p,10001000)
	local orange=Duel.GetFlagEffect(p,10002000)
	local yellow=Duel.GetFlagEffect(p,10003000)
	local green=Duel.GetFlagEffect(p,10004000)
	local blue=Duel.GetFlagEffect(p,10005000)
	local indigo=Duel.GetFlagEffect(p,10006000)
	local purple=Duel.GetFlagEffect(p,10007000)
	local spectrum=red+orange+yellow+green+blue+indigo+purple
	if chk==0 then return indigo~=0 end
	if red+orange+yellow+green+blue+indigo+purple==7 then Duel.ResetFlagEffect(p,10008000) end
	Duel.ResetFlagEffect(p,10006000)
end
