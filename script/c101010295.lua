--バトル・シティ
function c101010295.initial_effect(c)
--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetCode(EVENT_STARTUP)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetOperation(c101010295.op)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	c:RegisterEffect(e1)
	--normal summon in defense
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetRange(LOCATION_REMOVED)
	e0:SetOperation(c101010295.fdop)
	c:RegisterEffect(e0)
	--cannot be affected
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e6)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetCode(EFFECT_CANNOT_TO_DECK)
	eb:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(eb)
	local ec=eb:Clone()
	ec:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(ec)
	local ed=eb:Clone()
	ed:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(ed)
	local ee=eb:Clone()
	ee:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(ee)
end
function c101010295.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
	--Fusion Monsters cannot attack during the turn they are summoned.
	if not Duel.SelectYesNo(tp,aux.Stringid(101010295,0)) and not Duel.SelectYesNo(1-tp,aux.Stringid(101010295,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(c101010295.fusop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010295.fdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if Duel.SelectYesNo(tc:GetControler(),aux.Stringid(101010295,1)) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
		tc=eg:GetNext()
	end
end
function c101010295.fusop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_FUSION) then
			local e0=Effect.CreateEffect(tc)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_CANNOT_ATTACK)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e0:SetReset(RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e0)
		end
		tc=eg:GetNext()
	end
end
