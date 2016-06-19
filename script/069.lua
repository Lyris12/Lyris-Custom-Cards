--PSYStream Journey
function c101010672.initial_effect(c)
	--When your opponent activates a card or effect in response to the Special Summon of a "PSYStream" monster: Negate the activation, and if you do, destroy it.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101010672.condition)
	e1:SetTarget(c101010672.target)
	e1:SetOperation(c101010672.op)
	c:RegisterEffect(e1)
end
function c101010672.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x127)
end
function c101010672.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex,g=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	return ep~=tp and ex and g:IsExists(c101010672.spfilter,1,nil) and Duel.IsChainNegatable(ev)
end
function c101010672.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010672.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
	--[[If this card is in your Graveyard: You can banish this card from your Graveyard; Special Summon 1 "PSYStream" monster from your Deck. Monsters you control cannot declare an attack during the turn you activate this effect, except WATER monsters.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101010672)
	e2:SetCost(c101010672.cost)
	e2:SetTarget(c101010672.sumtg)
	e2:SetOperation(c101010672.sumop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101010672,ACTIVITY_ATTACK,c101010672.cfilter)
end
function c101010672.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c101010669.tcfilter(c)
	return c:IsSetCard(0x127) and c:IsAbleToRemoveAsCost()
end
function c101010672.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.GetCustomActivityCount(101010672,tp,ACTIVITY_ATTACK)==0 and Duel.IsExistingMatchingCard(c101010672.tcfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101010672.tcfilter,tp,LOCATION_HAND,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101010672.ftarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010672.ftarget(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c101010672.filter(c,e,tp)
	return c:IsSetCard(0x127) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010672.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010672.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010672.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010672.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end]]
