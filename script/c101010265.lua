--created & coded by Lyris
--Crystapal Formator
function c101010265.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(c101010265.chop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+101010265)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(2,101010265)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetLabelObject(e1)
	e2:SetTarget(c101010265.sumtg)
	e2:SetOperation(c101010265.sumop)
	c:RegisterEffect(e2)
	--todeck
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCost(c101010265.thcost)
	e0:SetTarget(c101010265.thtg)
	e0:SetOperation(c101010265.thop)
	c:RegisterEffect(e0)
end
function c101010265.chop1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	e:SetLabelObject(re:GetHandler())
	local ap=re:GetHandlerPlayer()
	if Duel.GetFlagEffect(ap,101010265)==0 then
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+101010265,e,r,rp,ap,0)
		Duel.RegisterFlagEffect(ap,101010265,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101010265.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010265.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010265.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x1613)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	Duel.SpecialSummon(spcard,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101010265.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101010265.thfilter(c)
	return c:IsSetCard(0x1613) and c:IsAbleToDeck()
end
function c101010265.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010265.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010265.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101010265.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101010265.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
