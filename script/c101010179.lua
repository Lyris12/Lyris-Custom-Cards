--Cyber Network's Virus
function c101010179.initial_effect(c)
	--When a card or effect is activated that targets exactly 1 card on the field (and no other cards): Detach all Xyz Materials from 1 Xyz Monster you control (min. 1); Negate the activation, and if you do, banish that card.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101010179.condition)
	e1:SetCost(c101010179.cost)
	e1:SetTarget(c101010179.target)
	e1:SetOperation(c101010179.operation)
	c:RegisterEffect(e1)
end
function c101010179.condition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	return g:GetFirst():IsOnField()
end
function c101010179.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and c:CheckRemoveOverlayCard(tp,c:GetOverlayCount(),REASON_COST)
end
function c101010179.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010179.filter,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c101010179.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local ct=c:GetOverlayCount()
	tc:RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function c101010179.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010179.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
	