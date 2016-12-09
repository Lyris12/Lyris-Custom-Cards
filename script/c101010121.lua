--created & coded by Lyris
--Fate's Ritual
function c101010121.initial_effect(c)
	aux.AddRitualProcEqual2(c,c101010121.rfilter)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101010121.thtg)
	e2:SetOperation(c101010121.thop)
	c:RegisterEffect(e2)
end
function c101010121.rfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0xf7a)
end
function c101010121.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and c:IsAbleToHand()
end
function c101010121.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010121.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010121.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101010121.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101010121.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c101010121.sumlimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101010121.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
