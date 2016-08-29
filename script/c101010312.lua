--Rainbow-Eyes Amaranth Pulse
function c101010312.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101010312.cost)
	e1:SetTarget(c101010312.target)
	e1:SetOperation(c101010312.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101010312,ACTIVITY_SPSUMMON,c101010312.ctfilter)
end
function c101010312.ctfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsSetCard(0x1be)
end
function c101010312.cfilter(c,e,tp)
	return c:IsSetCard(0x1be) and c:GetFlagEffect(c:GetCode())==0 and (c:IsSetCard(0xb2d) or (c:IsRace(RACE_DRAGON) and c:GetAttack()==2500 and c:GetDefense()==2000))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ+0x7150,tp,true,false)
end
function c101010312.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010312.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetCustomActivityCount(101010312,tp,ACTIVITY_SPSUMMON)==0 end
	local g=Duel.SelectMatchingCard(tp,c101010312.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetFirst() then
		Duel.ConfirmCards(1-tp,g)
		e:SetLabelObject(g:GetFirst())
		else return false
	end
end
function c101010312.filter(c)
	return not c:IsSetCard(0) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost()
end
function c101010312.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010312.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010312.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c101010312.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetFirst():IsFacedown() then Duel.ConfirmCards(1-tp,g:GetFirst()) e:GetHandler()RegisterFlagEffect(101010312,RESET_CHAIN,0,1) end
end
function c101010312.activate(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local tc=Duel.GetFirstTarget()
	if tc:IsControler(1-tp) or not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_CHAIN)
	e1:SetValue(tc:GetLevel()*100*sc:GetRank())
	tc:RegisterEffect(e1)
	if tc:IsAbleToRemoveAsCost() and Duel.GetCustomActivityCount(101010312,tp,ACTIVITY_SPSUMMON)==0 and sc:GetFlagEffect(sc:GetCode())==0 then
		sc:SetMaterial(Group.FromCards(tc))
		if e:GetHandler():GetFlagEffect(101010312)==0 and tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
		Duel.Remove(tc,POS_FACEUP,REASON_MATERIAL+0x7150)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ+0x7150,tp,tp,true,false,POS_FACEUP)
		local e0=Effect.CreateEffect(sc)
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_TO_DECK)
		e0:SetOperation(c101010312.splimit)
		e0:SetReset(RESET_EVENT+EVENT_TO_DECK)
		sc:RegisterEffect(e0)
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetLabelObject(e)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c101010312.sumlimit)
	Duel.RegisterEffect(e0,tp)
end
function c101010312.splimit(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(c:GetOriginalCode(),RESET_PHASE+PHASE_END,0,2)
end
function c101010312.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se and c:IsSetCard(0x1be)--((not c:IsType(0x100a040) and c:GetEffectCount(EFFECT_CHANGE_RANK)>0) or sumtype==0x7150)
end
