--Ashur, Tsuiho General
function c101010323.initial_effect(c)
	--back to grave/banish another
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1600547,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,10101034)
	e1:SetCost(c101010323.retcost)
	e1:SetTarget(c101010323.rettg)
	e1:SetOperation(c101010323.retop)
	c:RegisterEffect(e1)
	--banish from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010323,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10101034)
	e2:SetTarget(c101010323.bantg)
	e2:SetOperation(c101010323.banop)
	c:RegisterEffect(e2)
	--end turn/order and banish deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010323,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101010323.etcon)
	e3:SetTarget(c101010323.ettg)
	e3:SetOperation(c101010323.etop)
	c:RegisterEffect(e3)
end
function c101010323.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c101010323.rfilter(c)
	return c:IsSetCard(0x330) and c:IsAbleToRemove() and c:GetCode()~=101010323
end
function c101010323.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c101010323.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010323.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101010323.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c101010323.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c101010323.banfilter(c)
	return c:IsSetCard(0x330) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:GetCode()~=101010323
end
function c101010323.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c101010323.banfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c101010323.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010323.banfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		local rg=Group.CreateGroup()
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				rg:AddCard(tc)
				g:Remove(Card.IsCode,nil,tc:GetCode())
			end
		end
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local tg=rg:Select(1-tp,1,1,nil):GetFirst()
		if tg:IsAbleToRemove() then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	else
		local cg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleDeck(tp)
	end
end
function c101010323.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101010323.ettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c101010323.etop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	Duel.SortDecktop(tp,tp,3)
	Duel.BreakEffect()
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
