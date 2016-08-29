--Rusted Dragon MkII
function c101020109.initial_effect(c)
	--If this card is Normal Summoned: You can add 1 "Rusted" monster from your Deck to your hand, except "Rusted Dragon MkII".
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101020109,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c101020109.target)
	e1:SetOperation(c101020109.operation)
	c:RegisterEffect(e1)
	--If this card is sent to the Graveyard for the Fusion Summon of a "Rusted" monster, or when this card is banished: You can target 1 monster your opponent controls; banish it. You can only use this effect of "Rusted Dragon MkII" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,101020109)
	e2:SetTarget(c101020109.rmtg)
	e2:SetOperation(c101020109.rmop)
	c:RegisterEffect(e2)
	local e0=e2:Clone()
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(c101020109.rmcon)
	c:RegisterEffect(e0)
	--This card's name is treated as "Rusted Dragon" while it is on the field or Graveyard.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(101020108)
	c:RegisterEffect(e3)
end
function c101020109.filter(c)
	return c:IsSetCard(0x858) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetCode()~=101020109
end
function c101020109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020109.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020109.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101020109.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101020109.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101020109.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c101020109.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION and c:GetReasonCard():IsSetCard(0x858)
end
