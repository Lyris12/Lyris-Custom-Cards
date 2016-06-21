--Radiant Phantom
local id,ref=GIR()
function ref.start(c)
c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	--cannot effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(1)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(function(e) return Duel.IsExistingMatchingCard(ref.cfilter,e:GetHandler():GetControler(),LOCATION_HAND,0,2,nil,e) end)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,634000303))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--cannot negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e) return Duel.IsExistingMatchingCard(ref.radiant,tp,LOCATION_HAND,0,1,nil) end)
	e3:SetValue(function(e,te) return (bit.band(te:GetCode(),EFFECT_DISABLE+EFFECT_DISABLE_EFFECT+EFFECT_DISABLE_CHAIN)~=0 or te:IsHasCategory(CATEGORY_NEGATE+CATEGORY_DISABLE)) and te:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) end)
	c:RegisterEffect(e3)
	--tokens
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCountLimit(1,id)
	e4:SetLabel(0)
	e4:SetCost(ref.spcost)
	e4:SetTarget(ref.sptg)
	e4:SetOperation(ref.spop)
	c:RegisterEffect(e4)
end
function ref.radiant(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5e) and c:IsPublic()
end
function ref.cfilter(c,e)
	if e:GetLabel()==0 then return c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsPublic() end
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPublic()
end
function ref.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_HAND,0,2,nil,e) end
	local g=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_HAND,0,2,62,nil,e)
	local t=g:GetCount()
	while t/2-math.floor(t/2)==0.5 do g=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_HAND,0,2,62,nil,e) t=g:GetCount() end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
	Duel.AdjustInstantly()
	e:SetLabel(t)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,634000303,0x12c,0x5011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function ref.spfilter(c,e)
	return c:IsPublic() and c:GetFlagEffect(id)~=0
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(ref.radiant,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsDisabled() then Duel.NegateEffect(0) return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,634000303,0x12c,0x5011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	local ht=e:GetLabel()/2
	local cg=Group.CreateGroup()
	for i=1,ht do
		ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or cg:GetCount()>0 and not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then break end
		local token=Duel.CreateToken(tp,634000303)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			cg:AddCard(token)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_SELF_DESTROY)
			e1:SetCondition(ref.sdcon)
			token:RegisterEffect(e1)
		end
		ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
	end
	local ct=cg:GetCount()
	if ct==0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x4011,0,0,0,0,ATTRIBUTE_LIGHT) or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then Duel.SpecialSummonComplete() e:SetLabel(0) return end
	ref.light(e,tp,ct,Duel.GetLocationCount(tp,LOCATION_MZONE))
end
function ref.light(e,tp,ct,ft)
	Duel.BreakEffect()
	local lgtkn=Duel.CreateToken(tp,id)
	ft=ft-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_HAND,0,1,1,nil,e):GetFirst()
	local e1=Effect.CreateEffect(lgtkn)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(ref.chop)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e1,tp)
	local lg=Group.CreateGroup()
	local sg=Group.FromCards(lgtkn)
	for i=1,ct do
		lg:Merge(sg)
		if ft<=0 or ct==1 or (lg:GetCount()>0 and not Duel.SelectYesNo(tp,aux.Stringid(id,0))) then break end
		sg:AddCard(Duel.CreateToken(tp,id))
		ft=ft-1
	end
	if sg:GetCount()>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
	e:SetLabel(0)
end
function ref.dfilter(c)
	return c:IsSetCard(0x12c) and c:IsPublic()
end
function ref.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.dfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		return false
	else
		return true
	end
end
function ref.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=eg:GetFirst()
	while c do
		if c:IsCode(id) then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetCode(EFFECT_CHANGE_RACE)
			e0:SetValue(tc:GetRace())
			c:RegisterEffect(e0)
			local e1=e0:Clone()
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc:GetLevel())
			c:RegisterEffect(e1)
		end
		c=eg:GetNext()
	end
end