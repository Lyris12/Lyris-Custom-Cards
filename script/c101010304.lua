--レイディアント・ビーコン
function c101010304.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010304.target)
	e1:SetOperation(c101010304.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c101010304.actlimit)
	e2:SetTarget(c101010304.dtarget)
	c:RegisterEffect(e2)
end
function c101010304.filter(c)
	return c:IsSetCard(0x5e) and c:IsAbleToHand()
end
function c101010304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010304.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010304.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010304.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_PUBLIC)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetCondition(function(e) return e:GetHandler():IsPublic() end)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tv:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SSET)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		tc:RegisterEffect(e3)
	end
end
function c101010304.dfilter(c)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetAttack()<=1900) or c:IsDirectAttacked()
end
function c101010304.actlimit(e)
	return e:GetHandler():IsPublic() and not Duel.IsExistingMatchingCard(c101010304.dfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101010304.dtarget(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetAttack()<=1900
end
