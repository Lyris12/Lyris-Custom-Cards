--created & coded by Lyris
--未来型融合フューチャーイスティカル・フュージョン
function c101010227.initial_effect(c)
	c:SetUniqueOnField(1,0,101010227)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101010227.reg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(c101010227.tgcon)
	e2:SetOperation(c101010227.tgop)
	c:RegisterEffect(e2)
end
function c101010227.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c101010227.filter2(c,m)
	return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(m) and not c:IsForbidden()
end
function c101010227.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c101010227.filter1,tp,LOCATION_DECK,0,nil,e)
		return Duel.IsExistingMatchingCard(c101010227.filter2,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(c101010227.ctop)
	Duel.RegisterEffect(e1,tp)
	c:CreateEffectRelation(e1)
	local mg=Duel.GetMatchingGroup(c101010227.filter1,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
	local sg=Duel.GetMatchingGroup(c101010227.filter2,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local code=tc:GetCode()
	e:SetLabel(code)
end
function c101010227.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		e:Reset()
		return
	end
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct>=5 then e:Reset() end
end
function c101010227.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnCounter()==3
end
function c101010227.procfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c101010227.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c101010227.filter1,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
	local tc=Duel.GetFirstMatchingCard(c101010227.procfilter,tp,LOCATION_EXTRA,0,nil,e:GetLabelObject():GetLabel(),e,tp)
	if tc then
		local code=tc:GetCode()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg)
		local fg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,code)
		local tc=fg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=fg:GetNext()
		end
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		local e3=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e3:SetCountLimit(1)
		e3:SetLabel(code)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY,2)
		e3:SetCondition(c101010227.proccon)
		e3:SetOperation(c101010227.procop)
		c:RegisterEffect(e3)
	end
end
function c101010227.proccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnCounter()==5 and e:GetHandler():GetFlagEffect(101010227)==0
end
function c101010227.procop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(101010227,RESET_EVENT+0x1fe0000,0,1)
	if not c:IsRelateToEffect(e) then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010227.procfilter,tp,LOCATION_EXTRA,0,1,1,nil,code,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		tc:CompleteProcedure()
	else
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
			tc:CompleteProcedure()
			c:SetCardTarget(tc)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetCode(EVENT_CHAIN_SOLVED)
			e4:SetRange(0xff)
			e4:SetOperation(c101010227.desop)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EVENT_ADJUST)
			e5:SetLabelObject(e4)
			e4:SetLabelObject(e5)
			tc:RegisterEffect(e5)
			Duel.SpecialSummonComplete()
		end
	end
end
function c101010227.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetOwner()
	if tc and not c:IsOnField() then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		e:GetLabelObject():Reset()
		e:Reset()
	end
	if tc and not tc:IsOnField() then
		Duel.Destroy(c,REASON_EFFECT)
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
