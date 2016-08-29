--Anti-Space Matter
function c101010174.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010174.target)
	e1:SetOperation(c101010174.activate)
	c:RegisterEffect(e1)
end
function c101010174.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) or c.spatial) and c:IsAbleToRemove()
end
function c101010174.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010174.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c101010174.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101010174.mgfilter(c,e,tp,fusc)
	return not c:IsLocation(LOCATION_REMOVED)
		or c:GetReasonCard()~=fusc or bit.band(c:GetReason(),0x71500000000+SUMMON_TYPE_XYZ)==0
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010174.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c101010174.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(tc)
	local c=tc:GetFirst()
	if not c then return end
	local mg=c:GetMaterial()
	local sumable=true
	local sumtype=c:GetSummonType()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 or bit.band(sumtype,SUMMON_TYPE_XYZ+0x7150)==0 or mg:GetCount()==0
		or mg:GetCount()>Duel.GetLocationCount(tp,LOCATION_MZONE)
		or mg:IsExists(c101010174.mgfilter,1,nil,e,tp,c) then
		sumable=false
	end
	if sumable and Duel.SelectYesNo(tp,aux.Stringid(101010174,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
