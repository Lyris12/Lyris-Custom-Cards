--
function c101020103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101020103.target)
	e1:SetOperation(c101020103.activate)
	c:RegisterEffect(e1)
end
function c101020103.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsLocation(LOCATION_GRAVE) and not c:IsImmuneToEffect(e)
end
function c101020103.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function c101020103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
	Duel.DiscardDeck(tp,5,REASON_COST)
	local g=Duel.GetOperatedGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
	local mg1=g:Filter(c101020103.filter1,nil,e)
	if mg1:GetCount()==0 then return false end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101020103.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local g=e:GetLabelObject()
	local mg1=g:Filter(c101020103.filter1,nil,e)
	g:DeleteGroup()
	local sg1=Duel.GetMatchingGroup(c101020103.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,chkf)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg1:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		tc:SetMaterial(mat1)
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
