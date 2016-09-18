--A HERO Rises
function c101010164.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010164)
	e1:SetTarget(c101010164.target)
	e1:SetOperation(c101010164.activate)
	c:RegisterEffect(e1)
end
function c101010164.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x9008) and (bit.band(c:GetType(),0x81)==0x81 or c:IsLocation(LOCATION_SZONE)) and (not c.mat_filter or c.mat_filter(mc))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		--and mc:IsCanBeRitualMaterial(c)
end
function c101010164.filter(c,e,tp)
	local sg=Duel.GetMatchingGroup(c101010164.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,c,e,tp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return sg:CheckWithSumEqual(c101010164.lvfilter,c:GetRank(),1,ft)
end
function c101010164.lvfilter(c)
	if c:IsLocation(LOCATION_HAND) then
		local lv=c:GetLevel()
		if lv>1 then lv=math.floor(lv/2) end
		return lv
	else return c:GetOriginalLevel() end
end
function c101010164.mfilter(c)
	return c:GetLevel()<=0 and c:IsAbleToRemove()
end
function c101010164.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		local mg=Duel.GetMatchingGroup(c101010164.mfilter,tp,LOCATION_EXTRA,0,nil)
		return mg:IsExists(c101010164.filter,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101010164.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local mg=Duel.GetMatchingGroup(c101010164.mfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,c101010164.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Duel.GetMatchingGroup(c101010164.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,mc,e,tp,mc)
	if sg:CheckWithSumEqual(c101010164.lvfilter,mc:GetRank(),1,ft) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectWithSumEqual(tp,c101010164.lvfilter,mc:GetRank(),1,ft)
		local tc=tg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=tg:GetNext()
		end
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		local fg=tg:Filter(c101010164.ffilter,nil)
		if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
		tc=tg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function c101010164.ffilter(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_SZONE)
end
