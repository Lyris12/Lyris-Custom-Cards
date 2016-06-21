--Crystapal Formator
local id,ref=GIR()
function ref.start(c)
aux.EnablePendulumAttribute(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(ref.chop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(ref.chop2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(id)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(ref.sumcon)
	e3:SetTarget(ref.sumtg)
	e3:SetOperation(ref.sumop)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
	--tohand
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCost(ref.thcost)
	e0:SetTarget(ref.thtg)
	e0:SetOperation(ref.thop)
	c:RegisterEffect(e0)
end
function ref.chop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function ref.chop2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetLabelObject():SetLabelObject(re:GetHandler())
	e:GetLabelObject():SetLabel(1)
	local p=tp
	if re:GetHandler():GetControler()~=p then p=1-tp end
	Duel.RaiseSingleEvent(e:GetHandler(),id,e,r,rp,p,0)
end
function ref.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=0
end
function ref.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetFlagEffect(tp,id)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,e:GetHandler():GetControler(),LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function ref.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(ref.filter,e:GetHandler():GetControler(),LOCATION_DECK,0,nil,e,tp):RandomSelect(tp,1)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function ref.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function ref.thfilter(c)
	return c:IsSetCard(0x1613) and c:IsAbleToDeck()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,ref.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
--[[function ref.thfilter(c)
	return c:IsSetCard(0x613) and not c:IsCode(id) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end]]
