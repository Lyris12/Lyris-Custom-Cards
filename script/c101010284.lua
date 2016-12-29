--created & coded by Lyris
--レイディアント・ファントム
function c101010284.initial_effect(c)
c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(function(e) return Duel.IsExistingMatchingCard(c101010284.filter,e:GetHandler():GetControler(),LOCATION_HAND,0,2,nil,e) end)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,634000303))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.IsExistingMatchingCard(c101010284.radiant,tp,LOCATION_HAND,0,1,nil) end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101010284)
	e4:SetCost(c101010284.spcost)
	e4:SetTarget(c101010284.sptg)
	e4:SetOperation(c101010284.spop)
	c:RegisterEffect(e4)
end
function c101010284.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPublic()
end
function c101010284.radiant(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5e) and c:IsPublic()
end
function c101010284.cfilter(c,e)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsPublic()
end
function c101010284.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010284.cfilter,tp,LOCATION_HAND,0,2,nil,e) end
	local g=Duel.SelectMatchingCard(tp,c101010284.cfilter,tp,LOCATION_HAND,0,2,62,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(101010284,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
	Duel.AdjustInstantly()
end
function c101010284.spfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPublic()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101010242,0,0x4011,0,0,c:GetLevel(),c:GetAttribute(),ATTRIBUTE_LIGHT)
end
function c101010284.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,634000303,0x12c,0x5011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c101010284.spfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101010284.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0
		or not Duel.IsExistingMatchingCard(c101010284.spfilter,tp,LOCATION_HAND,0,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c101010284.spfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	local lgtkn=Duel.CreateToken(tp,101010242,0,0,0,tc:GetLevel(),tc:GetRace())
	Duel.SpecialSummonStep(lgtkn,0,tp,tp,false,false,POS_FACEUP)
	ft=ft-1
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,634000303,0x12c,0x5011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,634000303)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_SELF_DESTROY)
			e1:SetCondition(c101010284.sdcon)
			token:RegisterEffect(e1)
		end
	end
	Duel.SpecialSummonComplete()
end
function c101010284.dfilter(c)
	return c:IsSetCard(0x12c) and c:IsPublic()
end
function c101010284.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010284.dfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		return false
	else
		return true
	end
end
