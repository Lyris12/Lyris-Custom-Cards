--Crystapal Nadege the Aquamarine
function c101010137.initial_effect(c)
aux.EnablePendulumAttribute(c)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_DRAW)
	e3:SetTarget(c101010137.sptg)
	e3:SetOperation(c101010137.sumop)
	c:RegisterEffect(e3)
end
function c101010137.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c101010137.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c101010137.cfilter,1,nil,tp) end
	local g=eg:Filter(c101010137.cfilter,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010137.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010137.sumop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local p=e:GetHandler():GetControler()
	local sg=Duel.GetMatchingGroup(c101010137.filter,p,LOCATION_DECK,0,nil,e,tp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if mg:GetCount()>0 then
		local g=mg:Select(tp,1,ft1,nil)
		local sg1=sg:RandomSelect(tp,g:GetCount())
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
end
