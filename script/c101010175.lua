--海洋底拡大
function c101010175.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTarget(c101010175.target)
	e1:SetOperation(c101010175.operation)
	c:RegisterEffect(e1)
end
c101010175.sea_scout_list=true
function c101010175.filter(c,e,tp)
	return c:IsSetCard(0x5cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010175.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010175.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010175.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010175.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010175.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
		and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetBaseAttack()/2)
		e1:SetCondition(c101010175.rcon)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetBaseDefense()/2)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e3)
		--destroy
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_CHAIN_SOLVED)
		e4:SetRange(0xff)
		e4:SetOperation(c101010175.desop2)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EVENT_ADJUST)
		e5:SetLabelObject(e4)
		e4:SetLabelObject(e5)
		tc:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
	end
end
function c101010175.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c101010175.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetOwner()
	if tc and not c:IsOnField() then
		Duel.Destroy(tc,REASON_EFFECT)
		e:GetLabelObject():Reset()
		e:Reset()
	end
	if tc and not tc:IsOnField() then
		Duel.Destroy(c,REASON_EFFECT)
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
