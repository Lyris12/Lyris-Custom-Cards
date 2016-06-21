--ライリス
local id,ref=GIR()
function ref.start(c)
--race/attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(0xffffff)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(0xff)
	c:RegisterEffect(e1)
	--inherit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetOperation(ref.immop)
	c:RegisterEffect(e2)
	--double tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e3:SetValue(aux.TRUE)
	c:RegisterEffect(e3)
	--ritual level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_RITUAL_LEVEL)
	e4:SetValue(ref.rlv)
	c:RegisterEffect(e4)
	--nontuner
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e5)
	--fuse
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,id)
	e6:SetCost(ref.cost)
	e6:SetTarget(ref.target)
	e6:SetOperation(ref.operation)
	c:RegisterEffect(e6)
end
function ref.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--race/attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_RACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(0xffffff)
	rc:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(0xff)
	rc:RegisterEffect(e2)
end
function ref.rlv(e,c)
	local lv=e:GetHandler():GetLevel()
	local clv=c:GetLevel()
	return lv*65536+clv
end
function ref.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetActivateEffect():IsHasCategory(CATEGORY_SPECIAL_SUMMON) and not c:IsPublic()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_HAND,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SetTargetCard(g)
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
end
function ref.filter(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function ref.spfilter(c,e,tp)
	local st=SUMMON_TYPE_FUSION
	if c:IsSetCard(0x102) then st=st+0x10 end
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,st,tp,true,true)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCanBeFusionMaterial,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.filter(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards(e:GetHandler(),Duel.GetFirstTarget()):Filter(Card.IsRelateToEffect,nil,e)
	local g1=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e)
	local g2=Duel.GetMatchingGroup(ref.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if Duel.SendtoGrave(g,REASON_EFFECT)==2 and g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mg=g1:Select(tp,1,63,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g2:Select(tp,1,1,nil):GetFirst()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc then
			sc:SetMaterial(mg)
			Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
			Duel.BreakEffect()
			local st=SUMMON_TYPE_FUSION
			if sc:IsSetCard(0x102) then st=st+0x10 end
			Duel.SpecialSummon(sc,st,tp,tp,true,true,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
