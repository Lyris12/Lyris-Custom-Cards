--Crystapal Ali the Pearl
function c101010138.initial_effect(c)
aux.EnablePendulumAttribute(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(c101010138.chop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c101010138.chop2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_CUSTOM+101010138)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c101010138.sumcon)
	e3:SetTarget(c101010138.sumtg)
	e3:SetOperation(c101010138.sumop)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function c101010138.chop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function c101010138.chop2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_SPELL) or re:GetActivateLocation()~=LOCATION_SZONE then return end
	if re:GetHandler():GetSequence()>4 then return end
	e:GetLabelObject():SetLabelObject(re:GetHandler())
	e:GetLabelObject():SetLabel(1)
	local p=tp
	if re:GetHandler():GetControler()~=p then p=1-tp end
	Duel.RaiseSingleEvent(e:GetHandler(),101010138,re,r,rp,p,0)
end
function c101010138.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=0
end
function c101010138.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010138.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010138.filter,e:GetHandler():GetControler(),LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010138.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c101010138.filter,e:GetHandler():GetControler(),LOCATION_DECK,0,nil,e,tp):RandomSelect(tp,1)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end--[[
function c101010138.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101010138.thfilter(c)
	return c:IsSetCard(0x613) and not c:IsCode(101010138) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101010138.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010138.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010138.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010138.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
]]
