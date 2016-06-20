--
local id,ref=GIR()
function ref.start(c)
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,101010031,101010036,false,false)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(ref.spcon)
	e1:SetTarget(ref.sptg)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(ref.efilter)
	c:RegisterEffect(e4)
end
function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function ref.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	if Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) end
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fusg=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if fusg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fus=fusg:RandomSelect(tp,1):GetFirst()	
		if Duel.SpecialSummon(fus,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)~=0 and fus:GetTextAttack()==-2 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ref.atkval)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			fus:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENCE)
			fus:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			fus:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			fus:RegisterEffect(e4,true)
		end
		fus:CompleteProcedure()
	end
	Duel.BreakEffect()
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end
function ref.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x1093)*1000
end
function ref.efilter(e,re,rp)
	if re:GetHandler()==e:GetHandler() then return false end
	if not re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_FIELD+TYPE_COUNTER) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
