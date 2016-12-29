--created & coded by Lyris
--純正誕生
function c101010415.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_CHAIN_END)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c101010415.chop)
	e1:SetTarget(c101010415.hsptg)
	e1:SetOperation(c101010415.hspop)
	c:RegisterEffect(e1)
end
function c101010415.filter(c,g)
	local rs=c:GetReasonEffect():GetHandler()
	return rs:IsCode(53129443) and (c:IsCode(44508094) or c:IsCode(24696097) or (c:IsSetCard(0x55) and g:GetCount()>=3))
end
function c101010415.chop(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101010415.filter,1,nil,eg)
end
function c101010415.spfilter(c,e,tp)
	return c:IsCode(35952884) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c101010415.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010415.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010415.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or (c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_DRAGON))
end
function c101010415.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c101010415.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local c=g:GetFirst()
	if c then
		local mg=eg:Filter(c101010415.mfilter,nil)
		if mg:GetCount()>0 then c:SetMaterial(mg) end
		Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end
