--created & coded by Lyris
--Magma Fusion
function c101010298.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010298.target)
	e1:SetOperation(c101010298.activate)
	c:RegisterEffect(e1)
end
function c101010298.cnfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0xa88)
end
--If you control a "Flame Flight" Fusion Monster
function c101010298.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101010298.cnfilter,tp,LOCATION_MZONE,0,1,nil)
end
--Pay 1000 LP
function c101010298.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c101010298.filter0(c)
	if not c:IsCanBeFusionMaterial() then return false end
	--Deck, Hand, Field
	return (c:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE) and c:IsAbleToGrave())
		--banish
		or (c:IsLocation(LOCATION_REMOVED) and c:IsAbleToDeck())
		--Grave
		or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove())
end
function c101010298.filter1(c,e)
	if not c:IsCanBeFusionMaterial() or c:IsImmuneToEffect(e) then return false end
	--Deck, Hand, Field
	return (c:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE) and c:IsAbleToGrave())
		--banish
		or (c:IsLocation(LOCATION_REMOVED) and c:IsAbleToDeck())
		--Grave
		or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove())
end
function c101010298.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xa88) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c101010298.cfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c101010298.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c101010298.filter0,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_REMOVED,0,nil)
		if Duel.IsExistingMatchingCard(c101010298.cfilter,tp,0,LOCATION_MZONE,1,nil) then
			local sg=Duel.GetMatchingGroup(c101010298.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
			mg1:Merge(sg)
		end
		local res=Duel.IsExistingMatchingCard(c101010298.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c101010298.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010298.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c101010298.filter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_REMOVED,0,nil,e)
	if Duel.IsExistingMatchingCard(c101010298.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		local sg=Duel.GetMatchingGroup(c101010298.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e)
		mg1:Merge(sg)
	end
	local sg1=Duel.GetMatchingGroup(c101010298.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c101010298.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local matg=mat1:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE)
			local matr=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			local matd=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			if matg:GetCount()>0 then Duel.SendtoGrave(matg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
			if matr:GetCount()>0 then Duel.Remove(matr,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
			if matd:GetCount()>0 then Duel.SendtoDeck(matd,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(101010055)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	else
		local cg1=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_MZONE,0)
		local cg2=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		if cg1:GetCount()>1 and cg2:IsExists(Card.IsFacedown,1,nil)
			and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,27581098) then
			Duel.ConfirmCards(1-tp,cg1)
			Duel.ConfirmCards(1-tp,cg2)
			Duel.ShuffleHand(tp)
		end
	end
end
