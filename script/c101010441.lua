--Ladderal Maiden
function c101010441.initial_effect(c)
	--"When-Top-Decked" test
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c101010441.condition)
	e4:SetTarget(c101010441.target)
	--e4:SetOperation(c101010441.operation)
	c:RegisterEffect(e4)
end
function c101010441.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousLocation(),LOCATION_ONFIELD+LOCATION_GRAVE)~=0
		and c:GetSequence()==Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-1
end
function c101010441.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e) end
	Duel.ConfirmCards(tp,c)
	Duel.ConfirmCards(1-tp,c)
end
