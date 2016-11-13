--created by LionHeartKIng
--coded by Lyris
--Rippling Samurai of Stellar Vine
function c101020023.initial_effect(c)
	--This card can attack your opponent directly.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e0)
	--If this card inflicts battle damage to your opponent by a direct attack: You can banish 1 "Stellar Vine" monster from your hand, face-up; add 1 "Stellar Vine" monster from your Deck to your hand, except a monster with the same name as the monster banished by this effect.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetLabel(0)
	e2:SetCondition(c101020023.condition)
	e2:SetCost(c101020023.cost)
	e2:SetTarget(c101020023.target)
	e2:SetOperation(c101020023.op)
	c:RegisterEffect(e2)
	--If this card is banished: You can Special Summon 1 "Stellar Vine" monster from your Deck, except "Rippling Samurai of Stellar Vine", but banish it if it leaves the field.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101020023)
	e1:SetTarget(c101020023.tg)
	e1:SetOperation(c101020023.activate)
	c:RegisterEffect(e1)
end
function c101020023.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c101020023.cfilter(c)
	return c:IsSetCard(0x785e) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101020023.filter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101020023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020023.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101020023.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	e:SetLabel(g:GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c101020023.filter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToHand() and not c:IsCode(code)
end
function c101020023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020023.filter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020023.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101020023.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c101020023.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101020023.spfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_DECK)
end
function c101020023.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101020023.spfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(LOCATION_REMOVED)
		g:RegisterEffect(e1)
	end
end
