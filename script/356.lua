--Frozen Flower Princess
function c101010131.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCountLimit(1)
	e1:SetCost(c101010131.cost)
	e1:SetTarget(c101010131.tg)
	e1:SetOperation(c101010131.op)
	c:RegisterEffect(e1)
end
function c101010131.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil),POS_FACEUP,REASON_EFFECT)
end
function c101010131.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101010131.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) then
		local atk=0
		if tg:IsType(TYPE_XYZ) then
			local g=tg:GetOverlayGroup()
			local tc=g:GetFirst()
			while tc do
				atk=atk+tc:GetAttack()
				tc=g:GetNext()
			end
		elseif tg:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) then
			local g=tg:GetMaterial()
			local tc=g:GetFirst()
			while tc do
				atk=atk+tc:GetAttack()
				tc=g:GetNext()
			end
		end
		if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 and tg:IsLocation(LOCATION_EXTRA) and atk>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
