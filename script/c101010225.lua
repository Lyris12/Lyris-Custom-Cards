--created & coded by Lyris
--黒輪の運命
function c101010225.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010225.target)
	e1:SetOperation(c101010225.activate)
	c:RegisterEffect(e1)
end
function c101010225.spfilter(c,e,tp)
	local loc=LOCATION_MZONE
	if c:IsRace(RACE_WARRIOR) then loc=loc+LOCATION_HAND end
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x5d) and c.material(tp,loc,0,0)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101010225.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010225.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010225.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c101010225.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local loc=LOCATION_MZONE
		if tc:IsRace(RACE_WARRIOR) then loc=loc+LOCATION_HAND end
		local mat=tc.material(tp,loc,0,1)
		Duel.Release(mat,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetCondition(c101010225.atkcon)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
	if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function c101010225.brfilter(c)
	return c:IsFaceup() and c:IsCode(101010225)
end
function c101010225.atkcon(e)
	return Duel.IsExistingMatchingCard(c101010225.brfilter,e:GetHandler():GetControler(),LOCATION_REMOVED,0,1,nil)
end
