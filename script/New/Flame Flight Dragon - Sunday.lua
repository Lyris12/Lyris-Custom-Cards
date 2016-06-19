--FFD－サンデー
function c101010561.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(aux.bdcon)
	e4:SetTarget(c101010561.drtg)
	e4:SetOperation(c101010561.drop)
	c:RegisterEffect(e4)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101010561.ffilter1,c101010561.ffilter2,true)
end
function c101010561.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or (c:IsHasEffect(101010560) and not c:IsLocation(LOCATION_DECK))
end
function c101010561.ffilter2(c)
	return c:IsRace(RACE_MACHINE+RACE_WINDBEAST) or (c:IsHasEffect(101010576) and not c:IsLocation(LOCATION_DECK))
end
function c101010561.filter(c,e,tp)
	return (c:IsRace(RACE_MACHINE) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010561.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c101010561.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010561.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT,LOCATION_REMOVED)
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c101010561.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if not c:IsHasEffect(101010552) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
