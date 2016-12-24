--Dazzling Pendulum
function c101010305.initial_effect(c)
	--If this card is Summoned: You can Tribute it; banish 1 monster from your hand and add from your Deck to your hand, 1 Pendulum Monster with the same Type, Attribute, and Level as that banished monster had in the hand, but with a different name, but for the rest of the turn, monsters with the same name as that monster added to your hand by this effect cannot be banished from the hand.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCost(c101010305.cost)
	e1:SetTarget(c101010305.target)
	e1:SetOperation(c101010305.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101010305.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101010305.filter1(c,tp)
	return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c101010305.filter2,tp,LOCATION_DECK,0,1,nil,c:GetRace(),c:GetAttribute(),c:GetLevel(),c:GetCode())
end
function c101010305.filter2(c,rc,at,lv,code)
	return c:GetRace()==rc and c:GetAttribute()==at and c:GetLevel()==lv and c:GetCode()~=code and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101010305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010305.filter1,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010305.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c101010305.filter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	local tc=tg:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101010305.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetRace(),tc:GetAttribute(),tc:GetLevel(),tc:GetCode())
		local hc=g:GetFirst()
		if hc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,hc)
			--Monsters with the same name as that monster added to your hand by this effect cannot be banished from the hand.
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_REMOVE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetLabel(hc:GetCode())
			e1:SetTarget(c101010305.rmlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c101010305.rmlimit(e,c)
	return c:IsCode(e:GetLabel()) and c:IsLocation(LOCATION_HAND)
end
