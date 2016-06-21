--PSYStream Journey
local id,ref=GIR()
function ref.start(c)
--When your opponent activates a card or effect in response to the Special Summon of a "PSYStream" monster: Negate the activation, and if you do, destroy it.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(ref.condition)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
end
function ref.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x127)
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex,g=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	return ep~=tp and ex and g:IsExists(ref.spfilter,1,nil) and Duel.IsChainNegatable(ev)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
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
	e2:SetCountLimit(1,id)
	e2:SetCost(ref.cost)
	e2:SetTarget(ref.sumtg)
	e2:SetOperation(ref.sumop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_ATTACK,ref.cfilter)
end
function ref.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function ref.tcfilter(c)
	return c:IsSetCard(0x127) and c:IsAbleToRemoveAsCost()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.GetCustomActivityCount(id,tp,ACTIVITY_ATTACK)==0 and Duel.IsExistingMatchingCard(ref.tcfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,ref.tcfilter,tp,LOCATION_HAND,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(ref.ftarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function ref.ftarget(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function ref.filter(c,e,tp)
	return c:IsSetCard(0x127) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function ref.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end]]
