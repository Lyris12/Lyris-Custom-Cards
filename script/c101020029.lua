--created by LionHeartKIng
--coded by Lyris
--Dragluo Returner
function c101020029.initial_effect(c)
	--If this card is Pendulum Summoned, its controller cannot Special Summon monsters for the rest of the turn, except Dragon-Type monsters.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101020029.con)
	e4:SetOperation(c101020029.op)
	c:RegisterEffect(e4)
	--If this card is Special Summoned: You can add 1 "Dragluo" card from your Deck to your hand, except "Dragluo Returner". You can only use this effect of "Dragluo Returner" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,101020029)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c101020029.tg2)
	e2:SetOperation(c101020029.op2)
	c:RegisterEffect(e2)
	--If you control another Dragon-Type monster, this card's Level becomes 8.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(8)
	c:RegisterEffect(e0)
	--You can discard 1 "Dragluo" monster; Special Summon 1 Level 8 Dragon-Type monster from your Deck in face-up Defense Position, but its effect(s) are negated, also you cannot Special Summon any monsters for the rest of this turn, except Dragon-Type monsters from the Extra Deck.
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c101020029.cost)
	e6:SetTarget(c101020029.sptg)
	e6:SetOperation(c101020029.spop)
	c:RegisterEffect(e6)
end
function c101020029.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101020029.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101020029.sumlimit)
	Duel.RegisterEffect(e1,c:GetControler())
end
function c101020029.dragluo(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x94b)
end
function c101020029.cfilter(c)
	return c101020029.dragluo(c) and c:IsDiscardable()
end
function c101020029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020029.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101020029.dragluo,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c101020029.spfilter(c,e,tp)
	return c:GetLevel()==8 and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101020029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101020029.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101020029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c101020029.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101020029.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c101020029.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsRace(RACE_DRAGON) and c:IsLocation(LOCATION_EXTRA))
end
function c101020029.filter(c)
	return c:IsSetCard(0x94b) and c:IsAbleToHand() and c:GetCode()~=101020029
end
function c101020029.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020029.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020029.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101020029.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
