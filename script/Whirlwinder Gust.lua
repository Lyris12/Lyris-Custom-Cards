--旋風のガスト
function c101010075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101010075.condition)
	e1:SetTarget(c101010075.target)
	e1:SetOperation(c101010075.activate)
	c:RegisterEffect(e1)
end
function c101010075.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsChainNegatable(ev)
end
function c101010075.filter(c,tc,m)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSynchroSummonable(tc,m)
end
function c101010075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010075.filter,tp,LOCATION_EXTRA,0,1,nil,nil,Duel.GetFieldGroup(tp,LOCATION_MZONE,0)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c101010075.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g1=Duel.GetMatchingGroup(c101010075.filter,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g1:GetCount()>0 then
		Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g1:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
		Duel.NegateActivation(ev)
		local ec=re:GetHandler()
		if re:GetHandler():IsRelateToEffect(re) then
			ec:CancelToGrave()
			Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
		end
	end
end
