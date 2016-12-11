--created & coded by Lyris
--Fate's Magic Stargazer
function c101010187.initial_effect(c)
	--When you activate the effect of a "Fate's" Spell/Trap Card that requires you to discard a card(s) to activate, you can Tribute this card you control instead of paying that card's cost.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(101010187)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--If this card is Special Summoned from the hand or with a "Fate's" card: you can add 1 banished Ritual Spell Card or 1 "Fate's" Ritual Spell Card from your Deck to your hand. If this card was Pendulum Summoned, you must have a "Fate's" card in your Pendulum Zone to activate this effect. You can only use this effect of "Fate's Magic Stargazer" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,101010187)
	e2:SetCondition(c101010187.condition)
	e2:SetTarget(c101010187.target)
	e2:SetOperation(c101010187.operation)
	c:RegisterEffect(e2)
end
function c101010187.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
		return pc1:IsSetCard(0xf7a) or pc2:IsSetCard(0xf7a)
	end
	return c:GetSummonLocation()==LOCATION_HAND or re:GetHandler():IsSetCard(0xf7a)
end
function c101010187.filter(c)
	return c:GetType()==0x82 and (c:IsLocation(LOCATION_REMOVED) or c:IsSetCard(0xf7a)) and c:IsAbleToHand()
end
function c101010187.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010187.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	e:SetCategory(CATEGORY_TOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c101010187.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010187.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
