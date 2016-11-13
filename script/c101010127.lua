--created & coded by Lyris
--Earth Enforcement - Sealing Quake
function c101010127.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101010127.condition)
	e1:SetTarget(c101010127.tg)
	e1:SetOperation(c101010127.op)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c101010127.thcon)
	e2:SetTarget(c101010127.thtg)
	e2:SetOperation(c101010127.thop)
	c:RegisterEffect(e2)
end
function c101010127.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c101010127.cfilter(c)
	if not c:IsAbleToGraveAsCost() then return false end
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c101010127.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010127.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c101010127.dfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsFaceup() and c:IsDestructable()
end
function c101010127.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH) then
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.BreakEffect()
			local dg=Duel.GetMatchingGroup(c101010127.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,eg:GetFirst())
			if Duel.Destroy(eg,REASON_EFFECT)~=0 and dg:GetCount()>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
function c101010127.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c101010127.filter(c)
	return c:IsSetCard(0xeec) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101010127.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010127.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010127.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010127.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
