--水中噴出
function c101010231.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010231.tg)
	e1:SetOperation(c101010231.op)
	c:RegisterEffect(e1)
end
function c101010231.tg(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,LOCATION_EXTRA)>0 end
end
function c101010231.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_WATER)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
