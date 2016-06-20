--旋風のブリーズ
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(ref.syntg)
	e1:SetValue(ref.synval)
	Duel.RegisterEffect(e1,tp)
end
function ref.filter(c)
	return c:GetDestination()==LOCATION_GRAVE
end
function ref.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_SYNCHRO)~=0
	and eg:IsExists(ref.filter,1,nil) end
	local g=eg:Filter(ref.filter,nil,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(101010080,0)) then
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
		e:Reset()
		return true
	else return false end
end
function ref.synval(e,c)
	return ref.filter(c)
end
