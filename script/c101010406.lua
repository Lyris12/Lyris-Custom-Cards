--Fate's Decision
function c101010406.initial_effect(c)
	--Discard 1 Spell/Trap Card, then target 1 "Fate's" monster in your Graveyard; Special Summon it.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010406,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c101010406.cost)
	e1:SetTarget(c101010406.settg)
	e1:SetOperation(c101010406.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(101010406,2))
	e2:SetLabel(1)
	c:RegisterEffect(e2)
end
function c101010406.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c101010406.star(c)
	return c:IsFaceup() and c:IsHasEffect(101010187)
end
function c101010406.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=0 then return Duel.CheckReleaseGroup(tp,c101010406.star,1,nil)
		else return Duel.IsExistingMatchingCard(c101010406.filter,tp,LOCATION_HAND,0,1,nil) end
	end
	Duel.Hint(HINT_OPSELECTED,0,e:GetDescription())
	if e:GetLabel()~=0 then
		local g=Duel.SelectReleaseGroup(tp,c101010406.star,1,1,nil)
		Duel.Release(g,REASON_COST)
	else Duel.DiscardHand(tp,Card.IsType,1,1,REASON_COST+REASON_DISCARD,nil,TYPE_SPELL+TYPE_TRAP) end
end
function c101010406.setfilter(c,e,tp)
	return c:IsSetCard(0xf7a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010406.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101010406.setfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010406.setfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010406.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010406.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
