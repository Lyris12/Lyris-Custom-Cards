--Real Rights - Lawbook
function c101020093.initial_effect(c)
	aux.AddRitualProcEqual2(c,c101020093.ritual_filter)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101020093)
	e1:SetCost(c101020093.cost)
	e1:SetTarget(c101020093.thtg)
	e1:SetOperation(c101020093.thop)
	c:RegisterEffect(e1)
end
function c101020093.ritual_filter(c)
	return c:IsSetCard(0x2ea) and bit.band(c:GetType(),0x81)==0x81
end
function c101020093.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101020093.filter(c)
	return c:IsSetCard(0x2ea) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToHand()
end
function c101020093.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return ((chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)) or chkc:IsLocation(LOCATION_REMOVED)) and c101020093.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020093.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101020093.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101020093.thfilter(c)
	return c:IsSetCard(0x2ea) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:GetCode()~=101020093
end
function c101020093.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if g:IsRelateToEffect(e) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local sg=Duel.GetMatchingGroup(c101020093.thfilter,tp,LOCATION_DECK,0,nil)
	if g:IsType(TYPE_RITUAL) and sg:GetCount()>0 and Duel.SelectYesNo(tp,1109) then
		local tc=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
