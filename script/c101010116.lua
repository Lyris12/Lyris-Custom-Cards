--シー・ストーム
function c101010116.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010116.target)
	e1:SetOperation(c101010116.activate)
	c:RegisterEffect(e1)
end
c101010116.sea_scout_list=true
function c101010116.spfilter(c,e,tp,rg)
	if c:GetLevel()<=6 or not c:IsSetCard(0x5cd) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	return rg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
end
function c101010116.rmfilter(c)
	return c:GetLevel()>0 and c:IsAbleToGrave()
end
function c101010116.cfilter(c,lv)
	return c:GetLevel()<lv and c:IsType(TYPE_TUNER) and c:IsAbleToGrave() and c:IsCanBeSynchroMaterial()
end
function c101010116.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rg=Duel.GetMatchingGroup(c101010116.rmfilter,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMaxGroup(Card.GetLevel)
		if not rg:IsExists(c101010116.cfilter,1,nil,g:GetFirst():GetLevel()) then return false end
		return Duel.IsExistingMatchingCard(c101010116.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,rg)
	end
	local rg=Duel.GetMatchingGroup(c101010116.rmfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMaxGroup(Card.GetLevel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tuc=rg:FilterSelect(tp,c101010116.cfilter,1,1,nil,g:GetFirst():GetLevel()):GetFirst()
	Duel.SetTargetCard(tuc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010116.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local tlv=tc:GetLevel()
	local rg=Duel.GetMatchingGroup(c101010116.rmfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_DECK,0,nil,7)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=sg:FilterSelect(tp,c101010116.spfilter,1,1,nil,e,tp,rg)
	if sc:GetCount()>0 and rg:CheckWithSumEqual(Card.GetLevel,sc:GetFirst():GetLevel(),1,99) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rm=rg:SelectWithSumEqual(tp,Card.GetLevel,sc:GetFirst():GetLevel(),1,99)
		if not rm:IsContains(tc) or not tc:IsCanBeSynchroMaterial() then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>-rm:GetCount() then
			if sc:GetFirst():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) then
				local e1=Effect.CreateEffect(sc:GetFirst())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_ADD_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_SYNCHRO)
				e1:SetReset(RESET_TODECK)
				sc:GetFirst():RegisterEffect(e1)
				sc:GetFirst():SetMaterial(rm)
				Duel.SendtoGrave(rm,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
				Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
				sc:GetFirst():CompleteProcedure()
			elseif sc:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) then
				Duel.SendtoGrave(rm,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.SendtoGrave(sc,REASON_EFFECT)
		end
	end
end
