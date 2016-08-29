--Crystapal Dharc the Tourmaline
function c101010362.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(c101010362.spcon)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1)
	local e2=e0:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+101010362)
	e3:SetLabelObject(e1)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetTarget(c101010362.sumtg)
	e3:SetOperation(c101010362.sumop)
	c:RegisterEffect(e3)
end
function c101010362.cfilter(c)
	return not c:IsSetCard(0x1613)
end
function c101010362.spcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local tp1=false local tp2=false
	while tc do
		if c101010362.cfilter(tc) then
			if tc:GetSummonPlayer()==tp then tp1=true else tp2=true end
		end
		tc=eg:GetNext()
	end
	if tp1 and not tp2 then Duel.RaiseSingleEvent(c,101010362,e,r,rp,tp,0) end
	if tp2 and not tp1 then Duel.RaiseSingleEvent(c,101010362,e,r,rp,1-tp,0) end
end
function c101010362.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsAbleToHand()
end
function c101010362.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(c101010362.filter,p,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010362.sumop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetLabelObject():GetLabelObject():Filter(c101010362.cfilter,nil,tp)
	local p=e:GetHandler():GetControler()
	local sg=Duel.GetMatchingGroup(c101010362.filter,p,LOCATION_DECK,0,nil,e,tp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1>0 and mg:GetCount()>0 then
		local g=mg:FilterSelect(tp,Card.IsControler,1,ft1,nil,tp)
		local sg1=sg:RandomSelect(tp,g:GetCount())
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
end
