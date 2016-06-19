--旋風のブリーズ
function c101010080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101010080.activate)
	c:RegisterEffect(e1)
end
function c101010080.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c101010080.syntg)
	e1:SetValue(c101010080.synval)
	Duel.RegisterEffect(e1,tp)
end
function c101010080.filter(c)
	return c:GetDestination()==LOCATION_GRAVE
end
function c101010080.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_SYNCHRO)~=0
	and eg:IsExists(c101010080.filter,1,nil) end
	local g=eg:Filter(c101010080.filter,nil,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(101010080,0)) then
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
		e:Reset()
		return true
	else return false end
end
function c101010080.synval(e,c)
	return c101010080.filter(c)
end
