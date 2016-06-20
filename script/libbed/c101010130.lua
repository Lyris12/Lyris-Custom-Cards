--Destined Ritual Art
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101010178)
	e1:SetCondition(ref.condition)
	e1:SetCost(ref.cost)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
function ref.tfilter(c,tp)
	return c:IsFacedown() and c:IsLocation(LOCATION_SZONE) and c:IsControler(tp)
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(ref.tfilter,1,nil,tp)
end
function ref.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,ref.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function ref.dfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x9008)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.dfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE)
end
function ref.mfilter(c)
	return c:GetOriginalLevel()>0 and c:IsAbleToGrave()-- and (c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_SZONE))
end
function ref.rfilter(c,e,tp,m)
	if not c:IsSetCard(0x9008) or bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	local lv=c:GetLevel()
	if c:IsLocation(LOCATION_SZONE) then lv=c:GetOriginalLevel() end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,lv,1,99,c)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local rg=Duel.SelectMatchingCard(tp,ref.dfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if rg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,rg)
		local rc=rg:GetFirst()
		local mg=Duel.GetRitualMaterial(tp)
		local lg=Duel.GetMatchingGroup(ref.mfilter,tp,LOCATION_SZONE,0,nil)
		mg:Merge(lg)
		mg:RemoveCard(rc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,ref.rfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,e,tp,mg)
		if tg:GetCount()>0 then
			local tc=tg:GetFirst()
			if tc:IsFacedown() and tc:IsOnField() then Duel.ConfirmCards(1-tp,tc) end
			mg:RemoveCard(tc)
			if tc.mat_filter then
			   mg=mg:Filter(tc.mat_filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
				Duel.ChangeTargetCard(ev,rg)
			end
		end
	end
end
