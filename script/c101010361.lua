--created & coded by Lyris
--Victory Dragon Ariesen
function c101010361.initial_effect(c)
c:EnableReviveLimit()
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010361.aclimit)
	e1:SetCondition(c101010361.actcon)
	c:RegisterEffect(e1)
	--dispose
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckTiming(TIMING_BATTLE_START+TIMING_BATTLE_END) end)
	e2:SetCost(c101010361.cost)
	e2:SetTarget(c101010361.sptg)
	e2:SetOperation(c101010361.spop)
	c:RegisterEffect(e2)
	if not relay_check then
		relay_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010361.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010361.relay=true
c101010361.point=2
function c101010361.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function c101010361.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c101010361.actcon(e)
	local tc=Duel.GetAttacker()
	return tc and tc:IsSetCard(0x50b)
end
function c101010361.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
end
function c101010361.filter(c,e,tp)
	return c:IsSetCard(0x50b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010361.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010361.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101010361.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010361.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
