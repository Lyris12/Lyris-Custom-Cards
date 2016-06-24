--Real Rights - Lawbook
local id,ref=GIR()
function ref.start(c)
	aux.AddRitualProcEqual2(c,ref.ritual_filter)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(ref.cost)
	e1:SetTarget(ref.thtg)
	e1:SetOperation(ref.thop)
	c:RegisterEffect(e1)
end
function ref.ritual_filter(c)
	return c:IsSetCard(0x2ea) and bit.band(c:GetType(),0x81)==0x81
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function ref.filter(c)
	return c:IsSetCard(0x2ea) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return ((chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)) or chkc:IsLocation(LOCATION_REMOVED)) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function ref.thfilter(c)
	return c:IsSetCard(0x2ea) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:GetCode()~=id
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local sg=Duel.GetMatchingGroup(ref.thfilter,tp,LOCATION_DECK,0,nil)
	if g:IsType(TYPE_RITUAL) and sg:GetCount()>0 and Duel.SelectYesNo(tp,1109) then
		local tc=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end