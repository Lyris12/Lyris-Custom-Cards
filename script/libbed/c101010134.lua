--ミーターモーフアイシス
local id,ref=GIR()
function ref.start(c)
local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetLabel(0)
	e0:SetTarget(ref.tg)
	e0:SetOperation(ref.op)
	c:RegisterEffect(e0)
end
function ref.filter1(c,e,tp)
	local stat=c:GetAttack()+c:GetDefence()
	return c:IsAbleToExtraAsCost() and c:GetBaseAttack()==c:GetBaseDefence() and c:GetDefence()<2000 and Duel.IsExistingMatchingCard(ref.filter2,tp,LOCATION_EXTRA,0,1,nil,stat,e,tp)
end
function ref.filter2(c,stat,e,tp)
	return c:GetAttack()<=stat and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(ref.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,ref.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local stat=rg:GetFirst():GetAttack()+rg:GetFirst():GetDefence()
	e:SetLabel(stat)
	Duel.SendtoDeck(rg,nil,0,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local stat=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.filter2,tp,LOCATION_EXTRA,0,1,1,nil,stat,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
