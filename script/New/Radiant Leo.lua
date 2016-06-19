--Radiant Leo
function c101010282.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c101010282.cost)
	e1:SetTarget(c101010282.target)
	e1:SetOperation(c101010282.operation)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(c101010282.btcon)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5e))
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c101010282.btcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic()
end
function c101010282.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c101010282.mfilter(c)
	return c:IsSetCard(0x5e) and not c:IsPublic() and not c:IsCode(101010282)
end
function c101010282.sfilter(c,tc,m)
	return c:IsSynchroSummonable(tc,m) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101010282.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010282.mfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101010282.filter(c)
	return c:GetFlagEffect(101010282)~=0
end
function c101010282.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=nil
	local g=Duel.GetMatchingGroup(c101010282.mfilter,tp,LOCATION_HAND,0,c)
	Duel.ConfirmCards(1-tp,g)
	tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(101010282,RESET_CHAIN,0,1)
		tc=g:GetNext()
	end
	local rg=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or rg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=rg:FilterSelect(tp,c101010282.filter,1,1,nil)
	tc=sg1:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_TUNER)
	tc:RegisterEffect(e1)
	Duel.BreakEffect()
	local mg=Group.FromCards(tc)
	mg:Merge(Duel.GetMatchingGroup(c101010282.mgfilter,tp,LOCATION_HAND,0,c))
	local g=Duel.GetMatchingGroup(c101010282.sfilter,tp,LOCATION_EXTRA,0,nil,tc,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),tc,mg)
	end
end
function c101010282.mgfilter(c)
	return c:IsPublic() or c:IsHasEffect(EFFECT_PUBLIC) and not c:IsCode(101010282)
end