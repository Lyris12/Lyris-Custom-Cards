--Anti-Space Matter
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToRemove()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function ref.mgfilter(c,e,tp,fusc)
	return not c:IsLocation(LOCATION_REMOVED)
		or c:GetReasonCard()~=fusc-- or bit.band(c:GetReason(),0x7150)~=0x7150
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(tc)
	local c=tc:GetFirst()
	if not c then return end
	local mg=c:GetMaterial()
	local sumable=true
	local sumtype=c:GetSummonType()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 or bit.band(sumtype,SUMMON_TYPE_XYZ)~=SUMMON_TYPE_XYZ or mg:GetCount()==0
		or mg:GetCount()>Duel.GetLocationCount(tp,LOCATION_MZONE)
		or mg:IsExists(ref.mgfilter,1,nil,e,tp,c) then
		sumable=false
	end
	if sumable and Duel.SelectYesNo(tp,aux.Stringid(101010248,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
