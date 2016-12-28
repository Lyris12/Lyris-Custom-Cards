--created & coded by Lyris
--SS神速のデェルフィノス
function c101010110.initial_effect(c)
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_SEND_REPLACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetTarget(c101010110.syntg)
	e0:SetValue(c101010110.synval)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010110,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101010110.sccon)
	e2:SetTarget(c101010110.sctarg)
	e2:SetOperation(c101010110.scop)
	c:RegisterEffect(e2)
end
function c101010110.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
	and Duel.GetCurrentPhase()~=PHASE_END and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c101010110.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c101010110.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010110.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
function c101010110.filter(c)
	return c:GetDestination()==LOCATION_GRAVE and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5cd) and c:IsAbleToHandAsCost()
end
function c101010110.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if chk==0 then return bit.band(r,REASON_SYNCHRO)~=0 and eg:IsContains(c) and eg:IsExists(c101010110.filter,1,c) end
	if not rc:IsAttribute(ATTRIBUTE_WATER) then
		Duel.Remove(c,POS_FACEUP,REASON_REDIRECT+REASON_MATERIAL+REASON_SYNCHRO)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(101010110,0)) then
		local g=eg:Filter(c101010110.filter,c)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(101010110,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(c101010110.thcon)
		e1:SetOperation(c101010110.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function c101010110.synval(e,c)
	return false
end
function c101010110.thfilter(c)
	return c:GetFlagEffect(101010110)~=0
end
function c101010110.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101010110.thfilter,1,nil)
end
function c101010110.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101010110.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
