--Time Dragon Passage
function c101010302.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,101010302)
	--e1:SetCondition(c101010302.condition)
	--e1:SetCost(c101010302.cost)
	e1:SetTarget(c101010302.target)
	e1:SetOperation(c101010302.activate)
	c:RegisterEffect(e1)
end
function c101010302.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c101010302.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010302.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101010302.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101010302.cfilter(c,e,tp)
	return c:IsSetCard(0x4db) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010302.filter(c)
	return c:IsSetCard(0x4db) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101010302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c101010302.filter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(c101010302.filter,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101010302.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.SelectMatchingCard(tp,c101010302.filter,tp,LOCATION_HAND,0,1,1,nil)
	if dg:GetCount()>0 then
		Duel.SendtoDeck(dg,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
