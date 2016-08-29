--Real Rights - Punishment
function c101020095.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c101020095.addc2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c101020095.addc1)
	c:RegisterEffect(e3)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101020095)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101020095.descon)
	e3:SetCost(c101020095.descost)
	e3:SetTarget(c101020095.destg)
	e3:SetOperation(c101020095.desop)
	c:RegisterEffect(e3)
end
function c101020095.filter1(c)
	return c:IsSetCard(0x2ea) and c:IsReason(REASON_COST) and c:GetPreviousLocation()==LOCATION_GRAVE
end
function c101020095.addc2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c101020095.filter1,1,nil) then
		e:GetHandler():AddCounter(0x107+COUNTER_NEED_ENABLE,1)
	end
end
function c101020095.filter2(c,p)
	return c:IsFaceup() and c:IsSetCard(0x2ea) and bit.band(c:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL and c:IsControler(tp)
end
function c101020095.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c101020095.filter2,1,nil,tp) then
		e:GetHandler():AddCounter(0x107+COUNTER_NEED_ENABLE,1)
	end
end
function c101020095.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x107)>=4
end
function c101020095.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101020095.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101020095.filter0(c)
	return c:IsSetCard(0x2ea) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c101020095.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101020095.filter0,tp,LOCATION_DECK,0,1,1,nil)
		local sc=g:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,true,POS_FACEUP)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetOperation(c101020095.retop)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			tc:RegisterEffect(e2,true)
		end
	end
end
function c101020095.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
