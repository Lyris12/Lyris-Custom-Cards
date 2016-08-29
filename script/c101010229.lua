--RDM－マック・フォース
function c101010229.initial_effect(c)
--cannot fetch
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_TO_HAND)
	e0:SetRange(LOCATION_DECK)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101010229.target)
	e1:SetOperation(c101010229.activate)
	c:RegisterEffect(e1)
end
function c101010229.filter1(c,e,tp)
	local rk=c:GetRank()
	local at=c:GetAttribute()
	return rk>1 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c101010229.filter2,tp,LOCATION_EXTRA,0,1,nil,rk,at,e,tp)
		and not Duel.IsExistingMatchingCard(c101010229.filter3,tp,LOCATION_MZONE,0,1,nil,rk)
end
function c101010229.filter2(c,rk,at,e,tp)
	return c:IsRankBelow(rk-1) and c:IsRace(RACE_MACHINE) and c:GetAttribute()~=at
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c101010229.filter3(c,rk)
	return c:IsFaceup() and c:GetRank()>rk
end
function c101010229.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010229.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c101010229.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101010229.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010229.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010229.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetRank(),tc:GetAttribute(),e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
