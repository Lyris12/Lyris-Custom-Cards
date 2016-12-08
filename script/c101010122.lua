--Clear Seraphim
function c101010122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetTarget(c101010122.rectg)
	e2:SetOperation(c101010122.recop)
	c:RegisterEffect(e2)
end
function c101010122.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x306)
end
function c101010122.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c101010122.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.GetTurnPlayer()==tp and ct>0 end
	Duel.SetTargetPlayer(tp)
	local rec=ct*500
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c101010122.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rec=Duel.GetMatchingGroupCount(c101010122.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rec,REASON_EFFECT)
end
