--created & coded by Lyris
--Blitzkrieg Sky
function c101010124.initial_effect(c)
	--When this card is activated: You can add 1 "Blitzkrieg" monster from your Deck to your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetOperation(c101010124.activate)
	c:RegisterEffect(e1)
	--The effects of "Blitzkrieg" monsters you control cannot be activated.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x167))
	e5:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e5)
	--The controller of a "Blitzkrieg" monster chooses attack targets for their opponent, also, their opponent's face-up monsters, except "Blitzkrieg" monsters, must attack, if able.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e2:SetCondition(c101010124.condition1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e3:SetCondition(c101010124.condition2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(function(e,c) return not c:IsSetCard(0x167) end)
	c:RegisterEffect(e4)
end
function c101010124.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x167) and c:IsAbleToHand()
end
function c101010124.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101010124.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010124,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c101010124.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x167)
end
function c101010124.condition1(e)
	return Duel.IsExistingMatchingCard(c101010124.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101010124.condition2(e)
	return Duel.IsExistingMatchingCard(c101010124.atkfilter,e:GetHandlerPlayer,0,LOCATION_MZONE,1,nil)
end