--トラップマジック融合
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
function ref.mfilter(c,e,tp)
	if c:IsImmuneToEffect(e) then return false end
	return (c:IsSetCard(0xa2) and c:IsCanBeFusionMaterial() and Duel.IsExistingMatchingCard(ref.spfiltert,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetCode(),0))
		or (c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,0,c:GetRace()))
		or (c:IsType(TYPE_TRAP) and Duel.IsExistingMatchingCard(ref.spfilterc,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode()))
end
function ref.spfiltert(c,e,tp,code)
	if not c.material or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then return false end
	for i,mcode in ipairs(c.material) do
		if code==mcode then return true end
	end
	return false
end
function ref.spfilterc(c,e,tp,code)
	return c:IsType(TYPE_FUSION) and c.material_trap and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) and code==c.material_trap
end
function ref.spfilterh(c,e,tp,race)
	return c:IsType(TYPE_FUSION) and c.material_race and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and race==c.material_race
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(ref.mfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectMatchingCard(tp,ref.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp,chkf)
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
		local sc=nil
		if tc:IsType(TYPE_TRAP) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,ref.spfilterc,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
			sc=sg:GetFirst()
		else
			local g1=Duel.GetMatchingGroup(ref.spfiltert,tp,LOCATION_EXTRA,0,nil,e,tp,tc:GetCode())
			local g2=Duel.GetMatchingGroup(ref.spfilterh,tp,LOCATION_EXTRA,0,nil,e,tp,tc:GetRace())
			local sg=nil
			if tc:IsSetCard(0xa2) then
				g1:Merge(g2)
				sg=g1:Select(tp,1,1,nil)
			else sg=g2:Select(tp,1,1,nil) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sc=sg:GetFirst()
		end
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
