--Time Dragon Advance
function c101010528.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010528+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101010528.target)
	e1:SetOperation(c101010528.activate)
	c:RegisterEffect(e1)
end
function c101010528.filter(c,n)
	if not (c:IsSetCard(0x4db) and c:IsType(TYPE_MONSTER)) then return false end
	if n~=0 then return c:IsAbleToGrave() else return c:IsAbleToDeck() end
end
function c101010528.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010528.filter(chkc,0) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c101010528.filter,tp,LOCATION_GRAVE,0,1,nil,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101010528.filter,tp,LOCATION_GRAVE,0,1,3,nil,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dg)
end
function c101010528.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 then
		local g=Duel.GetOperatedGroup()
		ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
