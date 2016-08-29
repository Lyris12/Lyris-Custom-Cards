--未来型融合－フューチャーリスチック・フュージョン
function c101010227.initial_effect(c)
c:SetUniqueOnField(1,0,101010227)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010227.target)
	e1:SetOperation(c101010227.activate)
	c:RegisterEffect(e1)
end
function c101010227.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c101010227.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,PLAYER_NONE,false,false)
		and c:CheckFusionMaterial(m)
end
function c101010227.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c101010227.filter1,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
		return Duel.IsExistingMatchingCard(c101010227.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	e:GetHandler():SetTurnCounter(0)
end
function c101010227.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c101010227.filter1,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
	local sg=Duel.GetMatchingGroup(c101010227.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local code=tc:GetCode()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg)
		local fg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,code)
		local tc=fg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=fg:GetNext()
		end
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY,5)
		e1:SetRange(LOCATION_SZONE)
		e1:SetOperation(c101010227.proc)
		e1:SetLabel(code)
		e1:SetLabelObject(e)
		c:RegisterEffect(e1)
	end
end
function c101010227.procfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c101010227.proc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		local code=e:GetLabel()
		local tc=Duel.GetFirstMatchingCard(c101010227.procfilter,tp,LOCATION_EXTRA,0,nil,code,e,tp)
		if not tc then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			tc:CompleteProcedure()
		else
			if Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
				tc:CompleteProcedure()
				c:SetCardTarget(tc)
				--destroy
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e4:SetCode(EVENT_CHAIN_SOLVED)
				e4:SetRange(0xff)
				e4:SetOperation(c101010227.desop)
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
