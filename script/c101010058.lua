--created & coded by Lyris
--旋風のブリーズ
function c101010058.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101010058.activate)
	c:RegisterEffect(e1)
end
function c101010058.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c101010058.syntg)
	e1:SetValue(c101010058.synval)
	Duel.RegisterEffect(e1,tp)
end
function c101010058.filter(c)
	return c:GetDestination()==LOCATION_GRAVE
end
function c101010058.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_SYNCHRO)~=0
	and eg:IsExists(c101010058.filter,1,nil) end
	local g=eg:Filter(c101010058.filter,nil,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(101010058,0)) then
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
		e:Reset()
		return true
	else return false end
end
function c101010058.synval(e,c)
	return c101010058.filter(c)
end
